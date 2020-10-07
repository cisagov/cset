//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using DataLayerCore.Model;
using System.Text;
using CSETWeb_Api.Models;
using Microsoft.EntityFrameworkCore;
using CSETWeb_Api.BusinessLogic.Helpers.upload;

namespace CSETWeb_Api.BusinessManagers
{
    /// <summary>
    /// Handles management of documents.
    /// </summary>
    public class DocumentManager
    {
        /// <summary>
        /// The database context.
        /// </summary>
        private CSET_Context db;

        /// <summary>
        /// The current assessment.
        /// </summary>
        private readonly int assessmentId;


        /// <summary>
        /// Constructor.
        /// </summary>
        public DocumentManager(int assessmentId)
        {
            this.db = new CSET_Context();
            this.assessmentId = assessmentId;
        }


        /// <summary>
        /// Returns an array of Document instances that are attached to the answer.
        /// </summary>
        /// <returns></returns>
        public List<Document> GetDocumentsForAnswer(int answerId)
        {
            List<Document> list = new List<Document>();

            var files = db.ANSWER
                .Where(a => a.Answer_Id == answerId).FirstOrDefault()?.DOCUMENT_FILEs().ToList();

            if (files == null)
            {
                return list;
            }

            foreach (var file in files)
            {
                Document doc = new Document()
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
            var doc = db.DOCUMENT_FILE.Where(d => d.Document_Id == id).FirstOrDefault();

            // if they provided a file ID we don't know about, do nothing.
            if (doc == null)
            {
                return;
            }

            doc.Title = title;

            db.DOCUMENT_FILE.AddOrUpdate(doc, x => x.Document_Id);
            db.SaveChanges();
            CSETWeb_Api.BusinessLogic.Helpers.AssessmentUtil.TouchAssessment(doc.Assessment_Id);
        }


        /// <summary>
        /// Deletes a stored document.
        /// </summary>
        /// <param name="id">The document ID</param>
        /// <param name="answerId">The document ID</param>
        public void DeleteDocument(int id, int answerId)
        {
            var doc = db.DOCUMENT_FILE.Where(d => d.Document_Id == id).FirstOrDefault();

            // if they provided a file ID we don't know about, do nothing.
            if (doc == null)
            {
                return;
            }


            // Detach the document from the Answer
            doc.DOCUMENT_ANSWERS.Remove(db.DOCUMENT_ANSWERS.Where(ans => ans.Document_Id == id && ans.Answer_Id == answerId).FirstOrDefault());
            db.SaveChanges();

            // If we just detached the document from its only Answer, delete the whole document record
            var otherAnswersForThisDoc = db.DOCUMENT_ANSWERS.Where(da => da.Document_Id == id).Count();
            if (otherAnswersForThisDoc == 0)
            {
                db.DOCUMENT_FILE.Remove(doc);
                db.SaveChanges();
            }

            CSETWeb_Api.BusinessLogic.Helpers.AssessmentUtil.TouchAssessment(doc.Assessment_Id);
        }


        /// <summary>
        /// Returns a JSON array indicating which questions have attached the specified document.
        /// </summary>
        /// <param name="id">The document ID</param>
        public List<int> GetQuestionsForDocument(int id)
        {
            var ans = db.DOCUMENT_FILE.Include(x => x.DOCUMENT_ANSWERS)
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
            if (string.IsNullOrWhiteSpace(title))
            {
                title = "click to edit title";
            }

            foreach (var file in result.FileResultList)
            {
                // first see if the document already exists on any question in this Assessment, based on the filename and hash
                var doc = db.DOCUMENT_FILE.Where(f => f.FileMd5 == file.FileHash
                    && f.Name == file.FileName
                    && f.Assessment_Id == this.assessmentId).FirstOrDefault();
                if (doc == null)
                {
                    doc = new DOCUMENT_FILE()
                    {
                        Assessment_Id = this.assessmentId,
                        Title = title,
                        Path = file.FileName,  // this may end up being some other reference
                        Name = file.FileName,
                        FileMd5 = file.FileHash,
                        ContentType = file.ContentType,
                        Data = file.FileBytes
                    };

                }
                else
                {
                    doc.Title = title;
                    doc.Name = file.FileName;
                }

                var answer = db.ANSWER.Where(a => a.Answer_Id == answerId).FirstOrDefault();
                db.DOCUMENT_FILE.AddOrUpdate(doc, x => x.Document_Id);
                db.SaveChanges();

                DOCUMENT_ANSWERS temp = new DOCUMENT_ANSWERS() { Answer_Id = answer.Answer_Id, Document_Id = doc.Document_Id };
                if (db.DOCUMENT_ANSWERS.Find(temp.Document_Id, temp.Answer_Id) == null)
                {
                    db.DOCUMENT_ANSWERS.Add(temp);
                }
                else
                {
                    db.DOCUMENT_ANSWERS.Update(temp);
                }
                db.SaveChanges();
                CSETWeb_Api.BusinessLogic.Helpers.AssessmentUtil.TouchAssessment(doc.Assessment_Id);
            }
        }


        /// <summary>
        /// Returns an array of all Document instances that are attached to 
        /// active/relevant answers on the assessment.
        /// </summary>
        /// <returns></returns>
        public List<Document> GetDocumentsForAssessment(int assessmentId)
        {
            List<Document> list = new List<Document>();

            List<int> answerIds = new List<int>();

            // Use views for faster performance
            var inScopeStandardsAnswers = from a in db.Answer_Standards_InScope
                                 join s in db.STANDARD_SELECTION on a.assessment_id equals s.Assessment_Id
                                 where a.assessment_id == assessmentId
                                    && (a.mode == s.Application_Mode.Substring(0, 1).ToUpper()
                                    || a.mode == "Q" && s.Application_Mode == null)
                                 select a;

            answerIds = inScopeStandardsAnswers.Select(x => x.answer_id).ToList();

            var componentAnswers = from a in db.Answer_Components
                                          join s in db.STANDARD_SELECTION on a.Assessment_Id equals s.Assessment_Id
                                          where a.Assessment_Id == assessmentId
                                          select a;

            answerIds.AddRange(componentAnswers.Select(x => x.Answer_Id).ToList());


            List<int> docIDs = db.DOCUMENT_ANSWERS
                .Where(x => answerIds.Contains(x.Answer_Id))
                .Select(y => y.Document_Id)
                .ToList();

            var files = from df in db.DOCUMENT_FILE
                        where docIDs.Contains(df.Document_Id)
                        select df;

            if (files == null || files.Count() == 0)
            {
                return list;
            }

            foreach (var file in files)
            {
                Document doc = new Document()
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

