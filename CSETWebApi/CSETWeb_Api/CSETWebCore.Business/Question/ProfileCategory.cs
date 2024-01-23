//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Model.Question
{
    public class ProfileCategory
    {
        private ObservableCollection<ProfileQuestion> profileQuestions;
        public ObservableCollection<ProfileQuestion> ProfileQuestions
        {
            get { return profileQuestions; }
            set { profileQuestions = value; }
        }

        private string sublabel;

        [Required(ErrorMessage = "ID is required.")]
        [CustomValidation(typeof(ProfileCategory), "ValidateSubLabel")]
        public string SubLabel
        {
            get { return sublabel; }
            set
            {
                sublabel = value;
                //profileCategoryValidator.UpdateSubLabel(this);             
            }
        }


        private string heading;
        [Required(ErrorMessage = "Framework Category is required.")]
        [CustomValidation(typeof(ProfileCategory), "ValidateHeading")]
        public string Heading
        {
            get { return heading; }
            set
            {
                heading = value;
                //profileCategoryValidator.UpdateHeading(this);

            }
        }

        private string description;
        public string Description
        {
            get { return description; }
            set { description = value; }
        }

        private bool isCustomCategory;
        public bool IsCustomCategory
        {
            get { return isCustomCategory; }
            set { isCustomCategory = value; }
        }

        private bool isSelect;
        public bool IsSelect
        {
            get { return isSelect; }
            set
            {
                isSelect = value;
                SelectQuestions(value);

            }
        }

        internal void UpdateSubLabelNumber(ProfileQuestion profileQuestion, int value)
        {
            throw new NotImplementedException();
        }

        private bool isReadOnly;
        public bool IsReadOnly
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

        private QUESTION_GROUP_HEADING questionGroupHeading;
        public QUESTION_GROUP_HEADING QuestionGroupHeading
        {
            get { return questionGroupHeading; }
            set { questionGroupHeading = value; }
        }

        public int? QuestionGroupHeadingID { get; set; }


        public Guid ID
        {
            get;
            set;
        }

        public int DefaultCategoryID { get; set; }

        public String FunctionName { get { return ProfileFunction.FunctionName; } }

        public String SubFunCatLabel { get { return ProfileFunction.Function_ID + "." + SubLabel; } }

        public string UniversalCategory { get; set; }
        public ProfileFunction ProfileFunction { get; set; }



        private bool selectQuestions = true;


        private bool validate = false;
        private string oldHeading;
        private string oldSubLabel;
        private string oldDescription;
        private QUESTION_GROUP_HEADING oldQuestionGroupHeading;


        private Dictionary<Guid, ProfileQuestion> dictionaryCustomQuestions = new Dictionary<Guid, ProfileQuestion>();
        private Dictionary<int, ProfileQuestion> dictionaryDefaultQuestions = new Dictionary<int, ProfileQuestion>();

        public ProfileCategory(ProfileFunction profileFunction)
        {
            this.ProfileFunction = profileFunction;
            this.ID = Guid.NewGuid();
            this.ProfileQuestions = new ObservableCollection<ProfileQuestion>();

            IsReadOnly = false;
            CanDelete = true;
            CanEdit = true;
            CanSelect = true;
            IsSelect = true;
            SubLabel = "";
            Heading = "";
            Description = "";
            SetIsSelect(true);
            IsCustomCategory = true;
        }


        public void AddQuestions(IEnumerable<ProfileQuestion> questions)
        {
            foreach (ProfileQuestion question in questions)
            {
                AddQuestionToCollections(question);
            }
        }



        internal void AddQuestion(ProfileQuestion question)
        {
            int maxQuestionNumber = GetMaxQuestionNumber();
            question.CustomQuestionOrder = maxQuestionNumber + 1;
            AddQuestionToCollections(question);
        }

        private void AddQuestionToCollections(ProfileQuestion question)
        {
            ProfileQuestions.Add(question);
            if (question.IsCustomQuestion)
                dictionaryCustomQuestions[question.CustomQuestionID] = question;
            else
                dictionaryDefaultQuestions[question.QuestionDefaultID] = question;
        }

        public void SetIsSelect(bool isSelect)
        {
            selectQuestions = false;
            IsSelect = isSelect;
            selectQuestions = true;
        }

        public void RememberOldValues()
        {
            oldHeading = Heading;
            oldSubLabel = SubLabel;
            oldDescription = Description;
            oldQuestionGroupHeading = QuestionGroupHeading;
        }

        public void RevertValues()
        {
            this.SubLabel = oldSubLabel;
            this.Heading = oldHeading;
            this.Description = oldDescription;
            this.QuestionGroupHeading = oldQuestionGroupHeading;
        }

        public void SetValidation(bool validate)
        {
            this.validate = validate;
        }

        private void SelectQuestions(bool value)
        {
            if (selectQuestions)
            {
                foreach (ProfileQuestion profileQuestion in ProfileQuestions)
                {
                    profileQuestion.IsSelect = value;
                }
            }
        }



        private int GetMaxQuestionNumber()
        {
            int maxQuestionNumber;

            if (ProfileQuestions.Count() > 0)
            {
                maxQuestionNumber = ProfileQuestions.Max(x => x.SubLabelNumber);
            }
            else
            {
                maxQuestionNumber = 0;
            }
            return maxQuestionNumber;
        }

        internal int GetNextSubLabelNumber()
        {
            int maxQuestionNumber = GetMaxQuestionNumber();
            return maxQuestionNumber + 1;
        }

        internal bool DoesSubLabelNumberAlreadyExist(ProfileQuestion profileQuestion, int subLabelNumber)
        {
            throw new NotImplementedException();
        }

        public void RemoveQuestion(ProfileQuestion profileQuestion)
        {

            ProfileQuestions.Remove(profileQuestion);
        }



        private bool DoesHeadingExistAlready(String value)
        {
            throw new NotImplementedException("this needs to check the database for the heading");
        }

        internal void ResetSubLabelNumberValidator()
        {
            throw new NotImplementedException();
        }

        public bool DoesSubLabelExistAlready(String value)
        {
            throw new NotImplementedException("this needs to check the database or file for the sub label");
        }



        public bool IsSame(ProfileCategory profileCategory)
        {
            if (this.Heading != profileCategory.Heading ||
                this.QuestionGroupHeadingID != profileCategory.QuestionGroupHeadingID || this.SubLabel != profileCategory.SubLabel
                || this.IsSelect != profileCategory.IsSelect)
                return false;

            if (dictionaryDefaultQuestions.Count != profileCategory.dictionaryDefaultQuestions.Count)
                return false;

            foreach (ProfileQuestion question in profileCategory.ProfileQuestions)
            {
                if (question.IsCustomQuestion)
                {
                    ProfileQuestion thisProfileQuestion;
                    if (this.dictionaryCustomQuestions.TryGetValue(question.CustomQuestionID, out thisProfileQuestion))
                    {
                        if (!thisProfileQuestion.IsSame(question))
                            return false;
                    }
                    else
                        return false;

                }
                else
                {
                    ProfileQuestion thisProfileQuestion;
                    if (!this.dictionaryDefaultQuestions.TryGetValue(question.QuestionDefaultID, out thisProfileQuestion))
                        return false;
                    else
                    {
                        if (thisProfileQuestion.IsSelect != question.IsSelect)
                            return false;
                    }
                }
            }

            return true;
        }

        public static ValidationResult ValidateSubLabel(String value, ValidationContext context)
        {

            ProfileCategory category = (ProfileCategory)context.ObjectInstance;
            if (category.DoesSubLabelExistAlready(value))
                return new ValidationResult("ID already exists.", new string[] { context.MemberName });
            return ValidationResult.Success;
        }

        public static ValidationResult ValidateHeading(String value, ValidationContext context)
        {

            ProfileCategory category = (ProfileCategory)context.ObjectInstance;
            if (category.DoesHeadingExistAlready(value))
                return new ValidationResult("Framework Category already exists.", new string[] { context.MemberName });

            return ValidationResult.Success;
        }

        internal bool ContainsImportQuestion(ProfileImportQuestion importQuestion)
        {
            if (ProfileQuestions.Where(x => x.Question == importQuestion.Question).FirstOrDefault() == null)
                return false;
            else
                return true;
        }
    }
}