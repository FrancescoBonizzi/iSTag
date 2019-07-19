using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace IsTag.Entities
{
    public class Warehouse
    {
        public class Owner
        {
            public string Name { get; set; }
            public string Email { get; set; }
        }
        public string Name { get; set; }
        public string Category { get; set; }
        public string Description { get; set; }
        public Owner CurrentOwner { get; set; }
    }
}
