using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.Sal
{
    public interface ISalBusiness
    {
        Task SetDefaultSAL_IfNotSet(int assessmentId);
        Task SetDefaultSALs(int assessmentId, string level);
        Task SetDefault(int assessmentId, string level);
    }
}