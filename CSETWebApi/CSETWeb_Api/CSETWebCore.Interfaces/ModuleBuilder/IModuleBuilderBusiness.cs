using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Document;
using CSETWebCore.Model.Set;


namespace CSETWebCore.Interfaces.ModuleBuilder
{
    public interface IModuleBuilderBusiness
    {
        List<SetDetail> GetCustomSetList(bool includeNonCustom = false);
        Task<List<SetDetail>> GetSetsInUseList();
        void SetBaseSets(String setName, string[] setNames);
        List<String> GetBaseSets(string customSetName);
        List<SetDetail> GetNonCustomSetList(string exceptionList);
        SetDetail GetSetDetail(string setName);
        void AddCopyToSet(string sourceSetName, string destinationSetName);
        void DeleteCopyToSet(string setName);
        Task<SetDetail> CloneSet(string setName);
        Task<BasicResponse> DeleteSet(string setName);
        Task<string> SaveSetDetail(SetDetail set);
        string GenerateNewSetName();
        QuestionListResponse GetQuestionsForSet(string setName);
        List<int> GetMyQuestionsUsedByOtherSets(string setName);

        void PopulateCategorySubcategory(int headingPairId, CSETContext db, out string cat,
            out int pairID, out string subcat, out string subheading);

        string GetTitle(int questionId, CSETContext db);
        bool ExistsQuestionText(string questionText);
        Task AddCustomQuestion(SetQuestion request);
        Task AddQuestion(SetQuestion request);
        Task RemoveQuestion(SetQuestion request);
        Task<int> GetHeadingPair(int categoryId, string subcatText, string setName);
        List<CategoryEntry> GetStandardCategories();
        CategoriesSubcategoriesGroupHeadings GetCategoriesSubcategoriesGroupHeadings();
        List<QuestionDetail> SearchQuestions(QuestionSearch searchParms);
        void SetSalLevel(SalParms salParms);
        Task SetRequirementSalLevel(SalParms salParms);
        Task SetQuestionSalLevel(SalParms salParms);
        Task<BasicResponse> UpdateQuestionText(int questionID, string text);
        bool IsQuestionInUse(int questionID);
        Task UpdateHeadingText(int pairID, string text);
        bool IsTextEncrypted(string text);
        ModuleResponse GetModuleStructure(string setName);
        Task<Requirement> CreateRequirement(Requirement parms);
        Requirement GetRequirement(string setName, int reqID);
        ReferenceDocLists GetReferencesForRequirement(int reqID);
        Task<Requirement> UpdateRequirement(Requirement parms);
        Task RemoveRequirement(Requirement parms);
        List<ReferenceDoc> GetReferenceDocs(string setName, string filter);
        List<ReferenceDoc> GetReferenceDocsForSet(string setName);
        ReferenceDoc GetReferenceDocDetail(int id);
        Task UpdateReferenceDocDetail(ReferenceDoc doc);
        Task SelectSetFile(SetFileSelection parms);

        Task<ReferenceDocLists> AddDeleteRefDocToRequirement(int requirementId, int docId, bool isSourceRef, string bookmark,
            bool add);

        Task<int> RecordDocInDB(FileUploadStreamResult result);


    }
}