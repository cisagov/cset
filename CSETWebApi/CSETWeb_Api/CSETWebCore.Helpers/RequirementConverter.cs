//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.Interfaces;
using CSETWebCore.Model.AssessmentIO;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Helpers
{
    public static class RequirementConverter
    {
        public static async Task<ConverterResult<NEW_REQUIREMENT>> ToRequirement(this ExternalRequirement externalRequirement, string setName, ILogger logger, CSETContext context)
        {
            var result = new ConverterResult<NEW_REQUIREMENT>(logger);
            var newRequirement = result.Result;

            //basic mappings
            newRequirement.Supplemental_Info = externalRequirement.supplemental;
            newRequirement.Requirement_Text = externalRequirement.text;
            newRequirement.Requirement_Title = externalRequirement.identifier;
            newRequirement.Original_Set_Name = setName;
            newRequirement.Weight = externalRequirement.weight;
            newRequirement.REQUIREMENT_LEVELS = new List<REQUIREMENT_LEVELS>();
            newRequirement.REQUIREMENT_REFERENCES = new List<REQUIREMENT_REFERENCES>();
            newRequirement.REQUIREMENT_SETS = new List<REQUIREMENT_SETS>() { new REQUIREMENT_SETS() { Set_Name = setName } };

            QUESTION_GROUP_HEADING questionGroupHeading = null;
            UNIVERSAL_SUB_CATEGORY_HEADINGS subcategory = null;


            try
            {
                questionGroupHeading = context.QUESTION_GROUP_HEADING.FirstOrDefault(s => s.Question_Group_Heading1.Trim().ToLower() == externalRequirement.heading.Trim().ToLower());
                try
                {
                    var subcatId = context.UNIVERSAL_SUB_CATEGORIES.FirstOrDefault(s => s.Universal_Sub_Category.Trim().ToLower() == externalRequirement.subheading.Trim().ToLower())?.Universal_Sub_Category_Id ?? 0;
                    if (subcatId == 0)
                    {
                        var subcat = new UNIVERSAL_SUB_CATEGORIES() { Universal_Sub_Category = externalRequirement.subheading };
                        context.UNIVERSAL_SUB_CATEGORIES.Add(subcat);
                        await context.SaveChangesAsync();
                        subcatId = subcat.Universal_Sub_Category_Id;
                    }

                    try
                    {
                        subcategory = context.UNIVERSAL_SUB_CATEGORY_HEADINGS.FirstOrDefault(s => (s.Universal_Sub_Category_Id == subcatId) && (s.Question_Group_Heading_Id == questionGroupHeading.Question_Group_Heading_Id));
                        if (subcategory == null)
                        {
                            subcategory = new UNIVERSAL_SUB_CATEGORY_HEADINGS()
                            {
                                Set_Name = "Standards",
                                Universal_Sub_Category_Id = subcatId,
                                Question_Group_Heading_Id = questionGroupHeading.Question_Group_Heading_Id
                            };
                            context.UNIVERSAL_SUB_CATEGORY_HEADINGS.Add(subcategory);
                            await context.SaveChangesAsync();
                        }
                    }
                    catch (Exception exc)
                    {
                        NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

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
                result.LogError(String.Format("Heading invalid for requirement {0} {1}.  Please double check that the heading is spelled correctly.", externalRequirement.identifier, externalRequirement.text));
            }
            else
            {
                newRequirement.Question_Group_Heading_Id = questionGroupHeading.Question_Group_Heading_Id;
            }


            if (subcategory == null)
            {
                result.LogError(String.Format("Subheading invalid for requirement {0} {1}.  Please double check that the heading is spelled correctly.", externalRequirement.identifier, externalRequirement.text));
            }

            externalRequirement.category = string.IsNullOrWhiteSpace(externalRequirement.category) ? externalRequirement.heading : externalRequirement.category;
            var category = context.STANDARD_CATEGORY.FirstOrDefault(s => s.Standard_Category1 == externalRequirement.category);
            if (category == null)
            {
                newRequirement.Standard_CategoryNavigation = new STANDARD_CATEGORY() { Standard_Category1 = externalRequirement.category };
            }
            else
            {
                newRequirement.Standard_Category = category.Standard_Category1;
            }


            foreach (string sal in externalRequirement.securityAssuranceLevels)
            {
                var rl = new REQUIREMENT_LEVELS()
                {
                    Standard_Level = sal,
                    Level_Type = "NST"
                };
                newRequirement.REQUIREMENT_LEVELS.Add(rl);
            }


            var importer = new DocumentImporter(context);
            if (externalRequirement.references != null)
            {

                foreach (var reference in externalRequirement.references)
                {
                    var reqReference = new REQUIREMENT_REFERENCES();
                    try
                    {
                        reqReference.Destination_String = reference.destination;
                        reqReference.Page_Number = reference.pageNumber;
                        reqReference.Section_Ref = String.IsNullOrEmpty(reference.sectionReference) ? "" : reference.sectionReference;
                        reqReference.Gen_File_Id = importer.LookupGenFileId(reference.fileName);
                    }
                    catch
                    {
                        result.LogError(String.Format("Reference {0} could not be added for requirement {1} {2}.", externalRequirement.source?.fileName, externalRequirement.identifier, externalRequirement.text));
                    }
                    if (reqReference.Gen_File_Id == 0)
                    {
                        result.LogError(String.Format("Reference {0} has not been loaded into CSET.  Please add the file and try again.", externalRequirement.source?.fileName, externalRequirement.identifier, externalRequirement.text));
                    }
                    else
                    {
                        newRequirement.REQUIREMENT_REFERENCES.Add(reqReference);
                    }
                }
            }

            var reqSource = new REQUIREMENT_REFERENCES();

            try
            {
                if (externalRequirement.source != null)
                {
                    reqSource.Gen_File_Id = importer.LookupGenFileId(externalRequirement.source.fileName);
                    reqSource.Page_Number = externalRequirement.source.pageNumber;
                    reqSource.Destination_String = externalRequirement.source.destination;
                    reqSource.Section_Ref = String.IsNullOrEmpty(externalRequirement.source.sectionReference) ? "" : externalRequirement.source.sectionReference;
                    reqSource.Source = true;
                    if (reqSource.Gen_File_Id == 0)
                    {
                        result.LogError(String.Format("Source {0} has not been loaded into CSET.  Please add the file and try again.", externalRequirement.source?.fileName, externalRequirement.identifier, externalRequirement.text));
                    }
                    else
                    {
                        newRequirement.REQUIREMENT_REFERENCES.Add(reqSource);
                    }
                }
            }
            catch
            {
                result.LogError(String.Format("Source {0} could not be added for requirement {1} {2}.", externalRequirement.source?.fileName, externalRequirement.identifier, externalRequirement.text));
            }

            context.SaveChanges();


            // --------------
            // Questions
            // --------------

            if (externalRequirement.questions == null || externalRequirement.questions.Count() == 0)
            {
                externalRequirement.questions = new ExternalRequirement.QuestionList() { externalRequirement.text };
            }

            foreach (var question in externalRequirement.questions)
            {
                NEW_QUESTION newQuestion = null;
                var questionSet = new NEW_QUESTION_SETS()
                {
                    Set_Name = setName,
                    NEW_QUESTION_LEVELS = new List<NEW_QUESTION_LEVELS>()
                };

                // Look for existing question by question text
                newQuestion = context.NEW_QUESTION.FirstOrDefault(s => s.Simple_Question.ToLower().Trim() == question.ToLower().Trim());

                if (newQuestion == null)
                {
                    newQuestion = new NEW_QUESTION();
                    try
                    {
                        newQuestion.Original_Set_Name = setName;
                        newQuestion.Simple_Question = question;
                        newQuestion.Weight = externalRequirement.weight;
                        newQuestion.Question_Group_Id = questionGroupHeading.Question_Group_Heading_Id;
                        newQuestion.Universal_Sal_Level = SalCompare.FindLowestSal(externalRequirement.securityAssuranceLevels);
                        newQuestion.Std_Ref = setName.Replace("_", "");
                        newQuestion.Std_Ref = newQuestion.Std_Ref.Substring(0, Math.Min(newQuestion.Std_Ref.Length, 50));
                        newQuestion.Heading_Pair_Id = subcategory.Heading_Pair_Id;
                    }
                    catch
                    {
                        result.LogError(String.Format("Question {0} could not be added for requirement {1} {2}.", question, externalRequirement.identifier, externalRequirement.text));
                    }
                }

                foreach (string sal in externalRequirement.securityAssuranceLevels)
                {
                    var rl = new NEW_QUESTION_LEVELS()
                    {
                        Universal_Sal_Level = sal.ToString(),
                    };
                    questionSet.NEW_QUESTION_LEVELS.Add(rl);
                }


                questionSet.Question = newQuestion;
                newQuestion.NEW_QUESTION_SETS = new List<NEW_QUESTION_SETS>
                    {
                        questionSet
                    };

                newQuestion.REQUIREMENT_QUESTIONS_SETS = new List<REQUIREMENT_QUESTIONS_SETS>();
                newQuestion.REQUIREMENT_QUESTIONS_SETS.Add(new REQUIREMENT_QUESTIONS_SETS
                {
                    Set_Name = setName,
                    Requirement = newRequirement,
                    Question = newQuestion
                }
                );


                context.NEW_QUESTION.Add(newQuestion);
            }


            // null this out so that we don't try to insert it
            questionGroupHeading = null;

            context.SaveChanges();

            return result;
        }
    }
}