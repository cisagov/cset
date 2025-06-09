using System;
using System.Linq;
using System.Reflection;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Version;

namespace CSETWebCore.Business.Version
{
    /// <summary>
    /// Returns version breakdowns of the codebase (found by reflection of the Assembly)
    /// and the database (as found in the CSET_VERSION table).
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
            var response = new CsetVersion();


            // Codebase
            var entryAssembly = Assembly.GetEntryAssembly();
            var verCode = entryAssembly.GetName().Version;
            response.CodebaseVersion = new DataLayer.Model.Version
            {
                MajorVersion = verCode.Major,
                MinorVersion = verCode.Minor,
                Build = verCode.Build,
                Revision = verCode.Revision
            };


            // Database
            var verData = _context.CSET_VERSION.OrderByDescending(v => v.Id).FirstOrDefault();
            if (verData != null && verData.Cset_Version1?.Any() == true)
            {
                System.Version v = new System.Version(verData.Cset_Version1);

                response.DatabaseVersion = new DataLayer.Model.Version
                {
                    MajorVersion = v.Major,
                    MinorVersion = v.Minor,
                    Build = v.Build,
                    Revision = v.Revision
                };
            }

            return response;
        }
    }
}
