//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Model.Acet;

namespace CSETWebCore.Interfaces.IRP
{
    public interface IIRPBusiness
    {
        IRPResponse GetIRPList(int assessmentId);
        void PersistSelectedIRP(int assessmentId, IRPModel irp);
    }
}