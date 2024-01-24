//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer;
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
