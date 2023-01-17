//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Model.Assessment;

namespace CSETWebCore.Business.Demographic
{
    public interface ICisDemographicBusiness
    {
        int SaveOrgDemographics(CisOrganizationDemographics orgDemographics);
        int SaveServiceDemographics(CisServiceDemographics serviceDemographics);
        int SaveServiceComposition(CisServiceComposition serviceComposition);
        CisOrganizationDemographics GetOrgDemographics(int assessmentId);
        CisServiceDemographics GetServiceDemographics(int assessmentId);
        CisServiceComposition GetServiceComposition(int assessmentId);
    }
}