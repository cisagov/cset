using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BusinessLogic.Models;
using CSET_Main.Common.EnumHelper;
using CSETWeb_Api.BusinessLogic.Models;
using DataLayerCore.Model;
using System.Security.Cryptography;
using System.Text.RegularExpressions;
using static BusinessLogic.Models.ExternalRequirement;
using Microsoft.EntityFrameworkCore;


namespace CSETWeb_Api.BusinessLogic.Helpers
{
    /// <summary>
    /// This is an alternate way to convert module JSON
    /// and persist to the database.
    /// </summary>
    public class ModuleImporter
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="externalStandard"></param>
        public static void DoIt(IExternalStandard externalStandard)
        {
            
            // var result = new ConverterResult<SETS>(logger);
            SETS_CATEGORY category;
            int? categoryOrder = 0;
            var setname = Regex.Replace(externalStandard.ShortName, @"\W", "_");

            var documentImporter = new DocumentImporter();
            // var set = result.Result;
            var set = new SETS();

            var db = new CSET_Context();

            var existingSet = db.SETS.FirstOrDefault(s => s.Set_Name == setname);
            if (existingSet != null)
            {
                // result.LogError("Module already exists.  If this is a new version, please change the ShortName field to reflect this.");
            }
            category = db.SETS_CATEGORY.FirstOrDefault(s => s.Set_Category_Name.Trim().ToLower() == externalStandard.Category.Trim().ToLower());

            if (category == null)
            {
                // result.LogError("Module Category is invalid.  Please check the spelling and try again.");
            }
            else
            {
                categoryOrder = category.SETS.Max(s => s.Order_In_Category);
            }

            set.Set_Category_Id = category?.Set_Category_Id;
            set.Order_In_Category = categoryOrder;
            set.Short_Name = externalStandard.ShortName;
            set.Set_Name = setname;
            set.Full_Name = externalStandard.Name;
            set.Is_Custom = true;
            set.Is_Question = true;
            set.Is_Requirement = true;
            set.Is_Displayed = true;
            set.IsEncryptedModuleOpen = true;
            set.IsEncryptedModule = false;
            set.Is_Deprecated = false;

            set.Standard_ToolTip = externalStandard.Summary;

            db.SETS.Add(set);
            db.SaveChanges();


            DoRequirements(externalStandard, set, db);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="set"></param>
        /// <param name="db"></param>
        private static async void DoRequirements(IExternalStandard externalStandard, SETS set, CSET_Context db)
        {
            var questionDictionary = new Dictionary<string, NEW_QUESTION>();
            var categoryDictionary = new Dictionary<string, STANDARD_CATEGORY>();
            var requirementList = new List<string>();

            set.NEW_REQUIREMENT = new List<NEW_REQUIREMENT>();
            var requirements = set.NEW_REQUIREMENT;
            int counter = 0;

            foreach (var requirement in externalStandard.Requirements)
            {
                //skip duplicates
                if (!requirementList.Any(s => s == requirement.Identifier.Trim().ToLower() + "|||" + requirement.Text.Trim().ToLower()))
                {
                    counter++;
                    var requirementResult = await requirement.ToRequirement(set.Set_Name, new ConsoleLogger());
                    if (requirementResult.IsSuccess)
                    {
                        requirementResult.Result.REQUIREMENT_SETS.FirstOrDefault().Requirement_Sequence = counter;
                        if (requirementResult.Result.Standard_CategoryNavigation != null)
                        {
                            STANDARD_CATEGORY tempCategory;
                            if (categoryDictionary.TryGetValue(requirementResult.Result.Standard_CategoryNavigation.Standard_Category1, out tempCategory))
                            {
                                requirementResult.Result.Standard_CategoryNavigation = tempCategory;
                            }
                            else
                            {
                                categoryDictionary.Add(requirementResult.Result.Standard_CategoryNavigation.Standard_Category1, requirementResult.Result.Standard_CategoryNavigation);
                            }
                        }

                        foreach (var question in requirementResult.Result.NEW_QUESTIONs().ToList())
                        {
                            NEW_QUESTION existingQuestion;
                            if (questionDictionary.TryGetValue(question.Simple_Question, out existingQuestion))
                            {
                                requirementResult.Result.REQUIREMENT_QUESTIONS.Remove(new REQUIREMENT_QUESTIONS() { Question_Id = question.Question_Id, Requirement_Id = requirementResult.Result.Requirement_Id });
                            }
                            else
                            {
                                questionDictionary.Add(question.Simple_Question, question);
                            }
                        }
                        requirementList.Add(requirementResult.Result.Requirement_Title.Trim().ToLower() + "|||" + requirementResult.Result.Requirement_Text.Trim().ToLower());
                        requirements.Add(requirementResult.Result);
                    }
                    else
                    {
                        // requirementResult.ErrorMessages.ToList().ForEach(s => result.LogError(s));
                    }
                }
            }
        }
    }
}
