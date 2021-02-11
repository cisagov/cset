//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Runtime.Serialization;

namespace CSETWeb_Api.BusinessLogic.Helpers.upload
{
    [Serializable]
    internal class UploadFormException : Exception
    {
        public UploadFormException()
        {
        }

        public UploadFormException(string message) : base(message)
        {
        }

        public UploadFormException(string message, Exception innerException) : base(message, innerException)
        {
        }

        protected UploadFormException(SerializationInfo info, StreamingContext context) : base(info, context)
        {
        }
    }
}