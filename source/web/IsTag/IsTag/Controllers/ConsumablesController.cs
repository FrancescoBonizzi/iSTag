using IsTag.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;

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
            var data = _consumablesRepository.GetAllConsumables();
            return Ok(data.Select(a => new Consumable()
            {
                Category = a.Category,
                Description = a.Description,
                Name = a.Name,
                QRCode = a.QRCode,
                Status = a.Status
            }));
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

        public class InsertConsumable
        {
            public string Name { get; set; }
            public string Category { get; set; }
            public string Description { get; set; }
        }
        [HttpPost]
        public IActionResult CreateConsumable([FromBody] InsertConsumable consumable)
        {
            var c = new Entities.Consumable()
            {
                Category = consumable.Category,
                Description = consumable.Description,
                Name = consumable.Name,
                Status = "NotMissing",
                QRCode = Guid.NewGuid().ToString()
            };

            try
            {
                _consumablesRepository.InsertConsumable(c);
                return Ok();
            }
            catch(Exception)
            {
                return BadRequest();
            }
        }
    }
}