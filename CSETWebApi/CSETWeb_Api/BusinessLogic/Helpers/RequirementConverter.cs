//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Models;
using CSETWeb_Api.BusinessLogic.Models;
using DataLayerCore.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

using static BusinessLogic.Models.ExternalRequirement;
using Microsoft.EntityFrameworkCore;

namespace CSETWeb_Api.BusinessLogic.Helpers
{
    public static class RequirementConverter
    {

        public static async Task<ConverterResult<NEW_REQUIREMENT>> ToRequirement(this IExternalRequirement externalRequirement, string setName, ILogger logger)
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
            newRequirement.REQUIREMENT_SETS = new List<REQUIREMENT_SETS>() { new REQUIREMENT_SETS() { Set_Name = setName } };

            QUESTION_GROUP_HEADING questionGroupHeading = null;
            UNIVERSAL_SUB_CATEGORY_HEADINGS subcategory = null;

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
                        await db.SaveChangesAsync();
                        subcatId = subcat.Universal_Sub_Category_Id;
                    }

                    try
                    {
                        subcategory = db.UNIVERSAL_SUB_CATEGORY_HEADINGS.FirstOrDefault(s => (s.Universal_Sub_Category_Id == subcatId) && (s.Question_Group_Heading_Id == questionGroupHeading.Question_Group_Heading_Id));
                        if (subcategory == null)
                        {
                            subcategory = new UNIVERSAL_SUB_CATEGORY_HEADINGS()
                            {
                                Set_Name = "Standards",
                                Universal_Sub_Category_Id = subcatId,
                                Question_Group_Heading_Id = questionGroupHeading.Question_Group_Heading_Id
                            };
                            db.UNIVERSAL_SUB_CATEGORY_HEADINGS.Add(subcategory);
                            await db.SaveChangesAsync();
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


            if (subcategory == null)
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


            foreach (string sal in externalRequirement.SecurityAssuranceLevels)
            {
                var rl = new REQUIREMENT_LEVELS()
                {
                    Standard_Level = sal,
                    Level_Type = "NST"
                };
                newRequirement.REQUIREMENT_LEVELS.Add(rl);
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

            db.SaveChanges();


            // --------------
            // Questions
            // --------------

            if (externalRequirement.Questions == null || externalRequirement.Questions.Count() == 0)
            {
                externalRequirement.Questions = new QuestionList() { externalRequirement.Text };
            }

            foreach (var question in externalRequirement.Questions)
            {
                NEW_QUESTION newQuestion = null;
                var questionSet = new NEW_QUESTION_SETS()
                {
                    Set_Name = setName,
                    NEW_QUESTION_LEVELS = new List<NEW_QUESTION_LEVELS>()
                };

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
                        newQuestion.Heading_Pair_Id = subcategory.Heading_Pair_Id;
                    }
                    catch
                    {
                        result.LogError(String.Format("Question {0} could not be added for requirement {1} {2}.", question, externalRequirement.Identifier, externalRequirement.Text));
                    }
                }

                foreach (string sal in externalRequirement.SecurityAssuranceLevels)
                {
                    var rl = new NEW_QUESTION_LEVELS()
                    {
                        Universal_Sal_Level = sal.ToString(),
                    };
                    questionSet.NEW_QUESTION_LEVELS.Add(rl);
                }


                questionSet.Question_ = newQuestion;
                newQuestion.NEW_QUESTION_SETS = new List<NEW_QUESTION_SETS>
                    {
                        questionSet
                    };

                newQuestion.REQUIREMENT_QUESTIONS_SETS = new List<REQUIREMENT_QUESTIONS_SETS>();
                newQuestion.REQUIREMENT_QUESTIONS_SETS.Add(new REQUIREMENT_QUESTIONS_SETS
                {
                    Set_Name = setName,
                    Requirement_ = newRequirement,
                    Question_ = newQuestion
                }
                );


                db.NEW_QUESTION.Add(newQuestion);
            }


            // null this out so that we don't try to insert it
            questionGroupHeading = null;

            db.SaveChanges();

            return result;
        }
    }
}
