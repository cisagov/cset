using CSETWebCore.Model.Assessment;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Demographic
{
    public interface ICisDemographicBusiness
    {
        Task<int> SaveOrgDemographics(CisOrganizationDemographics orgDemographics);
        Task<int> SaveServiceDemographics(CisServiceDemographics serviceDemographics);
        Task<int> SaveServiceComposition(CisServiceComposition serviceComposition);
        CisOrganizationDemographics GetOrgDemographics(int assessmentId);
        CisServiceDemographics GetServiceDemographics(int assessmentId);
        CisServiceComposition GetServiceComposition(int assessmentId);
    }
}