//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Helpers
{
    public class PasswordExpiration
    {
        private int _expiryTermDays = 180;


        /// <summary>
        /// Checks the password's age.
        /// </summary>
        /// <returns></returns>
        public bool IsExpired(CsetwebContext context, int userId, string passwordHash)
        {
            var hist = context.PASSWORD_HISTORY.Where(x => x.UserId == userId && x.Password == passwordHash).FirstOrDefault();
            if (hist == null)
            {
                return true;
            }

            if (hist.Created.AddDays(_expiryTermDays) < DateTime.UtcNow)
            {
                // the password is old
                return true;
            }

            return false;
        }
    }
}
