using System.Net;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace CSETWebCore.Reports.Helper
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