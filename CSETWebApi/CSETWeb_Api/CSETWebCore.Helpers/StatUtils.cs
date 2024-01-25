//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Model.Maturity;

namespace CSETWebCore.Helpers
{
    public class StatUtils
    {
        public static double Percentagize(double numerator, double denominator, int decimals)
        {
            return Math.Round((numerator / (denominator == 0 ? 1 : denominator)) * 100, decimals);
        }

        public static double Percentagize(double numerator, double denominator)
        {
            return Percentagize(numerator, denominator, 0);
        }
        internal static String PercentagizeAsString(double numerator, double denominator)
        {
            return Percentagize(numerator, denominator, 0).ToString();
        }

        internal static double MakePercent(decimal areasPercent)
        {
            return Math.Round((double)areasPercent * 100);
        }
        internal static double MakePercent(double areasPercent)
        {
            return Math.Round(areasPercent * 100);
        }

        internal static double MakePercentwithTest(double areasPercent)
        {
            if (areasPercent > 1)
                return areasPercent;
            else
                return Math.Round(areasPercent * 100);
        }


        /// <summary>
        /// Calculates the distribution of a list of strings.
        /// Useful for building answer distribution charts.
        /// </summary>
        /// <param name="list"></param>
        /// <returns></returns>
        public static List<DistribItem> CalculateDistribution(List<string> list)
        {
            List<DistribItem> distribList = new List<DistribItem>();
            var distinctValues = list.Distinct();

            foreach (string v in distinctValues)
            {
                var item = new DistribItem();
                item.Value = v;
                item.Count = list.Count(x => x == v);
                item.Percent = 100.0 * (double)item.Count / (double)list.Count();

                distribList.Add(item);
            }

            return distribList;
        }
    }
}


