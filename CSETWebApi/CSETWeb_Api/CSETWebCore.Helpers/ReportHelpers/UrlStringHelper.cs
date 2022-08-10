using Microsoft.AspNetCore.Http;

namespace CSETWebCore.Helpers.ReportHelpers
{
    public static class UrlStringHelper
    {
        public static string GetBaseUrl(HttpRequest request)
        {
            var url = string.Format("{0}://{1}", request.Scheme, request.Host.ToUriComponent());
            return url;
        }
    }
}