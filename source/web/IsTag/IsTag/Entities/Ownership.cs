using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace IsTag.Entities
{
    public class Ownership
    {
        public class Owner
        {
            public string Name { get; set; }
            public string Email { get; set; }
        }
        public string QRCode { get; set; }
        public DateTime When { get; set; }
        public Owner UserData { get; set; }
        public string ObjectName { get; set; }
    }
}
