//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;

namespace CSETWebCore.Enum.EnumHelper
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
        public static String GetStringAttribute(this System.Enum enumValue)
        {
            return enumValue.GetAttributeOfType<StringAttr>().StringValue;
        }
    }
}