//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Question;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.Helpers
{
    public class ReferencesBuilder
    {

        private readonly CSETContext _context;


        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="context"></param>
        public ReferencesBuilder(CSETContext context)
        {
            _context = context;
        }


        /// <summary>
        /// Populates sourceDocList and additionalDocList with any connections from 
        /// REQUIREMENT_SOURCE_FILES and REQUIREMENT_REFERENCES, respectively.
        /// </summary>
        /// <param name="requirement_ID"></param>
        /// <param name="controlContext"></param>
        public void BuildReferenceDocuments(int requirement_ID,
            out List<CustomDocument> sourceDocList,
            out List<CustomDocument> additionalDocList)
        {
            // Build a list of available documents

            List<string> availableRefDocs = GetBuildDocuments();

            var documents = _context.REQUIREMENT_SOURCE_FILES.Where(s => s.Requirement_Id == requirement_ID)
                .Select(s => new { s.Gen_File.Gen_File_Id, s.Gen_File.Title, s.Gen_File.File_Name, s.Section_Ref, IsSource = true, s.Gen_File.Is_Uploaded })
                .Concat(
                    _context.REQUIREMENT_REFERENCES.Where(s => s.Requirement_Id == requirement_ID).Select(s => new { s.Gen_File.Gen_File_Id, s.Gen_File.Title, s.Gen_File.File_Name, s.Section_Ref, IsSource = false, s.Gen_File.Is_Uploaded })
                ).ToList();

            // Source Documents        
            var sourceDocuments = documents.Where(t => t.IsSource)
                .Select(s => new CustomDocument { File_Id = s.Gen_File_Id, Title = s.Title, File_Name = s.File_Name, Section_Ref = s.Section_Ref, Is_Uploaded = s.Is_Uploaded ?? false });
            sourceDocList = sourceDocuments.Where(d => availableRefDocs.Contains(d.File_Name) || d.Is_Uploaded).ToList();


            // Additional Resource Documents
            var additionalDocuments = documents.Where(t => !t.IsSource)
                .Select(s => new CustomDocument { File_Id = s.Gen_File_Id, Title = s.Title, File_Name = s.File_Name, Section_Ref = s.Section_Ref, Is_Uploaded = s.Is_Uploaded ?? false });
            additionalDocList = additionalDocuments.Where(d => availableRefDocs.Contains(d.File_Name) || d.Is_Uploaded).ToList();
        }


        /// <summary>
        /// Builds lists of Source Documents and Additional Resource) Document references for the question.
        /// 
        /// Documents without a filename are allowed because they will be displayed as flat tet but with
        /// no links rendered.  This will allow references to documents that are not onboard in CSET
        /// but the user could look up on their own.
        /// </summary>
        /// <param name="maturityQuestion_ID"></param>
        /// <param name="controlContext"></param>
        public void BuildDocumentsForMaturityQuestion(int maturityQuestion_ID,
             out List<CustomDocument> sourceDocList,
            out List<CustomDocument> additionalDocList)
        {
            // Create a list of documents we actual have on board, so that we don't build any dead links
            List<string> availableRefDocs = GetBuildDocuments();


            // Source Documents  
            var doc1 = _context.MATURITY_SOURCE_FILES
                .Include(x => x.Gen_File)
                .Where(s => s.Mat_Question_Id == maturityQuestion_ID)
                .Select(s => new { s.Gen_File.Gen_File_Id, s.Gen_File.Title, s.Gen_File.File_Name, s.Section_Ref, s.Gen_File.Is_Uploaded });
            var sourceDocuments = doc1
                .Select(s => new CustomDocument() { File_Id = s.Gen_File_Id, Title = s.Title, File_Name = s.File_Name, Section_Ref = s.Section_Ref, Is_Uploaded = s.Is_Uploaded ?? false });
            sourceDocList = sourceDocuments.Where(d => availableRefDocs.Contains(d.File_Name) || d.Is_Uploaded || string.IsNullOrEmpty(d.File_Name)).ToList();


            // Additional Resource Documents
            var doc2 = _context.MATURITY_REFERENCES
                .Include(x => x.Gen_File)
                .Where(s => s.Mat_Question_Id == maturityQuestion_ID)
                .Select(s => new { s.Gen_File_Id, s.Gen_File.Title, s.Gen_File.File_Name, s.Section_Ref, s.Gen_File.Is_Uploaded });
            var additionalDocuments = doc2
               .Select(s => new CustomDocument() { File_Id = s.Gen_File_Id, Title = s.Title, File_Name = s.File_Name, Section_Ref = s.Section_Ref, Is_Uploaded = s.Is_Uploaded ?? false });
            additionalDocList = additionalDocuments.Where(d => availableRefDocs.Contains(d.File_Name) || d.Is_Uploaded || string.IsNullOrEmpty(d.File_Name)).ToList();
        }


        /// <summary>
        /// Returns any plain text that is stored as a reference for the question.
        /// </summary>
        public List<string> BuildReferenceTextForMaturityQuestion(int maturityQuestion_ID)
        {
            var q = _context.MATURITY_REFERENCE_TEXT
                .Where(x => x.Mat_Question_Id == maturityQuestion_ID)
                .ToList().OrderBy(x => x.Sequence);

            var referenceTextList = new List<string>();
            foreach (var t in q)
            {
                if (t.Reference_Text != null)
                {
                    referenceTextList.Add(t.Reference_Text);
                }
            }

            return referenceTextList;
        }


        /// <summary>
        /// Returns any plain text that is stored as a reference for the requirement.
        /// </summary>
        /// <param name="requirementID"></param>
        public List<string> BuildReferenceTextForRequirement(int requirementID)
        {
            var q = _context.REQUIREMENT_REFERENCE_TEXT
                .Where(x => x.Requirement_Id == requirementID)
                .ToList().OrderBy(x => x.Sequence);

            var referenceTextList = new List<string>();
            foreach (var t in q)
            {
                referenceTextList.Add(t.Reference_Text);
            }

            return referenceTextList;
        }


        /// <summary>
        /// Returns a list of physical files in the Documents folder.
        /// Some installations may not have documents installed to reduce installation overhead.
        /// </summary>
        /// <returns></returns>
        public List<string> GetBuildDocuments()
        {
            var dir = Path.Combine((string)AppDomain.CurrentDomain.GetData("ContentRootPath"), "Documents");

            try
            {
                List<string> availableRefDocs = new DirectoryInfo(dir)
                    .GetFiles()
                    .Select(f => f.Name)
                    .ToList();
                return availableRefDocs;
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                return new List<string>();
            }
        }


        /// <summary>
        /// Returns an object containing source documents, additional documents 
        /// for the questions in a maturity model.
        /// </summary>
        /// <param name="modelId"></param>
        /// <returns></returns>
        public static QuestionReferences GetReferencesForModel(CsetwebContext context, int modelId)
        {
            var qr = new QuestionReferences();

            var _questionIds = context.MATURITY_QUESTIONS.Where(q => q.Maturity_Model_Id == modelId).Select(x => x.Mat_Question_Id).ToList();
            var msf = context.MATURITY_SOURCE_FILES.Where(x => _questionIds.Contains(x.Mat_Question_Id)).Include(x => x.Gen_File).ToList();
            msf.ForEach(x => {
                qr.SourceDocuments.Add(new RefDocument()
                {
                    Title = x.Gen_File.Title,
                    FileName = x.Gen_File.File_Name,
                    SectionRef = x.Section_Ref,
                    QuestionId = x.Mat_Question_Id
                });
            });
            var mr = context.MATURITY_REFERENCES.Where(x => _questionIds.Contains(x.Mat_Question_Id)).Include(x => x.Gen_File).ToList();
            mr.ForEach(x => {
                qr.AddtionalDocuments.Add(new RefDocument()
                {
                    Title = x.Gen_File.Title,
                    FileName = x.Gen_File.File_Name,
                    SectionRef = x.Section_Ref,
                    QuestionId = x.Mat_Question_Id
                });
            });

            return qr;
        }
    }
}
