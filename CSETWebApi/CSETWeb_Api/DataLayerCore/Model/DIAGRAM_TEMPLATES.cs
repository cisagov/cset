using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataLayerCore.Model
{
    public partial class DIAGRAM_TEMPLATES
    {
        public int Id { get; set; }
        [StringLength(150)]
        public string Template_Name { get; set; }
        public string File_Name { get; set; }
        [Required]
        public bool? Is_Read_Only { get; set; }
        [Required]
        public bool? Is_Visible { get; set; }
        public string Diagram_Markup { get; set; }
    }
}