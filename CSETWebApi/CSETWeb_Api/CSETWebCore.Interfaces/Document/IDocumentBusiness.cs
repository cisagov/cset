using System.Collections.Generic;
using CSETWebCore.Model.Document;

namespace CSETWebCore.Interfaces.Document
{
    public interface IDocumentBusiness
    {
        void SetUserAssessmentId(int assessmentId);
        List<Model.Document.Document> GetDocumentsForAnswer(int answerId);
        void RenameDocument(int id, string title);
        void DeleteDocument(int id, int answerId);
        List<int> GetQuestionsForDocument(int id);
        void AddDocument(string title, int answerId, FileUploadStreamResult result);
        List<Model.Document.Document> GetDocumentsForAssessment(int assessmentId);
    }
}