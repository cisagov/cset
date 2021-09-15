using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using System.Xml.XPath;


namespace CSETWebCore.Helpers.ReportWidgets
{
    public class MilHeatMap
    {
        private XDocument _xSvgDoc;
        private XElement _xSvg;

        // the main dimension - edge of an answer block
        private int aaa = 20;

        // the gap between questions
        private int gap1 = 2;

        // the gap between goals, header strips etc.
        private int gap2 = 5;

        //keep track of the max width and height for setting the viewbox
        private int maxX = 0;
        private int maxY = 0;


        /// <summary>
        /// 
        /// </summary>
        public MilHeatMap(XElement xMil, bool showMilStrip)
        {
            _xSvgDoc = new XDocument(new XElement("svg"));
            _xSvg = _xSvgDoc.Root;

            _xSvg.SetAttributeValue("data-mil", xMil.Attribute("label").Value);

            // style tag
            var xStyle = new XElement("style");
            _xSvg.Add(xStyle);
            xStyle.Value = "text {font: .5rem sans-serif}";


            var gX = 0;

            // create goals
            foreach (var xGoal in xMil.Descendants("Goal"))
            {
                // goal group
                var goalGroup = MakeGoal(xGoal);
                goalGroup.SetAttributeValue("transform", $"translate({gX}, {(aaa + gap2)})");

                var goalStrip = goalGroup.XPathSelectElement("*/rect[contains(@class, 'goal-strip')]");

                // advance the X coordinate for the next goal
                gX += int.Parse(goalStrip?.Attribute("width").Value);
                gX += gap2;

                if (gX > maxX)
                {
                    maxX = gX;
                }
            }


            // create MIL strip 
            var m = MakeMilStrip(xMil);
            _xSvg.Add(m);
            int milStripWidth = 0;
            var goalStripRects = m.XPathSelectElements("//rect[contains(@class, 'goal-strip')]");
            foreach (var rect in goalStripRects)
            {
                milStripWidth += int.Parse(rect.Attribute("width").Value);
                milStripWidth += gap2;
            }
            milStripWidth -= gap2;

            SetStripWidth(m, milStripWidth);


            // Might need to hide/shift a few things for the Results pages
            if (!showMilStrip)
            {
                var hasGhostGoal = (xMil.Descendants("Goal").All(g => g.Attribute("ghost-goal")?.Value == "true"));
                if (!hasGhostGoal)
                {
                    // this is Results for MIL-1.  Hide the MIL strip
                    m.SetAttributeValue("style", "visibility:hidden");
                }

                foreach (var rect in goalStripRects)
                {
                    WidgetResources.TranslateObject(rect.Parent.Parent, 0, -(aaa + gap2));
                }
            }


            maxY += 10;

            // Set the viewBox based on the size of the graphic
            _xSvg.SetAttributeValue("viewBox", $"0 0 {maxX} {maxY}");
            _xSvg.SetAttributeValue("width", maxX);
            _xSvg.SetAttributeValue("height", maxY);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        private XElement MakeMilStrip(XElement xMil)
        {
            var color = xMil.Attribute("scorecolor").Value;
            var fillColor = WidgetResources.ColorMap.ContainsKey(color) ? WidgetResources.ColorMap[color] : color;
            var textColor = "#000";
            if (color == "red")
            {
                textColor = "#fff";
            }


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

            t.Value = xMil.Attribute("label").Value;
            t.SetAttributeValue("x", 100 / 2);
            t.SetAttributeValue("y", aaa / 2);
            t.SetAttributeValue("dominant-baseline", "middle");
            t.SetAttributeValue("text-anchor", "middle");
            t.SetAttributeValue("fill", textColor);

            return g;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="xGoal"></param>
        /// <returns></returns>
        private XElement MakeGoal(XElement xGoal)
        {
            var goalGroup = new XElement("g");
            goalGroup.SetAttributeValue("id", xGoal.Attribute("abbreviation").Value);
            _xSvg.Add(goalGroup);



            // create the goal strip
            var goalStrip = MakeGoalStrip(xGoal);
            goalGroup.Add(goalStrip);


            // add question blocks to goal
            var x = -(aaa + gap1);
            var y = aaa + gap2;

            foreach (var xQ in xGoal.Descendants("Question"))
            {
                var isChild = xQ.Attribute("parentquestionid").Value != "";

                if (isChild)
                {
                    // stack below previous
                    y += (aaa + gap1);
                }
                else
                {
                    x += (aaa + gap1);
                    y = aaa + gap2;
                }

                var block = MakeQuestion(xQ);
                block.SetAttributeValue("transform", $"translate({x}, {y})");

                goalGroup.Add(block);

                if (y + ((aaa + gap1) * 2) > maxY)
                {
                    maxY = y + ((aaa + gap1) * 2);
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
            r.SetAttributeValue("rx", aaa / 6);

            t.Value = WidgetResources.QLabel(text);
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
        /// <param name="xGoal"></param>
        /// <returns></returns>
        private XElement MakeGoalStrip(XElement xGoal)
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
            r.SetAttributeValue("height", aaa);
            r.SetAttributeValue("rx", aaa / 6);
            r.SetAttributeValue("fill", fillColor);


            t.SetAttributeValue("y", aaa / 2);
            t.SetAttributeValue("dominant-baseline", "middle");
            t.SetAttributeValue("text-anchor", "middle");
            t.SetAttributeValue("fill", textColor);
            t.Value = WidgetResources.GLabel(xGoal.Attribute("abbreviation").Value);


            // determine width of goal strip
            var nonChildQuestions = xGoal.Descendants("Question")
               .Where(q => q.Attribute("parentquestionid").Value == "");
            var width = nonChildQuestions.Count() * (aaa + gap1) - gap1;
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
        private void SetStripWidth(XElement e, int width)
        {
            // assume that a <g> was passed
            var rect = e.Descendants("rect").First();
            rect.SetAttributeValue("width", width);

            var text = e.Descendants("text").First();
            text.SetAttributeValue("x", width / 2);
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
