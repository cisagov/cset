using CSETWebCore.Business.GalleryParser;
using CSETWebCore.Business.Standards;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Interfaces.Standards;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;

namespace CSETWebCore.Api.Controllers
{

    public class GalleryStateController : ControllerBase
    {
        private ITokenManager _tokenManager;
        private IGalleryStateParser _parser;

        public GalleryStateController(ITokenManager tokenManager, IGalleryStateParser parser
           )
        {
            _tokenManager = tokenManager;
            _parser = parser;
          
        }

        /// <summary>
        /// Persists the current Standards selection in the database.
        /// </summary>
        [HttpPost]
        [Route("api/cardid/setstate")]
        public IActionResult PersistSelectedStandards([FromBody] int GalleryItemId)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            try
            {
                _parser.ProcessParserState(assessmentId, GalleryItemId);
                return Ok();
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }
    }
}
