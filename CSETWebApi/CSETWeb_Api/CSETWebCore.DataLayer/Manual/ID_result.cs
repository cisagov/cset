//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.ComponentModel.DataAnnotations;


namespace DataLayerCore.Manual
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
