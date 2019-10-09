(function () {
    Sidebar.prototype.addCSETPalettes = function () {
        var sidebar = this;

        // default dimension (width & height)
        var d = 60;

        var s = 'aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/';

        // Get the component symbols structure
        Editor.getComponentSymbols().then(function (symbolGroups)
        {
            symbolGroups.forEach((group) =>
            {
                var symbols = [];


                // special case:  insert the 'text' symbols into the General palette
                if (group.SymbolGroupTitle === 'General')
                {
                    symbols.push(sidebar.createVertexTemplateEntry('text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;',
                        40, 20, 'Text', 'Text', null, null, 'text textbox textarea label'));
                    symbols.push(sidebar.createVertexTemplateEntry('text;html=1;strokeColor=none;fillColor=none;spacing=5;spacingTop=-20;whiteSpace=wrap;overflow=hidden;rounded=0;', 190, 120,
                        '<h1>Heading</h1><p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>',
                        'Textbox', null, null, 'text textbox textarea'));
                }

                group.Symbols.forEach((symbol) =>
                {
                    symbols.push(
                        sidebar.createVertexTemplateEntry(
                            s + symbol.FileName,
                            symbol.Width,
                            symbol.Height,
                            '',
                            symbol.DisplayName,
                            null,
                            null,
                            sidebar.getTagsForSymbol(symbol))
                    );
                });

                for (const symbol of symbols)
                {
                    symbol.isSearchable = true;
                }
                sidebar.addPalette(group.SymbolGroupTitle, group.SymbolGroupTitle, false, mxUtils.bind(sidebar, function (content) {
                    for (const symbol of symbols) {
                        content.appendChild(symbol(content));
                    }
                }));
            });

            // Zone Palette
            var symbolsZone = [
                sidebar.createVertexTemplateEntry('swimlane;zone=1;fillColor=#F0FFF0;swimlaneFillColor=#F0FFF0;', 200, 200, 'Zone', 'Zone', null, null, 'container group zone')
            ];
            for (const symbol of symbolsZone)
            {
                symbol.isSearchable = true;
            }
            sidebar.addPalette('zone', 'Zone', false, mxUtils.bind(sidebar, function (content) {
                for (const symbol of symbolsZone) {
                    content.appendChild(symbol(content));
                }
            }));

            // Shapes Palette
            var symbolsShapes = [
                sidebar.createVertexTemplateEntry('shape=ellipse;perimeter=ellipsePerimeter;whiteSpace=wrap;html=1;backgroundOutline=1;', d, d, '', 'Or', null, null, 'circle oval ellipse'),
                sidebar.createVertexTemplateEntry('shape=hexagon;perimeter=hexagonPerimeter2;whiteSpace=wrap;html=1;', d * 1.15, d, '', 'Hexagon', null, null, 'hexagon'),
                sidebar.createVertexTemplateEntry('shape=mxgraph.basic.octagon;whiteSpace=wrap;html=1;', d, d, '', 'Octagon', null, null, 'octagon'),
                sidebar.createVertexTemplateEntry('shape=mxgraph.basic.pentagon;whiteSpace=wrap;html=1;', d, d, '', 'Pentagon', null, null, 'pentagon'),
                sidebar.createVertexTemplateEntry('shape=cross;whiteSpace=wrap;html=1;size=.4;', d, d, '', 'Cross', null, null, 'cross'),
                sidebar.createVertexTemplateEntry('shape=rectangle;whiteSpace=wrap;html=1;', d, d, '', 'Rectangle', null, null, 'rectangle'),
                sidebar.createVertexTemplateEntry('shape=mxgraph.basic.orthogonal_triangle;whiteSpace=wrap;html=1;', d, d, '', 'Right Triangle', null, null, 'right triangle'),
                sidebar.createVertexTemplateEntry('shape=rectangle;rounded=1;arcSize=20;whiteSpace=wrap;html=1;', d, d, '', 'Rounded Rectangle', null, null, 'rounded rectangle'),
                sidebar.createVertexTemplateEntry('shape=mxgraph.basic.star;whiteSpace=wrap;html=1;', d, d, '', 'Star', null, null, 'star'),
                sidebar.createVertexTemplateEntry('shape=mxgraph.basic.acute_triangle;dx=.5;whiteSpace=wrap;html=1;', d, d, '', 'Triangle', null, null, 'triangle'),
            ];
            for (const symbol of symbolsShapes)
            {
                symbol.isSearchable = true;
            }
            sidebar.addPalette('shapes', 'Shapes', false, mxUtils.bind(sidebar, function (content) {
                for (const symbol of symbolsShapes) {
                    content.appendChild(symbol(content));
                }
            }));
        });
    }

    /**
     * Builds a string of search tags for the symbol.
     * @param {any} symbol
     */
    Sidebar.prototype.getTagsForSymbol = function (symbol) {
        tag = symbol.Abbreviation + ' ' + symbol.LongName + ' ' + symbol.DisplayName + ' ' + (!!symbol.Tags ? symbol.Tags : '');
        return tag;
    }
})();
