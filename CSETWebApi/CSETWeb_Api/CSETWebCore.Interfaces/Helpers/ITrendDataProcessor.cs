using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Aggregation;
using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface ITrendDataProcessor
    {
        Task Process(CSETContext db, int aggregationID, LineChart response, string Type);
    }
}