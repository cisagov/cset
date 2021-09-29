using System;
using System.Collections.Generic;
using Microsoft.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_ApiCore
{
    public class InitalDbInfo
    {
        public InitalDbInfo(string connectionString, string databaseCode)
        {
            Exists = true;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    SqlCommand cmd = conn.CreateCommand();
                    cmd.CommandText = "SELECT type_desc AS FileType, Physical_Name AS Location FROM sys.master_files mf INNER JOIN sys.databases db ON db.database_id = mf.database_id where db.name = '" + databaseCode+"'";

                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        var type = reader.GetString(0);
                        var path = reader.GetString(1);
                        switch (type)
                        {
                            case "ROWS":
                                CSETMDF = path;
                                break;
                            case "LOG":
                                CSETLDF = path;
                                break;
                        }
                    }
                }
                catch (SqlException sqle)
                {
                    this.Exists = false;
                }
            }
        }

        public String CSETMDF
        {
            get; set;
        }
        public String CSETLDF
        {
            get; set;
        }
        public bool Exists { get; private set; }
    }
}
