//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Elmah;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.Http.ModelBinding;

namespace CSETWeb_Api.Helpers
{
    public static class ElmahWrapper
    {
        public static HttpResponseMessage LogAndReportModelError(ModelStateDictionary modelState, HttpRequestMessage request, HttpContext context)
        {
            var errorMessages = modelState.Values.Where(a => a.Errors != null && a.Errors.Count > 0)
                .SelectMany(x => x.Errors).SelectMany(y => y.ErrorMessage);
            var exceptionMessages = modelState.Values.Where(a => a.Errors != null && a.Errors.Count > 0)
                .SelectMany(x => x.Errors).Where(b => b.Exception != null).Select(y => y.Exception).SelectMany(z => z.Message);
            var fullErrorMessage = string.Join("", errorMessages) + " Exception: " + string.Join("", exceptionMessages);
            var exceptionMessage = " The model state is invalid. The errors are: " + fullErrorMessage;
            WriteToMemory(new Exception(exceptionMessage), context);
            return request.CreateResponse(HttpStatusCode.BadRequest, exceptionMessage);
        }

        //public static HttpResponseMessage LogAndReportDbEntityValidationException(DbEntityValidationException ex, HttpRequestMessage request)
        //{
        //    return LogAndReportDbEntityValidationException(ex, request, HttpContext.Current);
        //}

        //public static HttpResponseMessage LogAndReportDbEntityValidationException(DbEntityValidationException ex, HttpRequestMessage request, HttpContext context)
        //{
        //    // Retrieve the error messages as a list of strings.
        //    var errorMessages = ex.EntityValidationErrors
        //        .SelectMany(x => x.ValidationErrors)
        //        .Select(x => x.ErrorMessage);

        //    // Join the list to a single string.
        //    var fullErrorMessage = string.Join("; ", errorMessages);

        //    // Combine the original exception message with the new one.
        //    var exceptionMessage = string.Concat(ex.Message, " The validation errors are: ", fullErrorMessage);

