using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace IsTag.Controllers
{
#if DEBUG
    [AllowAnonymous]
#endif
    public class DataController : ControllerBase
    {
        public IActionResult GetData(string id)
        {
            return Ok(@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque vestibulum interdum leo, a fermentum nunc dignissim at. Proin tempus elit ac metus dictum convallis. Quisque blandit sapien ac nibh fermentum, sed vestibulum nibh sagittis. Interdum et malesuada fames ac ante ipsum primis in faucibus. Praesent ut pulvinar turpis. Maecenas ut nisi sit amet est mattis euismod in a urna. Mauris fringilla, diam ut placerat finibus, diam quam hendrerit felis, non dapibus augue quam sed leo. Nulla accumsan diam a est faucibus porta.");
        }
    }
}