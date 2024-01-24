//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using CSETWebCore.Business.Framework;

namespace CSETWebCore.Model.Question
{
    public class ProfileFunction
    {
        private string functionName;
        public string FunctionName
        {
            get { return functionName; }
            set
            {
                functionName = value;

            }
        }

        private ObservableCollection<ProfileCategory> profileCategories;
        public ObservableCollection<ProfileCategory> ProfileCategories
        {
            get { return profileCategories; }
            set
            {
                profileCategories = value;

            }
        }

        public String Function_ID { get; set; }

        public int FunctionID { get; set; }

        private Dictionary<String, ProfileCategory> dictionaryCategoriesBySubLabel = new Dictionary<string, ProfileCategory>();
        private RankingManager RankingManger;

        public ProfileFunction(RankingManager rankingManager)
        {

            this.ProfileCategories = new ObservableCollection<ProfileCategory>();
            this.RankingManger = rankingManager;
        }

        public void SetCategories(IEnumerable<ProfileCategory> profileCategories)
        {
            List<ProfileCategory> defaultCategories = new List<ProfileCategory>();
            List<ProfileCategory> customCategories = new List<ProfileCategory>();
            foreach (ProfileCategory category in profileCategories)
            {
                if (category.IsCustomCategory)
                    customCategories.Add(category);
                else
                    defaultCategories.Add(category);
            }
            //THIS WAS COMMENTED OUT in the move to the web on May 29, 2018
            //this.ProfileCategories.AddRange(defaultCategories.OrderBy(x => x.DefaultCategoryID));
            //this.ProfileCategories.AddRange(customCategories.OrderBy(x => x.Heading));
            foreach (ProfileCategory category in profileCategories)
            {
                dictionaryCategoriesBySubLabel[category.SubLabel] = category;
            }
        }

        internal void RemoveCategory(ProfileCategory profileCategory)
        {
            ProfileCategories.Remove(profileCategory);
            if (profileCategory.SubLabel != null)
                dictionaryCategoriesBySubLabel.Remove(profileCategory.SubLabel);
        }

        internal void AddCategory(ProfileCategory profileCategory)
        {
            ProfileCategories.Add(profileCategory);
            dictionaryCategoriesBySubLabel[profileCategory.SubLabel] = profileCategory;
        }

        internal Tuple<bool, ProfileQuestion> AddImportQuestion(ProfileImportQuestion importQuestion)
        {
            ProfileCategory category;
            if (!dictionaryCategoriesBySubLabel.TryGetValue(importQuestion.CategorySubLabel, out category))
            {
                category = new ProfileCategory(this);
                category.SubLabel = importQuestion.CategorySubLabel;
                category.Heading = importQuestion.Category;
                category.IsSelect = true;
                AddCategory(category);
            }


            if (!category.ContainsImportQuestion(importQuestion))
            {
                ProfileQuestion question = new ProfileQuestion(category, RankingManger, importQuestion);
                category.AddQuestion(question);
                return Tuple.Create(true, question);
            }
            else
            {
                return Tuple.Create<bool, ProfileQuestion>(false, null);
            }
        }

        internal bool IsSame(ProfileFunction function)
        {
            if (function.ProfileCategories.Count != this.ProfileCategories.Count)
                return false;

            foreach (ProfileCategory profileCategory in function.ProfileCategories)
            {
                ProfileCategory thisCategory;
                if (dictionaryCategoriesBySubLabel.TryGetValue(profileCategory.SubLabel, out thisCategory))
                {
                    if (!thisCategory.IsSame(profileCategory))
                    {
                        return false;
                    }

                }
                else
                    return false;

            }

            return true;
        }
    }
}