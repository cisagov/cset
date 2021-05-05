namespace CSETWebCore.Model.Diagram
{
    public class DiagramRequest
    {
        public string DiagramXml;
        public int LastUsedComponentNumber;
        public string DiagramSvg;
        public bool revision;
        public bool AnalyzeDiagram;

        public DiagramRequest()
        {
            this.revision = true;
        }
    }
}