using System.Collections.Generic;
using CSETWebCore.DataLayer;
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
        int StoreComponentAnswer(Answer answer);
        int StoreAnswer(Answer answer);
        void BuildComponentsResponse(QuestionResponse resp);
        void BuildOverridesOnly(QuestionResponse resp, CSETContext context);
        void AddResponseComponentOverride(QuestionResponse resp, CSETContext context, List<Answer_Components_Base> list, string listname);

        void AddResponse(QuestionResponse resp, CSETContext context, List<Answer_Components_Base> list,
            string listname);

        string FormatLineBreaks(string s);
    }
}