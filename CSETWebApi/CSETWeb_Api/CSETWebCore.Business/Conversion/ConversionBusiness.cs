//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Business.Demographic;
using System.Linq;
using System.Collections.Generic;
using Microsoft.AspNetCore.Http.HttpResults;
using System;
using Npoi.Mapper;

namespace CSETWebCore.Business.Contact
{
    public class ConversionBusiness
    {
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;

        /// <summary>
        /// The set name for the Cyber Florida trimmed down CSF set
        /// </summary>
        private readonly string CF_CSF_SetName = "Florida_NCSF_V2";
        private readonly string[] CF_CSF_SetNames = { "Florida_NCSF_V2", "Florida_NCSF_V1" };

        /// <summary>
        /// The set name for Cybersecurity Framework v1.1
        /// </summary>
        private readonly string CF_SetName = "NCSF_V2";

        /// <summary>
        /// The model id for CPG
        /// </summary>
        private readonly int CPG_Model_Id = 11;

        /// <summary>
        /// The model id for RRA
        /// </summary>
        private readonly int RRA_Model_Id = 5;

        private readonly string Mid_Gallery_Guid = "FF43E99B-D6DD-409F-A07F-22F7AA55B9F3";

        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="context"></param>
        /// <param name="assessmentUtil"></param>
        public ConversionBusiness(CSETContext context, IAssessmentUtil assessmentUtil)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
        }


        /// <summary>
        /// Returns true if the assessment has a MATURITY-SUBMODEL record of 'RRA CF'
        /// or the standard 'Florida_CSF_v1' is selected.
        /// Normally, both conditions will be true for a Cyber Florida entry assessment.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public bool IsEntryCF(int assessmentId)
        {
            var cfRraRecord = _context.DETAILS_DEMOGRAPHICS.FirstOrDefault(x =>
                x.Assessment_Id == assessmentId && x.DataItemName == "MATURITY-SUBMODEL" && x.StringValue == "RRA CF");

            var availStandard = _context.AVAILABLE_STANDARDS
                .Where(x => x.Assessment_Id == assessmentId && CF_CSF_SetNames.Contains(x.Set_Name) && x.Selected).FirstOrDefault();

            if (cfRraRecord != null || availStandard != null)
            {
                return true;
            }

            return false;
        }


        /// <summary>
        /// Returns true if the assessment is CPG
        /// Normally, both conditions will be true for a Cyber Florida entry assessment.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public bool IsMidCF(int assessmentId)
        {
            var cfRraRecord = _context.DETAILS_DEMOGRAPHICS.FirstOrDefault(x =>
                x.Assessment_Id == assessmentId && x.DataItemName == "MATURITY-SUBMODEL" && x.StringValue == "RRA CF");

            var availStandard = _context.AVAILABLE_STANDARDS
                .Where(x => x.Assessment_Id == assessmentId && CF_CSF_SetNames.Contains(x.Set_Name) && x.Selected).FirstOrDefault();

            if (cfRraRecord != null || availStandard != null)
            {
                return true;
            }

            return false;
        }


        public List<CFEntry> IsEntryCF(List<int> assessmentIds)
        {
            List<CFEntry> results = new List<CFEntry>();
            foreach (var assessmentId in assessmentIds)
            {
                results.Add(new CFEntry() { AssessmentId = assessmentId, IsEntry = IsEntryCF(assessmentId) });
            }
            return results;
        }


