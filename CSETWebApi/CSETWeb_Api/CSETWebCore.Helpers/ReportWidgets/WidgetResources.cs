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
    public class WidgetResources
    {
        /// <summary>
        /// Map generic color words to our specific colors
        /// </summary>
        public static Dictionary<string, string> ColorMap
        {
            get
            {
                return new Dictionary<string, string>()
                {
                    { "green", "#28A745" },
                    { "yellow", "#FFC107"},
                    { "red", "#DC3545"},
                    { "unanswered-gray", "#6C757D" },
                    { "parent-gray", "#d0d0d0" },
                    { "placeholder-gray", "#e0e0e0"}
                };
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="c"></param>
        /// <returns></returns>
        public static string GetTextColor(string c)
        {
            // We have a few bar colors that we know we want white text
            if (c == "red" || c == "green" || c == "unanswered-gray")
            {
                return "#fff";
            }

            return "#000";
        }


        /// <summary>
        /// Calculates the luminance of the background color and returns
        /// the contrasting text color.
        /// Not being used presently, but could be if we want to.
        /// </summary>
        /// <param name="bgColor"></param>
        /// <returns></returns>
        private static string TextColorForBackground(string bgColor)
        {
            // To change the cutoff, tweak this
            var threshold = 0.179;

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
            return (luminance > threshold) ? "#000000" : "#FFFFFF";
        }


        /// <summary>
        /// Modifies an existing translate() attribute or creates a new one.
        /// </summary>
        /// <param name="o"></param>
        /// <param name="x"></param>
        /// <param name="y"></param>
        public static void TranslateObject(XElement o, float x, float y)
        {
            var attrib = o.Attribute("transform");
            if (attrib == null)
            {
                o.SetAttributeValue("transform", $"translate({x}, {y})");
            }
            else
            {
                attrib.Value = attrib.Value + $" translate({x}, {y})";
            }
        }


        /// <summary>
        /// Parses the Goal label for the goal strip
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        public static string GLabel(string s)
        {
            var cloc = s.LastIndexOf(":");
            if (cloc < 0)
            {
                return s;
            }

            return s.Substring(cloc + 1);
        }


        /// <summary>
        /// Parses the Question label for the block.
        /// </summary>
        /// <returns></returns>
        public static string QLabel(string s)
        {
            var qloc = s.LastIndexOf("Q");
            if (qloc < 0)
            {
                return s;
            }

            var s1 = s.Substring(qloc);

            var dloc = s1.LastIndexOf("-");
            if (dloc < 0)
            {
                // not a child question
                return s1;
            }

            // child question
            return s1.Substring(1, dloc - 1) + s1.Substring(dloc + 1);
        }
    }
}
