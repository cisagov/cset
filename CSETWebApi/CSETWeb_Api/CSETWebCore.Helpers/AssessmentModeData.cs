using System.Diagnostics;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Enum;
using CSETWebCore.Interfaces.Helpers;
using System.Linq;
using System;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

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
        private async Task<STANDARD_SELECTION> GetStandard()
        {
            try
            {
                int assessmentId = await _tokenManager.AssessmentForUser();

                this.standard = await _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).FirstOrDefaultAsync();
            }
            catch (Exception exc)
            {
                log4net.LogManager.GetLogger(this.GetType()).Error($"... {exc}");
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
                return GetIsRequirement();
            }
        }

        public bool IsQuestion
        {
            get
            {
                return GetIsQuestion();
            }
        }

        public bool IsFramework
        {
            get
            {
                return GetIsFramework();
            }
        }


        public bool GetIsRequirement()
        {
            var standard = GetStandard().Result;
            return standard.Application_Mode.Equals(REQUIREMENTS_BASED_APPLICATION_MODE);
        }


        public bool GetIsQuestion()
        {
            var standard = GetStandard().Result;
            return standard.Application_Mode.Equals(QUESTIONS_BASED_APPLICATION_MODE);
        }

        public bool GetIsFramework()
        {
            var standard = GetStandard().Result;
            return standard.Application_Mode.Equals(NIST_FRAMEWORK_MODE);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public async Task<StandardModeEnum> GetAssessmentMode()
        {
            var standard = await GetStandard();

            switch(standard.Application_Mode)
            {
                case QUESTIONS_BASED_APPLICATION_MODE:
                    return StandardModeEnum.Question;                    
                case REQUIREMENTS_BASED_APPLICATION_MODE:
                    return StandardModeEnum.Requirement;
                case NIST_FRAMEWORK_MODE:
                case NIST_OLD_MODE_ASSESSMENT:
                    return StandardModeEnum.NISTFramework;
            }
            Debug.Assert(false, "Can't determine mode of assessment. ApplicationMode: " + standard.Application_Mode);
            return StandardModeEnum.Question;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="standardMode"></param>
        public async Task SaveMode(StandardModeEnum standardMode)
        {
            var standard = await GetStandard();

            switch(standardMode)
            {
                case StandardModeEnum.Question:
                    standard.Application_Mode = QUESTIONS_BASED_APPLICATION_MODE;
                    break;
                case StandardModeEnum.Requirement:
                    standard.Application_Mode = REQUIREMENTS_BASED_APPLICATION_MODE;
                    break;
                case StandardModeEnum.NISTFramework:
                    standard.Application_Mode = NIST_FRAMEWORK_MODE;
                    break;
                default:
                    standard.Application_Mode = QUESTIONS_BASED_APPLICATION_MODE;
                    Debug.Assert(false, "Can't determine mode of assessment. ApplicationMode: " + standardMode);
                    break;

            }
            await _context.SaveChangesAsync();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="set"></param>
        public async Task SaveSortSet(string set)
        {
            var standard = await GetStandard();
            standard.Sort_Set_Name = set;
            await _context.SaveChangesAsync();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public async Task<string> GetSortSet()
        {
            var standard = await GetStandard();
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