        /// <summary>
        /// Converts a Cyber Florida "entry" assessment to a full
        /// assessment with CSF 1.1 and RRA.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public void ConvertCF(int assessmentId)
        {
            // Delete the "CF RRA" submodel record.  This will have the effect of looking
            // at the entire RRA model.
            var cfRraRecord = _context.DETAILS_DEMOGRAPHICS.FirstOrDefault(x =>
                x.Assessment_Id == assessmentId && x.DataItemName == "MATURITY-SUBMODEL" && x.StringValue == "RRA CF");
            if (cfRraRecord != null)
            {
                _context.DETAILS_DEMOGRAPHICS.Remove(cfRraRecord);
            }


            // swap out the AVAILABLE_STANDARDS record for the full CSF record
            var availStandard = _context.AVAILABLE_STANDARDS
                .Where(x => x.Assessment_Id == assessmentId && x.Set_Name == CF_CSF_SetName && x.Selected).FirstOrDefault();

            if (availStandard != null)
            {
                _context.AVAILABLE_STANDARDS.Remove(availStandard);


                var newAvailStandard = new AVAILABLE_STANDARDS()
                {
                    Assessment_Id = assessmentId,
                    Selected = true,
                    Set_Name = CF_SetName
                };

                _context.AVAILABLE_STANDARDS.Add(newAvailStandard);
            }


            // add details_demographics flagging the assessment as a "used to be a CyberFlorida entry assessment"
            var biz = new DemographicBusiness(_context, _assessmentUtil);
            biz.SaveDD(assessmentId, "FORMER-CF-ENTRY", "true", null);

            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(assessmentId);
        }

        /// <summary>
        /// Converts a Cyber Florida "entry" assessment to a mid-level
        /// assessment with CPG only.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public void ConvertEntryToMid(int assessmentId)
        {
            // Delete the "CF RRA" submodel record.  This will have the effect of looking
            // at the entire RRA model.
            var cfRraRecord = _context.DETAILS_DEMOGRAPHICS.FirstOrDefault(x =>
                x.Assessment_Id == assessmentId && x.DataItemName == "MATURITY-SUBMODEL" && x.StringValue == "RRA CF");
            if (cfRraRecord != null)
            {
                _context.DETAILS_DEMOGRAPHICS.Remove(cfRraRecord);
            }


            // remove the AVAILABLE_STANDARDS record and the RRA record in the AVAILABLE_MATURITY_MODELS table
            // add a CPG record in the AVAILABLE_MATURITY_MODELS table
            var availStandard = _context.AVAILABLE_STANDARDS
                .Where(x => x.Assessment_Id == assessmentId && x.Set_Name == CF_CSF_SetName && x.Selected).FirstOrDefault();
            var availMaturity = _context.AVAILABLE_MATURITY_MODELS
                .Where(x => x.Assessment_Id == assessmentId && x.model_id == RRA_Model_Id && x.Selected).FirstOrDefault();

            if (availStandard != null)
            {
                _context.AVAILABLE_STANDARDS.Remove(availStandard);
                //availMaturity.Selected = false;
                _context.AVAILABLE_MATURITY_MODELS.Remove(availMaturity);

                var newAvailMaturity = new AVAILABLE_MATURITY_MODELS()
                {
                    Assessment_Id = assessmentId,
                    Selected = true,
                    model_id = CPG_Model_Id
                };

                _context.AVAILABLE_MATURITY_MODELS.Add(newAvailMaturity);
            }

            CreateAnswerRecordsFromCFToCPG(assessmentId);


            // add details_demographics flagging the assessment as a "used to be a CyberFlorida entry assessment"
            var biz = new DemographicBusiness(_context, _assessmentUtil);
            biz.SaveDD(assessmentId, "FORMER-CF-ENTRY", "true", null);

            // changing gallery guid to mid-level
            var assessment = _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            assessment.GalleryItemGuid = Guid.Parse(Mid_Gallery_Guid);

            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(assessmentId);
        }

