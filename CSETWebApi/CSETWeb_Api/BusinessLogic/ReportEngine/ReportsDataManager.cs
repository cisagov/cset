//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Helpers;
using CSET_Main.Analysis.Analyzers;
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.Controllers;
using CSETWeb_Api.Helpers;
using DataLayerCore.Model;
using Nelibur.ObjectMapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using DataLayerCore.Manual;
using DataLayerCore;
using Snickler.EFCore;
using System.Runtime.InteropServices.WindowsRuntime;
using CSETWeb_Api.BusinessLogic.Models;
using CSETWeb_Api.Models;
using System.Diagnostics;

namespace CSETWeb_Api.BusinessLogic.ReportEngine
{
    public class ReportsDataManager : QuestionRequirementManager
    {
        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="assessment_id"></param>
        public ReportsDataManager(int assessment_id) : base(assessment_id)
        {
        }

        public List<MatRelevantAnswers> getACETDeficiences()
        {
            List<BasicReportData.RequirementControl> controls = new List<BasicReportData.RequirementControl>();
            //select* from ANSWER a
            //join MATURITY_QUESTIONS q on a.Question_Or_Requirement_Id = q.Mat_Question_Id
            //where a.Assessment_Id = 2357 and a.question_type = 'Maturity' and a.Answer_Text = 'N'
            using (var db = new CSET_Context())
            {
                var cont = from a in db.ANSWER
                           join m in db.MATURITY_QUESTIONS on a.Question_Or_Requirement_Id equals m.Mat_Question_Id
                           where a.Assessment_Id == this.assessmentID && a.Question_Type == "Maturity" && a.Answer_Text == "N" && m.Maturity_Model_Id == 1
                           select new MatRelevantAnswers()
                           {
                               ANSWER=a,
                               Mat=m
                           };
                return cont.ToList();
            }
                
        }

        public List<MatRelevantAnswers> getCommentsList()
        {
            List<BasicReportData.RequirementControl> controls = new List<BasicReportData.RequirementControl>();
            //select* from ANSWER a
            //join MATURITY_QUESTIONS q on a.Question_Or_Requirement_Id = q.Mat_Question_Id
            //where a.Assessment_Id = 2357 and a.question_type = 'Maturity' and a.Answer_Text = 'N'
            using (var db = new CSET_Context())
            {
                var cont = from a in db.ANSWER
                           join m in db.MATURITY_QUESTIONS on a.Question_Or_Requirement_Id equals m.Mat_Question_Id
                           where a.Assessment_Id == this.assessmentID && a.Question_Type == "Maturity" && a.Comment!=null && m.Maturity_Model_Id == 1
                           select new MatRelevantAnswers()
                           {
                               ANSWER = a,
                               Mat = m
                           };
                return cont.ToList();
            }
        }

        public List<MatRelevantAnswers> getMarkedForReviewList()
        {
            List<BasicReportData.RequirementControl> controls = new List<BasicReportData.RequirementControl>();
            //select* from ANSWER a
            //join MATURITY_QUESTIONS q on a.Question_Or_Requirement_Id = q.Mat_Question_Id
            //where a.Assessment_Id = 2357 and a.question_type = 'Maturity' and a.Answer_Text = 'N'
            using (var db = new CSET_Context())
            {
                var cont = from a in db.ANSWER
                           join m in db.MATURITY_QUESTIONS on a.Question_Or_Requirement_Id equals m.Mat_Question_Id
                           where a.Assessment_Id == this.assessmentID && a.Question_Type == "Maturity" && (a.Mark_For_Review??false)==true && m.Maturity_Model_Id == 1
                           select new MatRelevantAnswers()
                           {
                               ANSWER = a,
                               Mat = m
                           };
                return cont.ToList();
            }
        }

        public List<MatRelevantAnswers> getAlternatesList()
        {
            List<BasicReportData.RequirementControl> controls = new List<BasicReportData.RequirementControl>();
            //select* from ANSWER a
            //join MATURITY_QUESTIONS q on a.Question_Or_Requirement_Id = q.Mat_Question_Id
            //where a.Assessment_Id = 2357 and a.question_type = 'Maturity' and a.Answer_Text = 'N'
            using (var db = new CSET_Context())
            {
                var cont = from a in db.ANSWER
                           join m in db.MATURITY_QUESTIONS on a.Question_Or_Requirement_Id equals m.Mat_Question_Id
                           where a.Assessment_Id == this.assessmentID && a.Question_Type == "Maturity" && a.Answer_Text == "A" && m.Maturity_Model_Id == 1
                           select new MatRelevantAnswers()
                           {
                               ANSWER = a,
                               Mat = m
                           };
                return cont.ToList();
            }

        }

