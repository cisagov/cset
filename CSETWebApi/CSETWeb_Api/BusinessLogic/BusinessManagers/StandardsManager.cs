//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using System.Linq;
using CSETWeb_Api.Models;
using DataLayerCore.Model;
using CSETWeb_Api.BusinessLogic.Helpers;
using CSETWeb_Api.Helpers;

namespace CSETWeb_Api.BusinessManagers
{
    /// <summary>
    /// Encapsulates functionality related to Standards.
    /// </summary>
    public class StandardsManager
    {
        /// <summary>
        /// Returns a list of all displayable cybersecurity standards.
        /// Standards recommended for the assessment's demographics are marked as 'recommended.'
        /// </summary>
        /// <returns></returns>
        public StandardsResponse GetStandards(int assessmentId)
        {
            StandardsResponse response = new StandardsResponse();

            List<StandardCategory> categories = new List<StandardCategory>();
            List<CSETWeb_Api.Models.Standard> standardsList = new List<CSETWeb_Api.Models.Standard>();
            List<string> recommendedSets = RecommendedStandards(assessmentId);
            List<string> selectedSets = new List<string>();


            using (var db = new CSET_Context())
            {
                // Build a list of standards already selected for this assessment
                selectedSets = db.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId && x.Selected).Select(x => x.Set_Name).ToList();


                var query = from sc in db.SETS_CATEGORY
                            from s in db.SETS.Where(set => set.Set_Category_Id == sc.Set_Category_Id
                                && !set.Is_Deprecated && (set.Is_Displayed??false)
                                && (!set.IsEncryptedModule
                                || (set.IsEncryptedModule && (set.IsEncryptedModuleOpen ?? true)))
                                )
                            select new { s, sc.Set_Category_Name };

                var result = query.OrderBy(x => x.Set_Category_Name).ToList();


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

                    CSETWeb_Api.Models.Standard std = new CSETWeb_Api.Models.Standard
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
                response.QuestionCount = new QuestionsManager(assessmentId).NumberOfQuestions();
                response.RequirementCount = new RequirementsManager(assessmentId).NumberOfRequirements();
                return response;
            }
        }

        public bool GetFramework(int assessmentId)
        {
            using (var db = new CSET_Context())
            {
                return db.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId && x.Set_Name == "NCSF_V1" && x.Selected)
                    .FirstOrDefault() == null ? false : true;
            }

        }

        public bool GetACET(int assessmentId)
        {
            using (var db = new CSET_Context())
            {
                return !(db.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId && x.Set_Name == "ACET_V1" && x.Selected).FirstOrDefault() == null);
            }
        }


        /// <summary>
        /// Returns a list of recomended standards, based on the assessment demographics.
        /// </summary>
        /// <returns></returns>
        private List<string> RecommendedStandards(int assessmentId)
        {
            List<string> list = new List<string>();

            // Get the demographics for this assessment
            Demographics demographics = new AssessmentManager().GetDemographics(assessmentId);

            if (demographics == null)
            {
                return list;
            }

            using (var db = new CSET_Context())
            {
                // Convert Size and AssetValue from their keys to the strings they are stored as
                string assetValue = db.DEMOGRAPHICS_ASSET_VALUES.Where(dav => dav.DemographicsAssetId == demographics.AssetValue).FirstOrDefault()?.AssetValue;
                string assetSize = db.DEMOGRAPHICS_SIZE.Where(dav => dav.DemographicId == demographics.Size).FirstOrDefault()?.Size;

                // Build a list of standard sets that are recommended for the current demographics
                list = db.SECTOR_STANDARD_RECOMMENDATIONS.Where(
                                x => x.Industry_Id == demographics.IndustryId
                                && x.Sector_Id == demographics.SectorId
                                && x.Organization_Size == assetSize
                                && x.Asset_Value == assetValue)
                                .Select(x => x.Set_Name).ToList();
            }

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
            using (var db = new CSET_Context())
            {
                var result = db.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId);
                db.AVAILABLE_STANDARDS.RemoveRange(result);


                // If we were handed an empty list, get the default standards
                if (selectedStandards.Count == 1 && selectedStandards[0] == "***DEFAULT***")
                {
                    selectedStandards = GetDefaultStandardsList();
                }

                foreach (string std in selectedStandards)
                {
                    db.AVAILABLE_STANDARDS.Add(new AVAILABLE_STANDARDS()
                    {
                        Assessment_Id = assessmentId,
                        Set_Name = std,
                        Selected = true
                    });
                }
                db.SaveChanges();
            }

            AssessmentUtil.TouchAssessment(assessmentId);

            // Return the numbers of active Questions and Requirements
            QuestionRequirementCounts counts = new QuestionRequirementCounts();
            counts.QuestionCount = new QuestionsManager(assessmentId).NumberOfQuestions();
            counts.RequirementCount = new RequirementsManager(assessmentId).NumberOfRequirements();
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
        private List<string> GetDefaultStandardsList()
        {
            TokenManager tm = new TokenManager();
            var appCode = tm.Payload("scope");

            List<string> basicStandards = new List<string>();

            switch (appCode.ToLower())
            {
                case "cset":
                    //basicStandards.Add("Key");
                    break;
                case "acet":
                    basicStandards.Add("ACET_V1");
                    break;
            }

            return basicStandards;
        }
    }
}