        /// <summary>
        /// Creates new answer records for CPG based off answers from "entry" level Florida_NCSF_V2
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public void CreateAnswerRecordsFromCFToCPG(int assessmentId)
        {
            // get the titles 
            var convertableTitles = _context.NCSF_CONVERSION_MAPPINGS.Where(x => !string.IsNullOrEmpty(x.Entry_Level_Titles)).ToList();

            // seperates the entry column into its own list
            var entryTitles = convertableTitles.Select(x => x.Entry_Level_Titles).ToList();

            if (convertableTitles != null)
            {
                var entryIds = _context.NEW_REQUIREMENT.Where(x => entryTitles.Contains(x.Requirement_Title) && x.Original_Set_Name == CF_CSF_SetName).Select(x => x.Requirement_Id).ToList();

                var entryAnswers = _context.ANSWER.Where(x => entryIds.Contains(x.Question_Or_Requirement_Id) && x.Assessment_Id == assessmentId).ToList();
                if (entryAnswers != null)
                {
                    var addedIds = new List<int>();
                    var newMidAnswers = new List<ANSWER>();
                    for (int i = 0; i < entryAnswers.Count; i++)
                    {
                        if (entryAnswers[i].Answer_Text != "U")
                        {
                            var cpgQuestionTitles = convertableTitles[i].Mid_Level_Titles.Split(",");
                            foreach (var questionTitle in cpgQuestionTitles)
                            {
                                var newAnswer = new ANSWER()
                                {
                                    Assessment_Id = assessmentId,
                                    Question_Or_Requirement_Id = _context.MATURITY_QUESTIONS
                                    .Where(x => x.Maturity_Model_Id == CPG_Model_Id && x.Question_Title == questionTitle)
                                    .Select(x => x.Mat_Question_Id).FirstOrDefault(),
                                    Mark_For_Review = entryAnswers[i].Mark_For_Review,
                                    Comment = entryAnswers[i].Comment,
                                    Alternate_Justification = entryAnswers[i].Alternate_Justification,
                                    Answer_Text = entryAnswers[i].Answer_Text == "Y" ? "S" : "N", // "S" for "Scoped", "N" for "Not Implemented"
                                    Reviewed = entryAnswers[i].Reviewed,
                                    FeedBack = entryAnswers[i].FeedBack,
                                    Question_Type = "Maturity",
                                    Is_Requirement = false,
                                    Is_Component = false,
                                    Is_Maturity = true
                                };


                                // prevents doubling-up of ANSWER records if questions can be controlled by multiple sources
                                if (addedIds.Contains(newAnswer.Question_Or_Requirement_Id))
                                {
                                    var answerRecord = newMidAnswers.Find(x => x.Question_Or_Requirement_Id == newAnswer.Question_Or_Requirement_Id);
                                    if (answerRecord.Answer_Text != newAnswer.Answer_Text)
                                    {
                                        answerRecord.Answer_Text = "N";
                                    }
                                }
                                else
                                {
                                    newMidAnswers.Add(newAnswer);
                                    addedIds.Add(newAnswer.Question_Or_Requirement_Id);
                                }

                            }
                        }
                    }

                    _context.ANSWER.AddRange(newMidAnswers);
                    _context.SaveChanges();
                }
            }


        }

        public void ConvertMidToFull(int assessmentId)
        {

            // remove the CPG AVAILABLE_MATURITY_MODELS record and
            // add the CF and RRA records back in
            var availMaturity = _context.AVAILABLE_MATURITY_MODELS
                .Where(x => x.Assessment_Id == assessmentId && x.model_id == CPG_Model_Id && x.Selected).FirstOrDefault();

            if (availMaturity != null)
            {
                _context.AVAILABLE_MATURITY_MODELS.Remove(availMaturity);

                var newAvailMaturity = new AVAILABLE_MATURITY_MODELS()
                {
                    Assessment_Id = assessmentId,
                    Selected = true,
                    model_id = RRA_Model_Id
                };

                _context.AVAILABLE_MATURITY_MODELS.Add(newAvailMaturity);
                _context.AVAILABLE_STANDARDS.Add(new AVAILABLE_STANDARDS()
                {
                    Assessment_Id = assessmentId,
                    Selected = true,
                    Set_Name = CF_SetName
                });
            }

            CreateAnswerRecordsFromCPGToCF(assessmentId);


            // add details_demographics flagging the assessment as a "used to be a CyberFlorida entry assessment"
            var biz = new DemographicBusiness(_context, _assessmentUtil);
            biz.SaveDD(assessmentId, "FORMER-CF-MID", "true", null);

            // changing gallery guid to mid-level
            var assessment = _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            assessment.GalleryItemGuid = Guid.Parse(Mid_Gallery_Guid);

            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(assessmentId);
        }


