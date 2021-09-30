using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Server.Kestrel.Core;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using System;
using System.IO;
using System.Net.Sockets;

namespace CSETWeb_ApiCore
{
    public class Program
    {
        public static void Main(string[] args)
        {
            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureAppConfiguration((hostingContext, config) =>
                {
                    var env = hostingContext.HostingEnvironment;
                    config.AddJsonFile("appsettings.json", optional: true)
                        .AddJsonFile($"appsettings.{env.EnvironmentName}.json", optional: true);

                    if (hostingContext.HostingEnvironment.IsProduction())
                    {
                        setupDb("data source=(LocalDB)\\MSSQLLocalDB;Database=Master;integrated security=True;connect timeout=180;MultipleActiveResultSets=True;");
                    }
                })
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    int startPort = 5000;
                    int httpPort = CheckPorts(startPort);
                    int httpsPort = CheckPorts(httpPort + 1);
                    webBuilder.UseStartup<Startup>().UseUrls("http://localhost:" + httpPort.ToString() + ";https://localhost:" + httpsPort.ToString());
                });

        private static void setupDb(string masterConnectionString)
        {
            string databaseCode = "CSETWeb";
            string clientCode = "DHS";
            string applicationCode = "CSET";
            string databaseFileName = databaseCode + ".mdf";
            string databaseLogFileName = databaseCode + "_log.ldf";

            // TODO: This version string needs to be changed from being hardcoded
            string currentVersion = "11.0.0.0";

            string appdatas = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
            string csetDestDBFile = Path.Combine(appdatas, clientCode, applicationCode, currentVersion, "database", databaseFileName);
            string csetDestLogFile = Path.Combine(appdatas, clientCode, applicationCode, currentVersion, "database", databaseLogFileName);

            string sqlconnection = @"data source=(LocalDB)\MSSQLLocalDB;Database=" + databaseCode + ";integrated security=True;connect timeout=180;MultipleActiveResultSets=True;App=CSET";
            InitalDbInfo dbinfo = new InitalDbInfo(sqlconnection, databaseCode);

            if (!dbinfo.Exists)
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(masterConnectionString))
                    {
                        conn.Open();
                        SqlCommand cmd = conn.CreateCommand();

                        string fixDBNameCommand = "if exists(SELECT name \n" +
                        "FROM master..sysdatabases \n" +
                        "where name ='" + databaseCode + "') \n" +
                        "select * from " + databaseCode + ".dbo.CSET_VERSION \n" +
                        "else\n" +
                        "CREATE DATABASE " + databaseCode +
                            " ON(FILENAME = '" + csetDestDBFile + "'),  " +
                            " (FILENAME = '" + csetDestLogFile + "') FOR ATTACH; ";


                        cmd.CommandText = fixDBNameCommand;
                        cmd.ExecuteNonQuery();
                 
                        conn.Close();
                        SqlConnection.ClearPool(conn);
                    }
                }
                catch (SqlException sql)
                {
                    Console.WriteLine(sql);
                }
            }  
        }

        /// <summary>
        /// Checks if local port is already in use and increments by one until available port is found
        /// </summary>
        /// <param name="port"> The starting port to check </param>
        /// <returns> The next available port to be used by the api </returns>
        private static int CheckPorts(int port)
        {
            bool foundAvailablePort = false;
            Console.WriteLine("Begin check for available ports to be used...\r\n");
            while (foundAvailablePort == false)
            {
                using (TcpClient tcpClient = new TcpClient())
                {
                    try
                    {
                        tcpClient.Connect("127.0.0.1", port);
                        Console.WriteLine("Port " + port.ToString() + " is already listening for connections. Incrementing to next port...\r\n");
                        port++;
                    }
                    catch (Exception)
                    {
                        Console.Write("Port " + port.ToString() + " is not listening for any connections. Application will use this port.\r\n");
                        foundAvailablePort = true;
                    }
                }
            }
            return port;
        }
    }
}
