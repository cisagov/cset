using System.Collections.Generic;
using CSETWebCore.Model.Document;
using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.Document
{
    public interface IDocumentBusiness
    {
        void SetUserAssessmentId(int assessmentId);
        List<Model.Document.Document> GetDocumentsForAnswer(int answerId);
        Task RenameDocument(int id, string title);
        Task DeleteDocument(int id, int questionId, int assessId);
        List<int> GetQuestionsForDocument(int id);
        Task AddDocument(string title, int answerId, FileUploadStreamResult result);
        List<Model.Document.Document> GetDocumentsForAssessment(int assessmentId);
    }
}