using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using System.Xml.XPath;

namespace CSETWebCore.Helpers.ReportWidgets
{
    public class QuestionsHeatMap
    {
        private XDocument _xSvgDoc;
        private XElement _xSvg;


        // the primary unit of measure, the width/height of a question block
        private double aaa = 30;

        private double gap1 = 2;
        private double gap2 = 5;

        private double goalStripHeight = 10;

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="xGoal"></param>
        public QuestionsHeatMap(XElement xGoal)
        {
            _xSvgDoc = new XDocument(new XElement("svg"));
            _xSvg = _xSvgDoc.Root;

            // TODO:  TBD
            _xSvg.SetAttributeValue("width", "100%");
            _xSvg.SetAttributeValue("height", 50);

            // style tag
            var fontHeightPx = aaa * .4;
            var xStyle = new XElement("style");
            _xSvg.Add(xStyle);
            xStyle.Value = $".text {{font: {fontHeightPx}px sans-serif}}";



            double gX = 0;

            // create questions
            foreach (var xQuestion in xGoal.Descendants("Question"))
            {
                if (xQuestion.Attribute("isparentquestion")?.Value == "true"
                    || xQuestion.Attribute("placeholder-p")?.Value == "true")
                {
                    continue;
                }

                // question group
                var question = MakeQuestion(xQuestion);
                question.SetAttributeValue("transform", $"translate({gX}, {(goalStripHeight + gap2)})");

                _xSvg.Add(question);

                // advance the X coordinate for the next question
                gX += aaa;
                gX += gap2;
            }

            // create goal strip 
            var goalStrip = new XElement("rect");
            _xSvg.Add(goalStrip);
            var color = xGoal.Attribute("scorecolor").Value;
            var fillColor = WidgetResources.ColorMap.ContainsKey(color) ? WidgetResources.ColorMap[color] : color;
            goalStrip.SetAttributeValue("fill", fillColor);
            goalStrip.SetAttributeValue("height", goalStripHeight);
            goalStrip.SetAttributeValue("width", gX - gap2);
            goalStrip.SetAttributeValue("rx", goalStripHeight / 3d);
        }


        /// <summary>
        /// 
        /// </summary>
        private XElement MakeQuestion(XElement xQ)
        {
            var color = xQ.Attribute("scorecolor").Value;
            var text = WidgetResources.QLabel(xQ.Attribute("displaynumber").Value);

            var fillColor = WidgetResources.ColorMap.ContainsKey(color) ? WidgetResources.ColorMap[color] : color;
            var textColor = WidgetResources.GetTextColor(color);

            var g = new XElement("g");
            var r = new XElement("rect");
            var t = new XElement("text");

            g.Add(r);
            g.Add(t);

            r.SetAttributeValue("fill", fillColor);
            r.SetAttributeValue("width", aaa);
            r.SetAttributeValue("height", aaa);
            r.SetAttributeValue("rx", aaa / 6d);

            t.Value = WidgetResources.QLabel(text);
            t.SetAttributeValue("class", "text");
            t.SetAttributeValue("x", aaa / 2d);
            t.SetAttributeValue("y", aaa / 2d);
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
