//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWeb_Api.Helpers;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;

namespace CSETWeb_Api.BusinessLogic.Helpers.upload
{
    public class FileUploadStream
    {
        public async Task<FileUploadStreamResult> ProcessUploadStream(HttpRequestMessage request, Dictionary<string,string> formKeys)
        {
            if (!request.Content.IsMimeMultipartContent())
            {
                throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
            }
            
            var streamProvider = new InMemoryMultipartFormDataStreamProvider();
            await request.Content.ReadAsMultipartAsync<InMemoryMultipartFormDataStreamProvider>(streamProvider);
            FileUploadStreamResult result = new FileUploadStreamResult()
            {
                FormNameValues = formKeys                
            };

            //access form data
            NameValueCollection formData = streamProvider.FormData;
            foreach (HttpContent ctnt in streamProvider.Files)
            {
                // You would get hold of the inner memory stream here              
                using (Stream fs = ctnt.ReadAsStreamAsync().Result)
                {
                    string filename = ctnt.Headers.ContentDisposition.FileName.Trim("\"".ToCharArray());
                    string contentType = ctnt.Headers.ContentType.MediaType;
                    using (BinaryReader br = new BinaryReader(fs))
                    {
                        byte[] bytes = br.ReadBytes((Int32)fs.Length);
                        // Hash the file so that we can determine if it is already attached to another question

                        using (var md5 = MD5.Create())
                        {
                            var hash = md5.ComputeHash(bytes);
                            result.FileResultList.Add(new FileUploadResult()
                            {
                                FileHash = BitConverter.ToString(hash).Replace("-", "").ToLowerInvariant(),
                                FileBytes = bytes,
                                 FileName = filename,
                                 ContentType = contentType                                  
                            });
                        }   
                    }
                }
            }

            List<string> keys = formKeys.Keys.ToList();
            foreach (string key in keys)
            {
                if (formKeys.ContainsKey(key))
                    formKeys[key] = streamProvider.FormData[key];
                else
                {
                    result.ErrorsList.Add(key + " not found");
                }
            }

            if (result.ErrorsList.Count > 0)
                throw new UploadFormException("Could not find required form variables.  See errorlist for details.");
            return result;

        }
    }

  

    public class FileUploadResult
    {
        private byte[] filebytes;
        public byte[] FileBytes { get {
                return filebytes;
            }
            set {
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
