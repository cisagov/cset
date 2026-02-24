//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Aggregation;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface ITrendDataProcessor
    {
        Task ProcessAsync(CSETContext db, int aggregationID, LineChart response, string type);
    }
    
}