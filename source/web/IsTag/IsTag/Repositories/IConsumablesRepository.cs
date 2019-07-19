using IsTag.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace IsTag.Repositories
{
    public interface IConsumablesRepository
    {
        Consumable GetConsumable(string id);
        string SetMissingNotMissing(string id);
        IEnumerable<Consumable> GetAllConsumables();
        void InsertConsumable(Consumable consumable);
    }
}
