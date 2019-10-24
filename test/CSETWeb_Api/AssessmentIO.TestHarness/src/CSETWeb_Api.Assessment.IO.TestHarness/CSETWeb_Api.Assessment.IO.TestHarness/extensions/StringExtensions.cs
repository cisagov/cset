using System;
using System.IO;
using System.Linq;
using System.Text;

namespace CSETWeb_Api.AssessmentIO.TestHarness
{
    public static class StringExtensions
    {
        public static string SanitizePathPart(this string pathPart, char? replaceChar = null, params char[] invalidChars)
        {
            if (pathPart == null)
                return null;
            invalidChars = invalidChars.Any() ? invalidChars : Path.GetInvalidFileNameChars();
            var result = new StringBuilder(pathPart.Length);
            foreach (var character in pathPart.Trim())
            {
                if (!invalidChars.Contains(character))
                {
                    result.Append(character);
                }
                else if (replaceChar.HasValue && !invalidChars.Contains(replaceChar.Value))
                {
                    result.Append(replaceChar);
                }
            }
            var returnValue = result.ToString().Replace("..", ".").Replace("  ", " ").Replace("?", "");
            return returnValue;
        }
    }
}
