using CSETWebCore.DataLayer;
using CSETWebCore.Model.Aggregation;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface ITrendDataProcessor
    {
        void Process(CSETContext db, int aggregationID, LineChart response, string Type);
    }
}