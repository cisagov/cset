using System.IO;

namespace CSETWeb_Api.AssessmentIO.TestHarness
{
    public static class DirectoryInfoExtensions
    {
        public static void Clear(this DirectoryInfo di)
        {
            foreach (var file in di.GetFiles())
                file.Delete();
            foreach (var folder in di.GetDirectories())
            {
                folder.Clear();
                folder.Delete();
            }
        }
    }
}
