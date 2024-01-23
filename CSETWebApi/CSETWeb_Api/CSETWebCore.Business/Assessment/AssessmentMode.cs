//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CSETWebCore.DataLayer.Model;
using System.Threading.Tasks;
using CSETWebCore.Enum;
using CSETWebCore.Interfaces.Helpers;

namespace CSETWebCore.Business.Assessment
{
    /// <summary>
    /// Knows about questions and requirements modes.  
    /// </summary>
    public class AssessmentMode
    {
        //Try and keep usage of these constants to this class
        public const String QUESTIONS_BASED_APPLICATION_MODE = "Questions Based";
        public const String REQUIREMENTS_BASED_APPLICATION_MODE = "Requirements Based";
        public const String NIST_FRAMEWORK_MODE = "Cybersecurity Framework Based";
        public const String NIST_OLD_MODE_ASSESSMENT = "NIST Framework Mode";//This only for assessments created between 6.0 and 6.1
        private STANDARD_SELECTION standard;


        private readonly CSETContext _context;
        private readonly ITokenManager _tokenManager;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public AssessmentMode(CSETContext context, ITokenManager tokenManager)
        {
            _context = context;
            _tokenManager = tokenManager;

            int assessmentId = _tokenManager.AssessmentForUser();

            this.standard = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            if (this.standard == null)
                this.standard = new STANDARD_SELECTION()
                {
                    Application_Mode = DetermineDefaultApplicationMode(),
                    Assessment_Id = assessmentId,
                    Selected_Sal_Level = Constants.Constants.SAL_LOW
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
                // Debug.Assert(false, "Can't determine mode of assessment. ApplicationMode: " + standard.Application_Mode);
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
                // Debug.Assert(false, "Can't determine mode of assessment. ApplicationMode: " + standardMode);
            }

            _context.SaveChanges();
        }


        public void SaveSortSet(string set)
        {
            standard.Sort_Set_Name = set;
            _context.SaveChanges();
        }


        public string GetSortSet()
        {
            if (standard != null)
                return standard.Sort_Set_Name;
            else
                return String.Empty;
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
