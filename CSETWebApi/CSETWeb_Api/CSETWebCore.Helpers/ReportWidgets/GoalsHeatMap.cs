using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using System.Xml.XPath;

namespace CSETWebCore.Helpers.ReportWidgets
{
    /// <summary>
    /// Generates an SVG showing blocks for goals.
    /// </summary>
    public class GoalsHeatMap
    {
        private XDocument _xSvgDoc;
        private XElement _xSvg;

        private int milStripHeight = 10;

        // the primary unit of measure, the width/height of a goal block
        private int aaa = 30;

        private int gap1 = 2;
        private int gap2 = 5;


        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="xMil"></param>
        public GoalsHeatMap(XElement xMil)
        {
            _xSvgDoc = new XDocument(new XElement("svg"));
            _xSvg = _xSvgDoc.Root;

            // TODO:  TBD
            _xSvg.SetAttributeValue("width", "100%");
            _xSvg.SetAttributeValue("height", 50);

            // style tag
            var xStyle = new XElement("style");
            _xSvg.Add(xStyle);
            xStyle.Value = "text {font: .5rem sans-serif}";

           

            var gX = 0;

            // create goals
            foreach (var xGoal in xMil.Descendants("Goal"))
            {
                // goal group
                var goal = MakeGoal(xGoal);
                goal.SetAttributeValue("transform", $"translate({gX}, {(milStripHeight + gap2)})");

                _xSvg.Add(goal);

                // advance the X coordinate for the next goal
                gX += aaa;
                gX += gap2;
            }


            // create MIL strip 
            var milStrip = new XElement("rect");
            _xSvg.Add(milStrip);
            var color = xMil.Attribute("scorecolor").Value;
            var fillColor = WidgetResources.ColorMap.ContainsKey(color) ? WidgetResources.ColorMap[color] : color;
            milStrip.SetAttributeValue("fill", fillColor);
            milStrip.SetAttributeValue("height", milStripHeight);
            milStrip.SetAttributeValue("width", gX - gap2);
            milStrip.SetAttributeValue("rx", milStripHeight / 3);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="goal"></param>
        /// <returns></returns>
        private XElement MakeGoal(XElement goal)
        {
            var color = goal.Attribute("scorecolor").Value;
            var fillColor = WidgetResources.ColorMap.ContainsKey(color) ? WidgetResources.ColorMap[color] : color;
            var textColor = WidgetResources.GetTextColor(color);

            var text = goal.Attribute("abbreviation").Value;

            var g = new XElement("g");
            var r = new XElement("rect");
            var t = new XElement("text");

            g.Add(r);
            g.Add(t);

            r.SetAttributeValue("fill", fillColor);
            r.SetAttributeValue("width", aaa);
            r.SetAttributeValue("height", aaa);
            r.SetAttributeValue("rx", aaa / 6);

            t.Value = WidgetResources.GLabel(text);
            t.SetAttributeValue("x", aaa / 2);
            t.SetAttributeValue("y", aaa / 2);
            t.SetAttributeValue("dominant-baseline", "middle");
            t.SetAttributeValue("text-anchor", "middle");
            t.SetAttributeValue("fill", textColor);

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
