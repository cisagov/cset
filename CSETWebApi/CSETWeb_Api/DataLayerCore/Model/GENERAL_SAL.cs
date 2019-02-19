using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class GENERAL_SAL
    {
        public int Assessment_Id { get; set; }
        public string Sal_Name { get; set; }
        public int Slider_Value { get; set; }

        public virtual ASSESSMENTS Assessment_ { get; set; }
        public virtual GEN_SAL_NAMES Sal_NameNavigation { get; set; }
    }
}
