using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EmailController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public EmailController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet("dhsemail")]
        public IActionResult GetDHSEmail()
        {
            var dhsEmail = _configuration.GetValue<string>("Email:DHSEmail");
            if (string.IsNullOrEmpty(dhsEmail))
            {
                return Ok("test"); // 204 No Content
            }
            return Ok(dhsEmail);
        }
    }
}