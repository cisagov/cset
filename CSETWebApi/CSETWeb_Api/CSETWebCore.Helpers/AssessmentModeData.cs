//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Diagnostics;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Enum;
using CSETWebCore.Interfaces.Helpers;
using System.Linq;
using System;

namespace CSETWebCore.Helpers
{
    public class AssessmentModeData : IAssessmentModeData
    {
        private CSETContext _context;
        private readonly ITokenManager _tokenManager;

        private STANDARD_SELECTION standard;

        public const string QUESTIONS_BASED_APPLICATION_MODE = "Questions Based";
        public const string REQUIREMENTS_BASED_APPLICATION_MODE = "Requirements Based";
        public const string NIST_FRAMEWORK_MODE = "Cybersecurity Framework Based";
        public const string NIST_OLD_MODE_ASSESSMENT = "NIST Framework Mode"; //This only for assessments created between 6.0 and 6.1




        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        /// <param name="tokenManager"></param>
        public AssessmentModeData(CSETContext context, ITokenManager tokenManager)
        {
            _context = context;
            _tokenManager = tokenManager;
        }


        /// <summary>
        /// Lazily finds or creates a STANDARD_SELECTION record.
        /// We can't do this in the constructor because at that point there's
        /// no assessment in play yet.
        /// </summary>
        private STANDARD_SELECTION GetStandard()
        {
            try
            {
                int assessmentId = _tokenManager.AssessmentForUser();

                this.standard = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
            }

            if (this.standard == null)
            {
                this.standard = new STANDARD_SELECTION()
                {
                    Application_Mode = DetermineDefaultApplicationMode(),
                    Assessment_Id = 0,
                    Selected_Sal_Level = Constants.Constants.SAL_LOW
                };
            }

            return this.standard;
        }


        public bool IsRequirement
        {
            get
            {
                return (GetStandard().Application_Mode.Equals(REQUIREMENTS_BASED_APPLICATION_MODE));
            }
        }

        public bool IsQuestion
        {
            get
            {
                return (GetStandard().Application_Mode.Equals(QUESTIONS_BASED_APPLICATION_MODE));
            }
        }

        public bool IsFramework
        {
            get
            {
                return (GetStandard().Application_Mode.Equals(NIST_FRAMEWORK_MODE));
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public StandardModeEnum GetAssessmentMode()
        {


            if (GetStandard().Application_Mode.Equals(QUESTIONS_BASED_APPLICATION_MODE))
            {
                return StandardModeEnum.Question;
            }
            if (GetStandard().Application_Mode.Equals(REQUIREMENTS_BASED_APPLICATION_MODE))
            {
                return StandardModeEnum.Requirement;
            }
            if (GetStandard().Application_Mode.Equals(NIST_FRAMEWORK_MODE))
            {
                return StandardModeEnum.NISTFramework;
            }
            if (GetStandard().Application_Mode.Equals(NIST_OLD_MODE_ASSESSMENT))
            {
                return StandardModeEnum.NISTFramework;
            }

            //CSETLogger.Error("Can't determine mode of assessment. ApplicationMode: " + standard.Application_Mode);
            Debug.Assert(false, "Can't determine mode of assessment. ApplicationMode: " + standard.Application_Mode);
            return StandardModeEnum.Question;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="standardMode"></param>
        public void SaveMode(StandardModeEnum standardMode)
        {
            if (standardMode == StandardModeEnum.Question)
            {
                GetStandard().Application_Mode = QUESTIONS_BASED_APPLICATION_MODE;
            }
            else if (standardMode == StandardModeEnum.Requirement)
            {
                GetStandard().Application_Mode = REQUIREMENTS_BASED_APPLICATION_MODE;
            }
            else if (standardMode == StandardModeEnum.NISTFramework)
            {
                GetStandard().Application_Mode = NIST_FRAMEWORK_MODE;
            }
            else
            {
                GetStandard().Application_Mode = QUESTIONS_BASED_APPLICATION_MODE;
                //CSETLogger.Error("Can't determine mode of assessment. ApplicationMode: " + standardMode);
                Debug.Assert(false, "Can't determine mode of assessment. ApplicationMode: " + standardMode);
            }

            _context.SaveChanges();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="set"></param>
        public void SaveSortSet(string set)
        {
            GetStandard().Sort_Set_Name = set;
            _context.SaveChanges();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public string GetSortSet()
        {
            if (GetStandard() != null)
                return standard.Sort_Set_Name;
            else
                return string.Empty;
        }


        /// <summary>
        /// Normally default to Questions mode, 
        /// but ACET should default to Requirements mode.
        /// </summary>
        /// <returns></returns>
        public string DetermineDefaultApplicationMode()
        {
            string defaultMode = QUESTIONS_BASED_APPLICATION_MODE;

            // ACET defaults to Requirements mode
            string scope = _tokenManager.Payload("scope");

            if (scope == "ACET")
            {
                defaultMode = REQUIREMENTS_BASED_APPLICATION_MODE;
            }

            return defaultMode;
        }


        /// <summary>
        /// Returns the first character of the default application mode,
        /// 'Q' or 'R'.
        /// </summary>
        /// <returns></returns>
        public string DetermineDefaultApplicationModeAbbrev()
        {
            return DetermineDefaultApplicationMode().Substring(0, 1);
        }

    }
}