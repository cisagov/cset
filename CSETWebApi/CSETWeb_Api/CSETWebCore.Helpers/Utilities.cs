//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.AspNetCore.Http;
using NPOI.SS.Formula.Functions;

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
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

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
            var referrer = _httpContext.HttpContext.Request.Headers["Referer"].ToString();
            if (referrer == string.Empty)
            {
                return string.Empty;
            }

            var h = new Uri(referrer, UriKind.RelativeOrAbsolute);
            return h.GetLeftPart(UriPartial.Authority);
        }


        /// <summary>
        /// One-time use function that moves Hydro-specific action items 
        /// out of the ISE_ACTIONS table and into the HYDRO_DATA table
        /// </summary>
        /// <returns></returns>
        public void MoveActionItemsFrom_IseActions_To_HydroData(CSETContext context)
        {
            /*
            var actionsToMove = context.ISE_ACTIONS.Where(x => x.Mat_Option_Id != null).ToList();
            var hydroActions = context.HYDRO_DATA.ToList();

            foreach ( var iseAction in actionsToMove )
            {
                if ( iseAction != null )
                {
                    var hydroRow = hydroActions.Where(x => x.Mat_Option_Id == iseAction.Mat_Option_Id).FirstOrDefault();
                    if ( hydroRow != null )
                    {
                        hydroRow.Action_Item_Description = iseAction.Description;
                        hydroRow.Action_Items = iseAction.Action_Items;
                        hydroRow.Severity = iseAction.Severity;
                        hydroRow.Sequence = iseAction.Sequence;

                        context.SaveChanges();
                    }
                }
            }
            */

        }
    }
}
