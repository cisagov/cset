using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class DIAGRAM_TEMPLATES
    {
        public int Id { get; set; }
        public string Template_Name { get; set; }
        public string File_Name { get; set; }
        public bool? Is_Read_Only { get; set; }
        public bool? Is_Visible { get; set; }
    }
}
