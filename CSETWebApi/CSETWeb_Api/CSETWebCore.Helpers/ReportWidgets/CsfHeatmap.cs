//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Linq;
using System.Xml.Linq;

namespace CSETWebCore.Helpers.ReportWidgets
{
    /// <summary>
    /// Renders a domain-specific heatmap showing mapped questions below a domain header.
    /// </summary>
    public class CsfHeatmap
    {
        private XDocument _xSvgDoc;
        private XElement _xSvg;

        // the main dimension - edge of a sub-question block
        private double aaa = 15;

        // the width of a question block
        private double qWidth = 50;

        // the gap between questions
        private double gap1 = 2;

        private double fontRem = .5;



        /// <summary>
        /// 
        /// </summary>
        /// <param name="xDomain"></param>
        public CsfHeatmap(XElement xDomain)
        {
            // apply some scaling to tweak the generated size
            double scale = 1.3;
            aaa *= scale;
            qWidth *= scale;
            gap1 *= scale;
            fontRem *= scale;



            _xSvgDoc = new XDocument(new XElement("svg"));
            _xSvg = _xSvgDoc.Root;



            double gX = 0;
            double gY = 0;

            double totalWidth = 0;

            // domain block
            var xDomainStrip = MakeDomainStrip(xDomain);
            _xSvg.Add(xDomainStrip);
            totalWidth = qWidth;


            // populate a dummy placeholder 'question' if there are none
            // for this domain.  This will build an "NA" heatmap.
            if (xDomain.Descendants("Question").Count() == 0)
            {
                var naQ = new XElement("Question");
                naQ.SetAttributeValue("title", "NA");
                xDomain.Add(naQ);
            }

            // each question follows vertically
            foreach (var xQ in xDomain.Descendants("Question"))
            {
                var questionBlock = MakeQuestion(xQ);

                gX = 0;
                gY += (aaa + gap1);
                questionBlock.SetAttributeValue("transform", $"translate({gX}, {gY})");
                _xSvg.Add(questionBlock);


                // now lay out any asset types
                gX = (qWidth + gap1);
                foreach (var xSubQ in xQ.Descendants("AssetType"))
                {
                    var assetBlock = MakeAssetQuestion(xSubQ);
                    assetBlock.SetAttributeValue("transform", $"translate({gX}, 0)");
                    questionBlock.Add(assetBlock);

                    gX += (aaa + gap1);

                    if ((gX) > totalWidth)
                    {
                        totalWidth = gX;
                    }
                }
            }

            // set the size
            WidenDomainStrip(xDomainStrip, totalWidth);
            _xSvg.SetAttributeValue("width", totalWidth);
            _xSvg.SetAttributeValue("height", (xDomain.Descendants("Question").Count() + 1) * (aaa + gap1));

            // add margins to the SVG itself to allow space as the SVGs flow
            _xSvg.SetAttributeValue("class", "me-3 mb-3");
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="domain"></param>
        private XElement MakeDomainStrip(XElement domain)
        {
            var fillColor = "#999";
            var textColor = "#fff";

            var g = new XElement("g");
            var r = new XElement("rect");
            var t = new XElement("text");

            g.Add(r);
            g.Add(t);

            r.SetAttributeValue("id", "MIL");
            r.SetAttributeValue("width", 100);
            r.SetAttributeValue("height", aaa);
            r.SetAttributeValue("rx", aaa / 6);
            r.SetAttributeValue("fill", fillColor);

            t.Value = domain.Attribute("abbrev").Value;
            t.SetAttributeValue("x", 100 / 2);
            t.SetAttributeValue("y", aaa / 2);
            t.SetAttributeValue("font-size", "70%");
            t.SetAttributeValue("dominant-baseline", "middle");
            t.SetAttributeValue("text-anchor", "middle");
            t.SetAttributeValue("fill", textColor);
            t.SetAttributeValue("text-rendering", "optimizeLegibility");

            return g;
        }


        /// <summary>
        /// Adjusts the width and text positioning of the domain strip
        /// </summary>
        /// <param name="domainStrip"></param>
        /// <param name="width"></param>
        private void WidenDomainStrip(XElement domainStrip, double width)
        {
            var r = domainStrip.Descendants("rect").First();
            var t = domainStrip.Descendants("text").First();

            r.SetAttributeValue("width", width);
            t.SetAttributeValue("x", width / 2);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="color"></param>
        /// <param name="text"></param>
        /// <returns></returns>
        private XElement MakeQuestion(XElement xQ)
        {
            var color = xQ.Attribute("scorecolor")?.Value ?? "#EAEAEA";
            var text = xQ.Attribute("title").Value;

            var fillColor = WidgetResources.ColorMap.ContainsKey(color) ? WidgetResources.ColorMap[color] : color;
            var textColor = WidgetResources.GetTextColor(color);

            var g = new XElement("g");
            var r = new XElement("rect");
            var t = new XElement("text");

            g.Add(r);
            g.Add(t);

            r.SetAttributeValue("fill", fillColor);
            r.SetAttributeValue("width", qWidth);
            r.SetAttributeValue("height", aaa);
            r.SetAttributeValue("rx", aaa / 6.0);

            t.Value = text;
            t.SetAttributeValue("x", qWidth / 2.0);
            t.SetAttributeValue("y", aaa / 2.0);
            t.SetAttributeValue("font-size", "70%");
            t.SetAttributeValue("dominant-baseline", "middle");
            t.SetAttributeValue("text-anchor", "middle");
            t.SetAttributeValue("fill", textColor);
            t.SetAttributeValue("text-rendering", "optimizeLegibility");

            return g;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="xAQ"></param>
        /// <returns></returns>
        private XElement MakeAssetQuestion(XElement xAQ)
        {
            var color = xAQ.Attribute("scorecolor")?.Value ?? "#EAEAEA";
            var text = xAQ.Attribute("letter").Value;

            var fillColor = WidgetResources.ColorMap.ContainsKey(color) ? WidgetResources.ColorMap[color] : color;
            var textColor = xAQ.Attribute("scorecolor")?.Value != null ? WidgetResources.GetTextColor(color) : "#999";

            var g = new XElement("g");
            var r = new XElement("rect");
            var t = new XElement("text");

            g.Add(r);
            g.Add(t);

            r.SetAttributeValue("fill", fillColor);
            r.SetAttributeValue("width", aaa);
            r.SetAttributeValue("height", aaa);
            r.SetAttributeValue("rx", aaa / 6.0);

            t.Value = text;
            t.SetAttributeValue("x", aaa / 2.0);
            t.SetAttributeValue("y", aaa / 2.0);
            t.SetAttributeValue("font-size", "70%");
            t.SetAttributeValue("dominant-baseline", "middle");
            t.SetAttributeValue("text-anchor", "middle");
            t.SetAttributeValue("fill", textColor);
            t.SetAttributeValue("text-rendering", "optimizeLegibility");

            return g;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public override string ToString()
        {
            return _xSvgDoc.ToString();
        }
    }
}
