using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using System.Xml.XPath;

namespace CSETWebCore.Helpers.ReportWidgets
{
    /// <summary>
    /// Renders a 2D block of question scores that have been
    /// supplied.  
    /// 
    /// TODO:  Finish this once it is determined how the 
    /// NIST CSF mapped questions will be supplied to this class.
    /// </summary>
    public class NistDomainBlock
    {
        private XDocument _xSvgDoc;
        private XElement _xSvg;


        /// <summary>
        /// Constructor.
        /// </summary>
        public NistDomainBlock()
        {
            _xSvgDoc = new XDocument(new XElement("svg"));
            _xSvg = _xSvgDoc.Root;

            // TODO:  TBD
            _xSvg.SetAttributeValue("width", 1000);
            _xSvg.SetAttributeValue("height", 400);

            // style tag
            var xStyle = new XElement("style");
            _xSvg.Add(xStyle);
            xStyle.Value = "text {font: .5rem sans-serif}";

            // DUMMY PLACEHOLDER ----------------------------------------------
            var xDummy = new XElement("rect");
            _xSvg.Add(xDummy);
            xDummy.SetAttributeValue("width", 120);
            xDummy.SetAttributeValue("height", 200);
            xDummy.SetAttributeValue("fill", "#ddd");
            xDummy.SetAttributeValue("rx", 4);
            // ----------------------------------------------------------------
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public override string ToString()
        {
            return _xSvgDoc.ToString();
        }
    }
}
