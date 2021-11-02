using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.DataLayer.Model;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;


namespace CSETWebCore.DatabaseManager
{
    static class TransferData
    {

        public static string EscapeString(String value)
        {
            return value.Replace("'", "''");
        }

        private static void ForceClose(SqlConnection conn, string dbName)
        {
            try
            {
                //connect to the database 
                //and restore the database to the current mdf and log files.
                String cmdForceClose =
                    "Use Master; \n"
                    + "DECLARE @SQL varchar(max) \n"
                    + "Declare @id int  \n"
                    + "select @id = DB_ID('" + EscapeString(dbName) + "') from Master..SysProcesses \n"
                    + "if (@id is not null)  \n"
                    + "begin \n"
                    + "	SELECT @SQL = COALESCE(@SQL,'') + 'Kill ' + Convert(varchar, SPId) + ';' \n"
                    + "	FROM MASTER..SysProcesses \n"
                    + "	WHERE DBId = DB_ID('" + EscapeString(dbName) + "') AND SPId <> @@SPId \n"
                    + "--print @sql \n"
                    + "	EXEC(@SQL) \n"
                    + "EXEC sp_detach_db  @dbname = N'" + dbName + "'"
                    + "end  \n";
                conn.Open();
                SqlCommand cmd = conn.CreateCommand();
                cmd.CommandText = cmdForceClose;
                cmd.ExecuteNonQuery();
            }
            catch (SqlException sqle)
            {
                Console.WriteLine(sqle.Message);
            }
        }

        /// <summary>
        /// Transfers entities of type T (should be a class from DataLayer) to CSETWeb SQL Server localdb 2019 default instance from old installed versions of CSET.
        /// </summary>
        //internal static void TransferEntities<T>() where T : class
        //{
        //    List<T> entities = null;

        //    var contextOptions = new DbContextOptionsBuilder<CsetwebContext>()
        //        .UseSqlServer(oldCSETConnectionString)
        //        .Options;

        //    try
        //    {
        //        using (CSETContext context = new CSETContext(contextOptions))
        //        {
        //            // Have to temporarily add workflow column to get old INFORMATION table rows
        //            if (typeof(T) == typeof(INFORMATION))
        //            { 
        //                context.Database.ExecuteSqlRaw(
        //                    "IF COL_LENGTH('INFORMATION', 'Workflow') IS NULL \n" +
        //                        "ALTER TABLE INFORMATION ADD Workflow NVARCHAR(30);"
        //                    );
        //            }

        //            entities = context.Set<T>().ToList();

        //            // Concatenating child comments onto parent question answers
        //            if (typeof(T) == typeof(ANSWER))
        //            {
        //                var answersWithComments = from a in context.ANSWER
        //                                          join m in context.MATURITY_QUESTIONS on a.Question_Or_Requirement_Id equals m.Mat_Question_Id
        //                                          where a.Comment != null && m.Parent_Question_Id != null
        //                                          select new { a.Comment, m.Parent_Question_Id };

                        
        //                foreach (var row in answersWithComments) 
        //                {
        //                    var parent = context.ANSWER.Where(x => x.Question_Or_Requirement_Id == row.Parent_Question_Id).FirstOrDefault();
        //                    if (parent == null)
        //                    { 
                            
        //                    }
        //                    parent.Comment += " / " + row.Comment;
        //                }
        //                context.SaveChanges();

        //            }

        //            if (typeof(T) == typeof(INFORMATION))
        //            {
        //                context.Database.ExecuteSqlRaw(
        //                    "IF COL_LENGTH('INFORMATION', 'Workflow') IS NOT NULL \n" +
        //                        "ALTER TABLE INFORMATION DROP COLUMN Workflow;"
        //                    );
        //            }
        //        }
        //    }
        //    catch(Exception e)
        //    {
        //        Console.WriteLine(e);
        //        // something went wrong trying to retrieve entities from old db, just return null
        //        entities = null;
        //    }

        //    if (entities != null && entities.Count != 0)
        //    {
        //        try
        //        {
        //            using (CSETContext context = new CSETContext())
        //            {
        //                using (var transaction = context.Database.BeginTransaction())
        //                {
        //                    context.Set<T>().AddRange(entities);
        //                    context.Database.ExecuteSqlRaw(
        //                        "IF (OBJECTPROPERTY(OBJECT_ID('" + typeof(T).Name + "'), 'TableHasIdentity') = 1) \n" +
        //                            "SET IDENTITY_INSERT " + typeof(T).Name + " ON;"
        //                        );

        //                    context.SaveChanges();
        //                    context.Database.ExecuteSqlRaw(
        //                        "IF (OBJECTPROPERTY(OBJECT_ID('" + typeof(T).Name + "'), 'TableHasIdentity') = 1) \n" +
        //                            "SET IDENTITY_INSERT " + typeof(T).Name + " OFF;"
        //                        );
        //                    transaction.Commit();
        //                }
        //            }
        //        }
        //        catch(Exception e)
        //        {
        //            Console.WriteLine(e);
        //        }
        //    }
                
        //}
    }
}
