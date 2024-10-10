using System;
using System.Linq;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Version;
namespace CSETWebCore.Business.Version
{
    /// <summary>
    /// 
    /// </summary>
    public class VersionBusiness : IVersionBusiness
    {
        private CSETContext _context;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public VersionBusiness(CSETContext context)
        {
            _context = context;

        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public CsetVersion GetVersionNumber()
        {
            var version = _context.CSET_VERSION.OrderByDescending(v => v.Id).FirstOrDefault();

            if (version != null && version.Cset_Version1?.Any() == true)
            {
                System.Version v = new System.Version(version.Cset_Version1);

                return new CsetVersion
                {
                    MajorVersion = v.Major,
                    MinorVersion = v.Minor,
                    Build = v.Build,
                    Revision = v.Revision
                };
            }

            return new CsetVersion { MajorVersion = 0, MinorVersion = 0, Build = 0, Revision = 0 };
        }
    }
}
