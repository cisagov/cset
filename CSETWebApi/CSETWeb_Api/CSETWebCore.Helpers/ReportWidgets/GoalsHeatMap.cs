//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
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

        private double milStripHeight = 10;

        private double gap = 5;


        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="xMil"></param>
        public GoalsHeatMap(XElement xMil, int blockSize = 30)
        {
            _xSvgDoc = new XDocument(new XElement("svg"));
            _xSvg = _xSvgDoc.Root;

            _xSvg.SetAttributeValue("width", "100%");
            _xSvg.SetAttributeValue("height", this.milStripHeight + this.gap + blockSize);


            double gX = 0;

            // create goals
            foreach (var xGoal in xMil.Descendants("Goal"))
            {
                // goal group
                var goal = MakeGoal(xGoal, blockSize);
                goal.SetAttributeValue("transform", $"translate({gX}, {(milStripHeight + gap)})");

                _xSvg.Add(goal);

                // advance the X coordinate for the next goal
                gX += blockSize;
                gX += gap;
            }


            // create MIL strip 
            var milStrip = new XElement("rect");
            _xSvg.Add(milStrip);
            var color = xMil.Attribute("scorecolor").Value;
            var fillColor = WidgetResources.ColorMap.ContainsKey(color) ? WidgetResources.ColorMap[color] : color;
            milStrip.SetAttributeValue("fill", fillColor);
            milStrip.SetAttributeValue("height", milStripHeight);
            milStrip.SetAttributeValue("width", gX - gap);
            milStrip.SetAttributeValue("rx", milStripHeight / 3.0d);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="goal"></param>
        /// <returns></returns>
        private XElement MakeGoal(XElement goal, int blockSize)
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
            r.SetAttributeValue("width", blockSize);
            r.SetAttributeValue("height", blockSize);
            r.SetAttributeValue("rx", blockSize / 6.0d);

            t.Value = WidgetResources.GLabel(text);
            t.SetAttributeValue("x", blockSize / 2.0d);
            t.SetAttributeValue("y", blockSize / 2.0d);
            t.SetAttributeValue("font-size", "60%");
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
