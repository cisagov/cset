//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface IUtilities
    {
        int UnixTime();
        DateTime UtcToLocal(DateTime dt);
        DateTime LocalToUtc(DateTime dt);
        string GetClientHost();
        void MoveActionItemsFrom_IseActions_To_HydroData(CSETContext context);
    }
}
