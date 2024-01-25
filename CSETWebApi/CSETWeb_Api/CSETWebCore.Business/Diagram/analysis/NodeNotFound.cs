//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Runtime.Serialization;

namespace CSETWebCore.Business
{
    [Serializable]
    internal class NodeNotFound : Exception
    {
        public NodeNotFound()
        {
        }

        public NodeNotFound(string message) : base(message)
        {
        }

        public NodeNotFound(string message, Exception innerException) : base(message, innerException)
        {
        }

        protected NodeNotFound(SerializationInfo info, StreamingContext context)
        {
        }
    }
}