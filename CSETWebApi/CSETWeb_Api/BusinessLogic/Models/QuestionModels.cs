//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using DataLayerCore.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CSETWeb_Api.Models
{
    /// <summary>
    /// A response containing a structure of questions in their group/subgroups
    /// plus the current application mode (questions/requirements) of the assessment.
    /// </summary>
    public class QuestionResponse
    {
        public List<Domain> Domains;
        // public List<Category> Categories;

        // The current mode of the assessment
        public string ApplicationMode;

        // The count of all questions in the response.
        public int QuestionCount;

        // The count of all requirements in the response.
        public int RequirementCount;



        /// <summary>
        /// The calculated IRP.  If overridden, the override is returned.
        /// </summary>
        public int OverallIRP;

        public int DefaultComponentsCount { get; internal set; }
    }


    /// <summary>
    /// 
    /// </summary>
    public class Domain
    {
        /// <summary>
        /// The text displayed in the TOC.  If this container represents a maturity domain,
        /// it contains the name of the domain.
        /// </summary>
        public string DisplayText;

        /// <summary>
        /// Display text that appears below the domain name.  Not used for ACET but may be used for EDM.
        /// </summary>
        public string DomainText;

        /// <summary>
        /// Lists the display names of the maturity levels.
        /// </summary>
        public List<MaturityLevel> Levels;

        /// <summary>
        /// A list of categories within the domain.  CMMC domains correspond with
        /// categories, so there will be a single category in each CMMC domain.
        /// </summary>
        public List<QuestionGroup> Categories = new List<QuestionGroup>();


    }


    /// <summary>
    /// 
    /// </summary>
    public class MaturityLevel
    {
        public int Level;
        public string Label;
        public bool Applicable;
    }


    /// <summary>
    /// A container class that holds a collection of Categories / QuestionGroups.
    /// It is used for:
    ///  - a maturity Domain
    ///  - the Standard Questions node when in Questions mode
    ///  - the Component Defaults node
    ///  - the Component Overrides node
    /// </summary>
    public class CategoryContainer
    {
        /// <summary>
        /// The text displayed in the TOC.  If this container represents a maturity domain,
        /// it contains the name of the domain.
        /// </summary>
        public string DisplayText;

        /// <summary>
        /// Corresponds to the StandardCategory of the questions/requirements it encapsulates.
        /// </summary>
        public string AssessmentFactorName;

        /// <summary>
        /// If this is a domain, this indicates if maturity levels should be shown on the requirements page.
        /// </summary>
        public bool ShowMaturityLevels;

        /// <summary>
        /// The list of question groups or categories for the assessment
        /// </summary>
        public List<QuestionGroup> QuestionGroups = new List<QuestionGroup>();
    }


    /// <summary>
    /// A grouping of subgroups/subcategoriess.
    /// </summary>
    public class QuestionGroup
    {
        public bool IsOverride;
        public Guid NavigationGUID;
        public int GroupHeadingId;
        public string GroupHeadingText;
        public string StandardShortName;       
        public string ComponentName;
        public string SetName;
        public List<QuestionSubCategory> SubCategories = new List<QuestionSubCategory>();

        public string Symbol_Name { get; internal set; }
        public QuestionGroup()
        {
            this.NavigationGUID = Guid.NewGuid();
            this.IsOverride = false;
        }
    }

    /// <summary>
    /// A subgroup containing a list of questions.
    /// </summary>
    public class QuestionSubCategory
    {
        public Guid NavigationGUID;
        public int GroupHeadingId;
        public int SubCategoryId;
        public string SubCategoryHeadingText;
        public string HeaderQuestionText;
        public string SubCategoryAnswer;
        public List<QuestionAnswer> Questions = new List<QuestionAnswer>();

        public QuestionSubCategory()
        {
            this.NavigationGUID = Guid.NewGuid();
        }
    }

    /// <summary>
    /// One question and its answer fields.  This is used for both Question and Requirement modes.
    /// </summary>
    public class QuestionAnswer
    {
        /// <summary>
        /// An ordinal number in the case of a Question, and the requirement title/version
        /// in the case of Requirement.
        /// </summary>
        public string DisplayNumber;
        public int QuestionId;
        public string QuestionText;
        public List<ParameterToken> ParmSubs;
        public string StdRefId;
        public string Answer;
        public string AltAnswerText;
        public string Comment;
        public string Feedback;
        public bool MarkForReview;
        public string SetName;

        /// <summary>
        /// Indicates an answer that has been reviewed.  
        /// This field was added for NCUA/ACET support.
        /// </summary>
        public bool Reviewed;
        public bool HasComment { get; set; }        
        public bool HasDocument { get; set; }
        public bool HasFeedback { get; set; }
        public int docnum { get; set; }
        public bool HasDiscovery { get; set; }
        public int findingnum { get; set; }
        public int? Answer_Id { get; set; }

        /// <summary>
        /// Indicates the maturity level of the question/requirement/statement
        /// </summary>
        public int MaturityLevel { get; set; }
        public bool Is_Maturity { get; set; }
        public bool Is_Component { get; set; }
        public Guid ComponentGuid { get; set; }
        public bool Is_Requirement { get; set; }
    }


    /// <summary>
    /// Describes the user's answer, including Y/N/NA/ALT as well as
    /// comments and alt text.
    /// </summary>
    public class Answer
    {
        public int QuestionId;

        /// <summary>
        /// The sequential number that was assigned when the question list was built.
        /// </summary>
        public int QuestionNumber;

        public string AnswerText;
        public string AltAnswerText;
        public string Comment;
        public string Feedback;
        public bool MarkForReview;
        public Guid ComponentGuid;

        /// <summary>
        /// Indicates an answer that has been reviewed.  
        /// This field was added for NCUA/ACET support.
        /// </summary>
        public bool Reviewed;

        public bool Is_Requirement;

        public bool Is_Component;

        public bool Is_Maturity;
    }


    /// <summary>
    /// A response object containing the total number of active
    /// questions and requirements.  
    /// </summary>
    public class QuestionRequirementCounts
    {
        /// <summary>
        /// The number of active Questions based on the selected Standards.
        /// </summary>
        public int QuestionCount;

        /// <summary>
        /// The number of active Requirements based on the selected Standards.
        /// </summary>
        public int RequirementCount;
    }


    /// <summary>
    /// Encapsulates a mass answer update request, such as when the user 
    /// selects an 'N' or 'NA' answer for a subcategory.
    /// </summary>
    public class SubCategoryAnswers
    {
        /// <summary>
        /// 
        /// </summary>
        public int GroupHeadingId;

        /// <summary>
        /// 
        /// </summary>
        public int SubCategoryId;

        /// <summary>
        /// The answer stored in the SUB_CATEGORY_ANSWERS table.
        /// </summary>
        public string SubCategoryAnswer;

        /// <summary>
        /// The collection of answers to the questions in the subcategory
        /// </summary>
        public List<Answer> Answers;
    }


    /// <summary>
    /// This is used to quickly get the IDs for Question_Group_Heading and Universal_Sub_Category
    /// relationships.
    /// </summary>
    public class GroupAndSubcategory
    {
        public int QuestionGroupHeadingId;
        public string QuestionGroupHeadingText;
        public int SubCategoryId;
        public string SubCategoryHeadingText;
        public string SubCategoryHeaderQuestionText;
    }


    /// <summary>
    /// A collection of PARAMETERS [tokens] and their 
    /// configured substitution text values.
    /// </summary>
    public class ParameterSubstitution
    {
        public List<ParameterToken> Tokens = new List<ParameterToken>();


        /// <summary>
        /// Adds a new element to the tokens list or overwrites
        /// if it already exists.  This is so that we can overlay
        /// global settings with local/answer settings.
        /// </summary>
        /// <param name="token"></param>
        /// <param name="substitution"></param>
        public void Set(int id, string token, string substitution, int reqId, int ansId)
        {
            var t = this.Tokens.Find(x => x.Token == token);
            if (t != null)
            {
                t.Substitution = substitution;
                t.RequirementId = reqId;
                t.AnswerId = ansId;
            }
            else
            {
                Tokens.Add(new ParameterToken(id, token, substitution, reqId, ansId));
            }
        }
    }


    /// <summary>
    /// Defines one parameter override token.
    /// </summary>
    public class ParameterToken
    {
        public int Id;
        public string Token;
        public string Substitution;
        public int RequirementId;
        public int AnswerId;

        /// <summary>
        /// Constructor
        /// </summary>
        public ParameterToken(int id, string token, string substitution, int reqId, int ansId)
        {
            this.Id = id;
            this.Token = token;
            this.Substitution = substitution;
            this.RequirementId = reqId;
            this.AnswerId = ansId;
        }
    }
}

