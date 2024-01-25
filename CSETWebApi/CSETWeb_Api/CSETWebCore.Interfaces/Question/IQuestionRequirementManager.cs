//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Question;

namespace CSETWebCore.Interfaces.Question
{
    public interface IQuestionRequirementManager
    {
        public List<SubCategoryAnswersPlus> SubCatAnswers { get; set; }
        public int AssessmentId { get; set; }
        public string StandardLevel { get; set; }
        public List<string> SetNames { get; set; }
        public string ApplicationMode { get; set; }
        void InitializeManager(int assessmentId);
        void InitializeSubCategoryAnswers();
        void InitializeApplicationMode();
        void InitializeSalLevel();
        void InitializeStandardsForAssessment();
        void SetApplicationMode(string mode);
        string GetApplicationMode(int assessmentId);
        int StoreComponentAnswer(Answer answer);
        int StoreAnswer(Answer answer);
        void BuildComponentsResponse(QuestionResponse resp);
        void BuildOverridesOnly(QuestionResponse resp);
        void AddResponseComponentOverride(QuestionResponse resp, List<Answer_Components_Base> list, string listname);

        void AddResponse(QuestionResponse resp, List<Answer_Components_Base> list, string listname);

        string DetermineQuestionType(bool is_requirement, bool is_component, bool is_framework, bool is_maturity);
        int NumberOfRequirements();
        int NumberOfQuestions();
    }
}