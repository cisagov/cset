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

    public class QuestionDetail
    {
        public int QuestionID;
        public string QuestionText;
        public string Category;
        public string Subcategory;
        public string Level;
        public string Title;
        public bool IsCustom;
    }

    public class SetQuestion
    {
        public string SetName;
        public int QuestionID;

        /// <summary>
        /// Used when creating a new question from text.
        /// </summary>
        public string NewQuestionText;
        public int NewQuestionCategory;
        public int NewQuestionSubcategory;
    }

    public class CategoryEntry
    {
        public int ID;
        public string Text;
    }
}
