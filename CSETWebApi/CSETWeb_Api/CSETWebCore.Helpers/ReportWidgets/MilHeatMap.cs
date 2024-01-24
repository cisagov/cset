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
    /// Renders an SVG showing all Goals for a MIL or Domain with 
    /// each Goal's questions below.  
    /// </summary>
    public class MilHeatMap
    {
        private XDocument _xSvgDoc;
        private XElement _xSvg;

        // the gap between questions
        private double gap1 = 2;

        // the gap between goals, header strips etc.
        private double gap2 = 2;

        //keep track of the max width and height for setting the viewbox
        private double maxX = 0;
        private double maxY = 0;


        /// <summary>
        /// Create a heat map with Goal strips and Question blocks below.
        /// This will work for a MIL or a Domain as the parent.
        /// </summary>
        public MilHeatMap(XElement xParent, bool showParentStrip, bool collapseGhostGoal, int blockSize = 12)
        {
            _xSvgDoc = new XDocument(new XElement("svg"));
            _xSvg = _xSvgDoc.Root;


            // label the SVG if this is a MIL
            if (xParent.Name.ToString().ToLower() == "mil")
            {
                _xSvg.SetAttributeValue("data-mil", xParent.Attribute("label").Value);
            }


            double gX = 0;

            // create goals
            foreach (var xGoal in xParent.Descendants("Goal"))
            {
                // goal group
                var goalGroup = MakeGoal(xGoal, blockSize);
                goalGroup.SetAttributeValue("transform", $"translate({gX}, {(blockSize + gap2)})");

                var goalStrip = goalGroup.XPathSelectElement("*/rect[contains(@class, 'goal-strip')]");

                // advance the X coordinate for the next goal
                gX += double.Parse(goalStrip?.Attribute("width").Value);
                gX += gap2;

                if (gX > maxX)
                {
                    maxX = gX;
                }
            }


            // create parent strip 
            var m = MakeParentStrip(xParent, blockSize);
            _xSvg.Add(m);
            double parentStripWidth = 0;
            var goalStripRects = m.XPathSelectElements("//rect[contains(@class, 'goal-strip')]");
            foreach (var rect in goalStripRects)
            {
                parentStripWidth += double.Parse(rect.Attribute("width").Value);
                parentStripWidth += gap2;
            }
            parentStripWidth -= gap2;

            SetStripWidth(m, parentStripWidth);


            // Might need to hide/shift a few things for the Results pages
            var hasGhostGoal = (xParent.Descendants("Goal").All(g => g.Attribute("ghost-goal")?.Value == "true"));
            if (!showParentStrip)
            {
                if (!hasGhostGoal)
                {
                    // this is Results for MIL-1.  Hide the MIL strip
                    m.SetAttributeValue("style", "visibility:hidden");
                }
            }

            if (collapseGhostGoal)
            {
                if (hasGhostGoal)
                {
                    foreach (var rect in goalStripRects)
                    {
                        WidgetResources.TranslateObject(rect.Parent.Parent, 0, (float)(-(blockSize + gap2)));
                    }
                }
            }


            maxY += 10;

            _xSvg.SetAttributeValue("width", maxX);
            _xSvg.SetAttributeValue("height", maxY);
        }


        /// <summary>
        /// Scales the SVG by a defined amount.  A scale of 1 will
        /// not affect the size of the graphic.  Scale values smaller
        /// than 1 will shrink the graphic and values larger than 1 will
        /// enlarge it.
        /// </summary>
        /// <param name="scale"></param>
        public void Scale(double scale)
        {
            _xSvg.SetAttributeValue("width", double.Parse(_xSvg.Attribute("width")?.Value) * scale);
            _xSvg.SetAttributeValue("height", double.Parse(_xSvg.Attribute("height")?.Value) * scale);

            _xSvg.SetAttributeValue("transform-origin", "0 0");

            var attrTransform = _xSvg.Attribute("transform");
            if (attrTransform == null)
            {
                _xSvg.SetAttributeValue("transform", $"scale({scale})");
                return;
            }

            attrTransform.Value += $" scale({scale})";
        }


        public string Width
        {
            get => _xSvg.Attribute("width")?.Value;
            set
            {
                _xSvg.SetAttributeValue("width", value);
            }
        }

        public string Height
        {
            get => _xSvg.Attribute("height")?.Value;
            set
            {
                _xSvg.SetAttributeValue("height", value);
            }
        }

        public void DisableAspectRatio()
        {
            _xSvg.SetAttributeValue("preserveAspectRatio", "none");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        private XElement MakeParentStrip(XElement xParent, int blockSize)
        {
            var color = xParent.Attribute("scorecolor").Value;
            var fillColor = WidgetResources.ColorMap.ContainsKey(color) ? WidgetResources.ColorMap[color] : color;
            var textColor = WidgetResources.GetTextColor(color);

            var g = new XElement("g");
            var r = new XElement("rect");
            var t = new XElement("text");

            g.Add(r);
            g.Add(t);

            r.SetAttributeValue("id", xParent.Name.ToString().ToUpper());
            r.SetAttributeValue("width", 100d);
            r.SetAttributeValue("height", blockSize);
            r.SetAttributeValue("rx", blockSize / 6d);
            r.SetAttributeValue("fill", fillColor);


            var label = xParent.Attribute("label");
            var abbrev = xParent.Attribute("abbreviation");
            t.Value = label?.Value ?? abbrev?.Value ?? "";
            t.SetAttributeValue("x", 100d / 2d);
            t.SetAttributeValue("y", blockSize / 2d);
            t.SetAttributeValue("font-size", "40%");
            t.SetAttributeValue("dominant-baseline", "middle");
            t.SetAttributeValue("text-anchor", "middle");
            t.SetAttributeValue("fill", textColor);
            t.SetAttributeValue("text-rendering", "optimizeLegibility");

            return g;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="xGoal"></param>
        /// <returns></returns>
        private XElement MakeGoal(XElement xGoal, int blockSize)
        {
            var goalGroup = new XElement("g");
            goalGroup.SetAttributeValue("id", xGoal.Attribute("abbreviation").Value);
            _xSvg.Add(goalGroup);



            // create the goal strip
            var goalStrip = MakeGoalStrip(xGoal, blockSize);
            goalGroup.Add(goalStrip);


            // add question blocks to goal
            var x = -(blockSize + gap1);
            var y = blockSize + gap2;

            foreach (var xQ in xGoal.Descendants("Question"))
            {
                var isChild = xQ.Attribute("parentquestionid").Value != "";

                if (isChild)
                {
                    // stack below previous
                    y += (blockSize + gap1);
                }
                else
                {
                    x += (blockSize + gap1);
                    y = blockSize + gap2;
                }

                var block = MakeQuestion(xQ, blockSize);
                block.SetAttributeValue("transform", $"translate({x}, {y})");

                goalGroup.Add(block);

                if (y + ((blockSize + gap1) * 2) > maxY)
                {
                    maxY = y + ((blockSize + gap1) * 2);
                }
            }

            return goalGroup;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="color"></param>
        /// <param name="text"></param>
        /// <returns></returns>
        private XElement MakeQuestion(XElement xQ, int blockSize)
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
            r.SetAttributeValue("width", blockSize);
            r.SetAttributeValue("height", blockSize);
            r.SetAttributeValue("rx", blockSize / 6d);

            t.Value = WidgetResources.QLabel(text);
            t.SetAttributeValue("x", blockSize / 2d);
            t.SetAttributeValue("y", blockSize / 2d);
            t.SetAttributeValue("font-size", "40%");
            t.SetAttributeValue("dominant-baseline", "middle");
            t.SetAttributeValue("text-anchor", "middle");
            t.SetAttributeValue("fill", textColor);
            t.SetAttributeValue("text-rendering", "optimizeLegibility");

            return g;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="xGoal"></param>
        /// <returns></returns>
        private XElement MakeGoalStrip(XElement xGoal, int blockSize)
        {
            var color = xGoal.Attribute("scorecolor").Value;
            var fillColor = WidgetResources.ColorMap.ContainsKey(color) ? WidgetResources.ColorMap[color] : color;
            var textColor = WidgetResources.GetTextColor(color);


            var g = new XElement("g");
            var r = new XElement("rect");
            var t = new XElement("text");

            g.Add(r);
            g.Add(t);

            r.SetAttributeValue("class", "goal-strip");
            r.SetAttributeValue("x", 0);
            r.SetAttributeValue("y", 0);
            r.SetAttributeValue("height", blockSize);
            r.SetAttributeValue("rx", blockSize / 6d);
            r.SetAttributeValue("fill", fillColor);


            t.SetAttributeValue("y", blockSize / 2d);
            t.SetAttributeValue("font-size", "40%");
            t.SetAttributeValue("dominant-baseline", "middle");
            t.SetAttributeValue("text-anchor", "middle");
            t.SetAttributeValue("fill", textColor);
            t.SetAttributeValue("text-rendering", "optimizeLegibility");
            t.Value = WidgetResources.GLabel(xGoal.Attribute("abbreviation").Value);


            // determine width of goal strip
            var nonChildQuestions = xGoal.Descendants("Question")
               .Where(q => q.Attribute("parentquestionid").Value == "");
            var width = nonChildQuestions.Count() * (blockSize + gap1) - gap1;
            SetStripWidth(g, width);


            // hide ghost goal
            if (xGoal.Attribute("ghost-goal")?.Value == "true")
            {
                r.SetAttributeValue("visibility", "hidden");
                t.SetAttributeValue("visibility", "hidden");
            }

            return g;
        }


        /// <summary>
        /// Sets the width of the first rect child of the supplied
        /// XElement (e.g., <g>) to the specified width.
        /// The first text child is centered in that rect.
        /// </summary>
        /// <param name="e"></param>
        /// <param name="width"></param>
        private void SetStripWidth(XElement e, double width)
        {
            // assume that a <g> was passed
            var rect = e.Descendants("rect").First();
            rect.SetAttributeValue("width", width);

            var text = e.Descendants("text").First();
            text.SetAttributeValue("x", width / 2d);
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
