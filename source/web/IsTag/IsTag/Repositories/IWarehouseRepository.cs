using IsTag.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace IsTag.Repositories
{
    public interface IWarehouseRepository
    {
        Warehouse GetWarehouseItem(string id);
    }
}
