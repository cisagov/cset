//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Business.Authorization;
using CSETWebCore.CryptoBuffer;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Module;
using CSETWebCore.Business.GalleryParser;

namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class ProtectedFeatureController : ControllerBase
    {
        

        private CSETContext _context;

        public ProtectedFeatureController(CSETContext context)
        {
            _context = context;
        }


        [HttpGet]
        [Route("api/EnableProtectedFeature/Features")]
        /// <summary>
        /// Returns the FAA module along with its 'locked' status.' 
        /// IsEncryptedModule is used to indicate a 'lockable' module; they are not actulaly encrypted.
        /// </summary>
        /// <returns></returns>
        public IActionResult GetFeatures()
        {
            var openFaaSets = _context.SETS.Where(s=> s.IsEncryptedModule).ToList();

            var result = new List<EnabledModule>();

            foreach (var s in openFaaSets)
            {
                result.Add(new EnabledModule() { 
                    ShortName = s.Short_Name,
                    FullName = s.Full_Name,
                    Unlocked = s.IsEncryptedModuleOpen ?? false
                });
            }

            return Ok(result);
        }


        [HttpPost]
        [Route("api/EnableProtectedFeature/unlockFeature")]
        /// <summary>
        /// Marks the FAA set as 'unlocked.'
        /// </summary>
        /// <returns></returns>
        public IActionResult EnableFAA(string set_name)
        {
            AddNewlyEnabledModules();

            var response = new { 
                Message = ""
            };
            return Ok(response);
        }
                   

        /// <summary>
        /// Marks the FAA set as 'unlocked.' Marks the corresponding gallery card as 'visible'.
        /// </summary>
        private void AddNewlyEnabledModules()
        {
            var sets2 = _context.SETS.Where(s => s.IsEncryptedModule);
            foreach (SETS sts in sets2)
            {
                sts.IsEncryptedModuleOpen = true;
            }

            var gallItems = _context.GALLERY_ITEM.Where(g => g.Gallery_Item_Id == 68 || g.Gallery_Item_Id == 69);
            foreach (GALLERY_ITEM gall in gallItems)
            {
                gall.Is_Visible = true;
            }
            
            _context.SaveChanges();
        }
    }
}
