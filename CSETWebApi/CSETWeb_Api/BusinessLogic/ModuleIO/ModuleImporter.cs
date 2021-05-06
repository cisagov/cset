//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using BusinessLogic.Models;
using CSETWeb_Api.BusinessLogic.Models;
using DataLayerCore.Model;
using System.Text.RegularExpressions;
using static BusinessLogic.Models.ExternalRequirement;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using CSETWeb_Api.BusinessLogic.Helpers;


namespace CSETWeb_Api.BusinessLogic.ModuleIO
{
    /// <summary>
    /// This is an alternate way to convert module JSON
    /// and persist to the database.
    /// </summary>
    public static class ModuleImporter
    {
        private static readonly log4net.ILog log
       = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        /// <summary>
        /// Imports a Module/Standard.
        /// </summary>
        /// <param name="externalStandard"></param>
        public static void ProcessStandard(IExternalStandard externalStandard)
        {
            CsetLogManager.Instance.LogInfoMessage("ModuleImporter.ProcessStandard - basic");


            CsetLogManager.Instance.LogDebugMessage("ModuleImporter.ProcessStandard");

            SETS_CATEGORY category;
            int? categoryOrder = 0;
            var setname = Regex.Replace(externalStandard.ShortName, @"\W", "_");

            var documentImporter = new DocumentImporter();
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


            try
            {
                ProcessRequirements(externalStandard, set);
            }
            catch (Exception exc)
            {
                CsetLogManager.Instance.LogErrorMessage("Exception thrown in ModuleImporter.ProcessStandard() ... {0}", exc.ToString());
            }
        }


