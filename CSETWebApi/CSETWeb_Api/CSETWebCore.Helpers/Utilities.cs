using System;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.AspNetCore.Http;

namespace CSETWebCore.Helpers
{
    public class Utilities : IUtilities
    {
        private readonly IHttpContextAccessor _httpContext;
        private readonly ITokenManager _tokenManager;

        public Utilities(IHttpContextAccessor httpContext, ITokenManager tokenManager)
        {
            _httpContext = httpContext;
            _tokenManager = tokenManager;
        }
        public int UnixTime()
        {
            TimeSpan t = (DateTime.UtcNow - new DateTime(1970, 1, 1));
            return (int)t.TotalSeconds;
        }


        /// <summary>
        /// Converts a UTC time to the user's local time, based on the user's offset.
        /// This method should be used as close to the database as possible.  In other words,
        /// convert to local as soon as the data is fetched.
        /// </summary>
        /// <param name="dt"></param>
        /// <returns></returns>
        public DateTime UtcToLocal(DateTime dt)
        {
        
            string offsetMinutesString = _tokenManager.Payload(Constants.Constants.Token_TimezoneOffsetKey);
            if (offsetMinutesString == null)
            {
                return dt;
            }

            try
            {
                return dt.AddMinutes(int.Parse(offsetMinutesString) * -1);
            }
            catch (Exception exc)
            {
                return dt;
            }
        }


        /// <summary>
        /// Converts a local time to UTC, based on the user's offset.
        /// This method should be used as close to the database as possible.  In other words,
        /// convert to UTC just before inserting/updating.
        /// </summary>
        /// <param name="dt"></param>
        /// <returns></returns>
        public DateTime LocalToUtc(DateTime dt)
        {
            string offsetMinutesString = _tokenManager.Payload(Constants.Constants.Token_TimezoneOffsetKey);
            if (offsetMinutesString == null)
            {
                return dt;
            }

            return dt.AddMinutes(int.Parse(offsetMinutesString));
        }


        /// <summary>
        /// Returns the client host URI, based on the HTTP_REFERER value in the request.
        /// </summary>
        /// <returns></returns>
        public string GetClientHost()
        {
            var h = new Uri(_httpContext.HttpContext.Request.Headers["Referer"].ToString(), UriKind.RelativeOrAbsolute);
            return h.GetLeftPart(UriPartial.Authority);
        }


        /// <summary>
        /// Formats first and last name.  If the name is believed to be a domain\userid, 
        /// the userid is returned with the domain removed.
        /// </summary>
        /// <param name="firstName"></param>
        /// <param name="lastName"></param>
        /// <returns></returns>
        public string FormatName(string firstName, string lastName)
        {
            firstName = firstName.Trim();
            lastName = lastName.Trim();

            if (firstName.Length > 0 && lastName.Length > 0)
            {
                return string.Format("{0} {1}", firstName, lastName);
            }

            // if domain-qualified userid, remove domain
            if (firstName.IndexOf('\\') >= 0 && firstName.IndexOf(' ') < 0 && lastName.Length == 0)
            {
                return firstName.Substring(firstName.LastIndexOf('\\') + 1);
            }

            return string.Format("{0} {1}", firstName, lastName);
        }
    }
}
