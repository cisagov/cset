using Newtonsoft.Json;
using System;
using System.IO;

namespace CSETWeb_Api.AssessmentIO.TestHarness
{
    public static class JsonExtensions
    {
        public static string ToJson<T>(this T payload, Formatting formatting = Newtonsoft.Json.Formatting.None)
        {
            return JsonConvert.SerializeObject(payload, formatting);
        }

        public static T FromJson<T>(this string payload)
        {
            return (T)payload.FromJson(typeof(T));
        }

        public static T FromJson<T>(this Stream stream)
        {
            var serializer = new JsonSerializer();
            using (var sr = new StreamReader(stream))
            {
                using (var tr = new JsonTextReader(sr))
                {
                    return (T)serializer.Deserialize(tr);
                }
            }
        }

        public static object FromJson(this string payload, Type type)
        {
            return JsonConvert.DeserializeObject(payload, type);
        }
    }
}
