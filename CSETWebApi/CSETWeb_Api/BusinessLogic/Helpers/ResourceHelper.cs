//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
//====================================================
//| Downloaded From                                  |
//| Visual C# Kicks - http://www.vcskicks.com/       |
//| License - http://www.vcskicks.com/license.php    |
//====================================================
using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;

namespace CSETWeb_Api.Helpers
{
    public static class ResourceHelper
    {
        public static string GetEmbeddedResource(string resourceName)
        {
            return GetEmbeddedResource(resourceName, Assembly.GetCallingAssembly());
        }

        public static byte[] GetEmbeddedResourceAsBytes(string resourceName)
        {
            return GetEmbeddedResourceAsBytes(resourceName, Assembly.GetCallingAssembly());
        }

        public static string GetEmbeddedResource(string resourceName, Assembly assembly)
        {
            resourceName = FormatResourceName(assembly, resourceName);
            
            // reconcile the qualified resource name with those in the manifest (may contain another qualifier)
            List<string> knownResourceNames = new List<string>(assembly.GetManifestResourceNames());
            resourceName = knownResourceNames.Find(n => n.EndsWith(resourceName));

            using (Stream resourceStream = assembly.GetManifestResourceStream(resourceName))
            {
                if (resourceStream == null)
                    return null;

                using (StreamReader reader = new StreamReader(resourceStream))
                {
                    return reader.ReadToEnd();
                }
            }
        }

        public static byte[] GetEmbeddedResourceAsBytes(string resourceName, Assembly assembly)
        {
            using (Stream resourceStream = assembly.GetManifestResourceStream(resourceName))
            {
                byte[] content = new byte[resourceStream.Length];
                resourceStream.Read(content, 0, content.Length);

                return content;
            }
        }

        private static string FormatResourceName(Assembly assembly, string resourceName)
        {
            return assembly.GetName().Name + "." + resourceName.Replace(" ", "_").Replace("\\", ".").Replace("/", ".");
        }
    }
}

