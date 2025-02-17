//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Diagram
{
    public class DiagramResponse
    {
        public string AssessmentName { get; set; }
        public string DiagramXml { get; set; }
        public int LastUsedComponentNumber { get; set; }
        public bool AnalyzeDiagram { get; set; }
    }
}