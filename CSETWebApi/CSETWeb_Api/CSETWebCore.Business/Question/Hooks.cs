//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Observations;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Question;
using System;
using System.Linq;


namespace CSETWebCore.Business.Question
{
    /// <summary>
    /// Central class for implementing various hooks.
    /// </summary>
    public class Hooks
    {
        private readonly IAssessmentUtil _assessmentUtil;
        private CSETContext _context;


        /// <summary>
        /// CTOR
        /// </summary>
        /// <param name="context"></param>
        /// <param name="assessmentUtil"></param>
        public Hooks(CSETContext context, IAssessmentUtil assessmentUtil)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
        }


        /// <summary>
        /// Provides a central place to sense answered question
        /// events and do something.
        /// Returns a boolean indicating if details have changed.
        /// </summary>
        public bool HookQuestionAnswered(Answer answer)
        {
            if (answer.Is_Maturity)
            {
                return HookMaturityQuestionAnswered(answer);
            }

            return false;
        }


        /// <summary>
        /// Handles events when a maturity answer has been saved.
        /// Returns a boolean indicating if details have changed.
        /// </summary>
        /// <param name="answer"></param>
        public bool HookMaturityQuestionAnswered(Answer answer)
        {
            bool detailsChanged = false;

            var models = _context.AVAILABLE_MATURITY_MODELS.Where(x => x.Assessment_Id == answer.AssessmentId && x.Selected).ToList();


            // is this assessment CISA VADR
            if (models.Select(x => x.model_id).Contains(Constants.Constants.Model_CISA_VADR))
            {
                if (answer.AnswerText == "N")
                {
                    // build an Observation async and tell the front end to refresh their details

                    var om = new ObservationsManager(_context, answer.AssessmentId);
                    om.BuildAutoObservation(answer);
                    detailsChanged = true;
                }
                else
                {
                    // clear out any automatic Observation?  How can we tell?  We don't want to delete manually-added ones
                    // TODO:  



                    detailsChanged = true;
                }
            }

            return detailsChanged;
        }
    }
}
