using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using System.Linq;
using CSETWeb_Api.BusinessLogic.Models;
using DataLayerCore.Model;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers
{
    /// <summary>
    /// Manages data related to required documentation for ACET assessments.
    /// </summary>
    public class RequiredDocumentationManager
    {
        /// <summary>
        /// Returns a list of all available required documentation with the answers provided for the specified assessment.
        /// </summary>
        /// <param name="assessmentId">id of the assessment being looked up.</param>
        /// <returns>all required documentation and a Y/N/NA answer for each, defaulting to N</returns>
        public RequiredDocumentationResponse GetRequiredDocuments(int assessmentId)
        {
            RequiredDocumentationResponse response = new RequiredDocumentationResponse();

            using (var db = new CSET_Context())
            {
                foreach (REQUIRED_DOCUMENTATION_HEADERS header in db.REQUIRED_DOCUMENTATION_HEADERS.OrderBy(h => h.Header_Order))
                {
                    RequiredDocumentHeader tempHeader = new RequiredDocumentHeader()
                    {
                        documents = new List<RequiredDocument>(),
                        Header = header.Requirement_Documentation_Header
                    };
                    foreach (REQUIRED_DOCUMENTATION doc in db.REQUIRED_DOCUMENTATION
                        .Where(d => d.RDH_.RDH_Id == header.RDH_Id)
                        .OrderBy(d => d.Document_Order))
                    {
                        RequiredDocument tempDoc = new RequiredDocument()
                        {
                            DocId = doc.Documentation_Id,
                            Number = doc.Number,
                            Document_Description = doc.Document_Description
                        };

                        ASSESSMENTS_REQUIRED_DOCUMENTATION answer = db.ASSESSMENTS_REQUIRED_DOCUMENTATION.FirstOrDefault(ard => ard.Assessment_Id == assessmentId && ard.Documentation_Id == doc.Documentation_Id);
                        if (answer == null)
                        {
                            tempDoc.Answer = "N";
                            db.ASSESSMENTS_REQUIRED_DOCUMENTATION.Add(new ASSESSMENTS_REQUIRED_DOCUMENTATION()
                            {
                                Answer = "N",
                                Assessment_Id = assessmentId,
                                Documentation_Id = doc.Documentation_Id,
                                Comment = ""
                            });
                        }
                        else
                        {
                            tempDoc.Answer = answer.Answer;
                            tempDoc.Comment = answer.Comment;
                        }

                        tempHeader.documents.Add(tempDoc);
                    }
                    response.headerList.Add(tempHeader);
                }
                db.SaveChanges();
            }
            return response;
        }

        public void PersistSelectedRequiredDocuments(int assessmentId, RequiredDocument reqDoc)
        {
            if (reqDoc == null || reqDoc.DocId == 0) { return; }
            if (assessmentId == 0) { return; }
            using (var db = new CSET_Context())
            {
                ASSESSMENTS_REQUIRED_DOCUMENTATION ard = db.ASSESSMENTS_REQUIRED_DOCUMENTATION.FirstOrDefault(a =>
                    a.Assessment_Id == assessmentId && a.Documentation_Id == reqDoc.DocId);
                if (ard == null)
                {
                    ard = new ASSESSMENTS_REQUIRED_DOCUMENTATION()
                    {
                        Assessment_Id = assessmentId,
                        Documentation_Id = reqDoc.DocId,
                        Answer = reqDoc.Answer,
                        Comment = reqDoc.Comment
                    };
                    db.ASSESSMENTS_REQUIRED_DOCUMENTATION.Add(ard);
                }
                else
                {
                    ard.Answer = reqDoc.Answer;
                    ard.Comment = reqDoc.Comment;
                }
                db.SaveChanges();
            }
        }
    }
}
