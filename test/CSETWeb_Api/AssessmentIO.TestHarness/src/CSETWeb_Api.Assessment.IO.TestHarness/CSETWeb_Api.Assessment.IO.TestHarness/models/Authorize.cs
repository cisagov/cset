using System;

namespace CSETWeb_Api.AssessmentIO.TestHarness
{
    class Authorize
    {
        public string Email { get; set; }
        public string Password { get; set; }
        public int TzOffset { get { return (int)getTimezoneOffset(); } }
        public string Scope { get { return Program.config["apiUrl"]; } }

        static double getTimezoneOffset()
        {
            return (DateTime.UtcNow - DateTime.Now).TotalMinutes;
        }
    }
}
