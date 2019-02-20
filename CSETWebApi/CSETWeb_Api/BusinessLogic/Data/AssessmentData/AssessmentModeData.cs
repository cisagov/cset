//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Helpers;
using DataLayerCore.Model;
using System;
using System.Diagnostics;
using System.Linq;

namespace CSET_Main.Data.AssessmentData
{
    public class AssessmentModeData
    {

        //Try and keep usage of these constants to this class
        public const String QUESTIONS_BASED_APPLICATION_MODE = "Questions Based";
        public const String REQUIREMENTS_BASED_APPLICATION_MODE = "Requirements Based";
        public const String NIST_FRAMEWORK_MODE = "Cybersecurity Framework Based";
        public const String NIST_OLD_MODE_ASSESSMENT = "NIST Framework Mode";//This only for assessments created between 6.0 and 6.1
        private CSET_Context DataContext;
        private STANDARD_SELECTION standard;

        public AssessmentModeData(CSET_Context assessmentContextHolder, int assessmentId)
        {
            this.DataContext = assessmentContextHolder;
            this.standard = this.DataContext.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            if (this.standard == null)
                this.standard = new STANDARD_SELECTION()
                {
                    Application_Mode = QUESTIONS_BASED_APPLICATION_MODE,
                    Assessment_Id = assessmentId,
                    Selected_Sal_Level = Constants.SAL_LOW
                };
        }

        public bool IsRequirement { get { return (standard.Application_Mode.Equals(REQUIREMENTS_BASED_APPLICATION_MODE)); } }
        public bool IsQuestion { get { return (standard.Application_Mode.Equals(QUESTIONS_BASED_APPLICATION_MODE)); } }
        public bool IsFramework { get { return (standard.Application_Mode.Equals(NIST_FRAMEWORK_MODE)); } }

        public StandardModeEnum GetAssessmentMode()
        {           
            if (standard.Application_Mode.Equals(QUESTIONS_BASED_APPLICATION_MODE))
            {
                return StandardModeEnum.Question;
            }
            else if (standard.Application_Mode.Equals(REQUIREMENTS_BASED_APPLICATION_MODE))
            {
                return StandardModeEnum.Requirement;
            }
            else if (standard.Application_Mode.Equals(NIST_FRAMEWORK_MODE))
            {
                return StandardModeEnum.NISTFramework;
            }
            else if (standard.Application_Mode.Equals(NIST_OLD_MODE_ASSESSMENT))
            {
                return StandardModeEnum.NISTFramework;
            }
            else
            {
                //CSETLogger.Error("Can't determine mode of assessment. ApplicationMode: " + standard.Application_Mode);
                Debug.Assert(false, "Can't determine mode of assessment. ApplicationMode: " + standard.Application_Mode);
                return StandardModeEnum.Question;

            }
        }

        public void SaveMode(StandardModeEnum standardMode)
        {          
            if (standardMode == StandardModeEnum.Question)
            {
                standard.Application_Mode = QUESTIONS_BASED_APPLICATION_MODE;       
            }
            else if (standardMode == StandardModeEnum.Requirement)
            {
                standard.Application_Mode = REQUIREMENTS_BASED_APPLICATION_MODE;       
            }
            else if (standardMode == StandardModeEnum.NISTFramework)
            {
                standard.Application_Mode = NIST_FRAMEWORK_MODE;

            }
            else
            {
                standard.Application_Mode = QUESTIONS_BASED_APPLICATION_MODE;
                //CSETLogger.Error("Can't determine mode of assessment. ApplicationMode: " + standardMode);
                Debug.Assert(false, "Can't determine mode of assessment. ApplicationMode: " + standardMode);
            }

            DataContext.SaveChanges();
        }

        public void SaveSortSet(string set)
        {
            standard.Sort_Set_Name = set;
            DataContext.SaveChanges();
        }

        public string GetSortSet()
        {
            if (standard != null)
                return standard.Sort_Set_Name;
            else
                return String.Empty;
        }
    }
}


