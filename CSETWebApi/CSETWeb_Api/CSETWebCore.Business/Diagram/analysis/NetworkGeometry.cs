//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Drawing;
using System.Xml;

namespace CSETWebCore.Business.Diagram.Analysis
{
    public class NetworkGeometry
    {

        public Point point { get; private set; }
        public int Width { get; private set; }
        public int Height { get; private set; }
        public string AS { get; private set; }

        public NetworkGeometry(XmlNode node)
        {
            if (node == null)
            {
                return;
            }

            int x = 0;
            int y = 0;
            int.TryParse(node.Attributes["x"]?.Value, out x);
            int.TryParse(node.Attributes["y"]?.Value, out y);

            point = new Point(x, y);
            int width, height;

            if (int.TryParse(node.Attributes["width"]?.Value, out width))
            {
                Width = width;
            }
            if (int.TryParse(node.Attributes["height"]?.Value, out height))
            {
                Height = height;
            }
            AS = node.Attributes["as"].Value;
        }

        public Point GetMidPoint(Point b)
        {
            return new Point((this.point.X + b.X) / 2, (this.point.Y + b.Y) / 2);
        }
    }
}