//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Models;
using CSET_Main.Common.EnumHelper;
using CSETWeb_Api.BusinessLogic.Models;
using DataLayer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using static BusinessLogic.Models.ExternalRequirement;

namespace CSETWeb_Api.BusinessLogic.Helpers
{
    public static class StandardConverter
    {
        
        public static async Task<ConverterResult<SET>> ToSet(this IExternalStandard externalStandard)
        {
            return await externalStandard.ToSet(new ConsoleLogger());
        }
        public static async Task<ConverterResult<SET>> ToSet(this IExternalStandard externalStandard, ILogger logger)
        {
            var questionDictionary = new Dictionary<string, NEW_QUESTION>();
            var requirementList = new List<string>();

            var categoryDictionary = new Dictionary<string,STANDARD_CATEGORY>();
            var result = new ConverterResult<SET>(logger);
            SETS_CATEGORY category;
            int? categoryOrder = 0;
            var setname= Regex.Replace(externalStandard.ShortName, @"\W", "_");
            try
            {
                var documentImporter = new DocumentImporter();
                var set = result.Result;
                using (var db = new CSETWebEntities())
                {
                    var existingSet = db.SETS.FirstOrDefault(s => s.Set_Name == setname);
                    if (existingSet != null)
                    {
                        result.LogError("Module already exists.  If this is a new version, please change the ShortName field to reflect this.");
                    }
                    category = db.SETS_CATEGORY.FirstOrDefault(s => s.Set_Category_Name.Trim().ToLower() == externalStandard.Category.Trim().ToLower());

                    if (category == null)
                    {
                        result.LogError("Module Category is invalid.  Please check the spelling and try again.");
                    }
                    else
                    {
                        categoryOrder = category.SETS.Max(s => s.Order_In_Category);
                    }
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
                            if (requirementResult.Result.STANDARD_CATEGORY1 != null)
                            {
                                STANDARD_CATEGORY tempCategory;
                                if (categoryDictionary.TryGetValue(requirementResult.Result.STANDARD_CATEGORY1.Standard_Category1, out tempCategory))
                                {
                                    requirementResult.Result.STANDARD_CATEGORY1 = tempCategory;
                                }
                                else
                                {
                                    categoryDictionary.Add(requirementResult.Result.STANDARD_CATEGORY1.Standard_Category1, requirementResult.Result.STANDARD_CATEGORY1);
                                }

                            }
                            foreach (var question in requirementResult.Result.NEW_QUESTION.ToList())
                            {
                                NEW_QUESTION existingQuestion;
                                if (questionDictionary.TryGetValue(question.Simple_Question, out existingQuestion))
                                {
                                    requirementResult.Result.NEW_QUESTION.Remove(question);
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
                            requirementResult.ErrorMessages.ToList().ForEach(s => result.LogError(s));
                        }
                    }
                }
                var questions = requirements.SelectMany(s => s.NEW_QUESTION).ToList();
                for(var i=1; i<=questions.Count(); i++)
                {
                    var question = questions[i - 1];
                    question.Std_Ref_Number = i;
                    question.Std_Ref_Id = question.Std_Ref + question.Std_Ref_Number;
                }
            }
            catch
            {
                result.LogError("Module could not be added.");
            }
            return result;
        }
        public static ExternalStandard ToExternalStandard(this SET standard)
        {
            var externalStandard = new ExternalStandard();
            externalStandard.ShortName = standard.Short_Name;
            externalStandard.Name = standard.Full_Name;
            externalStandard.Summary = standard.Standard_ToolTip;
            externalStandard.Category = standard.SETS_CATEGORY.Set_Category_Name;

            var requirements=new List<ExternalRequirement>();
            //Caching for performance
            using (var db = new CSETWebEntities())
            {
                db.Configuration.ProxyCreationEnabled = false;
                db.Configuration.AutoDetectChangesEnabled = false;
                db.Configuration.LazyLoadingEnabled = false;
                var reqIds = standard.NEW_REQUIREMENT.Select(s => s.Requirement_Id).ToList();
                var reqs = db.NEW_REQUIREMENT.AsNoTracking().Where(s => reqIds.Contains(s.Requirement_Id));
                var reqQuestions = reqs.Select(s=>new { s.Requirement_Id, Questions = s.NEW_QUESTION.Select(t => new { t.Simple_Question, t.Heading_Pair_Id }) }).ToDictionary(s => s.Requirement_Id,s=> s.Questions);
                var reqHeadingIds = standard.NEW_REQUIREMENT.Select(s => s.Question_Group_Heading_Id).ToList();
                var questionHeadings = reqQuestions.SelectMany(s => s.Value.Select(t=>t.Heading_Pair_Id)).Distinct().ToList();
                var reqHeadings = db.QUESTION_GROUP_HEADING.AsNoTracking().Where(s => reqHeadingIds.Contains(s.Question_Group_Heading_Id)).ToDictionary(s=>s.Question_Group_Heading_Id, s=>s.Question_Group_Heading1);
                var headingPairs = db.UNIVERSAL_SUB_CATEGORY_HEADINGS.AsNoTracking().Where(s => questionHeadings.Contains(s.Heading_Pair_Id));
                var subcategories = headingPairs.Join(db.UNIVERSAL_SUB_CATEGORIES, s => s.Universal_Sub_Category_Id, s => s.Universal_Sub_Category_Id, (s, t) => new { s.Heading_Pair_Id, category = t})
                              .ToDictionary(s=>s.Heading_Pair_Id,s=>s.category.Universal_Sub_Category);
                var headings= headingPairs.Join(db.QUESTION_GROUP_HEADING, s => s.Question_Group_Heading_Id, s => s.Question_Group_Heading_Id, (s, t) => new { s.Heading_Pair_Id, category = t })
                              .ToDictionary(s => s.Heading_Pair_Id, s => s.category.Question_Group_Heading1);
                var reqReferences = reqs.Select(s => new
                    {
                        s.Requirement_Id,
                        Resources=s.REQUIREMENT_REFERENCES.Select(t => 
                        new ExternalResource
                        {
                            Destination = t.Destination_String,
                            FileName = t.GEN_FILE.File_Name,
                            PageNumber = t.Page_Number,
                            SectionReference = t.Section_Ref
                        })
                    }).ToDictionary(t => t.Requirement_Id, t => t.Resources);
                var reqSource = reqs.Select(s => new
    {
        s.Requirement_Id,
        Resource = s.REQUIREMENT_SOURCE_FILES.Select(t =>
                          new ExternalResource
        {
            Destination = t.Destination_String,
            FileName = t.GEN_FILE.File_Name,
            PageNumber = t.Page_Number,
            SectionReference = t.Section_Ref
        }).FirstOrDefault()
    }).ToDictionary(t => t.Requirement_Id, t => t.Resource);
                var reqLevels = new Dictionary<int, int?>();
                var tempLevels = reqs.Select(s => new { s.Requirement_Id, levels = s.REQUIREMENT_LEVELS.Select(t => t.Standard_Level) }).ToList();
                if (tempLevels.Any())
                {
                    reqLevels = tempLevels.ToDictionary(s => s.Requirement_Id, s => ((s.levels!=null && s.levels.Any())?s.levels?.Min(t =>
                    {
                        SalValues val;
                        if (Enum.TryParse(t, out val))
                        {
                            return (int)val;
                        }
                        else
                        {
                            return 1;
                        }
                    }) :1));

                }

                foreach (var requirement in standard.NEW_REQUIREMENT)
                {
                    var externalRequirement = new ExternalRequirement()
                    {
                        Identifier = requirement.Requirement_Title,
                        Text = requirement.Requirement_Text,
                        Category = requirement.Standard_Category,
                        Weight = requirement.Weight,
                        Subcategory = requirement.Standard_Sub_Category,
                        Supplemental = requirement.Supplemental_Info
                    };
                    var headingPairId = reqQuestions[requirement.Requirement_Id].Select(s => s.Heading_Pair_Id).FirstOrDefault(s => s != 0);
                    var references = externalRequirement.References;
                    reqReferences.TryGetValue(requirement.Requirement_Id, out references);
                    externalRequirement.References = references.ToList();
                    string heading = null;
                    headings.TryGetValue(headingPairId, out heading);
                    if (String.IsNullOrEmpty(heading))
                    {
                        reqHeadings.TryGetValue(requirement.Question_Group_Heading_Id, out heading);
                    }
                    if (String.IsNullOrEmpty(heading))
                    {
                        throw new Exception("Heading is not valid");
                    }
                    externalRequirement.Heading = heading;
                    IEnumerable<string> questions = new List<string>();
                    reqQuestions.ToDictionary(s => s.Key, s => s.Value.Select(e => e.Simple_Question)).TryGetValue(requirement.Requirement_Id, out questions);
                    externalRequirement.Questions = new QuestionList();
                    externalRequirement.Questions.AddRange(questions);
                    string subheading = null;
                    subcategories.TryGetValue(headingPairId,out subheading);
                    if (subheading == null)
                    {
                        subheading = heading;
                    }
                    externalRequirement.Subheading = subheading;
                    var source = externalRequirement.Source;
                    reqSource.TryGetValue(requirement.Requirement_Id, out source);
                    externalRequirement.Source = source;
                    int? sal;
                    reqLevels.TryGetValue(requirement.Requirement_Id, out sal);
                    externalRequirement.SecurityAssuranceLevel = sal;
                    requirements.Add(externalRequirement);
                }
                externalStandard.Requirements = requirements;
            }
            return externalStandard;
        }
    }
}


