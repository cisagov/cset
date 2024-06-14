using Microsoft.AspNetCore.Mvc;

namespace CSETWebCore.Api.Controllers
{
    public class HomeACETController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
