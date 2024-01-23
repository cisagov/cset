//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;

namespace CSETWebCore.Business.Diagram.analysis.helpers
{
    class DrawIOParsingHelps
    {
        public static Dictionary<string, string> DecodeQueryParameters(string uri)
        {
            if (uri == null)
                throw new ArgumentNullException("uri");

            if (uri.Length == 0)
                return new Dictionary<string, string>();

            return uri.TrimStart('?')
                            .Split(new[] { '&', ';' }, StringSplitOptions.RemoveEmptyEntries)
                            .Select(parameter => parameter.Split(new[] { '=' }, StringSplitOptions.RemoveEmptyEntries))
                            .GroupBy(parts => parts[0],
                                     parts => parts.Length > 2 ? string.Join("=", parts, 1, parts.Length - 1) : (parts.Length > 1 ? parts[1] : ""))
                            .ToDictionary(grouping => grouping.Key,
                                          grouping => string.Join(",", grouping));
        }
    }
}
