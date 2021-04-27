using System.Diagnostics;
using CSETWebCore.Enum;
using CSETWebCore.Interfaces.Helpers;
using DataLayerCore.Model;

namespace CSETWebCore.Helpers
{
    public class AssessmentModeData
    {
        private CSET_Context _context;
        private readonly ITokenManager _tokenManager;

        public const string QUESTIONS_BASED_APPLICATION_MODE = "Questions Based";
        public const string REQUIREMENTS_BASED_APPLICATION_MODE = "Requirements Based";
        public const string NIST_FRAMEWORK_MODE = "Cybersecurity Framework Based";
        public const string NIST_OLD_MODE_ASSESSMENT = "NIST Framework Mode"; //This only for assessments created between 6.0 and 6.1
        private CSET_Context DataContext;
        private STANDARD_SELECTION standard;

        public bool IsRequirement { get { return (standard.Application_Mode.Equals(REQUIREMENTS_BASED_APPLICATION_MODE)); } }
        public bool IsQuestion { get { return (standard.Application_Mode.Equals(QUESTIONS_BASED_APPLICATION_MODE)); } }
        public bool IsFramework { get { return (standard.Application_Mode.Equals(NIST_FRAMEWORK_MODE)); } }

        public AssessmentModeData(CSET_Context context, ITokenManager tokenManager)
        {
            _context = context;
            _tokenManager = tokenManager;
        }

        public StandardModeEnum GetAssessmentMode()
        {
            if (standard.Application_Mode.Equals(QUESTIONS_BASED_APPLICATION_MODE))
            {
                return StandardModeEnum.Question;
            }
            if (standard.Application_Mode.Equals(REQUIREMENTS_BASED_APPLICATION_MODE))
            {
                return StandardModeEnum.Requirement;
            }
            if (standard.Application_Mode.Equals(NIST_FRAMEWORK_MODE))
            {
                return StandardModeEnum.NISTFramework;
            }
            if (standard.Application_Mode.Equals(NIST_OLD_MODE_ASSESSMENT))
            {
                return StandardModeEnum.NISTFramework;
            }
            
            //CSETLogger.Error("Can't determine mode of assessment. ApplicationMode: " + standard.Application_Mode);
            Debug.Assert(false, "Can't determine mode of assessment. ApplicationMode: " + standard.Application_Mode);
            return StandardModeEnum.Question;
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

    }
}