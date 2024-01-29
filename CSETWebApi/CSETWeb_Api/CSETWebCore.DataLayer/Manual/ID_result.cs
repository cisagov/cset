//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.ComponentModel.DataAnnotations;


namespace CSETWebCore.DataLayer.Model
{
    /// <summary>
    /// 
    /// </summary>
    public class Question_Id_result
    {
        [Key]
        public int Question_Id { get; set; }
    }


    /// <summary>
    /// 
    /// </summary>
    public class Requirement_Id_result
    {
        [Key]
        public int Requirement_Id { get; set; }
    }
}
