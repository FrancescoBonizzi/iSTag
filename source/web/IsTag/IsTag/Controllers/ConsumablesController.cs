using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using IsTag.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;

namespace IsTag.Controllers
{
#if true
    [AllowAnonymous]
#endif
    public class ConsumablesController : ControllerBase
    {
        private readonly IConsumablesRepository _consumablesRepository;

        public ConsumablesController(IConsumablesRepository consumablesRepository)
        {
            _consumablesRepository = consumablesRepository;
        }

        public class Consumable
        {
            public string Name { get; set; }
            public string QRCode { get; set; }
            public string Status { get; set; }
            public string Category { get; set; }
            public string Description { get; set; }
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
            var cons = _consumablesRepository.GetConsumable(id);

            return cons == null ? (IActionResult)BadRequest() : Ok(new Consumable()
            {
                Category = cons.Category,
                Description = cons.Description,
                Name = cons.Name,
                Status = cons.Status
            });
        }

        public IActionResult MissingNotMissing(string id)
        {
            string res = null;
            try
            {
                res = _consumablesRepository.SetMissingNotMissing(id);
            }
            catch(Exception)
            {
                // TODO Loggala
                return BadRequest();
            }
            return Ok(res);
        }
    }
}