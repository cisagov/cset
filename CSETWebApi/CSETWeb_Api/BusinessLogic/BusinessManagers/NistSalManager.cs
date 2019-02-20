//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.SALS;
using CSETWeb_Api.BusinessLogic.Models;
using CSETWeb_Api.Helpers.sals;
using DataLayerCore.Model;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;

namespace CSETWeb_Api.Controllers
{
    public class NistSalManager
    {
        public NistSalManager()
        {
        }

        internal void CreateInitialList(object assessmentId)
        {
            using (CSET_Context db = new CSET_Context())
            {
                string sql =
                "if exists(select * from STANDARD_SELECTION where Assessment_Id = @id) and not exists(select * from NIST_SAL_INFO_TYPES where assessment_id = @id)  " +
                "begin " +
                "INSERT INTO [dbo].[NIST_SAL_INFO_TYPES] " +
                "           ([Assessment_Id] " +
                "           ,[Type_Value] " +
                "           ,[Selected] " +
                "           ,[Confidentiality_Value] " +
                "           ,[Confidentiality_Special_Factor] " +
                "           ,[Integrity_Value] " +
                "           ,[Integrity_Special_Factor] " +
                "           ,[Availability_Value] " +
                "           ,[Availability_Special_Factor] " +
                "           ,[Area] " +
                "           ,[NIST_Number]) " +
                "select [assessment_id] =@id " +
                "      ,[Type_Value]    " +
                "	  ,[Selected] = 0    " +
                "      ,[Confidentiality_Value] " +
                "      ,[Confidentiality_Special_Factor] " +
                "      ,[Integrity_Value] " +
                "      ,[Integrity_Special_Factor] " +
                "      ,[Availability_Value] " +
                "      ,[Availability_Special_Factor] " +
                "      ,[Area] " +
                "      ,[NIST_Number] " +
                "	   from NIST_SAL_INFO_TYPES_DEFAULTS " +
                "end  ";
                db.Database.ExecuteSqlCommand(sql,
                    new SqlParameter("@Id", assessmentId));
            }
        }

        public List<NistSalModel> GetInformationTypes(int assessmentId)
        {
            TinyMapper.Bind<NIST_SAL_INFO_TYPES, NistSalModel>();
            CreateInitialList(assessmentId);
            using (CSET_Context db = new CSET_Context())
            {
                List<NistSalModel> rlist = new List<NistSalModel>();
                foreach (NIST_SAL_INFO_TYPES t in db.NIST_SAL_INFO_TYPES.Where(x => x.Assessment_Id == assessmentId))
                {
                    rlist.Add(TinyMapper.Map<NistSalModel>(t));
                }
                return rlist;
            }
        }

        public Sals UpdateSalValue(NistSalModel updateValue, int assessmentid)
        {
            TinyMapper.Bind<NistSalModel, NIST_SAL_INFO_TYPES>(config =>
            {
                config.Ignore(x => x.Assessment_Id);
            });

            using (CSET_Context db = new CSET_Context())
            {
                NIST_SAL_INFO_TYPES update = db.NIST_SAL_INFO_TYPES.Where(x => x.Assessment_Id == assessmentid && x.Type_Value == updateValue.Type_Value).FirstOrDefault();
                TinyMapper.Map<NistSalModel, NIST_SAL_INFO_TYPES>(updateValue, update);
                db.SaveChanges();
                return CalculateOveralls(assessmentid, db);
            }

        }


        /// <summary>
        /// Returns all known NIST answers for the assessment.  
        /// If there are no answers for the assessment,
        /// a set of 'no' answers is created, saved and returned.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public List<NistQuestionsAnswers> GetNistQuestions(int assessmentId)
        {
            using (CSET_Context db = new CSET_Context())
            {
                // if we don't have answers yet, clone them and default all answers to 'no'
                var existingAnswers = db.NIST_SAL_QUESTION_ANSWERS.Where(x => x.Assessment_Id == assessmentId).ToList();
                if (existingAnswers.Count() == 0)
                {
                    // Create default answer rows based on the question set
                    foreach (var question in db.NIST_SAL_QUESTIONS.ToList())
                    {
                        var ans = new NIST_SAL_QUESTION_ANSWERS()
                        {
                            Assessment_Id = assessmentId,
                            Question_Id = question.Question_Id,
                            Question_Answer = "No"
                        };
                        db.NIST_SAL_QUESTION_ANSWERS.Add(ans);
                    }

                    db.SaveChanges();
                }

                var rlist = from a in db.NIST_SAL_QUESTIONS
                            join b in db.NIST_SAL_QUESTION_ANSWERS on a.Question_Id equals b.Question_Id
                            where b.Assessment_Id == assessmentId
                            orderby a.Question_Number
                            select new NistQuestionsAnswers() { Assessment_Id = b.Assessment_Id, Question_Id = b.Question_Id, Question_Answer = b.Question_Answer, Question_Number = a.Question_Number, Question_Text = a.Question_Text };
                return rlist.ToList();
            }
        }