        public List<MatAnsweredQuestionDomain> getAnsweredQuestionList(int assessmentId)
        {
            List<BasicReportData.RequirementControl> controls = new List<BasicReportData.RequirementControl>();
            //select* from ANSWER a
            //join MATURITY_QUESTIONS q on a.Question_Or_Requirement_Id = q.Mat_Question_Id
            //where a.Assessment_Id = 2357 and a.question_type = 'Maturity' and a.Answer_Text = 'N'
            using (var db = new CSET_Context())
            {
                
                var response = new MaturityResponse();

                var myModel = db.AVAILABLE_MATURITY_MODELS
                    .Include(x => x.model_)
                    .Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();

                var questions = db.MATURITY_QUESTIONS.Where(q =>
                    myModel.model_id == q.Maturity_Model_Id).ToList();


                // Get all MATURITY answers for the assessment
                var answers = from a in db.ANSWER.Where(x => x.Assessment_Id == assessmentId && x.Question_Type == "Maturity")
                              from b in db.VIEW_QUESTIONS_STATUS.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                              select new FullAnswer() { a = a, b = b };


                // Get all subgroupings for this maturity model
                var allGroupings = db.MATURITY_GROUPINGS
                    .Include(x => x.Type_)
                    .Where(x => x.Maturity_Model_Id == myModel.model_id).ToList();


                // Recursively build the grouping/question hierarchy
                var tempModel = new MaturityGrouping();
                BuildSubGroupings(tempModel, null, allGroupings, questions, answers.ToList());
                response.Groupings = tempModel.SubGroupings;

                var maturityDomains = new List<MatAnsweredQuestionDomain>();

                // ToDo: Refactor the following stucture of loops
                foreach (var domain in tempModel.SubGroupings){
                    
                    var newDomain = new MatAnsweredQuestionDomain()
                    {
                        Title = domain.Title,
                        AssesmentFactor = new List<MaturityAnsweredQuestionsAssesment>()
                    };
                    foreach (var assesmentFactor in domain.SubGroupings)
                    {
                        var newAssesmentFactor = new MaturityAnsweredQuestionsAssesment()
                        {
                            Title = assesmentFactor.Title,
                            Component = new List<MaturityAnsweredQuestionsComponent>()
                        };

                        foreach( var componenet in assesmentFactor.SubGroupings)
                        {
                            var newComponent = new MaturityAnsweredQuestionsComponent()
                            {
                                Title = componenet.Title,
                                Questions = new List<MaturityAnsweredQuestions>()
                            };

                            foreach (var question in componenet.Questions)
                            {
                                if (question.Answer != null)
                                {
                                    var newQuestion = new MaturityAnsweredQuestions()
                                    {
                                        Title = question.DisplayNumber,
                                        QuestionText = question.QuestionText,
                                    };

                                    if (question.Comment != null)
                                    {
                                        newQuestion.Comments = "Yes";
                                    } else
                                    {
                                        newQuestion.Comments = "No";
                                    }
                                  

                                    if (question.MaturityLevel == 6) {
                                        newQuestion.MaturityLevel = "ADV";
                                    } else if (question.MaturityLevel == 7)
                                    {
                                        newQuestion.MaturityLevel = "B";

                                    }
                                    else if (question.MaturityLevel == 8)
                                    {
                                        newQuestion.MaturityLevel = "E";

                                    }
                                    else if (question.MaturityLevel == 9)
                                    {
                                        newQuestion.MaturityLevel = "INN";

                                    }
                                    else if (question.MaturityLevel == 10)
                                    {
                                        newQuestion.MaturityLevel = "INT";

                                    }
                                    else
                                    {
                                        newQuestion.MaturityLevel = "";
                                    }
                                    newComponent.Questions.Add(newQuestion);

                                }
                            }
                            if (newComponent.Questions.Count > 0)
                            {
                                newAssesmentFactor.Component.Add(newComponent);
                            }

                        }
                        if (newAssesmentFactor.Component.Count > 0)
                        {
                            newDomain.AssesmentFactor.Add(newAssesmentFactor);
                        }

                    }
                    if (newDomain.AssesmentFactor.Count > 0)
                    {
                        maturityDomains.Add(newDomain);
                    }
                }

                return maturityDomains;
            }
        }

