//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Reflection;
using System.Globalization;

namespace CSETWebCore.Helpers
{
    public class BuildNumberHelper
    {
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public string GetLinkerTime()
        {
            const string BuildVersionMetadataPrefix = "+build";

            var attribute = Assembly.GetExecutingAssembly().GetCustomAttribute<AssemblyInformationalVersionAttribute>();
            if (attribute?.InformationalVersion != null)
            {
                var value = attribute.InformationalVersion;
                var index = value.IndexOf(BuildVersionMetadataPrefix);
                if (index > 0)
                {
                    value = value[(index + BuildVersionMetadataPrefix.Length)..];
                    return DateTime.ParseExact(value, "yyyy-MM-ddTHH:mm:ss:fffZ", CultureInfo.InvariantCulture)
                        .ToString("dd-MMM-yyyy HH:mm:ss");
                }
            }

            return "";
        }
    }
}
