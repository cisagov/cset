using System.Xml.Linq;

namespace CSETWebCore.Helpers.ReportWidgets
{
    public class MIL1PerformanceSummaryLegend
    {
        private XDocument _xSvgDoc;
        private XElement _xSvg;

        /// <summary>
        /// Constructor
        /// </summary>
        public MIL1PerformanceSummaryLegend()
        {
            _xSvgDoc = new XDocument(new XElement("svg"));
            _xSvg = _xSvgDoc.Root;

            // style tag
            var xStyle = new XElement("style");
            _xSvg.Add(xStyle);
            xStyle.Value = "text {font: .5rem sans-serif;} .bold {font-weight: bold;}";

            _xSvg.SetAttributeValue("height", 60);
            _xSvg.SetAttributeValue("width", 275);


            var g = new XElement("g");

            int rectangle_x = 0;
            int rectangle_y = 25;

            var title = new XElement("text");
            title.Value = "Legend";
            title.SetAttributeValue("x", rectangle_x);
            title.SetAttributeValue("y", rectangle_y + 25);
            title.SetAttributeValue("class", "bold");

            g.Add(title);

            // Green
            var green = new XElement("rect");
            green.SetAttributeValue("x", rectangle_x);
            green.SetAttributeValue("y", rectangle_y);
            green.SetAttributeValue("fill", WidgetResources.ColorMap["green"]);
            green.SetAttributeValue("height", 10);
            green.SetAttributeValue("width", 88.33);

            var green_text = new XElement("text");
            green_text.Value = "7";
            green_text.SetAttributeValue("x", rectangle_x + 88.33 / 2);
            green_text.SetAttributeValue("y", rectangle_y + 10 / 2);
            green_text.SetAttributeValue("dominant-baseline", "middle");
            green_text.SetAttributeValue("text-anchor", "middle");
            green_text.SetAttributeValue("fill", "white");
            green_text.SetAttributeValue("class", "text");

            g.Add(green);
            g.Add(green_text);


            // Yellow
            var yellow = new XElement("rect");
            yellow.SetAttributeValue("x", rectangle_x + 88.33);
            yellow.SetAttributeValue("y", rectangle_y);
            yellow.SetAttributeValue("fill", WidgetResources.ColorMap["yellow"]);
            yellow.SetAttributeValue("height", 10);
            yellow.SetAttributeValue("width", 88.33);

            var yellow_text = new XElement("text");
            yellow_text.Value = "7";
            yellow_text.SetAttributeValue("x", rectangle_x + 88.33 + 88.33 / 2);
            yellow_text.SetAttributeValue("y", rectangle_y + 10 / 2);
            yellow_text.SetAttributeValue("dominant-baseline", "middle");
            yellow_text.SetAttributeValue("text-anchor", "middle");
            yellow_text.SetAttributeValue("fill", "black");
            yellow_text.SetAttributeValue("class", "text");

            g.Add(yellow);
            g.Add(yellow_text);

            // Red
            var red = new XElement("rect");
            red.SetAttributeValue("x", rectangle_x + 88.33 + 88.33);
            red.SetAttributeValue("y", rectangle_y);
            red.SetAttributeValue("fill", WidgetResources.ColorMap["red"]);
            red.SetAttributeValue("height", 10);
            red.SetAttributeValue("width", 91.67);

            var red_text = new XElement("text");
            red_text.Value = "7";
            red_text.SetAttributeValue("x", rectangle_x + 88.33 + 88.33 + 88.33 / 2);
            red_text.SetAttributeValue("y", rectangle_y + 10 / 2);
            red_text.SetAttributeValue("dominant-baseline", "middle");
            red_text.SetAttributeValue("text-anchor", "middle");
            red_text.SetAttributeValue("fill", "white");
            red_text.SetAttributeValue("class", "text");


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
            yellow_line.SetAttributeValue("x1", rectangle_x + 120);
            yellow_line.SetAttributeValue("x2", rectangle_x + 120);
            yellow_line.SetAttributeValue("y1", rectangle_y + 5);
            yellow_line.SetAttributeValue("y2", rectangle_y + 28);
            yellow_line.SetAttributeValue("style", "stroke:rgb(0,0,0);stroke-width:0.5");

            var yellow_line_text1 = new XElement("text");
            var yellow_line_text2 = new XElement("text");
            yellow_line_text1.Value = "practices incompletely";
            yellow_line_text2.Value = "performed";
            yellow_line_text1.SetAttributeValue("x", rectangle_x + 125);
            yellow_line_text1.SetAttributeValue("y", rectangle_y + 20);
            yellow_line_text2.SetAttributeValue("x", rectangle_x + 125);
            yellow_line_text2.SetAttributeValue("y", rectangle_y + 28);

            var yellow_circle = new XElement("circle");
            yellow_circle.SetAttributeValue("cx", rectangle_x + 120);
            yellow_circle.SetAttributeValue("cy", rectangle_y + 5);
            yellow_circle.SetAttributeValue("r", 1);


            g.Add(yellow_line);
            g.Add(yellow_line_text1);
            g.Add(yellow_line_text2);
            g.Add(yellow_circle);


            // practices not perfomed
            var red_line = new XElement("line");
            red_line.SetAttributeValue("x1", rectangle_x + 205);
            red_line.SetAttributeValue("x2", rectangle_x + 205);
            red_line.SetAttributeValue("y1", rectangle_y - 18);
            red_line.SetAttributeValue("y2", rectangle_y + 5);
            red_line.SetAttributeValue("style", "stroke:rgb(0,0,0);stroke-width:0.5");

            var red_line_text1 = new XElement("text");
            var red_line_text2 = new XElement("text");
            red_line_text1.Value = "practices not";
            red_line_text2.Value = "performed";
            red_line_text1.SetAttributeValue("x", rectangle_x + 210);
            red_line_text1.SetAttributeValue("y", rectangle_y - 15);
            red_line_text2.SetAttributeValue("x", rectangle_x + 210);
            red_line_text2.SetAttributeValue("y", rectangle_y - 8);

            var red_circle = new XElement("circle");
            red_circle.SetAttributeValue("cx", rectangle_x + 205);
            red_circle.SetAttributeValue("cy", rectangle_y + 5);
            red_circle.SetAttributeValue("r", 1);

            g.Add(red_line);
            g.Add(red_line_text1);
            g.Add(red_line_text2);
            g.Add(red_circle);

            _xSvg.Add(g);
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
