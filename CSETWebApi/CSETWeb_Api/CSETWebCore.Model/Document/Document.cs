//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using System;

namespace CSETWebCore.Model.Document
{
    public class Document
    {
        /// <summary>
        /// 
        /// </summary>
        public int Document_Id { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string Title { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string FileName { get; set; }

        /// <summary>
        /// Indicates a document that has been marked as shared,
        /// so it can be seen outside of an assessment and eventually
        /// easily attached to other assessments.
        /// 
        /// This maps to the IsGlobal column of the DOCUMENT_FILE database table.
        /// </summary>
        public Boolean IsShared { get; set; }
    }
}