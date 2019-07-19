using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using IsTag.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace IsTag.Controllers
{
    [AllowAnonymous]
    public class ImagesController : ControllerBase
    {
        private readonly IImagesRepository _imagesRepository;
        public ImagesController(IImagesRepository imagesRepository)
        {
            _imagesRepository = imagesRepository;
        }


        public IActionResult Image(string id)
        {
            var img = _imagesRepository.GetImage(id);
            return File(img, "image/jpeg");
        }
    }
}