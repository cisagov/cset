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
    public GalleryModel Model { get; set; }

    public string SALLevel { get; set; }
    
    public string QuestionMode { get; set; }

    public bool Diagram { get; set; } = false;
}

public class GalleryModel
{ 
    public string ModelName { get; set; }

    public int Level { get; set; }
}
