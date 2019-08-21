//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Runtime.Serialization;

namespace CSETWeb_Api.BusinessManagers
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

        protected NodeNotFound(SerializationInfo info, StreamingContext context) : base(info, context)
        {
        }
    }
}