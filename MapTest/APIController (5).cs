using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CO2Maps.Models;

namespace CO2Maps.Controllers
{
    public class APIController : Controller
    {
        ApplicationDbContext db = new ApplicationDbContext();
        // GET: API
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult AddMapDetails(string latitude,string longtitude, int value)
        {
            CO2Maps.Models.CO2Maps  mm = new Models.CO2Maps();
            mm.Date = DateTime.UtcNow.AddHours(3);
            mm.Latitude = latitude;
            mm.Longtitude = longtitude;
            mm.Value = value;
            db.CO2Maps.Add(mm);
            db.SaveChanges();
            return Json(true, JsonRequestBehavior.AllowGet);
        }
        public ActionResult GetMapDetails()
        {
            var mm = db.CO2Maps.Select(s=> new {ID = s.ID, Latitude = s.Latitude, Longtitude = s.Longtitude, Date = s.Date.ToShortDateString(), Time = s.Date.ToShortTimeString() }).ToList();
            return Json(mm, JsonRequestBehavior.AllowGet);
        }
    }
}