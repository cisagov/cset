//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;

namespace CSET_Main.Common
{
    public static class CommonExtensionMethod
    {
        //public static HashSet<T> ToHashSet<T>(this IEnumerable<T> source)
        //{
        //    return new HashSet<T>(source);
        //}

        public static void TryAdd<TKey, TValue>(this Dictionary<TKey, TValue> dictionary,
                 TKey key, TValue value)
        {
            if (!dictionary.ContainsKey(key))
                dictionary.Add(key, value);
        }

        public static IEnumerable<TSource> DistinctBy<TSource, TKey>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector)
        {
            HashSet<TKey> seenKeys = new HashSet<TKey>();
            foreach (TSource element in source)
            {
                if (seenKeys.Add(keySelector(element)))
                {
                    yield return element;
                }
            }
        }
    }
}


