using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer;
using Microsoft.EntityFrameworkCore;


namespace CSETWebCore.DatabaseManager
{
    static class TransferData
    {
        public static string OldCSETConnectionString { get; private set; } = @"data source=(localdb)\v11.0;initial catalog = CSETWeb;persist security info = True;Integrated Security = SSPI;connect timeout=5;MultipleActiveResultSets=True";

        /// <summary>
        /// Transfers entities of type T to CSETWeb SQL Server localdb 2019 default instance from old installed versions of CSET.
        /// </summary>
        private static void TransferEntities<T>() where T : class
        {
            List<T> entities = null;

            var contextOptions = new DbContextOptionsBuilder<CsetwebContext>()
                .UseSqlServer(OldCSETConnectionString)
                .Options;

            try
            {
                using (CSETContext context = new CSETContext(contextOptions))
                {
                    
                    entities = context.Set<T>().ToList();
                }
            }
            catch
            {
                // no database from previous version of CSET found, just return null
                entities = null;
            }

            if (entities != null && entities.Count != 0)
            {
                using (CSETContext context = new CSETContext())
                {
                    using (var transaction = context.Database.BeginTransaction())
                    {
                        context.Set<T>().AddRange(entities);
                        context.Database.ExecuteSqlRaw("SET IDENTITY_INSERT " + typeof(T).Name + "ON;");
                        context.SaveChanges();
                        context.Database.ExecuteSqlRaw("SET IDENTITY_INSERT" + typeof(T).Name + "OFF;");
                        transaction.Commit();
                    }
                }
            }
        }
    }
}
