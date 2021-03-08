using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Models
{

    public class RelevantEDMAnswerResult
    {
        public string QuestionTitle { get; set; }

        public string QuestionText { get; set; }

        public string AnswerText { get; set; }

    }

    public class EDMAnswerTotal
    {
        public int Y { get; set; }
        public int I { get; set; }
        public int N { get; set; }
    }

    public class EDMSubcategoryGoalGroup
    {
        public string GroupName { get; set; }
        public List<EDMSubcategoryGoalResults> subResults;
        public string GroupAnswer { get; set; }

    }
    public class EDMSubcategoryGoalResults
    {
        public string GoalName { get; set; }
        public string Answer { get; set; }
        public List<EDMSubcategoryGoalResults> subResults;
    }

    public class RelevantEDMAnswersAppendix
    {
        public string FunctionName { get; set; }
        public string Acronym { get; set; }
        public EDMAnswerTotal totals { get; set; }

        public string Summary { get; set; }



        public List<Category> Categories;

    }

    public class Category
    {
        public string Name { get; set; }
        public string ShortName { get; set; }
        public EDMAnswerTotal totals { get; set; }

        public string Description { get; set; }
        public string Acronym { get; set; }


        public List<SubCategory> SubCategories;

    }

    public class SubCategory
    {
        public string Question_Title { get; set; }

        public string Question_Text { get; set; }

        public List<string> EDMReferences { get; set; }

        public List<RelevantEDMAnswerResult> answeredEDM;
        public EDMAnswerTotal totals { get; set; }
        public List<EDMSubcategoryGoalGroup> GoalResults;

    }



}
