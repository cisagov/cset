//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Business.Reports
{
    public class MvraSummary
    {
        private CSETContext _context;

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="context"></param>
        public MvraSummary(CSETContext context)
        {
            this._context = context;
        }



    }
}
