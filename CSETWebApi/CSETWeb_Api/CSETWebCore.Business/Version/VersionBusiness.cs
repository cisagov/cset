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
        public CsetVersionResponse getversionNumber()
        {
            var version = _context.CSET_VERSION.OrderByDescending(v => v.Id).FirstOrDefault();

            if (version != null && version.Cset_Version1?.Any() == true)
            {
                var versionNumbers = version.Cset_Version1.Split('.').Select(int.Parse).ToList();
                return new CsetVersionResponse
                {
                    MajorVersion = versionNumbers[0],
                    MinorVersion = versionNumbers[1],
                    Patch = versionNumbers[2],
                    Build = versionNumbers[3]
                };
            }

            return new CsetVersionResponse { MajorVersion = 0, MinorVersion = 0, Patch = 0, Build = 0 };
        }
    }
}