        private void BuildSubGroupings(MaturityGrouping g, int? parentID, 
            List<MATURITY_GROUPINGS> allGroupings,
            List<MATURITY_QUESTIONS> questions,
            List<FullAnswer> answers)
        {
            var mySubgroups = allGroupings.Where(x => x.Parent_Id == parentID).OrderBy(x => x.Sequence).ToList();

            if (mySubgroups.Count == 0)
            {
                return;
            }

            foreach (var sg in mySubgroups)
            {
                var newGrouping = new MaturityGrouping()
                {
                    GroupingID = sg.Grouping_Id,
                    GroupingType = sg.Type_.Grouping_Type_Name,
                    Title = sg.Title,
                    Description = sg.Description
                };

                g.SubGroupings.Add(newGrouping);


                // are there any questions that belong to this grouping?
                var myQuestions = questions.Where(x => x.Grouping_Id == newGrouping.GroupingID).ToList();

                var parentQuestionIDs = myQuestions.Select(x => x.Parent_Question_Id).Distinct().ToList();

                foreach (var myQ in myQuestions)
                {
                    FullAnswer answer = answers.Where(x => x.a.Question_Or_Requirement_Id == myQ.Mat_Question_Id).FirstOrDefault();

                    var qa = new QuestionAnswer()
                        {
                            DisplayNumber = myQ.Question_Title,
                            QuestionId = myQ.Mat_Question_Id,
                            ParentQuestionId = myQ.Parent_Question_Id,
                            QuestionType = "Maturity",
                            QuestionText = myQ.Question_Text.Replace("\r\n", "<br/>").Replace("\n", "<br/>").Replace("\r", "<br/>"),
                            Answer = answer?.a.Answer_Text,
                            AltAnswerText = answer?.a.Alternate_Justification,
                            Comment = answer?.a.Comment,
                            Feedback = answer?.a.Feedback,
                            MarkForReview = answer?.a.Mark_For_Review ?? false,
                            Reviewed = answer?.a.Reviewed ?? false,
                            Is_Maturity = true,
                            MaturityLevel = myQ.Maturity_Level,
                            IsParentQuestion = parentQuestionIDs.Contains(myQ.Mat_Question_Id),
                            SetName = string.Empty
                        };

                    if (answer != null)
                    {
                        TinyMapper.Bind<VIEW_QUESTIONS_STATUS, QuestionAnswer>();
                        TinyMapper.Map(answer.b, qa);
                    }

                    newGrouping.Questions.Add(qa);
                }

                // Recurse down to build subgroupings
                BuildSubGroupings(newGrouping, newGrouping.GroupingID, allGroupings, questions, answers);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<BasicReportData.RequirementControl> GetControls()
        {
            List<BasicReportData.RequirementControl> controls = new List<BasicReportData.RequirementControl>();

            using (var db = new CSET_Context())
            {
                db.FillEmptyQuestionsForAnalysis(assessmentID);

                var q = (from rs in db.REQUIREMENT_SETS
                         join r in db.NEW_REQUIREMENT on rs.Requirement_Id equals r.Requirement_Id
                         join rl in db.REQUIREMENT_LEVELS on r.Requirement_Id equals rl.Requirement_Id
                         join s in db.SETS on rs.Set_Name equals s.Set_Name
                         join av in db.AVAILABLE_STANDARDS on s.Set_Name equals av.Set_Name
                         join rqs in db.REQUIREMENT_QUESTIONS_SETS on new { r.Requirement_Id, s.Set_Name } equals new { rqs.Requirement_Id, rqs.Set_Name }
                         join qu in db.NEW_QUESTION on rqs.Question_Id equals qu.Question_Id
                         join a in db.Answer_Questions_No_Components on qu.Question_Id equals a.Question_Or_Requirement_Id
                         where rl.Standard_Level == _standardLevel && av.Selected == true && rl.Level_Type == "NST"
                             && av.Assessment_Id == assessmentID && a.Assessment_Id == assessmentID
                         orderby r.Standard_Category, r.Standard_Sub_Category, rs.Requirement_Sequence
                         select new { r, rs, rl, s, qu, a }).ToList();

                //get all the questions for this control 
                //determine the percent implemented.                 
                int prev_requirement_id = 0;
                int questionCount = 0;
                int questionsAnswered = 0;
                BasicReportData.RequirementControl control = null;
                List<BasicReportData.Control_Questions> questions = null;
                foreach (var a in q.ToList())
                {
                    double implementationstatus = 0;
                    if (prev_requirement_id != a.r.Requirement_Id)
                    {
                        questionCount = 0;
                        questionsAnswered = 0;
                        questions = new List<BasicReportData.Control_Questions>();
                        control = new BasicReportData.RequirementControl()
                        {
                            ControlDescription = a.r.Requirement_Text,
                            RequirementTitle = a.r.Requirement_Title,
                            Level = a.rl.Standard_Level,
                            StandardShortName = a.s.Short_Name,
                            Standard_Category = a.r.Standard_Category,
                            SubCategory = a.r.Standard_Sub_Category,
                            Control_Questions = questions
                        };
                        controls.Add(control);
                    }
                    questionCount++;

                    switch (a.a.Answer_Text)
                    {
                        case Constants.ALTERNATE:
                        case Constants.YES:
                            questionsAnswered++;
                            break;
                    }

                    questions.Add(new BasicReportData.Control_Questions()
                    {
                        Answer = a.a.Answer_Text,
                        Comment = a.a.Comment,
                        Simple_Question = a.qu.Simple_Question
                    });

                    control.ImplementationStatus = StatUtils.Percentagize(questionsAnswered, questionCount, 2).ToString("##.##");
                    prev_requirement_id = a.r.Requirement_Id;
                }
            }
            return controls;
        }

       
        public List<List<DiagramZones>> GetDiagramZones()
        {
            using (var db = new CSET_Context())
            {
                var level = db.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentID).FirstOrDefault();


                var rval1 = (from c in db.ASSESSMENT_DIAGRAM_COMPONENTS
                             join s in db.COMPONENT_SYMBOLS on c.Component_Symbol_Id equals s.Component_Symbol_Id
                             where c.Assessment_Id == assessmentID && c.Zone_Id == null
                             orderby s.Symbol_Name, c.label
                             select new DiagramZones
                             {
                                 Diagram_Component_Type = s.Symbol_Name,
                                 label = c.label,
                                 Zone_Name = "No Assigned Zone",
                                 Universal_Sal_Level = level == null ? "Low" : level.Selected_Sal_Level
                             }).ToList();

                var rval = (from c in db.ASSESSMENT_DIAGRAM_COMPONENTS
                            join z in db.DIAGRAM_CONTAINER on c.Zone_Id equals z.Container_Id
                            join s in db.COMPONENT_SYMBOLS on c.Component_Symbol_Id equals s.Component_Symbol_Id
                            where c.Assessment_Id == assessmentID
                            orderby s.Symbol_Name, c.label
                            select new DiagramZones
                            {
                                Diagram_Component_Type = s.Symbol_Name,
                                label = c.label,
                                Zone_Name = z.Name,
                                Universal_Sal_Level = z.Universal_Sal_Level
                            }).ToList();

                return rval.Union(rval1).GroupBy(u => u.Zone_Name).Select(grp => grp.ToList()).ToList();
            }
        }


        public List<usp_getFinancialQuestions_Result> GetFinancialQuestions()
        {
            using (var db = new CSET_Context())
            {
                return db.usp_getFinancialQuestions(assessmentID).ToList();
            }
        }


        public List<StandardQuestions> GetQuestionsForEachStandard()
        {
            using (var db = new CSET_Context())
            {
                var dblist = from a in db.AVAILABLE_STANDARDS
                             join b in db.NEW_QUESTION_SETS on a.Set_Name equals b.Set_Name
                             join c in db.Answer_Questions on b.Question_Id equals c.Question_Or_Requirement_Id
                             join q in db.NEW_QUESTION on c.Question_Or_Requirement_Id equals q.Question_Id
                             join h in db.vQUESTION_HEADINGS on q.Heading_Pair_Id equals h.Heading_Pair_Id
                             join s in db.SETS on b.Set_Name equals s.Set_Name
                             where a.Selected == true && a.Assessment_Id == assessmentID
                             && c.Assessment_Id == assessmentID
                             orderby s.Short_Name, h.Question_Group_Heading, c.Question_Number
                             select new SimpleStandardQuestions()
                             {
                                 ShortName = s.Short_Name,
                                 Answer = c.Answer_Text,
                                 CategoryAndNumber = h.Question_Group_Heading + " #" + c.Question_Number,
                                 Question = q.Simple_Question
                             };
                List<StandardQuestions> list = new List<StandardQuestions>();
                string lastshortname = "";
                List<SimpleStandardQuestions> qlist = new List<SimpleStandardQuestions>();
                foreach (var a in dblist.ToList())
                {
                    if (a.ShortName != lastshortname)
                    {
                        qlist = new List<SimpleStandardQuestions>();
                        list.Add(new StandardQuestions()
                        {
                            Questions = qlist,
                            StandardShortName = a.ShortName
                        });
                    }
                    lastshortname = a.ShortName;
                    qlist.Add(a);
                }
                return list;
            }
        }


        /// <summary>
        /// Returns a list of questions generated by components in the network.
        /// The questions correspond to the SAL level of each component's Zone level.
        /// Questions for components in hidden layers are not included.
        /// </summary>
        /// <returns></returns>
        public List<ComponentQuestion> GetComponentQuestions()
        {
            var l = new List<ComponentQuestion>();

            using (var db = new CSET_Context())
            {
                List<usp_getExplodedComponent> results = null;

                db.LoadStoredProc("[usp_getExplodedComponent]")
                  .WithSqlParam("assessment_id", assessmentID)
                  .ExecuteStoredProc((handler) =>
                  {
                      results = handler.ReadToList<usp_getExplodedComponent>().OrderBy(c => c.ComponentName).ThenBy(c => c.QuestionText).ToList();
                  });

                foreach (usp_getExplodedComponent q in results)
                {
                    l.Add(new ComponentQuestion
                    {
                        Answer = q.Answer_Text,
                        ComponentName = q.ComponentName,
                        Component_Symbol_Id = q.Component_Symbol_Id,
                        Question = q.QuestionText,
                        LayerName = q.LayerName,
                        SAL = q.SAL,
                        Zone = q.ZoneName
                    });
                }
            }

            return l;
        }


        public List<usp_GetOverallRankedCategoriesPage_Result> GetTop5Categories()
        {
            using (var db = new CSET_Context())
            {
                return db.usp_GetOverallRankedCategoriesPage(assessmentID).Take(5).ToList();
            }

        }


        public List<RankedQuestions> GetTop5Questions()
        {
            return GetRankedQuestions().Take(5).ToList();
        }


        /// <summary>
        /// Returns a list of questions that have been answered "Alt"
        /// </summary>
        /// <returns></returns>
        public List<QuestionsWithAlternateJustifi> GetQuestionsWithAlternateJustification()
        {
            using (var db = new CSET_Context())
            {
                var results = new List<QuestionsWithAlternateJustifi>();

                // get any "A" answers that currently apply
                var relevantAnswers = RelevantAnswers.GetAnswersForAssessment(assessmentID)
                    .Where(ans => ans.Answer_Text == "A").ToList();

                if (relevantAnswers.Count == 0)
                {
                    return results;
                }

                bool requirementMode = relevantAnswers[0].Is_Requirement;

                // include Question or Requirement contextual information
                if (requirementMode)
                {
                    var query = from ans in relevantAnswers
                                join req in db.NEW_REQUIREMENT on ans.Question_Or_Requirement_ID equals req.Requirement_Id
                                select new QuestionsWithAlternateJustifi()
                                {
                                    Answer = ans.Answer_Text,
                                    CategoryAndNumber = req.Standard_Category + " - " + req.Requirement_Title,
                                    AlternateJustification = ans.Alternate_Justification,
                                    Question = req.Requirement_Text
                                };

                    return query.ToList();
                }
                else
                {
                    var query = from ans in relevantAnswers
                                join q in db.NEW_QUESTION on ans.Question_Or_Requirement_ID equals q.Question_Id
                                join h in db.vQUESTION_HEADINGS on q.Heading_Pair_Id equals h.Heading_Pair_Id
                                orderby h.Question_Group_Heading
                                select new QuestionsWithAlternateJustifi()
                                {
                                    Answer = ans.Answer_Text,
                                    CategoryAndNumber = h.Question_Group_Heading + " #" + ans.Question_Number,
                                    AlternateJustification = ans.Alternate_Justification,
                                    Question = q.Simple_Question
                                };

                    return query.ToList();
                }
            }
        }


        /// <summary>
        /// Returns a list of questions that have comments.
        /// </summary>
        /// <returns></returns>
        public List<QuestionsWithComments> GetQuestionsWithComments()
        {
            using (var db = new CSET_Context())
            {
                var results = new List<QuestionsWithComments>();

                // get any "marked for review" or commented answers that currently apply
                var relevantAnswers = RelevantAnswers.GetAnswersForAssessment(assessmentID)
                    .Where(ans => !string.IsNullOrEmpty(ans.Comment))
                    .ToList();

                if (relevantAnswers.Count == 0)
                {
                    return results;
                }

                bool requirementMode = relevantAnswers[0].Is_Requirement;

                // include Question or Requirement contextual information
                if (requirementMode)
                {
                    var query = from ans in relevantAnswers
                                join req in db.NEW_REQUIREMENT on ans.Question_Or_Requirement_ID equals req.Requirement_Id
                                select new QuestionsWithComments()
                                {
                                    Answer = ans.Answer_Text,
                                    CategoryAndNumber = req.Standard_Category + " - " + req.Requirement_Title,
                                    Question = req.Requirement_Text,
                                    Comment = ans.Comment
                                };

                    return query.ToList();
                }
                else
                {
                    var query = from ans in relevantAnswers
                                join q in db.NEW_QUESTION on ans.Question_Or_Requirement_ID equals q.Question_Id
                                join h in db.vQUESTION_HEADINGS on q.Heading_Pair_Id equals h.Heading_Pair_Id
                                orderby h.Question_Group_Heading
                                select new QuestionsWithComments()
                                {
                                    Answer = ans.Answer_Text,
                                    CategoryAndNumber = h.Question_Group_Heading + " #" + ans.Question_Number,
                                    Question = q.Simple_Question,
                                    Comment = ans.Comment
                                };

                    return query.ToList();
                }
            }
        }


        /// <summary>
        /// Returns a list of questions that have been marked for review.
        /// </summary>
        /// <returns></returns>
        public List<QuestionsMarkedForReview> GetQuestionsMarkedForReview()
        {
            using (var db = new CSET_Context())
            {
                var results = new List<QuestionsMarkedForReview>();

                // get any "marked for review" or commented answers that currently apply
                var relevantAnswers = RelevantAnswers.GetAnswersForAssessment(assessmentID)
                    .Where(ans => ans.Mark_For_Review)
                    .ToList();

                if (relevantAnswers.Count == 0)
                {
                    return results;
                }

                bool requirementMode = relevantAnswers[0].Is_Requirement;

                // include Question or Requirement contextual information
                if (requirementMode)
                {
                    var query = from ans in relevantAnswers
                                join req in db.NEW_REQUIREMENT on ans.Question_Or_Requirement_ID equals req.Requirement_Id
                                select new QuestionsMarkedForReview()
                                {
                                    Answer = ans.Answer_Text,
                                    CategoryAndNumber = req.Standard_Category + " - " + req.Requirement_Title,
                                    Question = req.Requirement_Text
                                };

                    return query.ToList();
                }
                else
                {
                    var query = from ans in relevantAnswers
                                join q in db.NEW_QUESTION on ans.Question_Or_Requirement_ID equals q.Question_Id
                                join h in db.vQUESTION_HEADINGS on q.Heading_Pair_Id equals h.Heading_Pair_Id
                                orderby h.Question_Group_Heading
                                select new QuestionsMarkedForReview()
                                {
                                    Answer = ans.Answer_Text,
                                    CategoryAndNumber = h.Question_Group_Heading + " #" + ans.Question_Number,
                                    Question = q.Simple_Question
                                };

                    return query.ToList();
                }
            }
        }


        public List<RankedQuestions> GetRankedQuestions()
        {
            using (var db = new CSET_Context())
            {
                RequirementsManager rm = new RequirementsManager(assessmentID);

                List<RankedQuestions> list = new List<RankedQuestions>();
                List<usp_GetRankedQuestions_Result> rankedQuestionList = db.usp_GetRankedQuestions(assessmentID).ToList();
                foreach (usp_GetRankedQuestions_Result q in rankedQuestionList)
                {
                    q.QuestionText = rm.ResolveParameters(q.QuestionOrRequirementID, q.AnswerID, q.QuestionText);

                    list.Add(new RankedQuestions()
                    {
                        Answer = q.AnswerText,
                        CategoryAndNumber = q.Category + " #" + q.QuestionRef,
                        Level = q.Level,
                        Question = q.QuestionText,
                        Rank = q.Rank ?? 0
                    });
                }
                return list;
            }
        }


        public List<DocumentLibraryTable> GetDocumentLibrary()
        {
            using (var db = new CSET_Context())
            {
                List<DocumentLibraryTable> list = new List<DocumentLibraryTable>();
                var docs = from a in db.DOCUMENT_FILE
                           where a.Assessment_Id == assessmentID
                           select a;
                foreach (var doc in docs)
                {
                    list.Add(new DocumentLibraryTable()
                    {
                        DocumentTitle = doc.Title,
                        FileName = doc.Path
                    });
                }
                return list;
            }
        }


        public BasicReportData.OverallSALTable GetNistSals()
        {
            using (var db = new CSET_Context())
            {
                NistSalManager manager = new NistSalManager();
                Models.Sals sals = manager.CalculatedNist(assessmentID, db);
                List<BasicReportData.CNSSSALJustificationsTable> list = new List<BasicReportData.CNSSSALJustificationsTable>();
                var infos = db.CNSS_CIA_JUSTIFICATIONS.Where(x => x.Assessment_Id == assessmentID).ToList();
                Dictionary<string, string> typeToLevel = db.CNSS_CIA_JUSTIFICATIONS.Where(x => x.Assessment_Id == assessmentID).ToDictionary(x => x.CIA_Type, x => x.DropDownValueLevel);

                BasicReportData.OverallSALTable overallSALTable = new BasicReportData.OverallSALTable()
                {
                    OSV = sals.Selected_Sal_Level,
                    Q_AV = sals.ALevel,
                    Q_CV = sals.CLevel,
                    Q_IV = sals.ILevel
                };

                bool ok;
                string l;
                ok = typeToLevel.TryGetValue(Constants.Availabilty, out l);
                overallSALTable.IT_AV = ok ? l : "Low";
                ok = typeToLevel.TryGetValue(Constants.Confidentiality, out l);
                overallSALTable.IT_CV = ok ? l : "Low";
                ok = typeToLevel.TryGetValue(Constants.Integrity, out l);
                overallSALTable.IT_IV = ok ? l : "Low";

                return overallSALTable;
            }
        }


        public List<BasicReportData.CNSSSALJustificationsTable> GetNistInfoTypes()
        {
            using (var db = new CSET_Context())
            {
                List<BasicReportData.CNSSSALJustificationsTable> list = new List<BasicReportData.CNSSSALJustificationsTable>();
                var infos = db.CNSS_CIA_JUSTIFICATIONS.Where(x => x.Assessment_Id == assessmentID).ToList();
                foreach (CNSS_CIA_JUSTIFICATIONS info in infos)
                {
                    list.Add(new BasicReportData.CNSSSALJustificationsTable()
                    {
                        CIA_Type = info.CIA_Type,
                        Justification = info.Justification
                    });
                }
                return list;
            }

        }


        /// <summary>
        /// Returns SAL CIA values for the assessment.
        /// </summary>
        /// <returns></returns>
        public BasicReportData.OverallSALTable GetSals()
        {
            using (var db = new CSET_Context())
            {
                var sals = (from a in db.STANDARD_SELECTION
                            join b in db.ASSESSMENT_SELECTED_LEVELS on a.Assessment_Id equals b.Assessment_Id
                            where a.Assessment_Id == assessmentID
                            select new { a, b }).ToList();

                string OSV = "Low";
                string Q_CV = "Low";
                string Q_IV = "Low";
                string Q_AV = "Low";
                foreach (var s in sals)
                {
                    OSV = s.a.Selected_Sal_Level;
                    switch (s.b.Level_Name)
                    {
                        case "Confidence_Level":
                            Q_CV = s.b.Standard_Specific_Sal_Level;
                            break;
                        case "Integrity_Level":
                            Q_IV = s.b.Standard_Specific_Sal_Level;
                            break;
                        case "Availability_Level":
                            Q_AV = s.b.Standard_Specific_Sal_Level;
                            break;
                    }
                }

                // get active SAL type
                var standardSelection = db.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentID).FirstOrDefault();

                return new BasicReportData.OverallSALTable()
                {
                    OSV = OSV,
                    Q_CV = Q_CV,
                    Q_AV = Q_AV,
                    Q_IV = Q_IV,
                    LastSalDeterminationType = standardSelection.Last_Sal_Determination_Type
                };
            }
        }


