//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
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

            float barWidthInclGap = (float)d.Width / (float)d.AnswerCounts.Count;

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
            xStyle.Value = ".text-normal {font: .5rem sans-serif}";


            // leave a half gap on the left
            var x = (float)d.Gap / 2f;

            for (int i = 0; i < d.AnswerCounts.Count; i++)
            {
                if (d.AnswerCounts[i] < 0 || !double.IsFinite(d.AnswerCounts[i]))
                {
                    d.AnswerCounts[i] = 0;
                }

                var xRect = new XElement("rect");
                xSvg.Add(xRect);

                double pct = (double)d.AnswerCounts[i] / (double)maxAnswerCount;
                double barHeight = barSectionHeight * pct;
                // don't render a zero-height bar; provide some minimal color
                if (barHeight < 1 || !double.IsFinite(barHeight))
                {
                    barHeight = 1;
                }
                double barTop = barTopY + barSectionHeight - barHeight;

                var barWidth = barWidthInclGap - d.Gap;

                xRect.SetAttributeValue("height", barHeight.ToString());
                xRect.SetAttributeValue("width", barWidth.ToString());
                xRect.SetAttributeValue("x", x.ToString());
                xRect.SetAttributeValue("y", barTop.ToString());
                var fillColor = WidgetResources.ColorMap[d.BarColors[i]];
                xRect.SetAttributeValue("fill", fillColor);

                // Percentage
                var xBarLabel = new XElement("text");
                xSvg.Add(xBarLabel);
                xBarLabel.Value = d.AnswerCounts[i].ToString();
                xBarLabel.SetAttributeValue("x", (x + (barWidth * 0.5f)).ToString());
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

                var percentage = ((double)d.AnswerCounts[0] / (double)d.AnswerCounts.Sum()) * 100;
                var value = (percentage >= 99 && percentage < 100 ? 99 : Math.Round(percentage, 0, MidpointRounding.AwayFromZero));

                if (!double.IsFinite(value))
                {
                    value = 0;
                }

                xText.Value = $"{value}%".ToString();
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
