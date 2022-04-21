using CSETWebCore.Model.Assessment;

namespace CSETWebCore.Business.Demographic
{
    public interface ICistDemographicBusiness
    {
        int SaveOrgDemographics(CistOrganizationDemographics orgDemographics);
        int SaveServiceDemographics(CistServiceDemographics serviceDemographics);
        int SaveServiceComposition(CistServiceComposition serviceComposition);
        CistOrganizationDemographics GetOrgDemographics(int assessmentId);
        CistServiceDemographics GetServiceDemographics(int assessmentId);
        CistServiceComposition GetServiceComposition(int assessmentId);
    }
}