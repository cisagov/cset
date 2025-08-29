//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Aggregation;
using CSETWebCore.Business.Maturity;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Question;
using CsvHelper.Configuration.Attributes;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;

namespace CSETWebCore.Business.Question
{
    /// <summary>
    /// Calculates the number of questions completed
    /// based on the assessment characteristics.
    /// 
    /// Designed to replace a call to usp_Assessments_Completion_For_User
    /// </summary>
    public class CompletionCounter
    {
        private readonly CSETContext _context;


        /// <summary>
        /// 
        /// </summary>
        public CompletionCounter(CSETContext context)
        {
            _context = context;
        }


        /// <summary>
        /// Returns a collection of completion counts for each assessment that the user
        /// is associated with.
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<CompletionCounts> GetAssessmentsCompletionForUser(int userId)
        {
            var response = new List<CompletionCounts>();

            var q = from ac in _context.ASSESSMENT_CONTACTS
                    join a in _context.ASSESSMENTS on ac.Assessment_Id equals a.Assessment_Id
                    where ac.UserId == userId
                    select a;

            var myAssessments = q.ToList();

            return FillInMissingCounts(myAssessments, q);
        }


        /// <summary>
        /// Returns a collection of completion counts for each assessment that the access key
        /// is associated with.
        /// </summary>
        /// <returns></returns>
        public List<CompletionCounts> GetAssessmentsCompletionForAccessKey(string accessKey)
        {
            var response = new List<CompletionCounts>();

            var q = from aka in _context.ACCESS_KEY_ASSESSMENT
                    join a in _context.ASSESSMENTS on aka.Assessment_Id equals a.Assessment_Id
                    where aka.AccessKey == accessKey
                    select a;

            var myAssessments = q.ToList();

            return FillInMissingCounts(myAssessments, q);
        }


