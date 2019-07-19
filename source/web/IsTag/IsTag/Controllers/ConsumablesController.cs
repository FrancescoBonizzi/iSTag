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
    public class ConsumablesController : ControllerBase
    {
        public class Consumable
        {
            public string Name { get; set; }
            public string Status { get; set; }
        }
        public IActionResult GetData(string id)
        {
            return Ok(new Consumable()
            {
                Name = "PulisciCulo",
                Status = new Random().Next() % 2 == 0 ? "Missing" : "NotMissing"
            });
        }

        public IActionResult MissingNotMissing(string id)
        {
            return Ok(new Random().Next() % 2 == 0 ? "Missing" : "NotMissing");
        }
    }
}