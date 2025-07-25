//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using System;
using System.Collections.Generic;
using CSETWebCore.Model.Document;

namespace CSETWebCore.Interfaces.Document
{
    public interface IDocumentBusiness
    {
        void SetUserAssessmentId(int assessmentId);
        List<Model.Document.Document> GetDocumentsForAnswer(int answerId);
        void RenameDocument(int id, string title);
        void ChangeGlobal(int id, Boolean isGlobal);
        void DeleteDocument(int id, int questionId, int assessId);
        List<int> GetQuestionsForDocument(int id);
        void AddDocument(string title, int answerId, FileUploadStreamResult result);
        List<Model.Document.Document> GetDocumentsForAssessment(int assessmentId);
        List<Model.Document.Document> GetGlobalDocuments();
        void CopyFilesForMerge(List<DocumentWithAnswerId> documents);
    }
}