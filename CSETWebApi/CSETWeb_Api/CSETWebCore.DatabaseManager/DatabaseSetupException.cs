//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;

namespace CSETWebCore.DatabaseManager
{
    public class DatabaseSetupException : Exception
    {
        public DatabaseSetupException() 
        { 
        }

        public DatabaseSetupException(string message) : base(message) 
        { 
        }

        public DatabaseSetupException(string message, Exception inner) : base(message, inner)
        { 
        }
    }
}
