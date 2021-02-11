//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;

namespace CSET_Main.Analysis.Analyzers
{
    class StatUtils {
        internal static double Percentagize(double numerator, double denominator, int decimals) {
            return Math.Round((numerator / (denominator == 0 ? 1 : denominator)) * 100, decimals);
        }

        internal static double Percentagize(double numerator, double denominator) {
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
    }
}


