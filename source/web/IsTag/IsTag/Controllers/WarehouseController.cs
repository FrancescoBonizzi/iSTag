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
            public string Proprietario => CurrentOwner != null
                ? CurrentOwner.Email
                : "Nessun proprietario";
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
            var d = _warehouseRepository.GetAll();
            return Ok(d.Select(a => new WarehouseData()
            {
                Category = a.Category,
                Description = a.Description,
                Name = a.Name,
                Picture = $"/Images/Image/{a.ImageCode}",
                QRCode = a.QRCode,
                CurrentOwner = a.CurrentOwner == null ? null : new Owner()
                {
                    Email = a.CurrentOwner.Email,
                    Name = a.CurrentOwner.Name
                }
            }));
        }

        public IActionResult GetHistoryByObject(string id)
        {
            var own = _warehouseRepository.GetOwnershipHistoryOfItem(id);
            return Ok(own.Select(a => new OwnershipData()
            {
                ChangeDate = a.When,
                Owner = a.UserData == null ? null : new Owner()
                {
                    Email = a.UserData.Email,
                    Name = a.UserData.Name
                }
            }));
        }

        public IActionResult GetHistoryByUser(string id)
        {
            var own = _warehouseRepository.GetOwnershipHistoryOfUser(id);
            return Ok(own.Select(a => new OwnershipData()
            {
                ChangeDate = a.When,
                Owner = a.UserData == null ? null : new Owner()
                {
                    Email = a.UserData.Email,
                    Name = a.UserData.Name
                }
            }));
        }

        public class GiveData
        {
            public string QRCode { get; set; }
            public string Who { get; set; }
        }

        [HttpPost]
        public IActionResult Give([FromBody] GiveData giveTo)
        {
            var elem = _warehouseRepository.GetWarehouseItem(giveTo.QRCode);

            string target = null;

            if(elem?.CurrentOwner?.Email == giveTo.Who)
            {
                target = null;
            }
            else
            {
                target = giveTo.Who;
            }

            _warehouseRepository.Give(giveTo.QRCode, target);

            return Ok(target);
        }
    }
}