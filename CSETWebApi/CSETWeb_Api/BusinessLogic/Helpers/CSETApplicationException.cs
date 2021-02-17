//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CSETWeb_Api.Helpers
{
    public class CSETApplicationException:Exception
    {
        public CSETApplicationException(string custommessage, Exception e):base(custommessage,e)
        {

        }
    }
}

