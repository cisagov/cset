//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;

namespace CSETWebCore.Business.Sal
{
    public class NistProcessingLogic
    {
        private const int MAX_NIST_SAL_VALUE = 3;
        private const string MAX_NIST_SAL_NAME = Constants.Constants.SAL_HIGH;
        private static SALLevelNIST SAL_NONE = new SALLevelNIST() { SALValue = 0, SALName = Constants.Constants.SAL_NONE };
        private static SALLevelNIST SAL_LOW = new SALLevelNIST() { SALValue = 1, SALName = Constants.Constants.SAL_LOW };
        private static SALLevelNIST SAL_MODERATE = new SALLevelNIST() { SALValue = 2, SALName = Constants.Constants.SAL_MODERATE };
        private static SALLevelNIST SAL_HIGH = new SALLevelNIST() { SALValue = 3, SALName = Constants.Constants.SAL_HIGH };
        private static SALLevelNIST SAL_VERY_HIGH = new SALLevelNIST() { SALValue = 4, SALName = Constants.Constants.SAL_VERY_HIGH };

        public SALLevelNIST HighestOverallNISTSALLevel { get; set; }
        public Dictionary<String, SALLevelNIST> StringValueToLevel = new Dictionary<string, SALLevelNIST>();

        public SALLevelNIST highestQuestionConfidentialityValue = SAL_LOW;
        public SALLevelNIST highestQuestionAvailabilityValue = SAL_LOW;
        public SALLevelNIST highestQuestionIntegrityValue = SAL_LOW;
        public SALLevelNIST highestInfoTypeConfidentialityValue = SAL_LOW;
        public SALLevelNIST highestInfoTypeAvailabilityValue = SAL_LOW;
        public SALLevelNIST highestInfoTypeIntegrityValue = SAL_LOW;


        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;


        public NistProcessingLogic(CSETContext context, IAssessmentUtil assessmentUtil)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;

            StringValueToLevel.Add(Constants.Constants.SAL_NONE.ToLower(), SAL_NONE);
            StringValueToLevel.Add(Constants.Constants.SAL_LOW.ToLower(), SAL_LOW);
            StringValueToLevel.Add(Constants.Constants.SAL_MODERATE.ToLower(), SAL_MODERATE);
            StringValueToLevel.Add(Constants.Constants.SAL_HIGH.ToLower(), SAL_HIGH);
            StringValueToLevel.Add(Constants.Constants.SAL_VERY_HIGH.ToLower(), SAL_VERY_HIGH);
        }

        public SALLevelNIST GetWeightPair(String level)
        {
            return StringValueToLevel[level.ToLower()];
        }


        private List<NistSpecialFactor> GetSpecialFactors(int assessmentId)
        {
            var topList = _context.NIST_SAL_INFO_TYPES.Where(x => x.Assessment_Id == assessmentId && x.Selected == true).ToList();
            List<NistSpecialFactor> rvalue = new List<NistSpecialFactor>();
            foreach (NIST_SAL_INFO_TYPES t in topList)
            {
                NistSpecialFactor sp = new NistSpecialFactor()
                {
                    Availability_Special_Factor = t.Availability_Special_Factor,
                    Confidentiality_Special_Factor = t.Confidentiality_Special_Factor,
                    Integrity_Special_Factor = t.Integrity_Special_Factor,
                    Type_Value = t.Type_Value,
                    Availability_Value = GetWeightPair(t.Availability_Value),
                    Integrity_Value = GetWeightPair(t.Integrity_Value),
                    Confidentiality_Value = GetWeightPair(t.Confidentiality_Value),
                };
                rvalue.Add(sp);
            }

            return rvalue;
        }


        private List<NistQuestionPoco> GetNISTQuestionPocos(int assessmentId)
        {
            var list = from a in _context.NIST_SAL_QUESTION_ANSWERS
                       join b in _context.NIST_SAL_QUESTIONS on a.Question_Id equals b.Question_Id
                       where a.Assessment_Id == assessmentId
                       select new NistQuestionPoco() { QuestionNumber = b.Question_Number, Question_Answer = a.Question_Answer, Question_Id = a.Question_Id, Simple_Question = b.Question_Text };

            return list.ToList();
        }

        public void CalcLevels(int assessmentId)
        {
            var infoTypes = GetSpecialFactors(assessmentId);
            var questions = GetNISTQuestionPocos(assessmentId);
            UpdateHighestLevels(infoTypes, questions);
        }


