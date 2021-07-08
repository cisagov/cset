using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Server.Kestrel.Core;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using System;
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
                })
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    int startPort = 5000;
                    int httpPort = CheckPorts(startPort);
                    int httpsPort = CheckPorts(httpPort + 1);
                    webBuilder.UseUrls("http://localhost:" + httpPort.ToString() + ";https://localhost:" + httpsPort.ToString())
                               .UseKestrel()
                               .UseStartup<Startup>();
                });


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
                        Console.WriteLine("Port " + port.ToString() + " is already listening for connections. Looking at next port...\r\n");
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
