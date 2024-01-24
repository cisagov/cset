//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using System.Xml.Linq;

namespace CSETWebCore.Helpers.ReportWidgets
{
    public class PerformanceSummaryLegend
    {
        private XDocument _xSvgDoc;
        private XElement _xSvg;

        private int _svgWidth = 380;
        private int _svgHeight = 60;

        // the 'x' for the left end of the bars
        private int barsX = 40;


        /// <summary>
        /// Constructor
        /// </summary>
        public PerformanceSummaryLegend(string configuration = "")
        {
            var barsWidth = _svgWidth - barsX;

            _xSvgDoc = new XDocument(new XElement("svg"));
            _xSvg = _xSvgDoc.Root;

            _xSvg.SetAttributeValue("height", _svgHeight);
            _xSvg.SetAttributeValue("width", _svgWidth);

            _xSvg.SetAttributeValue("class", "legend-svg");


            var g = new XElement("g");


            var segmentWidth = barsWidth / 3.0;
            var barHeight = 10;

            int rectangle_x = 35;
            int rectangle_y = 25;

            // Legend
            var legend = new XElement("text");
            legend.Value = "Legend";
            legend.SetAttributeValue("x", 0);
            legend.SetAttributeValue("y", rectangle_y + 8);
            legend.SetAttributeValue("class", "bold");

            g.Add(legend);

            // Green
            var green = new XElement("rect");
            green.SetAttributeValue("x", barsX);
            green.SetAttributeValue("y", rectangle_y);
            green.SetAttributeValue("fill", WidgetResources.ColorMap["green"]);
            green.SetAttributeValue("height", barHeight);
            green.SetAttributeValue("width", segmentWidth);

            var green_text = new XElement("text");
            green_text.Value = "7";
            green_text.SetAttributeValue("x", barsX + (barsWidth * .167));
            green_text.SetAttributeValue("y", rectangle_y + 10 / 2);
            green_text.SetAttributeValue("dominant-baseline", "middle");
            green_text.SetAttributeValue("text-anchor", "middle");
            green_text.SetAttributeValue("fill", "white");

            g.Add(green);
            g.Add(green_text);


            // Yellow
            var yellow = new XElement("rect");
            yellow.SetAttributeValue("x", barsX + (barsWidth * .333));
            yellow.SetAttributeValue("y", rectangle_y);
            yellow.SetAttributeValue("fill", WidgetResources.ColorMap["yellow"]);
            yellow.SetAttributeValue("height", barHeight);
            yellow.SetAttributeValue("width", segmentWidth);

            var yellow_text = new XElement("text");
            yellow_text.Value = "7";
            yellow_text.SetAttributeValue("x", barsX + (barsWidth * .5));
            yellow_text.SetAttributeValue("y", rectangle_y + 10 / 2);
            yellow_text.SetAttributeValue("dominant-baseline", "middle");
            yellow_text.SetAttributeValue("text-anchor", "middle");
            yellow_text.SetAttributeValue("fill", "black");

            g.Add(yellow);
            g.Add(yellow_text);

            // Red
            var red = new XElement("rect");
            red.SetAttributeValue("x", barsX + (barsWidth * .667));
            red.SetAttributeValue("y", rectangle_y);
            red.SetAttributeValue("fill", WidgetResources.ColorMap["red"]);
            red.SetAttributeValue("height", barHeight);
            red.SetAttributeValue("width", segmentWidth);

            var red_text = new XElement("text");
            red_text.Value = "7";
            red_text.SetAttributeValue("x", barsX + (barsWidth * .83));
            red_text.SetAttributeValue("y", rectangle_y + 10 / 2);
            red_text.SetAttributeValue("dominant-baseline", "middle");
            red_text.SetAttributeValue("text-anchor", "middle");
            red_text.SetAttributeValue("fill", "white");


            g.Add(red);
            g.Add(red_text);

            // practices performed
            var green_line = new XElement("line");
            green_line.SetAttributeValue("x1", rectangle_x + 10);
            green_line.SetAttributeValue("x2", rectangle_x + 10);
            green_line.SetAttributeValue("y1", rectangle_y - 18);
            green_line.SetAttributeValue("y2", rectangle_y + 5);
            green_line.SetAttributeValue("style", "stroke:rgb(0,0,0);stroke-width:0.5");

            var green_line_text1 = new XElement("text");
            var green_line_text2 = new XElement("text");
            green_line_text1.Value = "practices";
            green_line_text1.SetAttributeValue("x", rectangle_x + 15);
            green_line_text1.SetAttributeValue("y", rectangle_y - 15);
            green_line_text2.Value = "performed";
            green_line_text2.SetAttributeValue("x", rectangle_x + 15);
            green_line_text2.SetAttributeValue("y", rectangle_y - 8);

            var green_circle = new XElement("circle");
            green_circle.SetAttributeValue("cx", rectangle_x + 10);
            green_circle.SetAttributeValue("cy", rectangle_y + 5);
            green_circle.SetAttributeValue("r", 1);

            g.Add(green_line);
            g.Add(green_line_text1);
            g.Add(green_line_text2);
            g.Add(green_circle);


            // practices incompletely perfomed
            var yellow_line = new XElement("line");
            yellow_line.SetAttributeValue("x1", rectangle_x + 15 + segmentWidth);
            yellow_line.SetAttributeValue("x2", rectangle_x + 15 + segmentWidth);
            yellow_line.SetAttributeValue("y1", rectangle_y + 5);
            yellow_line.SetAttributeValue("y2", rectangle_y + 28);
            yellow_line.SetAttributeValue("style", "stroke:rgb(0,0,0);stroke-width:0.5");

            var yellow_circle = new XElement("circle");
            yellow_circle.SetAttributeValue("cx", rectangle_x + 15 + segmentWidth);
            yellow_circle.SetAttributeValue("cy", rectangle_y + 5);
            yellow_circle.SetAttributeValue("r", 1);

            var yellow_line_text1 = new XElement("text");
            var yellow_line_text2 = new XElement("text");
            yellow_line_text1.Value = "practices incompletely";
            yellow_line_text2.Value = "performed";
            yellow_line_text1.SetAttributeValue("x", rectangle_x + 20 + segmentWidth);
            yellow_line_text1.SetAttributeValue("y", rectangle_y + 20);
            yellow_line_text2.SetAttributeValue("x", rectangle_x + 20 + segmentWidth);
            yellow_line_text2.SetAttributeValue("y", rectangle_y + 28);


            g.Add(yellow_line);
            g.Add(yellow_circle);
            g.Add(yellow_line_text1);
            g.Add(yellow_line_text2);


            // practices not perfomed
            var red_line = new XElement("line");
            red_line.SetAttributeValue("x1", rectangle_x + 15 + segmentWidth * 2);
            red_line.SetAttributeValue("x2", rectangle_x + 15 + segmentWidth * 2);
            red_line.SetAttributeValue("y1", rectangle_y - 18);
            red_line.SetAttributeValue("y2", rectangle_y + 5);
            red_line.SetAttributeValue("style", "stroke:rgb(0,0,0);stroke-width:0.5");

            var red_circle = new XElement("circle");
            red_circle.SetAttributeValue("cx", rectangle_x + 15 + segmentWidth * 2);
            red_circle.SetAttributeValue("cy", rectangle_y + 5);
            red_circle.SetAttributeValue("r", 1);

            var red_line_text1 = new XElement("text");
            var red_line_text2 = new XElement("text");
            red_line_text1.Value = "practices not";
            red_line_text2.Value = "performed";
            red_line_text1.SetAttributeValue("x", rectangle_x + 20 + segmentWidth * 2);
            red_line_text1.SetAttributeValue("y", rectangle_y - 15);
            red_line_text2.SetAttributeValue("x", rectangle_x + 20 + segmentWidth * 2);
            red_line_text2.SetAttributeValue("y", rectangle_y - 8);

            g.Add(red_line);
            g.Add(red_line_text1);
            g.Add(red_line_text2);
            g.Add(red_circle);



            // percentage of yes answers
            var yes_line_text1 = new XElement("text");
            var yes_line_text2 = new XElement("text");
            yes_line_text1.Value = "percentage of";
            yes_line_text2.Value = "yes answers";
            yes_line_text1.SetAttributeValue("x", rectangle_x - 5);
            yes_line_text1.SetAttributeValue("y", rectangle_y + 24);
            yes_line_text2.SetAttributeValue("x", rectangle_x - 5);
            yes_line_text2.SetAttributeValue("y", rectangle_y + 32);


            var yes_line = new XElement("line");
            var yes_line2 = new XElement("line");
            yes_line.SetAttributeValue("x1", rectangle_x + 20);
            yes_line.SetAttributeValue("x2", rectangle_x + 45);
            yes_line.SetAttributeValue("y1", rectangle_y + 15);
            yes_line.SetAttributeValue("y2", rectangle_y + 15);
            yes_line.SetAttributeValue("style", "stroke:rgb(0,0,0);stroke-width:0.5");
            yes_line2.SetAttributeValue("x1", rectangle_x + 10);
            yes_line2.SetAttributeValue("x2", rectangle_x + 20);
            yes_line2.SetAttributeValue("y1", rectangle_y + 17);
            yes_line2.SetAttributeValue("y2", rectangle_y + 15);
            yes_line2.SetAttributeValue("style", "stroke:rgb(0,0,0);stroke-width:0.5");

            var yes_circle = new XElement("circle");
            yes_circle.SetAttributeValue("cx", rectangle_x + 45);
            yes_circle.SetAttributeValue("cy", rectangle_y + 15);
            yes_circle.SetAttributeValue("r", 1);

            var number = new XElement("text");
            number.Value = "33%";
            number.SetAttributeValue("x", rectangle_x + 50);
            number.SetAttributeValue("y", rectangle_y + 18);
            number.SetAttributeValue("style", "font-weight: bold;");

            g.Add(yes_line_text1);
            g.Add(yes_line_text2);
            g.Add(yes_line);
            g.Add(yes_line2);
            g.Add(yes_circle);
            g.Add(number);


            // configuration "1" renders the Not Applicable bar and a full explanation
            if (configuration == "1")
            {
                AddNaBar(g);
                AddNaText(g, "full");
            }

            // configuration "2" renders the Not Applicable bar and a one-line explanation
            if (configuration == "2")
            {
                AddNaBar(g);
                AddNaText(g, "short");
            }


            _xSvg.Add(g);
        }


