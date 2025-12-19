//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.Observations;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Model.Observations;
using Microsoft.AspNetCore.Mvc;
using Nelibur.ObjectMapper;
using System.Collections.Generic;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    [CsetAuthorize]
    public class ObservationsController : ControllerBase
    {
        private readonly ITokenManager _token;
        private readonly CSETContext _context;
        private readonly IQuestionRequirementManager _questionRequirement;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="token"></param>
        public ObservationsController(ITokenManager token, CSETContext context, IQuestionRequirementManager questionRequirement)
        {
            _token = token;
            _context = context;
            _questionRequirement = questionRequirement;
        }


        /// <summary>
        /// Returns all observations stored at the assessment level
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/observations/assessment-level")]
        public IActionResult GetAssessmentLevelObservations()
        {
            int assessmentId = _token.AssessmentForUser();

            var obsMgr = new ObservationsManager(_context, assessmentId);
            var obsList = obsMgr.GetAssessmentLevelObservations();

            return Ok(obsList);
        }


        /// <summary>
        /// Returns observations stored on the assessment's answers.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/observations/answer-level")]
        public IActionResult GetAnswerLevelObservations()
        {
            int assessmentId = _token.AssessmentForUser();

            var obsMgr = new ObservationsManager(_context, assessmentId);
            var obsList = obsMgr.GetAnswerLevelObservations(assessmentId);

            return Ok(obsList);
        }


        /// <summary>
        /// Note that this only populates the summary/title and finding id. 
        /// the rest is populated in a separate call. 
        /// </summary>
        /// <param name="Answer_Id"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/answer/observations")]
        public IActionResult GetObservationsForAnswer([FromQuery] int answerId)
        {
            int assessmentId = _token.AssessmentForUser();

            var obsMgr = new ObservationsManager(_context, assessmentId);
            var obsList = obsMgr.GetObservationsForAnswer(answerId);

            return Ok(obsList);
        }


        /// <summary>
        /// Gets an observation using the observation ID.
        /// </summary>
        [HttpGet]
        [Route("api/observation")]
        public IActionResult GetObservation([FromQuery] int answerId, [FromQuery] int observationId, [FromQuery] int questionId, [FromQuery] string questionType, [FromQuery] string scope)
        {
            int assessmentId = _token.AssessmentForUser();

            var fm2 = new ObservationsManager(_context, assessmentId);
            var obs = fm2.GetObservation(observationId);

            return Ok(obs);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/importancevalues")]
        public IActionResult GetImportance()
        {
            TinyMapper.Bind<IMPORTANCE, Importance>();
            List<Importance> rlist = new List<Importance>();
            foreach (IMPORTANCE import in _context.IMPORTANCE)
            {
                rlist.Add(TinyMapper.Map<IMPORTANCE, Importance>(import));
            }

            return Ok(rlist);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="observationId"></param>
        [HttpPost]
        [Route("api/observation/delete")]
        public IActionResult DeleteObservation([FromBody] int observationId)
        {
            int assessmentId = _token.AssessmentForUser();
            var fm = new ObservationsManager(_context, assessmentId);

            fm.DeleteObservation(observationId);

            return Ok();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="obs"></param>
        [HttpPost]
        [Route("api/observation/save")]
        public IActionResult SaveObservation([FromBody] Observation obs, [FromQuery] bool cancel = false, [FromQuery] bool merge = false)
        {
            int assessmentId = _token.AssessmentForUser();
            var fm = new ObservationsManager(_context, assessmentId);

            if (obs.AnswerLevel)
            {
                obs.Assessment_Id = null;
            }

            if (!obs.AnswerLevel)
            {
                obs.Assessment_Id = assessmentId;
                obs.Answer_Id = null;
            }


            if (obs.IsObservationEmpty(cancel))
            {
                fm.DeleteObservation(obs.Observation_Id);
                return Ok();
            }


            if (obs.AnswerLevel && obs.Answer_Id == null)
            {
                var answerId = fm.BuildEmptyAnswer(assessmentId, obs);
                obs.Answer_Id = answerId;
            }


            var id = fm.UpdateObservation(obs);

            var resp = new ObservationResponse();
            resp.ObservationId = id;
            resp.AnswerId = obs.Answer_Id;

            return Ok(resp);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="obs"></param>
        [HttpPost]
        [Route("api/CopyObservationIntoNewObservation")]
        public IActionResult CopyObservationIntoNewObservation([FromBody] Observation obs, [FromQuery] bool cancel = false)
        {
            int assessmentId = _token.AssessmentForUser();
            var obsMgr = new ObservationsManager(_context, assessmentId);

            if (obs.IsObservationEmpty(cancel))
            {
                obsMgr.DeleteObservation(obs.Observation_Id);
                return Ok();
            }

            var id = obsMgr.UpdateObservation(obs);

            return Ok(id);
        }


    }



    public class ObservationResponse
    {
        public int ObservationId { get; set; }
        public int? AnswerId { get; set; }
    }
}
