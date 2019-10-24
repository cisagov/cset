using System.Text;

namespace CSETWeb_Api.AssessmentIO.TestHarness
{
    public class HttpPostPayload
    {
        public object Data { get; set; }
        public string ContentType { get; set; }
        public byte[] Buffer
        {
            get
            {
                if (Data is string)
                    return Encoding.UTF8.GetBytes(this.Data as string);

                if (Data is byte[])
                    return this.Data as byte[];

                return Encoding.UTF8.GetBytes(this.Data.ToJson());
            }
        }
    }
}
