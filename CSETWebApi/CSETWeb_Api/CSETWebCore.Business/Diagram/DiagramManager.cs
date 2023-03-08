//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
////////////////////////////////
using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Xml;
using System.Xml.Serialization;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Business.Diagram.layers;
using CSETWebCore.Interfaces;
using CSETWebCore.Model.Diagram;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Hosting;
using Newtonsoft.Json;
using System.Text;
using DocumentFormat.OpenXml.Bibliography;
using static CSETWebCore.Model.Diagram.CommonSecurityAdvisoryFrameworkObject;

namespace CSETWebCore.Business.Diagram
{
    public class DiagramManager : IDiagramManager
    {
        private CSETContext _context;
        static readonly NLog.Logger _logger = NLog.LogManager.GetCurrentClassLogger();


        public DiagramManager(CSETContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Persists the diagram XML in the database.
        /// </summary>
        /// <param name="assessmentID"></param>
        /// <param name="diagramXML"></param>
        public void SaveDiagram(int assessmentID, XmlDocument xDoc, DiagramRequest req)
        {
            int lastUsedComponentNumber = req.LastUsedComponentNumber;
            string diagramImage = req.DiagramSvg;

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


            var assessmentRecord = _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentID).FirstOrDefault();
            if (assessmentRecord != null)
            {
                try
                {
                    HashSet<string> validGuid = new HashSet<string>();
                    XmlNodeList cells = xDoc.SelectNodes("//root/object[@ComponentGuid]");
                    foreach (XmlElement c in cells)
                    {
                        validGuid.Add(c.Attributes["ComponentGuid"].InnerText);
                    }

                    var list = _context.ASSESSMENT_DIAGRAM_COMPONENTS.Where(x => x.Assessment_Id == assessmentID).ToList();
                    foreach (var i in list)
                    {
                        if (!validGuid.Contains(i.Component_Guid.ToString()))
                        {
                            _context.ASSESSMENT_DIAGRAM_COMPONENTS.Remove(i);
                        }
                    }
                    _context.SaveChanges();

                    DiagramDifferenceManager differenceManager = new DiagramDifferenceManager(_context);
                    XmlDocument oldDoc = new XmlDocument();
                    if (!String.IsNullOrWhiteSpace(assessmentRecord.Diagram_Markup) && req.revision)
                    {
                        oldDoc.LoadXml(assessmentRecord.Diagram_Markup);
                    }
                    differenceManager.buildDiagramDictionaries(xDoc, oldDoc);
                    differenceManager.SaveDifferences(assessmentID);

                }
                catch (Exception exc)
                {
                    NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
                }
                finally
                {
                    assessmentRecord.LastUsedComponentNumber = lastUsedComponentNumber;
                    String diagramXML = xDoc.OuterXml;
                    if (!String.IsNullOrWhiteSpace(diagramXML))
                    {
                        assessmentRecord.Diagram_Markup = diagramXML;
                    }
                    assessmentRecord.Diagram_Image = diagramImage;
                    _context.SaveChanges();
                }
            }
            else
            {
                //what the?? where is our assessment
                throw new ApplicationException("Assessment record is missing for id" + assessmentID);
            }
        }

        /// <summary>
        /// Returns the diagram XML for the assessment ID.  
        /// </summary>
        /// <param name="assessmentID"></param>
        /// <returns></returns>
        public DiagramResponse GetDiagram(int assessmentID)
        {

            var assessmentRecord = _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentID).FirstOrDefault();

            DiagramResponse resp = new DiagramResponse();

            if (assessmentRecord != null)
            {
                resp.DiagramXml = assessmentRecord.Diagram_Markup;
                resp.LastUsedComponentNumber = assessmentRecord.LastUsedComponentNumber;
                resp.AnalyzeDiagram = assessmentRecord.AnalyzeDiagram;
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

            var assessmentRecord = _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentID).FirstOrDefault();

            DiagramResponse resp = new DiagramResponse();

