using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace IsTag.Repositories
{
    public interface IImagesRepository
    {
        byte[] GetImage(string id);
    }
}
