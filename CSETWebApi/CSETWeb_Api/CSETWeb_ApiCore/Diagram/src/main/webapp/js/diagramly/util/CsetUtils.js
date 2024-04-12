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
CsetUtils = function () {

}

/**
 * Prevent async requests from occurring out of order
 * @param {any} max
 */
function Semaphore(max) {
    var counter = 0;
    var waiting = [];

    var take = function () {
        if (waiting.length > 0 && counter < max) {
            counter++;
            let promise = waiting.shift();
            promise.resolve();
        }
    }

    this.acquire = function () {
        if (counter < max) {
            counter++
            return new Promise(resolve => {
                resolve();
            });
        } else {
            return new Promise((resolve, err) => {
                waiting.push({ resolve: resolve, err: err });
            });
        }
    }

    this.release = function () {
        counter--;
        take();
    }

    this.purgeAllButLast = function () {
        if (waiting.length < 1)
            return;
        let unresolved = waiting.length - 1;

        for (let i = 0; i < unresolved; i++) {
            waiting[i].err('Task has been purged.');
        }
        var last = waiting.pop();
        waiting = [];
        waiting.push(last);
        counter = waiting.length;
    }
}

let myTestSema = new Semaphore(1);
/**
 * Component properties we don't want to show in the tooltip or in the Ctrl+M dialog
 */
CsetUtils.ignoredProperties = ['ComponentGuid', 'internalLabel', 'HasUniqueQuestions', 'zone', 'parent', 'questionid'];

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

