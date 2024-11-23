//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Contact
{
    public interface IConversionBusiness
    {
        void ConvertCF(int assessmentId);
        List<CFEntry> IsEntryCF(List<int> assessmentIds);
        public bool IsMidCF(int assessmentId);
        bool IsEntryCF(int assessmentId);
        Task<string> ConvertEntryToMid(int assessmentId);
        Task<string> ConvertMidToFull(int assessmentId);
    }
}