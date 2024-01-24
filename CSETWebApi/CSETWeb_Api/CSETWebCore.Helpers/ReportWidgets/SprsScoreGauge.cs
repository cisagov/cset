//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Xml.Linq;

namespace CSETWebCore.Helpers.ReportWidgets
{
    public class SprsScoreGauge
    {
        private XDocument _xSvgDoc;
        private XElement _xSvg;

        private int sprsMin = -203;
        private int sprsMax = 110;

        private double barThickness = 20;

        string gradientDef = "<linearGradient id=\"grad1\" x1=\"0%\" y1=\"0%\" x2=\"100%\" y2=\"0%\">" +
            "<stop offset = \"0%\" style=\"stop-color:#333;stop-opacity:1\"></stop>" +
            "<stop offset = \"100%\" style=\"stop-color:#090;stop-opacity:1\"></stop>" +
            "</linearGradient>";

        /// <summary>
        /// 
        /// </summary>
        /// <param name="score"></param>
        public SprsScoreGauge(double score, double width, double height)
        {
            _xSvgDoc = new XDocument(new XElement("svg"));
            _xSvg = _xSvgDoc.Root;
            _xSvg.SetAttributeValue("viewBox", $"0 0 {width + 50} {height}");

            // style tag
            var xStyle = new XElement("style");
            _xSvg.Add(xStyle);
            xStyle.Value = ".sprs-score-value { font-weight: bold; fill: #000; }";

            var xDefs = new XElement("defs");
            _xSvg.Add(xDefs);
            xDefs.Add(XElement.Parse(gradientDef));



            var g = new XElement("g");
            _xSvg.Add(g);
            g.SetAttributeValue("transform", $"translate(20, 0)");


            var gBar = new XElement("g");
            g.Add(gBar);

            var xRect1 = new XElement("rect");
            gBar.Add(xRect1);
            xRect1.SetAttributeValue("fill", "#333");
            xRect1.SetAttributeValue("height", $"{barThickness}");
            xRect1.SetAttributeValue("width", $"{width * .25}");

            var xRect2 = new XElement("rect");
            gBar.Add(xRect2);
            xRect2.SetAttributeValue("fill", "url(#grad1)");
            xRect2.SetAttributeValue("height", $"{barThickness}");
            xRect2.SetAttributeValue("width", $"{width * .75}");
            xRect2.SetAttributeValue("transform", $"translate({width * .25}, 0)");

            // midpoint tick
            var xMid = new XElement("line");
            xMid.SetAttributeValue("x1", $"{width / 2.0}");
            xMid.SetAttributeValue("y1", "-10");
            xMid.SetAttributeValue("x2", $"{width / 2.0}");
            xMid.SetAttributeValue("y2", $"{barThickness}");
            xMid.SetAttributeValue("stroke", "#666");
            gBar.Add(xMid);



            // triangle
            var xTriangle = new XElement("polygon");
            gBar.Add(xTriangle);
            xTriangle.SetAttributeValue("points", "0,20 5,30 -5,30");
            xTriangle.SetAttributeValue("fill", "#333");
            var scoreOffset = CalcScoreOffset(score, width);
            xTriangle.SetAttributeValue("transform", $"translate({scoreOffset}, 0)");

            // actual score
            var xScore = new XElement("text");
            gBar.Add(xScore);
            xScore.Value = $"{score}";
            xScore.SetAttributeValue("class", "sprs-score-value");
            xScore.SetAttributeValue("text-anchor", "middle");
            xScore.SetAttributeValue("transform", $"translate({scoreOffset}, {barThickness + 30})");



            gBar.SetAttributeValue("transform", "translate(0, 20)");


            // top text group (min & max)
            var gText = new XElement("g");
            g.Add(gText);
            gText.SetAttributeValue("transform", "translate(0, 12)");

            var xMinScore = new XElement("text");
            gText.Add(xMinScore);
            xMinScore.SetAttributeValue("text-anchor", "middle");
            xMinScore.SetAttributeValue("transform", "translate(0,0)");
            xMinScore.Value = $"{sprsMin}";

            var xMaxScore = new XElement("text");
            gText.Add(xMaxScore);
            xMaxScore.SetAttributeValue("text-anchor", "middle");
            xMaxScore.SetAttributeValue("transform", $"translate({width},0)");
            xMaxScore.Value = $"{sprsMax}";
        }


        /// <summary>
        /// Returns the x-offset for the score given the bar width
        /// </summary>
        /// <param name="score"></param>
        /// <param name="width"></param>
        /// <returns></returns>
        private double CalcScoreOffset(double score, double width)
        {
            var pointRange = sprsMax - sprsMin;
            var pointOffset = score - sprsMin;
            var percentOffset = pointOffset / pointRange;
            var pixelOffset = width * percentOffset;
            return pixelOffset;
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
