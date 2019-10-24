using System.IO;

namespace CSETWeb_Api.AssessmentIO.TestHarness
{
    public class BlobStream : MemoryStream
    {
        public string FileName { get; private set; }
        public string ContentType { get; private set; }
        public byte[] Buffer
        {
            get
            {
                return this.ToArray();
            }
        }

        public BlobStream(string filename, string contentType)
        {
            FileName = filename;
            ContentType = contentType;
        }
    }
}
