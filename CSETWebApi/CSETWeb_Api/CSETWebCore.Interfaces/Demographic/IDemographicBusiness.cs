//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Model.Assessment;

namespace CSETWebCore.Interfaces.Demographic
{
    public interface IDemographicBusiness
    {
        Demographics GetDemographics(int assessmentId);
        AnalyticsDemographic GetAnonymousDemographics(int assessmentId);
        int SaveDemographics(Demographics demographics);
        int SaveDemographics(Model.Demographic.ExtendedDemographic demographics);
    }
}