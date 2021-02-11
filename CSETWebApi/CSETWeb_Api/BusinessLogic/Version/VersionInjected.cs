//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Version
{
    public class VersionInjected
    {
        public static String VersionString
        {
            get;
            set;
        }
        public static System.Version Version { get; set; }
    }
}