        /// <summary>
        /// Returns a block of data generally from the INFORMATION table plus a few others.
        /// </summary>
        /// <returns></returns>
        public BasicReportData.INFORMATION GetInformation()
        {
            using (var db = new CSET_Context())
            {
                INFORMATION infodb = db.INFORMATION.Where(x => x.Id == assessmentID).FirstOrDefault();

                TinyMapper.Bind<INFORMATION, BasicReportData.INFORMATION>(config =>
                {
                    config.Ignore(x => x.Additional_Contacts);
                });
                var info = TinyMapper.Map<BasicReportData.INFORMATION>(infodb);


                var assessment = db.ASSESSMENTS.FirstOrDefault(x => x.Assessment_Id == assessmentID);
                info.Assessment_Date = assessment.Assessment_Date.ToLongDateString();

                // Primary Assessor
                var user = db.USERS.FirstOrDefault(x => x.UserId == assessment.AssessmentCreatorId);
                info.Assessor_Name = user != null ? Utilities.FormatName(user.FirstName, user.LastName) : string.Empty;


                // Other Contacts
                info.Additional_Contacts = new List<string>();
                var contacts = db.ASSESSMENT_CONTACTS
                    .Where(ac => ac.Assessment_Id == assessmentID
                            && ac.UserId != assessment.AssessmentCreatorId)
                    .Include(u => u.User)
                    .ToList();
                foreach (var c in contacts)
                {
                    info.Additional_Contacts.Add(Utilities.FormatName(c.FirstName, c.LastName));
                }

                // Include anything that was in the INFORMATION record's Additional_Contacts column
                if (infodb.Additional_Contacts != null)
                {
                    string[] acLines = infodb.Additional_Contacts.Split(new[] { Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (string c in acLines)
                    {
                        info.Additional_Contacts.Add(c);
                    }
                }


                // ACET properties
                info.Credit_Union_Name = assessment.CreditUnionName;
                info.Charter = assessment.Charter;

                info.Assets = 0;
                bool a = int.TryParse(assessment.Assets, out int assets);
                if (a)
                {
                    info.Assets = assets;
                }

                return info;
            }
        }


        /// <summary>
        /// Returns a list of individuals assigned to findings/observations.
        /// </summary>
        /// <returns></returns>
        public List<Individual> GetFindingIndividuals()
        {
            using (var db = new CSET_Context())
            {
                var findings = (from a in db.FINDING_CONTACT
                                join b in db.FINDING on a.Finding_Id equals b.Finding_Id
                                join c in db.ANSWER on b.Answer_Id equals c.Answer_Id
                                join d in db.ASSESSMENT_CONTACTS on a.Assessment_Contact_Id equals d.Assessment_Contact_Id
                                join i in db.IMPORTANCE on b.Importance_Id equals i.Importance_Id
                                where c.Assessment_Id == assessmentID
                                orderby a.Assessment_Contact_Id, b.Answer_Id, b.Finding_Id
                                select new { a, b, d, i.Value }).ToList();



                List<Individual> list = new List<Individual>();
                int contactid = 0;
                Individual individual = null;
                foreach (var f in findings)
                {
                    if (contactid != f.a.Assessment_Contact_Id)
                    {
                        individual = new Individual()
                        {
                            Findings = new List<Findings>(),
                            INDIVIDUALFULLNAME = Utilities.FormatName(f.d.FirstName, f.d.LastName)
                        };
                        list.Add(individual);
                    }
                    contactid = f.a.Assessment_Contact_Id;
                    TinyMapper.Bind<FINDING, Findings>();
                    Findings rfind = TinyMapper.Map<Findings>(f.b);
                    rfind.Finding = f.b.Summary;
                    rfind.ResolutionDate = f.b.Resolution_Date.ToString();
                    rfind.Importance = f.Value;

                    var othersList = (from a in f.b.FINDING_CONTACT
                                      join b in db.ASSESSMENT_CONTACTS on a.Assessment_Contact_Id equals b.Assessment_Contact_Id
                                      select Utilities.FormatName(b.FirstName, b.LastName)).ToList();
                    rfind.OtherContacts = string.Join(",", othersList);
                    individual.Findings.Add(rfind);

                }
                return list;
            }

        }


        public GenSALTable GetGenSals()
        {
            using (var db = new CSET_Context())
            {
                var gensalnames = db.GEN_SAL_NAMES.ToList();
                var actualvalues = (from a in db.GENERAL_SAL.Where(x => x.Assessment_Id == this.assessmentID)
                                    join b in db.GEN_SAL_WEIGHTS on new { a.Sal_Name, a.Slider_Value } equals new { b.Sal_Name, b.Slider_Value }
                                    select b).ToList();
                GenSALTable genSALTable = new GenSALTable();
                foreach (var a in gensalnames)
                {
                    genSALTable.setValue(a.Sal_Name, "None");
                }
                foreach (var a in actualvalues)
                {
                    genSALTable.setValue(a.Sal_Name, a.Display);
                }
                return genSALTable;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        /// 
        public List<MaturityReportData.MaturityModel> getMaturityModelData()
        {
            List<MaturityReportData.MaturityQuestion> mat_questions = new List<MaturityReportData.MaturityQuestion>();
            List<MaturityReportData.MaturityModel> mat_models = new List<MaturityReportData.MaturityModel>(); 
            using (var db = new CSET_Context())
            {
                db.FillEmptyMaturityQuestionsForAnalysis(assessmentID);

                var query = (
                    from amm in db.AVAILABLE_MATURITY_MODELS
                    join mm in db.MATURITY_MODELS on amm.model_id equals mm.Maturity_Model_Id
                    join mq in db.MATURITY_QUESTIONS on mm.Maturity_Model_Id equals mq.Maturity_Model_Id
                    join ans in db.ANSWER on mq.Mat_Question_Id equals ans.Question_Or_Requirement_Id
                    join asl in db.ASSESSMENT_SELECTED_LEVELS on amm.Assessment_Id equals asl.Assessment_Id
                    where amm.Assessment_Id == assessmentID 
                    && ans.Assessment_Id == assessmentID
                    && ans.Is_Maturity == true
                    && asl.Level_Name == "Maturity_Level"
                    select new { amm, mm, mq, ans, asl }
                    ).ToList();
                var models = query.Select(x => new { x.mm, x.asl }).Distinct();
                foreach(var model in models)
                {
                    MaturityReportData.MaturityModel newModel = new MaturityReportData.MaturityModel();
                    newModel.MaturityModelName = model.mm.Model_Name;
                    newModel.MaturityModelID = model.mm.Maturity_Model_Id;
                    if(Int32.TryParse(model.asl.Standard_Specific_Sal_Level, out int lvl)) {
                        newModel.TargetLevel = lvl;
                    } else {
                        newModel.TargetLevel = null;
                    }
                    mat_models.Add(newModel);
                }

                foreach(var queryItem in query)
                {
                    MaturityReportData.MaturityQuestion newQuestion = new MaturityReportData.MaturityQuestion();
                    newQuestion.Mat_Question_Id = queryItem.mq.Mat_Question_Id;
                    newQuestion.Question_Title = queryItem.mq.Question_Title;
                    newQuestion.Question_Text = queryItem.mq.Question_Text;
                    newQuestion.Supplemental_Info = queryItem.mq.Supplemental_Info;
                    newQuestion.Category = queryItem.mq.Category;
                    newQuestion.Sub_Category = queryItem.mq.Sub_Category;
                    newQuestion.Maturity_Level = queryItem.mq.Maturity_Level;
                    newQuestion.Set_Name = queryItem.mm.Model_Name;
                    newQuestion.Sequence = queryItem.mq.Sequence;
                    //newQuestion.Text_Hash = queryItem.mq.Text_Hash;
                    newQuestion.Maturity_Model_Id = queryItem.mm.Maturity_Model_Id;
                    newQuestion.Answer = queryItem.ans;

                    mat_models.Where(x => x.MaturityModelID == newQuestion.Maturity_Model_Id)
                        .FirstOrDefault()
                        .MaturityQuestions.Add(newQuestion);

                    mat_questions.Add(newQuestion);
                }
                return mat_models;

            }
        }

    }


    public class DiagramZones
    {
        public string Diagram_Component_Type { get; set; }
        public string label { get; set; }
        public string Universal_Sal_Level { get; set; }
        public string Zone_Name { get; set; }
    }
}


