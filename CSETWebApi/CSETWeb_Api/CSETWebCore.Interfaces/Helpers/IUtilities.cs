//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface IUtilities
    {
        int UnixTime();
        DateTime UtcToLocal(DateTime dt);
        DateTime LocalToUtc(DateTime dt);
        string GetClientHost();
    }
}
