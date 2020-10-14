using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataLayerCore.Model;
using DataLayerCore.Manual;
using Snickler.EFCore;
using BusinessLogic.Helpers;
using BusinessLogic.Models;
using Microsoft.EntityFrameworkCore;
using System.Data.SqlClient;
using CSETWeb_Api.BusinessLogic;

using CSETWeb_Api.BusinessLogic.Models;

namespace CSETWeb_Api.BusinessLogic
{
    /// <summary>
    /// 
    /// </summary>
    public class AggregationManager
    {
        /// <summary>
        /// Returns a list of AGGREGATION_INFORMATION records for the specified type, Trend or Compare.
        /// Returns only AGGREGATION_INFORMATION records where the current user is authorized
        /// to view all Assessments involved in the aggregation.
        /// </summary>
        /// <returns></returns>
        public List<Aggregation> GetAggregations(string mode, int currentUserId)
        {
            var l = new List<Aggregation>();

            using (var db = new CSET_Context())
            {
                // Find all aggregations of the desired type that the current user has access to one or more of its assessments
                var q1 = from ai in db.AGGREGATION_INFORMATION
                         where ai.Aggregation_Mode == mode
                         select ai;

                var aggCandidates = q1.ToList();

                List<int> myAllowedAggregIDs = new List<int>();

                foreach (var agg in aggCandidates)
                {
                    var assessmentIDs = db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == agg.AggregationID).Select(x => x.Assessment_Id).ToList();

                    // Hopefully this can be refactored.  We need to make sure that the current user is connected to all assessments in this aggregation.
                    if (db.ASSESSMENT_CONTACTS.Where(x => assessmentIDs.Contains(x.Assessment_Id) && x.UserId == currentUserId).Count() < assessmentIDs.Count)
                    {
                        continue;
                    }

                    if (myAllowedAggregIDs.Contains(agg.AggregationID))
                    {
                        continue;
                    }

                    l.Add(new Aggregation()
                    {
                        AggregationId = agg.AggregationID,
                        AggregationName = agg.Aggregation_Name,
                        AggregationDate = agg.Aggregation_Date
                    });

                    myAllowedAggregIDs.Add(agg.AggregationID);
                }
            }

            return l.OrderBy(x => x.AggregationDate).ToList();
        }


