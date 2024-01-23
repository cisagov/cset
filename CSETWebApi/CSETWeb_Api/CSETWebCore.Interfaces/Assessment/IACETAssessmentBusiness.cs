//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Assessment;

namespace CSETWebCore.Interfaces.Assessment
{
    public interface IACETAssessmentBusiness
    {
        int SaveAssessmentDetail(int assessmentId, AssessmentDetail assessmentDetail);
        bool? GetIseSubmission(int assessmentId);
        void UpdateIseSubmission(int assessmentId);
    }
}