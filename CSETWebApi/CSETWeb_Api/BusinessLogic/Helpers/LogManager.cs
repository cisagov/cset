//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using log4net;


namespace CSETWeb_Api.BusinessLogic.Helpers
{
    /// <summary>
    /// Writes to a log file as configured in log4net.config.
    /// </summary>
    public sealed class CsetLogManager
    {
        private static CsetLogManager _instance = null;

        public static CsetLogManager Instance
        {
            get
            {
                if (_instance == null)
                {
                   _instance = new CsetLogManager();
                }
                return _instance;
            }
        }

        private readonly ILog log = log4net.LogManager.GetLogger(typeof(LogManager));


        /// <summary>
        /// 
        /// </summary>
        private CsetLogManager()
        {
            Initialize();
        }

        private void Initialize()
        {
            // var appPath = System.Web.HttpContext.Current.Request.PhysicalApplicationPath;
            var appPath = System.Web.Hosting.HostingEnvironment.MapPath("~/");
            log4net.Config.XmlConfigurator.ConfigureAndWatch(new System.IO.FileInfo(appPath + @"\log4net.config"));
        }

        public void LogInfoMessage(string message)
        {
            log.Info(message);
        }

        public void LogInfoMessage(string format, params object[] args)
        {
            log.InfoFormat(format, args);
        }

        public void LogDebugMessage(string message)
        {
            log.Debug(message);
        }

        public void LogDebugMessage(string format, params object[] args)
        {
            log.DebugFormat(format, args);
        }

        public void LogErrorMessage(string message)
        {
            log.Error(message);
        }

        public void LogErrorMessage(string format, params object[] args)
        {
            log.ErrorFormat(format, args);
        }
    }
}
