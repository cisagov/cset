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

        private int questionGap = 5;

        private int goalStripHeight = 10;

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="xGoal"></param>
        /// <param name="goalStrip"></param>
        /// <param name="blockSize"></param>
        public QuestionsHeatMap(XElement xGoal, bool goalStrip, int blockSize)
        {
            _xSvgDoc = new XDocument(new XElement("svg"));
            _xSvg = _xSvgDoc.Root;

            _xSvg.SetAttributeValue("width", "100%");

            if (goalStrip)
            {
                _xSvg.SetAttributeValue("height", this.goalStripHeight + this.questionGap + blockSize);
            }
            else
            {
                _xSvg.SetAttributeValue("height", blockSize);
            }

            // style tag
            var xStyle = new XElement("style");
            _xSvg.Add(xStyle);
            xStyle.Value = "text {font: .5rem sans-serif}";



            var gX = 0;

            // create questions
            foreach (var xQuestion in xGoal.Descendants("Question"))
            {
                if (xQuestion.Attribute("isparentquestion")?.Value == "true"
                    || xQuestion.Attribute("placeholder-p")?.Value == "true")
                {
                    continue;
                }

                // question group
                var question = MakeQuestion(xQuestion, blockSize);
                if (goalStrip)
                {
                    question.SetAttributeValue("transform", $"translate({gX}, {(goalStripHeight + questionGap)})");
                }
                else
                {
                    question.SetAttributeValue("transform", $"translate({gX})");
                }


                _xSvg.Add(question);

                // advance the X coordinate for the next question
                gX += blockSize;
                gX += questionGap;
            }

            // create goal strip 
            if (goalStrip)
            {
                var strip = new XElement("rect");
                _xSvg.Add(strip);
                var color = xGoal.Attribute("scorecolor").Value;
                var fillColor = WidgetResources.ColorMap.ContainsKey(color) ? WidgetResources.ColorMap[color] : color;
                strip.SetAttributeValue("fill", fillColor);
                strip.SetAttributeValue("height", goalStripHeight);
                strip.SetAttributeValue("width", gX - questionGap);
                strip.SetAttributeValue("rx", goalStripHeight / 3);
            }

        }


        /// <summary>
        /// 
        /// </summary>
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
            r.SetAttributeValue("rx", blockSize / 6);

            t.Value = WidgetResources.QLabel(text);
            t.SetAttributeValue("x", blockSize / 2);
            t.SetAttributeValue("y", blockSize / 2);
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
