﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.DataLayer.Model
{
    public partial class GetChildrenAnswersResult
    {
        public int Mat_Question_Id { get; set; }
        [StringLength(250)]
        public string Question_Title { get; set; }
        [StringLength(2147483647)]
        public string Question_Text { get; set; }
        [StringLength(50)]
        public string Answer_Text { get; set; }
        public int Maturity_Level_Id { get; set; }
        public int? Parent_Question_Id { get; set; }
        public int? Ranking { get; set; }
        public int? Grouping_Id { get; set; }
    }
}
