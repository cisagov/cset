//using Microsoft.EntityFrameworkCore;
//using System;
//using System.Data;
//using System.Data.Common;
//using System.Data.SqlClient;
//using System.Linq;
//using System.Linq.Expressions;


//namespace CSETWeb_Api.Helpers.multiproc
//{
//    public class Repository<TEntity> : IRepository<TEntity> where TEntity : class
//    {
//        protected DbContext DbContext;
//        public Repository(DbContext context)
//        {
//            DbContext = context;
//        }
//        public virtual IQueryable<TEntity> GetAll()
//        {
//            return DbContext.Set<TEntity>();
//        }
        
//        public TEntity First(Expression<Func<TEntity, bool>> predicate)
//        {
//            return DbContext.Set<TEntity>().FirstOrDefault(predicate);
//        }
//        protected virtual T ExecuteReader<T>(Func<DbDataReader, T> mapEntities,
//            string exec, params object[] parameters)
//        {
//            using (var conn = new SqlConnection())
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
//        public void Dispose()
//        {
//            Dispose(true);
//            GC.SuppressFinalize(this);
//        }
//        protected virtual void Dispose(bool disposing)
//        {
//            if (!disposing) return;
//            if (DbContext == null) return;
//            DbContext.Dispose();
//            DbContext = null;
//        }
//    }
//}