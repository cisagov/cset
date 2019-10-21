using CSETWeb_Api.BusinessLogic.ImportAssessment;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers
{
    internal class CSET901_to_92Upgrade : ICSETJSONFileUpgrade
    {
        /// <summary>
        /// this is the string we will be upgrading to
        /// </summary>
        static string version = "9.2";
        public string ExecuteUpgrade(string json)
        {
            throw new System.NotImplementedException();
        }

        public string GetVersion()
        {
            return version;
        }
    }
}