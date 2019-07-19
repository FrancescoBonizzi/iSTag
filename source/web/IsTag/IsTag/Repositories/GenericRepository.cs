using Dapper;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;

namespace IsTag.Repositories
{
    public class GenericRepository : IGenericRepository
    {
        public string _connectionString;

        public GenericRepository(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("ISTag");
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
