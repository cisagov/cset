using Npoi.Mapper.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.DataLayer.Manual
{
   
    public class SpanishQuestionRow
    {
        public SpanishQuestionRow() { }

        [Column("Mat_Question_Id")]
        public int Mat_Question_Id { get; set; }
        [Column("Question_Title")]
        public string Question_Title { get; set; }
        [Column("Question_Text")]
        public string Question_Text { get; set; }
        [Column("Supplemental_Info")]
        public string Supplemental_Info { get; set; }
        [Column("Examination_Approach")]
        public string Examination_Approach { get; set; }
    }
}
