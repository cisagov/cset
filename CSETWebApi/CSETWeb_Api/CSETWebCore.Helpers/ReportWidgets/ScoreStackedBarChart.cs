using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace CSETWebCore.Helpers.ReportWidgets
{
    public class ScoreStackedBarChart
    {
        private XDocument xDoc;

        public ScoreStackedBarChart(BarChartInput d)
        {
            int maxAnswerCount = d.AnswerCounts.Max();

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
                    var segmentWidth = (float)d.Width * pct;

                    xRect.SetAttributeValue("height", d.Height.ToString());
                    xRect.SetAttributeValue("width", segmentWidth.ToString());
                    xRect.SetAttributeValue("x", x.ToString());
                    xRect.SetAttributeValue("y", "0");
                    xRect.SetAttributeValue("fill", d.BarColors[i]);


                    // labels on the segments
                    var xBarLabel = new XElement("text");
                    xSvg.Add(xBarLabel);
                    xBarLabel.Value = d.AnswerCounts[i].ToString();
                    xBarLabel.SetAttributeValue("x", (x + segmentWidth * 0.5f).ToString());
                    xBarLabel.SetAttributeValue("y", (d.Height * 0.5f).ToString());
                    xBarLabel.SetAttributeValue("text-anchor", "middle");
                    xBarLabel.SetAttributeValue("dominant-baseline", "middle");
                    xBarLabel.SetAttributeValue("class", "text-normal");
                    var textColor = TextColorForBackground(d.BarColors[i]);
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


        /// <summary>
        /// Calculates the luminance of the background color and returns
        /// the contrasting text color.
        /// </summary>
        /// <param name="bgColor"></param>
        /// <returns></returns>
        private string TextColorForBackground(string bgColor)
        {
            var color = bgColor.StartsWith('#') ? bgColor.Substring(1) : bgColor;
            var r = Convert.ToInt32(color.Substring(0, 2), 16); // hexToR
            var g = Convert.ToInt32(color.Substring(2, 2), 16); // hexToG
            var b = Convert.ToInt32(color.Substring(4, 2), 16); // hexToB
            var uicolors = new List<float>() { r / 255f, g / 255f, b / 255f };

            var c = new List<float>();
            foreach (float col in uicolors)
            {
                if (col <= 0.03928)
                {
                    c.Add(col / 12.92f);
                }
                c.Add((float)Math.Pow((double)((col + 0.055) / 1.055d), 2.4d));
            };

            var luminance = (0.2126 * c[0]) + (0.7152 * c[1]) + (0.0722 * c[2]);
            return (luminance > 0.179) ? "#000000" : "#FFFFFF";
        }
    }
}
