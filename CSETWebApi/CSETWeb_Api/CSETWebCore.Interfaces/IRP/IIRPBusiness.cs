using CSETWebCore.Model.Acet;
using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.IRP
{
    public interface IIRPBusiness
    {
        Task<IRPResponse> GetIRPList(int assessmentId);
        Task PersistSelectedIRP(int assessmentId, IRPModel irp);
    }
}