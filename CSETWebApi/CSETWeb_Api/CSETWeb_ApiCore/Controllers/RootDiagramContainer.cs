//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Model.Diagram;
using System.Collections.Generic;
using System.IO;

namespace CSETWebCore.Api.Controllers
{
    public class RootDiagramContainer
    {
        

        public RootDiagramContainer()
        {
        }

        public List<mxGraphModelRootObject> edges { get; set; }
        public List<mxGraphModelRootObject> links { get; set; }

        public StringReader diagramXml { get; internal set; }
        public List<mxGraphModelRootObject> vertices { get; internal set; }
        public List<mxGraphModelRootObject> zones { get; internal set; }
        public List<mxGraphModelRootObject> components { get; internal set; }
        public List<mxGraphModelRootMxCell> shapeVertices { get; internal set; }
        public List<mxGraphModelRootMxCell> shapes { get; internal set; }
        public List<mxGraphModelRootMxCell> texts { get; internal set; }
    }
}