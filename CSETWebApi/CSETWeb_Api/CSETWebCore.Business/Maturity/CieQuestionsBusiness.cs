using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Nested;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Maturity
{
    public class CieQuestionsBusiness
    {
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly int _assessmentId;

        /// <summary>
        /// The internal ID for the CIE model
        /// </summary>
        private readonly int _cieModelId = 17;
        public CieQuestionsBusiness(CSETContext context, IAssessmentUtil assessmentUtil, int assessmentId = 0)
        {
            this._context = context;
            this._assessmentUtil = assessmentUtil;
            this._assessmentId = assessmentId;
        }


        /// <summary>
        /// Returns a list of assessments that use the CIE model.
        /// The list is limited to assessments that the current user has access to.
        /// </summary>
        /// <returns></returns>
        public CisAssessmentsResponse GetMyCieAssessments(int assessmentId, int? userId)
        {
            var resp = new CisAssessmentsResponse();


            // Get the baseline assessment if one is selected
            var info = _context.INFORMATION.Where(x => x.Id == assessmentId).FirstOrDefault();
            if (info != null)
            {
                resp.BaselineAssessmentId = info.Baseline_Assessment_Id;
            }

            // we can expect to find this record for the current user and assessment.
            List<int> ac = _context.ASSESSMENT_CONTACTS.Where(x => x.UserId == userId)
                .Select(x => x.Assessment_Id).ToList();


            var query = from amm in _context.AVAILABLE_MATURITY_MODELS
                        join a in _context.ASSESSMENTS on amm.Assessment_Id equals a.Assessment_Id
                        join i in _context.INFORMATION on amm.Assessment_Id equals i.Id
                        where amm.model_id == _cieModelId
                            && amm.Selected == true
                            && ac.Contains(a.Assessment_Id)
                        select new { a, i };

            foreach (var l in query.ToList())
            {
                resp.MyCisAssessments.Add(new AssessmentDetail()
                {
                    Id = l.a.Assessment_Id,
                    AssessmentDate = l.a.Assessment_Date,
                    AssessmentName = l.i.Assessment_Name,
                    AssessmentDescription = l.i.Assessment_Description,
                    CreatedDate = l.a.AssessmentCreatedDate,
                    LastModifiedDate = l.a.LastModifiedDate ?? DateTime.MinValue
                });
            }

            return resp;
        }
    }
}
