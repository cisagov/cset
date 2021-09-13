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
                    { "unanswered-gray", "#a0a0a0" },
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
            if (c == "red" || c == "green")
            {
                return "#fff";
            }

            return "#000";
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
