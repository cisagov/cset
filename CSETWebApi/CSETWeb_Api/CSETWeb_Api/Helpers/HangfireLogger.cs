//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWeb_Api.BusinessLogic.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Hangfire;
using Hangfire.Console;
using Hangfire.Logging.LogProviders;
using Hangfire.Server;

namespace CSETWeb_Api.Helpers
{
    public class HangfireLogger : ILogger
    {
        private PerformContext context;
        public void Log(string message)
        {
            context.WriteLine(message);
        }

        public HangfireLogger(PerformContext context)
        {
            this.context = context;
        }
    }
}

