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
    public class ConsumablesRepository : IConsumablesRepository
    {
        public string _connectionString;

        public ConsumablesRepository()
        {
            _connectionString = JsonConvert.DeserializeObject<ConnectionStrings>(File.ReadAllText("cs.json")).ISTag;
        }

        public IEnumerable<Consumable> GetAllConsumables()
        {
            using (var connection = new SqlConnection(_connectionString))
            {
                var consumable = connection.Query<Consumable>("SELECT Q.QRCode, C.Name, C.Status, C.Category, C.Description FROM QRCodes Q INNER JOIN Consumables C ON Q.QRCodeID = C.QRCodeID");
                return consumable;
            }
        }

        public Consumable GetConsumable(string id)
        {
            using (var connection = new SqlConnection(_connectionString))
            {
                var consumable = connection.Query<Consumable>("SELECT Q.QRCode, C.Name, C.Status, C.Category, C.Description FROM QRCodes Q INNER JOIN Consumables C ON Q.QRCodeID = C.QRCodeID WHERE QRCode = @Qr", new { Qr = id }).FirstOrDefault();
                return consumable;
            }
        }

        public string SetMissingNotMissing(string id)
        {
            using (var connection = new SqlConnection(_connectionString))
            {
                connection.Execute("UPDATE Consumables SET Status = CASE WHEN Status = 'Missing' THEN 'NotMissing' ELSE 'Missing' END WHERE QRCodeID = (SELECT QRCodeID FROM QRCodes WHERE QRCode = @Qr)", new { Qr = id });
                var val = connection.Query<string>("SELECT C.Status FROM QRCodes Q INNER JOIN Consumables C ON Q.QRCodeID = C.QRCodeID WHERE Q.QRCode = @Qr", new { Qr = id }).FirstOrDefault();
                return val;
            }
        }
    }
}
