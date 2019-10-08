/**
 * 
 * NOTE:
 * This library will eventually be included in the minification.  
 * During development it is executed as native javascript.
 * When it is added to the minification build, remove the reference to this script from from index.html
 * 
 */


/**
 * A collection of CSET-specific utilities and functionality.
 */
CsetUtils = function ()
{
}

/**
 * Component properties we don't want to show in the tooltip or in the Ctrl+M dialog
 */
CsetUtils.ignoredProperties = ['ComponentGuid', 'internalLabel', 'HasUniqueQuestions', 'zone', 'parent'];

function updateGraph(editor, data, finalize) {
    let graph = Graph.zapGremlins(mxUtils.trim(data));
    graph = graph.replace(/\\"/g, '"').replace(/^\"|\"$/g, ''); // fix escaped quotes and trim quotes

    return new Promise(function (resolve, reject) {
        editor.graph.model.beginUpdate();
        try {
            const xml = mxUtils.parseXml(graph);
            editor.setGraphXml(xml.documentElement);
            resolve();
        } catch (err) {
            console.warn('Failed to set graph xml:', err);
            reject(err);
        } finally {
            editor.graph.model.endUpdate();

            if (finalize) {
                finalize();
            }

            editor.graph.fit();
            if (editor.graph.view.scale > 1) {
                editor.graph.zoomTo(1);
            }
        }
    });
}

function makeRequest(e)
{
    const jwt = localStorage.getItem('jwt');
    return new Promise(function (resolve, reject)
    {
        const xhr = new XMLHttpRequest();
        xhr.open(e.method, e.url);
        xhr.setRequestHeader('Authorization', jwt);
        xhr.setRequestHeader('Content-Type', e.contentType || 'application/json');
        if (e.overrideMimeType)
        {
            xhr.overrideMimeType(e.overrideMimeType);
        }

        if (e.onreadystatechange)
        {
            xhr.onreadystatechange = function ()
            {
                e.onreadystatechange({
                    readyState: this.readyState,
                    status: this.status,
                    responseText: this.responseText
                });
            };
        }
        xhr.onload = function ()
        {
            if (this.status >= 200 && this.status < 300)
            {
                resolve(xhr.response);
            } else
            {
                reject({
                    status: this.status,
                    statusText: xhr.statusText
                });
            }
        };
        xhr.onerror = function ()
        {
            reject({
                status: this.status,
                statusText: xhr.statusText
            });
        };

        switch (e.method)
        {
            case 'GET':
                xhr.send();
                break;
            case 'POST':
                xhr.send(e.payload);
                break;
        }
    });
}

CsetUtils.makeHttpRequest = makeRequest;

/**
 * If the edit is a cell being moved or added, makes it 'unconnectable'
 * if it is now the child of a multi-service component. 
 * @param {any} edit
 */
CsetUtils.adjustConnectability = function (edit) {
    const changes = edit && edit.changes || [];
    for (const change of changes) {
        if (change instanceof mxChildChange) {
            const c = change.child;
            if (c.isEdge()) {
                return;
            }

            // zones are not connectable
            if (c.isZone()) {
                c.setConnectable(false);
                return;
            }

            // children of an MSC are not connectable
            c.setConnectable(!c.isParentMSC());
        }
    }
}

/**
 * Retrieves the graph from the CSET API if it has been stored.
 */
CsetUtils.LoadGraphFromCSET = async function (editor, filename, app) {
    await makeRequest({
        method: 'GET',
        url: localStorage.getItem('cset.host') + 'diagram/get',
        onreadystatechange: function (e) {
            if (e.readyState !== 4) {
                return;
            }

            switch (e.status) {
                case 200:
                    const resp = JSON.parse(e.responseText);
                    const assessmentName = resp.AssessmentName;

                    filename.innerHTML = assessmentName;
                    if (app.currentFile) {
                        app.currentFile.title = app.defaultFilename = `${assessmentName}.csetwd`;
                    }
                    sessionStorage.setItem('assessment.name', assessmentName);
                    sessionStorage.setItem('last.number', resp.LastUsedComponentNumber);

                    var data = resp.DiagramXml || EditorUi.prototype.emptyDiagramXml;
                    updateGraph(editor, data);
                    CsetUtils.clearWarningsFromDiagram(editor.graph);
                    break;
                case 401:
                    window.location.replace(localStorage.getItem('cset.client'));
                    break;
            }
        }
    });
}

/**
 * Retrieves the graph from the CSET API if it has been stored.
 */
CsetUtils.LoadFileFromCSET = async function (app, filenameElmt) {
    let file = app.getCurrentFile();
    if (!file) {
        app.createFile(app.defaultFilename, null, null, App.MODE_CSET, null, null, null, false);
    }
    file = app.getCurrentFile();

    const data = await makeRequest({
        method: 'GET',
        url: localStorage.getItem('cset.host') + 'diagram/get',
        onreadystatechange: function (e) {
            if (e.readyState !== 4) {
                return;
            }

            switch (e.status) {
                case 200:
                    const resp = JSON.parse(e.responseText);
                    const assessmentName = resp.AssessmentName;

                    file.rename(`${assessmentName}.csetwd`, () => {
                        filenameElmt.innerHTML = assessmentName;
                        sessionStorage.setItem('assessment.name', assessmentName);
                        sessionStorage.setItem('last.number', resp.LastUsedComponentNumber);
                    });

                    const csetdata = resp.DiagramXml || EditorUi.prototype.emptyDiagramXml;
                    const filedata = file.getData();
                    console.log('setting file data: ', { csetdata, filedata });
                    if (filedata !== csetdata) {
                        file.setData(csetdata);
                        file.ui.setFileData(csetdata);
                    }
                    break;
                case 401:
                    window.location.replace(localStorage.getItem('cset.client'));
                    break;
            }
        }
    });
}

/**
 * Make sure edges (links) are not hidden behind zones or other objects
 */
CsetUtils.edgesToTop = function (graph, edit) {
    const model = graph.getModel();
    const changes = edit && edit.changes || [];
    for (const change of changes) {
        if (change instanceof mxChildChange && model.isVertex(change.child)) {
            const edges = CsetUtils.getAllChildEdges(change.child);
            graph.orderCells(false, edges);
        }
    }
}

/**
 * Persists the graph to the CSET API.
 */
CsetUtils.PersistGraphToCSET = async function (editor)
{
    const analysisReq = {
        DiagramXml: ''
    };

    const xmlserializer = new XMLSerializer();

    const model = editor.graph.getModel();
    if (model)
    {
        const enc = new mxCodec();
        const node = enc.encode(model);
        const sXML = xmlserializer.serializeToString(node);
        if (sXML !== EditorUi.prototype.emptyDiagramXml)
        {
            analysisReq.DiagramXml = sXML;
        }
    }

    CsetUtils.clearWarningsFromDiagram(editor.graph);

    await CsetUtils.analyzeDiagram(analysisReq, editor);

    const req = {
        DiagramXml: analysisReq.DiagramXml,
        LastUsedComponentNumber: sessionStorage.getItem("last.number")
    };

    const bg = '#ffffff';
    let svgRoot = editor.graph.getSvg(bg, 1, 0, true, null, true, true, null, null, false);
    svgRoot = xmlserializer.serializeToString(svgRoot);
    req.DiagramSvg = svgRoot;

    await CsetUtils.saveDiagram(req);
}


/**
 * Send the diagram to the API for analysis
 */
CsetUtils.analyzeDiagram = async function (req, editor)
{
    const response = await makeRequest({
        method: 'POST',
        overrideMimeType: 'application/json',
        url: localStorage.getItem('cset.host') + 'diagram/warnings',
        payload: JSON.stringify(req),
        onreadystatechange: function (e)
        {
            if (e.readyState !== 4)
            {
                return;
            }

            switch (e.status)
            {
                case 200:
                    // successful post            
                    break;
                case 401:
                    window.location.replace(localStorage.getItem('cset.client'));
                    break;
            }
        }
    });

    if (response)
    {
        if (editor.analyzeDiagram)
        {
            const warnings = JSON.parse(response);
            CsetUtils.addWarningsToDiagram(warnings, editor.graph);
        }
    }
}


/**
 * Posts the diagram and supporting information to the API.
 * @param {any} req
 */
CsetUtils.saveDiagram = async function (req)
{
    await makeRequest({
        method: 'POST',
        overrideMimeType: 'application/json',
        url: localStorage.getItem('cset.host') + 'diagram/save',
        payload: JSON.stringify(req),
        onreadystatechange: function (e)
        {
            if (e.readyState !== 4)
            {
                return;
            }

            switch (e.status)
            {
                case 200:
                    // successful post            
                    break;
                case 401:
                    window.location.replace(localStorage.getItem('cset.client'));
                    break;
            }
        }
    });
}


/**
 * Sends the file content to the CSET API for translation into an mxGraph diagram and drops it
 * into the existing diagram.
 */
CsetUtils.importFilesCSETD = function (files, editor)
{
    if (files.length == 0)
    {
        return;
    }

    var file = files[0];
    var reader = new FileReader();
    reader.onload = function (e)
    {
        TranslateToMxGraph(editor, e.target.result);
    };
    reader.readAsText(file);
}

/**
 * Persists the CSETD XML to the CSET API.  The mxGraph translation
 * is returned, and dropped into the existing graph.
 */
async function TranslateToMxGraph(editor, sXML)
{
    var req = {};
    req.DiagramXml = sXML;

    await makeRequest({
        method: 'POST',
        url: localStorage.getItem('cset.host') + 'diagram/importcsetd',
        payload: JSON.stringify(req),
        onreadystatechange: function (e)
        {
            if (e.readyState !== 4)
            {
                return;
            }

            switch (e.status)
            {
                case 200:
                case 204:
                    // successful post - drop the XML that came back into the graph
                    updateGraph(editor, e.responseText, function ()
                    {
                        CsetUtils.initializeZones(editor.graph)
                    });
                    break;
                case 401:
                    window.location.replace(localStorage.getItem('cset.client'));
                    break;
            }
        }
    });
}

/**
 * 
 */
CsetUtils.initializeZones = function (graph)
{
    var allCells = graph.getChildVertices(graph.getDefaultParent());
    allCells.forEach(x =>
    {
        x.setAttribute('internalLabel', x.getAttribute('label'));
        x.initZone();
    });
    graph.refresh();
}

/**
 * 
 */
CsetUtils.handleZoneChanges = function (edit) {
    const changes = edit && edit.changes || [];
    changes.forEach(change => {
        if (change instanceof mxValueChange && change.cell.isZone()) {
            const c = change.cell;

            // if they just changed the label, update the internal label
            if (change.value.attributes.label.value !== change.previous.attributes.label.value) {
                c.setAttribute('internalLabel', change.value.attributes.label.value);
            }

            c.initZone();
        }
    });
}

/**
 * Recursively finds all child edges for the parent.
 * 
 * @param {any} parent
 */
CsetUtils.getAllChildEdges = function (parent)
{
    var result = [];

    if (!!parent.edges)
    {
        parent.edges.forEach(e => result.push(e));
    }

    if (!!parent.children)
    {
        for (var i = 0; i < parent.children.length; i++)
        {
            getChildren(parent.children[i]);
        }
    }

    function getChildren(cell)
    {
        if (result.indexOf(cell) > -1)
        {
            return;
        }

        if (cell.isEdge())
        {
            result.push(cell);
        }

        if (!!cell.edges)
        {
            cell.edges.forEach(e => result.push(e));
        }

        if (!!cell.children)
        {
            for (var i = 0; i < cell.children.length; i++)
            {
                getChildren(cell.children[i]);
            }
        }
    }
    return result;
}

/**
 * 
 * 
 * @param {any} filename
 */
CsetUtils.findComponentInMap = function (filename)
{
    var m = Editor.componentSymbols;
    for (var i = 0; i < m.length; i++)
    {
        var group = m[i];
        for (var j = 0; j < group.Symbols.length; j++)
        {
            if (CsetUtils.getFilenameFromPath(filename) === group.Symbols[j].FileName)
            {
                return group.Symbols[j];
            }
        }
    };
}

/**
 * 
 */
CsetUtils.getFilenameFromPath = function (path)
{
    if (!path)
    {
        return '';
    }

    var s = path.lastIndexOf('/');
    if (s > 0)
    {
        if (path.length > (s + 1))
        {
            return path.substring(s + 1);
        }
        return '';
    }
    return path;
}

/**
 * 
 */
CsetUtils.clearWarningsFromDiagram = function (graph)
{
    var m = graph.getModel();
    var allCells = m.getDescendants();

    allCells.forEach(c =>
    {
        if (!!c.style && c.style.indexOf('redDot') >= 0)
        {
            m.remove(c);
        }
    });
}

/**
 * Create the red dots.  Maybe move this to its own class.
 */
CsetUtils.addWarningsToDiagram = function (warnings, graph)
{
    CsetUtils.clearWarningsFromDiagram(graph);

    var root = graph.getModel().root;

    warnings.forEach(w =>
    {
        var coords = CsetUtils.getCoords(w, graph);

        // don't overlay any other red dots on the same component
        if (CsetUtils.isRedDotAtCoords(graph, coords))
        {
            coords.x += 33;
        }

        var redDot = graph.insertVertex(root, null, w.Number, coords.x, coords.y, 30, 30, 'redDot;shape=ellipse;fontColor=#ffffff;fillColor=#ff0000;strokeColor=#ff0000;connectable=0;recursiveResize=0;movable=0;editable=0;resizable=0;rotatable=0;cloneable=0;deletable=0;');
        redDot.warningMsg = w.Message;
    });
}

/**
 * Determines where to place the red dot, based on the component or link it 
 * is describing.
 */
CsetUtils.getCoords = function (warning, graph)
{
    var coords = {
        x: 100,
        y: 100
    };

    // if only one node provided, then the dot goes on that component
    if (warning.NodeId1 && !warning.NodeId2)
    {
        const component = graph.getModel().getCell(warning.NodeId1);
        const g = component.getGeometry();
        coords.x = g.x;
        coords.y = g.y - 40;
        return coords;
    }

    // if both are provided, the dot goes on the edge
    if (warning.NodeId1 && warning.NodeId2)
    {
        const component1 = graph.getModel().getCell(warning.NodeId1);
        const component2 = graph.getModel().getCell(warning.NodeId2);
        const edges = graph.getModel().getEdgesBetween(component1, component2);
        const e = edges[0];

        const v = graph.view;
        const s1 = v.getState(component1);
        const s2 = v.getState(component2);

        // temporarily place the dot at the midpoint of a straight line between components.
        coords.x = (s1.origin.x + s2.origin.x) / 2;
        coords.y = (s1.origin.y + s2.origin.y) / 2;

        // then, try to place the dot so that it will be on the line no matter what.
        // CsetUtils.getTrueEdgeCoordinates(graph, e, coords);

        // fine-tune here if needed
        // coords.x = coords.x - 15;
        // coords.y = coords.y - 40;

        return coords;
    }

    return coords;
}


/**
 * Still experimenting with this.  The goal is to find the correct location for
 * the red dot on the edge, regardless of where the edge is routed.
 */
CsetUtils.getTrueEdgeCoordinates = function (graph, e, coords)
{
    const v = graph.view;
    const s = v.getState(e);


    const overlay = graph.setCellWarning(e, 'XYZ');
    var pt = s.view.getPoint(s, { x: 0, y: 0, relative: true });
    console.log(pt);
    // REMOVE THE OVERLAY AFTER WE HAVE THE COORDS - graph.removeCellOverlay(e);

    var xxx = graph.insertVertex(graph.getModel().root, null, 'X', null, null, 30, 30, 'redDot;shape=ellipse;fontColor=#ffffff;fillColor=#007700;strokeColor=#007700;connectable=0;recursiveResize=0;movable=0;editable=0;resizable=0;rotatable=0;cloneable=0;deletable=0;');
    var ptDot = graph.insertVertex(graph.getModel().root, null, 'PT', pt.x, pt.y, 10, 10, 'redDot;shape=ellipse;fontColor=#ffffff;fillColor=#0000ff;strokeColor=#0000ff;connectable=0;recursiveResize=0;movable=0;editable=0;resizable=0;rotatable=0;cloneable=0;deletable=0;');
    const refPoint = v.graphBounds.getPoint(1);
    console.log(refPoint);

    var refDot = graph.insertVertex(graph.getModel().root, null, 'R', refPoint.x, refPoint.y, 10, 10, 'redDot;shape=ellipse;fontColor=#ffffff;fillColor=#5500ff;strokeColor=#5500ff;connectable=0;recursiveResize=0;movable=0;editable=0;resizable=0;rotatable=0;cloneable=0;deletable=0;');

    console.log('state');
    console.log(s);  

    coords.x = pt.x - refPoint.x;
    coords.y = pt.y - refPoint.y;
}


/**
 * Returns a boolean indicating if a red dot is positioned at the specified coordinates.
 */
CsetUtils.isRedDotAtCoords = function (graph, coords)
{
    var found = false;

    graph.getModel().getDescendants().forEach(c =>
    {
        if (c instanceof mxCell && c.isRedDot())
        {
            if (c.getGeometry().x == coords.x && c.getGeometry().y == coords.y)
            {
                found = true;
            }
        }
    });

    return found;
}

/**
 * 
 */
CsetUtils.getCsetTemplates = async function () {
    let templates;
    await makeRequest({
        method: 'GET',
        url: localStorage.getItem('cset.host') + 'diagram/templates',
        onreadystatechange: function (e) {
            if (e.readyState !== 4) {
                return;
            }

            switch (e.status) {
                case 200:
                    templates = JSON.parse(e.responseText);
                    break;
                case 401:
                    window.location.replace('http://localhost:4200');
                    break;
            }
        }
    });
    return templates;
}
