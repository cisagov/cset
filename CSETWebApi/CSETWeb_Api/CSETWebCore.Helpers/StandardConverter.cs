//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using CSETWebCore.Interfaces;
using CSETWebCore.Model.AssessmentIO;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;


namespace CSETWebCore.Helpers
{
    public static class StandardConverter
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="externalStandard"></param>
        /// <returns></returns>
        public static async Task<ConverterResult<SETS>> ToSet(this ExternalStandard externalStandard, CSETContext _context)
        {
            return await externalStandard.ToSet(new ConsoleLogger(), _context);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="externalStandard"></param>
        /// <param name="logger"></param>
        /// <returns></returns>
        public static async Task<ConverterResult<SETS>> ToSet(this ExternalStandard externalStandard, ILogger logger, CSETContext _context)
        {
            var questionDictionary = new Dictionary<string, NEW_QUESTION>();
            var requirementList = new List<string>();

            var categoryDictionary = new Dictionary<string, STANDARD_CATEGORY>();
            var result = new ConverterResult<SETS>(logger);
            SETS_CATEGORY category;
            int? categoryOrder = 0;
            var setname = Regex.Replace(externalStandard.name, @"\W", "_");
            
            try
            {
                var documentImporter = new DocumentImporter(_context);
                var set = result.Result;

                var existingSet = _context.SETS.FirstOrDefault(s => s.Set_Name == setname);
                if (existingSet != null)
                {
                    result.LogError("Module already exists.  If this is a new version, please change the ShortName field to reflect this.");
                }
                category = _context.SETS_CATEGORY.FirstOrDefault(s => s.Set_Category_Name.Trim().ToLower() == externalStandard.category.Trim().ToLower());

                if (category == null)
                {
                    result.LogError("Module Category is invalid.  Please check the spelling and try again.");
                }
                else
                {
                    categoryOrder = category.SETS.Max(s => s.Order_In_Category);
                }

                set.Set_Category_Id = category?.Set_Category_Id;
                set.Order_In_Category = categoryOrder;
                set.Short_Name = externalStandard.shortName;
                set.Set_Name = setname;
                set.Full_Name = externalStandard.name;
                set.Is_Custom = true;
                set.Is_Question = true;
                set.Is_Requirement = true;
                set.Is_Displayed = true;
                set.IsEncryptedModuleOpen = true;
                set.IsEncryptedModule = false;
                set.Is_Deprecated = false;

                set.Standard_ToolTip = externalStandard.summary;


                set.NEW_REQUIREMENT = new List<NEW_REQUIREMENT>();
                var requirements = set.NEW_REQUIREMENT;
                int counter = 0;
                foreach (var requirement in externalStandard.requirements)
                {
                    //skip duplicates
                    if (!requirementList.Any(s => s == requirement.identifier.Trim().ToLower() + "|||" + requirement.text.Trim().ToLower()))
                    {
                        counter++;
                        var requirementResult = await RequirementConverter.ToRequirement(requirement, set.Set_Name, new ConsoleLogger(), _context);
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

                            foreach (var question in requirementResult.Result.NEW_QUESTIONs(_context).ToList())
                            {
                                NEW_QUESTION existingQuestion;
                                if (questionDictionary.TryGetValue(question.Simple_Question, out existingQuestion))
                                {
                                    requirementResult.Result.REQUIREMENT_QUESTIONS_SETS.Remove(new REQUIREMENT_QUESTIONS_SETS() { Question_Id = question.Question_Id, Requirement_Id = requirementResult.Result.Requirement_Id });
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
                var questions = requirements.SelectMany(s => s.NEW_QUESTIONs(_context)).ToList();
                for (var i = 1; i <= questions.Count(); i++)
                {
                    var question = questions[i - 1];
                    question.Std_Ref_Number = i;
                    question.Std_Ref_Id = question.Std_Ref + question.Std_Ref_Number;
                }
            }
            catch (Exception)
            {
                result.LogError("Module could not be added.");
            }

            _context.SaveChanges();

            return result;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="standard"></param>
        /// <returns></returns>
        public static ExternalStandard ToExternalStandard(this SETS standard, CSETContext _context)
        {
            var externalStandard = new ExternalStandard();
            externalStandard.shortName = standard.Short_Name;
            externalStandard.name = standard.Full_Name;
            externalStandard.summary = standard.Standard_ToolTip;
            externalStandard.category = standard.Set_Category?.Set_Category_Name ?? "";

            var requirements = new List<ExternalRequirement>();
            //Caching for performance

            //db.Configuration.ProxyCreationEnabled = false;
            //db.Configuration.AutoDetectChangesEnabled = false;
            //db.Configuration.LazyLoadingEnabled = false;

            var reqs = standard.NEW_REQUIREMENT.ToList();
            Dictionary<int, List<QuestionAndHeading>> reqQuestions = reqs.Select(s => new
            {
                s.Requirement_Id,
                Questions = s.NEW_QUESTIONs(_context).Select(t =>
new QuestionAndHeading() { Simple_Question = t.Simple_Question, Heading_Pair_Id = t.Heading_Pair_Id })
            })
                .ToDictionary(s => s.Requirement_Id, s => s.Questions.ToList());

            var reqHeadingIds = reqs.Select(s => s.Question_Group_Heading_Id).ToList();
            //var questionHeadings = from a in db.REQUIREMENT_QUESTIONS
            //                       join b in db.new on a.Question_Id equals b.Question_Id
            //                       join c in db.NEW_QUESTION_SETS on b.Question_Id equals c.Question_Id
            //                       where c.Set_Name == standard.Set_Name
            //                       select b.question_group_heading_id
            var questionHeadings = reqQuestions.SelectMany(s => s.Value.Select(t => t.Heading_Pair_Id)).Distinct().ToList();
            var reqHeadings = _context.QUESTION_GROUP_HEADING.Where(s => reqHeadingIds.Contains(s.Question_Group_Heading_Id)).ToDictionary(s => s.Question_Group_Heading_Id, s => s.Question_Group_Heading1);
            var headingPairs = _context.UNIVERSAL_SUB_CATEGORY_HEADINGS.Where(s => questionHeadings.Contains(s.Heading_Pair_Id));
            var subcategories = headingPairs.Join(_context.UNIVERSAL_SUB_CATEGORIES, s => s.Universal_Sub_Category_Id, s => s.Universal_Sub_Category_Id, (s, t) => new { s.Heading_Pair_Id, category = t })
                          .ToDictionary(s => s.Heading_Pair_Id, s => s.category.Universal_Sub_Category);
            var headings = headingPairs.Join(_context.QUESTION_GROUP_HEADING, s => s.Question_Group_Heading_Id, s => s.Question_Group_Heading_Id, (s, t) => new { s.Heading_Pair_Id, category = t })
                          .ToDictionary(s => s.Heading_Pair_Id, s => s.category.Question_Group_Heading1);

            var reqReferences = reqs.Select(s => new
            {
                s.Requirement_Id,
                Resources = s.REQUIREMENT_REFERENCES.Where(x => !x.Source).Select(t =>
                  new ExternalResource
                  {
                      destination = t.Destination_String,
                      fileName = t.Gen_File.File_Name,
                      pageNumber = t.Page_Number,
                      sectionReference = t.Section_Ref
                  })
            }).ToDictionary(t => t.Requirement_Id, t => t.Resources);

            var reqSource = reqs.Select(s => new
            {
                s.Requirement_Id,
                Resource = s.REQUIREMENT_REFERENCES.Where(x => x.Source).Select(t =>
                                  new ExternalResource
                                  {
                                      destination = t.Destination_String,
                                      fileName = t.Gen_File.File_Name,
                                      pageNumber = t.Page_Number,
                                      sectionReference = t.Section_Ref
                                  }).FirstOrDefault()
            }).ToDictionary(t => t.Requirement_Id, t => t.Resource);


            var reqLevels = new Dictionary<int, List<REQUIREMENT_LEVELS>>();
            foreach (var req in reqs)
            {
                if (!reqLevels.ContainsKey(req.Requirement_Id))
                {
                    reqLevels[req.Requirement_Id] = req.REQUIREMENT_LEVELS.ToList();
                }
            }
            //var tempLevels = reqs.Select(s => new { s.Requirement_Id, levels = s.REQUIREMENT_LEVELS.Select(t => t.Standard_Level) }).ToList();
            //if (tempLevels.Any())
            //{
            //    reqLevels = tempLevels.ToDictionary(s => s.Requirement_Id, s => s.levels.ToList());
            //}


            foreach (var requirement in reqs)
            {
                var externalRequirement = new ExternalRequirement()
                {
                    identifier = requirement.Requirement_Title,
                    text = requirement.Requirement_Text,
                    category = requirement.Standard_Category,
                    weight = requirement.Weight ?? 0,
                    subcategory = requirement.Standard_Sub_Category,
                    supplemental = requirement.Supplemental_Info
                };
                var headingPairId = reqQuestions[requirement.Requirement_Id].Select(s => s.Heading_Pair_Id).FirstOrDefault(s => s != 0);

                // References
                var references = externalRequirement.references;
                reqReferences.TryGetValue(requirement.Requirement_Id, out references);
                externalRequirement.references = references.ToList();

                // Heading
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
                externalRequirement.heading = heading;

                // Questions
                List<QuestionAndHeading> questions = new List<QuestionAndHeading>();
                reqQuestions.TryGetValue(requirement.Requirement_Id, out questions);
                externalRequirement.questions = new ExternalRequirement.QuestionList();
                foreach (QuestionAndHeading h in questions)
                    externalRequirement.questions.Add(h.Simple_Question);

                // Subheading
                string subheading = null;
                subcategories.TryGetValue(headingPairId, out subheading);
                if (subheading == null)
                {
                    subheading = heading;
                }
                externalRequirement.subheading = subheading;

                // Source
                var source = externalRequirement.source;
                reqSource.TryGetValue(requirement.Requirement_Id, out source);
                externalRequirement.source = source;

                // SAL - take any levels that are defined, regardless of level_type
                externalRequirement.securityAssuranceLevels = new List<string>();
                foreach (var s in reqLevels[requirement.Requirement_Id])
                {
                    if (!externalRequirement.securityAssuranceLevels.Contains(s.Standard_Level)
                        && s.Standard_Level.ToLower() != "none")
                    {
                        externalRequirement.securityAssuranceLevels.Add(s.Standard_Level);
                    }
                }

                requirements.Add(externalRequirement);
            }

            externalStandard.requirements = requirements;


            return externalStandard;
        }
    }


    /// <summary>
    /// 
    /// </summary>
    class QuestionAndHeading
    {
        public string Simple_Question { get; set; }
        public int Heading_Pair_Id { get; set; }
    }
}