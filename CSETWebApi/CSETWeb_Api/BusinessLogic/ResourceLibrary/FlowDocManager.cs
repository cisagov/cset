//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataLayerCore.Model;
using CSET_Main.Common;

namespace CSETWeb_Api.BusinessManagers
{ 
    public class FlowDocManager
    {
        public string GetFlowDoc(string type, int id)
        {
            string flowDoc = string.Empty;

            using (var db = new CSET_Context())
            {
                if (type.ToLower() == "cat")
                {
                    flowDoc = db.CATALOG_RECOMMENDATIONS_DATA.FirstOrDefault(d => d.Data_Id == id).Flow_Document;
                }

                if (type.ToLower() == "proc")
                {
                    flowDoc = db.PROCUREMENT_LANGUAGE_DATA.FirstOrDefault(d => d.Procurement_Id == id).Flow_Document;
                }
            }




            if (flowDoc == null)
            {
                return "None";
            }

            if (flowDoc.StartsWith("<FlowDocument"))
            {
                string html = HtmlFromXamlConverter.ConvertXamlToHtml(flowDoc);

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


