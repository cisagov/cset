//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace CSETWebCore.Helpers
{
    public class CustomJsonWriter : JsonTextWriter
    {
        public CustomJsonWriter(TextWriter writer) : base(writer) { }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="x"></param>
        /// <returns></returns>
        public static string Serialize(XElement x)
        {
            var builder = new StringBuilder();
            JsonSerializer.Create().Serialize(new CustomJsonWriter(new StringWriter(builder)), x);
            var serialized = builder.ToString();

            return serialized;
        }


        /// <summary>
        /// Removes @ or # from property names.  These can occur when 
        /// serializing an XDocument and there's no way to tell Newtonsoft
        /// to not add them.
        /// </summary>
        /// <param name="name"></param>
        public override void WritePropertyName(string name)
        {
            if (name.StartsWith("@") || name.StartsWith("#"))
            {
                base.WritePropertyName(name.Substring(1));
            }
            else
            {
                base.WritePropertyName(name);
            }
        }
    }
}
