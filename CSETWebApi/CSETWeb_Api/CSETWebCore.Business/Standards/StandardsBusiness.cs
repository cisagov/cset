//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Interfaces.Standards;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Question;
using CSETWebCore.Model.Standards;

namespace CSETWebCore.Business.Standards
{
    public class StandardsBusiness : IStandardsBusiness
    {
        private CSETContext _context;
        private IAssessmentUtil _assessmentUtil;
        private ITokenManager _tokenManager;
        private IQuestionRequirementManager _questionRequirement;
        private IDemographicBusiness _demographicBusiness;

        public StandardsBusiness(CSETContext context, IAssessmentUtil assessmentUtil,
            IQuestionRequirementManager questionRequirement, ITokenManager tokenManager,
            IDemographicBusiness demographicBusiness)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
            _tokenManager = tokenManager;
            _demographicBusiness = demographicBusiness;
            _questionRequirement = questionRequirement;
        }

        /// <summary>
        /// Returns a list of all displayable cybersecurity standards.
        /// Standards recommended for the assessment's demographics are marked as 'recommended.'
        /// 
        /// If the assessment is using a deprecated standard, it will be included in the
        /// list and marked as deprecated.
        /// </summary>
        /// <returns></returns>
        public StandardsResponse GetStandards(int assessmentId)
        {
            StandardsResponse response = new StandardsResponse();

            List<StandardCategory> categories = new List<StandardCategory>();
            List<Standard> standardsList = new List<Standard>();
            List<string> recommendedSets = RecommendedStandards(assessmentId);
            List<string> selectedSets = new List<string>();

            // Build a list of standards already selected for this assessment
            selectedSets = _context.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId && x.Selected).Select(x => x.Set_Name).ToList();


            var query = from sc in _context.SETS_CATEGORY
                        from s in _context.SETS.Where(set => set.Set_Category_Id == sc.Set_Category_Id
                            && (set.Is_Displayed)
                            && (!set.IsEncryptedModule
                            || (set.IsEncryptedModule && (set.IsEncryptedModuleOpen)))
                            )
                        select new { s, sc.Set_Category_Name };

            var result = query.OrderBy(x => x.Set_Category_Name).ThenBy(x => x.s.Order_In_Category).ToList();


            // clean out any deprecated standards that this assessment is not using
            result.RemoveAll(x => x.s.Is_Deprecated && !selectedSets.Contains(x.s.Set_Name));

            // label any remaining as deprecated
            result.Where(x => x.s.Is_Deprecated).ToList().ForEach(y =>
            {
                y.s.Full_Name += " [DEPRECATED]";
            });


            string currCategoryName = string.Empty;

            foreach (var set in result)
            {
                if (set.Set_Category_Name != currCategoryName)
                {
                    // create a new Category
                    StandardCategory cat = new StandardCategory();
                    cat.CategoryName = set.Set_Category_Name;
                    categories.Add(cat);

                    currCategoryName = set.Set_Category_Name;
                }

                Standard std = new Standard
                {
                    Code = set.s.Set_Name,
                    FullName = set.s.Full_Name,
                    Description = set.s.Standard_ToolTip,
                    Selected = selectedSets.Contains(set.s.Set_Name),
                    Recommended = recommendedSets.Contains(set.s.Set_Name)
                };
                categories.Last().Standards.Add(std);
            }

