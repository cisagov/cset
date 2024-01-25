//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
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
        /// <param name="requirementId"></param>
        /// <param name="controlContext"></param>
        public void BuildReferenceDocuments(int requirementId,
            out List<CustomDocument> sourceDocList,
            out List<CustomDocument> additionalDocList)
        {
            // Create a list of documents we actual have on board, so that we don't build any dead links
            List<string> onboardRefDocs = GetBuildDocuments();


            // Source Documents  
            var q1 = _context.REQUIREMENT_SOURCE_FILES
                .Include(x => x.Gen_File)
                .Where(s => s.Requirement_Id == requirementId)
                .Select(s => new CustomDocument { File_Id = s.Gen_File_Id, Title = s.Gen_File.Title, File_Name = s.Gen_File.File_Name, Section_Ref = s.Section_Ref, Is_Uploaded = s.Gen_File.Is_Uploaded ?? false, Sequence = s.Sequence });

            sourceDocList = SortList(q1, onboardRefDocs);


            // Additional Resource Documents
            var q2 = _context.REQUIREMENT_REFERENCES
                .Include(x => x.Gen_File)
                .Where(s => s.Requirement_Id == requirementId)
                .OrderBy(s => s.Sequence)
                .Select(s => new CustomDocument { File_Id = s.Gen_File_Id, Title = s.Gen_File.Title, File_Name = s.Gen_File.File_Name, Section_Ref = s.Section_Ref, Is_Uploaded = s.Gen_File.Is_Uploaded ?? false, Sequence = s.Sequence });

            additionalDocList = SortList(q2, onboardRefDocs);
        }


        /// <summary>
        /// Builds lists of Source Documents and Additional Resource) Document references for the question.
        /// </summary>
        /// <param name="maturityQuestion_ID"></param>
        /// <param name="controlContext"></param>
        public void BuildRefDocumentsForMaturityQuestion(int maturityQuestion_ID,
             out List<CustomDocument> sourceDocList,
            out List<CustomDocument> additionalDocList)
        {
            // Create a list of documents we actual have on board, so that we don't build any dead links
            List<string> onboardRefDocs = GetBuildDocuments();


            // Source Documents  
            var q1 = _context.MATURITY_SOURCE_FILES
                .Include(x => x.Gen_File)
                .Where(s => s.Mat_Question_Id == maturityQuestion_ID)
                .Select(s => new CustomDocument { File_Id = s.Gen_File_Id, Title = s.Gen_File.Title, File_Name = s.Gen_File.File_Name, Section_Ref = s.Section_Ref, Is_Uploaded = s.Gen_File.Is_Uploaded ?? false, Sequence = s.Sequence });

            sourceDocList = SortList(q1, onboardRefDocs);


            // Additional Resource Documents
            var q2 = _context.MATURITY_REFERENCES
                .Include(x => x.Gen_File)
                .Where(s => s.Mat_Question_Id == maturityQuestion_ID)
                .OrderBy(s => s.Sequence)
                .Select(s => new CustomDocument { File_Id = s.Gen_File_Id, Title = s.Gen_File.Title, File_Name = s.Gen_File.File_Name, Section_Ref = s.Section_Ref, Is_Uploaded = s.Gen_File.Is_Uploaded ?? false, Sequence = s.Sequence });

            additionalDocList = SortList(q2, onboardRefDocs);
        }


        /// <summary>
        /// Arranges the list with sequenced entries up front (orderd by sequence)
        /// and any non-sequenced entries after that.
        /// 
        /// Documents without a filename are allowed because they will be displayed as plain text but with
        /// no links rendered.  This will allow us to list references to documents that are not onboard in CSET
        /// but the user could look up on their own. 
        /// </summary>
        private List<CustomDocument> SortList(IQueryable<CustomDocument> q, List<string> onboardRefDocs)
        {
            var list = q
               .Select(s => new CustomDocument() { File_Id = s.File_Id, Title = s.Title, File_Name = s.File_Name, Section_Ref = s.Section_Ref, Is_Uploaded = s.Is_Uploaded, Sequence = s.Sequence });

            var sorted = list.Where(x => x.Sequence != null).OrderBy(x => x.Sequence).ToList();
            sorted.AddRange(list.Where(x => x.Sequence == null));

            return sorted.Where(d => onboardRefDocs.Contains(d.File_Name) || d.Is_Uploaded || string.IsNullOrEmpty(d.File_Name)).ToList();
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
