//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace DatabaseMaintenance
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            try
            {
                //RunCleanOutDiscoveries();
                RunCleanup();
                Message.Text = "Database Maintenance Successfully completed!";
            }
            catch (Exception e)
            {
                Message.Text = e.Message;
            }
        }

        private void RunCleanOutDiscoveries()
        {
            String connString = "data source=(LocalDB)\\v11.0;Initial Catalog=master;integrated security=True;connect timeout=600;MultipleActiveResultSets=True;App=DBMaint";

            String cleanupScript = "DECLARE @command nvarchar(max)\r\n" +
            "SET @command = ''\r\n" +

            "SELECT  @command = @command\r\n" +
            "+ 'select * from   [' + [name] + '].dbo.finding;'+CHAR(13)+CHAR(10)\r\n" +
            "+ 'delete  [' + [name] + '].dbo.finding_contact;'+CHAR(13)+CHAR(10)\r\n" +
            "FROM  [master].[sys].[databases] \r\n" +
            "where [name] like '%[._]CSET[._]%';\r\n" +

            "PRINT @COMMAND\r\n" +
            "EXECUTE sp_executesql @command;\r\n";


            using (SqlConnection conn = new SqlConnection(connString))
            {

                conn.Open();
                SqlCommand cmd = conn.CreateCommand();
                cmd.CommandText = cleanupScript;
                cmd.ExecuteNonQuery();
                conn.Close();
            }
        }

        private void RunCleanup()
        {
            String connString = "data source=(LocalDB)\\v11.0;Initial Catalog=master;integrated security=True;connect timeout=600;MultipleActiveResultSets=True;App=DBMaint";

           String cleanupScript =  "-- drops all user databases\r\n" +
            "DECLARE @command nvarchar(max)\r\n" +
            "SET @command = ''\r\n" +

            "SELECT  @command = @command\r\n" +
            "+ 'ALTER DATABASE [' + [name] + ']  SET single_user with rollback immediate;'+CHAR(13)+CHAR(10)\r\n" +
            "+ 'DROP DATABASE [' + [name] +'];'+CHAR(13)+CHAR(10)\r\n" +
            "FROM  [master].[sys].[databases] \r\n" +
            "where [name] like '%[._]CSET[._]%';\r\n" +

            "PRINT @COMMAND\r\n" +
            "EXECUTE sp_executesql @command\r\n";

           using (SqlConnection conn = new SqlConnection(connString))
           {

               conn.Open();
               SqlCommand cmd = conn.CreateCommand();
               cmd.CommandText = cleanupScript;
               cmd.ExecuteNonQuery();
               conn.Close();
           }
        }
    }
}


