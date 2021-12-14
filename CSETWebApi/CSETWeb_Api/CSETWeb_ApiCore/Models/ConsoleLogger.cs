using System;
using CSETWebCore.Api.Interfaces;

namespace CSETWebCore.Api.Models
{
    public class ConsoleLogger : ILogger
    {
        public void Log(string message)
        {
            Console.WriteLine(message);
        }
    }
}