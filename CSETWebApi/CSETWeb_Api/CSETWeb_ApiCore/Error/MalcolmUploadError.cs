//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Api.Error
{
    public class MalcolmUploadError
    {
        public MalcolmUploadError(string file, int statusCodes, string message)
        {
            File = file;
            StatusCode = statusCodes;
            Message = message;
        }
        public string File { get; set; }
        public int StatusCode { get; set; }
        public string Message { get; set; }
    }
}