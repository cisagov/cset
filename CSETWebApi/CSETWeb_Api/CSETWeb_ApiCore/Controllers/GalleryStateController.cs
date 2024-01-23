//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
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
using System.Linq;

namespace CSETWebCore.Api.Controllers
{
    public class GalleryStateController : ControllerBase
    {
        private readonly CSETContext _context;
        private ITokenManager _tokenManager;
        private IGalleryState _stateManager;

        public GalleryStateController(CSETContext context,
            ITokenManager tokenManager,
            IGalleryState parser
           )
        {
            _context = context;
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
        [Route("api/gallery/getLayoutItems")]
        public IActionResult GetLayoutItems(string Layout_Name)
        {
            try
            {
                var query = from r in _context.GALLERY_ROWS
                            join g in _context.GALLERY_GROUP_DETAILS
                                on r.Group_Id equals g.Group_Id
                            join n in _context.GALLERY_GROUP
                                on g.Group_Id equals n.Group_Id
                            join i in _context.GALLERY_ITEM
                                on g.Gallery_Item_Guid equals i.Gallery_Item_Guid
                            where r.Layout_Name == Layout_Name
                                && r.Group_Id == g.Group_Id
                                && g.Group_Id == n.Group_Id
                                && g.Gallery_Item_Guid == i.Gallery_Item_Guid
                            orderby g.Group_Id, g.Gallery_Item_Guid ascending
                            select new GalleryItem(i, n.Group_Id)
                            {
                            };

                var responseList = query.ToList();
                return Ok(responseList);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }
    }
}
