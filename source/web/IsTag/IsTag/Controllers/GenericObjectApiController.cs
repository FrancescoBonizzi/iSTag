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
    public class GenericObjectApiController : ControllerBase
    {
        private readonly IGenericRepository _genericRepository;
        public GenericObjectApiController(IGenericRepository genericRepository)
        {
            _genericRepository = genericRepository;
        }
        public IActionResult Get(string id)
        {
            var res = _genericRepository.GetTypeOfObject(id);
            return res == null ? (IActionResult)BadRequest() : Ok(res);
        }
    }
}