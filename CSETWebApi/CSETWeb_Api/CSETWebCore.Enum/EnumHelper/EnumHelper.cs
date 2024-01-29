//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

namespace CSETWebCore.Enum.EnumHelper
{
    public static class EnumHelper
    {
        public static T GetAttributeOfType<T>(this System.Enum enumVal) where T : System.Attribute
        {
            var type = enumVal.GetType();
            var memInfo = type.GetMember(enumVal.ToString());
            var attributes = memInfo[0].GetCustomAttributes(typeof(T), false);
            return (T)attributes[0];
        }

        public static List<T> GetListEnums<T>()
        {
            return System.Enum.GetValues(typeof(T)).Cast<T>().ToList();
        }

        public static string GetDescriptionFromEnumValue(System.Enum value)
        {
            StringAttr attribute = value.GetType()
                .GetField(value.ToString())
                .GetCustomAttributes(typeof(StringAttr), false)
                .SingleOrDefault() as StringAttr;
            return attribute == null ? value.ToString() : attribute.StringValue;
        }

        public static T GetEnumValueFromDescription<T>(string description)
        {
            var type = typeof(T);
            if (!type.IsEnum)
                throw new ArgumentException();
            FieldInfo[] fields = type.GetFields();
            var field = fields
                .SelectMany(f => f.GetCustomAttributes(
                    typeof(StringAttr), false), (
                    f, a) => new { Field = f, Att = a })
                .Where(a => ((StringAttr)a.Att)
                            .StringValue == description).SingleOrDefault();
            return field == null ? default(T) : (T)field.Field.GetRawConstantValue();
        }
    }
}