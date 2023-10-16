//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
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
    }
}