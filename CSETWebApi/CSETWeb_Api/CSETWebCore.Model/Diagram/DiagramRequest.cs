//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Diagram
{
    public class DiagramRequest
    {
        public string DiagramXml { get; set; }
        public int LastUsedComponentNumber { get; set; }
        public string DiagramSvg { get; set; }
        public bool revision { get; set; }
        public bool AnalyzeDiagram { get; set; }

        public DiagramRequest()
        {
            this.revision = true;
        }
    }
}