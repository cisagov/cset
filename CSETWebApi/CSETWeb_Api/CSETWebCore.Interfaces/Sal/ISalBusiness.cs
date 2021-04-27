namespace CSETWebCore.Interfaces.Sal
{
    public interface ISalBusiness
    {
        void SetDefaultSAL_IfNotSet(int assessmentId);
        void SetDefaultSALs(int assessmentId);
        void Setdefault(int assessmentId);
    }
}