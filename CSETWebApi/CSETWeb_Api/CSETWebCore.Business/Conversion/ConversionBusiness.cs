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
using DocumentFormat.OpenXml.Office2013.Excel;
using CSETWebCore.Business.AssessmentIO.Export;
using CSETWebCore.Business.AssessmentIO.Import;
using CSETWebCore.Helpers;
using Org.BouncyCastle.Security;
using System.IO;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Contact
{
    public class ConversionBusiness:IConversionBusiness
    {
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IImportManager _importManager;
        private ITokenManager _tokenManager;
        private IUtilities _utilities;

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
        public ConversionBusiness(IAssessmentUtil assessmentUtil, ITokenManager tokenManager, CSETContext context, IImportManager importManager)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
            _importManager = importManager;
            _tokenManager = tokenManager;
            

        }

        public bool IsLegacyCFFull(int assessmentId)
        {
            //saving the db lookup so far we think it can only be this value
            //D0C19648-00F5-4215-AF2D-C7EBD75FC578
            var assess = _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            if(assess == null) { return false; }
            return assess.GalleryItemGuid == new Guid("D0C19648-00F5-4215-AF2D-C7EBD75FC578");
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
            var availMaturity = _context.AVAILABLE_MATURITY_MODELS
                .Where(x => x.Assessment_Id == assessmentId && CPG_Model_Id == x.model_id && x.Selected).FirstOrDefault();

            if (availMaturity != null)
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

        public async Task ConvertLegacy(int assessmentId)
        {

            /**
             * Before here the upgrade script should grab 
             * all the old guids
             * 
             * Clone the assessment
             * update the answers for U to 0
             * update the answers for N to 1
             * update the answers for Y,A, NA to 2
             * update the guid to be the new guid
             * 
                new Guid CB818F86-9074-4B8A-8544-FFA946EAF1EA
                old GUID D0C19648-00F5-4215-AF2D-C7EBD75FC578
             */
            assessmentId = await DuplicateAssessment(assessmentId);
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

            //just call the stored proc
            await _context.Procedures.usp_CF_ConvertLegacyFullAsync(assessmentId);


            // add details_demographics flagging the assessment as a "used to be a CyberFlorida entry assessment"
            var biz = new DemographicBusiness(_context, _assessmentUtil);
            biz.SaveDD(assessmentId, "FORMER-CF-LEGACY-FULL", "true", null);

            // changing gallery guid to mid-level
            var assessment = _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            assessment.GalleryItemGuid = Guid.Parse("CB818F86-9074-4B8A-8544-FFA946EAF1EA");
            assessment.UseStandard = true;

            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(assessmentId);
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


        private async Task<int> DuplicateAssessment(int assessmentId)
        {
            AssessmentExportManager exportManager = new AssessmentExportManager(_context);
            var outFile = exportManager.ExportAssessment(assessmentId, ".zip");
             outFile.FileContents.Seek(0, SeekOrigin.Begin);
            
            return  await _importManager.ProcessCSETAssessmentImport(((MemoryStream)outFile.FileContents).ToArray(), 
                    _tokenManager.GetUserId(), _tokenManager.GetAccessKey(), _context);
            
            
        }

        /// <summary>
        /// Converts a Cyber Florida "entry" assessment to a mid-level
        /// assessment with CPG only.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public async Task<int> ConvertEntryToMid(int assessmentId)
        {
            assessmentId = await DuplicateAssessment(assessmentId);
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
                .Where(x => x.Assessment_Id == assessmentId && CF_CSF_SetNames.Contains(x.Set_Name) && x.Selected).FirstOrDefault();
            var availMaturity = _context.AVAILABLE_MATURITY_MODELS
                .Where(x => x.Assessment_Id == assessmentId && x.model_id == RRA_Model_Id && x.Selected).FirstOrDefault();

            if (availStandard != null)
            {
                _context.AVAILABLE_STANDARDS.Remove(availStandard);
                //availMaturity.Selected = false;
                if(availMaturity!=null)
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
            assessment.UseStandard = false;
            

            _context.SaveChanges();

            var assessInfo = _context.INFORMATION.Where(x => x.Id == assessmentId).FirstOrDefault();
            assessInfo.Assessment_Name += " (Upgraded)";
            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(assessmentId);
            return assessmentId;
        }

        public async Task<int> ConvertMidToFull(int assessmentId)
        {

            assessmentId = await DuplicateAssessment(assessmentId);
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
            assessment.UseStandard = true;

            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(assessmentId);

            var assessInfo = _context.INFORMATION.Where(x => x.Id == assessmentId).FirstOrDefault();
            assessInfo.Assessment_Name += " (Upgraded)";
            _context.SaveChanges();

            return assessmentId;
        }

        /// <summary>
        /// Creates new answer records for CPG based off answers from "entry" level Florida_NCSF_V2
        /// This is the basic to mid conversion.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        private void CreateAnswerRecordsFromCFToCPG(int assessmentId)
        {
            // get the titles 

            var convertableTitles = (from a in _context.NCSF_ENTRY_TO_MID
                                     join b in _context.NCSF_CONVERSION_MAPPINGS_ENTRY on a.Entry_Level_Titles equals b.Entry_Level_Titles
                                     join c in _context.NCSF_CONVERSION_MAPPINGS_MID on a.Mid_Level_Titles equals c.Mid_Level_Titles
                                     join ans in _context.Answer_Requirements on b.Requirement_Id equals ans.Question_Or_Requirement_Id
                                     where ans.Assessment_Id == assessmentId
                                     select new { b.Requirement_Id, c.Mat_Question_Id, ans }).ToList();

            // seperates the entry column into its own list
            

            if (convertableTitles != null)
            {
                var addedIds = new List<int>();
                var newMidAnswers = new List<ANSWER>();
                foreach (var entryAnswer in convertableTitles)
                {
                    if (entryAnswer.ans.Answer_Text != "U")
                    {  
                        var newAnswer = new ANSWER()
                        {
                            Assessment_Id = assessmentId,
                            Question_Or_Requirement_Id = entryAnswer.Mat_Question_Id,
                            Mark_For_Review = entryAnswer.ans.Mark_For_Review,
                            Comment = entryAnswer.ans.Comment,
                            Alternate_Justification = entryAnswer.ans.Alternate_Justification,
                            Answer_Text = entryAnswer.ans.Answer_Text == "Y" ? "S" : "N", // "S" for "Scoped", "N" for "Not Implemented"
                            Reviewed = entryAnswer.ans.Reviewed,
                            FeedBack = entryAnswer.ans.FeedBack,
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

                _context.ANSWER.AddRange(newMidAnswers);
                _context.SaveChanges();
                
            }


        }

      
        /// <summary>
        /// Creates new answer records for CF based off answers from "entry" level Florida_NCSF_V2 and "mid" level CPG
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public void CreateAnswerRecordsFromCPGToCF(int assessmentId)
        {
            // get the titles 
            var convertableTitles = (from a in _context.NCSF_FULL_TO_MID
                                     join b in _context.NCSF_CONVERSION_MAPPINGS_MID on a.Mid_Level_Titles equals b.Mid_Level_Titles
                                     join c in _context.NCSF_CONVERSION_MAPPINGS_FULL on a.Full_Level_Titles equals c.Full_Level_Titles
                                     join ans in _context.Answer_Maturity on b.Mat_Question_Id equals ans.Question_Or_Requirement_Id
                                     where ans.Assessment_Id == assessmentId 
                                     orderby b.Mat_Question_Id
                                     select new { b.Mat_Question_Id, c.Requirement_Id, ans }).ToList();

            
            // need the "entry" level answers for the couple entry questions that don't get fed into by CPGs when brought back into the full

            var newFullAnswerDict = new Dictionary<int, ANSWER>();
            var addedToDictList = new List<int>();

            if (convertableTitles != null)
            {
                var entryAnsList = _context.ANSWER.Where(x => x.Assessment_Id == assessmentId && x.Is_Requirement == true).ToList();
                
                foreach (var entryAnswer in entryAnsList)
                {
                    entryAnswer.Answer_Text = entryToCfAnswer(entryAnswer.Answer_Text);
                }

                foreach (var titleRow in convertableTitles)
                {
                    
                    if (titleRow.ans != null)
                    {   
                        ANSWER ansToAdd = new ANSWER()
                        {
                            Assessment_Id = assessmentId,
                            Question_Or_Requirement_Id = titleRow.Requirement_Id,
                            Mark_For_Review = titleRow.ans.Mark_For_Review,
                            Comment = titleRow.ans.Comment,
                            Alternate_Justification = titleRow.ans.Alternate_Justification,
                            Answer_Text = cpgToCfAnswer(titleRow.ans.Answer_Text),
                            Reviewed = titleRow.ans.Reviewed,
                            FeedBack = titleRow.ans.FeedBack,
                            Question_Type = "Requirement",
                            Is_Requirement = true,
                            Is_Component = false,
                            Is_Maturity = false
                        };

                        // if we've already added this to the dict, take a closer look to determine the correct Answer_Text
                        if (newFullAnswerDict.TryGetValue(titleRow.Requirement_Id, out ANSWER existingAnswer))
                        {
                            // if the list doesn't have the ID, assume it's from the entry level
                            // and needs it's answer text overwritten by the CPG answer
                            //if (addedToDictList.Contains(titleRow.Requirement_Id))
                            //{
                                // compare the existing answer text to this new one and take the smallest value
                                if (Int32.TryParse(existingAnswer.Answer_Text, out int alreadyInDict) &&
                                    Int32.TryParse(ansToAdd.Answer_Text, out int incomingCpgAns))
                                {
                                    ansToAdd.Answer_Text = Int32.Min(alreadyInDict, incomingCpgAns).ToString();
                                }

                                // if incoming answer can't be parsed to an int and the existing can, keep the existing
                                else if (!Int32.TryParse(ansToAdd.Answer_Text, out incomingCpgAns))
                                {
                                    ansToAdd = existingAnswer;
                                }
                            //}

                            newFullAnswerDict[titleRow.Requirement_Id] = ansToAdd;
                            addedToDictList.Add(titleRow.Requirement_Id);
                        }
                        else
                        {
                            var existingRecord = entryAnsList.Find(x => x.Question_Or_Requirement_Id == titleRow.Requirement_Id);
                            if (existingRecord != null)
                            {
                                // the answer record already exists in the DB (from the entry level), so update the record
                                existingRecord.Answer_Text = ansToAdd.Answer_Text;

                                // remove the record because it has been transitioned to a Full level answer
                                //entryAnsList.Remove(existingRecord);
                            }
                            else
                            {
                                // new answer record not in the DB, so we can add this to the DB at the end
                                newFullAnswerDict.Add(titleRow.Requirement_Id, ansToAdd);
                            }

                        }

                        
                    }
                    // the below else should never run, but just in case
                    else
                    {
                        ANSWER newAns = new ANSWER()
                        {
                            Assessment_Id = assessmentId,
                            Question_Or_Requirement_Id = titleRow.Requirement_Id,
                            Mark_For_Review = titleRow.ans.Mark_For_Review,
                            Comment = titleRow.ans.Comment,
                            Alternate_Justification = titleRow.ans.Alternate_Justification,
                            Answer_Text = titleRow.ans.Answer_Text,
                            Reviewed = titleRow.ans.Reviewed,
                            FeedBack = titleRow.ans.FeedBack,
                            Question_Type = "Requirement",
                            Is_Requirement = true,
                            Is_Component = false,
                            Is_Maturity = false
                        };

                        if (!newFullAnswerDict.TryAdd(titleRow.Requirement_Id, newAns))
                        {
                            // compare the existing answer text to this new one and take the smallest value
                            ANSWER existingAns = newFullAnswerDict[titleRow.Requirement_Id];

                            if (Int32.TryParse(existingAns.Answer_Text, out int existingAnsVal) &&
                                Int32.TryParse(newAns.Answer_Text, out int newAnsVal))
                            {
                                newAns.Answer_Text = Int32.Min(existingAnsVal, newAnsVal).ToString();
                                newFullAnswerDict[titleRow.Requirement_Id] = newAns;
                            }
                        }
                    }
                            
                }
                List<ANSWER> temp = newFullAnswerDict.Select(x => x.Value).ToList();

                _context.ANSWER.AddRange(temp);
                _context.SaveChanges();
            }
            
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


        public string entryToCfAnswer(string answerText)
        {
            switch (answerText)
            {
                case "A":
                case "Y":
                    // 2 for "Informally Performed" (didn't go through the CPG process, so can't infer anymore than a 2)
                    return "2";
                case "N":
                case "NA":
                    // 1 for "Not Performed"
                    return "1";
                case "U":
                    return "0";
                default:
                    return "1";
            }
        }
    }
}
