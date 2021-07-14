using System.Collections.Generic;
using System.IO;
using System.Xml;
using CSETWebCore.DataLayer;
using CSETWebCore.Model.Diagram;
using Microsoft.AspNetCore.Http;


namespace CSETWebCore.Interfaces
{
    public interface IDiagramManager
    {
        void SaveDiagram(int assessmentID, XmlDocument xDoc, DiagramRequest req);
        DiagramResponse GetDiagram(int assessmentID);
        bool HasDiagram(int assessmentID);
        string GetDiagramImage(int assessmentID, IHttpContextAccessor httpContext);
        List<ComponentSymbolGroup> GetComponentSymbols();
        string ImportOldCSETDFile(string diagramXml, int assessmentId);
        List<ComponentSymbol> GetAllComponentSymbols();
        StringReader GetDiagramXml(int assessmentId);
        List<mxGraphModelRootObject> ProcessDiagramVertices(StringReader stream, int assessment_id);
        List<mxGraphModelRootMxCell> ProcessDiagramShapes(StringReader stream, int assessment_id);
        List<mxGraphModelRootMxCell> ProcessDiagramEdges(StringReader stream, int assessment_id);
        LayerVisibility getLayerVisibility(string drawIoId, int assessment_id);
        List<mxGraphModelRootObject> GetDiagramComponents(List<mxGraphModelRootObject> vertices);
        List<mxGraphModelRootMxCell> GetDiagramLinks(List<mxGraphModelRootMxCell> edges);
        List<mxGraphModelRootObject> GetDiagramZones(List<mxGraphModelRootObject> vertices);
        List<mxGraphModelRootMxCell> GetDiagramShapes(List<mxGraphModelRootMxCell> vertices);
        List<mxGraphModelRootMxCell> GetDiagramText(List<mxGraphModelRootMxCell> vertices);
        void SaveLink(mxGraphModelRootMxCell vertice, int assessmentId);
        void SaveComponent(mxGraphModelRootObject vertice, int assessmentId);
        COMPONENT_SYMBOLS getFromLegacyName(string name);
        void SaveZone(mxGraphModelRootObject vertice, int assessmentId);
        void SaveShape(mxGraphModelRootMxCell vertice, int assessmentId);
        void SaveDiagramXml(int assessmentId, mxGraphModel diagramXml);
        string SetImage(int Component_Symbol_Id, string style);
        IEnumerable<DiagramTemplate> GetDiagramTemplates();
    }
}