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

        private Dictionary<string, string> colorMap;


        /// <summary>
        /// 
        /// </summary>
        public MilHeatMap(XElement xMil, bool showMilStrip)
        {
            _xSvgDoc = new XDocument(new XElement("svg"));
            _xSvg = _xSvgDoc.Root;

            // TODO:  TBD
            _xSvg.SetAttributeValue("width", 1000);
            _xSvg.SetAttributeValue("height", 400);

            // style tag
            var xStyle = new XElement("style");
            _xSvg.Add(xStyle);
            xStyle.Value = "text {font: .5rem sans-serif}";


            // map generic color words to our specific colors
            colorMap = new Dictionary<string, string>()
            {
                { "green", "#28A745" },
                { "yellow", "#FFC107"},
                { "red", "#DC3545"},
                { "unanswered-gray", "#a0a0a0" },
                { "parent-gray", "#d0d0d0" },
                { "placeholder-gray", "#e0e0e0"}
            };


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
                    TranslateObject(rect.Parent.Parent, 0, -(aaa + gap2));
                }
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        private XElement MakeMilStrip(XElement xMil)
        {
            var color = xMil.Attribute("scorecolor").Value;
            var fillColor = colorMap.ContainsKey(color) ? colorMap[color] : color;
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

                var block = MakeQBlock(xQ.Attribute("scorecolor").Value, xQ.Attribute("displaynumber").Value);
                block.SetAttributeValue("transform", $"translate({x}, {y})");

                goalGroup.Add(block);
            }

            return goalGroup;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="color"></param>
        /// <param name="text"></param>
        /// <returns></returns>
        private XElement MakeQBlock(string color, string text)
        {
            var fillColor = colorMap.ContainsKey(color) ? colorMap[color] : color;
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

            r.SetAttributeValue("fill", fillColor);
            r.SetAttributeValue("width", aaa);
            r.SetAttributeValue("height", aaa);
            r.SetAttributeValue("rx", aaa / 6);

            t.Value = QLabel(text);
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
            var fillColor = colorMap.ContainsKey(color) ? colorMap[color] : color;
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
            t.Value = GLabel(xGoal.Attribute("abbreviation").Value);


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
        /// Parses the Goal label for the goal strip
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        private string GLabel(string s)
        {
            var cloc = s.LastIndexOf(":");
            if (cloc < 0)
            {
                return s;
            }

            return s.Substring(cloc + 1);
        }


        /// <summary>
        /// Parses the Question label for the block.
        /// </summary>
        /// <returns></returns>
        private string QLabel(string s)
        {
            var qloc = s.LastIndexOf("Q");
            if (qloc < 0)
            {
                return s;
            }

            var s1 = s.Substring(qloc);

            var dloc = s1.LastIndexOf("-");
            if (dloc < 0)
            {
                // not a child question
                return s1;
            }

            // child question
            return s1.Substring(1, dloc - 1) + s1.Substring(dloc + 1);
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
        /// Modifies an existing translate() attribute or creates a new one.
        /// </summary>
        /// <param name="o"></param>
        /// <param name="x"></param>
        /// <param name="y"></param>
        private void TranslateObject(XElement o, float x, float y)
        {
            var attrib = o.Attribute("transform");
            if (attrib == null)
            {
                o.SetAttributeValue("transform", $"translate({x}, {y})");
            }
            else
            {
                attrib.Value = attrib.Value + $" translate({x}, {y})";
            }
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
