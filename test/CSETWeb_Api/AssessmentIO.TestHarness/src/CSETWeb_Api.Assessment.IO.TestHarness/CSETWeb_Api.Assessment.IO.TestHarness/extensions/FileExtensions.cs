using System.Text.RegularExpressions;

namespace CSETWeb_Api.AssessmentIO.TestHarness
{
    public static class FileExtensions
    {
        public static bool IsValidPath(this string path)
        {
            var r = new Regex(@"^(([a-zA-Z]\:)|(\\))(\\{1}|((\\{1})[^\\]([^/:*?<>""|]*))+)$");
            return r.IsMatch(path);
        }
    }
}
