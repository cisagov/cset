//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using CSETWebCore.Interfaces;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Helpers
{
    public class DocumentImporter
    {
        private CSETContext _context;


        public DocumentImporter(CSETContext context)
        {
            _context = context;
        }


        public GEN_FILE LookupGenFile(string p)
        {
            GEN_FILE gf;

            gf = (from h in _context.GEN_FILE
                  where h.File_Name == p
                  orderby h.Gen_File_Id descending
                  select h).FirstOrDefault();

            return gf;
        }


        public int LookupGenFileId(string fileName)
        {
            GEN_FILE gf = (from h in _context.GEN_FILE
                           where h.File_Name == fileName
                           orderby h.Gen_File_Id descending
                           select h).FirstOrDefault();
            if (gf == null)
                return 0;

            return gf.Gen_File_Id;
        }
    }
}