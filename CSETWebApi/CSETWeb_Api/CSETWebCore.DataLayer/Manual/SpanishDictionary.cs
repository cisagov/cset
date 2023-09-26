using CSETWebCore.DataLayer.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.DataLayer.Manual
{
    public class SpanishDictionary
    {
        public SpanishDictionary() { }
        public SpanishQuestionRow questionText { get; set; }
        public MATURITY_GROUPINGS grouping { get; set; }
        public IRP irp { get; set; }
    }
}
