using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using IsTag.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using QRCoder;

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

        public IActionResult QR(string id)
        {
            QRCodeGenerator qrGenerator = new QRCodeGenerator();
            QRCodeData qrCodeData = qrGenerator.CreateQrCode(id, QRCodeGenerator.ECCLevel.Q);
            QRCode qrCode = new QRCode(qrCodeData);
            Bitmap qrCodeImage = qrCode.GetGraphic(20);
            

            using (var ms = new MemoryStream(qrCodeImage.Width * qrCodeImage.Height * 4))
            {
                qrCodeImage.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg);
                return File (ms.ToArray(), "image/jpeg");
            }
        }
    }
}