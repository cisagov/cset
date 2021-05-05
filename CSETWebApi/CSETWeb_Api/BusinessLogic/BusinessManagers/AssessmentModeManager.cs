//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Helpers;
using CSETWebCore.DataLayer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers
{

    class AssessmentModeAttr : Attribute
    {
        internal AssessmentModeAttr(String dbValue)
        {
            this.DBValue = dbValue;
        }
        public string DBValue { get; private set; }
        
    }

    public enum AssessmentModeEnum
    {
        [AssessmentModeAttr("Questions Based")] QuestionsMode,
        [AssessmentModeAttr("Requirements Based")] RequirementsMode,
    }

    public static class AssessmentMode
    {
        public const string strQuestionsMode = "Questions Based";
        public const string strRequirementsMode = "Requirements Based"; 

        public static String GetDBValue(this AssessmentModeEnum p)
        {
            AssessmentModeAttr attr = GetAttr(p);
            return attr.DBValue;
        }

        public static bool EqualsDBValue(this AssessmentModeEnum p, string val)
        {
            return p.GetDBValue() == val ? true : false;
        }
        private static AssessmentModeAttr GetAttr(AssessmentModeEnum p)
        {
            return (AssessmentModeAttr)Attribute.GetCustomAttribute(ForValue(p), typeof(AssessmentModeAttr));
        }
        private static MemberInfo ForValue(AssessmentModeEnum p)
        {
            return typeof(AssessmentMode).GetField(Enum.GetName(typeof(AssessmentModeEnum), p));
        }
    }

    public class AssessmentModeAndSal
    {

        private Dictionary<String, String> fullNameToChar = new Dictionary<string, string>();
        private STANDARD_SELECTION selection; 
        
        public AssessmentModeAndSal(int assessmentId)
        {
            using (var db = new CSET_Context())
            {
                selection = db.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
                fullNameToChar = db.UNIVERSAL_SAL_LEVEL.ToDictionary(x => x.Full_Name_Sal, x => x.Universal_Sal_Level1);
            }
        }

        public bool IsRequirementMode()
        {
            return selection.Application_Mode.Equals(AssessmentMode.strRequirementsMode,StringComparison.CurrentCultureIgnoreCase);
        }

        public string GetSalLevel()
        {
            string rsal;
            if(fullNameToChar.TryGetValue(selection.Selected_Sal_Level, out rsal)){
                return rsal;
            }            
            return fullNameToChar[Constants.SAL_LOW];
        }
    }
}
