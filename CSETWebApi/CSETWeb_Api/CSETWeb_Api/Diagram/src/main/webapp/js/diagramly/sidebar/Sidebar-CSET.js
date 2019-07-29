(function ()
{
    Sidebar.prototype.addCSETPalettes = function ()
    {
        var sidebar = this;

        // default dimension (width & height)
        var d = 60;

        var s = 'aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/';

        // Get the component symbols structure
        var url = localStorage.getItem('cset.host') + 'diagram/symbols/get';
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function ()
        {
            if (this.readyState == 4 && this.status == 200)
            {
                Editor.componentSymbols = JSON.parse(this.responseText);

                Editor.componentSymbols.forEach((group) =>
                {
                    var fns = [];

                    group.Symbols.forEach((symbol) =>
                    {
                        fns.push(
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

                    sidebar.addPalette(group.SymbolGroupTitle, group.SymbolGroupTitle, false, mxUtils.bind(sidebar, function (content)
                    {
                        for (var i = 0; i < fns.length; i++)
                        {
                            content.appendChild(fns[i](content));
                        }
                    }));

                });


                // Zone Palette
                var fns6 = [
                    sidebar.createVertexTemplateEntry('swimlane;fillColor=#F0FFF0;swimlaneFillColor=#F0FFF0;', 200, 200, 'Zone', 'Zone', null, null, 'container group zone')
                ];
                sidebar.addPalette('zone', 'Zone', false, mxUtils.bind(sidebar, function (content)
                {
                    for (var i = 0; i < fns6.length; i++)
                    {
                        content.appendChild(fns6[i](content));
                    }
                }));


                // Shapes Palette
                var fns7 = [
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
                sidebar.addPalette('shapes', 'Shapes', false, mxUtils.bind(sidebar, function (content)
                {
                    for (var i = 0; i < fns7.length; i++)
                    {
                        content.appendChild(fns7[i](content));
                    }
                }));
            }
        }
        xhr.open('GET', url);
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.setRequestHeader('Authorization', localStorage.getItem('jwt'));
        xhr.send();
    };

    /**
     * Builds a string of search tags for the symbol.
     * @param {any} symbol
     */
    Sidebar.prototype.getTagsForSymbol = function (symbol)
    {
        tag = symbol.Abbreviation + ' ' + symbol.LongName + ' ' + symbol.DisplayName + ' ' + (!!symbol.Tags ? symbol.Tags : '');
        return tag;
    }

})();
