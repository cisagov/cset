using System.Collections.Generic;
using System.IO;
using System.Xml;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Diagram;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace CSETWebCore.Interfaces
{
    public interface IDiagramManager
    {
        Task SaveDiagram(int assessmentID, XmlDocument xDoc, DiagramRequest req);
        DiagramResponse GetDiagram(int assessmentID);
        bool HasDiagram(int assessmentID);
        string GetDiagramImage(int assessmentID, string http);
        List<ComponentSymbolGroup> GetComponentSymbols();
        Task<string> ImportOldCSETDFile(string diagramXml, int assessmentId);
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
        Task SaveLink(mxGraphModelRootMxCell vertice, int assessmentId);
        Task SaveComponent(mxGraphModelRootObject vertice, int assessmentId);
        COMPONENT_SYMBOLS getFromLegacyName(string name);
        Task SaveZone(mxGraphModelRootObject vertice, int assessmentId);
        Task SaveShape(mxGraphModelRootMxCell vertice, int assessmentId);
        Task SaveDiagramXml(int assessmentId, mxGraphModel diagramXml);
        string SetImage(int Component_Symbol_Id, string style);
        IEnumerable<DiagramTemplate> GetDiagramTemplates();
    }
}