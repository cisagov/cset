//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Model.Acet;

namespace CSETWebCore.Interfaces.IRP
{
    public interface IIRPBusiness
    {
        IRPResponse GetIRPList(int assessmentId, string lang);
        void PersistSelectedIRP(int assessmentId, IRPModel irp);
    }
}