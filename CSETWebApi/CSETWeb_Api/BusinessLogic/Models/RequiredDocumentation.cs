using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Models
{
    public class RequiredDocumentationResponse
    {
        /// <summary>
        /// List of available documents, arranged by their header.
        /// </summary>
        public List<RequiredDocumentHeader> headerList = new List<RequiredDocumentHeader>();
    }

    public class RequiredDocumentHeader
    {
        /// <summary>
        /// The actual text of the header.
        /// </summary>
        public string Header;

        /// <summary>
        /// The list of documents that are under this header.
        /// </summary>
        public List<RequiredDocument> documents = new List<RequiredDocument>();
    }

    public class RequiredDocument
    {
        /// <summary>
        /// The ID for this document.
        /// </summary>
        public int DocId;

        /// <summary>
        /// The Doc's number in its list, I think
        /// </summary>
        public string Number;

        /// <summary>
        /// Blurb describing the document.
        /// </summary>
        public string Document_Description;

        /// <summary>
        /// Y / N / NA indicating whether this document is required for the assessment in question.
        /// </summary>
        public string Answer;

        public string Comment;
    }
}
