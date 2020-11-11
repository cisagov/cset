using DataLayerCore.Model;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.EntityFrameworkCore.SqlServer;
using Microsoft.EntityFrameworkCore;
using Microsoft.Data.SqlClient;
using System;

namespace CSETWeb_Api.Controllers.Tests
{
    [TestClass()]
    public class QuestionsControllerTests
    {
        [TestMethod()]
        public void validateQuestionsList()
        {
            try
            {
                string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["CSET_DB"].ConnectionString;
                SqlConnection conn = new SqlConnection(connectionString);
                SqlDataReader rdr = null;
                try
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand("select * from new_question q left join new_question_sets s on q.question_id = s.question_id where original_set_name in (select set_name from sets) and s.set_name is null and q.question_id not in(375,1598,2028,11170,13469)", conn);
                    rdr = cmd.ExecuteReader();
                    Assert.IsFalse(rdr.HasRows, "Records have been orphaned in the new sets table");
                }

                finally
                {
                    if (rdr != null)
                    {
                        rdr.Close();
                    }
                    if (conn != null)
                    {
                        conn.Close();
                    }
                }
                
            }
            catch(Exception e)
            {
                Assert.Fail(e.Message);
            }
        }
    }
}