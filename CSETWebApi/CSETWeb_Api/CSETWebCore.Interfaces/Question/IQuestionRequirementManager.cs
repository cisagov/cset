using System.Collections.Generic;
using CSETWebCore.Model.Question;
using DataLayerCore.Manual;
using DataLayerCore.Model;

namespace CSETWebCore.Interfaces.Question
{
    public interface IQuestionRequirementManager
    {
        public List<SubCategoryAnswersPlus> SubCatAnswers { get; set; }
        public int AssessmentID { get; set; }
        public string StandardLevel { get; set; }
        public List<string> SetNames { get; set; }
        public string ApplicationMode { get;}

        void IntializeManager(int assessmentId);
        void InitializeSubCategoryAnswers();
        void InitializeApplicationMode();
        void InitializeSalLevel();
        void InitializeStandardsForAssessment();
        void SetApplicationMode(string mode);
        int StoreComponentAnswer(Answer answer);
        int StoreAnswer(Answer answer);
        void BuildComponentsResponse(QuestionResponse resp);
        void BuildOverridesOnly(QuestionResponse resp);
        void AddResponseComponentOverride(QuestionResponse resp, List<Answer_Components_Base> list, string listname);

        void AddResponse(QuestionResponse resp, List<Answer_Components_Base> list,
            string listname);

        string FormatLineBreaks(string s);
    }
}