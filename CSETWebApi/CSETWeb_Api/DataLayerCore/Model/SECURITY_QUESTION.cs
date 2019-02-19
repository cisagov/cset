using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class SECURITY_QUESTION
    {
        public int SecurityQuestionId { get; set; }
        public string SecurityQuestion { get; set; }
        public bool? IsCustomQuestion { get; set; }
    }
}
