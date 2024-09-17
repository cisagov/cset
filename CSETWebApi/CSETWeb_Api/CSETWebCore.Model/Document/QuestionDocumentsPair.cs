using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Document
{
    public class QuestionDocumentsPair
    {
        public QuestionDocumentsPair() { }

        public int questionId { get; set; }
        public List<DocumentWithAnswerId> docList { get; set; }
    }
}
