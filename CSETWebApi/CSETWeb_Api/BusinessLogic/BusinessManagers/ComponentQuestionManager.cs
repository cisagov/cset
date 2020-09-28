//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CSETWeb_Api.BusinessLogic.Helpers;
using CSETWeb_Api.Models;
using DataLayerCore.Manual;
using DataLayerCore.Model;
using Microsoft.EntityFrameworkCore;
using Snickler.EFCore;
using BusinessLogic.Helpers;
using CSET_Main.Data.ControlData;
using CSET_Main.Questions.InformationTabData;
using CSET_Main.Views.Questions.QuestionDetails;
using CSETWeb_Api.BusinessLogic.Helpers;
using CSETWeb_Api.Models;
using DataLayerCore.Manual;
using DataLayerCore.Model;
using Nelibur.ObjectMapper;
using Snickler.EFCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using CSETWeb_Api.BusinessLogic.Models;

namespace CSETWeb_Api.BusinessManagers
{
    public class ComponentQuestionManager : QuestionRequirementManager
    {

        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="assessmentID"></param>
        public ComponentQuestionManager(int assessmentId) : base(assessmentId)
        {
            this.assessmentID = assessmentId;
        }




        /// <summary>
        /// Gathers applicable questions for the assessment's network components as defined the by Diagram.
        /// </summary>
        /// <param name="resp"></param>        
        public QuestionResponse GetResponse()
        {
            var resp = new QuestionResponse();
            resp.Domains = new List<Domain>();

            using (CSET_Context context = new CSET_Context())
            {
                var list = context.usp_Answer_Components_Default(this.assessmentID).Cast<Answer_Components_Base>().ToList();

                AddResponse(resp, context, list, "Component Defaults");
                BuildOverridesOnly(resp, context);
            }

            return resp;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="resp"></param>
        /// <param name="context"></param>
        public void BuildOverridesOnly(QuestionResponse resp, CSET_Context context)
        {
            // Because these are only override questions and the lists are short, don't bother grouping by group header.  Just subcategory.
            List<Answer_Components_Base> dlist = null;
            context.LoadStoredProc("[usp_getAnswerComponentOverrides]")
              .WithSqlParam("assessment_id", this.assessmentID)
              .ExecuteStoredProc((handler) =>
              {
                  dlist = handler.ReadToList<Answer_Components_Base>()
                    .OrderBy(x => x.Symbol_Name).ThenBy(x => x.ComponentName).ThenBy(x => x.Component_Guid)
                    .ThenBy(x => x.Universal_Sub_Category)
                    .ToList();
              });

            AddResponseComponentOverride(resp, context, dlist, "Component Overrides");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="resp"></param>
        /// <param name="context"></param>
        /// <param name="list"></param>
        /// <param name="listname"></param>
        private void AddResponseComponentOverride(QuestionResponse resp, CSET_Context context, List<Answer_Components_Base> list, string listname)
        {
            List<QuestionGroup> groupList = new List<QuestionGroup>();
            QuestionGroup qg = new QuestionGroup();
            QuestionSubCategory sc = new QuestionSubCategory();
            QuestionAnswer qa = new QuestionAnswer();

            string symbolType = null;
            string componentName = null;
            string curGroupHeading = null;
            string curSubHeading = null;
            int prevQuestionId = 0;
            QuestionSubCategoryComparator comparator = new QuestionSubCategoryComparator();

            int displayNumber = 0;

            //push a new group if component_type, component_name, or question_group_heading changes

            foreach (var dbQ in list)
            {
                if ((dbQ.Symbol_Name != symbolType)
                    || (dbQ.ComponentName != componentName))
                {
                    qg = new QuestionGroup()
                    {
                        GroupHeadingText = dbQ.Question_Group_Heading,
                        GroupHeadingId = dbQ.GroupHeadingId,
                        StandardShortName = listname,
                        Symbol_Name = dbQ.Symbol_Name,
                        ComponentName = dbQ.ComponentName,
                        IsOverride = true

                    };
                    groupList.Add(qg);
                    symbolType = dbQ.Symbol_Name;
                    componentName = dbQ.ComponentName;

                    curGroupHeading = qg.GroupHeadingText;
                    // start numbering again in new group
                    displayNumber = 0;
                }

                // new subcategory -- break on pairing ID to separate 'base' and 'custom' pairings
                if ((dbQ.Universal_Sub_Category != curSubHeading) || (dbQ.Question_Id == prevQuestionId))
                {
                    sc = new QuestionSubCategory()
                    {
                        GroupHeadingId = dbQ.GroupHeadingId,
                        SubCategoryId = dbQ.SubCategoryId,
                        SubCategoryHeadingText = dbQ.Universal_Sub_Category,
                        HeaderQuestionText = dbQ.Sub_Heading_Question_Description,
                        SubCategoryAnswer = this.subCatAnswers.Where(x => x.HeadingId == dbQ.heading_pair_id).FirstOrDefault()?.AnswerText
                    };

                    qg.SubCategories.Add(sc);
                    curSubHeading = dbQ.Universal_Sub_Category;
                }
                prevQuestionId = dbQ.Question_Id;
                qa = new QuestionAnswer()
                {
                    DisplayNumber = (++displayNumber).ToString(),
                    QuestionId = dbQ.Question_Id,
                    QuestionText = FormatLineBreaks(dbQ.Simple_Question),
                    Answer = dbQ.Answer_Text,
                    Answer_Id = dbQ.Answer_Id,
                    AltAnswerText = dbQ.Alternate_Justification,
                    Comment = dbQ.Comment,
                    MarkForReview = dbQ.Mark_For_Review ?? false,
                    Reviewed = dbQ.Reviewed ?? false,
                    Is_Component = dbQ.Is_Component,
                    ComponentGuid = dbQ.Component_Guid ?? Guid.Empty,
                    Is_Requirement = dbQ.Is_Requirement,
                    Feedback = dbQ.Feedback
                };

                sc.Questions.Add(qa);
            }


            resp.Domains[0].Categories.AddRange(groupList);
            resp.QuestionCount += list.Count;
            resp.DefaultComponentsCount = list.Count;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="resp"></param>
        /// <param name="context"></param>
        /// <param name="list"></param>
        /// <param name="listname"></param>
        private void AddResponse(QuestionResponse resp, CSET_Context context, List<Answer_Components_Base> list, string listname)
        {
            List<QuestionGroup> groupList = new List<QuestionGroup>();
            QuestionGroup qg = new QuestionGroup();
            QuestionSubCategory sc = new QuestionSubCategory();
            QuestionAnswer qa = new QuestionAnswer();

            string curGroupHeading = null;
            int curHeadingPairId = 0;


            int displayNumber = 0;


            foreach (var dbQ in list)
            {
                if (dbQ.Question_Group_Heading != curGroupHeading)
                {
                    qg = new QuestionGroup()
                    {
                        GroupHeadingText = dbQ.Question_Group_Heading,
                        GroupHeadingId = dbQ.GroupHeadingId,
                        StandardShortName = listname,
                        Symbol_Name = dbQ.Symbol_Name,
                        ComponentName = dbQ.ComponentName
                    };
                    groupList.Add(qg);
                    curGroupHeading = qg.GroupHeadingText;
                    // start numbering again in new group
                    displayNumber = 0;
                }

                // new subcategory -- break on pairing ID to separate 'base' and 'custom' pairings
                if (dbQ.heading_pair_id != curHeadingPairId)
                {
                    sc = new QuestionSubCategory()
                    {
                        GroupHeadingId = dbQ.GroupHeadingId,
                        SubCategoryId = dbQ.SubCategoryId,
                        SubCategoryHeadingText = dbQ.Universal_Sub_Category,
                        HeaderQuestionText = dbQ.Sub_Heading_Question_Description,
                        SubCategoryAnswer = this.subCatAnswers.Where(x => x.HeadingId == dbQ.heading_pair_id).FirstOrDefault()?.AnswerText
                    };

                    qg.SubCategories.Add(sc);

                    curHeadingPairId = dbQ.heading_pair_id;
                }

                qa = new QuestionAnswer()
                {
                    DisplayNumber = (++displayNumber).ToString(),
                    QuestionId = dbQ.Question_Id,
                    QuestionText = FormatLineBreaks(dbQ.Simple_Question),
                    Answer = dbQ.Answer_Text,
                    Answer_Id = dbQ.Answer_Id,
                    AltAnswerText = dbQ.Alternate_Justification,
                    Comment = dbQ.Comment,
                    MarkForReview = dbQ.Mark_For_Review ?? false,
                    Reviewed = dbQ.Reviewed ?? false,
                    Is_Component = dbQ.Is_Component,
                    ComponentGuid = dbQ.Component_Guid ?? Guid.Empty,
                    Is_Requirement = dbQ.Is_Requirement,
                    Feedback = dbQ.Feedback
                };

                sc.Questions.Add(qa);
            }


            var container = new Domain()
            {
                DisplayText = listname
            };
            container.Categories.AddRange(groupList);
            resp.Domains.Add(container);
            resp.QuestionCount += list.Count;
            resp.DefaultComponentsCount = list.Count;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="question_id"></param>
        /// <param name="Component_Symbol_Id"></param>
        /// <returns></returns>
        public List<Answer_Components_Exploded_ForJSON> GetOverrideQuestions(int assessmentId, int question_id, int Component_Symbol_Id)
        {
            List<Answer_Components_Exploded_ForJSON> rlist = new List<Answer_Components_Exploded_ForJSON>();
            using (CSET_Context context = new CSET_Context())
            {
                List<usp_getExplodedComponent> questionlist = null;

                context.LoadStoredProc("s[usp_getExplodedComponent]")
                  .WithSqlParam("assessment_id", assessmentID)
                  .ExecuteStoredProc((handler) =>
                  {
                      questionlist = handler.ReadToList<usp_getExplodedComponent>().Where(c => c.Question_Id == question_id
                                    && c.Component_Symbol_Id == Component_Symbol_Id).ToList();
                  });

                IQueryable<Answer_Components> answeredQuestionList = context.Answer_Components.Where(a =>
                    a.Assessment_Id == assessmentId && a.Question_Or_Requirement_Id == question_id);


                foreach (var question in questionlist.ToList())
                {
                    Answer_Components_Exploded_ForJSON tmp = null;
                    tmp = TinyMapper.Map<Answer_Components_Exploded_ForJSON>(question);
                    tmp.Component_GUID = question.Component_GUID.ToString();
                    rlist.Add(tmp);
                }
                return rlist;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public QuestionResponse GetOverrideListOnly()
        {
            QuestionResponse resp = new QuestionResponse
            {
                Domains = new List<Domain>(),
                ApplicationMode = this.applicationMode
            };

            // Create the Component Overrides node
            var componentOverridesContainer = new Domain()
            {
                DisplayText = "Component Overrides"
            };
            componentOverridesContainer.Categories = new List<QuestionGroup>();
            resp.Domains.Add(componentOverridesContainer);


            resp.QuestionCount = 0;
            resp.RequirementCount = 0;

            BuildOverridesOnly(resp, new CSET_Context());
            return resp;
        }


        /// <summary>
        /// get the exploded view where assessment
        /// </summary>
        /// <param name="guid"></param>
        /// <param name="shouldSave"></param>
        public void HandleGuid(Guid guid, bool shouldSave)
        {
            using (CSET_Context context = new CSET_Context())
            {
                if (shouldSave)
                {
                    var componentName = context.ASSESSMENT_DIAGRAM_COMPONENTS.Where(x => x.Component_Guid == guid).FirstOrDefault();
                    if (componentName != null)
                    {
                        var creates = from a in context.COMPONENT_QUESTIONS
                                      where a.Component_Symbol_Id == componentName.Component_Symbol_Id
                                      select a;
                        var alreadyThere = (from a in context.ANSWER
                                            where a.Assessment_Id == assessmentID
                                            && a.Component_Guid == guid
                                            select a).ToDictionary(x => x.Question_Or_Requirement_Id, x => x);
                        foreach (var c in creates.ToList())
                        {
                            if (!alreadyThere.ContainsKey(c.Question_Id))
                            {
                                context.ANSWER.Add(new ANSWER()
                                {
                                    Answer_Text = Constants.UNANSWERED,
                                    Assessment_Id = this.assessmentID,
                                    Component_Guid = guid,
                                    Is_Component = true,
                                    Is_Requirement = false,
                                    Question_Or_Requirement_Id = c.Question_Id
                                });
                            }
                        }
                        context.SaveChanges();
                    }
                    else
                    {
                        throw new ApplicationException("could not find component for guid:" + guid);
                    }
                }
                else
                {
                    foreach (var a in context.ANSWER.Where(x => x.Component_Guid == guid).ToList())
                    {
                        context.ANSWER.Remove(a);
                    }
                    context.SaveChanges();
                }
            }
        }
    }
}
