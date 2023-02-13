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

    /** 
     * TODO: The functionality of this controller is now outdated since we only expose sets
     * to the user through gallery cards. We need to add some sort of column to GALLERY_ITEM
     * indicating if a card includes protected sets and should be hidden unless the protected features option
     * is enabled within CSET. For now, we are hard coding the Gallery_Item_Guids for the cards that we
     * want to reveal by setting the Is_Visible column to true. 
     */
   

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
        /// IsEncryptedModule is used to indicate a 'lockable' module; they are not actually encrypted.
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

            // FAA_MAINT: GUID = 4EE4C330-5A4C-42F0-8584-5188EDDA4E95; FAA_PED_V2: GUID = 4929452F-A737-4AFC-9778-CE8D550DF305
            var gallItems = _context.GALLERY_ITEM.Where(g => g.Gallery_Item_Guid.Equals(new Guid("4EE4C330-5A4C-42F0-8584-5188EDDA4E95")) || g.Gallery_Item_Guid.Equals(new Guid("4929452F-A737-4AFC-9778-CE8D550DF305")));
            foreach (GALLERY_ITEM gall in gallItems)
            {
                gall.Is_Visible = true;
            }
            _context.SaveChanges();
        }
    }
}
