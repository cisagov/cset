using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class QUESTION_GROUP_TYPE
    {
        public int Question_Group_Id { get; set; }
        [Required]
        [StringLength(10)]
        public string Group_Name { get; set; }
        [Required]
        [StringLength(10)]
        public string Scoring_Group { get; set; }
        [Required]
        [StringLength(10)]
        public string Scoring_Type { get; set; }
        [StringLength(2000)]
        public string Group_Header { get; set; }
    }
}
