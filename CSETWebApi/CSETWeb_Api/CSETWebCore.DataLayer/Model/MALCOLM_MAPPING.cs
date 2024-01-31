using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace CSETWebCore.DataLayer.Model;

public partial class MALCOLM_MAPPING
{
    [Key]
    public int Malcolm_Id { get; set; }

    public int Question_Id { get; set; }

    public int? Rule_Violated { get; set; }
}