using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IsTag.Controllers
{
    public class TestController : Controller
    {
        [AllowAnonymous]
        public IActionResult AreYouAlive()
        {
            if (User.Identity.IsAuthenticated)
            {
                return Ok($"Yes I am, {User.Identity.Name}!");
            }
            else
            {
                return Unauthorized("Who are you?!");
            }
        }
    }
}
