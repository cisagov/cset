using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class NCSF_CATEGORY
    {
        public NCSF_CATEGORY()
        {
            NEW_REQUIREMENT = new HashSet<NEW_REQUIREMENT>();
        }

        public string NCSF_Function_Id { get; set; }
        public string NCSF_Category_Id { get; set; }
        public string NCSF_Category_Name { get; set; }
        public string NCSF_Category_Description { get; set; }
        public int NCSF_Cat_Id { get; set; }
        public int Question_Group_Heading_Id { get; set; }

        public virtual NCSF_FUNCTIONS NCSF_Function_ { get; set; }
        public virtual ICollection<NEW_REQUIREMENT> NEW_REQUIREMENT { get; set; }
    }
}
