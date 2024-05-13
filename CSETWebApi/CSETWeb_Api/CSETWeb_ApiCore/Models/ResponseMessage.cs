namespace CSETWebCore.Api.Models
{
    public class ResponseMessage
    {
        public int Code { get; set; }
        public string Message { get; set; }

        /// <summary>
        /// CTOR
        /// </summary>
        /// <param name="m"></param>
        public ResponseMessage(int c, string m) { 
            this.Code = c;
            this.Message = m;
        }
    }
}
