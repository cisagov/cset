//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class GuidController : ControllerBase
    {
        [Route("api/guid/requestblock")]
        [HttpGet]
        public IActionResult GetABlockOfGuids(int number = 100)
        {
            List<Guid> guids = new List<Guid>();
            for (int i = 0; i < number; i++)
            {
                guids.Add(Guid.NewGuid());
            }
            return Ok(guids);
        }
    }
}
