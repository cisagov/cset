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
using CSETWebCore.DataLayer.Model;
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
        /// REQUIREMENT_REFERENCES, respectively.
        /// </summary>
        /// <param name="requirementId"></param>
        /// <param name="controlContext"></param>
        public void BuildReferenceDocuments(int requirementId,
            out List<ReferenceDocLink> sourceDocList,
            out List<ReferenceDocLink> additionalDocList)
        {
            // Source Documents  
            var q1 = _context.REQUIREMENT_REFERENCES
                .Include(x => x.Gen_File)
                .Where(s => s.Requirement_Id == requirementId && s.Source)
                .Select(s => new GenFileView { File_Id = s.Gen_File_Id, Title = s.Gen_File.Title, File_Name = s.Gen_File.File_Name, Section_Ref = s.Section_Ref, Destination_String = s.Destination_String, Is_Uploaded = s.Gen_File.Is_Uploaded, Sequence = s.Sequence });

            sourceDocList = SortList(q1);


            // Additional Resource Documents
            var q2 = _context.REQUIREMENT_REFERENCES
                .Include(x => x.Gen_File)
                .Where(s => s.Requirement_Id == requirementId && !s.Source)
                .OrderBy(s => s.Sequence)
                .Select(s => new GenFileView { File_Id = s.Gen_File_Id, Title = s.Gen_File.Title, File_Name = s.Gen_File.File_Name, Section_Ref = s.Section_Ref, Destination_String = s.Destination_String, Is_Uploaded = s.Gen_File.Is_Uploaded, Sequence = s.Sequence });

            additionalDocList = SortList(q2);
        }


        /// <summary>
        /// Builds lists of Source Documents and Additional Resource) Document references for the question.
        /// </summary>
        /// <param name="maturityQuestion_ID"></param>
        /// <param name="controlContext"></param>
        public void BuildRefDocumentsForMaturityQuestion(int maturityQuestion_ID,
             out List<ReferenceDocLink> sourceDocList,
            out List<ReferenceDocLink> additionalDocList)
        {
            // Source Documents  
            var q1 = _context.MATURITY_REFERENCES
                .Include(x => x.Gen_File)
                .Where(s => s.Mat_Question_Id == maturityQuestion_ID && s.Source)
                .Select(s => new GenFileView { File_Id = s.Gen_File_Id, Title = s.Gen_File.Title, File_Name = s.Gen_File.File_Name, File_Type_Id = s.Gen_File.File_Type_Id ?? 0, Section_Ref = s.Section_Ref, Destination_String = s.Destination_String, Is_Uploaded = s.Gen_File.Is_Uploaded, Sequence = s.Sequence });

            sourceDocList = SortList(q1);


            // Additional Resource Documents
            var q2 = _context.MATURITY_REFERENCES
                .Include(x => x.Gen_File)
                .Where(s => s.Mat_Question_Id == maturityQuestion_ID && !s.Source)
                .OrderBy(s => s.Sequence)
                .Select(s => new GenFileView { File_Id = s.Gen_File_Id, Title = s.Gen_File.Title, File_Name = s.Gen_File.File_Name, File_Type_Id = s.Gen_File.File_Type_Id ?? 0, Section_Ref = s.Section_Ref, Destination_String = s.Destination_String, Is_Uploaded = s.Gen_File.Is_Uploaded, Sequence = s.Sequence });

            additionalDocList = SortList(q2);
        }


        /// <summary>
        /// Arranges the list with sequenced entries up front (orderd by sequence)
        /// and any non-sequenced entries after that.
        /// 
        /// Documents without a filename are allowed because they will be displayed as plain text but with
        /// no links rendered.  This will allow us to list references to documents that are not onboard in CSET
        /// but the user could look up on their own. 
        /// </summary>
        private List<ReferenceDocLink> SortList(IQueryable<GenFileView> docList)
        {
            var sorted = docList.Where(x => x.Sequence != null).OrderBy(x => x.Sequence).ToList();
            sorted.AddRange(docList.Where(x => x.Sequence == null));


            var outList = new List<ReferenceDocLink>();
            foreach (var doc in sorted)
            {
                var docLink = new ReferenceDocLink()
                {
                    FileId = doc.File_Id,
                    FileName = doc.File_Name,
                    Url = doc.Url,
                    Title = doc.Title,
                    SectionRef = doc.Section_Ref,
                    DestinationString = doc.Destination_String,
                };


                // special case for URLs - populate URL field with file_name from GEN_FILE
                if (doc.File_Type_Id == 45)
                {
                    docLink.Url = doc.File_Name;
                    docLink.FileName = null;
                }


                outList.Add(docLink);
            }

            return outList;
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

                return [];
            }
        }
    }
}
