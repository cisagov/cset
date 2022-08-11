//////////////////////////////// 
// 
//   Copyright 2022 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Nelibur.ObjectMapper;
using System;
using System.Collections.Generic;
using Microsoft.Data.SqlClient;
using System.Linq;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Sal;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Sal
{
    public class NistSalBusiness
    {
        private CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;

        /// <summary>
        /// 
        /// </summary>
        public NistSalBusiness(CSETContext context, IAssessmentUtil assessmentUtil)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        internal void CreateInitialList(object assessmentId)
        {
            string sql =
            "if exists(select * from STANDARD_SELECTION where Assessment_Id = @id) and not exists(select * from NIST_SAL_INFO_TYPES where assessment_id = @id)  " +
            "begin " +
            "INSERT INTO [NIST_SAL_INFO_TYPES] " +
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

            _context.Database.ExecuteSqlRaw(sql,
                new SqlParameter("@Id", assessmentId));
        }

        public  List<NistSalModel> GetInformationTypes(int assessmentId)
        {
            TinyMapper.Bind<NIST_SAL_INFO_TYPES, NistSalModel>();
            CreateInitialList(assessmentId);
            List<NistSalModel> rlist = new List<NistSalModel>();
            foreach (NIST_SAL_INFO_TYPES t in _context.NIST_SAL_INFO_TYPES.Where(x => x.Assessment_Id == assessmentId))
            {
                rlist.Add(TinyMapper.Map<NistSalModel>(t));
            }
            return rlist;
        }

        public async Task<Sals> UpdateSalValue(NistSalModel updateValue, int assessmentid)
        {
            TinyMapper.Bind<NistSalModel, NIST_SAL_INFO_TYPES>(config =>
            {
                config.Ignore(x => x.Assessment_Id);
            });

            NIST_SAL_INFO_TYPES update = await _context.NIST_SAL_INFO_TYPES.Where(x => x.Assessment_Id == assessmentid && x.Type_Value == updateValue.Type_Value).FirstOrDefaultAsync();
            TinyMapper.Map<NistSalModel, NIST_SAL_INFO_TYPES>(updateValue, update);
            await _context.SaveChangesAsync();
            return await CalculateOveralls(assessmentid);
        }


        /// <summary>
        /// Returns all known NIST answers for the assessment.  
        /// If there are no answers for the assessment,
        /// a set of 'no' answers is created, saved and returned.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public async Task<List<NistQuestionsAnswers>> GetNistQuestions(int assessmentId)
        {
            // if we don't have answers yet, clone them and default all answers to 'no'
            var existingAnswers = _context.NIST_SAL_QUESTION_ANSWERS.Where(x => x.Assessment_Id == assessmentId).ToList();
            if (existingAnswers.Count() == 0)
            {
                // Create default answer rows based on the question set
                var questions = await _context.NIST_SAL_QUESTIONS.ToListAsync();
                foreach (var question in questions)
                {
                    var ans = new NIST_SAL_QUESTION_ANSWERS()
                    {
                        Assessment_Id = assessmentId,
                        Question_Id = question.Question_Id,
                        Question_Answer = "No"
                    };
                    await _context.NIST_SAL_QUESTION_ANSWERS.AddAsync(ans);
                }

                await _context.SaveChangesAsync();
            }

            var rlist = from a in _context.NIST_SAL_QUESTIONS
                        join b in _context.NIST_SAL_QUESTION_ANSWERS on a.Question_Id equals b.Question_Id
                        where b.Assessment_Id == assessmentId
                        orderby a.Question_Number
                        select new NistQuestionsAnswers() { Assessment_Id = b.Assessment_Id, Question_Id = b.Question_Id, Question_Answer = b.Question_Answer, Question_Number = a.Question_Number, Question_Text = a.Question_Text };
            return await rlist.ToListAsync();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentid"></param>
        /// <param name="answer"></param>
        /// <returns></returns>
        public async Task<Sals> SaveNistQuestions(int assessmentid, NistQuestionsAnswers answer)
        {
            var dbAnswer = await _context.NIST_SAL_QUESTION_ANSWERS.Where(x => x.Assessment_Id == assessmentid && x.Question_Id == answer.Question_Id).FirstOrDefaultAsync();
            if (dbAnswer == null)
            {
                throw new ApplicationException(String.Format("Question {0} could not be found for assessment {1}!", answer.Question_Number, assessmentid));
            }

            TinyMapper.Bind<NistQuestionsAnswers, NIST_SAL_QUESTION_ANSWERS>();
            TinyMapper.Map<NistQuestionsAnswers, NIST_SAL_QUESTION_ANSWERS>(answer, dbAnswer);
            await _context.SaveChangesAsync();
            return await CalculateOveralls(assessmentid);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public NistSpecialFactor GetSpecialFactors(int assessmentId)
        {
            NistSpecialFactor rval = new NistSpecialFactor();
            rval.LoadFromDb(assessmentId, _context);
            return rval;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="updateValue"></param>
        /// <returns></returns>
        public async Task<Sals> SaveNistSpecialFactor(int assessmentId, NistSpecialFactor updateValue)
        {
            await updateValue.SaveToDb(assessmentId, _context, _assessmentUtil);
            return await CalculateOveralls(assessmentId);
        }


        public Sals CalculatedNist(int assessmentId)
        {
            var nistProcessing = new NistProcessingLogic(_context, _assessmentUtil);
            nistProcessing.CalcLevels(assessmentId);
            Sals rval = new Sals()
            {
                ALevel = nistProcessing.highestQuestionAvailabilityValue.SALName,
                CLevel = nistProcessing.highestQuestionConfidentialityValue.SALName,
                ILevel = nistProcessing.highestQuestionIntegrityValue.SALName,
                Selected_Sal_Level = nistProcessing.HighestOverallNISTSALLevel.SALName
            };

            return rval;
        }


        private async Task<Sals> CalculateOveralls(int assessmentId)
        {
            Sals rval = CalculatedNist(assessmentId);
            STANDARD_SELECTION sTANDARD_SELECTION = await _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).FirstOrDefaultAsync();
            sTANDARD_SELECTION.Selected_Sal_Level = rval.Selected_Sal_Level;
            LevelManager lm = new LevelManager(assessmentId, _context);
            await lm.SaveOtherLevels(assessmentId, rval);
            await _context.SaveChangesAsync();
            return rval;
        }
    }


    public class SALLevelNIST
    {
        public int SALValue { get; set; }
        public string SALName { get; set; }
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
