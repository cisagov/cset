using System;
using CSETWebCore.Interfaces;

namespace CSETWebCore.Helpers
{
    public class ConsoleLogger : ILogger
    {
        public void Log(string message)
        {
            Console.WriteLine(message);
        }
    }
}