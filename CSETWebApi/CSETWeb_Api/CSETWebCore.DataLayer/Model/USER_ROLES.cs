using System.ComponentModel.DataAnnotations;

namespace CSETWebCore.DataLayer.Model;

public class USER_ROLES
{
    [Key] 
    public int UserRoleId { get; set; }

    [Required]
    public int UserId { get; set; }
    [Required]
    public int RoleId { get; set; }
    public virtual USERS USERS { get; set; }
    public virtual ROLES ROLES { get; set; }
}