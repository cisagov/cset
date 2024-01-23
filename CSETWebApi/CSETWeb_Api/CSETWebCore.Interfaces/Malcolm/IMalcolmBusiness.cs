//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Model.Malcolm;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.Malcolm
{
    public interface IMalcolmBusiness
    {
        public List<MalcolmData> GetMalcolmJsonData(List<MalcolmData> list);
    }
}
