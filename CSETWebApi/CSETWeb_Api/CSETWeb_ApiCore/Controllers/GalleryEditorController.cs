//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.GalleryParser;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class GalleryEditorController : ControllerBase
    {

        private readonly ITokenManager _token;
        private CSETContext _context;
        private IGalleryEditor _galleryEditor;

        // if you want to use the gallery editor, change this to true
        private bool inDev = true;

        public GalleryEditorController(ITokenManager token, IGalleryEditor galleryEditor, CSETContext context)
        {
            _token = token;
            _context = context;
            _galleryEditor = galleryEditor;
        }
        [HttpPost]
        [Route("api/galleryEdit/updatePosition")]
        public IActionResult updatePosition(MoveItem moveItem)
        {
            if (!inDev)
            {
                return Ok(200);
            }
            try
            {
                _galleryEditor.UpdatePosition(moveItem);
                return Ok();
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
        public IActionResult CloneItem(String Item_To_Clone, int Group_Id, bool New_Id)
        {
            if (!inDev)
            {
                return Ok(200);
            }
            try
            {
                Guid Item_To_Clone_Guid = Guid.Parse(Item_To_Clone);
                _galleryEditor.CloneGalleryItem(Item_To_Clone_Guid, Group_Id, New_Id);
                return Ok();
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
        [Route("api/gallery/cloneGroup")]
        public IActionResult CloneGroup(int Group_Id, string layout_Name)
        {
            if (!inDev)
            {
                return Ok(200);
            }
            try
            {
                _galleryEditor.CloneGalleryGroup(Group_Id, layout_Name);
                return Ok();
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        /// <summary>
        /// Adds the item
        /// </summary>
        /// <param name="newDescription"></param>
        /// <param name="newTitle"></param>
        /// <param name="newIconSmall"></param>
        /// <param name="newIconLarge"></param>
        /// <param name="newConfigSetup"></param>
        /// <param name="group_Id"></param>
        /// <param name="columnId"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/gallery/addItem")]
        public IActionResult AddItem(string newDescription, string newTitle, string newIconSmall, string newIconLarge, string newConfigSetup, int group_Id, int columnId)
        {
            if (!inDev)
            {
                return Ok(200);
            }

            try
            {
                _galleryEditor.AddGalleryItem(newIconSmall, newIconLarge, newDescription, newTitle, newConfigSetup, group_Id, columnId);
                return Ok();
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        /// <summary>
        /// Clones the specified item
        /// </summary>
        /// <param name="group"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/gallery/addGroup")]
        public IActionResult AddGroup(string group, string layout, string newDescription, string newTitle, string newIconSmall, string newIconLarge, string newConfigSetup, int columnId)
        {
            if (!inDev)
            {
                return Ok(200);
            }

            try
            {
                var group_id = _galleryEditor.AddGalleryGroup(group, layout);
                _galleryEditor.AddGalleryItem(newIconSmall, newIconLarge, newDescription, newTitle, newConfigSetup, group_id, columnId);
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
        [Route("api/gallery/deleteGalleryItem")]
        public IActionResult DeleteItem(string galleryItemGuid, int group_id)
        {
            if (!inDev)
            {
                return Ok(200);
            }
            try
            {
                Guid guid = Guid.Parse(galleryItemGuid);
                _galleryEditor.DeleteGalleryItem(guid, group_id);
                return Ok();
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [HttpGet]
        [Route("api/gallery/getlayouts")]
        public IActionResult GetLayouts()
        {
            if (!inDev)
            {
                return Ok(200);
            }
            try
            {

                return Ok(_galleryEditor.GetLayouts());
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
        public IActionResult DeleteGroup(int id, string layout)
        {
            if (!inDev)
            {
                return Ok(200);
            }
            try
            {
                _galleryEditor.DeleteGalleryGroup(id, layout);
                return Ok();
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }


        [HttpPost]
        [Route("api/galleryEdit/updateName")]
        public IActionResult UpdateName([FromBody] UpdateItem item)
        {
            if (!inDev)
            {
                return Ok(200);
            }
            try
            {
                if (item.IsGroup)
                {
                    var galleryGroup = _context.GALLERY_GROUP.Where(x => x.Group_Id == item.Group_Id).FirstOrDefault();
                    if (galleryGroup == null) return BadRequest();

                    galleryGroup.Group_Title = item.Value;
                    _context.SaveChanges();
                }
                else
                {
                    Guid guid = Guid.Parse(item.Gallery_Item_Guid);
                    var galleryItem = _context.GALLERY_ITEM.Where(x => x.Gallery_Item_Guid == guid).FirstOrDefault();
                    if (galleryItem == null) return BadRequest();

                    galleryItem.Title = item.Value;
                    _context.SaveChanges();
                }

                return Ok();
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }


        [HttpPost]
        [Route("api/galleryEdit/updateItem")]
        public IActionResult UpdateItem([FromBody] GALLERY_ITEM item)
        {
            if (!inDev)
            {
                return Ok(200);
            }
            try
            {

                var galleryItem = _context.GALLERY_ITEM.Where(x => x.Gallery_Item_Guid == item.Gallery_Item_Guid).FirstOrDefault();
                if (galleryItem == null) return BadRequest();

                galleryItem.Title = item.Title;
                galleryItem.Description = item.Description;
                galleryItem.Configuration_Setup = item.Configuration_Setup;
                galleryItem.Icon_File_Name_Large = item.Icon_File_Name_Large;
                galleryItem.Icon_File_Name_Small = item.Icon_File_Name_Small;
                galleryItem.Is_Visible = item.Is_Visible;

                _context.SaveChanges();


                return Ok();
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }


        /// <summary>
        /// Returns the gallery card structure
        /// </summary>
        /// <param name="Layout_Name"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/gallery/getUnused")]
        public IActionResult GetUnusedItems(string Layout_Name)
        {
            if (!inDev)
            {
                return Ok(200);
            }
            try
            {
                return Ok(_galleryEditor.GetUnused(Layout_Name));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }


    }

}
