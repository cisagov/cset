//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Linq;
using CSETWebCore.Business.Common;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Common;
using CSETWebCore.Interfaces.ResourceLibrary;

namespace CSETWebCore.Business.RepositoryLibrary
{
    public class FlowDocManager : IFlowDocManager
    {
        private CSETContext _context;
        private readonly IHtmlFromXamlConverter _html;

        public FlowDocManager(CSETContext context, IHtmlFromXamlConverter html)
        {
            _context = context;
            _html = html;
        }

        public string GetFlowDoc(string type, int id)
        {
            string flowDoc = string.Empty;


            if (type.ToLower() == "cat")
            {
                flowDoc = _context.CATALOG_RECOMMENDATIONS_DATA.FirstOrDefault(d => d.Data_Id == id).Flow_Document;
            }

            if (type.ToLower() == "proc")
            {
                flowDoc = _context.PROCUREMENT_LANGUAGE_DATA.FirstOrDefault(d => d.Procurement_Id == id).Flow_Document;
            }

            if (flowDoc == null)
            {
                return "None";
            }

            if (flowDoc.StartsWith("<FlowDocument"))
            {
                string html = _html.ConvertXamlToHtml(flowDoc);

                // add some style to the first <p> element to make it look like a title
                if (html.StartsWith("<p>"))
                {
                    html = "<p style=\"font-size: 150%; font-weight: bold;\">" + html.Substring(3);
                }

                return html.Replace("margin:0 0 0 0;", "").Replace("padding:0 0 0 0;", "");
            }

            return string.Empty;
        }
    }
}