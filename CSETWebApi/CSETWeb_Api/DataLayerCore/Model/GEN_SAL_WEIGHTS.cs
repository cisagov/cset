using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class GEN_SAL_WEIGHTS
    {
        public int Sal_Weight_Id { get; set; }
        public string Sal_Name { get; set; }
        public int Slider_Value { get; set; }
        public decimal Weight { get; set; }
        public string Display { get; set; }

        public virtual GEN_SAL_NAMES Sal_Name1 { get; set; }
        public virtual GENERAL_SAL_DESCRIPTIONS Sal_NameNavigation { get; set; }
    }
}
