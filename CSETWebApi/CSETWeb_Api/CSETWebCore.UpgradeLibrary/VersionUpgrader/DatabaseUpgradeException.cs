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

namespace UpgradeLibrary.Upgrade
{
    public class DatabaseUpgradeException : Exception
    {
        public DatabaseUpgradeException(string message) : base(message)
        {
        }
    }
}
