using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.DataLayer.Manual
{
    public class CyOTEAnsweredQuestions
    {
        public CyOTEAnsweredQuestions()
        {
        }
        public int Mat_Question_Id { get; set; }
        public bool expandable { get; set; }
        public bool? isExpanded { get; set; }
        public string Question_Title { get; set; }
        public string Question_Text { get; set; }        
        public int Sequence { get; set; }
        public int Question_Level { get; set; }
        public string Mat_Question_Type { get; set; }        
        public string Answer_Text { get; set; }
        public string Free_Response_Answer { get; set; }
        public string Comment { get; set; }
        public int Answer_Id { get; set; }
        public int? Parent_Question_Id { get; set; }
    }
}
