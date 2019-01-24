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
        public int RequirementID;
    }

    public class QuestionListResponse
    {
        public string SetFullName;
        public string SetShortName;
        public string SetDescription;
        public List<QuestionListCategory> Categories = new List<QuestionListCategory>();
    }

    public class QuestionListCategory
    {
        public string CategoryName;
        public List<QuestionListSubcategory> Subcategories = new List<QuestionListSubcategory>();
    }

    public class QuestionListSubcategory
    {
        public int PairID;
        public string SubcategoryName;
        public string SubHeading;

        /// <summary>
        /// Only subheadings on custom question pairs are editable.
        /// </summary>
        public bool IsSubHeadingEditable;
        public List<QuestionDetail> Questions = new List<QuestionDetail>();
    }

       public class QuestionDetail
    {
        public int QuestionID;
        public string QuestionText;
        public string Category;

        /// <summary>
        /// The primary key of the UNIVERSAL_SUBCATEGORY_HEADING.
        /// </summary>
        public int PairID;
        public string Subcategory;
        public string SubHeading;

        public string Title;
        public bool IsCustom;
        public List<string> SalLevels = new List<string>();
    }

    public class SetQuestion
    {
        /// <summary>
        /// SetName is specified when the question is attached to the set
        /// </summary>
        public string SetName;

        /// <summary>
        /// RequirementID is specified when the question is attached to a requirement.
        /// </summary>
        public int RequirementID;

        public int QuestionID;
        public int QuestionCategoryID;

        /// <summary>
        /// The name of a new subcategory.  Only used when the user has invented 
        /// a new subcategory name.
        /// </summary>
        public string QuestionSubcategoryText;

        /// <summary>
        /// Used when creating a new question from text.
        /// </summary>
        public string CustomQuestionText;

        public List<string> SalLevels;
    }

    public class CategoriesSubcategoriesGroupHeadings
    {
        public List<CategoryEntry> Categories;
        public List<CategoryEntry> Subcategories;
        public List<CategoryEntry> GroupHeadings;
    }

    public class CategoryEntry
    {
        public int ID;
        public string Text;
    }

    public class SalParms
    {
        public string SetName;
        public int RequirementID;
        public int QuestionID;

        // Whether the level should be applied (true) or removed (false)
        public bool State;
        public string Level;
    }

    public class QuestionTextUpdateParms
    {
        public int QuestionID;
        public string QuestionText;
    }

    public class HeadingUpdateParms
    {
        public int PairID;
        public string HeadingText;
    }

    ////////////////////////////////////////////////////////////
    /// 
    /// Classes related to Standards and Requirements
    /// 
    ////////////////////////////////////////////////////////////

    public class StandardsResponse
    {
        public string SetFullName;
        public string SetShortName;
        public string SetDescription;
        public List<RequirementListCategory> Categories = new List<RequirementListCategory>();
    }

    public class RequirementListCategory
    {
        public string CategoryName;
        public List<RequirementListSubcategory> Subcategories = new List<RequirementListSubcategory>();
    }

    public class RequirementListSubcategory
    {
        public string SubcategoryName;
        public List<Requirement> Requirements = new List<Requirement>();
    }

    public class Requirement
    {
        public int RequirementID;
        public string SetName;
        public string Category;
        public string Subcategory;
        public int QuestionGroupHeadingID;
        public string Title;
        public string RequirementText;
        public List<string> SalLevels = new List<string>();
        public string SupplementalInfo;
        public List<ReferenceDoc> ReferenceDocs = new List<ReferenceDoc>();
        public List<QuestionDetail> Questions = new List<QuestionDetail>();
    }

    public class Supplemental
    {
        public int RequirementID;
        public string Markup;
    }

    public class ReferenceDoc
    {
        public int ID;
        public string Title;
        public string FileName;
        public string SectionRef;
        public bool IsUploaded;
    }
}
