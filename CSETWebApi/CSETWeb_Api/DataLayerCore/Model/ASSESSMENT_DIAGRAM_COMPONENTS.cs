using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class ASSESSMENT_DIAGRAM_COMPONENTS
    {
        public int Assessment_Id { get; set; }
        [StringLength(100)]
        public string Diagram_Component_Type { get; set; }
    }
}
