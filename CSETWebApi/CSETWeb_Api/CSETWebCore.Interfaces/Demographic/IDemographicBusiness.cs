//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Model.Assessment;

namespace CSETWebCore.Interfaces.Demographic
{
    public interface IDemographicBusiness
    {
        Demographics GetDemographics(int assessmentId);
        int SaveDemographics(Demographics demographics);
    }
}