using CSETWebCore.Interfaces.Helpers;

namespace DuplicateAssessments
{
    internal class MockUtilities : IUtilities
    {
        public string GetClientHost()
        {
            return "localhost";
        }

        public DateTime LocalToUtc(DateTime dt)
        {
            throw new NotImplementedException();
        }

        public int UnixTime()
        {
            throw new NotImplementedException();
        }

        public DateTime UtcToLocal(DateTime dt)
        {
            throw new NotImplementedException();
        }
    }
}