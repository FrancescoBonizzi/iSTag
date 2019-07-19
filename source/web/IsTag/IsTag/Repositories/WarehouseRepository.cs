using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Dapper;
using IsTag.Entities;
using Newtonsoft.Json;

namespace IsTag.Repositories
{
    public class WarehouseRepository : IWarehouseRepository
    {
        public string _connectionString;

        public WarehouseRepository()
        {
            _connectionString = JsonConvert.DeserializeObject<ConnectionStrings>(File.ReadAllText("cs.json")).ISTag;
        }
        public WarehouseItem GetWarehouseItem(string id)
        {
            throw new NotImplementedException();
            /*
            using (var connection = new SqlConnection(_connectionString))
            {
                var wh = connection.Query<WarehouseItem>("SELECT W.Name, W.Category, W.Description, W.ImageCode FROM Warehouse W INNER JOIN QRCodes Q ON W.QRCodeID = Q.QRCodeID WHERE Q.QRCode = @Qr", new { Qr = id });
                var up = connection.Query<WarehouseItem.Owner>("SELECT U.Name, U.Email FROM Users U WHERE U.UserID = ")
            }*/
        }
    }
}
