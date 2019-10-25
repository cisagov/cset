using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataLayerCore.Manual
{
    public class Answer_Components_Base
    {
        [StringLength(100)]
        public string UniqueKey { get; private set; }
        public int Assessment_Id { get; private set; }
        public int Answer_Id { get; private set; }
        public int Question_Id { get; private set; }
        [Required]
        [StringLength(50)]
        public string Answer_Text { get; private set; }
        [StringLength(1000)]
        public string Comment { get; private set; }
        [StringLength(1000)]
        public string Alternate_Justification { get; private set; }
        public int? Question_Number { get; private set; }
        [StringLength(7338)]
        public string QuestionText { get; private set; }
        [Required]
        [StringLength(250)]
        public string Question_Group_Heading { get; private set; }
        public int GroupHeadingId { get; set; }
        [Required]
        [StringLength(100)]
        public string Universal_Sub_Category { get; private set; }
        public int SubCategoryId { get; set; }
        public bool Is_Component { get; private set; }
        [StringLength(36)]
        public Guid? Component_Guid { get; private set; }
        [StringLength(10)]
        public string SAL { get; private set; }
        public bool? Mark_For_Review { get; private set; }
        public bool Is_Requirement { get; private set; }
        public bool Is_Framework { get; private set; }
        public int heading_pair_id { get; private set; }
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
