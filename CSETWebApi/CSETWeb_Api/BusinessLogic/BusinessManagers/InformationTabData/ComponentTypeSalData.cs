//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSET_Main.Questions.InformationTabData
{
    public class ComponentTypeSalData
    {
        //public String ComponentType { get; set; }
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


