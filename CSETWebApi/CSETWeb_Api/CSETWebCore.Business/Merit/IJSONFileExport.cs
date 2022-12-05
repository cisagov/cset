namespace CSETWebCore.Business.Merit
{
    public interface IJSONFileExport
    {
        void SendFileToMerit(string filename, string data, string uncPath, bool overwrite);
        bool DoesFileExist(string filename, string uncPath);


    }
}