//using System;
//using System.Collections.Generic;
//using System.Data;
//using System.Data.Common;
//using System.Data.SqlClient;
//using System.Linq;
//using System.Web;

//namespace CSETWeb_Api.Helpers.multiproc
//{
//    public class MultiProcRespository
//    {
//        public class FaqRepository : Repository<FAQ>
//        {
//            public FaqRepository(DbContext context) : base(context)
//            {
//            }
//        }


//        protected virtual T ExecuteReader<T>(Func<DbDataReader, T> mapEntities, string exec, params object[] parameters)
//        {
//            using (var conn = new SqlConnection(dbContext.Database.Connection.ConnectionString))
//            {
//                using (var command = new SqlCommand(exec, conn))
//                {
//                    conn.Open();
//                    command.Parameters.AddRange(parameters);
//                    command.CommandType = CommandType.StoredProcedure;
//                    try
//                    {
//                        using (var reader = command.ExecuteReader())
//                        {
//                            T data = mapEntities(reader);
//                            return data;
//                        }
//                    }
//                    finally
//                    {
//                        conn.Close();
//                    }
//                }
//            }
//        }
//    }
//}