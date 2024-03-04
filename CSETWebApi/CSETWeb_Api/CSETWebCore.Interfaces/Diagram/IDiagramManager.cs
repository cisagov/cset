//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using System.IO;
using System.Xml;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Diagram;
using CSETWebCore.Model.Malcolm;

namespace CSETWebCore.Interfaces
{
    public interface IDiagramManager
    {
        void SaveDiagram(int assessmentID, XmlDocument xDoc, DiagramRequest req, bool refreshQuestions);
        DiagramResponse GetDiagram(int assessmentID);
        bool HasDiagram(int assessmentID);
        string GetDiagramImage(int assessmentID, string http);
        List<ComponentSymbolGroup> GetComponentSymbols();
        string ImportOldCSETDFile(string diagramXml, int assessmentId);
        List<ComponentSymbol> GetAllComponentSymbols();
        StringReader GetDiagramXml(int assessmentId);
        List<mxGraphModelRootObject> ProcessDiagramVertices(StringReader stream, int assessment_id);
        List<mxGraphModelRootMxCell> ProcessDiagramShapes(StringReader stream, int assessment_id);
        List<mxGraphModelRootObject> ProcessDiagramEdges(StringReader stream, int assessment_id);
        LayerVisibility getLayerVisibility(string drawIoId, int assessment_id);
        List<mxGraphModelRootObject> GetDiagramComponents(List<mxGraphModelRootObject> vertices);
        List<mxGraphModelRootObject> GetDiagramLinks(List<mxGraphModelRootObject> edges);
        List<mxGraphModelRootObject> GetDiagramZones(List<mxGraphModelRootObject> vertices);
        List<mxGraphModelRootMxCell> GetDiagramShapes(List<mxGraphModelRootMxCell> vertices);
        List<mxGraphModelRootMxCell> GetDiagramText(List<mxGraphModelRootMxCell> vertices);
        void SaveLink(mxGraphModelRootMxCell vertice, int assessmentId);
        void SaveComponent(mxGraphModelRootObject vertice, int assessmentId);
        COMPONENT_SYMBOLS getFromLegacyName(string name);
        void SaveZone(mxGraphModelRootObject vertice, int assessmentId);
        void SaveShape(mxGraphModelRootMxCell vertice, int assessmentId);
        void SaveDiagramXml(int assessmentId, mxGraphModel diagramXml);
        void UpdateComponentType(int assessmentId, string guid, string type);
        void UpdateComponentLabel(int assessmentId, string guid, string label);
        void ChangeShapeToComponent(int assessmentId, string type, string id, string label);
        string SetImage(int Component_Symbol_Id, string style);
        IEnumerable<DiagramTemplate> GetDiagramTemplates();
        IEnumerable<CommonSecurityAdvisoryFrameworkVendor> GetCsafVendors();
        public CommonSecurityAdvisoryFrameworkVendor SaveCsafVendor(CommonSecurityAdvisoryFrameworkVendor vendor);
        public void DeleteCsafVendor(string vendorName);
        public void DeleteCsafProduct(string vendorName, string productName);
        void CreateMalcolmDiagram(int assessmentId, List<MalcolmData> processedData);
    }
}