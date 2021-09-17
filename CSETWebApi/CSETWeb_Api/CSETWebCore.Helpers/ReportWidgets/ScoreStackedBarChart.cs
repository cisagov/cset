using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace CSETWebCore.Helpers.ReportWidgets
{
    /// <summary>
    /// Renders an svg for a single stacked bar.
    /// Each segment is labeled with its count.
    /// </summary>
    public class ScoreStackedBarChart
    {
        private XDocument xDoc;

        public ScoreStackedBarChart(BarChartInput d)
        {
            int maxAnswerCount = d.AnswerCounts.Sum();

            xDoc = new XDocument(new XElement("svg"));
            var xSvg = xDoc.Root;
            xSvg.SetAttributeValue("width", "100%");
            xSvg.SetAttributeValue("height", d.Height.ToString());

            // style tag
            var xStyle = new XElement("style");
            xSvg.Add(xStyle);
            xStyle.Value = ".text-normal {font: .9rem sans-serif}";


            var x = 0f;

            for (int i = 0; i < d.AnswerCounts.Count; i++)
            {
                if (d.AnswerCounts[i] > 0)
                {
                    var xRect = new XElement("rect");
                    xSvg.Add(xRect);

                    float pct = (float)d.AnswerCounts[i] / (float)maxAnswerCount;
                    var segmentWidth = ((float)d.Width * pct);

                    xRect.SetAttributeValue("height", d.Height.ToString());
                    xRect.SetAttributeValue("width", segmentWidth.ToString());
                    xRect.SetAttributeValue("x", x.ToString());
                    xRect.SetAttributeValue("y", "0");
                    var fillColor = WidgetResources.ColorMap[d.BarColors[i]];
                    xRect.SetAttributeValue("fill", fillColor);


                    // labels on the segments
                    var xBarLabel = new XElement("text");
                    xSvg.Add(xBarLabel);
                    xBarLabel.Value = d.AnswerCounts[i].ToString();
                    xBarLabel.SetAttributeValue("x", (x + segmentWidth * 0.5f).ToString());
                    xBarLabel.SetAttributeValue("y", (d.Height * 0.5f).ToString());
                    xBarLabel.SetAttributeValue("text-anchor", "middle");
                    xBarLabel.SetAttributeValue("dominant-baseline", "middle");
                    xBarLabel.SetAttributeValue("class", "text-normal");
                    var textColor = WidgetResources.GetTextColor(d.BarColors[i]);
                    xBarLabel.SetAttributeValue("fill", textColor);

                    x += segmentWidth;
                }
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
