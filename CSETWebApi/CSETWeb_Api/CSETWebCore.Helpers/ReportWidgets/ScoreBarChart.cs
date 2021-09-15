using System;
using System.Linq;
using System.Xml.Linq;

namespace CSETWebCore.Helpers.ReportWidgets
{
    public class ScoreBarChart
    {
        private XDocument xDoc;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="d"></param>
        public ScoreBarChart(BarChartInput d)
        {
            int maxAnswerCount = d.AnswerCounts.Max();

            int barWidthInclGap = d.Width / d.AnswerCounts.Count;

            int barTopY = 20;

            int barSectionHeight = d.Height - barTopY - 20;

            int lineY = barTopY + barSectionHeight + 5;

            xDoc = new XDocument(new XElement("svg"));
            var xSvg = xDoc.Root;
            xSvg.SetAttributeValue("width", "100%");
            xSvg.SetAttributeValue("height", d.Height.ToString());

            // style tag
            var xStyle = new XElement("style");
            xSvg.Add(xStyle);
            xStyle.Value = ".text-normal {font: .9rem sans-serif}";


            // leave a half gap on the left
            var x = d.Gap / 2;

            for (int i = 0; i < d.AnswerCounts.Count; i++)
            {
                if (d.AnswerCounts[i] < 0)
                {
                    d.AnswerCounts[i] = 0;
                }

                var xRect = new XElement("rect");
                xSvg.Add(xRect);

                float pct = (float)d.AnswerCounts[i] / (float)maxAnswerCount;
                float barHeight = barSectionHeight * pct;                
                // don't render a zero-height bar; provide some minimal color
                if (barHeight < 3)
                {
                    barHeight = 3;
                }
                float barTop = barTopY + barSectionHeight - barHeight;


                xRect.SetAttributeValue("height", barHeight.ToString());
                xRect.SetAttributeValue("width", (barWidthInclGap - d.Gap).ToString());
                xRect.SetAttributeValue("x", x.ToString());
                xRect.SetAttributeValue("y", barTop.ToString());
                xRect.SetAttributeValue("fill", d.BarColors[i]);


                var xBarLabel = new XElement("text");
                xSvg.Add(xBarLabel);
                xBarLabel.Value = d.AnswerCounts[i].ToString();
                xBarLabel.SetAttributeValue("x", (x + (barWidthInclGap * 0.5f)).ToString());
                xBarLabel.SetAttributeValue("y", (barTop - 3).ToString());
                xBarLabel.SetAttributeValue("text-anchor", "middle");
                xBarLabel.SetAttributeValue("dominant-baseline", "auto");
                xBarLabel.SetAttributeValue("class", "text-normal");

                x += barWidthInclGap;
            }

            var xLine = new XElement("line");
            xSvg.Add(xLine);
            xLine.SetAttributeValue("x1", "0");
            xLine.SetAttributeValue("y1", lineY.ToString());
            xLine.SetAttributeValue("x2", d.Width.ToString());
            xLine.SetAttributeValue("y2", lineY.ToString());
            xLine.SetAttributeValue("stroke", "black");
            xLine.SetAttributeValue("stroke-width", "1");
            xLine.SetAttributeValue("vector-effect", "non-scaling-stroke");

            if (d.IncludePercentFirstBar)
            {
                var xText = new XElement("text");
                xSvg.Add(xText);
                xText.SetAttributeValue("x", ((float)barWidthInclGap * 0.5f).ToString());
                xText.SetAttributeValue("y", (lineY + 2).ToString());
                xText.SetAttributeValue("dominant-baseline", "hanging");
                xText.SetAttributeValue("text-anchor", "middle");
                xText.Value = ((float)d.AnswerCounts[0] / (float)d.AnswerCounts.Sum()).ToString("P0");
                xText.SetAttributeValue("class", "text-normal");
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public override string ToString()
        {
            return xDoc.ToString();
        }
    }
}
