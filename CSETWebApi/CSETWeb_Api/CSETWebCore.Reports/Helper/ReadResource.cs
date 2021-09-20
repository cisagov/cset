using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using Newtonsoft.Json;

namespace CSETWebCore.Reports.Helper
{
    public static class ReadResource
    {
        public static string ReadResourceByKey(string file, string key)
        {
            try
            {
                var location = $"CSETWebCore.Reports.Resources.{file}";
                var assembly = Assembly.GetExecutingAssembly();
                using (Stream stream = assembly.GetManifestResourceStream(location))
                using (StreamReader reader = new StreamReader(stream))
                {
                    var json = reader.ReadToEnd();
                    var jsonFile = JsonConvert.DeserializeObject<List<KeyValuePair<string, string>>>(json);
                    string val = jsonFile.FirstOrDefault(x => x.Key == key).Value;
                    return val;
                }
            }
            catch (Exception x)
            {
                return string.Empty;
            }
        }
    }
}