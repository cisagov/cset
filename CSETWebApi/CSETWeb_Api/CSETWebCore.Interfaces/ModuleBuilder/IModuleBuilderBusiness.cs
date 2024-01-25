//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Document;
using CSETWebCore.Model.Set;

namespace CSETWebCore.Interfaces.ModuleBuilder
{
    public interface IModuleBuilderBusiness
    {
        List<SetDetail> GetCustomSetList(bool includeNonCustom = false);
        List<SetDetail> GetSetsInUseList();
        void SetBaseSets(String setName, string[] setNames);
        List<String> GetBaseSets(string customSetName);
        List<SetDetail> GetNonCustomSetList(string exceptionList);
        SetDetail GetSetDetail(string setName);
        void AddCopyToSet(string sourceSetName, string destinationSetName);
        void DeleteCopyToSet(string setName);
        SetDetail CloneSet(string setName);
        BasicResponse DeleteSet(string setName);
        string SaveSetDetail(SetDetail setDetail);
        string GenerateNewSetName();
        QuestionListResponse GetQuestionsForSet(string setName);
        List<int> GetMyQuestionsUsedByOtherSets(string setName);

        void PopulateCategorySubcategory(int headingPairId, CSETContext db, out string cat,
            out int pairID, out string subcat, out string subheading);

        string GetTitle(int questionId, CSETContext db);
        bool ExistsQuestionText(string questionText);
        void AddCustomQuestion(SetQuestion request);
        void AddQuestion(SetQuestion request);
        void RemoveQuestion(SetQuestion request);
        int GetHeadingPair(int categoryId, string subcatText, string setName);
        List<CategoryEntry> GetStandardCategories();
        CategoriesSubcategoriesGroupHeadings GetCategoriesSubcategoriesGroupHeadings();
        List<QuestionDetail> SearchQuestions(QuestionSearch searchParms);
        void SetSalLevel(SalParms salParms);
        void SetRequirementSalLevel(SalParms salParms);
        void SetQuestionSalLevel(SalParms salParms);
        BasicResponse UpdateQuestionText(int questionID, string text);
        bool IsQuestionInUse(int questionID);
        void UpdateHeadingText(int pairID, string text);
        bool IsTextEncrypted(string text);
        ModuleResponse GetModuleStructure(string setName);
        Requirement CreateRequirement(Requirement parms);
        Requirement GetRequirement(string setName, int reqID);
        ReferenceDocLists GetReferencesForRequirement(int reqID);
        Requirement UpdateRequirement(Requirement parms);
        void RemoveRequirement(Requirement parms);
        List<ReferenceDoc> GetReferenceDocs(string setName, string filter);
        List<ReferenceDoc> GetReferenceDocsForSet(string setName);
        ReferenceDoc GetReferenceDocDetail(int id);
        void UpdateReferenceDocDetail(ReferenceDoc doc);
        void SelectSetFile(SetFileSelection parms);

        ReferenceDocLists AddDeleteRefDocToRequirement(int requirementId, int docId, bool isSourceRef, string bookmark,
            bool add);

        int RecordDocInDB(FileUploadStreamResult result);


    }
}