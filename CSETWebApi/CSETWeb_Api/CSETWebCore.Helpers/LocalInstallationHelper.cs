using CSETWebCore.DataLayer.Model;
using Microsoft.AspNetCore.Hosting;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.Helpers
{
    public class LocalInstallationHelper : ILocalInstallationHelper
    {

        private bool IsUpgraded = false;
        private readonly IHostingEnvironment _hostingEnvironment;
        private readonly CSETContext _context;

        public LocalInstallationHelper(IHostingEnvironment hostingEnvironment, CSETContext context)
        {
            _hostingEnvironment = hostingEnvironment;
            _context = context;
        }

        public async Task DetermineIfUpgradedNeededAndDoSo(int newuserID)
        {
            //look to see if the localuser exists
            //if so then get that user id and changes all 
            if (!IsUpgraded)
            {
                var user = await _context.USERS.Where(x => x.PrimaryEmail == "localuser").FirstOrDefaultAsync();
                if (user != null)
                {
                    var contacts = await  _context.ASSESSMENT_CONTACTS.Where(x => x.UserId == user.UserId).ToListAsync();
                    if (contacts.Any())
                        for (int i = 0; i < contacts.Count(); i++)
                            contacts[i].UserId = newuserID;

                    _context.ASSESSMENT_CONTACTS.UpdateRange(contacts);
                    await _context.SaveChangesAsync();
                }
            }
            IsUpgraded = true;
        }

        /// <summary>
        /// Returns 'true' if the installation is 'local' (self-contained using Windows identity).
        /// The local installer will place an empty file (LOCAL-INSTALLATION) in the website folder
        /// and the existence of the file indicates if the installation is local.
        /// </summary>
        /// <returns></returns>
        public bool IsLocalInstallation()
        {
            string physicalAppPath = _hostingEnvironment.ContentRootPath;

            return File.Exists(Path.Combine(physicalAppPath, "LOCAL-INSTALLATION"));
        }
    }
}
