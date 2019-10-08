/**
 * Constructs a new point for the optional x and y coordinates. If no
 * coordinates are given, then the default values for <x> and <y> are used.
 * @constructor
 * @class Implements a basic 2D point. Known subclassers = {@link mxRectangle}.
 * @param {number} x X-coordinate of the point.
 * @param {number} y Y-coordinate of the point.
 */
CSETFile = function (ui, data, title, temp) {
    DrawioFile.call(this, ui, data);

    this.title = title;
    this.mode = App.MODE_CSET;
};

//Extends mxEventSource
mxUtils.extend(CSETFile, DrawioFile);

/**
 * Translates this point by the given vector.
 * 
 * @param {number} dx X-coordinate of the translation.
 * @param {number} dy Y-coordinate of the translation.
 */
CSETFile.prototype.isAutosave = function () {
    return false;
};

/**
 * Translates this point by the given vector.
 * 
 * @param {number} dx X-coordinate of the translation.
 * @param {number} dy Y-coordinate of the translation.
 */
CSETFile.prototype.getMode = function () {
    return this.mode;
};

/**
 * Translates this point by the given vector.
 * 
 * @param {number} dx X-coordinate of the translation.
 * @param {number} dy Y-coordinate of the translation.
 */
CSETFile.prototype.getTitle = function () {
    return this.title;
};

/**
 * Translates this point by the given vector.
 * 
 * @param {number} dx X-coordinate of the translation.
 * @param {number} dy Y-coordinate of the translation.
 */
CSETFile.prototype.isRenamable = function () {
    return true;
};

/**
 * Translates this point by the given vector.
 * 
 * @param {number} dx X-coordinate of the translation.
 * @param {number} dy Y-coordinate of the translation.
 */
CSETFile.prototype.save = function (revision, success, error) {
    this.saveAs(this.title, success, error);
};

/**
 * Translates this point by the given vector.
 * 
 * @param {number} dx X-coordinate of the translation.
 * @param {number} dy Y-coordinate of the translation.
 */
CSETFile.prototype.saveAs = function (title, success, error) {
    this.saveFile(title, false, success, error);
};

/**
 * Translates this point by the given vector.
 * 
 * @param {number} dx X-coordinate of the translation.
 * @param {number} dy Y-coordinate of the translation.
 */
CSETFile.prototype.saveFile = function (title, revision, success, error) {
    //this.title = title;

    //// Updates data after changing file name
    //this.updateFileData();
    //var data = this.getData();
    //var binary = this.ui.useCanvasForExport && /(\.png)$/i.test(this.getTitle());

    //var doSave = mxUtils.bind(this, function (data) {
    //    if (this.ui.isOfflineApp() || this.ui.isLocalFileSave()) {
    //        this.ui.doSaveLocalFile(data, title, (binary) ?
    //            'image/png' : 'text/xml', binary);
    //    }
    //    else {
    //        if (data.length < MAX_REQUEST_SIZE) {
    //            var dot = title.lastIndexOf('.');
    //            var format = (dot > 0) ? title.substring(dot + 1) : 'xml';

    //            // Do not update modified flag
    //            new mxXmlRequest(SAVE_URL, 'format=' + format +
    //                '&xml=' + encodeURIComponent(data) +
    //                '&filename=' + encodeURIComponent(title) +
    //                ((binary) ? '&binary=1' : '')).
    //                simulate(document, '_blank');
    //        }
    //        else {
    //            this.ui.handleError({ message: mxResources.get('drawingTooLarge') }, mxResources.get('error'), mxUtils.bind(this, function () {
    //                mxUtils.popup(data);
    //            }));
    //        }
    //    }

    //    this.setModified(false);
    //    this.contentChanged();

    //    if (success != null) {
    //        success();
    //    }
    //});

    //if (binary) {
    //    this.ui.getEmbeddedPng(mxUtils.bind(this, function (imageData) {
    //        doSave(imageData);
    //    }), error, (this.ui.getCurrentFile() != this) ? this.getData() : null);
    //}
    //else {
    //    doSave(data);
    //}
};

/**
 * Translates this point by the given vector.
 * 
 * @param {number} dx X-coordinate of the translation.
 * @param {number} dy Y-coordinate of the translation.
 */
CSETFile.prototype.rename = function (title, success, error) {
    if (this.title !== title) {
        this.title = title;
        this.descriptorChanged();
        if (success) {
            success();
        }
    }
};

/**
 * Returns the location as a new object.
 * @type mx.Point
 */
CSETFile.prototype.open = function () {
    const data = this.getData();
    if (data) {
        this.ui.setFileData(data);
        if (!this.isModified()) {
            this.shadowData = mxUtils.getXml(this.ui.getXmlFileData());
            this.shadowPages = null;
        }
    }
    this.installListeners();
};

CSETFile.prototype.emptyXmlRegx = /<mxGraphModel(?:\s+grid=["']\d+["'])?(?:\s+gridSize=["']\d+["'])?><root><mxCell id=["']0["']\s*(?:\/>|>(?:<mxCell id=["']1["'] parent=["']0["']\s+\/>)?<\/mxCell>)<\/root><\/mxGraphModel>/g;

CSETFile.prototype.isDiagramEmpty = function () {
    // mxgraph\EditorUi.prototype.isDiagramEmpty
    return this.ui.isDiagramEmpty();
}

CSETFile.prototype.isXmlEmpty = function () {
    const data = this.getData();
    return !data || this.emptyXmlRegx.test(data);
}

CSETFile.prototype.isEmpty = function () {
    return this.isDiagramEmpty() || this.isXmlEmpty();
}

CSETFile.prototype.setFileData = function (data, success, error) {
    try {
        if (data && data !== this.getData()) {
            this.setData(data);
            this.ui.setFileData(data);
            this.shadowData = mxUtils.getXml(this.ui.getXmlFileData());
            this.shadowPages = null;
        }

        if (success) {
            success();
        }
    } catch (err) {
        if (error) {
            error(err);
        }
    }
};
