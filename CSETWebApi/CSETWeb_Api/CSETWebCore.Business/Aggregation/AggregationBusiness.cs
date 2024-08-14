//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Aggregation;
using CSETWebCore.Model.Aggregation;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.Business.Aggregation
{
    public class AggregationBusiness : IAggregationBusiness
    {
        private readonly CSETContext _context;

        public AggregationBusiness(CSETContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Returns a list of AGGREGATION_INFORMATION records for the specified type, Trend or Compare.
        /// Returns only AGGREGATION_INFORMATION records where the current user is authorized
        /// to view all Assessments involved in the aggregation.
        /// </summary>
        /// <returns></returns>
        public List<CSETWebCore.Model.Aggregation.Aggregation> GetAggregations(string mode, int currentUserId)
        {
            var l = new List<CSETWebCore.Model.Aggregation.Aggregation>();

            // Find all aggregations of the desired type that the current user has access to one or more of its assessments
            var q1 = from ai in _context.AGGREGATION_INFORMATION
                     where ai.Aggregation_Mode == mode
                     select ai;

            var aggCandidates = q1.ToList();

            List<int> myAllowedAggregIDs = new List<int>();

            foreach (var agg in aggCandidates)
            {
                var assessmentIDs = _context.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == agg.AggregationID).Select(x => x.Assessment_Id).ToList();

                // Hopefully this can be refactored.  We need to make sure that the current user is connected to all assessments in this aggregation.
                if (_context.ASSESSMENT_CONTACTS.Where(x => assessmentIDs.Contains(x.Assessment_Id) && x.UserId == currentUserId).Count() < assessmentIDs.Count)
                {
                    continue;
                }

                if (myAllowedAggregIDs.Contains(agg.AggregationID))
                {
                    continue;
                }

                l.Add(new CSETWebCore.Model.Aggregation.Aggregation()
                {
                    AggregationId = agg.AggregationID,
                    AggregationName = agg.Aggregation_Name,
                    AggregationDate = agg.Aggregation_Date
                });

                myAllowedAggregIDs.Add(agg.AggregationID);
            }

            return l.OrderBy(x => x.AggregationDate).ToList();
        }


        /// <summary>
        /// Creates a new Aggregation (Trend or Comparison).
        /// </summary>
        public CSETWebCore.Model.Aggregation.Aggregation CreateAggregation(string mode)
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

            CSETWebCore.Model.Aggregation.Aggregation newAgg = new CSETWebCore.Model.Aggregation.Aggregation()
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
        public CSETWebCore.Model.Aggregation.Aggregation GetAggregation(int aggregationId)
        {

            // Find all aggregations of the desired type that the current user has access to one or more of its assessments
            var agg = _context.AGGREGATION_INFORMATION.Where(x => x.AggregationID == aggregationId).FirstOrDefault();
            if (agg == null)
            {
                return null;
            }

            return new CSETWebCore.Model.Aggregation.Aggregation()
            {
                AggregationDate = agg.Aggregation_Date,
                AggregationId = agg.AggregationID,
                AggregationName = agg.Aggregation_Name,
                Mode = agg.Aggregation_Mode,
                AssessorName = agg.Assessor_Name
            };
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public int SaveAggregationInformation(int aggregationId, CSETWebCore.Model.Aggregation.Aggregation aggreg)
        {

            var agg = _context.AGGREGATION_INFORMATION.Where(x => x.AggregationID == aggregationId).FirstOrDefault();

            if (agg == null)
            {
                agg = new AGGREGATION_INFORMATION()
                {
                    Aggregation_Name = aggreg.AggregationName,
                    Aggregation_Date = DateTime.Today,
                    Aggregation_Mode = aggreg.Mode
                };

                _context.AGGREGATION_INFORMATION.Add(agg);
                _context.SaveChanges();
                aggregationId = agg.AggregationID;
            }

            agg.AggregationID = aggregationId;
            agg.Aggregation_Name = aggreg.AggregationName;
            agg.Aggregation_Date = aggreg.AggregationDate;

            _context.AGGREGATION_INFORMATION.Update(agg);
            _context.SaveChanges();

            return aggregationId;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="aggregationId"></param>
        public void DeleteAggregation(int aggregationId)
        {
            _context.AGGREGATION_ASSESSMENT.RemoveRange(
                 _context.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationId)
                 );

            _context.AGGREGATION_INFORMATION.RemoveRange(
                _context.AGGREGATION_INFORMATION.Where(x => x.AggregationID == aggregationId)
                );

            _context.SaveChanges();
        }


        /// <summary>
        /// Returns a list of assessments for the specified aggregation.
        /// The list is in ascending order of assessment date.
        /// </summary>
        /// <param name="aggregationId"></param>
        public AssessmentListResponse GetAssessmentsForAggregation(int aggregationId)
        {

            var ai = _context.AGGREGATION_INFORMATION.Where(x => x.AggregationID == aggregationId).FirstOrDefault();
            var resp = new AssessmentListResponse
            {
                Aggregation = new CSETWebCore.Model.Aggregation.Aggregation()
                {
                    AggregationId = ai.AggregationID,
                    AggregationName = ai.Aggregation_Name,
                    AggregationDate = ai.Aggregation_Date
                }
            };


            var dbAaList = _context.AGGREGATION_ASSESSMENT
                .Where(x => x.Aggregation_Id == aggregationId)
                .Include(x => x.Assessment)
                .ThenInclude(x => x.INFORMATION)
                .OrderBy(x => x.Assessment.Assessment_Date)
                .ToList();

            var l = new List<AggregAssessment>();

            foreach (var dbAA in dbAaList)
            {
                var aa = new AggregAssessment()
                {
                    AssessmentId = dbAA.Assessment_Id,
                    Alias = dbAA.Alias,
                    AssessmentName = dbAA.Assessment.INFORMATION.Assessment_Name,
                    AssessmentDate = dbAA.Assessment.Assessment_Date,
                    useMaturity = dbAA.Assessment.UseMaturity,
                    useStandard = dbAA.Assessment.UseStandard
                };

                l.Add(aa);

                if (string.IsNullOrEmpty(aa.Alias))
                {
                    aa.Alias = GetNextAvailableAlias(dbAaList.Select(x => x.Alias).ToList(), l.Select(x => x.Alias).ToList());
                    dbAA.Alias = aa.Alias;
                }
            }

            // Make sure the aliases are persisted
            _context.SaveChanges();

            resp.Assessments = l;

            IncludeStandards(ref resp);

            resp.Aggregation.QuestionsCompatibility = CalcCompatibility("Q", resp.Assessments.Select(x => x.AssessmentId).ToList());
            resp.Aggregation.RequirementsCompatibility = CalcCompatibility("R", resp.Assessments.Select(x => x.AssessmentId).ToList());


            return resp;
        }


        /// <summary>
        /// Looks for the lowest letter that has not yet been used as an alias in 
        /// the database list and the list we are currently building.
        /// </summary>
        /// <returns></returns>
        public string GetNextAvailableAlias(List<string> a, List<string> b)
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
        public CSETWebCore.Model.Aggregation.Aggregation SaveAssessmentSelection(int aggregationId, int assessmentId, bool selected)
        {

            var aa = _context.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationId && x.Assessment_Id == assessmentId).FirstOrDefault();

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
                    _context.AGGREGATION_ASSESSMENT.Add(aa);
                    _context.SaveChanges();
                }
            }
            else
            {
                if (aa != null)
                {
                    _context.AGGREGATION_ASSESSMENT.Remove(aa);
                    _context.SaveChanges();
                }
            }


            // Recalculate the compatibility scores and build the response
            var agg = _context.AGGREGATION_INFORMATION.Where(x => x.AggregationID == aggregationId).FirstOrDefault();
            var assessmentIDs = _context.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationId).Select(x => x.Assessment_Id).ToList();

            var resp = new CSETWebCore.Model.Aggregation.Aggregation()
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


        /// <summary>
        /// Saves the specified alias.  If an empty string is submitted,
        /// An alias is assigned to the record and the value is returned to the client.
        /// </summary>
        public string SaveAssessmentAlias(int aggregationId, int assessmentId, string alias, List<AssessmentSelection> assessList)
        {

            var aa = _context.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationId && x.Assessment_Id == assessmentId).FirstOrDefault();
            if (aa == null)
            {
                return "";
            }

            if (alias == "")
            {
                alias = GetNextAvailableAlias(assessList.Select(x => x.Alias).ToList(), new List<string>());
            }

            aa.Alias = alias;
            _context.SaveChanges();

            return alias;
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

            foreach (var a in response.Assessments)
            {
                var info = _context.INFORMATION.Where(x => x.Id == a.AssessmentId).FirstOrDefault();

                DataRow rowAssess = dt.NewRow();
                rowAssess["AssessmentId"] = info.Id;
                rowAssess["AssessmentName"] = info.Assessment_Name;
                rowAssess["Alias"] = a.Alias;
                dt.Rows.Add(rowAssess);

                List<AVAILABLE_STANDARDS> standards = _context.AVAILABLE_STANDARDS
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


        /// <summary>
        /// Returns percent overlap.  
        /// Gets lists of question or requirement IDs, then uses LINQ to do the intersection.
        /// </summary>
        /// <param name="mode"></param>
        /// <returns></returns>
        public float CalcCompatibility(string mode, List<int> assessmentIds)
        {
            var l = new List<List<int>>();

            // master hash set of all questions
            var m = new HashSet<int>();

            foreach (int id in assessmentIds)
            {
                if (mode == "Q")
                {
                    var listQuestionID = (List<int>)_context.InScopeQuestions(id);
                    l.Add(listQuestionID);
                    m.UnionWith(listQuestionID);
                }

                if (mode == "R")
                {
                    var listRequirementID = (List<int>)_context.InScopeRequirements(id);
                    l.Add(listRequirementID);
                    m.UnionWith(listRequirementID);
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
        /// Returns a list of questions or requirements that are answered "N" for no
        /// or "U" for unanswered in every assessment in the comparison.  
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

            var assessmentIds = _context.AGGREGATION_ASSESSMENT
                .Where(x => x.Aggregation_Id == aggregationId).ToList().Select(x => x.Assessment_Id);


            foreach (int assessmentId in assessmentIds)
            {
                var isNoOrUnanswered = _context.Answer_Standards_InScope
                    .Where(x => x.assessment_id == assessmentId && (x.answer_text == "N" || x.answer_text == "U")).ToList();

                // get the assessments 'mode'
                var assessmentMode = _context.STANDARD_SELECTION
                    .Where(x => x.Assessment_Id == assessmentId)
                    .Select(x => x.Application_Mode).FirstOrDefault();

                if (assessmentMode.StartsWith("Q"))
                {
                    questionsAnsweredNo.Add(isNoOrUnanswered.Where(x => x.mode == "Q")
                        .Select(x => x.question_or_requirement_id).ToList());
                    requirementsAnsweredNo.Add(new List<int>());
                }

                if (assessmentMode.StartsWith("R"))
                {
                    questionsAnsweredNo.Add(new List<int>());
                    requirementsAnsweredNo.Add(isNoOrUnanswered.Where(x => x.mode == "R")
                        .Select(x => x.question_or_requirement_id).ToList());
                }
            }

            // Now that the lists are built, analyze for common "N" answers
            resp.AddRange(BuildQList(questionsAnsweredNo));
            resp.AddRange(BuildRList(requirementsAnsweredNo));

            return resp;
        }


        /// <summary>
        /// Returns a list of questions or requirements that are answered "N" for no
        /// or "U" for unanswered in every assessment in the comparison.  
        /// 
        /// Note that if the comparison has assessments in both
        /// Questions and Requirements mode, there will be no common "N" answers.
        /// </summary>
        /// <param name="aggregationId"></param>
        public List<MissedQuestion> GetCommonlyMissedMaturityQuestions(int aggregationId)
        {
            var resp = new List<MissedQuestion>();

            // build lists of question IDs, then use LINQ to do the intersection
            var questionsAnsweredNo = new List<List<int>>();
            var requirementsAnsweredNo = new List<List<int>>();

            var assessmentIds = _context.AGGREGATION_ASSESSMENT
                .Where(x => x.Aggregation_Id == aggregationId).ToList().Select(x => x.Assessment_Id);


            foreach (int assessmentId in assessmentIds)
            {
                var isNoOrUnanswered = _context.Answer_Maturity
                    .Where(x => x.Assessment_Id == assessmentId && (x.Answer_Text == "N" || x.Answer_Text == "U")).ToList();

                questionsAnsweredNo.Add(isNoOrUnanswered
                    .Select(x => x.Question_Or_Requirement_Id).ToList());
                requirementsAnsweredNo.Add(isNoOrUnanswered
                    .Select(x => x.Question_Or_Requirement_Id).ToList());

            }

            // Now that the lists are built, analyze for common "N" answers
            resp.AddRange(BuildQList(questionsAnsweredNo));
            resp.AddRange(BuildRList(requirementsAnsweredNo));

            return resp;
        }


        /// <summary>
        /// Build a list of Questions with common "N" answers.
        /// </summary>
        /// <param name="isNoOrUnanswered"></param>
        /// <param name="db"></param>
        /// <returns></returns>
        public List<MissedQuestion> BuildQList(List<List<int>> isNoOrUnanswered)
        {
            var resp = new List<MissedQuestion>();

            if (isNoOrUnanswered.Count == 0)
            {
                return resp;
            }

            var intersectionQ = isNoOrUnanswered
            .Skip(1)
            .Aggregate(
                new HashSet<int>(isNoOrUnanswered.First()),
                (h, e) => { h.IntersectWith(e); return h; }
            );

            var query1 = from nq in _context.NEW_QUESTION
                         join usch in _context.UNIVERSAL_SUB_CATEGORY_HEADINGS on nq.Heading_Pair_Id equals usch.Heading_Pair_Id
                         join qgh in _context.QUESTION_GROUP_HEADING on usch.Question_Group_Heading_Id equals qgh.Question_Group_Heading_Id
                         join usc in _context.UNIVERSAL_SUB_CATEGORIES on usch.Universal_Sub_Category_Id equals usc.Universal_Sub_Category_Id
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
        /// <param name="isNoOrUnanswered"></param>
        /// <param name="db"></param>
        /// <returns></returns>
        public List<MissedQuestion> BuildRList(List<List<int>> isNoOrUnanswered)
        {
            var resp = new List<MissedQuestion>();

            if (isNoOrUnanswered.Count == 0)
            {
                return resp;
            }
            var intersectionR = isNoOrUnanswered
                .Skip(1)
                .Aggregate(
                    new HashSet<int>(isNoOrUnanswered.First()),
                    (h, e) => { h.IntersectWith(e); return h; }
                );

            var query1 = from nr in _context.NEW_REQUIREMENT
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
    }
}