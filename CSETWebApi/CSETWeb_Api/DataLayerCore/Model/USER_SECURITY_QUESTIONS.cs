using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class USER_SECURITY_QUESTIONS
    {
        public int UserId { get; set; }
        public string SecurityQuestion1 { get; set; }
        public string SecurityAnswer1 { get; set; }
        public string SecurityQuestion2 { get; set; }
        public string SecurityAnswer2 { get; set; }

        public virtual USERS User { get; set; }
    }
}
