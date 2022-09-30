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

        /// <summary>
        /// Clones the specified item
        /// </summary>
        /// <param name="Item_To_Clone"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/gallery/cloneItem")]
        public IActionResult CloneItem(GalleryItem Item_To_Clone)
        {
            try
            {
                return Ok(_stateManager.CloneGalleryItem(Item_To_Clone));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }


        /// <summary>
        /// Adds the item
        /// </summary>
        /// <param name="newIcon_File_Name_Small"></param>
        /// <param name="newIcon_File_Name_Large"></param>
        /// <param name="newDescription"></param>
        /// <param name="newTitle"></param>
        /// <param name="group"></param>
        /// <param name="columnId"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/gallery/addItem")]
        public IActionResult AddItem(string newIcon_File_Name_Small, string newIcon_File_Name_Large, string newDescription, string newTitle, string group, int columnId)
        {
            try
            {
                return Ok(_stateManager.AddGalleryItem(newIcon_File_Name_Small, newIcon_File_Name_Large, newDescription, newTitle, group, columnId));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        /// <summary>
        /// Deletes the item
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/gallery/deleteGalleryItem")]
        public IActionResult DeleteItem(int id)
        {
            try
            {
                _stateManager.DeleteGalleryItem(id);
                return Ok();
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        /// <summary>
        /// Deletes the item
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/gallery/deleteGalleryGroup")]
        public IActionResult DeleteGroup(int id)
        {
            try
            {
                _stateManager.DeleteGalleryGroup(id);
                return Ok();
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

        [HttpGet]
        [Route("api/gallery/getLayoutItems")]
        public IActionResult getLayoutItems(string Layout_Name)
        {
            try
            {
                var query = from r in _context.GALLERY_ROWS
                            join g in _context.GALLERY_GROUP_DETAILS
                                on r.Group_Id equals g.Group_Id
                            join n in _context.GALLERY_GROUP
                                on g.Group_Id equals n.Group_Id
                            join i in _context.GALLERY_ITEM
                                on g.Gallery_Item_Id equals i.Gallery_Item_Id
                            where r.Layout_Name == Layout_Name
                                && r.Group_Id == g.Group_Id
                                && g.Group_Id == n.Group_Id
                                && g.Gallery_Item_Id == i.Gallery_Item_Id
                            orderby g.Group_Id, g.Gallery_Item_Id ascending
                            select new GalleryItem(i) //START HERE - FIX "CSETWebCore.Model.NewFolder" to be Gallery related
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
