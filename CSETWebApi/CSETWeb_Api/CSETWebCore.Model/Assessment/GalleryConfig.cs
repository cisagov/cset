using System.Collections.Generic;

namespace CSETWebCore.Model.Assessment;

public class GalleryConfig
{
    /// <summary>
    /// Multiple sets can be specified
    /// </summary>
    public List<string> Sets { get; set; }
    
    /// <summary>
    /// A single model can be specified 
    /// </summary>
    public string Model { get; set; }

    public string SALLevel { get; set; }
    
    public string QuestionMode { get; set; }

    public bool Diagram { get; set; } = false;
}