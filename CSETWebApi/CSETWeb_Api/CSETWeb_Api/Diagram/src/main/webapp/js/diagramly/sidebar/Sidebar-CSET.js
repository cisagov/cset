(function () {
    Sidebar.prototype.addCSETPalettes = function () {


        // perimeter=ellipsePerimeter or rectangle (and there are others).  
        // Probably use rectangle for most, except circular images.  
        var d = 50;
        var dt = 'ibm';
        var sb = this;
        var s = 'aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/';

        var gn = 'ms active directory ';



        var fns = [
            this.createVertexTemplateEntry(s + 'configuration_server.svg;',
                d, d, '', 'Configuration Server', false, null, this.getTagsForStencil(gn, 'configuration server', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'dcs.svg;',
                d, d, '', 'DCS', false, null, this.getTagsForStencil(gn, 'dcs', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'ews.svg;',
                d, d, '', 'EWS', false, null, this.getTagsForStencil(gn, 'ews', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'front_end_processor.svg;',
                d, d, '', 'FEP', false, null, this.getTagsForStencil(gn, 'fep', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'historian.svg;',
                d, d, '', 'Historian', false, null, this.getTagsForStencil(gn, 'historian', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'hmi.svg;',
                d, d, '', 'HMI', false, null, this.getTagsForStencil(gn, 'hmi', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'ied.svg;',
                d, d, '', 'IED', false, null, this.getTagsForStencil(gn, 'ied', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'mtu.svg;',
                d, d, '', 'MTU', false, null, this.getTagsForStencil(gn, 'mtu', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'plc.svg;',
                d, d, '', 'PLC', false, null, this.getTagsForStencil(gn, 'plc', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'rtu.svg;',
                d, d, '', 'RTU', false, null, this.getTagsForStencil(gn, 'rtu', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'sis.svg;',
                d, d, '', 'SIS', false, null, this.getTagsForStencil(gn, 'sis', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'terminal_server.svg;',
                d, d, '', 'Terminal Server', false, null, this.getTagsForStencil(gn, 'terminal server', dt).join(' ')),
            this.createVertexTemplateEntry(s + 'unidirectional_device.svg;',
                d, d, '', 'Unidirectional Device', false, null, this.getTagsForStencil(gn, 'unidirectional device', dt).join(' '))
        ];

        
        this.addPalette('ics', 'ICS', false, mxUtils.bind(this, function (content) {
            for (var i = 0; i < fns.length; i++) {
                content.appendChild(fns[i](content));
            }
        }));



        // TODO:  There will be multiple palettes for all of the CSET stuff.
        //        It might be cleaner to break each palette into a function.

        

        this.addPalette('it', 'IT', false, mxUtils.bind(this, function (content) {
            for (var i = 0; i < fns.length; i++) {
                content.appendChild(fns[i](content));
            }
        }));

        this.addPalette('radio', 'Radio', false, mxUtils.bind(this, function (content) {
            for (var i = 0; i < fns.length; i++) {
                content.appendChild(fns[i](content));
            }
        }));

        this.addPalette('medical', 'Medical', false, mxUtils.bind(this, function (content) {
            for (var i = 0; i < fns.length; i++) {
                content.appendChild(fns[i](content));
            }
        }));

        this.addPalette('general', 'General', false, mxUtils.bind(this, function (content) {
            for (var i = 0; i < fns.length; i++) {
                content.appendChild(fns[i](content));
            }
        }));

        this.addPalette('zone', 'Zone', false, mxUtils.bind(this, function (content) {
            for (var i = 0; i < fns.length; i++) {
                content.appendChild(fns[i](content));
            }
        }));

        this.addPalette('shapes', 'Shapes', false, mxUtils.bind(this, function (content) {
            for (var i = 0; i < fns.length; i++) {
                content.appendChild(fns[i](content));
            }
        }));
    };




})();
