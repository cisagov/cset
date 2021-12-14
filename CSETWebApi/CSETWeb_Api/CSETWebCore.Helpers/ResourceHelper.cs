//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
//====================================================
//| Downloaded From                                  |
//| Visual C# Kicks - http://www.vcskicks.com/       |
//| License - http://www.vcskicks.com/license.php    |
//====================================================

using System.Collections.Generic;
using System.IO;
using System.Reflection;
using CSETWebCore.Interfaces.Helpers;

namespace CSETWebCore.Helpers
{
    public class ResourceHelper : IResourceHelper
    {
        public string GetEmbeddedResource(string resourceName)
        {
            return GetEmbeddedResource(resourceName, Assembly.GetCallingAssembly());
        }

        public byte[] GetEmbeddedResourceAsBytes(string resourceName)
        {
            return GetEmbeddedResourceAsBytes(resourceName, Assembly.GetCallingAssembly());
        }

        public string GetEmbeddedResource(string resourceName, Assembly assembly)
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

        public byte[] GetEmbeddedResourceAsBytes(string resourceName, Assembly assembly)
        {
            using (Stream resourceStream = assembly.GetManifestResourceStream(resourceName))
            {
                byte[] content = new byte[resourceStream.Length];
                resourceStream.Read(content, 0, content.Length);

                return content;
            }
        }

        public string FormatResourceName(Assembly assembly, string resourceName)
        {
            return assembly.GetName().Name + "." + resourceName.Replace(" ", "_").Replace("\\", ".").Replace("/", ".");
        }
    }
}