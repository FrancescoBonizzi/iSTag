using IsTag.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace IsTag.Repositories
{
    public interface IWarehouseRepository
    {
        WarehouseItem GetWarehouseItem(string id);
        void InsertWarehouseItem(WarehouseItem warehouseItem);
        IEnumerable<WarehouseItem> GetAll();
        IEnumerable<Ownership> GetOwnershipHistoryOfItem(string id);
        IEnumerable<Ownership> GetOwnershipHistoryOfUser(string id);


        void Give(string what, string who);
        void Delete(string id);
    }
}
