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
        /// <summary>
        /// Returns the export extension for the app being run (CSET or ACET)
        /// </summary>
        /// <param name="appCode"></param>
        /// <returns></returns>
        public static string GetExportFileExtension(string appCode)
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


        /// <summary>
        /// Returns supported extensions that can be imported.
        /// </summary>
        /// <param name="appCode"></param>
        /// <returns></returns>
        public static string GetImportFileExtensions(string appCode)
        {
            return ".csetw, .acet";
        }
    }
}
