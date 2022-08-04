using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface IAssessmentUtil
    {
        Task TouchAssessment(int assessmentId);
    }
}