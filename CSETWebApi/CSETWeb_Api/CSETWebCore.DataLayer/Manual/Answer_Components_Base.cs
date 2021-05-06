using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.DataLayer
{
    public class Answer_Components_Base
    {
        [StringLength(100)]
        public int UniqueKey { get; set; }
        public int Assessment_Id { get; set; }
        public int Answer_Id { get; set; }
        public int Question_Id { get; set; }    
        public string Question_Type { get; set; }
        [StringLength(50)]
        public string Answer_Text { get; set; }
        [StringLength(1000)]
        public string Comment { get; set; }
        [StringLength(1000)]
        public string Alternate_Justification { get; set; }
        public int? Question_Number { get; set; }
        [StringLength(7338)]
        public string QuestionText { get; set; }        
        [StringLength(250)]
        public string Question_Group_Heading { get; set; }
        public int GroupHeadingId { get; set; }        
        [StringLength(100)]
        public string Universal_Sub_Category { get; set; }
        public int SubCategoryId { get; set; }
        public string Feedback { get; set; }
        public bool Is_Component { get; set; }
        [StringLength(36)]
        public Guid? Component_Guid { get; set; }
        [StringLength(10)]
        public string SAL { get; set; }
        public bool? Mark_For_Review { get; set; }
        public bool Is_Requirement { get; set; }
        public bool Is_Framework { get; set; }
        public int heading_pair_id { get; set; }
        public string Sub_Heading_Question_Description { get; set; }
        public string Simple_Question { get; set; }
        public bool? Reviewed { get; set; }
        public string label { get; set; }
        public string ComponentName { get; set; }
        public string Symbol_Name { get; set; }
        public int Component_Symbol_Id { get; set; }
        

        //,[Layer_Id]
        //,[LayerName]
        //,[Container_Id]
        //,[ZoneName]


    }
}
