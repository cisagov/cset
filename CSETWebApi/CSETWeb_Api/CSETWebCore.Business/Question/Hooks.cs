//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Aggregation;
using CSETWebCore.Business.Observations;
using CSETWebCore.DataLayer.Model;
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
        private CSETContext _context;


        /// <summary>
        /// CTOR
        /// </summary>
        /// <param name="context"></param>
        /// <param name="assessmentUtil"></param>
        public Hooks(CSETContext context)
        {
            _context = context;
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
                new CompletionCounter(_context).CountMaturityCompletion(answer.AssessmentId);

                return HookMaturityQuestionAnswered(answer);
            }

            if (answer.Is_Requirement)
            {
                new CompletionCounter(_context).CountRequirementCompletion(answer.AssessmentId);

                return false;
            }

            if (answer.Is_Question)
            {
                new CompletionCounter(_context).CountSimpleQuestionCompletion(answer.AssessmentId);

                return false;
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
                var om = new ObservationsManager(_context, answer.AssessmentId);

                if (answer.AnswerText == "N")
                {
                    // build an Observation async and tell the front end to refresh their details
                    om.BuildAutoObservation(answer);
                    detailsChanged = true;
                }
                else
                {
                    // clear out any automatic Observations for the Answer
                    om.DeleteAutoObservation(answer);
                    detailsChanged = true;
                }
            }

            return detailsChanged;
        }


        /// <summary>
        /// Handles actions that should be taken when a maturity 
        /// target level is changed.
        /// </summary>
        public void HookTargetLevelChanged(int assessmentId)
        {
            new CompletionCounter(_context).CountMaturityCompletion(assessmentId);
        }

        /// <summary>
        /// Handles actions that should be taken when the SAL is changed.
        /// </summary>
        public void HookSalChanged(int assessmentId)
        {
            new CompletionCounter(_context).CountStandardsBasedCompletion(assessmentId);
        }


        /// <summary>
        /// Handles actions that should be taken when the questions/requirements mode is changed.
        /// </summary>
        /// <param name="assessmentId"></param>
        public void HookQuestionsModeChanged(int assessmentId)
        {
            new CompletionCounter(_context).CountStandardsBasedCompletion(assessmentId);
        }


        /// <summary>
        /// Handles actions that should be taken when a 
        /// grouping selection is changed.
        /// </summary>
        /// <param name="assessmentId"></param>
        public void HookGroupingSelectionChanged(int assessmentId)
        {
            new CompletionCounter(_context).CountMaturityCompletion(assessmentId);
        }
    }
}
