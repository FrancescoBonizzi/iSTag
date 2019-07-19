using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;

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

        public IActionResult GetAll()
        {
            return Ok(new List<Consumable>()
            {
                new Consumable()
                {
                    Name = "PulisciCulo",
                    Status = new Random().Next() % 2 == 0 ? "Missing" : "NotMissing"
                },
                new Consumable()
                {
                    Name = "PulisciFiga",
                    Status = new Random().Next() % 2 == 0 ? "Missing" : "NotMissing"
                },
                new Consumable()
                {
                    Name = "PulisciCuore",
                    Status = new Random().Next() % 2 == 0 ? "Missing" : "NotMissing"
                },
                new Consumable()
                {
                    Name = "PulisciAnima",
                    Status = new Random().Next() % 2 == 0 ? "Missing" : "NotMissing"
                },
            });
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