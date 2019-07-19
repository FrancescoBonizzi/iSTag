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
            public string QRCode { get; set; }
            public string Status { get; set; }
            public string Description { get; set; }

            public bool IsMissing
            {
                get
                {
                    return Status == "Missing";
                }

                set
                {
                    if (value)
                    {
                        Status = "Missing";
                    }
                    else
                    {
                        Status = "NotMissing";
                    }
                }
            }

        }

        public IActionResult GetAll()
        {
            return Ok(new List<Consumable>()
            {
                new Consumable()
                {
                    Name = "PulisciCulo",
                    QRCode = "a",
                    Status = new Random().Next() % 2 == 0 ? "Missing" : "NotMissing",
                    Description = "Lorem ipsum bla bla bla bla bla bla bla bla bla bla bla bla bla bla"
                },
                new Consumable()
                {
                    Name = "PulisciFiga",
                    QRCode = "b",
                    Status = new Random().Next() % 2 == 0 ? "Missing" : "NotMissing",
                    Description = "Lorem ipsum bla bla bla bla bla bla bla bla bla bla bla bla bla bla"
                },
                new Consumable()
                {
                    Name = "PulisciCuore",
                    QRCode = "c",
                    Status = new Random().Next() % 2 == 0 ? "Missing" : "NotMissing",
                    Description = "Lorem ipsum bla bla bla bla bla bla bla bla bla bla bla bla bla bla"
                },
                new Consumable()
                {
                    Name = "PulisciAnima",
                    QRCode = "d",
                    Status = new Random().Next() % 2 == 0 ? "Missing" : "NotMissing",
                    Description = "Lorem ipsum bla bla bla bla bla bla bla bla bla bla bla bla bla bla"
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