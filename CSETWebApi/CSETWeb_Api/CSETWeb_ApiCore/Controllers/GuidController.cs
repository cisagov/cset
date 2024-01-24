//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

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
