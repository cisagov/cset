using System;

namespace CSETWebCore.Business.Merit
{   
    internal class MERITApplicationException:ApplicationException
    {
        public MERITApplicationException(string message) : base(message)
        {
        }

        public string Path { get; set; }
    }
}