//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;

namespace UpgradeLibrary.Upgrade
{
    public class DatabaseUpgradeException : Exception
    {
        public DatabaseUpgradeException(string message) : base(message)
        {
        }
    }
}
