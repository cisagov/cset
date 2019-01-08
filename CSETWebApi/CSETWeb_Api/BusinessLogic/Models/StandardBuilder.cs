using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Models
{
    public class SetListResponse
    {
        public List<SetDetail> SetList;        
    }

    public class SetDetail
    {
        public string SetName;
        public string FullName;
        public string ShortName;

        public bool Clonable;
        public bool Deletable;

        /// <summary>
        /// Maps to Standard_ToolTip
        /// </summary>
        public string Description;
        public int? SetCategory;

        public bool IsCustom;
        public bool IsDisplayed;

        public List<SetCategory> CategoryList;
    }

    public class SetCategory
    {
        public int Id;
        public string CategoryName;

        public SetCategory(int id, string categoryName)
        {
            this.Id = id;
            this.CategoryName = categoryName;
        }
    }

    public class QuestionSearch
    {
        public string SearchTerms;
        public string SetName;
    }

    public class QuestionListResponse
    {
        public List<QuestionListCategory> Categories = new List<QuestionListCategory>();
    }

    public class QuestionListCategory
    {
        public string CategoryName;
        public List<QuestionListSubcategory> Subcategories = new List<QuestionListSubcategory>();
    }

    public class QuestionListSubcategory
    {
        public string SubcategoryName;
        public List<QuestionDetail> Questions = new List<QuestionDetail>();
    }

    public class QuestionDetail
    {
        public int QuestionID;
        public string QuestionText;
        public string Category;
        public string Subcategory;
        public string Title;
        public bool IsCustom;
        public List<string> SalLevels = new List<string>();
    }

    public class SetQuestion
    {
        public string SetName;
        public int QuestionID;
        public int QuestionCategory;
        public int QuestionSubcategory;

        public List<string> SalLevels;

        /// <summary>
        /// Used when creating a new question from text.
        /// </summary>
        public string NewQuestionText;
    }

    public class CategoryEntry
    {
        public int ID;
        public string Text;
    }

    public class SalParms
    {
        public string SetName;
        public int QuestionID;

        // Whether the level should be applied (true) or removed (false)
        public bool State;
        public string Level;
    }
}
