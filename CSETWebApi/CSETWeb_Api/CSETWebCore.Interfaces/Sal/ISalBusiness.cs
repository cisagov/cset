namespace CSETWebCore.Interfaces.Sal
{
    public interface ISalBusiness
    {
        void SetDefaultSAL_IfNotSet(int assessmentId);
        void SetDefaultSALs(int assessmentId, string level);
        void SetDefault(int assessmentId, string level);
    }
}