//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Document
{
    public class FileUploadResult
    {
        private byte[] filebytes;
        public byte[] FileBytes
        {
            get
            {
                return filebytes;
            }
            set
            {
                filebytes = value;
                this.FileSize = filebytes.LongLength;
            }
        }
        public string FileHash { get; set; }
        public string FileName { get; set; }
        public string ContentType { get; set; }
        public long FileSize { get; set; }
    }
}