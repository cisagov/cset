using System.Collections.Generic;

namespace CSETWebCore.Model.Acet
{
    public class IRPHeader
    {
        public string header;
        public List<IRPModel> irpList;

        public IRPHeader() { irpList = new List<IRPModel>(); }
    }
}