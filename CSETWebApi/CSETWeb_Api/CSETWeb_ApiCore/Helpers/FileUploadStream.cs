//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Cryptography;
using System.Threading.Tasks;
using CSETWebCore.Model.Document;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.StaticFiles;

namespace CSETWebCore.Helpers
{
    public class FileUploadStream
    {
#pragma warning disable CS1998 // Async method lacks 'await' operators and will run synchronously
        public async Task<FileUploadStreamResult> ProcessUploadStream(HttpContext request, Dictionary<string, string> formKeys)
#pragma warning restore CS1998 // Async method lacks 'await' operators and will run synchronously
        {
            FileUploadStreamResult result = new FileUploadStreamResult()
            {
                FormNameValues = formKeys
            };

            //access form data
            var formData = request.Request.Form;
            foreach (FormFile ctnt in request.Request.Form.Files)
            {
                // You would get hold of the inner memory stream here              

                string filename = ctnt.FileName.Trim("\"".ToCharArray());
                var provider = new FileExtensionContentTypeProvider();
                string contentType;
                if (!provider.TryGetContentType(filename, out contentType))
                {
                    contentType = "application/octet-stream";
                }
                var target = new MemoryStream();
                ctnt.CopyTo(target);

                var bytes = target.ToArray();
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

            List<string> keys = formKeys.Keys.ToList();
            foreach (string key in keys)
            {
                if (formKeys.ContainsKey(key))
                    formKeys[key] = formData[key];
                else
                {
                    result.ErrorsList.Add(key + " not found");
                }
            }

            //if (result.ErrorsList.Count > 0)
            //throw new UploadFormException("Could not find required form variables.  See errorlist for details.");
            return result;

        }
    }
}