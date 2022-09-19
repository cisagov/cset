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
        private IGalleryState _stateManager;

        public GalleryStateController(ITokenManager tokenManager, 
            IGalleryState parser            
           )
        {
            _tokenManager = tokenManager;
            _stateManager = parser;          
        }


        /// <summary>
        /// Returns the gallery card structure
        /// </summary>
        /// <param name="Layout_Name"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/gallery/getboard")]
        public IActionResult GetBoard(string Layout_Name)
        {
            try
            {   
                return Ok(_stateManager.GetGalleryBoard(Layout_Name));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [HttpGet]
        [Route("api/gallery/getLayouts")]
        public IActionResult getLayouts()
        {
            try { 
                return Ok(_stateManager.GetLayout());
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }
    }
}
