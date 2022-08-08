using CSETWebCore.Model.Assessment;
using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.Demographic
{
    public interface IDemographicBusiness
    {
        Demographics GetDemographics(int assessmentId);
        AnalyticsDemographic GetAnonymousDemographics(int assessmentId);
        Task<int> SaveDemographics(Demographics demographics);
    }
}