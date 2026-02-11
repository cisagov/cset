////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using System.Collections.Generic;

namespace CSETWebCore.Model.Document
{
    public class MergeDocuments
    {
        public MergeDocuments() { }

        public MergeDocuments(int assessmentId, List<DocumentWithAnswerId> documents)
        {
            this.assessmentId = assessmentId;
            this.documents = documents;
        }


        public int assessmentId { get; set; }
        public List<DocumentWithAnswerId> documents { get; set; }
    }
}