            if (assessmentRecord != null)
            {
                return assessmentRecord.Diagram_Markup != null;
            }

            return false;
        }


        /// <summary>
        /// Returns the diagram image stored in the database for the assessment.
        /// </summary>
        /// <param name="assessmentID"></param>
        /// <returns></returns>
        public string GetDiagramImage(int assessmentID, string http)
        {
            var assessmentRecord = _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentID).FirstOrDefault();
            if (assessmentRecord.Diagram_Image == null)
            {
                return string.Empty;
            }


            XmlDocument xImage = new XmlDocument();
            try
            {
                xImage.LoadXml(assessmentRecord.Diagram_Image);
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                // whatever is in the database is not XML
                return string.Empty;
            }


            // Make sure any paths to embedded svg images are correctly qualified with this server's URL

            //var serverHostUrl = System.Web.HttpContext.Current.Request.Url;
            //var contextFeature = http.HttpContext.Features.Get<IHttpRequestFeature>();
            //var urlContext = url.ActionContext.HttpContext.Request.Scheme;
            var uri = new Uri(http);
            string s = uri.Scheme + "://" + uri.Authority;


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

            XmlElement xDoc = xImage.DocumentElement;
            xDoc.SetAttribute("width", "100%");
            xDoc.SetAttribute("height", "100%");

            return xImage.OuterXml;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<ComponentSymbolGroup> GetComponentSymbols()
        {
            var resp = new List<ComponentSymbolGroup>();
            var symbolGroups = _context.SYMBOL_GROUPS.OrderBy(x => x.Id).ToList();

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

                var symbols = _context.COMPONENT_SYMBOLS.Where(x => x.Symbol_Group_Id == group.SymbolGroupID)
                    .OrderBy(x => x.Symbol_Name).ToList();

                foreach (COMPONENT_SYMBOLS s in symbols)
                {
                    var symbol = new ComponentSymbol
                    {
                        Symbol_Name = s.Symbol_Name,
                        Abbreviation = s.Abbreviation,
                        FileName = s.File_Name,
                        ComponentFamilyName = s.Component_Family_Name,
                        Search_Tags = s.Search_Tags,
                        Width = (int)s.Width,
                        Height = (int)s.Height
                    };

                    group.Symbols.Add(symbol);
                }
            }

