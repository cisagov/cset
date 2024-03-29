using System;
using System.Linq;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Version;



namespace CSETWebCore.Business.Version
{
    public class VersionBusiness : IVersionBusiness
    {
        private CSETContext _context;

        public VersionBusiness(CSETContext context)
        {
            _context = context;
          
        }
        public CSET_VERSION getversionNumber()
        {
            var result = _context.CSET_VERSION
                   .OrderByDescending(v => v.Id)
                  .Take(1)
                  .FirstOrDefault();
            return result;
        }
    }
}

