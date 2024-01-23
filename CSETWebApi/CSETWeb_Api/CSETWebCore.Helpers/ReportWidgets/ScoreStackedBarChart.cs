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

namespace CSETWebCore.Helpers.ReportWidgets
{
    /// <summary>
    /// Renders an svg for a single stacked bar.
    /// Each segment is labeled with its count.
    /// </summary>
    public class ScoreStackedBarChart
    {
        private XDocument xDoc;

        private bool _isNA = false;

        private bool _isEmpty = false;


        /// <summary>
        /// Creates an SVG stacked bar chart representing the scores provided.
        /// </summary>
        /// <param name="d"></param>
        public ScoreStackedBarChart(BarChartInput d)
        {
            int maxAnswerCount = d.AnswerCounts.Sum();

            xDoc = new XDocument(new XElement("svg"));
            var xSvg = xDoc.Root;
            xSvg.SetAttributeValue("width", "100%");
            xSvg.SetAttributeValue("height", d.Height.ToString());

            if (d.AnswerCounts.All(x => x == 0))
            {
                _isNA = true;

                if (d.ShowNA)
                {
                    d.AnswerCounts[0] = 1;
                    maxAnswerCount = 1;
                    d.BarColors[0] = "placeholder-gray";
                }

                if (d.HideEmptyChart)
                {
                    _isEmpty = true;
                }
            }

            var x = 0f;

            for (int i = 0; i < d.AnswerCounts.Count; i++)
            {
                if (d.AnswerCounts[i] > 0)
                {
                    var xRect = new XElement("rect");
                    xSvg.Add(xRect);

                    float pct = (float)d.AnswerCounts[i] / (float)maxAnswerCount;
                    var segmentWidth = ((float)d.Width * pct);

                    xRect.SetAttributeValue("height", $"{d.Height}");
                    xRect.SetAttributeValue("width", $"{segmentWidth}");
                    xRect.SetAttributeValue("x", $"{x}");
                    xRect.SetAttributeValue("y", "0");
                    var fillColor = WidgetResources.ColorMap[d.BarColors[i]];
                    xRect.SetAttributeValue("fill", fillColor);


                    // labels on the segments
                    var xBarLabel = new XElement("text");
                    xSvg.Add(xBarLabel);
                    xBarLabel.Value = _isNA ? "Not Applicable" : $"{d.AnswerCounts[i]}";
                    xBarLabel.SetAttributeValue("x", $"{x + segmentWidth * 0.5f}");
                    xBarLabel.SetAttributeValue("y", $"{d.Height * 0.5f}");
                    xBarLabel.SetAttributeValue("text-anchor", "middle");
                    xBarLabel.SetAttributeValue("dominant-baseline", "middle");
                    xBarLabel.SetAttributeValue("font-size", "90%");
                    if (d.Height < 15)
                    {
                        xBarLabel.SetAttributeValue("font-size", "100%");
                    }
                    xBarLabel.SetAttributeValue("font-family", "sans-serif");
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
            if (_isEmpty)
            {
                return "";
            }
            return xDoc.ToString();
        }
    }
}
