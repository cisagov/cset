//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Interfaces.Sal
{
    public interface ISalBusiness
    {
        void SetDefaultSalIfNotSet(int assessmentId);
        void SetDefaultSal(int assessmentId, string level);
        void SetDefault(int assessmentId, string level);
    }
}