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
    public class WarehouseController : ControllerBase
    {
        private readonly Random _random;
        private readonly IWarehouseRepository _warehouseRepository;

        public WarehouseController(IWarehouseRepository warehouseRepository)
        {
            _random = new Random();
            _warehouseRepository = warehouseRepository;
        }

        public class Owner
        {
            public string Name { get; set; }
            public string Email { get; set; }
        }
        public class WarehouseData
        {
            public string QRCode { get; set; }
            public string Name { get; set; }
            public string Category { get; set; }
            public Owner CurrentOwner { get; set; }
            public string Description { get; set; }
            public string Picture { get; set; }
        }

        public IActionResult GetData(string id)
        {
            var wh = _warehouseRepository.GetWarehouseItem(id);
            return wh == null ? (IActionResult)BadRequest() : Ok(new WarehouseData()
            {
                Name = wh.Name,
                CurrentOwner = wh.CurrentOwner == null ? null : new Owner()
                {
                    Email = wh.CurrentOwner.Email,
                    Name = wh.CurrentOwner.Name
                },
                Category = wh.Category,
                Description = wh.Description,
                Picture = $"/Images/Image/{wh.ImageCode}"
            });
        }

        public class InsertWarehouse
        {
            public string Name { get; set; }
            public string Category { get; set; }
            public string Description { get; set; }
        }

        [HttpPost]
        public IActionResult Create([FromBody] InsertWarehouse request)
        {
            try
            {
                _warehouseRepository.InsertWarehouseItem(new Entities.WarehouseItem()
                {
                    Category = request.Category,
                    CurrentOwner = null,
                    Description = request.Description,
                    ImageCode = "Warehouse",
                    Name = request.Name,
                    QRCode = Guid.NewGuid().ToString()
                });
            }
            catch(Exception)
            {
                return BadRequest();
            }

            return Ok();
        }

        public class OwnershipData
        {
            public DateTime ChangeDate { get; set; }
            public Owner Owner { get; set; }
        }

        public IActionResult GetAll()
        {
            return Ok(new WarehouseData[0]);
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