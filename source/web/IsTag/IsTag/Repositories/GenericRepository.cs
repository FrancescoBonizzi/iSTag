using Dapper;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace IsTag.Repositories
{
    public class GenericRepository : IGenericRepository
    {
        public string _connectionString;

        public GenericRepository()
        {
            _connectionString = JsonConvert.DeserializeObject<ConnectionStrings>(File.ReadAllText("cs.json")).ISTag;
        }

        public string GetTypeOfObject(string id)
        {
            using (var connection = new SqlConnection(_connectionString))
            {
                var type = connection.Query<string>("SELECT Type FROM QRCodes WHERE QRCode = @Qr", new { Qr = id }).FirstOrDefault();
                return type;
            }
        }
    }
}
