using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer
{
    public partial class UNIVERSAL_AREA
    {
        [StringLength(60)]
        public string Universal_Area_Name { get; set; }
        public double? Area_Weight { get; set; }
        [StringLength(2000)]
        public string Comments { get; set; }
        public int Universal_Area_Number { get; set; }
    }
}