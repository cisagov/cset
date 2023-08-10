// -------------- mxCell extension functions ------------------------


/**
 * Returns the value of the attribute on the wrapper object (NOT THE STYLE).
 */
mxCell.prototype.getCsetAttribute = function (name)
{
    // 'object' is for old diagrams that haven't been updated yet
    if (typeof this.value != 'UserObject' && typeof this.value != 'object')
    {
        return null;
    }

    var obj = this.value;
    if (!obj)
    {
        return null;
    }
    return obj.getAttribute(name);
}


/**
 * Sets an attribute on a cell.  Lazily creates an object value for the cell.
 */
mxCell.prototype.setCsetAttribute = function (attributeName, attributeValue)
{
    var obj = null;
    if (!!this.value && (typeof this.value == 'UserObject' || this.value.tagName == 'UserObject'))
    {
        obj = this.value;

        obj.setAttribute(attributeName, attributeValue);
        // set an internal label as well.  Something to concatenate with the SAL for the display label.
        if (attributeName === 'label') {

            obj.setAttribute('internalLabel', attributeValue || '');
        }
    }
    else
    {
        // The cell is just an mxCell.  Wrap it in a UserObject and set the attribute on the wrapper.
        try
        {
            var doc = mxUtils.createXmlDocument();
            obj = doc.createElement('UserObject');
            obj.setAttribute(attributeName, attributeValue);
            
            // set an internal label as well.  Something to concatenate with the SAL for the display label.
            if (attributeName === 'label') {
                obj.setAttribute('internalLabel', attributeValue || '');
            }

            // 'object' is for old diagrams that haven't been updated yet
            if (!this.value || (typeof this.value != 'UserObject' && typeof this.value != 'object') && (obj.style || this.value.style || this.value == 'Zone')) {
                this.value = obj;
            }

        }
        catch (e)
        {
            console.log(e);
        }
    }
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
 * Returns a boolean indicating if the cell is the blue connector 'component'
 */
mxCell.prototype.isBlueConnector = function ()
{
    var imagePath = this.getStyleValue('image');
    if (imagePath == null) { return false; }
    return imagePath.indexOf('connector.svg') >= 0;
}


/**
 * Returns a boolean indicating if the cell is a Layer.
 */
mxCell.prototype.isLayer = function ()
{
    var parent = this.getParent();
    if (!!parent && parent.hasOwnProperty('id') && parent.id == 0)
    {
        return true;
    }
    return false;
}


/**
 * Returns the cell that represents the component's layer.
 */
mxCell.prototype.myLayer = function ()
{
    var c = this;
    while (!c.isLayer())
    {
        c = c.getParent();
    }
    return c;
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

    this.setZoneColor();

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
mxCell.prototype.setZoneColor = function ()
{
    if (!this.isZone())
    {
        return;
    }
    var headerColor = '#ece4d7';
    var color = '#f6f3ed';

    var zoneType = (this.getCsetAttribute('ZoneType') || '').toLowerCase();
    switch (zoneType)
    {
        case 'control dmz':
            headerColor = '#ffe7e9';
            color = '#fff1f2';
            break;
        case 'corporate':
            headerColor = '#fdf9d9';
            color = '#fffef4';
            break;
        case 'other':
            headerColor = '#ece4d7';
            color = '#f6f3ed';
            break;
        case 'safety':
            headerColor = '#f6d06b';
            color = '#ffe7a5';
            break;
        case 'external dmz':
            headerColor = '#d3f1df';
            color = '#ebf4ef';
            break;
        case 'plant system':
            headerColor = '#e6dbee';
            color = '#f2edf6';
            break;
        case 'control system':
            headerColor = '#d3eef2';
            color = '#f2f8f9';
            break;
        case 'classified':
            headerColor = '#99cfff';
            color = '#cce5ff';
            break;
    }

    this.setStyleValue('fillColor', headerColor);
    this.setStyleValue('swimlaneFillColor', color);
}


/**
 * Derives a name/label for the component based on its type.
 */
mxCell.prototype.autoNameComponent = function ()
{
    // ignore items without style
    if (!this.getStyle())
    {
        return;
    }
    // ignore items already labeled
    if (!!this.getCsetAttribute('label'))
    {
        return;
    }
    if (!!this.getAttribute('label')) {
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
            for (var j = 0; j < compMap[i].symbols.length && !found; j++)
            {
                var s = compMap[i].symbols[j];
                if ('img/cset/' + s.fileName == this.getStyleValue('image'))
                {
                    prefix = s.abbreviation;
                    found = true;
                }
            }
        }
    }

    this.setCsetAttribute('label', prefix + '-' + num);
}


/**
 * Returns details for the component (sourced from COMPONENT_SYMBOLS columns)
 */
mxCell.prototype.getSymbolDetail = function ()
{
    // ignore items without style
    if (!this.getStyle())
    {
        return;
    }


    var filename = CsetUtils.getFilenameFromPath(this.getStyleValue('image'));


    // if this is an MSC, use it's natural filename to find the component definition
    var s = this.getStyle();
    if (!!s && s.indexOf('msc=1') > 0)
    {
        filename = 'multiple_services_component.svg';
    }

    return CsetUtils.findComponentInMap(filename);
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
        if (style.toLowerCase() === name.toLowerCase()
            || style.toLowerCase().startsWith(name.toLowerCase() + '='))
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
 * 
 */
mxCell.prototype.removeStyleValue = function (name)
{
    var elements = this.getStyle().split(';');

    for (var i = elements.length - 1; i >= 0; i--)
    {
        if (elements[i].toLowerCase() === name.toLowerCase()
            || elements[i].toLowerCase().startsWith(name.toLowerCase() + '=')
            || elements[i] === '')
        {
            elements.splice(i, 1);
        }
    }

    this.setStyle(elements.join(';'));
}


/**
 * Sets a single style value in the cell's style string.
 */
mxCell.prototype.setStyleValue = function (name, value)
{
    this.removeStyleValue(name);

    var newStyle = name;
    if (!!value)
    {
        newStyle += ('=' + value);
    }

    var elements = this.getStyle().split(';');
    elements.push(newStyle + ';');

    this.setStyle(elements.join(';'));
}


/**
 * Gets the SAL from the component (if it's a zone), 
 * the component's zone, or from the assessment itself
 * if the component is not in a zone.
 */
mxCell.prototype.getSAL = function ()
{
    const cell = this;

    if (cell.isZone())
    {
        return cell.getCsetAttribute('SAL');
    }

    var c = cell;
    while (!c.isLayer() && !c.isZone())
    {
        c = c.getParent();
    }

    // component lives in layer - use overall SAL
    if (c.isLayer())
    {
        return Editor.overallSAL;
    }

    // parent zone's SAL
    return c.getCsetAttribute('SAL');
}


