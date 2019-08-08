// -------------- mxCell extension functions ------------------------

/**
 * Providing a nice function to set a single style element in a cell.
 * @param {any} name
 * @param {any} value
 */
mxCell.prototype.setStyleValue = function (name, value)
{
    this.setStyle(CsetUtils.setStyleValue(this.getStyle(), name, value));
}


/**
 * Returns the value of the attribute on the wrapper object (NOT THE STYLE).
 */
mxCell.prototype.getCsetAttribute = function (name)
{
    if (typeof this.value != "object")
    {
        return null;
    }

    var obj = this.value;

    return obj.getAttribute(name);
}


/**
 * Sets an attribute on a cell.  Creates a wrapper object for the cell if needed.
 */
mxCell.prototype.setCsetAttribute = function (attributeName, attributeValue)
{
    var obj = null;

    if (typeof this.value == "object")
    {
        obj = this.value;
    }
    else
    {
        // The cell is just an mxCell.  Wrap it in an object and set the attribute on the wrapper.
        try
        {
            var doc = mxUtils.createXmlDocument();
            obj = doc.createElement('object');
            this.value = obj;
        }
        catch (e)
        {
            console.log(e);
        }
    }

    obj.setAttribute(attributeName, attributeValue);

    // set an internal label as well.  Something to concatenate with the SAL for the display label.
    if (attributeName === 'label')
    {
        obj.setAttribute('internalLabel', attributeValue || '');
    }
}


/**
 * Recursively looks up through parentage to see if the cell's
 * parent is ultimately the top of the graph (as opposed to the sidebar).
 * @param {any} cell
 */
mxCell.prototype.isTopParentGraph = function ()
{
    if (!this.hasOwnProperty('parent'))
    {
        return false;
    }

    // if I have a null parent but I have an ID, then I am the top node of the graph
    if (this.parent == null && this.hasOwnProperty('id'))
    {
        return true;
    }

    return this.getParent().isTopParentGraph();
}


/**
 * Returns a boolean indicating if the cell's immediate parent is a 
 * multi-service component.
 */
mxCell.prototype.isParentMSC = function ()
{
    var parent = this.getParent();
    if (!parent) { return false; }

    var s = parent.getStyle();
    return (!!s && s.indexOf('msc=1') > 0);
}


/**
 * Returns a boolean indicating if the cell is a connector.
 */
mxCell.prototype.isConnector = function ()
{
    var isconnector = (!this.value && !!this.edge && this.edge == true);
    return isconnector;
}


/**
 * Returns a boolean indicating if the cell is a Zone.
 */
mxCell.prototype.isZone = function ()
{
    var z = this.getCsetAttribute('zone');

    if (!z)
    {
        if (this.getStyleValue('swimlane') == '1')
        {
            this.setCsetAttribute('zone', '1');
            z = true;
        }
    }

    return (!!z);
}


/**
 * 
 */
mxCell.prototype.initZone = function ()
{
    if (!this.isZone())
    {
        return;
    }

    this.colorZone();

    this.setConnectable(false);

    // set the zone's label (for display) based on its SAL
    if (!this.value.hasAttribute('SAL'))
    {
        this.value.setAttribute('SAL', 'Low');
    }
    var sal = this.value.attributes['SAL'].value;
    this.setAttribute('label', this.getAttribute('internalLabel') + '-' + sal);
}

/**
 * Changes the color of the zone
 */
mxCell.prototype.colorZone = function ()
{
    if (!this.isZone())
    {
        return;
    }
    var color = '#4b5e00';

    var zoneType = (this.getCsetAttribute('zoneType') || '').toLowerCase();
    switch (zoneType)
    {
        case 'control dmz':
            color = '#6ce48d';
            break;
        case 'corporate':
            color = '#dcafae';
        case 'other':
            break;
            color = '#4b5e00';
            break;
        case 'safety':
            color = '#db7e94';
            break;
        case 'externaldmz':
            color = '#933705';
            break;
        case 'plant system':
            color = '#b97349';
            break;
        case 'control system':
            color = '#fb1936';
            break;
    }

    this.setStyleValue('fillColor', color);
    this.setStyleValue('swimlaneFillColor', color);
}


/**
 * Derives a name/label for the component based on its type.
 */
mxCell.prototype.autoNameComponent = function ()
{
    console.log('autoNameComponent');
    console.log(this);

    // ignore items without style
    if (!this.getStyle())
    {
        return;
    }

    // determine new number
    var num = parseInt(sessionStorage.getItem("last.number"), 10) + 1;
    sessionStorage.setItem("last.number", num);


    // determine component type prefix
    if (this.getStyleValue('zone') == '1')
    {
        prefix = 'Zone';
    }
    else 
    {
        var prefix = "COMP";
        var compMap = Editor.componentSymbols;
        if (!compMap)
        {
            return;
        }
        var found = false;
        for (var i = 0; i < compMap.length && !found; i++)
        {
            for (var j = 0; j < compMap[i].Symbols.length && !found; j++)
            {
                var s = compMap[i].Symbols[j];
                if ('img/cset/' + s.FileName == this.getStyleValue('image'))
                {
                    prefix = s.Abbreviation;
                    found = true;
                }
            }
        }
    }

    this.setCsetAttribute('label', prefix + '-' + num);
}


/**
 * Returns a boolean indicating if the specified style exists,
 * regardless of its value.
 * @param {any} styleString
 * @param {any} name
 */
mxCell.prototype.hasStyle = function (name)
{
    var exists = false;
    var styleString = this.getStyle();
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


/**
 * Returns the value for the specified style.  
 * Some style elements may not have a value.
 * This function should not be used to find those.
 * @param {any} styleString
 * @param {any} name
 */
mxCell.prototype.getStyleValue = function (name)
{
    var styleString = this.getStyle();
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
 * Sets a single style value in the cell's style string.
 */
mxCell.prototype.setStyleValue = function (name, value)
{
    var exists = false;
    var styleElements = this.getStyle().split(';');

    for (var i = 0; i < styleElements.length; i++)
    {
        const s = styleElements[i].split('=', 2);
        if (s[0].toLowerCase() === name.toLowerCase())
        {
            s[1] = value;
            styleElements[i] = s[0] + '=' + s[1];
            exists = true;
        }
    }

    if (!exists)
    {
        styleElements.push(name + '=' + value + ';');
    }

    this.setStyle(styleElements.join(';'));
}