        //    WriteToMemory(ex, context);
        //    WriteToMemory(new Exception(exceptionMessage), context);
        //    return request.CreateResponse(HttpStatusCode.InternalServerError);
        //}
        public static HttpResponseMessage LogAndReportException(Exception e, HttpRequestMessage request, HttpContext context)
        {
            WriteToMemory(e, context);
            string message;
            if (e.InnerException != null && e.InnerException.InnerException != null)
            {
                message = e.InnerException.InnerException.Message;
            }
            else if (e.InnerException != null)
            {
                message = e.InnerException.Message;
            }
            else
            {
                message = e.Message;
            }
            message += " STACK: " + e.StackTrace;
            return request.CreateResponse(HttpStatusCode.NotFound, message);
        }
        public static HttpResponseMessage LogAndReportDbUpdateException(DbUpdateException dbe, HttpRequestMessage request, HttpContext context)
        {
            WriteToMemory(dbe, context);
            string message;
            if (dbe.InnerException != null && dbe.InnerException.InnerException != null)
            {
                message = dbe.InnerException.InnerException.Message;
            }
            else if (dbe.InnerException != null)
            {
                message = dbe.InnerException.Message;
            }
            else
            {
                message = dbe.Message;
            }
            return request.CreateResponse(HttpStatusCode.BadRequest, message);
        }
        public static void WriteToMemory(Exception exception, HttpContext context)
        {
            if (context != null)
            {
                ErrorLog.GetDefault(context)
                    .Log(exception != null
                        ? new Error(exception)
                        : new Error(new Exception("The actual exception is null or empty.")));
            }
        }
        public static void WriteToMemory(HttpContext context, Exception exception)
        {
            ErrorLog.GetDefault(context).Log(new Error(exception));
        }
        public static string DumpRequestToString(HttpRequest request)
        {
            var dump = new StringBuilder();
            dump.AppendLine("\n\nDUMPING.....\n\n");
            dump.AppendLine("--------------------------------------------------------------------------------------------------\n\n");
            dump.AppendLine("request.AnonymousID: " + request.AnonymousID);
            dump.AppendLine("request.ApplicationPath: " + request.ApplicationPath);
            dump.AppendLine("request.AppRelativeCurrentExecutionFilePath: " + request.AppRelativeCurrentExecutionFilePath);
            dump.AppendLine("request.CurrentExecutionFilePath: " + request.CurrentExecutionFilePath);
            dump.AppendLine("request.FilePath: " + request.FilePath);
            dump.AppendLine("request.HttpMethod: " + request.HttpMethod);
            dump.AppendLine("request.IsAuthenticated: " + request.IsAuthenticated);
            dump.AppendLine("request.IsLocal: " + request.IsLocal);
            dump.AppendLine("request.IsSecureConnection: " + request.IsSecureConnection);
            dump.AppendLine("request.LogonUserIdentity.Name: " + (request.LogonUserIdentity == null ? "null" : request.LogonUserIdentity.Name));
            dump.AppendLine("request.PathInfo: " + request.PathInfo);
            dump.AppendLine("request.Path: " + request.Path);
            dump.AppendLine("request.PhysicalApplicationPath: " + request.PhysicalApplicationPath);
            dump.AppendLine("request.PhysicalPath: " + request.PhysicalPath);
            dump.AppendLine("request.QueryString: " + request.QueryString);
            dump.AppendLine("request.RawUrl: " + request.RawUrl);
            dump.AppendLine("request.requestType: " + request.RequestType);
            dump.AppendLine("request.Url.AbsolutePath: " + (request.Url == null ? "null" : request.Url.AbsolutePath));
            dump.AppendLine("request.Url.AbsoluteUri: " + (request.Url == null ? "null" : request.Url.AbsoluteUri));
            dump.AppendLine("request.Url.Authority: " + (request.Url == null ? "null" : request.Url.Authority));
            dump.AppendLine("request.Url.DnsSafeHost: " + (request.Url == null ? "null" : request.Url.DnsSafeHost));
            dump.AppendLine("request.Url.Fragment: " + (request.Url == null ? "null" : request.Url.Fragment));
            dump.AppendLine("request.Url.Host: " + (request.Url == null ? "null" : request.Url.Host));
            dump.AppendLine("request.Url.HostNameType: " + (request.Url == null ? "null" : request.Url.HostNameType.ToString()));
            dump.AppendLine("request.Url.IsAbsoluteUri: " + (request.Url == null ? "null" : request.Url.IsAbsoluteUri.ToString()));
            dump.AppendLine("request.Url.IsDefaultPort: " + (request.Url == null ? "null" : request.Url.IsDefaultPort.ToString()));
            dump.AppendLine("request.Url.IsFile: " + (request.Url == null ? "null" : request.Url.IsFile.ToString()));
            dump.AppendLine("request.Url.IsLoopback: " + (request.Url == null ? "null" : request.Url.IsLoopback.ToString()));
            dump.AppendLine("request.Url.IsUnc: " + (request.Url == null ? "null" : request.Url.IsUnc.ToString()));
            dump.AppendLine("request.Url.IsWellFormedOriginalString: " + (request.Url == null ? "null" : request.Url.IsWellFormedOriginalString().ToString()));
            dump.AppendLine("request.Url.LocalPath: " + (request.Url == null ? "null" : request.Url.LocalPath));
            dump.AppendLine("request.Url.OriginalString: " + (request.Url == null ? "null" : request.Url.OriginalString));
            dump.AppendLine("request.Url.PathAndQuery: " + (request.Url == null ? "null" : request.Url.PathAndQuery));
            dump.AppendLine("request.Url.Port: " + (request.Url == null ? "null" : request.Url.Port.ToString()));
            dump.AppendLine("request.Url.Query: " + (request.Url == null ? "null" : request.Url.Query));
            dump.AppendLine("request.Url.Scheme: " + (request.Url == null ? "null" : request.Url.Scheme));
            dump.AppendLine("request.Url.UserEscaped: " + (request.Url == null ? "null" : request.Url.UserEscaped.ToString()));
            dump.AppendLine("request.Url.UserInfo: " + (request.Url == null ? "null" : request.Url.UserInfo));
            dump.AppendLine("request.UserAgent: " + request.UserAgent);
            dump.AppendLine("request.UserHostAddress: " + request.UserHostAddress);
            dump.AppendLine("request.UserHostName: " + request.UserHostName + "\n\n\n");
            dump.AppendLine("--------------------------------------------------------------------------------------------------\n\n");

            dump.AppendLine("request.Forms: \n\n");
            foreach (var v in request.Form)
                dump.AppendLine(v + ": " + request.Form[v.ToString()]);
            dump.AppendLine("--------------------------------------------------------------------------------------------------\n\n");

            dump.AppendLine("request.Headers: \n\n");
            foreach (var v in request.Headers)
                dump.AppendLine(v + ": " + request.Headers[v.ToString()]);
            dump.AppendLine("--------------------------------------------------------------------------------------------------\n\n");

            dump.AppendLine("request.Params: \n\n");
            foreach (var v in request.Params)
                dump.AppendLine(v + ": " + request.Params[v.ToString()]);
            dump.AppendLine("--------------------------------------------------------------------------------------------------\n\n");

            dump.AppendLine("request.ServerVariables: \n\n");
            foreach (var v in request.ServerVariables)
                dump.AppendLine(v + ": " + request.ServerVariables[v.ToString()]);
            dump.AppendLine("--------------------------------------------------------------------------------------------------\n\n");

            return dump.ToString();
        }
    }
}


