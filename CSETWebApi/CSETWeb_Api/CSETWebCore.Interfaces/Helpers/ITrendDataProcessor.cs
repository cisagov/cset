//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Aggregation;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface ITrendDataProcessor
    {
        void Process(CSETContext db, int aggregationID, LineChart response, string Type);
    }
}