using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using System.Xml.Serialization;
using BusinessLogic.Helpers;
using CSETWeb_Api.BusinessLogic;
using CSETWeb_Api.BusinessLogic.Helpers;
using CSETWeb_Api.BusinessLogic.Models;
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.Models;
using DataLayerCore.Model;
using Microsoft.EntityFrameworkCore;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers
{
    public class DiagramManager
    {


        public void GetDiagramXml(int assessmentId)
        {
            var diagram = new AssessmentManager().GetAssessmentById(assessmentId)?.Diagram_Markup;

            if (diagram != null)
            {
                XmlSerializer deserializer = new XmlSerializer(typeof(mxGraphModel));
                var stream = new StreamReader(diagram);
                var diagramXml = (mxGraphModel)deserializer.Deserialize((stream));
                var item = diagramXml.root.Items[0];
            }


        }

        public void ProcessDiagram(StreamReader stream)
        {
            XmlSerializer deserializer = new XmlSerializer(typeof(mxGraphModel));
            var diagramXml = (mxGraphModel)deserializer.Deserialize((stream));
            List<mxGraphModelRootMxCell> edges = new List<mxGraphModelRootMxCell>();
            List<mxGraphModelRootObject> vertexlist = new List<mxGraphModelRootObject>();
            mxGraphModelRootObject o = new mxGraphModelRootObject();
            Type objectType =  o.GetType();


            foreach (var item in diagramXml.root.Items)
            {
                if (item.GetType() == objectType)
                {
                    vertexlist.Add((mxGraphModelRootObject) item);
                }
                else
                {
                    edges.Add((mxGraphModelRootMxCell) item);
                }
            }
            
        }
       
    }
}
