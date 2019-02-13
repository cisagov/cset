//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSET_Main.Common.EnumHelper
{
    public class StringAttr : Attribute
    {
        public StringAttr(String stringValue)
        {
            this.StringValue = stringValue;

        }
        public String StringValue { get; private set; }

    }

    public static class GetString
    {
        public static String GetStringAttribute(this Enum enumValue)
        {
            return enumValue.GetAttributeOfType<StringAttr>().StringValue;
        }

       
    }
}