        /// <summary>
        /// Save all Requirements in the specified module.
        /// </summary>
        /// <param name="set"></param>
        /// <param name="db"></param>
        private static void ProcessRequirements(IExternalStandard externalStandard, SETS set)
        {
            var jsonStandard = JsonConvert.SerializeObject(externalStandard, Formatting.Indented);

            var questionDictionary = new Dictionary<string, NEW_QUESTION>();
            var categoryDictionary = new Dictionary<string, STANDARD_CATEGORY>();
            var requirementList = new List<string>();

            set.NEW_REQUIREMENT = new List<NEW_REQUIREMENT>();
            var requirements = set.NEW_REQUIREMENT;
            int reqSequence = 0;

            foreach (var requirement in externalStandard.Requirements)
            {
                //skip duplicates
                if (!requirementList.Any(s => s == requirement.Identifier.Trim().ToLower() + "|||" + requirement.Text.Trim().ToLower()))
                {
                    reqSequence++;
                    var requirementResult = SaveRequirement(requirement, set.Set_Name, reqSequence, new ConsoleLogger());


                    if (requirementResult != null)
                    {
                        if (requirementResult.Standard_CategoryNavigation != null)
                        {
                            STANDARD_CATEGORY tempCategory;
                            if (categoryDictionary.TryGetValue(requirementResult.Standard_CategoryNavigation.Standard_Category1, out tempCategory))
                            {
                                requirementResult.Standard_CategoryNavigation = tempCategory;
                            }
                            else
                            {
                                categoryDictionary.Add(requirementResult.Standard_CategoryNavigation.Standard_Category1, requirementResult.Standard_CategoryNavigation);
                            }
                        }

                        foreach (var question in requirementResult.NEW_QUESTIONs().ToList())
                        {
                            NEW_QUESTION existingQuestion;
                            if (questionDictionary.TryGetValue(question.Simple_Question, out existingQuestion))
                            {
                                requirementResult.REQUIREMENT_QUESTIONS.Remove(new REQUIREMENT_QUESTIONS() { Question_Id = question.Question_Id, Requirement_Id = requirementResult.Requirement_Id });
                            }
                            else
                            {
                                questionDictionary.Add(question.Simple_Question, question);
                            }
                        }
                        requirementList.Add(requirementResult.Requirement_Title.Trim().ToLower() + "|||" + requirementResult.Requirement_Text.Trim().ToLower());
                        requirements.Add(requirementResult);
                    }
                    else
                    {
                        // requirementResult.ErrorMessages.ToList().ForEach(s => result.LogError(s));
                    }
                }
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="externalRequirement"></param>
        /// <param name="setName"></param>
        /// <param name="logger"></param>
        /// <returns></returns>
        public static NEW_REQUIREMENT SaveRequirement(this IExternalRequirement externalRequirement, string setName,
            int sequence, ILogger logger)
        {
            var result = new ConverterResult<NEW_REQUIREMENT>(logger);
            var newRequirement = result.Result;

            //basic mappings
            newRequirement.Supplemental_Info = externalRequirement.Supplemental;
            newRequirement.Requirement_Text = externalRequirement.Text;
            newRequirement.Requirement_Title = externalRequirement.Identifier;
            newRequirement.Original_Set_Name = setName;
            newRequirement.Weight = externalRequirement.Weight;
            newRequirement.REQUIREMENT_LEVELS = new List<REQUIREMENT_LEVELS>();
            newRequirement.REQUIREMENT_REFERENCES = new List<REQUIREMENT_REFERENCES>();
            newRequirement.REQUIREMENT_SETS = new List<REQUIREMENT_SETS>()
            {
                new REQUIREMENT_SETS()
                {
                    Set_Name = setName,
                    Requirement_Sequence = sequence
                }
            };

            QUESTION_GROUP_HEADING questionGroupHeading = null;
            UNIVERSAL_SUB_CATEGORY_HEADINGS uschPairing = null;

            var db = new CSET_Context();

            try
            {
                questionGroupHeading = db.QUESTION_GROUP_HEADING.FirstOrDefault(s => s.Question_Group_Heading1.Trim().ToLower() == externalRequirement.Heading.Trim().ToLower());
                try
                {
                    var subcatId = db.UNIVERSAL_SUB_CATEGORIES.FirstOrDefault(s => s.Universal_Sub_Category.Trim().ToLower() == externalRequirement.Subheading.Trim().ToLower())?.Universal_Sub_Category_Id ?? 0;
                    if (subcatId == 0)
                    {
                        var subcat = new UNIVERSAL_SUB_CATEGORIES() { Universal_Sub_Category = externalRequirement.Subheading };
                        db.UNIVERSAL_SUB_CATEGORIES.Add(subcat);
                        db.SaveChanges();
                        subcatId = subcat.Universal_Sub_Category_Id;
                    }

                    try
                    {
                        uschPairing = db.UNIVERSAL_SUB_CATEGORY_HEADINGS.FirstOrDefault(s => (s.Universal_Sub_Category_Id == subcatId) && (s.Question_Group_Heading_Id == questionGroupHeading.Question_Group_Heading_Id));
                        if (uschPairing == null)
                        {
                            uschPairing = new UNIVERSAL_SUB_CATEGORY_HEADINGS()
                            {
                                Set_Name = "Standards",
                                Universal_Sub_Category_Id = subcatId,
                                Question_Group_Heading_Id = questionGroupHeading.Question_Group_Heading_Id
                            };
                            db.UNIVERSAL_SUB_CATEGORY_HEADINGS.Add(uschPairing);
                            db.SaveChanges();
                        }
                    }
                    catch (Exception exc)
                    {
                        var myExc = exc;
                    }
                }
                catch
                {

                }
            }
            catch
            {

            }


            if (questionGroupHeading == null)
            {
                result.LogError(String.Format("Heading invalid for requirement {0} {1}.  Please double check that the heading is spelled correctly.", externalRequirement.Identifier, externalRequirement.Text));
            }
            else
            {
                newRequirement.Question_Group_Heading_Id = questionGroupHeading.Question_Group_Heading_Id;
            }


            if (uschPairing == null)
            {
                result.LogError(String.Format("Subheading invalid for requirement {0} {1}.  Please double check that the heading is spelled correctly.", externalRequirement.Identifier, externalRequirement.Text));
            }

            externalRequirement.Category = string.IsNullOrWhiteSpace(externalRequirement.Category) ? externalRequirement.Heading : externalRequirement.Category;
            var category = db.STANDARD_CATEGORY.FirstOrDefault(s => s.Standard_Category1 == externalRequirement.Category);
            if (category == null)
            {
                newRequirement.Standard_CategoryNavigation = new STANDARD_CATEGORY() { Standard_Category1 = externalRequirement.Category };
            }
            else
            {
                newRequirement.Standard_Category = category.Standard_Category1;
            }

            newRequirement.Standard_Sub_Category = externalRequirement.Subheading;


            // SAL
            foreach (string sal in externalRequirement.SecurityAssuranceLevels)
            {
                var rl = new REQUIREMENT_LEVELS()
                {
                    Standard_Level = sal,
                    Level_Type = "NST"
                };

                if (newRequirement.REQUIREMENT_LEVELS.Count(x => x.Standard_Level == rl.Standard_Level) == 0)
                {
                    newRequirement.REQUIREMENT_LEVELS.Add(rl);
                }
            }


            var importer = new DocumentImporter();
            if (externalRequirement.References != null)
            {
                foreach (var reference in externalRequirement.References)
                {
                    var reqReference = new REQUIREMENT_REFERENCES();
                    try
                    {
                        reqReference.Destination_String = reference.Destination;
                        reqReference.Page_Number = reference.PageNumber;
                        reqReference.Section_Ref = String.IsNullOrEmpty(reference.SectionReference) ? "" : reference.SectionReference;
                        reqReference.Gen_File_Id = importer.LookupGenFileId(reference.FileName);
                    }
                    catch
                    {
                        result.LogError(String.Format("Reference {0} could not be added for requirement {1} {2}.", externalRequirement.Source?.FileName, externalRequirement.Identifier, externalRequirement.Text));
                    }
                    if (reqReference.Gen_File_Id == 0)
                    {
                        result.LogError(String.Format("Reference {0} has not been loaded into CSET.  Please add the file and try again.", externalRequirement.Source?.FileName, externalRequirement.Identifier, externalRequirement.Text));
                    }
                    else
                    {
                        newRequirement.REQUIREMENT_REFERENCES.Add(reqReference);
                    }
                }
            }

            var reqSource = new REQUIREMENT_SOURCE_FILES();

            try
            {
                if (externalRequirement.Source != null)
                {
                    reqSource.Gen_File_Id = importer.LookupGenFileId(externalRequirement.Source.FileName);
                    reqSource.Page_Number = externalRequirement.Source.PageNumber;
                    reqSource.Destination_String = externalRequirement.Source.Destination;
                    reqSource.Section_Ref = String.IsNullOrEmpty(externalRequirement.Source.SectionReference) ? "" : externalRequirement.Source.SectionReference;
                    if (reqSource.Gen_File_Id == 0)
                    {
                        result.LogError(String.Format("Source {0} has not been loaded into CSET.  Please add the file and try again.", externalRequirement.Source?.FileName, externalRequirement.Identifier, externalRequirement.Text));
                    }
                    else
                    {
                        newRequirement.REQUIREMENT_SOURCE_FILES.Add(reqSource);
                    }
                }
            }
            catch
            {
                result.LogError(String.Format("Source {0} could not be added for requirement {1} {2}.", externalRequirement.Source?.FileName, externalRequirement.Identifier, externalRequirement.Text));
            }

            try
            {
                db.NEW_REQUIREMENT.Add(newRequirement);
                db.SaveChanges();
            }
            catch (Exception exc)
            {
                // throw exc;
            }


            // Save any Questions associated with the Requirement
            SaveQuestions(setName, externalRequirement, newRequirement,
                questionGroupHeading, uschPairing,
                db);


            return newRequirement;
        }


        /// <summary>
        /// 
        /// </summary>
        public static void SaveQuestions(
            string setName,
            IExternalRequirement externalRequirement,
            NEW_REQUIREMENT newRequirement,
            QUESTION_GROUP_HEADING questionGroupHeading,
            UNIVERSAL_SUB_CATEGORY_HEADINGS uschPairing,
            CSET_Context db)
        {
            if (externalRequirement.Questions == null || externalRequirement.Questions.Count() == 0)
            {
                return;

                // trying to manufacture a question where none was defined could get us into trouble
                // externalRequirement.Questions = new QuestionList() { externalRequirement.Text };
            }

            var stdRefNum = 1;

            foreach (var question in externalRequirement.Questions)
            {
                NEW_QUESTION newQuestion = null;


                // Look for existing question by question text
                newQuestion = db.NEW_QUESTION.FirstOrDefault(s => s.Simple_Question.ToLower().Trim() == question.ToLower().Trim());

                if (newQuestion == null)
                {
                    newQuestion = new NEW_QUESTION();
                    try
                    {
                        newQuestion.Original_Set_Name = setName;
                        newQuestion.Simple_Question = question;
                        newQuestion.Weight = externalRequirement.Weight;
                        newQuestion.Question_Group_Id = questionGroupHeading.Question_Group_Heading_Id;
                        newQuestion.Universal_Sal_Level = SalCompare.FindLowestSal(externalRequirement.SecurityAssuranceLevels);
                        newQuestion.Std_Ref = setName.Replace("_", "");
                        newQuestion.Std_Ref = newQuestion.Std_Ref.Substring(0, Math.Min(newQuestion.Std_Ref.Length, 50));
                        newQuestion.Std_Ref_Number = stdRefNum++;

                        newQuestion.Heading_Pair_Id = uschPairing.Heading_Pair_Id;

                        db.NEW_QUESTION.Add(newQuestion);
                        db.SaveChanges();
                    }
                    catch (Exception exc)
                    {
                        var a = exc;
                        // result.LogError(String.Format("Question {0} could not be added for requirement {1} {2}.", question, externalRequirement.Identifier, externalRequirement.Text));
                    }
                }


                var nqs = new NEW_QUESTION_SETS()
                {
                    Question_Id = newQuestion.Question_Id,
                    Set_Name = setName
                };

                if (db.NEW_QUESTION_SETS.Count(x => x.Question_Id == nqs.Question_Id && x.Set_Name == nqs.Set_Name) == 0)
                {
                    db.NEW_QUESTION_SETS.Add(nqs);
                    db.SaveChanges();


                    // attach question SAL levels
                    var nqlList = new List<NEW_QUESTION_LEVELS>();
                    foreach (string sal in externalRequirement.SecurityAssuranceLevels)
                    {
                        var nql = new NEW_QUESTION_LEVELS()
                        {
                            Universal_Sal_Level = sal.ToString(),
                            New_Question_Set_Id = nqs.New_Question_Set_Id
                        };

                        if (!nqlList.Exists(x => 
                            x.Universal_Sal_Level == nql.Universal_Sal_Level 
                            && x.New_Question_Set_Id == nqs.New_Question_Set_Id))
                        {
                            db.NEW_QUESTION_LEVELS.Add(nql);
                            nqlList.Add(nql);
                        }
                    }
                }


                try
                {
                    var rqs = new REQUIREMENT_QUESTIONS_SETS()
                    {
                        Question_Id = newQuestion.Question_Id,
                        Set_Name = setName,
                        Requirement_Id = newRequirement.Requirement_Id
                    };
                    if (db.REQUIREMENT_QUESTIONS_SETS.Count(x =>
                        x.Question_Id == rqs.Question_Id
                        && x.Set_Name == rqs.Set_Name) == 0)
                    {
                        db.REQUIREMENT_QUESTIONS_SETS.Add(rqs);
                    }


                    var rq = new REQUIREMENT_QUESTIONS()
                    {
                        Question_Id = newQuestion.Question_Id,
                        Requirement_Id = newRequirement.Requirement_Id
                    };
                    if (db.REQUIREMENT_QUESTIONS_SETS.Count(x => x.Question_Id == rq.Question_Id
                        && x.Requirement_Id == rq.Requirement_Id) == 0)
                    {
                        db.REQUIREMENT_QUESTIONS.Add(rq);
                    }

                    db.SaveChanges();
                }
                catch (Exception exc)
                {
                    throw new Exception("Error saving REQUIREMENT_QUESTIONS_SETS and REQUIREMENT_QUESTIONS");
                }
            }
        }
    }
}