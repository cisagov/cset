﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.DataLayer.Model;

public partial class USER_ROLES
{
    [Key]
    public int UserRoleId { get; set; }

    public int UserId { get; set; }

    public int RoleId { get; set; }

    [ForeignKey("RoleId")]
    [InverseProperty("USER_ROLES")]
    public virtual ROLES Role { get; set; }

    [ForeignKey("UserId")]
    [InverseProperty("USER_ROLES")]
    public virtual USERS User { get; set; }
}