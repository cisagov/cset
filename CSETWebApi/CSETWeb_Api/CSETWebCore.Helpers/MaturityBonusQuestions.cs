using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Question;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Helpers
{
    /// <summary>
    /// Adds additional questions 
    /// </summary>
    public class MaturityBonusQuestions
    {
        private CSETContext _context;

        /// <summary>
        /// A secondary maturity model whose questions should be included in the assessment (SSG)
        /// </summary>
        public int? BonusModelId;

        /// <summary>
        /// A list of additional questions (e.g., Sector-Specific Goals (SSG)) applicable to the assessment
        /// </summary>
        public List<AdditionalQuestionDefinition> BonusQuestions;


        /// <summary>
        /// CTOR
        /// </summary>
        /// <param name="context"></param>
        public MaturityBonusQuestions(CSETContext context, int assessmentId)
        {
            _context = context;


            BonusModelId = DetermineBonusModel(assessmentId);

            var result = from mqa in _context.MQ_BONUS
                         join mq in _context.MATURITY_QUESTIONS on mqa.BonusQuestionId equals mq.Mat_Question_Id
                         where mqa.ModelId == BonusModelId
                         select new AdditionalQuestionDefinition() { Question = mq, MqAppend = mqa };

            foreach (var item in result)
            {
                item.Question.MATURITY_QUESTION_PROPS = _context.MATURITY_QUESTION_PROPS.Where(x => x.Mat_Question_Id == item.Question.Mat_Question_Id).ToList();
            }

            this.BonusQuestions = result.ToList();
        }



        /// <summary>
        /// Include additional questions.  This was created to add SSG questions 
        /// to a CPG assessment based on the assessment's SECTOR.
        /// </summary>
        /// <param name="questions"></param>
        public void AppendBonusQuestions(List<QuestionAnswer> groupingQuestions, List<FullAnswer> answers, AdditionalSupplemental addlSuppl)
        {
            // see if any of the questions in this grouping should be preceded/followed/replaced
            // by an "additional question"
            for (int i = groupingQuestions.Count - 1; i >= 0; i--)
            {
                QuestionAnswer targetQ = groupingQuestions[i];

                var bonuses = BonusQuestions.Where(x => x.MqAppend.BaseQuestionId == targetQ.QuestionId).OrderBy(x => x.MqAppend.Sequence).Reverse().ToList();

                foreach (var bonus in bonuses)
                {
                    FullAnswer answer = answers.Where(x => x.a.Question_Or_Requirement_Id == bonus.Question.Mat_Question_Id).FirstOrDefault();

                    var newQ = QuestionAnswerBuilder.BuildQuestionAnswer(bonus.Question, answer);
                    newQ.IsBonusQuestion = true;

                    // Include CSF mappings
                    newQ.CsfMappings = addlSuppl.GetCsfMappings(newQ.QuestionId, "Maturity");

                    // Include any TTPs
                    newQ.TTP = addlSuppl.GetTTPReferenceList(newQ.QuestionId);


                    // "Action" will be B, A or R
                    switch (bonus.MqAppend.Action.ToUpper())
                    {
                        // insert BEFORE
                        case "B":
                            groupingQuestions.Insert(i, newQ);
                            break;

                        // insert AFTER
                        case "A":
                            groupingQuestions.Insert(i + 1, newQ);
                            break;

                        // REPLACE
                        case "R":
                            groupingQuestions.Insert(i + 1, newQ);
                            groupingQuestions.RemoveAt(i);
                            break;
                    }
                }
            }
        }


        /// <summary>
        /// Determines which Model is also applicable to the assessment
        /// as an SSG "bonus."
        /// 
        /// These relationships could be defined in the database at some
        /// point, but due to the complexity of 2 different storage locations,
        /// for now they are defined here as code.  
        /// </summary>
        /// <returns></returns>
        private int? DetermineBonusModel(int assessmentId)
        {
            // define the SSG model Ids we currently support
            const int CHEM = 18;



            var ddSector = _context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id != assessmentId && x.DataItemName == "SECTOR").FirstOrDefault();
            if (ddSector.IntValue == 19)
            {
                return CHEM;
            }


            var demographics = _context.DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            if (demographics != null)
            {
                if (demographics.SectorId == 1)
                {
                    return CHEM;
                }
            }

            // no sector has been selected, so no bonus model is applicable
            return null;
        }
    }
}
