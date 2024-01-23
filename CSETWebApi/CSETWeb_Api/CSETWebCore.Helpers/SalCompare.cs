//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using CSETWebCore.Enum;

namespace CSETWebCore.Helpers
{
    public class SalCompare
    {
        public static string FindLowestSal(List<string> salList)
        {
            var salNames = System.Enum.GetNames(typeof(SalValues));
            foreach (string s in salNames)
            {
                if (salList.Contains(s))
                {
                    return s;
                }
            }

            return SalValues.L.ToString();
        }
    }
}