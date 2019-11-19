using System;
using System.Collections.Generic;

namespace CSETWeb_Api.AssessmentIO.TestHarness
{
    public class WebRequestOptions
    {
        public string UriString { get; set; }
        public string AuthType { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public string Referer { get; set; }
        public IDictionary<string, string> Headers { get; set; }

        public Uri Uri
        {
            get
            {
                return new Uri(this.UriString);
            }
        }
    }
}
