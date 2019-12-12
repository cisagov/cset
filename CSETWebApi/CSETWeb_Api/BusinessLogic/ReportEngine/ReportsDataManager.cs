//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
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

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<BasicReportData.RequirementControl> GetControls()
        {
            List<BasicReportData.RequirementControl> controls = new List<BasicReportData.RequirementControl>();

            using (var db = new CSET_Context())
            {
                db.FillEmptyQuestionsForAnalysis(_assessmentId);

                var q = (from rs in db.REQUIREMENT_SETS
                         join r in db.NEW_REQUIREMENT on rs.Requirement_Id equals r.Requirement_Id
                         join rl in db.REQUIREMENT_LEVELS on r.Requirement_Id equals rl.Requirement_Id
                         join s in db.SETS on rs.Set_Name equals s.Set_Name
                         join av in db.AVAILABLE_STANDARDS on s.Set_Name equals av.Set_Name
                         join rqs in db.REQUIREMENT_QUESTIONS_SETS on new { r.Requirement_Id, s.Set_Name } equals new { rqs.Requirement_Id, rqs.Set_Name }
                         join qu in db.NEW_QUESTION on rqs.Question_Id equals qu.Question_Id
                         join a in db.Answer_Questions_No_Components on qu.Question_Id equals a.Question_Or_Requirement_Id
                         where rl.Standard_Level == _standardLevel && av.Selected == true && rl.Level_Type == "NST"
                             && av.Assessment_Id == _assessmentId && a.Assessment_Id == _assessmentId
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
                var level = db.STANDARD_SELECTION.Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();


                var rval1 = (from c in db.ASSESSMENT_DIAGRAM_COMPONENTS
                             join s in db.COMPONENT_SYMBOLS on c.Component_Symbol_Id equals s.Component_Symbol_Id
                             where c.Assessment_Id == _assessmentId && c.Zone_Id == null
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
                            where c.Assessment_Id == _assessmentId
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
                return db.usp_getFinancialQuestions(_assessmentId).ToList();
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
                             where a.Selected == true && a.Assessment_Id == _assessmentId
                             && c.Assessment_Id == _assessmentId
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

                db.LoadStoredProc("[dbo].[usp_getExplodedComponent]")
                  .WithSqlParam("assessment_id", _assessmentId)
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
                return db.usp_GetOverallRankedCategoriesPage(_assessmentId).Take(5).ToList();
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
                var relevantAnswers = RelevantAnswers.GetAnswersForAssessment(_assessmentId)
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
        /// Returns a list of questions that have been marked for review or have comments.
        /// </summary>
        /// <returns></returns>
        public List<QuestionsWithComments> GetQuestionsWithCommentsOrMarkedForReview()
        {
            using (var db = new CSET_Context())
            {
                var results = new List<QuestionsWithComments>();

                // get any "marked for review" or commented answers that currently apply
                var relevantAnswers = RelevantAnswers.GetAnswersForAssessment(_assessmentId)
                    .Where(ans => ans.Mark_For_Review == true || !string.IsNullOrEmpty(ans.Comment))
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
                                    MarkedForReview = ans.Mark_For_Review.ToString(),
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
                                    MarkedForReview = ans.Mark_For_Review.ToString(),
                                    Question = q.Simple_Question,
                                    Comment = ans.Comment
                                };

                    return query.ToList();
                }
            }
        }


        public List<RankedQuestions> GetRankedQuestions()
        {
            using (var db = new CSET_Context())
            {
                RequirementsManager rm = new RequirementsManager(_assessmentId);

                List<RankedQuestions> list = new List<RankedQuestions>();
                List<usp_GetRankedQuestions_Result> rankedQuestionList = db.usp_GetRankedQuestions(_assessmentId).ToList();
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
                           where a.Assessment_Id == _assessmentId
                           select a;
                foreach (var doc in docs)
                {
                    list.Add(new DocumentLibraryTable()
                    {
                        documenttitle = doc.Title,
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
                Models.Sals sals = manager.CalculatedNist(_assessmentId, db);
                List<BasicReportData.CNSSSALJustificationsTable> list = new List<BasicReportData.CNSSSALJustificationsTable>();
                var infos = db.CNSS_CIA_JUSTIFICATIONS.Where(x => x.Assessment_Id == _assessmentId).ToList();
                Dictionary<string, string> typeToLevel = db.CNSS_CIA_JUSTIFICATIONS.Where(x => x.Assessment_Id == _assessmentId).ToDictionary(x => x.CIA_Type, x => x.DropDownValueLevel);

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
                var infos = db.CNSS_CIA_JUSTIFICATIONS.Where(x => x.Assessment_Id == _assessmentId).ToList();
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


        public BasicReportData.OverallSALTable GetSals()
        {
            using (var db = new CSET_Context())
            {
                var sals = (from a in db.STANDARD_SELECTION
                            join b in db.ASSESSMENT_SELECTED_LEVELS on a.Assessment_Id equals b.Assessment_Id
                            where a.Assessment_Id == _assessmentId
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
                        case "Q_CV":
                            Q_CV = s.b.Standard_Specific_Sal_Level;
                            break;
                        case "Q_IV":
                            Q_IV = s.b.Standard_Specific_Sal_Level;
                            break;
                        case "Q_AV":
                            Q_AV = s.b.Standard_Specific_Sal_Level;
                            break;
                    }
                }

                // get active SAL type
                var standardSelection = db.STANDARD_SELECTION.Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();

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
                INFORMATION infodb = db.INFORMATION.Where(x => x.Id == _assessmentId).FirstOrDefault();

                TinyMapper.Bind<INFORMATION, BasicReportData.INFORMATION>(config =>
                {
                    config.Ignore(x => x.Additional_Contacts);
                });
                var info = TinyMapper.Map<BasicReportData.INFORMATION>(infodb);


                var assessment = db.ASSESSMENTS.FirstOrDefault(x => x.Assessment_Id == _assessmentId);
                info.Assessment_Date = assessment.Assessment_Date.ToLongDateString();

                // Primary Assessor
                var user = db.USERS.FirstOrDefault(x => x.UserId == assessment.AssessmentCreatorId);
                info.Assessor_Name = user != null ? Utilities.FormatName(user.FirstName, user.LastName) : string.Empty;


                // Other Contacts
                info.Additional_Contacts = new List<string>();
                var contacts = db.ASSESSMENT_CONTACTS
                    .Where(ac => ac.Assessment_Id == _assessmentId
                            && ac.UserId != assessment.AssessmentCreatorId)
                    .Include(u => u.User)
                    .ToList();
                foreach (var c in contacts)
                {
                    info.Additional_Contacts.Add(Utilities.FormatName(c.FirstName, c.LastName));
                }

                // Include anything that was in the INFORMATION record's Additional_Contacts column
                string[] acLines = infodb.Additional_Contacts.Split(new[] { Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries);
                foreach (string c in acLines)
                {
                    info.Additional_Contacts.Add(c);
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


        public List<Individual> GetFindingIndividuals()
        {
            using (var db = new CSET_Context())
            {
                var findings = (from a in db.FINDING_CONTACT
                                join b in db.FINDING on a.Finding_Id equals b.Finding_Id
                                join c in db.ANSWER on b.Answer_Id equals c.Answer_Id
                                join d in db.ASSESSMENT_CONTACTS on a.Assessment_Contact_Id equals d.Assessment_Contact_Id
                                join i in db.IMPORTANCE on b.Importance_Id equals i.Importance_Id
                                where c.Assessment_Id == _assessmentId
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
                var actualvalues = (from a in db.GENERAL_SAL.Where(x => x.Assessment_Id == this._assessmentId)
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
    }


    public class DiagramZones
    {
        public string Diagram_Component_Type { get; set; }
        public string label { get; set; }
        public string Universal_Sal_Level { get; set; }
        public string Zone_Name { get; set; }
    }
}