            // Build the response
            response.Categories = categories;
            _questionRequirement.AssessmentId = assessmentId;
            response.QuestionCount = _questionRequirement.NumberOfQuestions();
            response.RequirementCount = _questionRequirement.NumberOfRequirements();
            return response;
        }


        public bool GetFramework(int assessmentId)
        {
            return _context.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId && x.Set_Name == "NCSF_V1" && x.Selected)
                .FirstOrDefault() == null ? false : true;
        }


        public bool GetACET(int assessmentId)
        {
            return !(_context.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId && x.Set_Name == "ACET_V1" && x.Selected).FirstOrDefault() == null);
        }


        /// <summary>
        /// Returns a list of recomended standards, based on the assessment demographics.
        /// </summary>
        /// <returns></returns>
        public List<string> RecommendedStandards(int assessmentId)
        {
            List<string> list = new List<string>();

            // Get the demographics for this assessment
            Demographics demographics = _demographicBusiness.GetDemographics(assessmentId);

            if (demographics == null)
            {
                return list;
            }

            // Convert Size and AssetValue from their keys to the strings they are stored as
            string assetValue = _context.DEMOGRAPHICS_ASSET_VALUES.Where(dav => dav.DemographicsAssetId == demographics.AssetValue).FirstOrDefault()?.AssetValue;
            string assetSize = _context.DEMOGRAPHICS_SIZE.Where(dav => dav.DemographicId == demographics.Size).FirstOrDefault()?.Size;

            // Build a list of standard sets that are recommended for the current demographics
            list = _context.SECTOR_STANDARD_RECOMMENDATIONS.Where(
                            x => x.Industry_Id == demographics.IndustryId
                            && x.Sector_Id == demographics.SectorId
                            && x.Organization_Size == assetSize
                            && x.Asset_Value == assetValue)
                            .Select(x => x.Set_Name).ToList();

            // Remove any trailing spaces
            for (int i = 0; i < list.Count; i++)
            {
                list[i] = list[i].Trim();
            }

            return list;
        }


        /// <summary>
        /// Saves the list of selected Standards.
        /// </summary>
        /// <param name="selectedStandards"></param>
        /// <returns></returns>
        public QuestionRequirementCounts PersistSelectedStandards(int assessmentId, List<string> selectedStandards)
        {
            var result = _context.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId);
            _context.AVAILABLE_STANDARDS.RemoveRange(result);
            _context.SaveChanges();

            if (selectedStandards != null)
            {
                foreach (string std in selectedStandards)
                {
                    _context.AVAILABLE_STANDARDS.Add(new AVAILABLE_STANDARDS()
                    {
                        Assessment_Id = assessmentId,
                        Set_Name = std,
                        Selected = true
                    });
                }
                _context.SaveChanges();
            }

            _assessmentUtil.TouchAssessment(assessmentId);

            // Return the numbers of active Questions and Requirements
            QuestionRequirementCounts counts = new QuestionRequirementCounts();
            _questionRequirement.AssessmentId = assessmentId;
            counts.QuestionCount = _questionRequirement.NumberOfQuestions();
            counts.RequirementCount = _questionRequirement.NumberOfRequirements();
            return counts;
        }


        /// <summary>
        /// Clears any other selected standards and adds the default standard.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public QuestionRequirementCounts PersistDefaultSelectedStandard(int assessmentId)
        {
            var result = _context.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId);
            _context.AVAILABLE_STANDARDS.RemoveRange(result);

            var selectedStandards = GetDefaultStandardsList();
            if (selectedStandards.Any())
            {
                foreach (string std in selectedStandards)
                {
                    _context.AVAILABLE_STANDARDS.Add(new AVAILABLE_STANDARDS()
                    {
                        Assessment_Id = assessmentId,
                        Set_Name = std,
                        Selected = true
                    });
                }

                _context.SaveChanges();
            }

            _assessmentUtil.TouchAssessment(assessmentId);

            // Return the numbers of active Questions and Requirements
            QuestionRequirementCounts counts = new QuestionRequirementCounts();
            _questionRequirement.AssessmentId = assessmentId;
            counts.QuestionCount = _questionRequirement.NumberOfQuestions();
            counts.RequirementCount = _questionRequirement.NumberOfRequirements();
            return counts;
        }


        /// <summary>
        /// Returns a list of 'default' standards for a 'basic' assessment.
        /// This has been decided to be the 'Key' set, rather than using the demographics
        /// to look up sets in the SECTOR_STANDARD_RECOMMENDATIONS table as before.
        /// 
        /// If the calling app is CSET, default to 'Key'.
        /// If the calling app is ACET, default to 'ACET_V1'.
        /// 
        /// </summary>
        /// <returns></returns>
        public List<string> GetDefaultStandardsList()
        {
            var scope = _tokenManager.Payload("scope");

            List<string> basicStandards = new List<string>();

            switch (scope.ToLower())
            {
                case "cset":
                    basicStandards.Add("Key");
                    break;
                case "acet":
                    basicStandards.Add("ACET_V1");
                    break;
            }

            return basicStandards;
        }
    }
}