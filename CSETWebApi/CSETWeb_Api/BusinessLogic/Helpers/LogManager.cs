using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using log4net;


namespace CSETWeb_Api.BusinessLogic.Helpers
{
    public sealed class LogManager
    {
        private static readonly LogManager _instance = new LogManager();

        public static LogManager Instance
        {
            get
            {
                return _instance;
            }
        }

        private readonly ILog log = log4net.LogManager.GetLogger(typeof(LogManager));

        public void LogDebugMessage(string message)
        {
            log.Info(message);
        }
    }
}
