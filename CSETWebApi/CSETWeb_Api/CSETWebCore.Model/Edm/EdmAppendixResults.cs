//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace CSETWebCore.Model.Edm
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
        public int U { get; set; }
    }

    public class EDMSubcategoryGoalGroup
    {
        public string GroupName { get; set; }

        public List<EDMSubcategoryGoalResults> SubResults { get; set; }

        public string GroupAnswer { get; set; }
    }

    public class EDMSubcategoryGoalResults
    {
        public string GoalName { get; set; }

        public string Answer { get; set; }

        public List<EDMSubcategoryGoalResults> SubResults { get; set; }
    }

    public class RelevantEDMAnswersAppendix
    {
        public string FunctionName { get; set; }

        public string Acronym { get; set; }

        public EDMAnswerTotal Totals { get; set; }

        public string Summary { get; set; }

        public List<Category> Categories { get; set; }
    }

    public class Category
    {
        public string Name { get; set; }

        public string ShortName { get; set; }

        public List<RelevantEDMAnswerResult> AnsweredEDM { get; set; }

        public EDMAnswerTotal Totals { get; set; }

        public string Description { get; set; }

        public string Acronym { get; set; }

        public List<EDMSubcategoryGoalGroup> GoalResults { get; set; }

        public List<SubCategory> SubCategories { get; set; }
    }

    public class SubCategory
    {
        public string Question_Title { get; set; }

        public string Question_Text { get; set; }

        public List<string> EDMReferences { get; set; }

        public List<RelevantEDMAnswerResult> AnsweredEDM { get; set; }

        public EDMAnswerTotal Totals { get; set; }

        public List<EDMSubcategoryGoalGroup> GoalResults { get; set; }
    }
}
