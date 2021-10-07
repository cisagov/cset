using CSETWebCore.DataLayer;
using CSETWebCore.Model.Document;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Interfaces.Document;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.Business.Document
{
    public class DocumentBusiness : IDocumentBusiness
    {
        /// <summary>
        /// The database context.
        /// </summary>
        private CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;

        /// <summary>
        /// The current assessment.
        /// </summary>
        private int assessmentId;


        /// <summary>
        /// Constructor.
        /// </summary>
        public DocumentBusiness(CSETContext context, IAssessmentUtil assessmentUtil)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;

        }

        public void SetUserAssessmentId(int assessmentId)
        {
            this.assessmentId = assessmentId;
        }



        /// <summary>
        /// Returns an array of Document instances that are attached to the answer.
        /// </summary>
        /// <returns></returns>
        public List<Model.Document.Document> GetDocumentsForAnswer(int answerId)
        {
            List<Model.Document.Document> list = new List<Model.Document.Document>();

            var files = _context.ANSWER
                .Where(a => a.Answer_Id == answerId).FirstOrDefault()?.DOCUMENT_FILEs().ToList();

            if (files == null)
            {
                return list;
            }

            foreach (var file in files)
            {
                Model.Document.Document doc = new Model.Document.Document()
                {
                    Document_Id = file.Document_Id,
                    Title = file.Title,
                    FileName = file.Name
                };

                list.Add(doc);
            }

            return list;
        }


        /// <summary>
        /// Changes the title of a stored document.
        /// </summary>
        /// <param name="id"></param>
        /// <param name="title"></param>
        public void RenameDocument(int id, string title)
        {
            var doc = _context.DOCUMENT_FILE.Where(d => d.Document_Id == id).FirstOrDefault();

            // if they provided a file ID we don't know about, do nothing.
            if (doc == null)
            {
                return;
            }

            doc.Title = title;

            _context.DOCUMENT_FILE.Update(doc);
            _context.SaveChanges();
            _assessmentUtil.TouchAssessment(doc.Assessment_Id);
        }


        /// <summary>
        /// Deletes a stored document.
        /// </summary>
        /// <param name="id">The document ID</param>
        /// <param name="answerId">The document ID</param>
        public void DeleteDocument(int id, int answerId)
        {
            var doc = _context.DOCUMENT_FILE.Where(d => d.Document_Id == id).FirstOrDefault();

            // if they provided a file ID we don't know about, do nothing.
            if (doc == null)
            {
                return;
            }


            // Detach the document from the Answer
            doc.DOCUMENT_ANSWERS.Remove(_context.DOCUMENT_ANSWERS.Where(ans => ans.Document_Id == id && ans.Answer_Id == answerId).FirstOrDefault());
            _context.SaveChanges();

            // If we just detached the document from its only Answer, delete the whole document record
            var otherAnswersForThisDoc = _context.DOCUMENT_ANSWERS.Where(da => da.Document_Id == id).Count();
            if (otherAnswersForThisDoc == 0)
            {
                _context.DOCUMENT_FILE.Remove(doc);
                _context.SaveChanges();
            }

            _assessmentUtil.TouchAssessment(doc.Assessment_Id);
        }


        /// <summary>
        /// Returns a JSON array indicating which questions have attached the specified document.
        /// </summary>
        /// <param name="id">The document ID</param>
        public List<int> GetQuestionsForDocument(int id)
        {
            var ans = _context.DOCUMENT_FILE.Include(x => x.DOCUMENT_ANSWERS)
                .Where(d => d.Document_Id == id).FirstOrDefault().ANSWERs().ToList();

            List<int> qlist = new List<int>();

            foreach (var aaa in ans)
            {
                qlist.Add(aaa.Question_Or_Requirement_Id);
            }

            return qlist;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="fileName"></param>
        /// <param name="tmpFilename"></param>
        /// <param name="fileHash"></param>
        /// <param name="answerId"></param>
        /// <param name="File_Upload_Id"></param>
        /// <param name="stream_id">only used if moving away from the blob process</param>
        public void AddDocument(string title, int answerId, FileUploadStreamResult result)
        {
            foreach (var file in result.FileResultList)
            {
                // first see if the document already exists on any question in this Assessment, based on the filename and hash
                var doc = _context.DOCUMENT_FILE.Where(f => f.FileMd5 == file.FileHash
                    && f.Name == file.FileName
                    && f.Assessment_Id == this.assessmentId).FirstOrDefault();

                if (doc == null)
                {
                    doc = new DOCUMENT_FILE()
                    {
                        Assessment_Id = this.assessmentId,
                        Title = string.IsNullOrWhiteSpace(title) ? "click to edit title" : title,
                        Path = file.FileName,  // this may end up being some other reference
                        Name = file.FileName,
                        FileMd5 = file.FileHash,
                        ContentType = file.ContentType,
                        Data = file.FileBytes
                    };

                }
                else
                {
                    doc.Title = string.IsNullOrWhiteSpace(title) ? doc.Title : title;
                    doc.Name = file.FileName;
                }

                var answer = _context.ANSWER.Where(a => a.Answer_Id == answerId).FirstOrDefault();
                _context.DOCUMENT_FILE.Update(doc);
                _context.SaveChanges();

                DOCUMENT_ANSWERS temp = new DOCUMENT_ANSWERS() { Answer_Id = answer.Answer_Id, Document_Id = doc.Document_Id };
                if (_context.DOCUMENT_ANSWERS.Find(temp.Document_Id, temp.Answer_Id) == null)
                {
                    _context.DOCUMENT_ANSWERS.Add(temp);
                }
                else
                {
                    _context.DOCUMENT_ANSWERS.Update(temp);
                }

                _context.SaveChanges();
                _assessmentUtil.TouchAssessment(doc.Assessment_Id);
            }
        }


        /// <summary>
        /// Returns an array of all Document instances that are attached to 
        /// active/relevant answers on the assessment.
        /// </summary>
        /// <returns></returns>
        public List<Model.Document.Document> GetDocumentsForAssessment(int assessmentId)
        {
            List<Model.Document.Document> list = new List<Model.Document.Document>();

            List<int> answerIds = new List<int>();

            // Use views for faster performance
            var inScopeStandardsAnswers = from a in _context.Answer_Standards_InScope
                                          join s in _context.STANDARD_SELECTION on a.assessment_id equals s.Assessment_Id
                                          where a.assessment_id == assessmentId
                                             && (a.mode == s.Application_Mode.Substring(0, 1).ToUpper()
                                             || a.mode == "Q" && s.Application_Mode == null)
                                          select a;

            answerIds = inScopeStandardsAnswers.Select(x => x.answer_id).ToList();

            var componentAnswers = from a in _context.Answer_Components
                                   join s in _context.STANDARD_SELECTION on a.Assessment_Id equals s.Assessment_Id
                                   where a.Assessment_Id == assessmentId
                                   select a;

            answerIds.AddRange(componentAnswers.Select(x => x.Answer_Id).ToList());

            var maturityAnswers = from ans in _context.Answer_Maturity
                                  join a in _context.ASSESSMENTS on ans.Assessment_Id equals a.Assessment_Id
                                  where ans.Assessment_Id == assessmentId && a.UseMaturity
                                  select ans;

            answerIds.AddRange(maturityAnswers.Select(x => x.Answer_Id).ToList());


            List<int> docIDs = _context.DOCUMENT_ANSWERS
                .Where(x => answerIds.Contains(x.Answer_Id))
                .Select(y => y.Document_Id)
                .ToList();

            var files = from df in _context.DOCUMENT_FILE
                        where docIDs.Contains(df.Document_Id)
                        select df;

            if (files == null || files.Count() == 0)
            {
                return list;
            }

            foreach (var file in files)
            {
                Model.Document.Document doc = new Model.Document.Document()
                {
                    Document_Id = file.Document_Id,
                    Title = file.Title,
                    FileName = file.Name
                };

                // Don't display "click to edit title" in this context because they won't be able to click it
                if (doc.Title == "click to edit title")
                {
                    doc.Title = "(untitled)";
                }

                list.Add(doc);
            }

            return list;
        }
    }
}