using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace IsTag.Controllers
{
#if true
    [AllowAnonymous]
#endif
    public class WarehouseController : ControllerBase
    {
        private readonly Random _random;

        public WarehouseController()
        {
            _random = new Random();
        }

        public class Owner
        {
            public string Name { get; set; }
            public string Email { get; set; }
        }
        public class WarehouseData
        {
            public string Name { get; set; }
            public string Category { get; set; }
            public Owner CurrentOwner { get; set; }
            public string Description { get; set; }
        }
        public IActionResult GetData(string id)
        {
            return Ok(new WarehouseData()
            {
                Name = "Oggetto",
                CurrentOwner = new Owner()
                {
                    Email = "t.eeeeeeee@isolutions.it",
                    Name = "Tèèèèèèèèèèè!"
                },
                Category = "PC",
                Description = "Questa descrizione descrive questo oggetto"
            });
        }

        public class OwnershipData
        {
            public DateTime ChangeDate { get; set; }
            public Owner Owner { get; set; }
        }
        public IActionResult GetHistoryByObject(string id)
        {
            return Ok(new[]
            {
                new OwnershipData()
                {
                    ChangeDate = new DateTime(2019, 1, 1, 13, 0, 0),
                    Owner = null
                },
                new OwnershipData()
                {
                    ChangeDate = new DateTime(2019, 2, 1, 13, 0, 0),
                    Owner = new Owner()
                    {
                        Email = "t.eeeeeeee@isolutions.it",
                        Name = "Tèèèèèèèèèèè!"
                    }
                },
                new OwnershipData()
                {
                    ChangeDate = new DateTime(2019, 3, 1, 13, 0, 0),
                    Owner = null
                }
            });
        }

        public class GiveData
        {
            public string QRCode { get; set; }
            public string Who { get; set; }
        }
        [HttpPost]
        public IActionResult Give([FromBody] GiveData giveTo)
        {
            var email = User.Identity.Name;
            return Ok(_random.Next() % 2 == 0 ? true : false);
        }
    }
}