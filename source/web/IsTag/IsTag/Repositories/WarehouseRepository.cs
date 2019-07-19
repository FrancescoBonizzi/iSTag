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
        public Warehouse GetWarehouseItem(string id)
        {
            throw new NotImplementedException();/*
            using (var connection = new SqlConnection(_connectionString))
            {
                var wh = connection.Query("SELECT W.Name, W.Category, W.Description FROM    ")
            }*/
        }
    }
}
