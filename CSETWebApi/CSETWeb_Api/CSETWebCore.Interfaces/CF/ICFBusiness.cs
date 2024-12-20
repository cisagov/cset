//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.CF
{
    public interface ICFBusiness
    {
        public Task<string> callBull(int assessmentId, int userId);
    }
}