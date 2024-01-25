//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using System.Collections.Generic;

namespace CSETWebCore.Model.Gallery
{
    public class GalleryItems
    {
        public GalleryItems()
        {
        }

        public int Gallery_Item_Guid { get; set; }
        public string Icon_File_Name_Small { get; set; }
        public string Icon_File_Name_Large { get; set; }
        //public Configuration_Setup { get; set; }

        public ANSWER ANSWER { get; set; }
        public MATURITY_QUESTIONS Mat { get; set; }

        // This should have a defined getter since as a property is ascertainable
        // but that getter would ping the database, and the GetMissingParents() function
        // in MaturyBasicReportData can calculate this with data already present.
        public bool IsParentWithChildren { get; set; }

        /// <summary>
        /// This property is used to know when to suppress the bottom border.
        /// This keeps child questions visually grouped with their parent.
        /// </summary>
        public bool IsFollowedByChild { get; set; }


        /// <summary>
        /// This property is used to instruct the _MatAnswerHead shared view
        /// to show the alt justification, rather than the answer value.
        /// </summary>
        public bool ShowAlt { get; set; }
    }

    public class MatAnsweredQuestionDomain
    {
        public MatAnsweredQuestionDomain()
        {
        }

        public string Title { get; set; }
        public bool IsDeficient { get; set; }
        public List<MaturityAnsweredQuestionsAssesment> AssessmentFactors { get; set; }
    }

    public class MaturityAnsweredQuestionsAssesment
    {
        public MaturityAnsweredQuestionsAssesment()
        {
        }
        public string Title { get; set; }
        public bool IsDeficient { get; set; }
        public List<MaturityAnsweredQuestionsComponent> Components { get; set; }
    }
    public class MaturityAnsweredQuestionsComponent
    {
        public MaturityAnsweredQuestionsComponent()
        {
        }
        public string Title { get; set; }
        public bool IsDeficient { get; set; }
        public List<MaturityAnsweredQuestions> Questions { get; set; }
    }

    public class MaturityAnsweredQuestions
    {
        public MaturityAnsweredQuestions()
        {
        }
        public string Title { get; set; }
        public string QuestionText { get; set; }
        public string MaturityLevel { get; set; }
        public string Comments { get; set; }
        public string AnswerText { get; set; }
        public bool MarkForReview { get; set; }
        public string Comment { get; set; }
    }


}