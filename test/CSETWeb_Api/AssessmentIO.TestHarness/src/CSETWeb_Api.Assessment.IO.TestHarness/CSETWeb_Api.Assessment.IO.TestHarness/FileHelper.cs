using System.IO;
using System.Text.RegularExpressions;

namespace CSETWeb_Api.AssessmentIO.TestHarness
{
    static class FileHelper
    {
        public static string GetSafeFileName(string filePath)
        {
            if (!filePath.IsValidPath())
                throw new IOException("Invalid File Path");

            var dir = Path.GetDirectoryName(filePath);
            if (!Directory.Exists(dir))
                return filePath;

            var id = 0;

            var fileName = Path.GetFileNameWithoutExtension(filePath);
            var ext = Path.GetExtension(filePath);
            var pattern = @"(\((\d+)\))$";
            var match = Regex.Match(fileName, pattern);
            if (match.Success)
            {
                id = match.Groups[2].Value.ParseInt32OrDefault();
                fileName = Regex.Replace(fileName, pattern, string.Empty).Trim();
            }

            var safeName = string.Concat(fileName, ext);
            while (File.Exists(Path.Combine(dir, safeName)))
            {
                id++;
                safeName = string.Concat(fileName, string.Format(" ({0})", id), ext);
            }
            return Path.Combine(dir, safeName);
        }
    }
}
