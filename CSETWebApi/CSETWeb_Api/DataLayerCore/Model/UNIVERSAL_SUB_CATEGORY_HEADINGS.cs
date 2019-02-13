using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class UNIVERSAL_SUB_CATEGORY_HEADINGS
    {
        public UNIVERSAL_SUB_CATEGORY_HEADINGS()
        {
            NEW_QUESTION = new HashSet<NEW_QUESTION>();
            SUB_CATEGORY_ANSWERS = new HashSet<SUB_CATEGORY_ANSWERS>();
        }

        [StringLength(1000)]
        public string Sub_Heading_Question_Description { get; set; }
        public bool? Display_Radio_Buttons { get; set; }
        public int Question_Group_Heading_Id { get; set; }
        public int Universal_Sub_Category_Id { get; set; }
        public int Heading_Pair_Id { get; set; }

        public virtual QUESTION_GROUP_HEADING Question_Group_Heading_ { get; set; }
        public virtual UNIVERSAL_SUB_CATEGORIES Universal_Sub_Category_ { get; set; }
        public virtual ICollection<NEW_QUESTION> NEW_QUESTION { get; set; }
        public virtual ICollection<SUB_CATEGORY_ANSWERS> SUB_CATEGORY_ANSWERS { get; set; }
    }
}