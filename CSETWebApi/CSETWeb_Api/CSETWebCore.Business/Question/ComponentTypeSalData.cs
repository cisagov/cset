//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Business.Question
{
    public class ComponentTypeSalData
    {
        public int Component_Symbol_Id { get; set; }
        public HashSet<int> SALLevels { get; set; }

        internal bool HasComponentAtSALLevels(int salLevel)
        {
            foreach (int salComponents in SALLevels)
            {
                if (salComponents >= salLevel)
                    return true;
            }
            return false;
        }
    }
}