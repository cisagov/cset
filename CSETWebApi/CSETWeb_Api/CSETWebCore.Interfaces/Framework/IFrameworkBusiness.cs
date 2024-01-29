//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Model.Framework;

namespace CSETWebCore.Interfaces.Framework
{
    public interface IFrameworkBusiness
    {
        FrameworkResponse GetFrameworks(int assessmentId);
        void PersistSelectedTierAnswer(int assessmentId, TierSelection selectedTier);
    }
}