        /// <summary>
        /// Creates a new Aggregation (Trend or Comparison).
        /// </summary>
        public Aggregation CreateAggregation(string mode)
        {
            string name = "";
            switch (mode)
            {
                case "COMPARE":
                    name = "New Comparison";
                    break;
                case "TREND":
                    name = "New Trend";
                    break;
            }

            Aggregation newAgg = new Aggregation()
            {
                AggregationDate = DateTime.Today,
                AggregationName = name,
                Mode = mode
            };

            // Commit the new assessment
            int aggregationId = SaveAggregationInformation(0, newAgg);
            newAgg.AggregationId = aggregationId;

            return newAgg;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="aggregationId"></param>
        /// <returns></returns>
        public Aggregation GetAggregation(int aggregationId)
        {
            using (var db = new CSET_Context())
            {
                // Find all aggregations of the desired type that the current user has access to one or more of its assessments
                var agg = db.AGGREGATION_INFORMATION.Where(x => x.AggregationID == aggregationId).FirstOrDefault();
                if (agg == null)
                {
                    return null;
                }

                return new Aggregation()
                {
                    AggregationDate = agg.Aggregation_Date,
                    AggregationId = agg.AggregationID,
                    AggregationName = agg.Aggregation_Name,
                    Mode = agg.Aggregation_Mode
                };
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public int SaveAggregationInformation(int aggregationId, Aggregation aggreg)
        {
            using (var db = new CSET_Context())
            {
                var agg = db.AGGREGATION_INFORMATION.Where(x => x.AggregationID == aggregationId).FirstOrDefault();

                if (agg == null)
                {
                    agg = new AGGREGATION_INFORMATION()
                    {
                        Aggregation_Name = aggreg.AggregationName,
                        Aggregation_Date = DateTime.Today,
                        Aggregation_Mode = aggreg.Mode
                    };

                    db.AGGREGATION_INFORMATION.Add(agg);
                    db.SaveChanges();
                    aggregationId = agg.AggregationID;
                }

                agg.AggregationID = aggregationId;
                agg.Aggregation_Name = aggreg.AggregationName;
                agg.Aggregation_Date = aggreg.AggregationDate;

                db.AGGREGATION_INFORMATION.AddOrUpdate(agg, x => x.AggregationID);
                db.SaveChanges();

                return aggregationId;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="aggregationId"></param>
        public void DeleteAggregation(int aggregationId)
        {
            using (var db = new CSET_Context())
            {
                db.AGGREGATION_ASSESSMENT.RemoveRange(
                    db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationId)
                    );

                db.AGGREGATION_INFORMATION.RemoveRange(
                    db.AGGREGATION_INFORMATION.Where(x => x.AggregationID == aggregationId)
                    );

                db.SaveChanges();
            }
        }


        /// <summary>
        /// Returns a list of assessments for the specified aggregation.
        /// The list is in ascending order of assessment date.
        /// </summary>
        /// <param name="aggregationId"></param>
        public AssessmentListResponse GetAssessmentsForAggregation(int aggregationId)
        {
            using (var db = new CSET_Context())
            {
                var ai = db.AGGREGATION_INFORMATION.Where(x => x.AggregationID == aggregationId).FirstOrDefault();
                var resp = new AssessmentListResponse
                {
                    Aggregation = new Aggregation()
                    {
                        AggregationId = ai.AggregationID,
                        AggregationName = ai.Aggregation_Name,
                        AggregationDate = ai.Aggregation_Date
                    }
                };


                var dbAaList = db.AGGREGATION_ASSESSMENT
                    .Where(x => x.Aggregation_Id == aggregationId)
                    .Include(x => x.Assessment_)
                    .ThenInclude(x => x.INFORMATION)
                    .OrderBy(x => x.Assessment_.Assessment_Date)
                    .ToList();

                var l = new List<AggregAssessment>();

                foreach (var dbAA in dbAaList)
                {
                    var aa = new AggregAssessment()
                    {
                        AssessmentId = dbAA.Assessment_Id,
                        Alias = dbAA.Alias,
                        AssessmentName = dbAA.Assessment_.INFORMATION.Assessment_Name,
                        AssessmentDate = dbAA.Assessment_.Assessment_Date
                    };

                    l.Add(aa);

                    if (string.IsNullOrEmpty(aa.Alias))
                    {
                        aa.Alias = GetNextAvailableAlias(dbAaList.Select(x => x.Alias).ToList(), l.Select(x => x.Alias).ToList());
                        dbAA.Alias = aa.Alias;
                    }
                }

                // Make sure the aliases are persisted
                db.SaveChanges();

                resp.Assessments = l;

                IncludeStandards(ref resp);

                resp.Aggregation.QuestionsCompatibility = CalcCompatibility("Q", resp.Assessments.Select(x => x.AssessmentId).ToList());
                resp.Aggregation.RequirementsCompatibility = CalcCompatibility("R", resp.Assessments.Select(x => x.AssessmentId).ToList());


                return resp;
            }
        }


        /// <summary>
        /// Looks for the lowest letter that has not yet been used as an alias in 
        /// the database list and the list we are currently building.
        /// </summary>
        /// <returns></returns>
        private string GetNextAvailableAlias(List<string> a, List<string> b)
        {
            // assign default aliases
            // NOTE:  If they are comparing more than 26 assessments, this will have to be done a different way.
            var aliasLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

            foreach (char letterChar in aliasLetters.ToCharArray())
            {
                if (!a.Exists(aa => aa == letterChar.ToString())
                    && !b.Exists(bb => bb == letterChar.ToString()))
                {
                    return letterChar.ToString();
                }
            }

            return string.Empty;
        }


        /// <summary>
        /// Creates or deletes an AGGREGATION_ASSESSMENT bridge record.
        /// Returns the compatibility scores for the current set of assessments.
        /// </summary>
        /// <param name="aggregationId"></param>
        /// <param name="assessmentId"></param>
        /// <param name="selected"></param>
        public Aggregation SaveAssessmentSelection(int aggregationId, int assessmentId, bool selected)
        {
            using (var db = new CSET_Context())
            {
                var aa = db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationId && x.Assessment_Id == assessmentId).FirstOrDefault();

                if (selected)
                {
                    if (aa == null)
                    {
                        aa = new AGGREGATION_ASSESSMENT()
                        {
                            Aggregation_Id = aggregationId,
                            Assessment_Id = assessmentId,
                            Alias = ""
                        };
                        db.AGGREGATION_ASSESSMENT.Add(aa);
                        db.SaveChanges();
                    }
                }
                else
                {
                    if (aa != null)
                    {
                        db.AGGREGATION_ASSESSMENT.Remove(aa);
                        db.SaveChanges();
                    }
                }


                // Recalculate the compatibility scores and build the response
                var agg = db.AGGREGATION_INFORMATION.Where(x => x.AggregationID == aggregationId).FirstOrDefault();
                var assessmentIDs = db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationId).Select(x => x.Assessment_Id).ToList();

                var resp = new Aggregation()
                {
                    AggregationId = aggregationId,
                    AggregationName = agg.Aggregation_Name,
                    AggregationDate = agg.Aggregation_Date,
                    Mode = agg.Aggregation_Mode
                };

                resp.QuestionsCompatibility = CalcCompatibility("Q", assessmentIDs);
                resp.RequirementsCompatibility = CalcCompatibility("R", assessmentIDs);
                return resp;
            }
        }


        /// <summary>
        /// Saves the specified alias.  If an empty string is submitted,
        /// An alias is assigned to the record and the value is returned to the client.
        /// </summary>
        public string SaveAssessmentAlias(int aggregationId, int assessmentId, string alias, List<AssessmentSelection> assessList)
        {
            using (var db = new CSET_Context())
            {
                var aa = db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationId && x.Assessment_Id == assessmentId).FirstOrDefault();
                if (aa == null)
                {
                    return "";
                }

                if (alias == "")
                {
                    alias = GetNextAvailableAlias(assessList.Select(x => x.Alias).ToList(), new List<string>());
                }

                aa.Alias = alias;
                db.SaveChanges();

                return alias;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        public void IncludeStandards(ref AssessmentListResponse response)
        {
            // For each standard, list any assessments that use it.
            Dictionary<string, List<int>> selectedStandards = new Dictionary<string, List<int>>();
            DataTable dt = new DataTable();
            dt.Columns.Add("AssessmentName");
            dt.Columns.Add("AssessmentId", typeof(int));
            dt.Columns.Add("Alias");
            int startColumn = dt.Columns.Count;

            using (var db = new CSET_Context())
            {
                foreach (var a in response.Assessments)
                {
                    var info = db.INFORMATION.Where(x => x.Id == a.AssessmentId).FirstOrDefault();

                    DataRow rowAssess = dt.NewRow();
                    rowAssess["AssessmentId"] = info.Id;
                    rowAssess["AssessmentName"] = info.Assessment_Name;
                    rowAssess["Alias"] = a.Alias;
                    dt.Rows.Add(rowAssess);

                    List<AVAILABLE_STANDARDS> standards = db.AVAILABLE_STANDARDS
                        .Include(x => x.Set_NameNavigation)
                        .Where(x => x.Assessment_Id == a.AssessmentId && x.Selected).ToList();
                    foreach (var s in standards)
                    {
                        if (!dt.Columns.Contains(s.Set_NameNavigation.Short_Name))
                        {
                            dt.Columns.Add(s.Set_NameNavigation.Short_Name, typeof(bool));
                        }
                        rowAssess[s.Set_NameNavigation.Short_Name] = true;
                    }
                }

                // Build an alphabetical list of standards involved
                List<string> setNames = new List<string>();
                for (int i = startColumn; i < dt.Columns.Count; i++)
                {
                    setNames.Add(dt.Columns[i].ColumnName);
                }
                setNames.Sort();


                foreach (DataRow rowAssessment in dt.Rows)
                {
                    var assessment = response.Assessments.Where(x => x.AssessmentId == (int)rowAssessment["AssessmentId"]).FirstOrDefault();
                    if (assessment == null)
                    {
                        continue;
                    }

                    foreach (string setName in setNames)
                    {
                        var set = new SelectedStandards();
                        assessment.SelectedStandards.Add(new SelectedStandards()
                        {
                            StandardName = setName,
                            Selected = rowAssessment[setName] == DBNull.Value ? false : (bool)rowAssessment[setName]
                        });
                    }
                }
            }
        }


        /// <summary>
        /// Returns percent overlap.  
        /// Gets lists of question or requirement IDs, then uses LINQ to do the intersection.
        /// </summary>
        /// <param name="mode"></param>
        /// <returns></returns>
        private float CalcCompatibility(string mode, List<int> assessmentIds)
        {
            var l = new List<List<int>>();

            // master hash set of all questions
            var m = new HashSet<int>();

            using (var db = new CSET_Context())
            {
                foreach (int id in assessmentIds)
                {
                    if (mode == "Q")
                    {
                        var listQuestionID = (List<int>)db.InScopeQuestions(id);
                        l.Add(listQuestionID);
                        m.UnionWith(listQuestionID);
                    }

                    if (mode == "R")
                    {
                        var listRequirementID = (List<int>)db.InScopeRequirements(id);
                        l.Add(listRequirementID);
                        m.UnionWith(listRequirementID);
                    }
                }
            }

            if (l.Count == 0)
            {
                return 0f;
            }

            var intersection = l
                .Skip(1)
                .Aggregate(
                    new HashSet<int>(l.First()),
                    (h, e) => { h.IntersectWith(e); return h; }
                );

            if (m.Count == 0)
            {
                return 0f;
            }

            return ((float)intersection.Count / (float)m.Count);
        }


        /// <summary>
        /// Returns a list of questions or requirements that are answered "N"
        /// in every assessment in the comparison.  
        /// 
        /// Note that if the comparison has assessments in both
        /// Questions and Requirements mode, there will be no common "N" answers.
        /// </summary>
        /// <param name="aggregationId"></param>
        public List<MissedQuestion> GetCommonlyMissedQuestions(int aggregationId)
        {
            var resp = new List<MissedQuestion>();

            // build lists of question IDs, then use LINQ to do the intersection
            var questionsAnsweredNo = new List<List<int>>();
            var requirementsAnsweredNo = new List<List<int>>();

            using (var db = new CSET_Context())
            {
                var assessmentIds = db.AGGREGATION_ASSESSMENT
                    .Where(x => x.Aggregation_Id == aggregationId).ToList().Select(x => x.Assessment_Id);


                foreach (int assessmentId in assessmentIds)
                {
                    var answeredNo = db.Answer_Standards_InScope
                        .Where(x => x.assessment_id == assessmentId && x.answer_text == "N").ToList();

                    // get the assessments 'mode'
                    var assessmentMode = db.STANDARD_SELECTION
                        .Where(x => x.Assessment_Id == assessmentId)
                        .Select(x => x.Application_Mode).FirstOrDefault();

                    if (assessmentMode.StartsWith("Q"))
                    {
                        questionsAnsweredNo.Add(answeredNo.Where(x => x.mode == "Q")
                            .Select(x => x.question_or_requirement_id).ToList());
                        requirementsAnsweredNo.Add(new List<int>());
                    }

                    if (assessmentMode.StartsWith("R"))
                    {
                        questionsAnsweredNo.Add(new List<int>());
                        requirementsAnsweredNo.Add(answeredNo.Where(x => x.mode == "R")
                            .Select(x => x.question_or_requirement_id).ToList());
                    }
                }

                // Now that the lists are built, analyze for common "N" answers
                resp.AddRange(BuildQList(questionsAnsweredNo, db));
                resp.AddRange(BuildRList(requirementsAnsweredNo, db));
            }

            return resp;
        }


        /// <summary>
        /// Build a list of Questions with common "N" answers.
        /// </summary>
        /// <param name="answeredNo"></param>
        /// <param name="db"></param>
        /// <returns></returns>
        private List<MissedQuestion> BuildQList(List<List<int>> answeredNo, CSET_Context db)
        {
            var resp = new List<MissedQuestion>();

            if (answeredNo.Count == 0)
            {
                return resp;
            }

            var intersectionQ = answeredNo
            .Skip(1)
            .Aggregate(
                new HashSet<int>(answeredNo.First()),
                (h, e) => { h.IntersectWith(e); return h; }
            );

            var query1 = from nq in db.NEW_QUESTION
                         join usch in db.UNIVERSAL_SUB_CATEGORY_HEADINGS on nq.Heading_Pair_Id equals usch.Heading_Pair_Id
                         join qgh in db.QUESTION_GROUP_HEADING on usch.Question_Group_Heading_Id equals qgh.Question_Group_Heading_Id
                         join usc in db.UNIVERSAL_SUB_CATEGORIES on usch.Universal_Sub_Category_Id equals usc.Universal_Sub_Category_Id
                         where intersectionQ.Contains(nq.Question_Id)
                         orderby qgh.Question_Group_Heading1, usc.Universal_Sub_Category, nq.Simple_Question
                         select new { nq, qgh, usc };

            
            foreach (var q in query1.ToList())
            {
                resp.Add(new MissedQuestion()
                {
                    QuestionId = q.nq.Question_Id,
                    QuestionText = q.nq.Simple_Question,
                    Category = q.qgh.Question_Group_Heading1,
                    Subcategory = q.usc.Universal_Sub_Category
                });
            }

            return resp;
        }


        /// <summary>
        /// Build a list of Requirements with common "N" answers.
        /// </summary>
        /// <param name="answeredNo"></param>
        /// <param name="db"></param>
        /// <returns></returns>
        private List<MissedQuestion> BuildRList(List<List<int>> answeredNo, CSET_Context db)
        {
            var resp = new List<MissedQuestion>();

            if (answeredNo.Count == 0)
            {
                return resp;
            }
            var intersectionR = answeredNo
                .Skip(1)
                .Aggregate(
                    new HashSet<int>(answeredNo.First()),
                    (h, e) => { h.IntersectWith(e); return h; }
                );

            var query1 = from nr in db.NEW_REQUIREMENT
                         where intersectionR.Contains(nr.Requirement_Id)
                         orderby nr.Standard_Category, nr.Standard_Sub_Category, nr.Requirement_Text
                         select nr;

            foreach (var q in query1.ToList())
            {
                resp.Add(new MissedQuestion()
                {
                    QuestionId = q.Requirement_Id,
                    QuestionText = q.Requirement_Text,
                    Category = q.Standard_Category,
                    Subcategory = q.Standard_Sub_Category
                });
            }

            return resp;
        }


        /// <summary>
        /// 
        /// </summary>
        public MergeStructure GetAnswers(List<int> mergeCandidates)
        {
            if (mergeCandidates.Count == 0)
            {
                return null;
            }


            MergeStructure mergeResponse = new MergeStructure
            {
                MergeID = Guid.NewGuid()
            };

            Dictionary<int, MergeQuestion> QuestionDictionary = new Dictionary<int, MergeQuestion>();

            using (var db = new CSET_Context())
            {
                // this is probably unnecessary because we just barely created the new merge ID
                var previousCombinedAnswers = db.COMBINED_ANSWER.Where(x => x.Merge_ID == mergeResponse.MergeID).ToList();
                db.COMBINED_ANSWER.RemoveRange(previousCombinedAnswers);
                db.SaveChanges();


                for (int i = 0; i < mergeCandidates.Count; i++)
                {
                    int assessmentID = mergeCandidates[i];

                    var myAnswers = RelevantAnswers.GetAnswersForAssessment(assessmentID);
                    foreach (var a in myAnswers)
                    {
                        MergeQuestion mq = null;

                        if (QuestionDictionary.ContainsKey(a.Question_Or_Requirement_ID))
                        {
                            mq = QuestionDictionary[a.Question_Or_Requirement_ID];
                        }
                        else
                        {
                            var query1 = from nq in db.NEW_QUESTION
                                         join usch in db.UNIVERSAL_SUB_CATEGORY_HEADINGS on nq.Heading_Pair_Id equals usch.Heading_Pair_Id
                                         join qgh in db.QUESTION_GROUP_HEADING on usch.Question_Group_Heading_Id equals qgh.Question_Group_Heading_Id
                                         where nq.Question_Id == a.Question_Or_Requirement_ID
                                         select new { nq, qgh };

                            var q = query1.FirstOrDefault();
                            if (q == null)
                            {
                                continue;
                            }

                            mq = new MergeQuestion(mergeCandidates.Count);
                            mq.CategoryID = (int)q.qgh.Question_Group_Heading_Id;
                            mq.CategoryText = q.qgh.Question_Group_Heading1;
                            mq.QuestionID = q.nq.Question_Id;
                            mq.QuestionText = q.nq.Simple_Question;
                        }


                        mq.Is_Component = a.Is_Component;

                        var sourceAnswer = mq.SourceAnswers[i];
                        sourceAnswer.SourceAnswerID = a.Answer_ID;
                        sourceAnswer.AnswerText = a.Answer_Text == "U" ? "" : a.Answer_Text;
                        sourceAnswer.AlternateJustification = a.Alternate_Justification;
                        sourceAnswer.Comment = a.Comment;

                        QuestionDictionary[a.Question_Or_Requirement_ID] = mq;



                        // at this point we should probably build the COMBINED_ANSWER record, but only
                        // if one has not been built for this answer.
                        var ca = db.COMBINED_ANSWER.Where(x => x.Merge_ID == mergeResponse.MergeID && x.Question_Or_Requirement_Id == a.Question_Or_Requirement_ID).FirstOrDefault();
                        if (ca == null && a.Answer_Text != "U" && a.Answer_Text != "")
                        {
                            ca = new COMBINED_ANSWER()
                            {
                                Merge_ID = mergeResponse.MergeID,
                                Mark_For_Review = a.Mark_For_Review,
                                Comment = a.Comment,
                                Alternate_Justification = a.Alternate_Justification,
                                Question_Or_Requirement_Id = a.Question_Or_Requirement_ID,
                                Custom_Question_Guid = a.Custom_Question_Guid,
                                Answer_Text = a.Answer_Text,
                                Component_Guid = a.Component_Guid,
                                Is_Component = a.Is_Component
                                // Is_Resolved 
                                // Type_Question
                            };

                            db.COMBINED_ANSWER.Add(ca);
                            db.SaveChanges();

                            mq.CombinedAnswerID = ca.AnswerID;
                        }
                    }
                }


                // sort the questions into their appropriate lists/categories
                foreach (MergeQuestion q in QuestionDictionary.Values)
                {
                    SetDefaultAnswer(q);

                    if (!q.Is_Component)
                    {
                        AddQuestionToStructure(mergeResponse, mergeResponse.QuestionsCategories, q);
                    }
                    else
                    {
                        if (q.SourceAnswers.Exists(x => x.ComponentGuid != Guid.Empty.ToString()))
                        {
                            AddQuestionToStructure(mergeResponse, mergeResponse.ComponentOverrideCategories, q);
                        }
                        else
                        {
                            AddQuestionToStructure(mergeResponse, mergeResponse.ComponentDefaultCategories, q);
                        }
                    }
                }

                mergeResponse.QuestionsCategories = mergeResponse.QuestionsCategories.OrderBy(x => x.Category).ToList();
                mergeResponse.ComponentDefaultCategories = mergeResponse.ComponentDefaultCategories.OrderBy(x => x.Category).ToList();
                mergeResponse.ComponentOverrideCategories = mergeResponse.ComponentOverrideCategories.OrderBy(x => x.Category).ToList();
            }

            // remove any empty categories
            mergeResponse.QuestionsCategories.RemoveAll(x => x.Questions.Count() == 0);
            mergeResponse.ComponentDefaultCategories.RemoveAll(x => x.Questions.Count() == 0);
            mergeResponse.ComponentOverrideCategories.RemoveAll(x => x.Questions.Count() == 0);

            return mergeResponse;
        }


        /// <summary>
        /// Determines a default answer based on the source answers, the leftmost assessment with an actual answer.
        /// </summary>
        /// <param name="q"></param>
        private void SetDefaultAnswer(MergeQuestion q)
        {
            foreach (var ans in q.SourceAnswers)
            {
                if (ans.AnswerText != "" && ans.AnswerText != "U")
                {
                    q.DefaultAnswer = ans.AnswerText;
                    return;
                }
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="categoryGroup"></param>
        /// <param name="q"></param>
        private void AddQuestionToStructure(MergeStructure enchilada, List<MergeCategory> categoryGroup, MergeQuestion q)
        {
            // if the answers agree, don't include it
            if (q.SourceAnswers.Select(x => x.AnswerText).Distinct().Count() == 1)
            {
                return;
            }

            MergeCategory cat = categoryGroup.Where(x => x.Category == q.CategoryText).FirstOrDefault();
            if (cat == null)
            {
                cat = new MergeCategory();
                cat.Category = q.CategoryText;
                categoryGroup.Add(cat);
            }

            cat.Questions.Add(q);
            cat.Questions = cat.Questions.OrderBy(x => x.QuestionText).ToList();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="answerId"></param>
        /// <param name="answerText"></param>
        public void SetMergeAnswer(int combinedAnswerId, string answerText)
        {
            using (var db = new CSET_Context())
            {
                var ca = db.COMBINED_ANSWER.Where(x => x.AnswerID == combinedAnswerId).FirstOrDefault();
                if (ca != null)
                {
                    ca.Answer_Text = answerText;
                    db.SaveChanges();
                }
            }
        }
    }
}
