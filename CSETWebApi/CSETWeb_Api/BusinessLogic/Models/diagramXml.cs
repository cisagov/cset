using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace CSETWeb_Api.BusinessLogic.Models
{
    public partial class mxGraphModelRootObject
    {

        private string assetTypeField;

        private string zoneLabelField;


        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public string assetType
        {
            get { return this.assetTypeField; }
            set { this.assetTypeField = value; }
        }

        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public string zoneLabel
        {
            get { return this.zoneLabelField; }
            set { this.zoneLabelField = value; }
        }
    }
}
