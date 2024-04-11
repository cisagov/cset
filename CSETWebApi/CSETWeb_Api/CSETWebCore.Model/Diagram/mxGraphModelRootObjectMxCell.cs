//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Diagram
{
    [System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "4.6.1055.0")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
    public class mxGraphModelRootObjectMxCell
    {
        private mxGraphModelRootObjectMxCellMxGeometry mxGeometryField;

        private string styleField { get; set; }

        private string edgeField { get; set; }

        private string parentField { get; set; }

        private string vertexField { get; set; }

        /// <remarks/>
        public mxGraphModelRootObjectMxCellMxGeometry mxGeometry
        {
            get
            {
                return this.mxGeometryField;
            }
            set
            {
                this.mxGeometryField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        public string style
        {
            get
            {
                return this.styleField;
            }
            set
            {
                this.styleField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        public string parent
        {
            get
            {
                return this.parentField;
            }
            set
            {
                this.parentField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        public string vertex
        {
            get
            {
                return this.vertexField;
            }
            set
            {
                this.vertexField = value;
            }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute()]
        public string edge
        {
            get
            {
                return this.edgeField;
            }
            set
            {
                this.edgeField = value;
            }
        }
    }
}