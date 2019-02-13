//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;

namespace CSETWeb_Api.Versioning
{
    public class VersionHandler
    {
        public string Application_Accept_Path { get { return Constants.APPLICATION_NAME + " " + CSETVersionString; } }

        private static Version version;
        private static Version Version
        {
            get
            {
                if (version == null)
                {
                    Type t = new VersionHandler().GetType();
                    version = Assembly.GetAssembly(t).GetName().Version;
                }
                return version;
            }

        }

        public static String CSETVersionStringStatic
        {
            get
            {
                Version version = Version;
                string csetVersion = version.Major.ToString() + "." + version.Minor;
                return csetVersion;
            }

        }

        public Decimal CSETVersionDecimal
        {
            get
            {
                Decimal dVersion;
                if (Decimal.TryParse(CSETVersionStringStatic, out dVersion))
                    return dVersion;
                else
                    return 0.0m;
            }
        }

        public string FullVersion
        {
            get { return GetFullVersion(); }
        }

        public string GetFullVersion()
        {
            try
            {
                Version version = Version;
                DateTime buildDateTime = new DateTime(2000, 1, 1).Add(new TimeSpan(
                TimeSpan.TicksPerDay * version.Build + // days since 1 January 2000
                TimeSpan.TicksPerSecond * 2 * version.Revision)); // seconds since midnight, (multiply by 2 to get original)
                buildDateTime = buildDateTime.AddHours(1);//It is off by an hour
                string versionText = version.Major + "." + version.Minor + "." + buildDateTime.ToString("MMddyyyy.HHmmss") + " - ";
                return versionText;

            }
            catch (Exception ex)
            {
                //CSETLogger.Error("Failed to show version.", ex);
                return "";
            }

        }

        public String CSETVersionString { get { return CSETVersionStringStatic; } }

    }
}

