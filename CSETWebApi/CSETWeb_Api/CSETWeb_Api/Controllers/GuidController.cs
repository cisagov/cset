using CSETWeb_Api.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;


namespace CSETWeb_Api.Controllers
{
    [CSETAuthorize]
    public class GuidController : ApiController
    {
        
        [Route("api/guid/requestblock")]
        [HttpGet]
        public List<Guid> GetABlockOfGuids([FromUri] int number=100)
        {
            List<Guid> guids = new List<Guid>();
            for(int i=0; i<number; i++)
            {
                guids.Add(Guid.NewGuid());
            }
            return guids;
        }
    }
}