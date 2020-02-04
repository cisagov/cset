//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using DataAccess.Attributes;
using DataAccess.Model;
using DataLayerCore.Model;

namespace DataAccess
{
    [LifecycleTransient]
    public class FileRepository : IFileRepository, IDisposable
    {
        private CSET_Context _context;
        public FileRepository()
        {
            _context = new CSET_Context();
        }

        public IEnumerable<FileDescriptionShort> AddFileDescriptions(FileResult fileResult)
        {
            List<string> filenames = new List<string>();
            for (int i = 0; i < fileResult.FileNames.Count(); i++)
            {
                var fileDescription = new DOCUMENT_FILE
                {
                    ContentType = fileResult.ContentTypes[i],
                    Path = fileResult.FileNames[i],                    
                    CreatedTimestamp = fileResult.CreatedTimestamp,
                    UpdatedTimestamp = fileResult.UpdatedTimestamp,
                    Title = fileResult.Tiitle
                };

                filenames.Add(fileResult.FileNames[i]);
                _context.DOCUMENT_FILE.Add(fileDescription);
            }

            _context.SaveChanges();            
            return GetNewFiles(filenames);
        }

        private IEnumerable<FileDescriptionShort> GetNewFiles(List<string> filenames)
        {
            IEnumerable<DOCUMENT_FILE> x = _context.DOCUMENT_FILE.Where(r => filenames.Contains(r.Path));
            return x.Select(t => new FileDescriptionShort { Name = t.Name, Path = t.Path, Id = t.Document_Id, Title = t.Title });
        }

        public IEnumerable<FileDescriptionShort> GetAllFiles(int assessment_id)
        {
            return _context.DOCUMENT_FILE.Where(x=> x.Assessment_Id == assessment_id).Select(
                    t => new FileDescriptionShort { Name = t.Name, Path = t.Path, Id = t.Document_Id, Title = t.Title });
        }

        public DOCUMENT_FILE GetFileDescription(int id)
        {
            DOCUMENT_FILE doc =  _context.DOCUMENT_FILE.Single(t => t.Document_Id == id);
            return doc;
        }


        public void Dispose()
        {
            if (_context != null)
            {
                _context.Dispose();
                _context = null;
            }
        }
    }
}



