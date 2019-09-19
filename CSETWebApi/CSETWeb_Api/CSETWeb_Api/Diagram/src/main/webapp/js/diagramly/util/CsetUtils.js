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
            if (c.isParentMSC())
            {
                c.setConnectable(false);
            }
            else
            {
                c.setConnectable(true);
            }
        }
    }
}


/**
 * Persists the graph to the CSET API.
 */
CsetUtils.PersistGraphToCSET = function (editor)
{
    var enc = new mxCodec();
    var model = editor.graph.getModel();
    var node = enc.encode(editor.graph.getModel());
    var oSerializer = new XMLSerializer();
    var sXML = oSerializer.serializeToString(node);

    var selectionEmpty = editor.graph.isSelectionEmpty();
    var ignoreSelection = selectionEmpty;
    var bg = '#ffffff';
    var req = {};

    if(model){    
        var node = enc.encode(model);
        var oSerializer = new XMLSerializer();
        var sXML = oSerializer.serializeToString(node);
    
        req.DiagramXml = sXML;
        req.LastUsedComponentNumber = sessionStorage.getItem("last.number");
    }

    if (sXML == EditorUi.prototype.emptyDiagramXml)
    {
        // debugger;
        req.DiagramXml = "";
        req.LastUsedComponentNumber = 1;
    }

    // include the SVG in the save request
    var bg = '#ffffff';

    var svgRoot = editor.graph.getSvg(bg, 1, 0, true, null, true, true, null, null, false);
    svgRoot = new XMLSerializer().serializeToString(svgRoot);

    req.DiagramSvg = svgRoot;
    CsetUtils.saveDiagram(req);
}


/**
 * Posts the diagram and supporting information to the API.
 * @param {any} req
 */
CsetUtils.saveDiagram = function (req)
{
    var jwt = localStorage.getItem('jwt');
    var url = localStorage.getItem('cset.host') + 'diagram/save';
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function ()
    {
        if (this.readyState == 4 && this.status == 200)
        {
            // successful post            
        }
        if (this.readyState == 4 && this.status == 401)
        {
            window.location.replace('http://localhost:4200');
        }
    }
    xhr.open('POST', url);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('Authorization', jwt);
    xhr.overrideMimeType("application/json");
    xhr.onload  = function() {        
        if(req.responseText){    
            var warnings = JSON.parse(req.responseText);
            var analysis = new CsetAnalysisWarnings();
            analysis.addWarningsToDiagram(warnings, editor.graph);
        }
     };
    xhr.send(JSON.stringify(req));
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
function TranslateToMxGraph(editor, sXML)
{
    var jwt = localStorage.getItem('jwt');

    var req = {};
    req.DiagramXml = sXML;

    var url = localStorage.getItem('cset.host') + 'diagram/importcsetd';
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function ()
    {
        if (this.readyState == 4 && (this.status == 200 || this.status == 204))
        {
            // successful post - drop the XML that came back into the graph
            var data = xhr.responseText;
            data = Graph.zapGremlins(mxUtils.trim(data));

            // fix escaped quotes and trim quotes
            data = data.replace(/\\"/g, '"').replace(/^\"|\"$/g, '');

            editor.graph.model.beginUpdate();
            try
            {
                editor.setGraphXml(mxUtils.parseXml(data).documentElement);
            }
            catch (e)
            {
                error = e;
                console.log('TranslateToMxGraph error: ' + error);
            }
            finally
            {
                editor.graph.model.endUpdate();
                CsetUtils.initializeZones(editor.graph);

                editor.graph.fit();
                if (editor.graph.view.scale > 1)
                {
                    editor.graph.zoomTo(1);
                }
            }
        }
        if (this.readyState == 4 && this.status == 401)
        {
            window.location.replace('http://localhost:4200');
        }
    }
    xhr.open('POST', url);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('Authorization', jwt);
    xhr.send(JSON.stringify(req));
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

