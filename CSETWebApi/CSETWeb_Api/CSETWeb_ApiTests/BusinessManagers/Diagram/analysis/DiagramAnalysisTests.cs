using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWeb_Api.BusinessManagers.Diagram.Analysis;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Diagnostics;

namespace CSETWeb_Api.BusinessManagers.Diagram.Analysis.Tests
{
    [TestClass()]
    public class DiagramAnalysisTests
    {
        [TestMethod()]
        public void PerformAnalysisTest()
        {
            string xmlContent = "<mxCell id=\"b6cfa23b-42c6-437f-8072-5a027f7a2b9e\" value=\"1\" style=\"ellipse;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#FF0000;fontColor=#FFFFFF;fontSize=13;\" vertex=\"1\" parent=\"\">" +
            "	<mxGeometry x=\"-420\" y=\"-210\" width=\"20\" height=\"20\" as=\"geometry\"/>" +
            "</mxCell>";
            XmlDocument xDoc = new XmlDocument();
            string diagramxml = "<mxGraphModel dx=\"2834\" dy=\"1594\" grid=\"1\" gridSize=\"10\" guides=\"1\" tooltips=\"1\" connect=\"1\" arrows=\"1\" fold=\"1\" page=\"0\" pageScale=\"1\" pageWidth=\"1100\" pageHeight=\"850\" math=\"0\" shadow=\"0\">" +
"  <root>" +
"    <mxCell id=\"0\"/>" +
"    <mxCell id=\"1\" parent=\"0\"/>" +
"    <mxCell id=\"_hgiiUUBZ608dPnyU8nU-2\" style=\"edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;;endArrow=none;\" parent=\"1\" source=\"_hgiiUUBZ608dPnyU8nU-1\" target=\"kJ8EX1JqY7O3_XgfF69A-3\" edge=\"1\">" +
"      <mxGeometry relative=\"1\" as=\"geometry\"/>" +
"    </mxCell>" +
"    <object ComponentGuid=\"542d4373-16c9-4eab-85bf-a48785c91017\" label=\"VE-34\" internalLabel=\"VE-34\" id=\"_hgiiUUBZ608dPnyU8nU-1\">" +
"      <mxCell style=\"aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/vendor.svg\" parent=\"1\" vertex=\"1\">" +
"        <mxGeometry x=\"-420\" y=\"-210\" width=\"50\" height=\"60\" as=\"geometry\"/>" +
"      </mxCell>" +
"    </object>" +
"    <mxCell id=\"kJ8EX1JqY7O3_XgfF69A-2\" value=\"MyTestLayer\" parent=\"0\"/>" +
"    <object ComponentGuid=\"8a8a17a9-0fbd-4999-9914-0f6650024d3e\" label=\"CNFIG-35\" internalLabel=\"CNFIG-35\" id=\"kJ8EX1JqY7O3_XgfF69A-1\">" +
"      <mxCell style=\"aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/configuration_server.svg\" parent=\"kJ8EX1JqY7O3_XgfF69A-2\" vertex=\"1\">" +
"        <mxGeometry x=\"-20\" y=\"-210\" width=\"45\" height=\"60\" as=\"geometry\"/>" +
"      </mxCell>" +
"    </object>" +
"    <object ComponentGuid=\"23f09c7c-7e48-46f1-9eb6-3638fddf0c30\" label=\"FEP-36\" internalLabel=\"FEP-36\" id=\"kJ8EX1JqY7O3_XgfF69A-3\">" +
"      <mxCell style=\"aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/front_end_processor.svg\" parent=\"kJ8EX1JqY7O3_XgfF69A-2\" vertex=\"1\">" +
"        <mxGeometry x=\"-410\" y=\"-20\" width=\"48\" height=\"60\" as=\"geometry\"/>" +
"      </mxCell>" +
"    </object>" +
"  </root>" +
"</mxGraphModel>";
            xDoc.LoadXml(diagramxml);

            XmlDocument doc = new XmlDocument();
            doc.LoadXml(xmlContent);
            XmlNode newNode = doc.DocumentElement;
            XmlNode root = xDoc.DocumentElement.FirstChild;
            
            XmlNode r =  xDoc.ImportNode(newNode, true);
            root.AppendChild(r);
            Trace.Write(xDoc.ToString());
        }
    }
}