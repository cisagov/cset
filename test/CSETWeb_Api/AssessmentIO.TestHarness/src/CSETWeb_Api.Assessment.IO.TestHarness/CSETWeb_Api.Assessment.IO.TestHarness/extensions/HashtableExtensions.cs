using System.Collections;

namespace CSETWeb_Api.AssessmentIO.TestHarness
{
    public static class HashtableExtensions
    {
        public static T GetValueOrDefault<T>(this Hashtable ht, string key, T defaultValue = default(T))
        {
            if (!ht.Contains(key))
                return defaultValue;
            return (T)ht[key];
        }
    }
}
