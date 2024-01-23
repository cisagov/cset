//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.ComponentModel.DataAnnotations;
using CSETWebCore.Business.Framework;

namespace CSETWebCore.Model.Question
{
    public class ProfileQuestion
    {
        internal static ProfileQuestion CreateNewQuestion(ProfileCategory profileCategory, RankingManager rankingManager)
        {
            int nextSubLabelNumber = profileCategory.GetNextSubLabelNumber();
            ProfileQuestion question = new ProfileQuestion(profileCategory, rankingManager)
            {
                SubFunCatLabel = profileCategory.SubFunCatLabel,
                SubLabelNumber = nextSubLabelNumber
            };
            question.Weight = 10;
            question.CanDelete = true;
            question.CanEdit = true;
            question.CanSelect = true;
            question.IsCustomQuestion = true;
            question.CustomQuestionID = Guid.NewGuid();
            question.IsSelect = true;

            return question;
        }

        private string subFunCatLabel;
        public string SubFunCatLabel
        {
            get { return subFunCatLabel; }
            set { subFunCatLabel = value; }
        }

        internal void SetRank()
        {
            this.Ranking = this.RankingManger.GetMaxQuestionRanking();
        }

        public string FunctionName
        {
            get
            {
                return Category.FunctionName;
            }
        }

        public Tuple<String, String, String> UniqueQuestionIdentifier
        {
            get { return Tuple.Create(Category.FunctionName, Category.SubLabel, Question); }
        }

        private int subLabelNumber;

        public int SubLabelNumber
        {
            get { return subLabelNumber; }
            set
            {
                subLabelNumber = value;
                Category.UpdateSubLabelNumber(this, value);

                //This is hokey will set private property and then do onPropertyChange
                subLabelNumberString = value.ToString();

            }
        }



        private String subLabelNumberString;
        [CustomValidation(typeof(ProfileQuestion), "ValidateSubLabelNumber")]
        public String SubLabelNumberString
        {
            get { return subLabelNumberString; }
            set
            {
                subLabelNumberString = value;

                int newValue;
                if (Int32.TryParse(value, out newValue))
                {
                    SubLabelNumber = newValue;

                    Category.UpdateSubLabelNumber(this, newValue);
                }
            }
        }

        private string question;
        [Required(ErrorMessage = "Requirement is required.")]
        public string Question
        {
            get { return question; }
            set
            {

                question = value;


            }
        }

        private string comments;
        public string Comments
        {
            get { return comments; }
            set { comments = value; }
        }

        private string supplementalInfo;
        public string SupplementalInfo
        {
            get { return supplementalInfo; }
            set { supplementalInfo = value; }
        }

        private string references;
        public string References
        {
            get { return references; }
            set { references = value; }
        }

        private bool isSelect;
        public bool IsSelect
        {
            get { return isSelect; }
            set { isSelect = value; }
        }

        private bool isCustomQuestion;
        public bool IsCustomQuestion
        {
            get { return isCustomQuestion; }
            set { isCustomQuestion = value; }
        }

        private Boolean isReadOnly;
        public Boolean IsReadOnly
        {
            get { return isReadOnly; }
            set { isReadOnly = value; }
        }

        private Boolean canSelect;
        public Boolean CanSelect
        {
            get { return canSelect; }
            set { canSelect = value; }
        }

        private Boolean canDelete;
        public Boolean CanDelete
        {
            get { return canDelete; }
            set { canDelete = value; }
        }

        private Boolean canEdit;
        public Boolean CanEdit
        {
            get { return canEdit; }
            set { canEdit = value; }
        }

        public int Weight { get; set; }

        /// <summary>
        /// NOTE: This ranking is auto generated for custom questions. It needs to eventually be assigned by the user and stored in the XML.
        /// </summary>
        public int Ranking { get; set; }

        public int QuestionDefaultID { get; set; }
        public int CustomQuestionOrder { get; set; }


        public Guid CustomQuestionID { get; set; }

        public string UniversalCategory { get { return Category.UniversalCategory; } }
        public string CategoryHeading { get { return Category.Heading; } }

        public ProfileCategory Category { get; private set; }
        private bool validate = false;
        //private ProfileOldQuestionValues oldQuestionValues = new ProfileOldQuestionValues();
        private RankingManager RankingManger;

        public ProfileQuestion(ProfileCategory category, RankingManager rankingManger)
        {
            this.Category = category;
            this.SubFunCatLabel = category.SubFunCatLabel;
            this.RankingManger = rankingManger;
        }

        public ProfileQuestion(ProfileCategory category, RankingManager rankingManger, ProfileImportQuestion importQuestion) : this(category, rankingManger)
        {
            IsCustomQuestion = true;
            Weight = 10;
            CustomQuestionID = importQuestion.ID;
            CanEdit = true;
            CanDelete = true;
            CanSelect = true;
            IsReadOnly = false;

            Question = importQuestion.QuestionObj.Question;
            Comments = importQuestion.QuestionObj.Comments;
            References = importQuestion.QuestionObj.References;
            SupplementalInfo = importQuestion.QuestionObj.SupplementalInfo;
            IsSelect = true;

            if (category.DoesSubLabelNumberAlreadyExist(this, importQuestion.QuestionObj.SubLabelNumber))
            {
                SubLabelNumber = category.GetNextSubLabelNumber();
            }
            else
            {
                SubLabelNumber = importQuestion.QuestionObj.SubLabelNumber;
            }
        }

        public void SetValidation(bool validate)
        {
            this.validate = validate;
            if (validate)
            {
                Category.ResetSubLabelNumberValidator();
            }
        }
        //public void RememberCurrentValues()
        //{
        //    oldQuestionValues.SubLabelNumber = SubLabelNumber;
        //    oldQuestionValues.Question = Question;
        //    oldQuestionValues.Comments = Comments;
        //    oldQuestionValues.References = References;
        //    oldQuestionValues.IsSelect = IsSelect;
        //    oldQuestionValues.SupplementalInfo = SupplementalInfo;
        //}

        //internal void ResetQuestion()
        //{
        //    this.SubLabelNumber = oldQuestionValues.SubLabelNumber;
        //    this.Question = oldQuestionValues.Question;
        //    this.Comments = oldQuestionValues.Comments;
        //    this.References = oldQuestionValues.References;
        //    this.IsSelect = oldQuestionValues.IsSelect;

        //    this.SupplementalInfo = oldQuestionValues.SupplementalInfo;


        //}

        internal void RemoveQuestion()
        {
            Category.RemoveQuestion(this);
        }

        internal bool IsSame(ProfileQuestion question)
        {
            if (this.Comments != Comments || this.SupplementalInfo != question.SupplementalInfo ||
                this.Question != question.Question || this.References != question.References
                || this.SubLabelNumber != question.SubLabelNumber || this.IsSelect != question.IsSelect || this.IsCustomQuestion != question.IsCustomQuestion)
                return false;
            if (this.IsCustomQuestion && question.IsCustomQuestion)
            {
                if (this.CustomQuestionID != question.CustomQuestionID)
                    return false;
            }

            return true;
        }


        private bool DoesSubLabelNumberAlreadyExist(int newValue)
        {
            bool alreadyValue = Category.DoesSubLabelNumberAlreadyExist(this, newValue);
            return alreadyValue;
        }
    }
}