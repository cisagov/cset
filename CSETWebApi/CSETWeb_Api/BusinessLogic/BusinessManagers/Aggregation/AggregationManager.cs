using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataLayerCore.Model;
using DataLayerCore.Manual;
using Snickler.EFCore;
using BusinessLogic.Helpers;
using BusinessLogic.Models;
using Microsoft.EntityFrameworkCore;

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
                var q1 = from ac in db.ASSESSMENT_CONTACTS
                         join aa in db.AGGREGATION_ASSESSMENT on ac.Assessment_Id equals aa.Assessment_Id
                         join ai in db.AGGREGATION_INFORMATION on aa.Aggregation_Id equals ai.AggregationID
                         where ai.Aggregation_Mode == mode && ac.UserId == currentUserId
                         select new { ai, aa, ac };

                var aggCandidates = q1.ToList();

                List<int> myAllowedAggregIDs = new List<int>();

                foreach (var agg in aggCandidates)
                {
                    var assessmentIDs = db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == agg.ai.AggregationID).Select(x => x.Assessment_Id).ToList();

                    // Hopefully this can be refactored.  We need to make sure that the current user is connected to all assessments in this aggregation.
                    if (db.ASSESSMENT_CONTACTS.Where(x => assessmentIDs.Contains(x.Assessment_Id) && x.UserId == currentUserId).Count() < assessmentIDs.Count)
                    {
                        continue;
                    }

                    if (myAllowedAggregIDs.Contains(agg.ai.AggregationID))
                    {
                        continue;
                    }

                    l.Add(new Aggregation()
                    {
                        AggregationId = agg.ai.AggregationID,
                        AggregationName = agg.ai.Aggregation_Name,
                        AggregationDate = agg.ai.Aggregation_Date
                    });

                    myAllowedAggregIDs.Add(agg.ai.AggregationID);
                }
            }

            return l.OrderBy(x => x.AggregationDate).ToList();
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


            MergeStructure mergeResponse = new MergeStructure();
            mergeResponse.MergeID = Guid.NewGuid();

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
