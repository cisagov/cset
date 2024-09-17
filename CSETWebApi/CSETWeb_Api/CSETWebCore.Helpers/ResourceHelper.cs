//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
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
using System;
using CSETWebCore.Interfaces.Helpers;

namespace CSETWebCore.Helpers
{
    public class ResourceHelper : IResourceHelper
    {
        /// <summary>
        /// 
        /// </summary>
        public string GetEmbeddedResource(string resourceName)
        {
            return GetEmbeddedResource(resourceName, Assembly.GetCallingAssembly());
        }

        /// <summary>
        /// Embeds the scope into the resource name template.
        /// If the desired scope is not supported, falls back to use "CSET" 
        /// as the scope.
        /// </summary>
        public string GetEmbeddedResource(string resourceName, string scope)
        {
            // try 5 times, though 2 is enough for a simple fallback
            for (var i = 0; i < 5; i++)
            {
                try
                {
                    var formattedResourceName = resourceName.Replace("{{scope}}", scope);
                    var rsx = GetEmbeddedResource(formattedResourceName, Assembly.GetCallingAssembly());
                    return rsx;
                }
                catch (Exception)
                {
                    // fallback to "CSET" and try again
                    scope = "CSET";
                }
            }

            return null;
        }

        /// <summary>
        /// 
        /// </summary>
        public byte[] GetEmbeddedResourceAsBytes(string resourceName)
        {
            return GetEmbeddedResourceAsBytes(resourceName, Assembly.GetCallingAssembly());
        }

        /// <summary>
        /// 
        /// </summary>
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

        /// <summary>
        /// 
        /// </summary>
        public byte[] GetEmbeddedResourceAsBytes(string resourceName, Assembly assembly)
        {
            using (Stream resourceStream = assembly.GetManifestResourceStream(resourceName))
            {
                byte[] content = new byte[resourceStream.Length];
                resourceStream.Read(content, 0, content.Length);

                return content;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public string FormatResourceName(Assembly assembly, string resourceName)
        {
            return assembly.GetName().Name + "." + resourceName.Replace(" ", "_").Replace("\\", ".").Replace("/", ".");
        }


        /// <summary>
        /// Gets a resource that is not embedded, but is "Copy Always" or "Copy if Newer"
        /// </summary>
        /// <param name="resourceName"></param>
        /// <returns></returns>
        public string GetCopiedResource(string resourceName)
        {
            var path = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, resourceName);
            if (File.Exists(path))
            {
                return File.ReadAllText(path);
            }

            return null;
        }



        /// <summary>
        /// Gets the bytes of a resource that is not embedded, but is "Copy Always" or "Copy if Newer"
        /// </summary>
        /// <param name="resourceName"></param>
        /// <returns></returns>
        public byte[] GetCopiedResourceAsBytes(string resourceName)
        {
            var path = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, resourceName);
            if (File.Exists(path))
            {
                var fs = File.OpenRead(path);
                
                byte[] byteArray = new byte[fs.Length];
                fs.Read(byteArray, 0, (int)fs.Length);
                return byteArray;
            }

            return null;
        }
    }
}