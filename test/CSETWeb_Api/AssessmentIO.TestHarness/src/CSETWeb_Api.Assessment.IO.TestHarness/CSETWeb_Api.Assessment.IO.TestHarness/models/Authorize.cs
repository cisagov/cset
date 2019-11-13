using System;

namespace CSETWeb_Api.AssessmentIO.TestHarness
{
    class Authorize
    {
        public string Email { get; set; }
        public string Password { get; set; }
        //{ return (int)getTimezoneOffset(); }
        public int TzOffset { get; set; }
        public string Scope { get { return Program.config["apiUrl"]; } }

        static double getTimezoneOffset()
        {
            return (DateTime.UtcNow - DateTime.Now).TotalMinutes;
        }
    }
}
