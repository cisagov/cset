using System;
using System.Globalization;

namespace CSETWeb_Api.AssessmentIO.TestHarness
{
    public static class ObjectExtensions
    {
        public static int ParseInt32OrDefault(this object value, int defaultValue = 0)
        {
            if (value is int)
                return (int)value;
            return (value is string) ? ParseInt32OrDefault(value as string, defaultValue) : defaultValue;
        }

        public static int ParseInt32OrDefault(this string stringValue, int defaultValue = 0, NumberStyles numberStyles = NumberStyles.None)
        {
            if (string.IsNullOrEmpty(stringValue))
                return defaultValue;
            return Int32.TryParse(stringValue, numberStyles, CultureInfo.InvariantCulture, out int result) ? result : defaultValue;
        }
    }
}
