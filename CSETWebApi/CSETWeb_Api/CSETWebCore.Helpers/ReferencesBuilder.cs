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
using CSETWebCore.Model.Question;

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
        /// </summary>
        /// <param name="maturityQuestion_ID"></param>
        /// <param name="controlContext"></param>
        public void BuildDocumentsForMaturityQuestion(int maturityQuestion_ID,
             out List<CustomDocument> sourceDocList,
            out List<CustomDocument> additionalDocList)
        {
            List<string> availableRefDocs = GetBuildDocuments();

            var documents = _context.MATURITY_SOURCE_FILES.Where(s => s.Mat_Question_Id == maturityQuestion_ID).Select(s => new { s.Gen_File.Gen_File_Id, s.Gen_File.Title, s.Gen_File.File_Name, s.Section_Ref, IsSource = true, s.Gen_File.Is_Uploaded })
                .Concat(
              _context.MATURITY_REFERENCES.Where(s => s.Mat_Question_Id == maturityQuestion_ID).Select(s => new { s.Gen_File.Gen_File_Id, s.Gen_File.Title, s.Gen_File.File_Name, s.Section_Ref, IsSource = false, s.Gen_File.Is_Uploaded })
              ).ToList();

            // Source Documents  
            var sourceDocuments = documents.Where(t => t.IsSource)
                .Select(s => new CustomDocument() { File_Id = s.Gen_File_Id, Title = s.Title, File_Name = s.File_Name, Section_Ref = s.Section_Ref, Is_Uploaded = s.Is_Uploaded ?? false })
                .ToList();
            sourceDocList = sourceDocuments.Where(d => availableRefDocs.Contains(d.File_Name) || d.Is_Uploaded).ToList();


            // Additional Resource Documents
            var additionalDocuments = documents.Where(t => !t.IsSource)
               .Select(s => new CustomDocument() { File_Id = s.Gen_File_Id, Title = s.Title, File_Name = s.File_Name, Section_Ref = s.Section_Ref, Is_Uploaded = s.Is_Uploaded ?? false })
               .ToList();
            additionalDocList = additionalDocuments.Where(d => availableRefDocs.Contains(d.File_Name) || d.Is_Uploaded).ToList();
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
    }
}
