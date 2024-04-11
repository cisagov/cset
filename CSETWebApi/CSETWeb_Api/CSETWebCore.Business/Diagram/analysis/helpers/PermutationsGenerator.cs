//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;

namespace CSETWebCore.Business.Diagram.analysis.helpers
{
    public class CombinationsGenerator
    {

        /// <summary>        
        /// Generating combinations is exponentially horrific do not
        /// REPEAT do not do this for a large number (ie greater than 10)
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="list"></param>
        /// <returns></returns>
        public List<List<T>> GetAllCombos<T>(List<T> list)
        {
            int comboCount = (int)Math.Pow(2, list.Count) - 1;
            List<List<T>> result = new List<List<T>>();
            for (int i = 1; i < comboCount + 1; i++)
            {
                // make each combo here
                result.Add(new List<T>());
                for (int j = 0; j < list.Count; j++)
                {
                    if ((i >> j) % 2 != 0)
                        result.Last().Add(list[j]);
                }
            }
            return result;
        }
    }


}
