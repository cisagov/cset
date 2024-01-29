//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;

namespace CSETWebCore.Helpers
{
    public class IRPHelper
    {
        private static HashSet<String> supportedList = new HashSet<string>() { "ACET", "ISE" };

        public static bool UsesIRP(string setOrModelName)
        {
            if (String.IsNullOrWhiteSpace(setOrModelName))
            {
                return false;
            }
            return supportedList.Contains(setOrModelName);
        }
    }
}