        /// <summary>
        /// When "My Assessments" is requested, this makes sure that the assessments 
        /// in the list all have values in the count fields.  If there are any
        /// that are still null, this will quickly calculate them so that the user
        /// gets counts for all of their assessments.
        /// </summary>
        /// <param name="list"></param>
        /// <returns></returns>
        private List<CompletionCounts> FillInMissingCounts(List<ASSESSMENTS> list, IQueryable<ASSESSMENTS> q)
        {
            var response = new List<CompletionCounts>();

            // populate any missing counts
            foreach (var a in list)
            {
                if (a.CompletedQuestionCount == null || a.TotalQuestionCount == null)
                {
                    new CompletionCounter(_context).CountMaturityCompletion(a.Assessment_Id);
                }
            }


            // re-fetch the list and build the response
            list = q.ToList();

            foreach (var a in list)
            {
                var entry = new CompletionCounts()
                {
                    AssessmentId = a.Assessment_Id,
                    TotalMaturityQuestionsCount = a.TotalQuestionCount,
                    CompletedCount = a.CompletedQuestionCount
                };

                response.Add(entry);
            }

            return response;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        public void CountStandardsBasedCompletion(int assessmentId)
        {
            var mode = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault()?.Application_Mode;

            if (mode == "Questions Based")
            {
                CountSimpleQuestionCompletion(assessmentId);
            }

            if (mode == "Requirements Based")
            {
                CountRequirementCompletion(assessmentId);
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        public void CountRequirementCompletion(int assessmentId)
        {
            var setNames = _context.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId).Select(y => y.Set_Name).ToList();
            string selectedSalLevel = _context.STANDARD_SELECTION.Where(ss => ss.Assessment_Id == assessmentId).Select(c => c.Selected_Sal_Level).FirstOrDefault();

            var q = from rs in _context.REQUIREMENT_SETS
                    from r in _context.NEW_REQUIREMENT.Where(x => x.Requirement_Id == rs.Requirement_Id)
                    from rl in _context.REQUIREMENT_LEVELS.Where(x => x.Requirement_Id == r.Requirement_Id)
                    from usl in _context.UNIVERSAL_SAL_LEVEL.Where(x => x.Full_Name_Sal == selectedSalLevel)
                    where setNames.Contains(rs.Set_Name)
                          && rl.Standard_Level == usl.Universal_Sal_Level1
                    select r.Requirement_Id;

            var inScopeRequirementIds = q.ToList();

            var inScopeAnswers = _context.ANSWER.Where(x => x.Question_Type == "Requirement" && inScopeRequirementIds.Contains(x.Question_Or_Requirement_Id)).ToList();

            var totalCount = inScopeRequirementIds.Count();
            var completedCount = inScopeAnswers.Where(ans => ans.Answer_Text != "U" && ans.Answer_Text != "").Count();

            var assessment = _context.ASSESSMENTS.FirstOrDefault(x => x.Assessment_Id == assessmentId);
            if (assessment == null)
            {
                return;
            }

            assessment.CompletedQuestionCount = completedCount;
            assessment.TotalQuestionCount = totalCount;
            _context.SaveChanges();
        }


        /// <summary>
        /// Counts and persists question completion totals for a standards-based assessment in questions mode.
        /// </summary>
        /// <param name="assessmentId"></param>
        public void CountSimpleQuestionCompletion(int assessmentId)
        {
            var setNames = _context.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId).Select(y => y.Set_Name).ToList();
            string selectedSalLevel = _context.STANDARD_SELECTION.Where(ss => ss.Assessment_Id == assessmentId).Select(c => c.Selected_Sal_Level).FirstOrDefault();


            if (setNames.Count == 1)
            {
                // Single standard
                var query1 = from q in _context.NEW_QUESTION
                             from qs in _context.NEW_QUESTION_SETS.Where(x => x.Question_Id == q.Question_Id)
                             from l in _context.NEW_QUESTION_LEVELS.Where(x => qs.New_Question_Set_Id == x.New_Question_Set_Id)
                             from s in _context.SETS.Where(x => x.Set_Name == qs.Set_Name)
                             from usl in _context.UNIVERSAL_SAL_LEVEL.Where(x => x.Full_Name_Sal == selectedSalLevel)
                             where setNames.Contains(s.Set_Name)
                                && l.Universal_Sal_Level == usl.Universal_Sal_Level1
                             select q.Question_Id;

                var inScopeQuestionIds = query1.ToList();

                var inScopeAnswers = _context.ANSWER.Where(x => x.Question_Type == "Question" && inScopeQuestionIds.Contains(x.Question_Or_Requirement_Id)).ToList();

                var totalCount = inScopeQuestionIds.Count();
                var completedCount = inScopeAnswers.Where(ans => ans.Answer_Text != "U" && ans.Answer_Text != "").Count();

                var assessment = _context.ASSESSMENTS.FirstOrDefault(x => x.Assessment_Id == assessmentId);
                if (assessment == null)
                {
                    return;
                }

                assessment.CompletedQuestionCount = completedCount;
                assessment.TotalQuestionCount = totalCount;
                _context.SaveChanges();
            }
            else
            {
                // multi standard
                var query2 = from q in _context.NEW_QUESTION
                             join qs in _context.NEW_QUESTION_SETS on q.Question_Id equals qs.Question_Id
                             join nql in _context.NEW_QUESTION_LEVELS on qs.New_Question_Set_Id equals nql.New_Question_Set_Id
                             join usch in _context.UNIVERSAL_SUB_CATEGORY_HEADINGS on q.Heading_Pair_Id equals usch.Heading_Pair_Id
                             join stand in _context.AVAILABLE_STANDARDS on qs.Set_Name equals stand.Set_Name
                             join qgh in _context.QUESTION_GROUP_HEADING on usch.Question_Group_Heading_Id equals qgh.Question_Group_Heading_Id
                             join usc in _context.UNIVERSAL_SUB_CATEGORIES on usch.Universal_Sub_Category_Id equals usc.Universal_Sub_Category_Id
                             join usl in _context.UNIVERSAL_SAL_LEVEL on selectedSalLevel equals usl.Full_Name_Sal
                             where stand.Selected == true
                                             && stand.Assessment_Id == assessmentId
                                             && nql.Universal_Sal_Level == usl.Universal_Sal_Level1
                             select q.Question_Id;

                //return query2.Distinct().Count();

                var sssssssss = 1;
            }
        }


        #region Maturity Questions

        /// <summary>
        /// Counts the number of in-scope question/answers and stores
        /// the number that have a value as well as the total.  
        /// </summary>
        public void CountMaturityCompletion(int assessmentId)
        {
            List<int> inScopeModels = DetermineInScopeModels(assessmentId).ToList();

            var q =
            from mq in _context.MATURITY_QUESTIONS
            join ans in _context.ANSWER on mq.Mat_Question_Id equals ans.Question_Or_Requirement_Id
            where ans.Assessment_Id == assessmentId
                && inScopeModels.Contains(mq.Maturity_Model_Id)
                && ans.Question_Type.ToLower() == "maturity"
                && mq.Is_Answerable
            select new AnswerBasic()
            {
                AnswerText = ans.Answer_Text,
                MatQuestionId = mq.Mat_Question_Id
            };

            var inScopeAnswers = q.ToList();


            // CRE+ has special conditions for OD and MIL to apply
            if (inScopeModels.Contains(Constants.Constants.Model_CRE))
            {
                inScopeAnswers = FilterCrePlus(assessmentId, inScopeAnswers);
            }


            // Filter out questions above the target level, if selectable
            inScopeAnswers = FilterByMaturityLevel(assessmentId, inScopeModels, inScopeAnswers);


            var totalCount = inScopeAnswers.Count();
            var completedCount = inScopeAnswers.Where(ans => ans.AnswerText != "U" && ans.AnswerText != "").Count();

            var assessment = _context.ASSESSMENTS.FirstOrDefault(x => x.Assessment_Id == assessmentId);
            if (assessment == null)
            {
                return;
            }

            assessment.CompletedQuestionCount = completedCount;
            assessment.TotalQuestionCount = totalCount;
            _context.SaveChanges();
        }


        /// <summary>
        /// Based on the assessment's current state, returns a list of
        /// all maturity model IDs that are currently applicable/in scope.
        /// </summary>
        private HashSet<int> DetermineInScopeModels(int assessmentId)
        {
            HashSet<int> response = [];

            // determine the assessment type 
            var q = from amm in _context.AVAILABLE_MATURITY_MODELS
                    join mm in _context.MATURITY_MODELS on amm.model_id equals mm.Maturity_Model_Id
                    join a in _context.ASSESSMENTS on amm.Assessment_Id equals a.Assessment_Id
                    where a.Assessment_Id == assessmentId
                            && a.UseMaturity == true
                    select mm.Maturity_Model_Id;

            var ammm = q.ToList();


            // special case:  CPG - account for SSGs
            if (ammm.Contains(Constants.Constants.Model_CPG))
            {
                response.UnionWith(InScopeModelsCpg(assessmentId, Constants.Constants.Model_CPG));
            }


            // special case:  CPG2 - account for SSGs
            if (ammm.Contains(Constants.Constants.Model_CPG2))
            {
                response.UnionWith(InScopeModelsCpg(assessmentId, Constants.Constants.Model_CPG2));
            }


            // special case:  CRE+ - account for selected OD and MIL
            if (ammm.Contains(Constants.Constants.Model_CRE))
            {
                response.UnionWith(InScopeModelsCrePlus(assessmentId, Constants.Constants.Model_CRE));
            }


            // default maturity
            if (response.Count == 0)
            {
                response.UnionWith(ammm);
            }

            return response;
        }


        /// <summary>
        /// This returns all of the potential model IDs because the CRE questions 
        /// will be filtered later using GROUPING_SELECTION so there's no need
        /// to spend any time here.
        /// </summary>
        private HashSet<int> InScopeModelsCrePlus(int assessmentId, int modelId)
        {
            HashSet<int> response = [Constants.Constants.Model_CRE, Constants.Constants.Model_CRE_OD, Constants.Constants.Model_CRE_MIL];
            return response;
        }


        /// <summary>
        /// Filters out non-applicable questions based on GROUPING_SELECTION.
        /// </summary>
        private List<AnswerBasic> FilterCrePlus(int assessmentId, List<AnswerBasic> list)
        {
            // get all of the CRE+ (21) questions - keep them
            var creQIds = _context.MATURITY_QUESTIONS.Where(x => x.Maturity_Model_Id == Constants.Constants.Model_CRE).Select(x => x.Mat_Question_Id).ToList();


            // for OD and MIL, look at grouping selections to determine which groupings are in scope
            var q = from gs in _context.GROUPING_SELECTION
                    join mg in _context.MATURITY_GROUPINGS on gs.Grouping_Id equals mg.Grouping_Id
                    join mq in _context.MATURITY_QUESTIONS on mg.Grouping_Id equals mq.Grouping_Id
                    where gs.Assessment_Id == assessmentId
                    select mq;

            var activeQuestionIds = q.Select(x => x.Mat_Question_Id).Distinct().ToList();

            // any questions that are not in either the CRE list or the selected OD and MIL lists is gone
            list.RemoveAll(x => !creQIds.Contains(x.MatQuestionId) && !activeQuestionIds.Contains(x.MatQuestionId));

            return list;
        }


        /// <summary>
        /// Includes applicable SSG model(s).
        /// 
        /// Note that if we start supporting multiple SSGs on an assessment
        /// this will need to evolve to handle multiples.
        /// </summary>
        private HashSet<int> InScopeModelsCpg(int assessmentId, int modelId)
        {
            HashSet<int> response = [];

            response.Add(modelId);

            // See if any SSG models apply ....
            var ssgModelId = new CpgBusiness(_context, "en").DetermineSsgModel(assessmentId);
            if (ssgModelId != null)
            {
                response.Add((int)ssgModelId);
            }

            return response;
        }


        /// <summary>
        /// Removes questions that are above the assessment's target maturity level.
        /// </summary>
        private List<AnswerBasic> FilterByMaturityLevel(int assessmentId, List<int> inScopeModels, List<AnswerBasic> list)
        {
            // determine the target level
            var selectedLevel = _context.ASSESSMENT_SELECTED_LEVELS
               .Where(x => x.Assessment_Id == assessmentId && x.Level_Name == Constants.Constants.MaturityLevel)
               .FirstOrDefault();

            int targetLevel = (selectedLevel != null) ? int.Parse(selectedLevel.Standard_Specific_Sal_Level) : 9999;


            // get the questions assigned to levels that are higher than my target
            var outOfRangeQuestionIds = from ml in _context.MATURITY_LEVELS
                                        join mq in _context.MATURITY_QUESTIONS on ml.Maturity_Level_Id equals mq.Maturity_Level_Id
                                        where inScopeModels.Contains(mq.Maturity_Model_Id)
                                        && ml.Level > targetLevel
                                        select mq.Mat_Question_Id;


            // remove all questions from 'the list' that are assigned to the out-of-scope levels
            list.RemoveAll(x => outOfRangeQuestionIds.Contains(x.MatQuestionId));

            return list;
        }

        #endregion
    }


    /// <summary>
    /// A helper class to manage question IDs and answer values.
    /// </summary>
    public class AnswerBasic
    {
        public int MatQuestionId { get; set; }
        public string AnswerText { get; set; }
    }

}
