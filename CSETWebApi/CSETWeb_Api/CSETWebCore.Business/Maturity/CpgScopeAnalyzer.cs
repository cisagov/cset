using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Question;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Maturity
{
    /// <summary>
    /// Handles the determination of questions that are in scope.
    /// </summary>
    public class CpgScopeAnalyzer : QuestionScopeAnalyzer
    {
        private CSETContext _context;

        private readonly int _assessmentId;
        private string _techDomain;


        /// <summary>
        /// CTOR
        /// </summary>
        public CpgScopeAnalyzer(int assessmentId, CSETContext context)
        {
            _assessmentId = assessmentId;
            _context = context;

            // get the technical domain of the assessment
            var demog = new Demographic.DemographicExtBusiness(_context);
            _techDomain = demog.GetX(assessmentId, "TECH-DOMAIN")?.ToString();
        }


        /// <summary>
        /// Determines if a question is out of scope because it is specific
        /// to some assessment attribute.
        /// 
        /// Case 1:  The assessment is marked as "OT" for its technical domain, but the question is 
        ///          designed to hold an "IT" answer.  
        /// </summary>
        /// <returns></returns>
        public override bool IsQuestionInScope(QuestionAnswer qa)
        {
            var isIt = qa.Props.Any(x => x.Name == "IS-IT" && x.Value == "1");
            var isOt = qa.Props.Any(x => x.Name == "IS-OT" && x.Value == "1");

            // if the question is not flagged for either domain
            if (!isIt && !isOt)
            {
                return true;
            }

            switch (_techDomain)
            {
                case "IT":
                    return isIt;
                case "OT":
                    return isOt;
            }

            return true;
        }


        /// <summary>
        /// Returns a list of question IDs that are in scope
        /// </summary>
        /// <returns></returns>
        public override List<int> QuestionIdsInScope()
        {
            var isIt = _context.MATURITY_QUESTION_PROPS.Any(x => x.PropertyValue == "IS-IT" && x.PropertyValue == "1");
            var isOt = _context.MATURITY_QUESTION_PROPS.Any(x => x.PropertyValue == "IS-OT" && x.PropertyValue == "1");

            return new List<int>();
        }
    }
}
