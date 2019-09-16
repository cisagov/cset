//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
////////////////////////////////
using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Xml;
using Microsoft.EntityFrameworkCore;
using DataLayerCore.Model;
using CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram;
using CSETWeb_Api.Models;

namespace CSETWeb_Api.BusinessManagers
{
    public class DiagramManager
    {
        private CSET_Context db;

        public DiagramManager(CSET_Context db)
        {
            this.db = db;
        }

        /// <summary>
        /// Persists the diagram XML in the database.
        /// </summary>
        /// <param name="assessmentID"></param>
        /// <param name="diagramXML"></param>
        public void SaveDiagram(int assessmentID, XmlDocument xDoc, string diagramXML, int lastUsedComponentNumber, string diagramImage)
        {
            // the front end sometimes calls 'save' with an empty graph on open.  
            // Need to prevent the javascript from doing that on open, but for now,
            // let's detect an empty graph and not save it.

            var cellCount = xDoc.SelectNodes("//root/mxCell").Count;
            var objectCount = xDoc.SelectNodes("//root/object").Count;
            if (cellCount == 2 && objectCount == 0)
            {
                // Update 29-Aug-2019 RKW - we are no longer getting the save calls on open.
                // Allow all save calls with an empty graph.
                // return;
            }

            using (var db = new CSET_Context())
            {
                var assessmentRecord = db.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentID).FirstOrDefault();
                if (assessmentRecord != null)
                {
                    DiagramDifferenceManager differenceManager = new DiagramDifferenceManager(db);
                    XmlDocument oldDoc = new XmlDocument();
                    if (!String.IsNullOrWhiteSpace(assessmentRecord.Diagram_Markup))
                    {
                        oldDoc.LoadXml(assessmentRecord.Diagram_Markup);
                    }
                    differenceManager.buildDiagramDictionaries(xDoc, oldDoc);
                    differenceManager.SaveDifferences(assessmentID);
                }
                else
                {
                    //what the?? where is our assessment
                    throw new ApplicationException("Assessment record is missing for id" + assessmentID);
                }

            assessmentRecord.LastUsedComponentNumber = lastUsedComponentNumber;
            String diagramXML = xDoc.OuterXml;
            if (!String.IsNullOrWhiteSpace(diagramXML))
            {
                assessmentRecord.Diagram_Markup = diagramXML;
            }
	    assessmentRecord.Diagram_Image = diagramImage;

            db.SaveChanges();
            
         
        }


        /// <summary>
        /// Returns the diagram XML for the assessment ID.  
        /// </summary>
        /// <param name="assessmentID"></param>
        /// <returns></returns>
        public DiagramResponse GetDiagram(int assessmentID)
        {
           
                var assessmentRecord = db.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentID).FirstOrDefault();

                DiagramResponse resp = new DiagramResponse();

                if (assessmentRecord != null)
                {
                    resp.DiagramXml = assessmentRecord.Diagram_Markup;
                    resp.LastUsedComponentNumber = assessmentRecord.LastUsedComponentNumber;
                    return resp;
                }

                return null;           
        }


        /// <summary>
        /// Returns a boolean indicating the presence of a diagram.
        /// </summary>
        /// <param name="assessmentID"></param>
        /// <returns></returns>
        public bool HasDiagram(int assessmentID)
        {
            using (var db = new CSET_Context())
            {
                var assessmentRecord = db.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentID).FirstOrDefault();

                DiagramResponse resp = new DiagramResponse();

                if (assessmentRecord != null)
                {
                    return assessmentRecord.Diagram_Markup != null;
                }

                return false;
            }
        }


        /// <summary>
        /// Returns the diagram image stored in the database for the assessment.
        /// </summary>
        /// <param name="assessmentID"></param>
        /// <returns></returns>
        public string GetDiagramImage(int assessmentID)
        {
            using (var db = new CSET_Context())
            {
                var assessmentRecord = db.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentID).FirstOrDefault();
                if (assessmentRecord.Diagram_Image == null)
                {
                    return string.Empty;
                }


                XmlDocument xImage = new XmlDocument();
                try
                {
                    xImage.LoadXml(assessmentRecord.Diagram_Image);
                }
                catch (Exception)
                {
                    // whatever is in the database is not XML
                    return string.Empty;
                }


                // Make sure any paths to embedded svg images are correctly qualified with this server's URL
                var serverHostUrl = System.Web.HttpContext.Current.Request.Url;
                string s = serverHostUrl.Scheme + "://" + serverHostUrl.Authority;


                var images = xImage.GetElementsByTagName("image");
                foreach (var image in images)
                {
                    var href = ((XmlElement)image).Attributes["xlink:href"];
                    if (href != null)
                    {
                        Uri u = new Uri(href.InnerText);
                        ((XmlElement)image).SetAttribute("xlink:href", s + u.LocalPath);
                    }
                }

                return xImage.OuterXml;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<ComponentSymbolGroup> GetComponentSymbols()
        {
            var resp = new List<ComponentSymbolGroup>();

            using (var db = new CSET_Context())
            {
                var symbolGroups = db.SYMBOL_GROUPS.OrderBy(x => x.Id).ToList();

                foreach (SYMBOL_GROUPS g in symbolGroups)
                {
                    var group = new ComponentSymbolGroup
                    {
                        SymbolGroupID = g.Id,
                        GroupName = g.Symbol_Group_Name,
                        SymbolGroupTitle = g.Symbol_Group_Title,
                        Symbols = new List<ComponentSymbol>()
                    };

                    resp.Add(group);

                    var symbols = db.COMPONENT_SYMBOLS.Where(x => x.Symbol_Group_Id == group.SymbolGroupID)
                        .OrderBy(x => x.Name).ToList();

                    foreach (COMPONENT_SYMBOLS s in symbols)
                    {
                        var symbol = new ComponentSymbol
                        {
                            Name = s.Name,
                            DiagramTypeXml = s.Diagram_Type_Xml,
                            Abbreviation = s.Abbreviation,
                            FileName = s.File_Name,
                            DisplayName = s.Display_Name,
                            LongName = s.Long_Name,
                            ComponentFamilyName = s.Component_Family_Name,
                            Tags = s.Tags,
                            Width = (int)s.Width,
                            Height = (int)s.Height
                        };

                        group.Symbols.Add(symbol);
                    }
                }
            }

            return resp;
        }


        /// <summary>
        /// Get all component symbols ungrouped 
        /// </summary>
        /// <returns></returns>
        public List<ComponentSymbol> GetAllComponentSymbols()
        {
            var resp = new List<ComponentSymbol>();
            using (var db = new CSET_Context())
            {


                var symbols = db.COMPONENT_SYMBOLS.OrderBy(x => x.Name).ToList();

                foreach (COMPONENT_SYMBOLS s in symbols)
                {
                    var symbol = new ComponentSymbol
                    {
                        Name = s.Name,
                        DiagramTypeXml = s.Diagram_Type_Xml,
                        Abbreviation = s.Abbreviation,
                        FileName = s.File_Name,
                        DisplayName = s.Display_Name,
                        LongName = s.Long_Name,
                        ComponentFamilyName = s.Component_Family_Name,
                        Tags = s.Tags,
                        Width = (int)s.Width,
                        Height = (int)s.Height
                    };

                    resp.Add(symbol);
                }
            }

            return resp;
        }
    }
}
