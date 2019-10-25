using System;
using System.Globalization;

namespace CSETWeb_Api.AssessmentIO.TestHarness
{
    public static class TimeStamp
    {
        public static string Now()
        {
            return DateTime.Now.ToTimeStamp();
        }
    }

    public static class TimeStampExtensions
    {
        public static string ToTimeStamp(this DateTime dateTime)
        {
            return $"{dateTime.Ticks:X}";
        }

        public static DateTime FromTimeStamp(this string timestamp)
        {
            return new DateTime(timestamp.TicksFromTimeStamp());
        }

        public static long TicksFromTimeStamp(this string timestamp)
        {
            Int64.TryParse(timestamp, NumberStyles.HexNumber, null, out long ticks);
            return ticks;
        }
    }
}
