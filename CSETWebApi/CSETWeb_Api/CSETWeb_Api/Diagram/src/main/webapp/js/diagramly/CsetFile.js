CSETFile = function (ui, data, title, temp) {
    DrawioFile.call(this, ui, data);

    this.title = title;
    this.mode = App.MODE_CSET;
};

// Extends DrawioFile, which in turn extends mxEventSource.
mxUtils.extend(CSETFile, DrawioFile);

CSETFile.prototype.isAutosave = function () {
    return false;
};

CSETFile.prototype.getMode = function () {
    return this.mode;
};

CSETFile.prototype.getTitle = function () {
    return this.title;
};

CSETFile.prototype.isRenamable = function () {
    return true;
};

CSETFile.prototype.save = function (revision, success, error) {
    this.saveAs(this.title, success, error);
};

CSETFile.prototype.saveAs = function (title, success, error) {
    this.saveFile(title, false, success, error);
};

CSETFile.prototype.saveFile = function (title, revision, success, error) {
    this.rename(title);

    const data = this.getData();
    const empty = this.isEmpty();
    if (data && !empty) {
        CsetUtils.PersistDataToCSET(this.ui.editor, data).then(() => {
            this.setModified(false);
            this.contentChanged();
            if (success) {
                success();
            }
        }, reason => {
            if (error) {
                error(reason);
            }
        });
    }
};

CSETFile.prototype.rename = function (title, success, error) {
    if (this.title !== title) {
        this.title = title;
        this.updateFileData();
        this.descriptorChanged();
        if (success) {
            success();
        }
    }
};

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

// see: mxgraph\EditorUi.prototype.isDiagramEmpty
CSETFile.prototype.isDiagramEmpty = function () {
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
            this.setModified(true);
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