function makeRequest(e) {

    const jwt = localStorage.getItem('jwt');
    return new Promise(function (resolve, reject) {
        const xhr = new XMLHttpRequest();
        xhr.open(e.method, e.url);
        xhr.setRequestHeader('Authorization', jwt);
        xhr.setRequestHeader('Content-Type', e.contentType || 'application/json');
        if (e.overrideMimeType) {
            xhr.overrideMimeType(e.overrideMimeType);
        }

        if (e.onreadystatechange) {
            xhr.onreadystatechange = function () {
                e.onreadystatechange({
                    readyState: this.readyState,
                    status: this.status,
                    responseText: this.responseText
                });
            };
        }
        xhr.onload = function () {
            if (this.status >= 200 && this.status < 300) {
                resolve(xhr.response);
            } else {
                reject({
                    status: this.status,
                    statusText: xhr.statusText
                });
            }
        };
        xhr.onerror = function () {
            reject({
                status: this.status,
                statusText: xhr.statusText
            });
        };

        switch (e.method) {
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
CsetUtils.LoadFileFromCSET = async function (app) {
    let file = app.getCurrentFile();
    if (!file) {
        app.createFile(app.defaultFilename, null, null, App.MODE_CSET, null, null, null, null);
    }
    file = app.getCurrentFile();
    const resp = await makeRequest({
        method: 'GET',
        url: localStorage.getItem('cset.host') + 'diagram/get',
        onreadystatechange: function (e) {
            if (e.readyState !== 4) {
                return;
            }
            switch (e.status) {
                case 200:
                    break;
                case 401:
                    window.location.replace(localStorage.getItem('cset.client'));
                    break;
            }
        }
    });

    const data = JSON.parse(resp);
    const assessmentName = data.assessmentName;


    file.rename(`${assessmentName}.csetwd`, () => {
        const filenameelmt = app.fname;
        filenameelmt.innerHTML = assessmentName;
        sessionStorage.setItem('assessment.name', assessmentName);
        sessionStorage.setItem('last.number', data.lastUsedComponentNumber);
    });

    const csetdata = data.diagramXml || EditorUi.prototype.emptyDiagramXml;
    file.setFileData(csetdata);


    // set analysis toggle state
    if (data.analyzeDiagram || false) {
        for (var element of app.toolbar.container.childNodes) {
            if (element.title == 'Analyze') {
                element.click();
                break;
            }
        }
    }

    return file;
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
        if (change instanceof mxTerminalChange) {
            graph.orderCells(false, [change.cell]);
        }
    }
}

/**
 * Persists the graph to the CSET API.
 */
CsetUtils.PersistGraphToCSET = async function (editor) {
    const analysisReq = {
        DiagramXml: '',
        AnalyzeDiagram: editor.analyzeDiagram
    };

    const xmlserializer = new XMLSerializer();

    const model = editor.graph.getModel();
    if (model) {
        const enc = new mxCodec();
        const node = enc.encode(model);
        const sXML = xmlserializer.serializeToString(node);

        if (sXML !== EditorUi.prototype.emptyDiagramXml) {
            analysisReq.DiagramXml = testForBase64(sXML);
        }
    }

    CsetUtils.clearWarningsFromDiagram(editor.graph);
    // below is commented because the analyzer was running twice and crashing in the backend
    await CsetUtils.analyzeDiagram(analysisReq, editor);
    await CsetUtils.PersistDataToCSET(editor, analysisReq.DiagramXml);
}

/**
 * 
 */
CsetUtils.PersistDataToCSET = async function (editor, xml, revision) {
    const req = {
        diagramXml: testForBase64(xml),
        lastUsedComponentNumber: sessionStorage.getItem("last.number"),
        revision: revision
    };


    const bg = '#ffffff';
    const xmlserializer = new XMLSerializer();
    let svgRoot = editor.graph.getSvg(bg, 1, 0, true, null, true, true, null, null, false);
    svgRoot = xmlserializer.serializeToString(svgRoot);
    req.diagramSvg = testForBase64(svgRoot);

    //may need to add this in to the save
    //editor.menubarContainer;
    await CsetUtils.saveDiagram(req);
}

function testForBase64(strValue) {
    var base64regex = /^([0-9a-zA-Z+/]{4})*(([0-9a-zA-Z+/]{2}==)|([0-9a-zA-Z+/]{3}=))?$/;
    if (!base64regex.test(strValue)) {
        //return btoa(strValue);
        return Base64.encode(strValue);
    }
    return strValue;
}

/**
 * Send the diagram to the API for analysis
 */
CsetUtils.analyzeDiagram = async function (req, editor) {
    try {
        req.AnalyzeDiagram = true;
        const response = await makeRequest({
            method: 'POST',
            overrideMimeType: 'application/json',
            url: localStorage.getItem('cset.host') + 'diagram/analysis',
            payload: JSON.stringify(req),
            onreadystatechange: function (e) {
                if (e.readyState !== 4) {
                    return;
                }

                switch (e.status) {
                    case 200:
                        // successful post            
                        break;
                    case 401:
                        window.location.replace(localStorage.getItem('cset.client'));
                        break;
                }
            }
        });
        if (response) {
            if (editor.analyzeDiagram) {
                const warnings = JSON.parse(response);
                CsetUtils.addWarningsToDiagram(warnings, editor.graph);
            }
        }
    } catch (e) {
        console.log(e);
    }
}

/**
 * Posts the diagram and supporting information to the API.
 * @param {any} req
 */
CsetUtils.saveDiagram = async function (req) {
    try {
        await myTestSema.acquire();
        // create a new div element 
        var newDiv = document.createElement("div");
        // and give it some content 
        var newContent = document.createTextNode("Saving");
        // add the text node to the newly created div
        newDiv.appendChild(newContent);
        document.body.appendChild(newDiv);
        newDiv.id = "CSETSaving";
        newDiv.style.position = 'absolute';
        newDiv.style.top = '0';
        newDiv.style.right = '0';
        newDiv.style.padding = '5px';
        newDiv.style.color = 'green';

        await makeRequest({
            method: 'POST',
            overrideMimeType: 'application/json',
            url: localStorage.getItem('cset.host') + 'diagram/save',
            payload: JSON.stringify(req),
            onreadystatechange: function (e) {
                if (e.readyState !== 4) {
                    return;
                }
                switch (e.status) {
                    case 200:
                        // successful post            
                        break;
                    case 401:
                        window.location.replace(localStorage.getItem('cset.client'));
                        break;
                }
            }
        });
    } catch (error) {
        //console.log(error);
    } finally {
        myTestSema.release();
        myTestSema.purgeAllButLast();
        hideSaving();
    }
}
CsetUtils.hideSaving = function () {
    var div = document.body;
    var img = document.getElementById('CSETSaving');
    div.removeChild(img);
}


/**
 * Sends the file content to the CSET API for translation into an mxGraph diagram and drops it
 * into the existing diagram.
 */
CsetUtils.importFilesCSETD = function (files, editor) {
    if (files.length == 0) {
        return;
    }

    var file = files[0];
    var reader = new FileReader();
    reader.onload = function (e) {
        TranslateToMxGraph(editor, e.target.result);
    };
    reader.readAsText(file);
}

/**
 * Persists the CSETD XML to the CSET API.  The mxGraph translation
 * is returned, and dropped into the existing graph.
 */
async function TranslateToMxGraph(editor, sXML) {
    var req = {};
    req.DiagramXml = testForBase64(sXML);

    await makeRequest({
        method: 'POST',
        url: localStorage.getItem('cset.host') + 'diagram/importcsetd',
        payload: JSON.stringify(req),
        onreadystatechange: function (e) {
            if (e.readyState !== 4) {
                return;
            }

            switch (e.status) {
                case 200:
                case 204:
                    // successful post - drop the XML that came back into the graph
                    updateGraph(editor, e.responseText, function () {
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
CsetUtils.initializeZones = function (graph) {
    var allCells = graph.getChildVertices(graph.getDefaultParent());
    allCells.forEach(x => {
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
CsetUtils.getAllChildEdges = function (parent) {
    var result = [];

    if (!!parent.edges) {
        parent.edges.forEach(e => result.push(e));
    }

    if (!!parent.children) {
        for (var i = 0; i < parent.children.length; i++) {
            getChildren(parent.children[i]);
        }
    }

    function getChildren(cell) {
        if (result.indexOf(cell) > -1) {
            return;
        }

        if (cell.isEdge()) {
            result.push(cell);
        }

        if (!!cell.edges) {
            cell.edges.forEach(e => result.push(e));
        }

        if (!!cell.children) {
            for (var i = 0; i < cell.children.length; i++) {
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
CsetUtils.findComponentInMap = function (filename) {
    var m = Editor.componentSymbols;
    for (var i = 0; i < m.length; i++) {
        var group = m[i];
        for (var j = 0; j < group.symbols.length; j++) {
            if (CsetUtils.getFilenameFromPath(filename) === group.symbols[j].fileName) {
                return group.symbols[j];
            }
        }
    };
}

/**
 * 
 */
CsetUtils.getFilenameFromPath = function (path) {
    if (!path) {
        return '';
    }

    var s = path.lastIndexOf('/');
    if (s > 0) {
        if (path.length > (s + 1)) {
            return path.substring(s + 1);
        }
        return '';
    }
    return path;
}

/**
 * 
 */
CsetUtils.clearWarningsFromDiagram = function (graph) {
    var m = graph.getModel();
    var allCells = m.getDescendants();

    allCells.forEach(c => {
        graph.removeCellOverlay(c);
    });
}

/**
 * Create the red dots.  Maybe move this to its own class.
 */
CsetUtils.addWarningsToDiagram = function (warnings, graph) {
    CsetUtils.clearWarningsFromDiagram(graph);

    warnings.forEach(w => {

        var taggedCell = CsetUtils.getTaggedCell(w, graph);

        var dot = "data:image/svg+xml;utf8,"
            + "<svg xmlns='http://www.w3.org/2000/svg' width='10' height='10'>"
            + "<circle fill='rgb(255,0,0)' cx='5' cy='5' r='5' />"
            + "<text x='50%' y='50%' dy='25%' text-anchor='middle' fill='rgb(255,255,255)' style='font-family: arial; font-size: 40%;'>" + w.number + "</text>"
            + "</svg>";


        var maxX = 0;
        var y = -3;

        const overlay = new mxCellOverlay(new mxImage(dot, 30, 30), "<div style='max-width: 300px'>" + w.message + "</div>");
        if (taggedCell.isVertex()) {
            overlay.align = mxConstants.ALIGN_LEFT;
            overlay.verticalAlign = mxConstants.ALIGN_TOP;
            overlay.defaultOverlap = 1;
        }

        if (taggedCell.isEdge()) {
            maxX = -32;
            y = 0;
        }

        // determine the offset for the overlay
        const overlays = graph.getCellOverlays(taggedCell);
        if (!!overlays) {
            overlays.forEach(o => {
                maxX = o.offset.x;
            });
        }
        overlay.offset = new mxPoint((maxX + 32), y);

        graph.addCellOverlay(taggedCell, overlay);
    });
}

/**
 * Returns the cell that the warning belongs to, whether component (vertex) or link (edge).
 */
CsetUtils.getTaggedCell = function (warning, graph) {
    // if only one node provided, then the dot goes on that component
    if (warning.nodeId1 && !warning.nodeId2 && !warning.edgeId) {
        return graph.getModel().getCell(warning.nodeId1);
    }

    // if two components are provided, look for any edges that connect them directly
    if (warning.nodeId1 && warning.nodeId2) {
        const component1 = graph.getModel().getCell(warning.nodeId1);
        const component2 = graph.getModel().getCell(warning.nodeId2);
        const edges = graph.getModel().getEdgesBetween(component1, component2);
        if (edges.length > 0) {
            return edges[0];
        }
    }

    // if an edgeId is provided, the dot goes on the edge
    if (!!warning.edgeId) {
        return graph.getModel().getCell(warning.edgeId);
    }
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

async function showSaving(requestId) {
    // create a new div element 
    var newDiv = document.createElement("div");
    // and give it some content 
    var newContent = document.createTextNode("Saving");
    // add the text node to the newly created div
    newDiv.appendChild(newContent);

    var tmppayload = JSON.stringify(requestId);
    document.body.appendChild(newDiv);
    newDiv.id = "CSETSaving";
    newDiv.style.position = 'absolute';
    newDiv.style.top = '0';
    newDiv.style.right = '0';
    newDiv.style.padding = '5px';
    newDiv.style.color = 'green';
    const resp = await makeRequest({
        method: 'POST',
        url: localStorage.getItem('cset.host') + 'diagram/testqueue',
        payload: tmppayload,
        onreadystatechange: function (e) {
            if (e.readyState !== 4) {
                return;
            }

            hideSaving();
            myTestSema.release();
            myTestSema.purgeAllButLast();
            switch (e.status) {
                case 200:
                    break;
                case 401:
                    window.location.replace(localStorage.getItem('cset.client'));
                    break;
            }
        }
    });
}

function hideSaving() {
    var div = document.body;
    var img = document.getElementById('CSETSaving');
    div.removeChild(img);
}

