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
            xStyle.Value = "text {font: .75rem sans-serif}";

            _xSvg.SetAttributeValue("height", "100%");
            _xSvg.SetAttributeValue("width", "100%");


            var g = new XElement("g");

            int rectangle_x = 25;
            int rectangle_y = 25;

            var title = new XElement("text");
            title.Value = "Legend";
            title.SetAttributeValue("x", rectangle_x + 5);
            title.SetAttributeValue("y", rectangle_y + 35);

            g.Add(title);

            // Green
            var green = new XElement("rect");
            green.SetAttributeValue("x", rectangle_x);
            green.SetAttributeValue("y", rectangle_y);
            green.SetAttributeValue("fill", WidgetResources.ColorMap["green"]);
            green.SetAttributeValue("height", 15);
            green.SetAttributeValue("width", 190);

            var green_text = new XElement("text");
            green_text.Value = "12";
            green_text.SetAttributeValue("x", rectangle_x + 190 / 2);
            green_text.SetAttributeValue("y", rectangle_y + 15 / 2);
            green_text.SetAttributeValue("dominant-baseline", "middle");
            green_text.SetAttributeValue("text-anchor", "middle");
            green_text.SetAttributeValue("fill", "white");

            g.Add(green);
            g.Add(green_text);


            // Yellow
            var yellow = new XElement("rect");
            yellow.SetAttributeValue("x", rectangle_x + 190);
            yellow.SetAttributeValue("y", rectangle_y);
            yellow.SetAttributeValue("fill", WidgetResources.ColorMap["yellow"]);
            yellow.SetAttributeValue("height", 15);
            yellow.SetAttributeValue("width", 60);

            var yellow_text = new XElement("text");
            yellow_text.Value = "2";
            yellow_text.SetAttributeValue("x", rectangle_x + 190 + 60 / 2);
            yellow_text.SetAttributeValue("y", rectangle_y + 15 / 2);
            yellow_text.SetAttributeValue("dominant-baseline", "middle");
            yellow_text.SetAttributeValue("text-anchor", "middle");
            yellow_text.SetAttributeValue("fill", "black");

            g.Add(yellow);
            g.Add(yellow_text);

            // Red
            var red = new XElement("rect");
            red.SetAttributeValue("x", rectangle_x + 90 + 60);
            red.SetAttributeValue("y", rectangle_y);
            red.SetAttributeValue("fill", WidgetResources.ColorMap["red"]);
            red.SetAttributeValue("height", 15);
            red.SetAttributeValue("width", 70);

            var red_text = new XElement("text");
            red_text.Value = "3";
            red_text.SetAttributeValue("x", rectangle_x + 190 + 60 + 70 / 2);
            red_text.SetAttributeValue("y", rectangle_y + 15 / 2);
            red_text.SetAttributeValue("dominant-baseline", "middle");
            red_text.SetAttributeValue("text-anchor", "middle");
            red_text.SetAttributeValue("fill", "white");


            g.Add(red);
            g.Add(red_text);

            // practices performed
            var green_line = new XElement("line");
            green_line.SetAttributeValue("x1", rectangle_x + 35);
            green_line.SetAttributeValue("x2", rectangle_x + 35);
            green_line.SetAttributeValue("y1", rectangle_y - 20);
            green_line.SetAttributeValue("y2", rectangle_y + 10);
            green_line.SetAttributeValue("style", "stroke:rgb(0,0,0);stroke-width:1");

            var green_line_text = new XElement("text");
            green_line_text.Value = "practices performed";
            green_line_text.SetAttributeValue("x", rectangle_x + 40);
            green_line_text.SetAttributeValue("y", rectangle_y - 15);
            g.Add(green_line);
            g.Add(green_line_text);

            // practices incompletely perfomed
            var yellow_line = new XElement("line");
            yellow_line.SetAttributeValue("x1", rectangle_x + 200);
            yellow_line.SetAttributeValue("x2", rectangle_x + 200);
            yellow_line.SetAttributeValue("y1", rectangle_y + 10);
            yellow_line.SetAttributeValue("y2", rectangle_y + 45);
            yellow_line.SetAttributeValue("style", "stroke:rgb(0,0,0);stroke-width:1");

            var yellow_line_text = new XElement("text");
            yellow_line_text.Value = "practices incompletely performed";
            yellow_line_text.SetAttributeValue("x", rectangle_x + 205);
            yellow_line_text.SetAttributeValue("y", rectangle_y + 35);
            g.Add(yellow_line);
            g.Add(yellow_line_text);


            // practices not perfomed
            var red_line = new XElement("line");
            red_line.SetAttributeValue("x1", rectangle_x + 315);
            red_line.SetAttributeValue("x2", rectangle_x + 315);
            red_line.SetAttributeValue("y1", rectangle_y - 20);
            red_line.SetAttributeValue("y2", rectangle_y + 10);
            red_line.SetAttributeValue("style", "stroke:rgb(0,0,0);stroke-width:1");

            var red_line_text = new XElement("text");
            red_line_text.Value = "practices not performed";
            red_line_text.SetAttributeValue("x", rectangle_x + 185);
            red_line_text.SetAttributeValue("y", rectangle_y - 15);
            g.Add(red_line);
            g.Add(red_line_text);

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
