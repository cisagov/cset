using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace CSETWeb_Api.BusinessManagers.Diagram.Analysis
{
    public class DiagramAnalysisNodeMessage : IDiagramAnalysisNodeMessage
    {
        [JsonIgnore]
        [IgnoreDataMember]
        public NetworkComponent Component { get; internal set; }
        public int Number { get; internal set; }
        public string redDot { get; set; }
        public string label { get; set; }
        public string id { get; set; }
        public string layerId { get; set; }
        public string value { get; set; }
        public string style { get; set; }
        public string vertex { get; set; }
        public string parent { get; set; }
        public NetworkGeometry mxGeometry { get; internal set; }
        public HashSet<String> SetMessages { get; set; }
        public int MessageIdentifier { get; set; }

        [JsonIgnore]
        [IgnoreDataMember]
        public string XmlValue
        {
            get
            {
                string warning = "    <object redDot=\"{3}\" label=\"1\" id=\"{0}\">" +
                            getStyle()+
                            "      <mxGeometry x=\"{1}\" y=\"{2}\" width=\"20\" height=\"20\" as=\"geometry\"/>" +
                            "    </mxCell></object>";
                return String.Format(warning, id, mxGeometry==null?0:mxGeometry.point.X, mxGeometry==null?0:mxGeometry.point.Y, 
                    redDot);
            }
        }

        private string getStyle()
        {
            return String.Format("   <mxCell  value=\"{0}\" style=\"ellipse;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#FF0000;fontColor=#FFFFFF;fontSize=13;\" vertex=\"1\" parent=\"{1}\">",
                Number,parent);
        }

        public DiagramAnalysisNodeMessage()
        {
            SetMessages = new HashSet<string>();
            redDot = "1";
            Number = 1;
            label = "";
            id = Guid.NewGuid().ToString();
            layerId = "0";
            value = Number.ToString();
            style = getStyle();
            vertex = "1";
            parent = "0";
        }

        public void AddMessage(String message)
        {
            SetMessages.Add(message);
        }

        public String Message
        {
            get
            {
                return String.Join("\n\n", SetMessages);
            }
        }

        
    }
}
