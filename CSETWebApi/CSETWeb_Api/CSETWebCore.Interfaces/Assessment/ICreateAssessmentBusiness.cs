//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Model.Assessment;

namespace CSETWebCore.Interfaces.Assessment
{
    public interface ICreateAssessmentBusiness
    {
        AssessmentDetail CreateNewAssessment(int? currentUserId, string workflow, GalleryConfig config);
        int SaveAssessmentDetail(int assessmentId, AssessmentDetail assessment);
    }
}