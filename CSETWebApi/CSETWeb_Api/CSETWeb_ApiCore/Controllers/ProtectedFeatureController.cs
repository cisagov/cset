//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Business.Authorization;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Module;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.AspNetCore.Authorization;

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
        private readonly ITokenManager _tokenManager;

        public ProtectedFeatureController(CSETContext context, ITokenManager tokenManager)
        {
            _context = context;
            _tokenManager = tokenManager;
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
            var openFaaSets = _context.SETS.Where(s => s.IsEncryptedModule).ToList();

            var enabledModules = new List<EnabledModule>();

            foreach (var s in openFaaSets)
            {
                enabledModules.Add(new EnabledModule()
                {
                    ShortName = s.Short_Name,
                    FullName = s.Full_Name,
                    Unlocked = s.IsEncryptedModuleOpen
                });
            }

            return Ok(enabledModules);
        }


        [HttpPost]
        [Route("api/EnableProtectedFeature/enableModules")]
        /// <summary>
        /// Marks the FAA set as 'unlocked.'
        /// </summary>
        /// <returns></returns>
        public IActionResult EnableFAA(string set_name)
        {
            AddNewlyEnabledModules();

            var response = new
            {
                Message = ""
            };
            return Ok(response);
        }

        [HttpPost]
        [Route("api/EnableProtectedFeature/setCisaAssessorWorkflow")]
        /// <summary>
        /// Toggles the Cisa Assessor Workflow for the given user.
        /// </summary>
        /// <returns></returns>
        public IActionResult SetCisaAssessorWorkflow([FromBody] bool cisaWorkflowEnabled)
        {
            var userId = _tokenManager.GetCurrentUserId();
            var ak = _tokenManager.GetAccessKey();

            if (userId != null)
            {
                _context.USERS.Where(u => u.UserId == userId).FirstOrDefault().CisaAssessorWorkflow = cisaWorkflowEnabled;
            }
            else if (ak != null)
            {
                _context.ACCESS_KEY.Where(a => a.AccessKey == ak).FirstOrDefault().CisaAssessorWorkflow = cisaWorkflowEnabled;
            }

            _context.SaveChanges();

            var response = new
            {
                Message = "'CisaAssessorWorkflow' database property set successfully."
            };

            return Ok(response);
        }

        [HttpGet]
        [Route("api/EnableProtectedFeature/getCisaAssessorWorkflow")]
        /// <summary>
        /// Gets the status of the CISA assessor workflow for the current user.
        /// </summary>
        /// <returns></returns>
        public IActionResult GetCisaAssessorWorkflow()
        {
            var userId = _tokenManager.GetCurrentUserId();
            var ak = _tokenManager.GetAccessKey();

            // Assume false if we can't find the user or access key (they are probably on the login page).
            bool cisaWorkflowEnabled = false;

            if (userId != null)
            {
                var user = _context.USERS.Where(u => u.UserId == userId).FirstOrDefault();
                if (user != null)
                {
                    cisaWorkflowEnabled = user.CisaAssessorWorkflow;
                }
            }
            else if (ak != null)
            {
                var acesskey = _context.ACCESS_KEY.Where(a => a.AccessKey == ak).FirstOrDefault();
                if (acesskey != null)
                {
                    cisaWorkflowEnabled = acesskey.CisaAssessorWorkflow;
                }
            }

            return Ok(cisaWorkflowEnabled);
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
