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
            using (var connection = new SqlConnection(_connectionString))
            {
                var wh = connection.Query<WarehouseItem>("SELECT W.Name, W.Category, W.Description, W.ImageCode FROM Warehouse W INNER JOIN QRCodes Q ON W.QRCodeID = Q.QRCodeID WHERE Q.QRCode = @Qr", new { Qr = id }).FirstOrDefault();
                var up = connection.Query<WarehouseItem.Owner>("SELECT U.Name, U.Email FROM Users U WHERE U.UserID = (SELECT TOP 1 UserID FROM WarehouseUpdates WHERE QRCodeID = (SELECT QRCodeID FROM QRCodes WHERE QRCode = @Id) ORDER BY [When] DESC)", new { Id = id }).FirstOrDefault();

                wh.CurrentOwner = up;

                return wh;
            }
        }

        public void InsertWarehouseItem(WarehouseItem warehouseItem)
        {
            using (var connection = new SqlConnection(_connectionString))
            {
                connection.Execute("INSERT INTO QRCodes VALUES (@Qr, 'Warehouse'); DECLARE @QrID int = SCOPE_IDENTITY(); INSERT INTO Warehouse VALUES (@QrID, @Name, @Category, @Description, @ImageCode)",
                    new
                    {
                        Qr = warehouseItem.QRCode,
                        Name = warehouseItem.Name,
                        Category = warehouseItem.Category,
                        Description = warehouseItem.Description,
                        ImageCode = warehouseItem.ImageCode
                    });
            }
        }
    }
}