            return resp;
        }

        public string ImportOldCSETDFile(string diagramXml, int assessmentId)
        {
            var t = new TranslateCsetdToDrawio();
            string newDiagramXml = t.Translate(_context, diagramXml).OuterXml;
            _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).First().Diagram_Markup = null;
            //string sql =
            //"delete ASSESSMENT_DIAGRAM_COMPONENTS  where assessment_id = @id;" +
            //"delete [DIAGRAM_CONTAINER] where assessment_id = @id;";

            //db.Database.ExecuteSqlCommand(sql,
            //    new SqlParameter("@Id", assessmentId));
            var diagramComponents = _context.ASSESSMENT_DIAGRAM_COMPONENTS.Where(x => x.Assessment_Id == assessmentId);
            var diagramContainer = _context.DIAGRAM_CONTAINER.Where(x => x.Assessment_Id == assessmentId);
            _context.ASSESSMENT_DIAGRAM_COMPONENTS.RemoveRange(diagramComponents);
            _context.DIAGRAM_CONTAINER.RemoveRange(diagramContainer);

            _context.SaveChanges();
            XmlDocument xDoc = new XmlDocument();
            xDoc.LoadXml(newDiagramXml);
            SaveDiagram(assessmentId, xDoc, new DiagramRequest()
            {
                LastUsedComponentNumber = 0,
                DiagramSvg = String.Empty
            });
            return newDiagramXml;
        }


        /// <summary>
        /// Get all component symbols ungrouped 
        /// </summary>
        /// <returns></returns>
        public List<ComponentSymbol> GetAllComponentSymbols()
        {
            var resp = new List<ComponentSymbol>();

            var symbols = _context.COMPONENT_SYMBOLS.OrderBy(x => x.Symbol_Name).ToList();

            foreach (COMPONENT_SYMBOLS s in symbols)
            {
                var symbol = new ComponentSymbol
                {
                    Abbreviation = s.Abbreviation,
                    FileName = s.File_Name,
                    Symbol_Name = s.Symbol_Name,
                    Component_Symbol_Id = s.Component_Symbol_Id,
                    ComponentFamilyName = s.Component_Family_Name,
                    Search_Tags = s.Search_Tags,
                    Width = (int)s.Width,
                    Height = (int)s.Height
                };

                resp.Add(symbol);

            }

            return resp;
        }

        /// <summary>
        /// Get xml stream for an assessment diagram
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public StringReader GetDiagramXml(int assessmentId)
        {
            var diagram = _context.ASSESSMENTS.FirstOrDefault(a => a.Assessment_Id == assessmentId)?.Diagram_Markup;

            if (diagram != null)
            {
                var stream = new StringReader(diagram);
                return stream;
            }

            return null;
        }

        /// <summary>
        /// get vertices from diagram stream
        /// </summary>
        /// <param name="stream"></param>
        /// <returns></returns>
        public List<mxGraphModelRootObject> ProcessDiagramVertices(StringReader stream, int assessment_id)
        {

            List<mxGraphModelRootObject> vertices = new List<mxGraphModelRootObject>();
            if (stream != null)
            {
                XmlSerializer deserializer = new XmlSerializer(typeof(mxGraphModel));
                var diagramXml = (mxGraphModel)deserializer.Deserialize((stream));

                mxGraphModelRootObject o = new mxGraphModelRootObject();
                Type objectType = typeof(mxGraphModelRootObject);

                LayerManager layers = new LayerManager(_context, assessment_id);
                foreach (var item in diagramXml.root.Items)
                {
                    if (item.GetType() == objectType)
                    {

                        var addLayerVisible = (mxGraphModelRootObject)item;
                        string parentId = !string.IsNullOrEmpty(addLayerVisible.mxCell.parent) ? addLayerVisible.mxCell.parent : addLayerVisible.parent ?? "0";
                        var layerVisibility = layers.GetLastLayer(parentId);
                        if (layerVisibility != null) 
                        {
                            addLayerVisible.visible = layerVisibility.visible ?? "true";
                            addLayerVisible.layerName = layerVisibility.layerName ?? string.Empty;

                            vertices.Add(addLayerVisible);
                        }
                    }

                }
            }

            return vertices;
        }


        /// <summary>
        /// get vertices from diagram stream
        /// </summary>
        /// <param name="stream"></param>
        /// <returns></returns>
        public List<mxGraphModelRootMxCell> ProcessDiagramShapes(StringReader stream, int assessment_id)
        {

            List<mxGraphModelRootMxCell> vertices = new List<mxGraphModelRootMxCell>();
            if (stream != null)
            {
                XmlSerializer deserializer = new XmlSerializer(typeof(mxGraphModel));
                var diagramXml = (mxGraphModel)deserializer.Deserialize((stream));

                Type objectType = typeof(mxGraphModelRootMxCell);


                foreach (var item in diagramXml.root.Items)
                {
                    if (item.GetType() == objectType)
                    {
                        var addLayerVisible = (mxGraphModelRootMxCell)item;
                        var layerVisibility = getLayerVisibility(addLayerVisible.parent, assessment_id);
                        if (layerVisibility != null) 
                        { 
                            addLayerVisible.visible = layerVisibility.visible;
                            addLayerVisible.layerName = layerVisibility.layerName;
                            vertices.Add(addLayerVisible);
                        }
                    }

                }
            }

            return vertices;
        }

        /// <summary>
        /// get edges from diagram stream
        /// </summary>
        /// <param name="stream"></param>
        /// <returns></returns>
        public List<mxGraphModelRootObject> ProcessDiagramEdges(StringReader stream, int assessment_id)
        {
            List<mxGraphModelRootObject> edges = new List<mxGraphModelRootObject>();
            if (stream != null)
            {
                XmlSerializer deserializer = new XmlSerializer(typeof(mxGraphModel));
                var diagramXml = (mxGraphModel)deserializer.Deserialize((stream));

                Type objectType = typeof(mxGraphModelRootObject);

                foreach (var item in diagramXml.root.Items)
                {
                    if (item.GetType() == objectType)
                    {
                        var addLayerVisible = (mxGraphModelRootObject)item;
                        var layerVisibility = getLayerVisibility(addLayerVisible.parent, assessment_id);
                        if (layerVisibility != null) 
                        {
                            addLayerVisible.visible = layerVisibility.visible;
                            addLayerVisible.layerName = layerVisibility.layerName;
                            edges.Add(addLayerVisible);
                        }
                    }
                }
            }

            return edges;
        }

        //TODO check to see if this is still the same
        /// <summary>
        /// 
        /// </summary>
        /// <param name="drawIoId"></param>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public LayerVisibility getLayerVisibility(string drawIoId, int assessment_id)
        {
            //get the parent id
            var lm = new LayerManager(_context, assessment_id);
            var list = lm.GetLastLayer(drawIoId);

            //Dictionary<string, LayerVisibility> allItems = list.ToDictionary(x => x.DrawIo_id, x => x);
            //LayerVisibility layer = new LayerVisibility();
            //LayerVisibility lastLayer = new LayerVisibility();
            //while (!string.IsNullOrEmpty(drawIoId) && allItems.TryGetValue(drawIoId, out layer))
            //{
            //    lastLayer = layer;
            //    drawIoId = layer.Parent_DrawIo_id;
            //}

            return list;
        }



        /// <summary>
        /// Get components from diagram xml objects
        /// </summary>
        /// <param name="diagram"></param>
        /// <returns></returns>
        public List<mxGraphModelRootObject> GetDiagramComponents(List<mxGraphModelRootObject> vertices)
        {
            try
            {
                var diagramComponents = vertices.Where(x => !string.IsNullOrEmpty(x.ComponentGuid)).ToList();
                var diagramZones = GetDiagramZones(vertices);
                var symbols = GetAllComponentSymbols();
                for (int i = 0; i < diagramComponents.Count(); i++)
                {
                    var imageTag = diagramComponents[i].mxCell.style.Split(';').FirstOrDefault(x => x.Contains("image="));

                    if (!string.IsNullOrEmpty(imageTag))
                    {
                        var image = imageTag.Split('/').LastOrDefault();
                        diagramComponents[i].assetType = symbols.FirstOrDefault(x => x.FileName == image)?.Symbol_Name;
                    }

                    mxGraphModelRootObject parent = diagramZones.FirstOrDefault(x => x.id == diagramComponents[i].mxCell.parent);

                    if (string.IsNullOrEmpty(diagramComponents[i].SAL))
                    {
                        diagramComponents[i].SAL = parent?.SAL;
                    }

                    diagramComponents[i].zoneLabel = parent?.label;
                }

                return diagramComponents;
            }
            catch (Exception ex)
            {
                var message = ex.Message;
            }
            finally
            {
            }

            return null;
        }

        /// <summary>
        /// Get lines from diagram xml objects
        /// </summary>
        /// <param name="edges"></param>
        /// <returns></returns>
        public List<mxGraphModelRootObject> GetDiagramLinks(List<mxGraphModelRootObject> edges)
        {
            var diagramLines = edges.Where(l => l.mxCell.edge == "1").ToList();
            return diagramLines;
        }

        /// <summary>
        /// Get zones from diagram xml objects
        /// </summary>
        /// <param name="vertices"></param>
        /// <returns></returns>
        public List<mxGraphModelRootObject> GetDiagramZones(List<mxGraphModelRootObject> vertices)
        {
            var diagramZones = vertices.Where(z => z.zone == "1").ToList();
            return diagramZones;
        }

        /// <summary>
        /// Get shapes from diagram xml objects
        /// </summary>
        /// <param name="vertices"></param>
        /// <returns></returns>
        public List<mxGraphModelRootMxCell> GetDiagramShapes(List<mxGraphModelRootMxCell> vertices)
        {
            var diagramShapes = vertices.Where(x => !string.IsNullOrEmpty(x.style) && x.style.Contains("shape=")).ToList();
            return diagramShapes;
        }

        /// <summary>
        /// Get text from diagram xml objects
        /// </summary>
        /// <param name="vertices"></param>
        /// <returns></returns>
        public List<mxGraphModelRootMxCell> GetDiagramText(List<mxGraphModelRootMxCell> vertices)
        {
            var diagramText = vertices.Where(x => !string.IsNullOrEmpty(x.style) && x.style.Contains("text")).ToList();
            return diagramText;
        }

        /// <summary>
        /// Update fields of link
        /// </summary>
        /// <param name="vertice"></param>
        /// <param name="assessmentId"></param>
        public void SaveLink(mxGraphModelRootMxCell vertice, int assessmentId)
        {
            try
            {
                var stream = GetDiagramXml(assessmentId);
                XmlSerializer serializer = new XmlSerializer(typeof(mxGraphModel));
                var diagramXml = (mxGraphModel)serializer.Deserialize(stream);
                for (int i = 0; i < diagramXml.root.Items.Length; i++)
                {
                    mxGraphModelRootMxCell item = new mxGraphModelRootMxCell();
                    Type objectType = typeof(mxGraphModelRootMxCell);

                    if (diagramXml.root.Items[i].GetType() == objectType)
                    {
                        item = (mxGraphModelRootMxCell)diagramXml.root.Items[i];
                    }

                    if (item.id == vertice.id)
                    {
                        item.value = vertice.value;
                        diagramXml.root.Items[i] = (object)item;
                    }
                }

                SaveDiagramXml(assessmentId, diagramXml);
            }
            catch (Exception ex)
            {
                var message = ex.Message;
            }
            finally
            {
            }


        }

        /// <summary>
        /// Update fields of components
        /// </summary>
        /// <param name="vertice"></param>
        /// <param name="assessmentId"></param>
        public void SaveComponent(mxGraphModelRootObject vertice, int assessmentId)
        {
            try
            {
                var stream = GetDiagramXml(assessmentId);
                XmlSerializer serializer = new XmlSerializer(typeof(mxGraphModel));
                var diagramXml = (mxGraphModel)serializer.Deserialize(stream);
                for (int i = 0; i < diagramXml.root.Items.Length; i++)
                {
                    mxGraphModelRootObject item = new mxGraphModelRootObject();
                    Type objectType = typeof(mxGraphModelRootObject);

                    if (diagramXml.root.Items[i].GetType() == objectType)
                    {
                        item = (mxGraphModelRootObject)diagramXml.root.Items[i];
                    }

                    if (item.id == vertice.id)
                    {
                        item.label = vertice.label;
                        int Component_Symbol_Id = getFromLegacyName(vertice.assetType).Component_Symbol_Id;
                        item.mxCell.style = this.SetImage(Component_Symbol_Id, item.mxCell.style);
                        item.internalLabel = vertice.label;
                        item.HasUniqueQuestions = vertice.HasUniqueQuestions;
                        item.Criticality = vertice.Criticality;
                        item.Description = vertice.Description;
                        item.HostName = vertice.HostName;
                        item.PhysicalLocation = vertice.PhysicalLocation;
                        item.VendorName = vertice.VendorName;
                        item.ProductName = vertice.ProductName;
                        item.VersionName = vertice.VersionName;
                        item.SerialNumber = vertice.SerialNumber;
                        diagramXml.root.Items[i] = (object)item;
                    }
                }

                SaveDiagramXml(assessmentId, diagramXml);
            }
            catch (Exception ex)
            {
                var message = ex.Message;
                _logger.Error(message);
            }
            finally
            {
            }


        }

        private static Dictionary<string, COMPONENT_SYMBOLS> legacyNamesList = null;

        public COMPONENT_SYMBOLS getFromLegacyName(string name)
        {
            if (legacyNamesList == null)
            {
                legacyNamesList = (from a in _context.COMPONENT_NAMES_LEGACY
                                   join b in _context.COMPONENT_SYMBOLS on a.Component_Symbol_id equals
                                   b.Component_Symbol_Id
                                   select new { a, b }).ToDictionary(x => x.a.Old_Symbol_Name, x => x.b);
            }
            return legacyNamesList[name];

        }

        /// <summary>
        /// Update fields of zone
        /// </summary>
        /// <param name="vertice"></param>
        /// <param name="assessmentId"></param>
        public void SaveZone(mxGraphModelRootObject vertice, int assessmentId)
        {
            try
            {
                var stream = GetDiagramXml(assessmentId);
                XmlSerializer serializer = new XmlSerializer(typeof(mxGraphModel));
                var diagramXml = (mxGraphModel)serializer.Deserialize(stream);
                for (int i = 0; i < diagramXml.root.Items.Length; i++)
                {
                    mxGraphModelRootObject item = new mxGraphModelRootObject();
                    Type objectType = typeof(mxGraphModelRootObject);

                    if (diagramXml.root.Items[i].GetType() == objectType)
                    {
                        item = (mxGraphModelRootObject)diagramXml.root.Items[i];
                    }

                    if (item.id == vertice.id)
                    {
                        item.label = vertice.label;
                        item.ZoneType = vertice.ZoneType;
                        item.SAL = vertice.SAL;
                        item.internalLabel = vertice.label;
                        diagramXml.root.Items[i] = (object)item;
                    }
                }

                SaveDiagramXml(assessmentId, diagramXml);
            }
            catch (Exception ex)
            {
                var message = ex.Message;
            }
            finally
            {
            }


        }

        /// <summary>
        /// Update fields of shape
        /// </summary>
        /// <param name="vertice"></param>
        /// <param name="assessmentId"></param>
        public void SaveShape(mxGraphModelRootMxCell vertice, int assessmentId)
        {
            try
            {
                var stream = GetDiagramXml(assessmentId);
                XmlSerializer serializer = new XmlSerializer(typeof(mxGraphModel));
                var diagramXml = (mxGraphModel)serializer.Deserialize(stream);
                for (int i = 0; i < diagramXml.root.Items.Length; i++)
                {
                    mxGraphModelRootMxCell item = new mxGraphModelRootMxCell();
                    Type objectType = typeof(mxGraphModelRootMxCell);

                    if (diagramXml.root.Items[i].GetType() == objectType)
                    {
                        item = (mxGraphModelRootMxCell)diagramXml.root.Items[i];
                    }

                    if (item.id == vertice.id)
                    {
                        item.value = vertice.value;
                        diagramXml.root.Items[i] = (object)item;
                    }
                }

                SaveDiagramXml(assessmentId, diagramXml);
            }
            catch (Exception ex)
            {
                var message = ex.Message;
            }
            finally
            {
            }
        }

        public void SaveDiagramXml(int assessmentId, mxGraphModel diagramXml)
        {
            using (var sww = new StringWriter())
            {
                using (XmlWriter writer = XmlWriter.Create(sww))
                {
                    XmlSerializer serializer = new XmlSerializer(typeof(mxGraphModel));
                    serializer.Serialize(writer, diagramXml);
                    string xml = sww.ToString();
                    var assessment = _context.ASSESSMENTS.FirstOrDefault(x => x.Assessment_Id == assessmentId);
                    var xDoc = new XmlDocument();
                    xDoc.LoadXml(xml);
                    if (assessment != null)
                        SaveDiagram(assessmentId, xDoc, new DiagramRequest()
                        {
                            LastUsedComponentNumber = assessment.LastUsedComponentNumber,
                            DiagramSvg = assessment.Diagram_Image
                        });
                }
            }
        }

        public string SetImage(int Component_Symbol_Id, string style)
        {
            var symbols = this.GetAllComponentSymbols();
            var styles = style.Split(';');
            string newStyle = string.Empty;
            for (int i = 0; i < styles.Length; i++)
            {
                if (styles[i].Contains("image="))
                {
                    styles[i] = string.Format("image=img/cset/{0}",
                        symbols.FirstOrDefault(x => x.Component_Symbol_Id == Component_Symbol_Id)?.FileName);
                }
            }

            foreach (var s in styles)
            {
                newStyle += !string.IsNullOrEmpty(s) ? s + ";" : string.Empty;
            }

            return newStyle;
        }

        /// <summary>
        /// Returns all diagram templates stored in the database.
        /// </summary>
        /// <returns></returns>
        public IEnumerable<DiagramTemplate> GetDiagramTemplates()
        {
            var templates = Enumerable.Empty<DiagramTemplate>();

            templates = _context.DIAGRAM_TEMPLATES
                .Where(x => x.Is_Visible ?? false)
                .OrderBy(x => x.Id)
                .Select(x => new DiagramTemplate
                {
                    Name = x.Template_Name,
                    ImageSource = x.Image_Source,
                    Markup = x.Diagram_Markup
                })
                .ToArray();

            return templates;
        }

        /// <summary>
        /// Gets all of the vendors from the uploaded CSAF_FILE records in the DB.
        /// </summary>
        /// <returns></returns>
        public IEnumerable<CommonSecurityAdvisoryFrameworkVendor> GetCsafVendors() 
        {
            List<CSAF_FILE> csafList = _context.CSAF_FILE.ToList();
            List<CommonSecurityAdvisoryFrameworkVendor> vendors = new List<CommonSecurityAdvisoryFrameworkVendor>();

            foreach (var csaf in csafList)
            {
                var csafObj = JsonConvert.DeserializeObject<CommonSecurityAdvisoryFrameworkObject>(Encoding.UTF8.GetString(csaf.Data));

                var vendor = new CommonSecurityAdvisoryFrameworkVendor(csafObj);
                var existingVendor = vendors.Find(v => v.Name.Trim() == vendor.Name.Trim());

                // Use existing vendor from list if present
                if (existingVendor != null)
                {
                    vendor = existingVendor;
                }

                if (csafObj.Product_Tree.Branches[0].Branches == null)
                {
                    csafObj.Product_Tree.Branches[0].Branches = new List<Branch>();
                }
                    
                foreach (var branch in csafObj.Product_Tree.Branches[0].Branches)
                {
                    // Add newly found products, else add new vulnerabilites to existing product
                    var newProduct = new CommonSecurityAdvisoryFrameworkProduct(csafObj, branch);
                    if (!vendor.Products.Exists(p => p.Name == newProduct.Name))
                    {
                        vendor.Products.Add(newProduct);
                    }
                    else
                    {
                        var existingProduct = vendor.Products.Find(p => p.Name == newProduct.Name);
                        existingProduct.AffectedVersions += " / " + branch.Branches?[0].Name;
                        foreach (var vulnerability in newProduct.Vulnerabilities)
                        {
                            if (!existingProduct.Vulnerabilities.Exists(v => v.Cve == vulnerability.Cve))
                            {
                                existingProduct.Vulnerabilities.Add(vulnerability);
                            }
                        }
                    }
                }

                if (existingVendor == null)
                {
                    vendors.Add(vendor);
                }
            }

            vendors.Sort((a, b) => string.Compare(a.Name, b.Name, true));

            foreach (var vendor in vendors)
            {
                vendor.Products.Sort((a, b) => string.Compare(a.Name, b.Name, true));
            }

            return vendors;
        }

        /// <summary>
        /// Adds a new / modifies an existing CSAF vendor and persists it to the database.
        /// Currently, users can only manually add vendors and products (not vulnerabilities);
        /// </summary>
        /// <param name="vendor"></param>
        /// <returns>The newly added / edited vendor</returns>
        public CommonSecurityAdvisoryFrameworkVendor SaveCsafVendor(CommonSecurityAdvisoryFrameworkVendor vendor) 
        {
            var currentVendors = GetCsafVendors();

            var existingVendor = currentVendors.FirstOrDefault(v => v.Name == vendor.Name);

            if (existingVendor != null)
            {
                var allCsafs = _context.CSAF_FILE.ToList();

                var dbCsafFile = allCsafs.FirstOrDefault(
                    csaf => JsonConvert.DeserializeObject<CommonSecurityAdvisoryFrameworkObject>(Encoding.UTF8.GetString(csaf.Data))
                    .Product_Tree.Branches[0].Name == existingVendor.Name
                    );

                var csafObj = JsonConvert.DeserializeObject<CommonSecurityAdvisoryFrameworkObject>(Encoding.UTF8.GetString(dbCsafFile.Data));

                foreach (var product in vendor.Products)
                {
                    var existingProduct = existingVendor.Products.Find(p => p.Name == product.Name);
                    if (existingProduct == null)
                    {
                        existingVendor.Products.Add(product);

                        if (csafObj.Product_Tree.Branches[0].Branches == null)
                        {
                            csafObj.Product_Tree.Branches[0].Branches = new List<Branch>();
                        }

                        csafObj.Product_Tree.Branches[0].Branches.Add(new Branch { Name = product.Name });
                    }
                }

                existingVendor.Products.Sort((a, b) => string.Compare(a.Name, b.Name, true));

                dbCsafFile.Data = Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(csafObj));

                _context.SaveChanges();

                return existingVendor;
            }
            else
            {
                CommonSecurityAdvisoryFrameworkObject newCsafObj = new CommonSecurityAdvisoryFrameworkObject(vendor);

                var bytes = Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(newCsafObj));

                CSAF_FILE csafFile = new CSAF_FILE
                {
                    File_Name = vendor.Name + "-CUSTOM.json",
                    Data = bytes,
                    File_Size = bytes.LongLength,
                    Upload_Date = DateTime.Now,
                };

                _context.CSAF_FILE.Add(csafFile);
                _context.SaveChanges();

                return vendor;
            }
        }

        public void DeleteCsafVendor(string vendorName) 
        {
            var allCsafs = _context.CSAF_FILE.ToList();
            var csafFilesToRemove = allCsafs.Where(csaf => JsonConvert.DeserializeObject<CommonSecurityAdvisoryFrameworkObject>(Encoding.UTF8.GetString(csaf.Data))
                    .Product_Tree.Branches[0].Name == vendorName);

            _context.CSAF_FILE.RemoveRange(csafFilesToRemove);

            _context.SaveChanges();
        }

        public void DeleteCsafProduct(string vendorName, string productName) 
        {
            var allCsafs = _context.CSAF_FILE.ToList();
            var csafFilesWithTargetVendor = allCsafs.Where(csaf => JsonConvert.DeserializeObject<CommonSecurityAdvisoryFrameworkObject>(Encoding.UTF8.GetString(csaf.Data))
                    .Product_Tree.Branches[0].Name == vendorName);

            foreach (CSAF_FILE csafFile in csafFilesWithTargetVendor) 
            {
                CommonSecurityAdvisoryFrameworkObject csafObj = JsonConvert.DeserializeObject<CommonSecurityAdvisoryFrameworkObject>(Encoding.UTF8.GetString(csafFile.Data));
                csafObj.Product_Tree.Branches[0].Branches.RemoveAll(branch => branch.Name == productName);

                csafFile.Data = Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(csafObj));
            }

            _context.SaveChanges();
        }
    }
}
