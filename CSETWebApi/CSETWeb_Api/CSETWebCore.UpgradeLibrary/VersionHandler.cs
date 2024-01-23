//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using System.Web;

namespace CSETWeb_Api.Versioning
{
    public class VersionHandler
    {
        public static Version GetCurrentVersion()
        {
            Assembly assembly = Assembly.GetExecutingAssembly();
            FileVersionInfo fileVersionInfo = FileVersionInfo.GetVersionInfo(assembly.Location);
            string CSETVersionString = fileVersionInfo.FileVersion;
            Version currentVersion = new Version(CSETVersionString);
            return NormalizeVersion(currentVersion);
        }

        public static string GetCurrentVersionString()
        {
            Assembly assembly = Assembly.GetExecutingAssembly();
            FileVersionInfo fileVersionInfo = FileVersionInfo.GetVersionInfo(assembly.Location);
            return fileVersionInfo.FileVersion;
        }

        public static System.Version NormalizeVersion(System.Version v)
        {
            return new System.Version(
                   v.Major < 0 ? 0 : v.Major,
                   v.Minor < 0 ? 0 : v.Minor,
                   v.Build < 0 ? 0 : v.Build,
                   v.Revision < 0 ? 0 : v.Revision);
        }

        public static System.Version ConvertFromStringToVersion(String v)
        {
            // The version string may come in from a float and not be interpreted correctly.  
            // This attempts to turn "9.04" into "9.0.4"
            string[] parts = v.Split(".".ToCharArray());
            if (parts.Length < 2)
            {
                if (parts.Length > 1 && parts[1].StartsWith("0"))
                {
                    parts[1] = "0." + parts[1].Substring(1);
                }
                v = String.Join(".", parts);
                if (v.EndsWith("."))
                {
                    v = v.TrimEnd('.');
                }
            }


            if (int.TryParse(v, out int version))
            {
                return NormalizeVersion(new System.Version(version, 0));
            }
            return NormalizeVersion(new System.Version(v));
        }

        private static Version version;
        public static Version Version
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
                string csetVersion = version.Major.ToString() + "." + version.Minor + "." + version.Build;
                return csetVersion;
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
            catch
            {
                //CSETLogger.Error("Failed to show version.", ex);
                return "";
            }

        }

        public String CSETVersionString { get { return CSETVersionStringStatic; } }

    }
}

