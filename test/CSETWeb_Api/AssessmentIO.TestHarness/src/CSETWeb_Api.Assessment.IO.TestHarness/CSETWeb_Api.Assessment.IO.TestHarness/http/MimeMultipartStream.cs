using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace CSETWeb_Api.AssessmentIO.TestHarness
{
    class MimeMultipartStream : MemoryStream
    {
        public string ContentType { get; private set; }
        public byte[] Buffer
        {
            get
            {
                return this.ToArray();
            }
        }

        private static void WriteToStream(Stream s, string text)
        {
            var buffer = Encoding.UTF8.GetBytes(text);
            WriteToStream(s, buffer);
        }

        private static void WriteToStream(Stream s, byte[] buffer)
        {
            s.Write(buffer, 0, buffer.Length);
        }

        public static MimeMultipartStream FromContent(IDictionary<string, object> content)
        {
            var boundary = $"----------{DateTime.Now.Ticks.ToString("x")}";
            var ms = new MimeMultipartStream { ContentType = $"multipart/form-data; boundary={boundary}" };

            var header = $"--{boundary}{Environment.NewLine}";
            var footer = $"{Environment.NewLine}--{boundary}--{Environment.NewLine}";
            var addCRLF = false;

            var keys = (content ?? new Dictionary<string, object>()).Keys;
            foreach (string key in keys)
            {
                if (addCRLF)
                    WriteToStream(ms, Environment.NewLine);
                var value = content[key] ?? string.Empty;

                var bs = value as BlobStream;
                if (bs != null)
                {
                    WriteToStream(ms, header);
                    WriteToStream(ms, $"Content-Disposition: form-data; name=\"{key}\"; filename=\"{bs.FileName ?? key}\"{Environment.NewLine}");
                    WriteToStream(ms, $"Content-Type: {bs.ContentType ?? "application/octet-stream"}{Environment.NewLine}{Environment.NewLine}");
                    WriteToStream(ms, bs.Buffer);
                    continue;
                }

                WriteToStream(ms, header);
                WriteToStream(ms, $"Content-Disposition: form-data; name=\"{key}\"{Environment.NewLine}{Environment.NewLine}");
                WriteToStream(ms, value.ToString());
                addCRLF = true;
            }

            WriteToStream(ms, footer);
            return ms;
        }
    }
}
