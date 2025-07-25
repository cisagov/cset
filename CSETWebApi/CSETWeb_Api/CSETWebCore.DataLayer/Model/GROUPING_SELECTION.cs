﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.DataLayer.Model;

[PrimaryKey("Assessment_Id", "Grouping_Id")]
public partial class GROUPING_SELECTION
{
    [Key]
    public int Assessment_Id { get; set; }

    [Key]
    public int Grouping_Id { get; set; }

    [ForeignKey("Assessment_Id")]
    [InverseProperty("GROUPING_SELECTION")]
    public virtual ASSESSMENTS Assessment { get; set; }

    [ForeignKey("Grouping_Id")]
    [InverseProperty("GROUPING_SELECTION")]
    public virtual MATURITY_GROUPINGS Grouping { get; set; }
}