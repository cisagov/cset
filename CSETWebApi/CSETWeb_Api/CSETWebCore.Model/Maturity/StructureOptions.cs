using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Maturity
{
    public class StructureOptions
    {
        public bool IncludeQuestionText { get; set; } = true;

        public bool IncludeSupplemental { get; set; } = false;

        public bool IncludeOtherText { get; set; } = false;
    }
}
