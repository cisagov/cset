//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

namespace CSETWeb_Api.BusinessLogic.AssessmentIO
{
    public static class IOHelper
    {
        public static string GetFileExtension(string appCode)
        {
            var code = appCode ?? string.Empty;
            switch (code.ToUpper())
            {
                case "ACET":
                    return ".acet";
                case "CSET":
                default:
                    return ".csetw";
            }
        }
    }
}
