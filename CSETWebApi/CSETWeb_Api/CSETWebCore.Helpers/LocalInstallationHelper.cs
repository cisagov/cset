//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using Microsoft.AspNetCore.Hosting;
using System.IO;
using System.Linq;

namespace CSETWebCore.Helpers
{
    public class LocalInstallationHelper : ILocalInstallationHelper
    {

        private bool IsUpgraded = false;
        private readonly IWebHostEnvironment _hostingEnvironment;

        public LocalInstallationHelper(IWebHostEnvironment hostingEnvironment)
        {
            _hostingEnvironment = hostingEnvironment;
        }

        public void determineIfUpgradedNeededAndDoSo(int newuserID, CSETContext tmpContext)
        {
            //look to see if the localuser exists
            //if so then get that user id and changes all 
            if (!IsUpgraded)
            {
                var user = tmpContext.USERS.Where(x => x.PrimaryEmail == "localuser").FirstOrDefault();
                if (user != null)
                {
                    var contacts = tmpContext.ASSESSMENT_CONTACTS.Where(x => x.UserId == user.UserId).ToList();
                    if (contacts.Any())
                        for (int i = 0; i < contacts.Count(); i++)
                            contacts[i].UserId = newuserID;

                    tmpContext.ASSESSMENT_CONTACTS.UpdateRange(contacts);
                    tmpContext.SaveChanges();
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
