using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class QUESTION_GROUP_TYPE
    {
        public int Question_Group_Id { get; set; }
        public string Group_Name { get; set; }
        public string Scoring_Group { get; set; }
        public string Scoring_Type { get; set; }
        public string Group_Header { get; set; }
    }
}
