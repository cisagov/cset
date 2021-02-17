using DataLayerCore.Model;
using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;

namespace DBDictionary
{
    class Program
    {
        private static string connString = @"data source=(localdb)\v11.0;initial catalog=CSETWeb;persist security info=True;Integrated Security=SSPI;MultipleActiveResultSets=True";

        static void Main(string[] args)
        {
            Program p = new Program();
            p.ProcessStuff();
        }

        private void ProcessStuff()
        {
            using (var connection = new SqlConnection(connString))
            {
                connection.Open();
                SqlCommand cmd = connection.CreateCommand();
                cmd.CommandText = getTablesList();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        String tableName = reader.GetString(0);
                        String currentComment = reader.IsDBNull(2)?null:reader.GetString(2);
                        Console.WriteLine("updating property {0}", tableName);
                        SqlCommand tcommand = getPropertyCommand(connection, tableName, null, currentComment);
                        tcommand.ExecuteNonQuery();
                    }
                }
                else
                {
                    Console.WriteLine("No rows found.");
                }
                reader.Close(); 

            }
        }

        private string getTablesList()
        {
            return File.ReadAllText("GetTableList.sql");
        }

        private SqlCommand getPropertyCommand(SqlConnection conn, string tableName, 
            string colName, string currentComment)
        {
            string cmdText = currentComment==null ? "sp_addextendedproperty" : "sp_updateextendedproperty";
            SqlCommand cmd = new SqlCommand(cmdText, conn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlParameter param;
            param = cmd.Parameters.Add("@name", SqlDbType.NVarChar, 250);
            param.Value = "MS_Description";
            param = cmd.Parameters.Add("@value", SqlDbType.NVarChar, 250);
            param.Value = "A collection of "+ tableName + " records";            
            param = cmd.Parameters.Add("@level0type", SqlDbType.NVarChar, 250);
            param.Value = "Schema";
            param = cmd.Parameters.Add("@level0name", SqlDbType.NVarChar, 250);
            param.Value = "dbo";
            param = cmd.Parameters.Add("@level1type", SqlDbType.NVarChar, 250);
            param.Value = "Table";
            param = cmd.Parameters.Add("@level1name", SqlDbType.NVarChar, 250);
            param.Value = tableName;
            if (!string.IsNullOrWhiteSpace(colName))
            {
                param = cmd.Parameters.Add("@level2type", SqlDbType.NVarChar, 250);
                param.Value = "Column";
                param = cmd.Parameters.Add("@level2name", SqlDbType.NVarChar, 250);
                param.Value = colName;
            }
            return cmd;
        }

    }
}
