//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using BusinessLogic.Helpers;
using CSETWeb_Api.Helpers;
using DataLayer;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Globalization;

namespace CSET_Main.SALS
{
    /// <summary>
    /// Object that allows assigning a numerical weight to a sal value
    /// </summary>
    public class SALLevelNIST
    {
        public static SALLevelNIST SAL_NONE = new SALLevelNIST(0, Constants.SAL_NONE);
        public static SALLevelNIST SAL_LOW = new SALLevelNIST(1, Constants.SAL_LOW);
        public static SALLevelNIST SAL_MODERATE = new SALLevelNIST(2, Constants.SAL_MODERATE);
        public static SALLevelNIST SAL_HIGH = new SALLevelNIST(3, Constants.SAL_HIGH);
        public static SALLevelNIST SAL_VERY_HIGH = new SALLevelNIST(4, Constants.SAL_VERY_HIGH);
        public  static Dictionary<String, SALLevelNIST> StringValueToLevel = new Dictionary<string, SALLevelNIST>();

        public SALLevelNIST highestQuestionConfidentialityValue = SAL_LOW;
        public SALLevelNIST highestQuestionAvailabilityValue = SAL_LOW;
        public SALLevelNIST highestQuestionIntegrityValue = SAL_LOW;
        public SALLevelNIST highestInfoTypeConfidentialityValue = SAL_LOW;
        public SALLevelNIST highestInfoTypeAvailabilityValue = SAL_LOW;
        public SALLevelNIST highestInfoTypeIntegrityValue = SAL_LOW;

        static SALLevelNIST()
        {
            //TypeDescriptor.AddAttributes(typeof(NIST_SAL_INFO_TYPES), new TypeConverterAttribute(typeof(NIST_SAL_INFO_TYPESTypeConverter)));
            StringValueToLevel.Add(Constants.SAL_NONE.ToLower(), SAL_NONE);
            StringValueToLevel.Add(Constants.SAL_LOW.ToLower(), SAL_LOW);
            StringValueToLevel.Add(Constants.SAL_MODERATE.ToLower(), SAL_MODERATE);
            StringValueToLevel.Add(Constants.SAL_HIGH.ToLower(), SAL_HIGH);
            StringValueToLevel.Add(Constants.SAL_VERY_HIGH.ToLower(), SAL_VERY_HIGH);
        }

        public static SALLevelNIST GetWeightPair(String level)
        {
            if (String.IsNullOrWhiteSpace(level))
                return SAL_NONE;
            return StringValueToLevel[level.ToLower()];
        }

        public int SALValue { get; set; }
        public string SALName { get; set; }

        public SALLevelNIST(int weight, string name)
        {
            this.SALValue = weight;
            this.SALName = name;
        }
    }
    public sealed class NIST_SAL_INFO_TYPESTypeConverter : TypeConverter
    {
        public override bool CanConvertTo(ITypeDescriptorContext context, Type destinationType)
        {
            return destinationType == typeof(NistSpecialFactor);
        }

        public override object ConvertTo(ITypeDescriptorContext context, CultureInfo culture, object value, Type destinationType)
        {
            var concreteValue = (NIST_SAL_INFO_TYPES)value;
            var result = new NistSpecialFactor
            {
                Confidentiality_Value = concreteValue.Confidentiality_Value == null ? SALLevelNIST.SAL_LOW:SALLevelNIST.StringValueToLevel[concreteValue.Confidentiality_Value.ToLower()],
                Availability_Value = concreteValue.Availability_Value == null ? SALLevelNIST.SAL_LOW : SALLevelNIST.StringValueToLevel[concreteValue.Availability_Value.ToLower()],
                Integrity_Value = concreteValue.Integrity_Value == null ? SALLevelNIST.SAL_LOW : SALLevelNIST.StringValueToLevel[concreteValue.Integrity_Value.ToLower()]
            };
            return result;
        }
    }

}


