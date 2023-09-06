﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.DataLayer.Model
{
    public partial class DETAILS_DEMOGRAPHICS
    {
        [Key]
        public int Assessment_Id { get; set; }
        [Key]
        [StringLength(100)]
        public string DataItemName { get; set; }
        public string StringValue { get; set; }
        public int? IntValue { get; set; }
        public double? FloatValue { get; set; }
        public bool? BoolValue { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime? DateTimeValue { get; set; }
    }
}