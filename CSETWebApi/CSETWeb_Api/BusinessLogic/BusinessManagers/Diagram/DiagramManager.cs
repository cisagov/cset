//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
////////////////////////////////
using System;
using System.Linq;
using System.Data;
using System.Xml;
using Microsoft.EntityFrameworkCore;
using DataLayerCore.Model;

namespace CSETWeb_Api.BusinessManagers
{
    public class DiagramManager
    {
        /// <summary>
        /// Persists the diagram XML in the database.
        /// </summary>
        /// <param name="assessmentID"></param>
        /// <param name="diagramXML"></param>
        public void SaveDiagram(int assessmentID, string diagramXML)
        {

            // the front end sometimes calls 'save' with an empty graph on open.  Need to 
            // prevent the javascript from doing that on open, but for now,
            // let's detect an empty graph and not save it.

            XmlDocument xDoc = new XmlDocument();
            xDoc.LoadXml(diagramXML);
            var cellCount = xDoc.SelectNodes("//root/mxCell").Count;
            if (cellCount == 2)
            {
                return;
            }



            using (var db = new CSET_Context())
            {
                // Assume a single bridge record for now.  
                // Maybe we will support multiple diagrams per assessment some day.
                var bridge = db.ASSESSMENT_DIAGRAM_MARKUP.Where(x => x.Assessment_Id == assessmentID).FirstOrDefault();
                if (bridge == null)
                {
                    InsertNewDiagram(assessmentID, diagramXML);
                    return;
                }

                var markup = db.DIAGRAM_MARKUP.Where(x => x.Diagram_ID == bridge.Diagram_Id).FirstOrDefault();
                markup.Markup = diagramXML;
                db.DIAGRAM_MARKUP.Update(markup);
                db.SaveChanges();

            }
        }


        /// <summary>
        /// Create a new diagram record and its bridge to the assessment.
        /// </summary>
        /// <param name="assessmentID"></param>
        /// <param name="diagramXML"></param>
        private void InsertNewDiagram(int assessmentID, string diagramXML)
        {
            using (var db = new CSET_Context())
            {
                // quietly validate assessment ID
                var assessment = db.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentID).FirstOrDefault();
                if (assessment == null)
                {
                    return;
                }


                // build markup
                var newMarkup = new DIAGRAM_MARKUP
                {
                    Markup = diagramXML
                };

                db.DIAGRAM_MARKUP.Add(newMarkup);
                db.SaveChanges();

                // build bridge
                var newBridge = new ASSESSMENT_DIAGRAM_MARKUP
                {
                    Assessment_Id = assessmentID,
                    Diagram_Id = newMarkup.Diagram_ID
                };

                db.ASSESSMENT_DIAGRAM_MARKUP.Add(newBridge);
                db.SaveChanges();
            }
        }


        /// <summary>
        /// Returns the diagram XML for the assessment ID.  
        /// If not defined, null is returned.
        /// </summary>
        /// <param name="assessmentID"></param>
        /// <returns></returns>
        public string GetDiagram(int assessmentID)
        {
            using (var db = new CSET_Context())
            {
                var markup = from g in db.ASSESSMENT_DIAGRAM_MARKUP
                             join h in db.DIAGRAM_MARKUP on g.Diagram_Id equals h.Diagram_ID
                             where g.Assessment_Id == assessmentID
                             select h.Markup;

                return markup.FirstOrDefault();
            }
        }
    }
}
