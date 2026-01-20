using System;
using System.ComponentModel.DataAnnotations;

namespace CSETWebCore.DataLayer.Model
{
    /// <summary>
    /// DTO class for component exploded data.
    /// Matches the structure of the Answer_Components_Exploded view.
    /// Used for mapping query results when querying the view directly.
    /// </summary>
    public class usp_getExplodedComponent
    {
        [Key]
        public string UniqueKey { get; set; }
        public int Assessment_Id { get; set; }
        public int? Answer_Id { get; set; }
        public int Question_Id { get; set; }
        public string Answer_Text { get; set; }
        public string Comment { get; set; }
        public string Alternate_Justification { get; set; }
        public int? Question_Number { get; set; }
        public string QuestionText { get; set; }
        public string ComponentName { get; set; }
        public int Component_Symbol_Id { get; set; }
        public bool Is_Component { get; set; }
        public Guid Component_GUID { get; set; }
        public int? Layer_Id { get; set; }
        public string LayerName { get; set; }
        public int? Container_Id { get; set; }
        public string ZoneName { get; set; }
        public string SAL { get; set; }
        public bool? Mark_For_Review { get; set; }
        public string Feedback { get; set; }
    }
}
