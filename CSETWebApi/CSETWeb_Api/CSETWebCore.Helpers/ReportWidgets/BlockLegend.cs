//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Xml.Linq;

namespace CSETWebCore.Helpers.ReportWidgets
{
    /// <summary>
    /// A red yellow green legend showing discreet blocks
    /// for the answer option colors.
    /// </summary>
    public class BlockLegend
    {
        private XDocument _xSvgDoc;
        private XElement _xSvg;

        /// <summary>
        /// Used to create tspan elements, children of text elements
        /// </summary>
        /// <param name="text"></param>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <param name="dy"></param>
        private XElement CreateElement(string text, int x, int? y, string dy)
        {
            var tspan = new XElement("tspan", text, new XAttribute("style", "font-size: .55rem;"));
            tspan.SetAttributeValue("x", x);
            tspan.SetAttributeValue("y", y);
            tspan.SetAttributeValue("dy", dy);
            return tspan;
        }


        /// <summary>
        /// Constructor
        /// </summary>
        public BlockLegend(bool includeGoal = true)
        {
            _xSvgDoc = new XDocument(new XElement("svg"));
            _xSvg = _xSvgDoc.Root;

            _xSvg.SetAttributeValue("height", "40px");
            _xSvg.SetAttributeValue("width", "100%");


            var g = new XElement("g");

            int rectangle_x = 45;
            int rectangle_y = 5;
            var green = new XElement("rect");
            green.SetAttributeValue("x", rectangle_x);
            green.SetAttributeValue("y", rectangle_y);
            green.SetAttributeValue("fill", WidgetResources.ColorMap["green"]);
            green.SetAttributeValue("height", 15);
            green.SetAttributeValue("width", 15);

            var yellow = new XElement("rect");
            yellow.SetAttributeValue("x", rectangle_x + 80);
            yellow.SetAttributeValue("y", rectangle_y);
            yellow.SetAttributeValue("fill", WidgetResources.ColorMap["yellow"]);
            yellow.SetAttributeValue("height", 15);
            yellow.SetAttributeValue("width", 15);


            var red = new XElement("rect");
            red.SetAttributeValue("x", rectangle_x + 205);
            red.SetAttributeValue("y", rectangle_y);
            red.SetAttributeValue("fill", WidgetResources.ColorMap["red"]);
            red.SetAttributeValue("height", 15);
            red.SetAttributeValue("width", 15);

            var title = new XElement("text", CreateElement("Legend", 0, 15, null));

            int colorLegend_x = 65;
            int colorLegend_y = 15;
            var colorLegend = new XElement("text",
            CreateElement("= Performed", colorLegend_x, colorLegend_y, null),
            CreateElement("= Incompletely Performed", colorLegend_x + 80, colorLegend_y, null),
            CreateElement("= Not Performed", colorLegend_x + 205, colorLegend_y, null)
            );


            int questionLegend_x = 35;
            int questionLegend_y = 40;
            var questionLegend = new XElement("text",
            CreateElement("Q1 = Question Number", questionLegend_x, questionLegend_y, null)
            );

            if (includeGoal)
            {
                questionLegend.Add(
                    CreateElement("G1 = Goal Number", questionLegend_x + 105, questionLegend_y, null));
            }

            g.Add(title);
            g.Add(green);
            g.Add(yellow);
            g.Add(red);
            g.Add(colorLegend);
            g.Add(questionLegend);

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
