//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Enum.EnumHelper
{
    public static class StringToEnum
    {
        public static T ToEnum<T>(this string s)
        {
            return (T)System.Enum.Parse(typeof(T), s);
        }
    }
}