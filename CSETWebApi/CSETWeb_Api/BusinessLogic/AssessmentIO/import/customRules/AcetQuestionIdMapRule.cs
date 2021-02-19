using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using CSETWeb_Api.BusinessLogic.ImportAssessment;
using Newtonsoft.Json.Linq;


namespace CSETWeb_Api.BusinessLogic.AssessmentIO.import.customRules
{
    public class AcetQuestionIdMapRule : IImportAssessmentRule
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="jObj"></param>
        /// <param name="xTable"></param>
        /// <param name="dBIO"></param>
        public void ProcessRule(JToken jObj, XmlElement xTable, DBIO dBIO)
        {
            var j = 1;

            bool isReq = jObj["Is_Requirement"].Value<bool>();

            if (isReq)
            {
                int reqID = jObj["Question_Or_Requirement_Id"].Value<int>();

                int maturityQuestionID = ImportManagerACET.requirementToMaturity[reqID];

                jObj["Question_Or_Requirement_Id"] = maturityQuestionID;
                jObj["Question_Type"] = "Maturity";

            }
            else
            {
                var jjjjj = 1;
            }


        }
    }
}