        public Sals SaveNistQuestions(int assessmentid, NistQuestionsAnswers answer)
        {
            using (CSET_Context db = new CSET_Context())
            {
                var dbAnswer = db.NIST_SAL_QUESTION_ANSWERS.Where(x => x.Assessment_Id == assessmentid && x.Question_Id == answer.Question_Id).FirstOrDefault();
                if (dbAnswer == null)
                {
                    throw new ApplicationException(String.Format("Question {0} could not be found for assessment {1}!", answer.Question_Number, assessmentid));
                }
                TinyMapper.Map<NistQuestionsAnswers, NIST_SAL_QUESTION_ANSWERS>(answer, dbAnswer);
                db.SaveChanges();
                return CalculateOveralls(assessmentid, db);
            }
        }

        public NistSpecialFactor GetSpecialFactors(int assessmentId)
        {
            using (CSET_Context db = new CSET_Context())
            {

                NistSpecialFactor rval = new NistSpecialFactor();
                rval.loadFromDb(assessmentId, db);
                return rval;
            }

        }

        public Sals SaveNistSpecialFactor(int assessmentId, NistSpecialFactor updateValue)
        {
            using (CSET_Context db = new CSET_Context())
            {
                updateValue.SaveToDb(assessmentId, db);
                return CalculateOveralls(assessmentId, db);
            }
        }

        public Sals CalculatedNist(int assessmentId, CSET_Context db)
        {
            NistProcessingLogic nistProcessing = new NistProcessingLogic();
            nistProcessing.CalcLevels(assessmentId, db);
            Sals rval = new Sals()
            {
                ALevel = nistProcessing.highestQuestionAvailabilityValue.SALName,
                CLevel = nistProcessing.highestQuestionConfidentialityValue.SALName,
                ILevel = nistProcessing.highestQuestionIntegrityValue.SALName,
                Selected_Sal_Level = nistProcessing.HighestOverallNISTSALLevel.SALName
            };
            return rval;
        }

        private Sals CalculateOveralls(int assessmentId, CSET_Context db)
        {
            Sals rval = CalculatedNist(assessmentId, db);           
            STANDARD_SELECTION sTANDARD_SELECTION = db.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            sTANDARD_SELECTION.Selected_Sal_Level = rval.Selected_Sal_Level;
            LevelManager lm = new LevelManager(assessmentId,db);            
            lm.SaveOtherLevels(assessmentId, rval);
            db.SaveChanges();
            return rval;
        }
    }

    public class SALLevelNIST
    {
        public int SALValue { get; set; }
        public string SALName { get; set; }

        public SALLevelNIST(int weight, string name)
        {
            this.SALValue = weight;
            this.SALName = name;
        }
    }

    public class NistModel
    {


        public List<NistSalModel> models { get; set; }
        public List<NistQuestionsAnswers> questions { get; set; }
        public NistSpecialFactor specialFactors { get; set; }
    }

    public class NistQuestionsAnswers
    {
        public int Assessment_Id { get; set; }
        public int Question_Id { get; set; }
        public string Question_Answer { get; set; }
        public int Question_Number { get; set; }
        public string Question_Text { get; set; }
    }

    /// <summary>
    /// 
    /// </summary>
    public class NistSalModel
    {
        public int Assessment_Id { get; set; }
        public string Type_Value { get; set; }
        public bool Selected { get; set; }
        public string Confidentiality_Value { get; set; }
        public string Confidentiality_Special_Factor { get; set; }
        public string Integrity_Value { get; set; }
        public string Integrity_Special_Factor { get; set; }
        public string Availability_Value { get; set; }
        public string Availability_Special_Factor { get; set; }
        public string Area { get; set; }
        public string NIST_Number { get; set; }
    }
}


