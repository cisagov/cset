using System.Collections.Generic;

namespace CSETWebCore.Model.Document
{
    public class QuestionDocumentsPair
    {
        public QuestionDocumentsPair() { }

        public int questionId { get; set; }
        public List<DocumentWithAnswerId> docList { get; set; }
    }
}
