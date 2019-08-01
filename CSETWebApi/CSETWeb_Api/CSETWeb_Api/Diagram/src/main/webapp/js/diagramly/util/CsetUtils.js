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
* Finds any connectors that reach into a child component of a multi-service component.
* Reattaches the connector to the MSC itself.
*/
CsetUtils.fixMSCChildLinks = function (editor)
{
    var g = editor.graph;
    if (!g.model.root.children)
    {
        return;
    }

    var cells = g.model.root.children[0].children;
    if (!cells)
    {
        return;
    }

    var refreshNeeded = false;

    for (var i = 0; i < cells.length; i++)
    {
        var c = cells[i];
        if (!c.value && !!c.edge && c.edge == true)
        {
            if (!!c.source)
            {
                if (CsetUtils.isParentMSC(c.source))
                {
                    var p = c.source.getParent();
                    c.source = p;
                    refreshNeeded = true;
                }
            }

            if (!!c.target)
            {
                if (CsetUtils.isParentMSC(c.target))
                {
                    var p = c.target.getParent();
                    c.target = p;
                    refreshNeeded = true;
                }
            }
        }
    }

    if (refreshNeeded)
    {
        editor.graph.refresh();
    }
}

/**
 * 
 */
CsetUtils.isParentMSC = function (cell)
{
    var s = cell.getParent().getStyle();
    return (!!s && s.indexOf('msc=1') > 0);
}

/**
 * Persists the graph to the CSET API.
 */
CsetUtils.PersistGraphToCSET = function (editor)
{
    var jwt = localStorage.getItem('jwt');
    var enc = new mxCodec();
    var node = enc.encode(editor.graph.getModel());
    var oSerializer = new XMLSerializer();
    var sXML = oSerializer.serializeToString(node);

    var req = {};
    req.DiagramXml = sXML;
    req.LastUsedComponentNumber = sessionStorage.getItem("last.number");

    if (sXML == EditorUi.prototype.emptyDiagramXml)
    {
        // debugger;
    }

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
            window.location.replace('error401.html');
        }
    }
    xhr.open('POST', url);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('Authorization', jwt);
    xhr.send(JSON.stringify(req));
}


/**
 * 
 * 
 * @param {any} model
 * @param {any} cell
 * @param {any} attributeName
 * @param {any} attributeValue
 */
CsetUtils.applyAttributeToCell = function (model, cell, attributeName, attributeValue)
{
    try
    {
        var value = model.getValue(cell);
        // Converts the value to an XML node
        if (!mxUtils.isNode(value))
        {
            var doc = mxUtils.createXmlDocument();
            var obj = doc.createElement('object');

            obj.setAttribute('label', cell.getValue('label') || '');

            // set the new attribute value on the object
            obj.setAttribute(attributeName, attributeValue);
            value = obj;

        }

        // value = value.cloneNode(true);

        // Updates the value of the cell (undoable)
        model.setValue(cell, value);
    }
    catch (e)
    {
        console.log(e);
    }
}


/**
 * Returns the value for the specified style.  
 * Some style elements may not have a value.
 * This function should not be used to find those.
 * @param {any} styleString
 * @param {any} name
 */
CsetUtils.getStyleValue = function (styleString, name)
{
    if (!styleString)
    {
        return null;
    }

    var v = null;
    styleString.split(';').forEach((pair) =>
    {
        const s = pair.split('=', 2);
        if (s[0] === name)
        {
            if (!!s[1])
            {
                v = s[1];
            }
        }
    });
    return v;
}

/**
 * Returns a boolean indicating if the specified style exists,
 * regardless of its value.
 * @param {any} styleString
 * @param {any} name
 */
CsetUtils.hasStyle = function (styleString, name)
{
    var exists = false;
    styleString.split(';').forEach((style) =>
    {
        const s = style.split('=', 2);
        if (s[0] === name)
        {
            exists = true;
        }
    });
    return exists;
}
