//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
////////////////////////////////
using CSETWebCore.Business.Diagram.layers;
using CSETWebCore.Business.Malcolm;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces;
using CSETWebCore.Model.Diagram;
using CSETWebCore.Model.Malcolm;
using Newtonsoft.Json;
using NPOI.SS.Formula.Functions;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Serialization;
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
        public void SaveDiagram(int assessmentID, XmlDocument xDoc, DiagramRequest req, bool refreshQuestions = true)
        {
            int lastUsedComponentNumber = req.LastUsedComponentNumber;
            string diagramImage = req.DiagramSvg;

            // the front end sometimes calls 'save' with an empty graph on open.  
            // Need to prevent the javascript from doing that on open, but for now,
            // let's detect an empty graph and not save it.

            var cellCount = xDoc.SelectNodes("//root/mxCell").Count;
            var objectCount = xDoc.SelectNodes("//root/UserObject").Count;

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
                    XmlNodeList cells = xDoc.SelectNodes("//root/UserObject[@ComponentGuid]");

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
                    differenceManager.BuildDiagramDictionaries(xDoc, oldDoc);
                    differenceManager.SaveDifferences(assessmentID, refreshQuestions);

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

                    var mb = new MalcolmBusiness(_context);
                    mb.VerificationAndValidation(assessmentID);
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
                // updates the previous version's 'object' to 'UserObject' if needed (Draw.IO v21.0.2 uses 'UserObject' instead)
                // I know this is a potentially dangerous replacement, so look here if things break
                if (diagram.Contains("<object ") && diagram.Contains("</object>"))
                {
                    diagram = diagram.Replace("<object ", "<UserObject ");
                    diagram = diagram.Replace("</object>", "</UserObject>");

                    _context.ASSESSMENTS.Where(a => a.Assessment_Id == assessmentId).FirstOrDefault().Diagram_Markup = diagram;
                    _context.SaveChanges();
                }

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
                //mxGraphModelRootMxCell cell = new mxGraphModelRootMxCell();

                Type objectType = typeof(mxGraphModelRootObject);
                //Type objectType = typeof(mxGraphModelRootMxCell);

                LayerManager layers = new LayerManager(_context, assessment_id);
                foreach (var item in diagramXml.root.Items)
                {
                    if (item.GetType() == objectType)
                    {
                        /*
                        var currentCell = (mxGraphModelRootMxCell)item;
                        //if (currentCell.mxGeometry == null)
                        //{
                            //var addLayerVisible = (mxGraphModelRootMxCell)item;

                            string parentId = !string.IsNullOrEmpty(currentCell.parent) ? currentCell.parent : o.parent ?? "0";
                            //string parentId = !string.IsNullOrEmpty(addLayerVisible.parent) ? addLayerVisible.parent : addLayerVisible.parent ?? "0";

                            var layerVisibility = layers.GetLastLayer(parentId);
                            var addLayerVisible = o;

                            if (layerVisibility != null)
                            {
                                addLayerVisible.visible = layerVisibility.visible ?? "true";
                                addLayerVisible.layerName = layerVisibility.layerName ?? string.Empty;
                                addLayerVisible.id = currentCell.id ?? "0";
                                vertices.Add(addLayerVisible);
                            }
                        //}
                        */

                        var addLayerVisible = (mxGraphModelRootObject)item;
                        //var addLayerVisible = (mxGraphModelRootMxCell)item;

                        string parentId = !string.IsNullOrEmpty(addLayerVisible.mxCell.parent) ? addLayerVisible.mxCell.parent : addLayerVisible.parent ?? "0";
                        //string parentId = !string.IsNullOrEmpty(addLayerVisible.parent) ? addLayerVisible.parent : addLayerVisible.parent ?? "0";

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


        /// <summary>
        /// Sets the type of a component in the diagram XML 
        /// and in the assessment's component inventory.
        /// </summary>
        /// <param name="guid"></param>
        /// <param name="type"></param>
        public void UpdateComponentType(int assessmentId, string guid, string type)
        {
            var componentGuid = Guid.Parse(guid);
            var adc = _context.ASSESSMENT_DIAGRAM_COMPONENTS.FirstOrDefault(x => x.Assessment_Id == assessmentId && x.Component_Guid == componentGuid);
            var symbol = _context.COMPONENT_SYMBOLS.FirstOrDefault(x => x.Abbreviation == type);

            if (adc == null || symbol?.Component_Symbol_Id == null)
            {
                // I was fed something I can't update; do nothing
                return;
            }

            // change the symbol that the component is associated with
            adc.Component_Symbol_Id = symbol.Component_Symbol_Id;


            // Update the image in the diagram markup for the component
            var assessment = _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();

            var xDiagram = new XmlDocument();
            xDiagram.LoadXml(assessment.Diagram_Markup);
            var mxCell = (XmlElement)xDiagram.SelectSingleNode($"//UserObject[@ComponentGuid='{componentGuid}']/mxCell");

            //var mxCell = (XmlElement)xDiagram.SelectSingleNode($"//object[@ComponentGuid='{componentGuid}']/mxCell");
            if (mxCell == null)
            {
                return;
            }

            // change the image path and size in the cell style
            var newStyle = this.SetImage(symbol.Component_Symbol_Id, mxCell.Attributes["style"].InnerText);
            mxCell.SetAttribute("style", newStyle);

            var geometry = (XmlElement)mxCell.SelectSingleNode("mxGeometry");
            geometry.SetAttribute("width", symbol.Width.ToString());
            geometry.SetAttribute("height", symbol.Height.ToString());

            assessment.Diagram_Markup = xDiagram.OuterXml;

            _context.SaveChanges();
        }


        /// <summary>
        /// Changes a shape into a CSET component.
        /// </summary>
        /// <param name="label"></param>
        /// <param name="id"></param>
        /// <param name="type"></param>
        public void ChangeShapeToComponent(int assessmentId, string type, string id, string label)
        {
            var componentGuid = Guid.NewGuid();
            var assessment = _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();

            var symbol = _context.COMPONENT_SYMBOLS.FirstOrDefault(x => x.Abbreviation == type);

            // Sorry about the hardcoded styling, but this is the same for every cset component I found, so it *should* be ok
            var symbolStyle = "whiteSpace=wrap;html=1;image;image=img/cset/" + symbol.File_Name + ";labelBackgroundColor=none;";

            if (symbol?.Component_Symbol_Id == null)
            {
                // I was fed something I can't update; do nothing
                return;
            }

            var xDiagram = new XmlDocument();
            xDiagram.LoadXml(assessment.Diagram_Markup);

            // gets the mxCell of the shape
            var mxCell = (XmlElement)xDiagram.SelectSingleNode($"//mxCell[@id='{id}']");
            if (mxCell == null)
            {
                return;
            }

            // gets the parent node of te shape (zone or layer)
            var parent = mxCell.GetAttribute("parent");

            // creates a UserObject to be the new CSET component
            var userObject = xDiagram.CreateElement("UserObject");
            userObject.SetAttribute("label", label);
            userObject.SetAttribute("ComponentGuid", componentGuid.ToString());
            userObject.SetAttribute("HasUniqueQuestions", "");
            userObject.SetAttribute("IPAddress", "");
            userObject.SetAttribute("Description", "");
            userObject.SetAttribute("Criticality", "");
            userObject.SetAttribute("HostName", "");
            userObject.SetAttribute("parent", parent);
            userObject.SetAttribute("id", id);

            // taking out the unecessary attributes from the mxCell (already assigned to the soon-to-be parent userObject)
            mxCell.RemoveAttribute("value");
            mxCell.RemoveAttribute("id");
            mxCell.SetAttribute("style", symbolStyle);

            // puts the mxCell and the cell's mxGeometry into the UserObject
            userObject.PrependChild(mxCell);

            var zoneId = _context.DIAGRAM_CONTAINER.Where(x => x.Assessment_Id == assessmentId && x.DrawIO_id == parent).Select(x => x.Container_Id).FirstOrDefault();
            var layerId = _context.DIAGRAM_CONTAINER.Where(x => x.Assessment_Id == assessmentId && x.Parent_Id == 0).Select(x => x.Container_Id).FirstOrDefault();

            // build and put the new CSET component into the database
            ASSESSMENT_DIAGRAM_COMPONENTS adc = new ASSESSMENT_DIAGRAM_COMPONENTS();
            adc.Assessment_Id = assessmentId;
            adc.Component_Guid = componentGuid;
            adc.Component_Symbol_Id = symbol.Component_Symbol_Id;
            adc.DrawIO_id = id;
            adc.label = label;
            adc.Zone_Id = zoneId == 0 ? null : zoneId;
            adc.Layer_Id = layerId;

            _context.ASSESSMENT_DIAGRAM_COMPONENTS.Add(adc);
            _context.SaveChanges();

            // puts the UserObject right after its parent (to keep them together for readability)
            var parentNode = (XmlElement)xDiagram.SelectSingleNode($"//UserObject[@id='{parent}']");

            var root = (XmlElement)xDiagram.SelectSingleNode($"//root");
            root.InsertAfter(userObject, parentNode);

            assessment.Diagram_Markup = xDiagram.OuterXml;
            _context.SaveChanges();
        }


        /// <summary>
        /// Sets the label of a component in the diagram XML 
        /// and in the assessment's component inventory.
        /// </summary>
        /// <param name="guid"></param>
        /// <param name="label"></param>
        public void UpdateComponentLabel(int assessmentId, string guid, string label)
        {
            var componentGuid = Guid.Parse(guid);
            var adc = _context.ASSESSMENT_DIAGRAM_COMPONENTS.FirstOrDefault(x => x.Assessment_Id == assessmentId && x.Component_Guid == componentGuid);

            if (adc == null || label == null)
            {
                // I was fed something I can't update; do nothing
                return;
            }

            // change the label of the component
            adc.label = label;

            // Update the label in the diagram markup for the component
            var assessment = _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();

            var xDiagram = new XmlDocument();
            xDiagram.LoadXml(assessment.Diagram_Markup);
            var userObject = (XmlElement)xDiagram.SelectSingleNode($"//UserObject[@ComponentGuid='{componentGuid}']");
            userObject.Attributes["label"].Value = label;

            if (userObject == null)
            {
                return;
            }

            assessment.Diagram_Markup = xDiagram.OuterXml;

            _context.SaveChanges();
            return;
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
                .Where(x => x.Is_Visible)
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


        public XmlDocument xml = new XmlDocument();
        public int incrementalId = 0;
        public int treeNumber = 0;
        public List<YCoords> treeBounds = new List<YCoords>();
        public List<List<Geometry>> nodeLocations = new List<List<Geometry>>();

        public void CreateMalcolmDiagram(int assessmentId, List<MalcolmData> processedData)
        {
            XmlElement newMxGraphModel = xml.CreateElement("mxGraphModel");
            newMxGraphModel.SetAttribute("dx", "1050");
            newMxGraphModel.SetAttribute("yx", "610");
            newMxGraphModel.SetAttribute("grid", "1");
            newMxGraphModel.SetAttribute("gridSize", "10");
            newMxGraphModel.SetAttribute("guides", "1");
            newMxGraphModel.SetAttribute("tooltips", "1");
            newMxGraphModel.SetAttribute("connect", "1");
            newMxGraphModel.SetAttribute("arrows", "1");
            newMxGraphModel.SetAttribute("fold", "1");
            newMxGraphModel.SetAttribute("page", "0");
            newMxGraphModel.SetAttribute("pageScale", "1");
            newMxGraphModel.SetAttribute("pageWidth", "850");
            newMxGraphModel.SetAttribute("pageHeight", "1100");
            newMxGraphModel.SetAttribute("math", "0");
            newMxGraphModel.SetAttribute("shadow", "0");

            // Create an empty Network diagram
            XmlElement root = xml.CreateElement("root", null);

            XmlElement parentOfMainLayer = xml.CreateElement("mxCell");
            parentOfMainLayer.SetAttribute("id", "0");

            XmlElement mainLayer = xml.CreateElement("mxCell");
            mainLayer.SetAttribute("id", "1");
            mainLayer.SetAttribute("value", "Main Layer");
            mainLayer.SetAttribute("parent", "0");

            root.AppendChild(parentOfMainLayer);
            root.AppendChild(mainLayer);

            newMxGraphModel.AppendChild(root);
            xml.AppendChild(newMxGraphModel);

            // Generate the actual Diagram/XML objects
            for (treeNumber = 0; treeNumber < processedData[0].Trees.Count; treeNumber++)
            {
                treeBounds.Add(new YCoords());
                WalkDownTree(processedData[0].Trees[treeNumber], "");
            }

            incrementalId = 0;
            int offset = 0;
            // going through all the trees again to give buffers between trees
            for (treeNumber = 0; treeNumber < processedData[0].Trees.Count; treeNumber++)
            {
                int treeHeight = 0;
                if (treeNumber != 0)
                {
                    // will be positive becuase lowerY should always be negative
                    treeHeight = treeBounds[treeNumber - 1].upperY - treeBounds[treeNumber].lowerY;
                    offset += 120 + treeHeight;
                }

                // going through the nodes in this tree
                for (int i = 0; i < nodeLocations[treeNumber].Count; i++)
                {
                    string parentId = "component-" + incrementalId;
                    XmlElement mxGeometry = (XmlElement)xml.SelectSingleNode($"//UserObject[@id='{parentId}']").FirstChild.FirstChild;

                    int y = int.Parse(mxGeometry.Attributes["y"].Value);
                    mxGeometry.SetAttribute("y", (y + offset).ToString());
                    incrementalId++;
                }

            }

            // Save that XML to the Assessments table -- Diagram Markup.
            SaveDiagram(assessmentId, xml, new DiagramRequest(), true);
            //var mb = new MalcolmBusiness(_context);
            //mb.VerificationAndValidation(assessmentId);
        }

        public void WalkDownTree(TempNode node, string parentId)
        {
            // Get a unique Guid for each node
            string guid = Guid.NewGuid().ToString();
            string id = "component-" + incrementalId;
            incrementalId++;

            // set the label to include the node's key (IP address)
            string label = "";
            var symbol = _context.COMPONENT_SYMBOLS.Where(x => x.Symbol_Name == node.Role).FirstOrDefault();
            if (symbol == null)
            {
                symbol = _context.COMPONENT_SYMBOLS.Where(x => x.Abbreviation == node.Role).FirstOrDefault();
                if (symbol != null) 
                {
                    label = symbol.Abbreviation;
                }
                else if (symbol == null && node.Role != null)
                {
                    int symbolId = _context.COMPONENT_SYMBOLS_MAPPINGS.Where(x => x.Application == "Malcolm" && x.Malcolm_Role == node.Role)
                            .Select(x => x.Component_Symbol_Id).FirstOrDefault();

                    symbol = _context.COMPONENT_SYMBOLS.Where(x => x.Component_Symbol_Id == symbolId).FirstOrDefault();

                    if (symbol == null)
                    {
                        symbol = _context.COMPONENT_SYMBOLS.Where(x => x.Symbol_Name == "Unknown").FirstOrDefault();
                    }
                    label = node.Role;
                }
                else
                {
                    symbol = _context.COMPONENT_SYMBOLS.Where(x => x.Symbol_Name == "Unknown").FirstOrDefault();
                    label = "UN-" + node.Key;
                }
            }
            else
            {
                label = symbol.Symbol_Name;
            }


            var userObject = xml.CreateElement("UserObject");
            userObject.SetAttribute("label", label);
            userObject.SetAttribute("internalLabel", label);
            userObject.SetAttribute("ComponentGuid", guid);
            userObject.SetAttribute("HasUniqueQuestions", "");
            userObject.SetAttribute("IPAddress", node.Key);
            userObject.SetAttribute("Description", "");
            userObject.SetAttribute("Criticality", "");
            userObject.SetAttribute("HostName", "");
            userObject.SetAttribute("id", id);

            Geometry geometry = AssignCoordinates(parentId, symbol.Width, symbol.Height);
            userObject.AppendChild(CreateMxCellAndGeometry(geometry.x.ToString(), geometry.y.ToString()
                , symbol.File_Name, symbol.Width.ToString(), symbol.Height.ToString()));
            XmlElement root = (XmlElement)xml.SelectSingleNode("//root");

            root.AppendChild(userObject);

            if (parentId != "")
            {
                root.AppendChild(CreateEdge(parentId, id, "1")); // "1" because the only layer is the main layer for now
            }

            if (node.Children != null && node.Children.Count > 0)
            {
                foreach (TempNode childNode in node.Children)
                {
                    WalkDownTree(childNode, id);
                }
            }

            return;
        }

        public XmlElement CreateMxCellAndGeometry(string x, string y, string fileName, string w, string h)
        {
            XmlElement mxCell = xml.CreateElement("mxCell");
            mxCell.SetAttribute("style", "aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/" + fileName);
            mxCell.SetAttribute("vertex", "1");
            mxCell.SetAttribute("parent", "1");

            XmlElement mxGeometry = xml.CreateElement("mxGeometry");
            mxGeometry.SetAttribute("x", x);
            mxGeometry.SetAttribute("y", y);
            mxGeometry.SetAttribute("width", w);
            mxGeometry.SetAttribute("height", h);
            mxGeometry.SetAttribute("as", "geometry");

            mxCell.AppendChild(mxGeometry);

            return mxCell;
        }

        public XmlElement CreateEdge(string source, string target, string parentLayer)
        {
            XmlElement edge = xml.CreateElement("mxCell");
            edge.SetAttribute("style", "rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;");
            edge.SetAttribute("parent", parentLayer);
            edge.SetAttribute("source", source);
            edge.SetAttribute("target", target);
            edge.SetAttribute("edge", "1");

            XmlElement geometry = xml.CreateElement("mxGeometry");
            geometry.SetAttribute("relative", "1");
            geometry.SetAttribute("as", "geometry");

            edge.AppendChild(geometry);

            return edge;
        }

        public Geometry AssignCoordinates(string parentId, int w, int h)
        {
            XmlElement parentNode = (XmlElement)xml.SelectSingleNode($"//UserObject[@id='{parentId}']");
            Geometry geometry = new Geometry();

            if (parentNode == null)
            {
                geometry.x = 0;
                geometry.y = 0;
                geometry.w = w;
                geometry.h = h;

                nodeLocations.Add(new List<Geometry> { geometry });
                treeBounds[treeNumber].upperY = geometry.y;
                treeBounds[treeNumber].lowerY = geometry.y - geometry.h;
                return geometry;
            }

            int i = 0;
            int revolution = 1;
            Geometry parentCoordinates = ParseCoordinates(parentNode);
            Geometry newCoordinatesToTry = new Geometry();
            newCoordinatesToTry.w = w;
            newCoordinatesToTry.h = h;

            do
            {
                newCoordinatesToTry = CircleAroundParent(parentCoordinates, i, revolution);
                i++;
                newCoordinatesToTry.w = w;
                newCoordinatesToTry.h = h;
                if (i == 8)
                {
                    i = 0;
                    revolution++;
                }
            }
            while (AreCoordinatesOverlapping(newCoordinatesToTry));

            geometry.x = newCoordinatesToTry.x;
            geometry.y = newCoordinatesToTry.y;
            geometry.w = newCoordinatesToTry.w;
            geometry.h = newCoordinatesToTry.h;
            nodeLocations[treeNumber].Add(geometry);

            // keeps track of the upper and lower bounds for offsetting the trees later 
            if (treeBounds[treeNumber].upperY < geometry.y)
                treeBounds[treeNumber].upperY = geometry.y;

            if (treeBounds[treeNumber].lowerY >= geometry.y - geometry.h)
                treeBounds[treeNumber].lowerY = geometry.y - geometry.h;

            return geometry;
        }

        public bool AreCoordinatesOverlapping(Geometry newCoords)
        {
            // checking the nodes in this tree for overlapping (we realign the trees to not overlap later)
            foreach (Geometry currentNode in nodeLocations[treeNumber])
            {
                int currentEndX = currentNode.x + currentNode.w;
                int currentEndY = currentNode.y + currentNode.h;
                int newCoordsEndX = newCoords.x + newCoords.w;
                int newCoordsEndY = newCoords.y + newCoords.h;

                // check for x and y overlaps
                bool xOverlapping = (currentNode.x <= newCoords.x && newCoordsEndX <= currentEndX) || (currentNode.x >= newCoords.x && newCoordsEndX >= currentEndX);
                bool yOverlapping = (currentNode.y <= newCoords.y && newCoordsEndY <= currentEndY) || (currentNode.y >= newCoords.y && newCoordsEndY >= currentEndY);

                if (xOverlapping && yOverlapping)
                {
                    return true;
                }
            }

            return false;
        }

        public Geometry ParseCoordinates(XmlElement node)
        {
            var mxGeometry = node.FirstChild.FirstChild;
            string x = mxGeometry.Attributes["x"].Value;
            string y = mxGeometry.Attributes["y"].Value;
            string width = mxGeometry.Attributes["width"].Value;
            string height = mxGeometry.Attributes["height"].Value;

            int xInt, yInt, wInt, hInt;

            if (!int.TryParse(x, out xInt)
                || !int.TryParse(y, out yInt)
                || !int.TryParse(width, out wInt)
                || !int.TryParse(height, out hInt))
            {
                throw new Exception("Coordinates or width/height couldn't be found.");
            }

            return new Geometry(xInt, yInt, wInt, hInt);
        }

        /// <summary>
        /// Goes around the parent clockwise,
        /// checking for an open space (i.e. no overlaps with another component) to put the current component.
        /// </summary>
        /// <param name="geo"></param>
        /// <param name="i"></param>
        /// <param name="revolution"></param>
        /// <returns></returns>
        public Geometry CircleAroundParent(Geometry geo, int i, int revolution)
        {
            int changeAmount = 120 * revolution;
            Geometry parent = new Geometry(geo.x, geo.y, geo.w, geo.h);
            ///     3   2   1
            ///     4       0
            ///     5   6   7
            switch (i % 8)
            {
                case 0:
                    parent.x += changeAmount;
                    return parent;
                case 7:
                    parent.x += changeAmount;
                    parent.y -= changeAmount;
                    return parent;
                case 6:
                    parent.y -= changeAmount;
                    return parent;
                case 5:
                    parent.x -= changeAmount;
                    parent.y -= changeAmount;
                    return parent;
                case 4:
                    parent.x -= changeAmount;
                    return parent;
                case 3:
                    parent.x -= changeAmount;
                    parent.y += changeAmount;
                    return parent;
                case 2:
                    parent.y += changeAmount;
                    return parent;
                case 1:
                    parent.x += changeAmount;
                    parent.y += changeAmount;
                    return parent;
                default:
                    return parent;
            }
        }
        
        public class YCoords
        {
            public int upperY = 0, lowerY = 0;
            public YCoords()
            {

            }
        }

        public class Geometry
        {
            public int x = 0;
            public int y = 0;
            public int w = 0;
            public int h = 0;

            public Geometry(int x, int y, int w, int h)
            {
                this.x = x;
                this.y = y;
                this.w = w;
                this.h = h;
            }
            public Geometry()
            {

            }
        }
    }
}
