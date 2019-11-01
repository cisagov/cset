using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text.RegularExpressions;

namespace CSETWeb_Api.AssessmentIO.TestHarness
{
    public static class WebServiceExtensions
    {
        public static WebRequest BuildRequest(this WebRequestOptions parms)
        {
            var request = (HttpWebRequest)WebRequest.Create(parms.UriString);

            if (!string.IsNullOrWhiteSpace(parms.Username))
            {
                var credentials = new NetworkCredential(parms.Username, parms.Password);
                request.Credentials = credentials.GetCredential(parms.Uri, parms.AuthType ?? string.Empty);
            }

            if (!string.IsNullOrWhiteSpace(parms.Referer))
                request.Referer = parms.Referer;

            parms.Headers = parms.Headers ?? new Dictionary<string, string>();
            foreach (var kvp in parms.Headers)
                request.Headers[kvp.Key] = kvp.Value;

            return request;
        }

        public static string Get(this WebRequestOptions parms)
        {
            var request = parms.BuildRequest();
            request.Method = "GET";
            return request.ReadStringResponse();
        }

        public static BlobStream GetStream(this WebRequestOptions parms)
        {
            var request = parms.BuildRequest();
            request.Method = "GET";
            return request.ReadStreamResponse();
        }

        public static string Post(this WebRequestOptions parms, HttpPostPayload payload)
        {
            var request = parms.BuildRequest();
            request.Method = "POST";
            request.ContentType = payload.ContentType;
            var buffer = payload.Buffer;
            request.ContentLength = buffer.Length;
            using (var rs = request.GetRequestStream())
            {
                rs.Write(buffer, 0, buffer.Length);
            }
            return request.ReadStringResponse();
        }

        public static string ReadStringResponse(this WebRequest request, string encodingName = "UTF-8")
        {
            using (var response = request.GetResponse())
            {
                using (var stream = response.GetResponseStream())
                {
                    var encode = System.Text.Encoding.GetEncoding(encodingName);
                    using (var reader = new StreamReader(stream, encode))
                    {
                        return reader.ReadToEnd();
                    }
                }
            }
        }

        public static BlobStream ReadStreamResponse(this WebRequest request)
        {
            var regx = new Regex("filename=\"(?<fn>[^\"]+)\"");
            using (var response = request.GetResponse())
            {
                var match = regx.Match(response.Headers["content-disposition"]);
                var bs = new BlobStream(match.Groups["fn"].Value, response.Headers["Content-Type"]);
                using (var stream = response.GetResponseStream())
                {
                    stream.CopyTo(bs);
                }
                return bs;
            }
        }
    }
}
