//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using DataLayerCore.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers
{
    /// <summary>
    /// 
    /// </summary>
    public class AnswerManager
    {
        private int _assessmentId;

        public AnswerManager(int assessmentId)
        {
            _assessmentId = assessmentId;
        }


        /// <summary>
        /// Returns a list of 'active' answer IDs for the assessment.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public List<int> ActiveAnswerIds()
        {
            using (var db = new CSET_Context())
            {
                var ss = db.STANDARD_SELECTION.Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();
                if (ss == null)
                {
                    return new List<int>();
                }

                if (ss.Application_Mode == "Questions Based")
                {
                    // Questions Mode
                    return GetQuestionAnswerIds();
                }
                else
                {
                    // Requirements Mode
                    return GetRequirementAnswerIds();
                }
            }
        }


        /// <summary>
        /// Returns a list of answerids attached to active questions.
        /// This could be expanded in the future to return more Question or Answer data.
        /// </summary>
        /// <returns></returns>
        private List<int> GetQuestionAnswerIds()
        {
            List<int> list = new List<int>();

            using (var db = new CSET_Context())
            {
                List<string> mySets = db.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == _assessmentId).Select(x => x.Set_Name).ToList();

                if (mySets.Count == 1)
                {
                    var query = from q in db.NEW_QUESTION
                                from ans in db.ANSWER.Where(x => x.Assessment_Id == _assessmentId
                                                            && x.Question_Or_Requirement_Id == q.Question_Id)
                                from qs in db.NEW_QUESTION_SETS.Where(x => x.Question_Id == q.Question_Id)
                                from l in db.NEW_QUESTION_LEVELS.Where(x => x.New_Question_Set_Id == qs.New_Question_Set_Id)
                                from s in db.SETS.Where(x => x.Set_Name == qs.Set_Name)
                                from ss in db.STANDARD_SELECTION.Where(x => x.Assessment_Id == ans.Assessment_Id)
                                from u in db.UNIVERSAL_SAL_LEVEL.Where(x => x.Full_Name_Sal == ss.Selected_Sal_Level)
                                where mySets.Contains(qs.Set_Name)
                                    && l.Universal_Sal_Level == u.Universal_Sal_Level1
                                select new { ans.Answer_Id };

                    // get the answerids 
                    list = query.Select(x => x.Answer_Id).ToList();
                }
                else
                {
                    var query = from q in db.NEW_QUESTION
                                from ans in db.ANSWER.Where(x => x.Assessment_Id == _assessmentId
                                                            && x.Question_Or_Requirement_Id == q.Question_Id)
                                from qs in db.NEW_QUESTION_SETS.Where(x => x.Question_Id == q.Question_Id)
                                from nql in db.NEW_QUESTION_LEVELS.Where(x => x.New_Question_Set_Id == qs.New_Question_Set_Id)
                                from usch in db.UNIVERSAL_SUB_CATEGORY_HEADINGS.Where(x => x.Heading_Pair_Id == q.Heading_Pair_Id)
                                from stand in db.AVAILABLE_STANDARDS.Where(x => x.Set_Name == qs.Set_Name)
                                from qgh in db.QUESTION_GROUP_HEADING.Where(x => x.Question_Group_Heading_Id == usch.Question_Group_Heading_Id)
                                from usc in db.UNIVERSAL_SUB_CATEGORIES.Where(x => x.Universal_Sub_Category_Id == usch.Universal_Sub_Category_Id)
                                where stand.Selected == true && stand.Assessment_Id == ans.Assessment_Id
                                select new { ans.Answer_Id };

                    // get the answerids 
                    list = query.Select(x => x.Answer_Id).ToList();
                }
            }

            return list;
        }


        /// <summary>
        /// Returns a list of answerids attached to active requirements.
        /// This could be expanded in the future to return more Requirement or Answer data.
        /// </summary>
        /// <returns></returns>
        private List<int> GetRequirementAnswerIds()
        {
            List<int> list = new List<int>();

            using (var db = new CSET_Context())
            {
                List<string> mySets = db.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == _assessmentId).Select(x => x.Set_Name).ToList();

                var query = from rs in db.REQUIREMENT_SETS
                            from s in db.SETS.Where(x => x.Set_Name == rs.Set_Name)
                            from r in db.NEW_REQUIREMENT.Where(x => x.Requirement_Id == rs.Requirement_Id)
                            from ans in db.ANSWER.Where(x => x.Assessment_Id == _assessmentId
                                                        && x.Question_Or_Requirement_Id == r.Requirement_Id)
                            from rl in db.REQUIREMENT_LEVELS.Where(x => x.Requirement_Id == r.Requirement_Id)
                            from ss in db.STANDARD_SELECTION.Where(x => x.Assessment_Id == ans.Assessment_Id)
                            from u in db.UNIVERSAL_SAL_LEVEL.Where(x => x.Full_Name_Sal == ss.Selected_Sal_Level)
                            where mySets.Contains(rs.Set_Name)
                                && rl.Standard_Level == u.Universal_Sal_Level1
                            select new { ans.Answer_Id };

                // get the answerids 
                list = query.Select(x => x.Answer_Id).ToList();
            }

            return list;
        }
    }
}


