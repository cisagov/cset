using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Interfaces.Framework;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Framework;
using System.Threading.Tasks;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class FrameworkController : ControllerBase
    {
        private readonly IFrameworkBusiness _framework;
        private readonly ITokenManager _token;

        public FrameworkController(IFrameworkBusiness framework, ITokenManager token)
        {
            _framework = framework;
            _token = token;
        }

        /// <summary>
        /// Returns a list of all displayable cybersecurity framework tiers.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/frameworks")]
        public async Task<IActionResult> GetFrameworks()
        {
            int assessmentId = await _token.AssessmentForUser();
            return Ok(_framework.GetFrameworks(assessmentId));
        }


        /// <summary>
        /// Persists the selected tier value to the database.
        /// </summary>
        [HttpPost]
        [Route("api/framework")]
        public async Task<IActionResult> PersistSelectedTierAnswer(TierSelection tier)
        {
            // In case nothing is sent, bail out gracefully
            if (tier == null)
            {
                return Ok();
            }

            int assessmentId = await _token.AssessmentForUser();
            await _framework.PersistSelectedTierAnswer(assessmentId, tier);
            return Ok();
        }
    }
}
