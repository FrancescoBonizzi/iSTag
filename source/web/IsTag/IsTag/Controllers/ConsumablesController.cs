using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using IsTag.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

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
            public string Status { get; set; }
            public string Category { get; set; }
            public string Description { get; set; }
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