        private void UpdateHighestLevels(IEnumerable<NistSpecialFactor> infoTypeList, IEnumerable<NistQuestionPoco> nistQuestions)
        {
            HighestOverallNISTSALLevel = SAL_LOW;
            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // INFO TYPES
            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // Iterate over the Info Type list and set the highest SAL value for each type

            foreach (NistSpecialFactor infoType in infoTypeList)
            {
                if (infoType.Confidentiality_Value.SALValue > highestInfoTypeConfidentialityValue.SALValue)
                {
                    highestInfoTypeConfidentialityValue = infoType.Confidentiality_Value;
                }

                if (infoType.Availability_Value.SALValue > highestInfoTypeAvailabilityValue.SALValue)
                {
                    highestInfoTypeAvailabilityValue = infoType.Availability_Value;
                }

                if (infoType.Integrity_Value.SALValue > highestInfoTypeIntegrityValue.SALValue)
                {
                    highestInfoTypeIntegrityValue = infoType.Integrity_Value;
                }
            }
            this.GetHighestLevel(this.HighestOverallNISTSALLevel, highestInfoTypeConfidentialityValue,
                   highestInfoTypeAvailabilityValue, highestInfoTypeIntegrityValue);

            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // QUESTIONS
            /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            // Initialize the question values to that of the Info type values
            highestQuestionConfidentialityValue = highestInfoTypeConfidentialityValue;
            highestQuestionAvailabilityValue = highestInfoTypeAvailabilityValue;
            highestQuestionIntegrityValue = highestInfoTypeIntegrityValue;

            // Increments the SAL values as appropriate for each question
            if (nistQuestions != null)
            {
                foreach (NistQuestionPoco question in nistQuestions)
                {
                    if (question.IsAnswerYes == true)
                    {
                        int questionNumber = question.QuestionNumber;
                        if ((questionNumber == 1) || (questionNumber == 3) || (questionNumber == 6) || (questionNumber == 7) || (questionNumber == 8))
                        {
                            highestQuestionConfidentialityValue = this.IncrementNISTSALLevel(highestQuestionConfidentialityValue);
                        }
                        if ((questionNumber == 1) || (questionNumber == 2) || (questionNumber == 3) || (questionNumber == 6) || (questionNumber == 5))
                        {
                            highestQuestionAvailabilityValue = this.IncrementNISTSALLevel(highestQuestionAvailabilityValue);
                        }
                        if ((questionNumber == 1) || (questionNumber == 2) || (questionNumber == 3) || (questionNumber == 4) || (questionNumber == 6))
                        {
                            highestQuestionIntegrityValue = this.IncrementNISTSALLevel(highestQuestionIntegrityValue);
                        }
                    }
                }
            }
            // Get the highest overall Question value
            this.HighestOverallNISTSALLevel = this.GetHighestLevel(this.HighestOverallNISTSALLevel, highestQuestionConfidentialityValue, highestQuestionAvailabilityValue, highestQuestionIntegrityValue);
        }


        /// <summary>
        /// Returns the highest level of the passed parameters
        /// </summary>
        /// <param name="highestConfidentialityLevel"></param>
        /// <param name="highestAvailabilityLevel"></param>
        /// <param name="highestIntegrityLevel"></param>
        /// <returns></returns>
        public SALLevelNIST GetHighestLevel(SALLevelNIST currentHighestLevel, SALLevelNIST currentConfidentialityLevel, SALLevelNIST currentAvailabilityLevel, SALLevelNIST currentIntegrityLevel)
        {
            if (currentConfidentialityLevel.SALValue > currentHighestLevel.SALValue)
            {
                currentHighestLevel = currentConfidentialityLevel;
            }
            if (currentAvailabilityLevel.SALValue > currentHighestLevel.SALValue)
            {
                currentHighestLevel = currentAvailabilityLevel;
            }
            if (currentIntegrityLevel.SALValue > currentHighestLevel.SALValue)
            {
                currentHighestLevel = currentIntegrityLevel;
            }
            return currentHighestLevel;
        }


        /// <summary>
        /// Increments the passed SALLevelNIST object and takes care of the max values
        /// </summary>
        /// <param name="salLevelToincrement"></param>
        /// <returns></returns>
        private SALLevelNIST IncrementNISTSALLevel(SALLevelNIST salLevelToincrement)
        {
            SALLevelNIST salLevel = new SALLevelNIST() { SALValue = salLevelToincrement.SALValue, SALName = salLevelToincrement.SALName };
            if (salLevel.SALValue < MAX_NIST_SAL_VALUE)
            {
                salLevel.SALValue++;
                switch (salLevel.SALValue)
                {
                    case (0):
                    case (1):
                        salLevel.SALName = Constants.Constants.SAL_LOW;
                        break;
                    case (2):
                        salLevel.SALName = Constants.Constants.SAL_MODERATE;
                        break;
                    case (3):
                        salLevel.SALName = Constants.Constants.SAL_HIGH;
                        break;
                }
            }
            else
            {
                salLevel.SALValue = MAX_NIST_SAL_VALUE;
                salLevel.SALName = MAX_NIST_SAL_NAME;
            }
            return salLevel;
        }
    }
}
