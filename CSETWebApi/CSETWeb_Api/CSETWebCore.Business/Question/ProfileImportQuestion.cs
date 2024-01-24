//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;

namespace CSETWebCore.Model.Question
{
    public class ProfileImportQuestion
    {
        private bool isSelected;
        public bool IsSelected
        {
            get { return isSelected; }
            set { isSelected = value; }
        }

        private String profileFileName;
        public String ProfileFileName
        {
            get { return profileFileName; }
            set { profileFileName = value; }
        }

        private String profileName;
        public String ProfileName
        {
            get { return profileName; }
            set { profileName = value; }
        }

        private String function;
        public String Function
        {
            get { return function; }
            set { function = value; }
        }

        private String category;
        public String Category
        {
            get { return category; }
            set { category = value; }
        }

        private String categorySubLabel;
        public String CategorySubLabel
        {
            get { return categorySubLabel; }
            set { categorySubLabel = value; }
        }

        private int questionSubNumber;
        public int QuestionSubNumber
        {
            get { return questionSubNumber; }
            set { questionSubNumber = value; }
        }

        private String question;
        public String Question
        {
            get { return question; }
            set { question = value; }
        }

        public Guid ID { get; set; }
        public int QuestionOrder { get; set; }

        public ProfileQuestion QuestionObj { get; private set; }

        public ProfileImportQuestion(ProfileQuestion questionObj)
        {
            this.QuestionObj = questionObj;
        }
    }
}