        /// <summary>
        /// Creates new answer records for CF based off answers from "entry" level Florida_NCSF_V2 and "mid" level CPG
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public void CreateAnswerRecordsFromCPGToCF(int assessmentId)
        {
            // get the titles 
            var convertableTitles = _context.NCSF_CONVERSION_MAPPINGS.Where(x => !string.IsNullOrEmpty(x.Mid_Level_Titles)).ToList();
            var entryIds = new List<int>();
            var fullIds = new List<int>();

            // seperates the columns into their own lists
            var entryTitlesUnparsed = convertableTitles.Where(x => !String.IsNullOrEmpty(x.Entry_Level_Titles)).OrderBy(x => x.Conversion_Id).Select(x => x.Entry_Level_Titles).ToList();
            var midTitlesUnparsed = convertableTitles.OrderBy(x => x.Conversion_Id).Select(x => x.Mid_Level_Titles).ToList();
            var fullTitlesUnparsed = convertableTitles.OrderBy(x => x.Conversion_Id).Select(x => x.Full_Level_Titles).ToList();

            foreach (var entryTitle in entryTitlesUnparsed)
            {
                entryIds.Add(_context.NEW_REQUIREMENT.Where(x => (x.Original_Set_Name == CF_CSF_SetName || x.Original_Set_Name == CF_SetName) 
                    && x.Requirement_Title == entryTitle).Select(x => x.Requirement_Id).FirstOrDefault());
            }

            // need the "entry" level answers for the couple entry questions that don't get fed into by CPGs when brought back into the full

            var newFullAnswerDict = new Dictionary<int, ANSWER>();

            var alreadyInDbList = new List<int>();

            if (convertableTitles != null)
            {
                for (int i = 0; i < midTitlesUnparsed.Count; i++)
                {

                    string csvMidTitles = midTitlesUnparsed[i];
                    var midTitles = csvMidTitles.Split(',');

                    string csvFullTitles = fullTitlesUnparsed[i];
                    var fullTitles = csvFullTitles.Split(',');

                    for (int j = 0; j < midTitles.Length; j++)
                    {
                        string midTitle = midTitles[j];
                        int cpgQId = _context.MATURITY_QUESTIONS.Where(x => x.Maturity_Model_Id == CPG_Model_Id && x.Question_Title == midTitle).Select(x => x.Mat_Question_Id).FirstOrDefault();
                        ANSWER cpgAns = _context.ANSWER.Where(x => x.Assessment_Id == assessmentId && x.Question_Or_Requirement_Id == cpgQId).FirstOrDefault();

                        foreach (string fullTitle in fullTitles)
                        {
                            int fullQId = _context.NEW_REQUIREMENT.Where(x => (x.Original_Set_Name == CF_CSF_SetName || x.Original_Set_Name == CF_SetName) && x.Requirement_Title == fullTitle).Select(x => x.Requirement_Id).FirstOrDefault();
                            if (fullQId > 0)
                            {
                                fullIds.Add(fullQId);
                                var alreadyInDb = _context.ANSWER.Where(x => x.Assessment_Id == assessmentId && x.Question_Or_Requirement_Id == fullQId).FirstOrDefault();
                                if (alreadyInDb != null)
                                {
                                    // if we haven't looked at this yet, add it to the "looked-at" list 
                                    if (!alreadyInDbList.Contains(fullQId))
                                    {
                                        alreadyInDbList.Add(fullQId);
                                        alreadyInDb.Answer_Text = cpgToCfAnswer(cpgAns.Answer_Text);
                                    }
                                    // compare the existing answer text to this new one and take the smallest value
                                    if (Int32.TryParse(alreadyInDb.Answer_Text, out int alreadyInDbVal) &&
                                        Int32.TryParse(cpgToCfAnswer(cpgAns.Answer_Text), out int cpgAnsVal))
                                    {
                                        alreadyInDb.Answer_Text = Int32.Min(alreadyInDbVal, cpgAnsVal).ToString();
                                    }
                                }
                                else
                                {
                                    ANSWER newAns = new ANSWER()
                                    {
                                        Assessment_Id = assessmentId,
                                        Question_Or_Requirement_Id = fullQId,
                                        Mark_For_Review = cpgAns.Mark_For_Review,
                                        Comment = cpgAns.Comment,
                                        Alternate_Justification = cpgAns.Alternate_Justification,
                                        Answer_Text = cpgToCfAnswer(cpgAns.Answer_Text),
                                        Reviewed = cpgAns.Reviewed,
                                        FeedBack = cpgAns.FeedBack,
                                        Question_Type = "Requirement",
                                        Is_Requirement = true,
                                        Is_Component = false,
                                        Is_Maturity = false
                                    };

                                    if (!newFullAnswerDict.TryAdd(fullQId, newAns))
                                    {
                                        // compare the existing answer text to this new one and take the smallest value
                                        ANSWER existingAns = newFullAnswerDict[fullQId];

                                        if (Int32.TryParse(existingAns.Answer_Text, out int existingAnsVal) &&
                                            Int32.TryParse(newAns.Answer_Text, out int newAnsVal))
                                        {
                                            newAns.Answer_Text = Int32.Min(existingAnsVal, newAnsVal).ToString();
                                            newFullAnswerDict[fullQId] = newAns;
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                }
                List<ANSWER> temp = newFullAnswerDict.Select(x => x.Value).ToList();

                // if a "Y" from the "Entry" level, but has no CPG feeding into the "Full" level, make it a 2 (per Ollie)
                var answerList = _context.ANSWER.Where(x => x.Assessment_Id == assessmentId && entryIds.Contains(x.Question_Or_Requirement_Id) 
                    && !fullIds.Contains(x.Question_Or_Requirement_Id)).ToList();
               
                foreach (var answer in answerList)
                {
                    if (answer.Answer_Text == "Y")
                    {
                        answer.Answer_Text = "2";
                    }
                }
                

                //alreadyInDbList.ForEach(x => 
                //    {
                //        if (x.Answer_Text == "Y")
                //        {
                //            x.Answer_Text = "2";
                //        }
                //    }
                //);

                _context.ANSWER.AddRange(temp);
                _context.SaveChanges();
            }
            //if (convertableTitles != null)
            //{
            //    // var midIds = _context.MATURITY_QUESTIONS.Where(x => midTitles.Contains(x.Question_Title) && x.Maturity_Model_Id == CPG_Model_Id).Select(x => x.Mat_Question_Id).ToList();
            //    var midWholeQuestion = _context.MATURITY_QUESTIONS.Where(x => midTitles.Contains(x.Question_Title) && x.Maturity_Model_Id == CPG_Model_Id).ToList();
            //    var midIds = midWholeQuestion.Select(x => x.Mat_Question_Id).ToList();


            //    var midAnswers = _context.ANSWER.Where(x => midIds.Contains(x.Question_Or_Requirement_Id) && x.Assessment_Id == assessmentId).ToList();



                //if (midIds != null)
                //{
                //    var addedIds = new List<int>();
                //    var newFullAnswers = new List<ANSWER>();
                //    for (int i = 0; i < midIds.Count; i++)
                //    {
                //        if (midAnswers[i].Answer_Text != "U")
                //        {
                //            var fullQuestionTitles = convertableTitles.Where(x => x.) [i].Full_Level_Titles.Split(",");
                //            foreach (var questionTitle in fullQuestionTitles)
                //            {
                //                var id = _context.NEW_REQUIREMENT
                //                    .Where(x => (x.Original_Set_Name == CF_CSF_SetName || x.Original_Set_Name == CF_SetName) && x.Requirement_Title == questionTitle)
                //                    .Select(x => x.Requirement_Id).FirstOrDefault();

                //                // if the id is null (i.e. a parent question or grouping), skip it
                //                if (id == 0)
                //                {
                //                    continue;
                //                }

                //                var newAnswer = new ANSWER()
                //                {
                //                    Assessment_Id = assessmentId,
                //                    Question_Or_Requirement_Id = id,
                //                    Mark_For_Review = midAnswers[i].Mark_For_Review,
                //                    Comment = midAnswers[i].Comment,
                //                    Alternate_Justification = midAnswers[i].Alternate_Justification,
                //                    Answer_Text = cpgToCfAnswer(midAnswers[i].Answer_Text),
                //                    Reviewed = midAnswers[i].Reviewed,
                //                    FeedBack = midAnswers[i].FeedBack,
                //                    Question_Type = "Requirement",
                //                    Is_Requirement = true,
                //                    Is_Component = false,
                //                    Is_Maturity = false
                //                };
                //                var leastLevel = "7";

                //                // prevents doubling-up of ANSWER records if question already has a record from the entry version of the assessment
                //                var entryAnswer = _context.ANSWER.Where(x => x.Assessment_Id == assessmentId && x.Question_Or_Requirement_Id == newAnswer.Question_Or_Requirement_Id).FirstOrDefault();
                //                if (entryAnswer != null)
                //                {
                //                    if (entryAnswer.Answer_Text == "Y" && entryAnswer.Is_Requirement == true)
                //                    {
                //                        leastLevel = "3";
                //                        //entryAnswer.Answer_Text = "3";
                //                    }
                //                    else if (entryAnswer.Answer_Text == "N")
                //                    {
                //                        leastLevel = "1";
                //                        //entryAnswer.Answer_Text = "1";
                //                    }
                //                    else
                //                    {
                //                        // somehow a CPG snuck in and was answered "Implemented"
                //                        leastLevel = "7";
                //                        //entryAnswer.Answer_Text = "7";
                //                    }
                //                    entryAnswer.Answer_Text = leastLevel;
                //                }
                //                // prevents doubling-up of ANSWER records if questions can be controlled by multiple sources
                //                else if (addedIds.Contains(newAnswer.Question_Or_Requirement_Id))
                //                {
                //                    var answerRecord = newFullAnswers.Find(x => x.Question_Or_Requirement_Id == newAnswer.Question_Or_Requirement_Id);
                //                    if (answerRecord.Answer_Text != newAnswer.Answer_Text)
                //                    {
                //                        Int32.TryParse(cpgToCfAnswer(answerRecord.Answer_Text), out int leastAnsInt);
                //                        if (leastAnsInt == null || leastAnsInt == 0)
                //                        {
                //                            leastAnsInt = 7;
                //                        }

                //                        if (Int32.TryParse(cpgToCfAnswer(answerRecord.Answer_Text), out int prevAnsInt) 
                //                        && Int32.TryParse(cpgToCfAnswer(newAnswer.Answer_Text), out int newAnsInt))
                //                        {
                //                            leastLevel = Int32.Min(leastAnsInt, Int32.Min(prevAnsInt, newAnsInt)).ToString();
                //                        }
                //                        else if (Int32.TryParse(cpgToCfAnswer(answerRecord.Answer_Text), out prevAnsInt))
                //                        {
                //                            leastLevel = Int32.Min(leastAnsInt, prevAnsInt).ToString();
                //                        }
                //                        else if (Int32.TryParse(cpgToCfAnswer(newAnswer.Answer_Text), out newAnsInt))
                //                        {
                //                            leastLevel = Int32.Min(leastAnsInt, newAnsInt).ToString();
                //                        }

                //                        answerRecord.Answer_Text = leastLevel;
                //                    }
                //                    else
                //                    {
                //                        // answerRecord.Answer_Text = "1";
                //                    }
                //                }
                //                // if no duplications, add the answer to the to-be-added list
                //                else
                //                {
                //                    newFullAnswers.Add(newAnswer);
                //                    addedIds.Add(newAnswer.Question_Or_Requirement_Id);
                //                }
                //                if (entryAnswer != null)
                //                {
                //                    entryAnswer.Answer_Text = leastLevel;
                //                }

                //                if (entryAnswer != null && entryAnswer.Answer_Text == "Y")
                //                {
                //                    entryAnswer.Answer_Text = "3";
                //                }
                //            }
                //        }
                //    }

                //    _context.ANSWER.AddRange(newFullAnswers);
                //    _context.SaveChanges();
                //}
            //}


        }

        public string cpgToCfAnswer(string answerText)
        {
            switch (answerText) {
                case "Y":
                    // 7 for "Tested and Verified"
                    return "7";
                case "I":
                    // 6 for "Implementation in Process"
                    return "6";
                case "S":
                    // 3 for "Documented Policy"
                    return "3";
                case "N":
                    // 1 for "Not Performed"
                    return "1";
                default:
                    return "1";
            }
        }
    }
}