        /// <summary>
        /// 
        /// </summary>
        private void AddNaBar(XElement g)
        {
            var barNA = new XElement("rect");
            barNA.SetAttributeValue("x", barsX);
            barNA.SetAttributeValue("y", 65);
            barNA.SetAttributeValue("fill", "#aaaaaa");
            barNA.SetAttributeValue("height", 10);
            barNA.SetAttributeValue("width", _svgWidth - barsX);
            barNA.SetAttributeValue("class", "bar-na");
            g.Add(barNA);

            var na_text = new XElement("text");
            na_text.Value = "Not Applicable";
            na_text.SetAttributeValue("x", ((_svgWidth - barsX) / 2.0) + barsX);
            na_text.SetAttributeValue("y", 70);
            na_text.SetAttributeValue("dominant-baseline", "middle");
            na_text.SetAttributeValue("text-anchor", "middle");
            na_text.SetAttributeValue("fill", "#000000");
            g.Add(na_text);
        }


        /// <summary>
        /// Add text below the gray Not Applicable bar.  
        /// "Short" mode adds a one-liner.
        /// </summary>
        /// <param name="g"></param>
        private void AddNaText(XElement g, string mode)
        {
            List<string> naText = new()
            {
                "The Incident Management Review (IMR) has as its focus incident handling and response, and",
                "as such is not designed to directly map to all of the Cybersecurity Framework (CSF) categories",
                "and sub-categories. A companion product, the Cyber Resilience Review (CRR) which is",
                "intended as a comprehensive cybersecurity assessment tool, does map to all of the CSF."
            };

            if (mode == "short")
            {
                naText = new()
            {
                "Please see legend of the NIST Cybersecurity Framework Summary Page."
            };
            }

            var y = 75;

            naText.ForEach(t =>
            {
                var xNA = new XElement("text");
                xNA.Value = t;
                xNA.SetAttributeValue("x", barsX);
                xNA.SetAttributeValue("y", y += 10);
                g.Add(xNA);
            });

            _xSvg.SetAttributeValue("height", y += 10);
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
