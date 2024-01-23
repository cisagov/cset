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
    public class mxGraphModelRoot
    {
        private object[] itemsField;

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("mxCell", typeof(mxGraphModelRootMxCell))]
        [System.Xml.Serialization.XmlElementAttribute("UserObject", typeof(mxGraphModelRootObject))]
        public object[] Items
        {
            get
            {
                return this.itemsField;
            }
            set
            {
                this.itemsField = value;
            }
        }
    }
}