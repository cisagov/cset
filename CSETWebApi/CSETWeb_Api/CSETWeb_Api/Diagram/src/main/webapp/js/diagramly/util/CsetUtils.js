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

function updateGraph(editor, data, finalize)
{
    let graph = Graph.zapGremlins(mxUtils.trim(data));
    graph = graph.replace(/\\"/g, '"').replace(/^\"|\"$/g, ''); // fix escaped quotes and trim quotes

    return new Promise(function (resolve, reject)
    {
        editor.graph.model.beginUpdate();
        try
        {
            editor.setGraphXml(mxUtils.parseXml(graph).documentElement);
            resolve();
        } catch (err)
        {
            console.warn('Failed to set graph xml:', err);
            reject(err);
        } finally
        {
            editor.graph.model.endUpdate();

            if (finalize)
            {
                finalize();
            }

            editor.graph.fit();
            if (editor.graph.view.scale > 1)
            {
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
CsetUtils.adjustConnectability = function (edit)
{
    for (var i = 0; i < edit.changes.length; i++)
    {
        if (edit.changes[i] instanceof mxChildChange)
        {
            var c = edit.changes[i].child;
            if (c.isEdge())
            {
                return;
            }

            // zones are not connectable
            if (c.isZone())
            {
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
CsetUtils.LoadGraphFromCSET = async function (editor, filename, app)
{
    await makeRequest({
        method: 'GET',
        url: localStorage.getItem('cset.host') + 'diagram/get',
        onreadystatechange: function (e)
        {
            if (e.readyState !== 4)
            {
                return;
            }

            switch (e.status)
            {
                case 200:
                    const resp = JSON.parse(e.responseText);
                    const assessmentName = resp.AssessmentName;

                    filename.innerHTML = assessmentName;
                    if (app.currentFile) {
                        app.currentFile.title = app.defaultFilename = `${assessmentName}.csetwd`;
                    }
                    sessionStorage.setItem('assessment.name', assessmentName);
                    sessionStorage.setItem("last.number", resp.LastUsedComponentNumber);

                    var data = resp.DiagramXml || EditorUi.prototype.emptyDiagramXml;
                    updateGraph(editor, data);
                    break
                case 401:
                    window.location.replace('http://localhost:4200');
                    break;
            }
        }
    });
}

/**
 * Make sure edges (links) are not hidden behind zones or other objects
 */
CsetUtils.edgesToTop = function (graph, edit)
{
    var model = graph.getModel();
    for (var i = 0; i < edit.changes.length; i++)
    {
        if (edit.changes[i] instanceof mxChildChange && model.isVertex(edit.changes[i].child))
        {
            var edges = CsetUtils.getAllChildEdges(edit.changes[i].child);
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

    // Analyze the diagram, if the user wants to
    if (editor.analyzeDiagram)
    {
        await CsetUtils.analyzeDiagram(analysisReq, editor);
    }


    // Save the diagram
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
                    window.location.replace('http://localhost:4200');
                    break;
            }
        }
    });

    if (response)
    {
        const warnings = JSON.parse(response);

        CsetUtils.addWarningsToDiagram(warnings, editor.graph);
    }
}


/**
 * Posts the diagram and supporting information to the API.
 * @param {any} req
 */
CsetUtils.saveDiagram = async function (req)
{
    const response = await makeRequest({
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
                    window.location.replace('http://localhost:4200');
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
                    window.location.replace('http://localhost:4200');
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
CsetUtils.handleZoneChanges = function (edit)
{
    edit.changes.forEach(change =>
    {
        if (change instanceof mxValueChange && change.cell.isZone())
        {
            var c = change.cell;

            // if they just changed the label, update the internal label
            if (change.value.attributes.label.value != change.previous.attributes.label.value)
            {
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
        var coords = CsetUtils.getCoords(w);
        var redDot = graph.insertVertex(root, null, w.Number, coords.X, coords.Y, 30, 30, 'redDot;shape=ellipse;fontColor=#ffffff;fillColor=#ff0000;strokeColor=#ff0000;connectable=0;recursiveResize=0;movable=0;editable=0;resizable=0;rotatable=0;cloneable=0;deletable=0;');
    });
}

/**
 * 
 */
CsetUtils.getCoords = function (warning)
{
    var coords = {};
    coords.X = 100;
    coords.Y = 100;
    return coords;
}