using System.ComponentModel.DataAnnotations;

namespace CSETWebCore.DataLayer.Model;

public class ROLES
{
    [Key] public int RoleId { get; set; }
    [Required] public string RoleName { get; set; }
}