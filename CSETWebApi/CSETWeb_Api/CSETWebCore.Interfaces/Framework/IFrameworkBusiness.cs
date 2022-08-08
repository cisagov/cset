using CSETWebCore.Model.Framework;
using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.Framework
{
    public interface IFrameworkBusiness
    {
        FrameworkResponse GetFrameworks(int assessmentId);
        Task PersistSelectedTierAnswer(int assessmentId, TierSelection selectedTier);
    }
}