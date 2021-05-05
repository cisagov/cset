using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class LEVEL_BACKUP_ACET_QUESTIONS
    {
        public int question_id { get; set; }
        public int New_Question_Set_Id { get; set; }
        [StringLength(10)]
        public string universal_sal_level { get; set; }
    }
}