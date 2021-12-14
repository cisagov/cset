using System.ComponentModel.DataAnnotations;

namespace CSETWebCore.Interfaces.AssessmentIO
{
    public interface IExternalDocument
    {
        [Required]
        string name { get; set; }
        [Required]
        string shortName { get; set; }
        byte[] data { get; set; }
        double? fileSize { get; set; }
        string fileName { get; set; }
    }
}