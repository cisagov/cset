//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using ICSharpCode.SharpZipLib.Zip;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;


namespace CSETWebCore.Business.AssessmentIO
{
    public class SharpZipLibWrapper : IDisposable
    {
        public readonly ZipOutputStream _zipStream;
        private readonly HashSet<string> _addedEntries;


        public SharpZipLibWrapper(Stream outputStream)
        {
            _zipStream = new ZipOutputStream(outputStream);
            _addedEntries = new HashSet<string>();
        }


        public string Password
        {
            get => _zipStream.Password;
            set => _zipStream.Password = value;
        }


        public void AddEntry(string entryName, string content)
        {
            if (_addedEntries.Contains(entryName))
            {
                throw new InvalidOperationException($"Entry '{entryName}' already exists in the ZIP archive.");
            }

            var entry = new ZipEntry(entryName)
            {
                DateTime = DateTime.Now
            };

            _zipStream.PutNextEntry(entry);
            byte[] buffer = Encoding.UTF8.GetBytes(content);
            _zipStream.Write(buffer, 0, buffer.Length);
            _zipStream.CloseEntry();

            _addedEntries.Add(entryName);
        }


        public void AddEntry(string entryName, Stream contentStream)
        {
            if (_addedEntries.Contains(entryName))
            {
                throw new InvalidOperationException($"Entry '{entryName}' already exists in the ZIP archive.");
            }

            var entry = new ZipEntry(entryName)
            {
                DateTime = DateTime.Now
            };

            _zipStream.PutNextEntry(entry);
            contentStream.CopyTo(_zipStream);
            _zipStream.CloseEntry();

            _addedEntries.Add(entryName);
        }


        /// <summary>
        /// 
        /// </summary>
        public bool ContainsEntry(string entryName)
        {
            return _addedEntries.Contains(entryName);
        }


        /// <summary>
        /// 
        /// </summary>
        public void Save()
        {
            _zipStream.Finish();
        }


        public void CloseStream()
        {
            _zipStream.IsStreamOwner = false; // Avoid closing the underlying stream
            _zipStream.Close();
        }

        public void Dispose()
        {
            _zipStream.Close();
        }
    }
}
