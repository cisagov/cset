using System.Collections.Generic;

namespace CSETWebCore.Model.Acet
{
    public class IRPResponse
    {
        public List<IRPHeader> headerList;
        public IRPResponse() { headerList = new List<IRPHeader>(); }
    }
}