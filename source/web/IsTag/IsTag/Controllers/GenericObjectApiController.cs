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
    public class GenericObjectApiController : ControllerBase
    {
        
        public IActionResult Get(string id)
        {
            return Ok("Warehouse");
        }
    }
}