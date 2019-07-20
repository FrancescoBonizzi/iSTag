﻿using IsTag.ViewModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace IsTag.Controllers
{
#if true
    [AllowAnonymous]
#endif
    //[Authorize]
    public class PagesController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        [AllowAnonymous]
        public IActionResult Login()
        {
            if (User.Identity.IsAuthenticated)
            {
                return RedirectToAction("Index");
            }

            return View();
        }

        public IActionResult Warehouse()
        {
            return View();
        }

        public IActionResult Consumables()
        {
            return View();
        }

        public IActionResult PrintQr(string id, string name)
        {
            return View(new PrintQrViewModel(id, name));
        }
    }
}
