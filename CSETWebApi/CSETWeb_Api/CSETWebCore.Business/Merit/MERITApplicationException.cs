//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;

namespace CSETWebCore.Business.Merit
{
    internal class MERITApplicationException : ApplicationException
    {
        public MERITApplicationException(string message) : base(message)
        {
        }

        public string Path { get; set; }
    }
}