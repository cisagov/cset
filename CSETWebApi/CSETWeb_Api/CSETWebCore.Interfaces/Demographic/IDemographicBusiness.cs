using CSETWebCore.Model.Assessment;

namespace CSETWebCore.Interfaces.Demographic
{
    public interface IDemographicBusiness
    {
        Demographics GetDemographics(int assessmentId);
        AnalyticsDemographic GetAnonymousDemographics(int assessmentId);
        int SaveDemographics(Demographics demographics);
    }
}