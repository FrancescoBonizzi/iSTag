using Dapper;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace IsTag.Repositories
{
    public class ImagesRepository : IImagesRepository
    {
        public string _connectionString;

        public ImagesRepository()
        {
            _connectionString = JsonConvert.DeserializeObject<ConnectionStrings>(File.ReadAllText("cs.json")).ISTag;
        }
        public byte[] GetImage(string id)
        {
            using(var connection = new SqlConnection(_connectionString))
            {
                var res = connection.Query<string>("SELECT Image FROM Images WHERE ImageCode = @Code", new { Code = id }).FirstOrDefault();

                return res == null ? null : Convert.FromBase64String(res);
            }
        }
    }
}
