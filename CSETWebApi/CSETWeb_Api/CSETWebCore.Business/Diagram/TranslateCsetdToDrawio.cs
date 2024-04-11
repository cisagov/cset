//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Xml;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Business.Diagram
{
    public class TranslateCsetdToDrawio
    {
        #region class-level variables

        CSETContext _context;

        /// <summary>
        /// The origin document (CSETD)
        /// </summary>
        XmlDocument xCsetd = new XmlDocument();


        /// <summary>
        /// Namespace Manager used to read the CSETD document with its default namespace.
        /// </summary>
        XmlNamespaceManager nsmgr = null;


        /// <summary>
        /// The destination document (Draw.io)
        /// </summary>
        XmlDocument xDrawio = new XmlDocument();


        /// <summary>
        /// The root element in the new document.
        /// </summary>
        XmlElement xRoot = null;


        /// <summary>
        /// A map of IDs from the CSETD file to the new DRAW.IO file.
        /// The key is the CSETD ID and the value is the new Draw.IO ID.
        /// </summary>
        private Dictionary<string, string> mapIDs = new Dictionary<string, string>();


        /// <summary>
        /// An integer that is incremented to assign new unique IDs.
        /// </summary>
        int nextID = 0;


        /// <summary>
        /// Store the properties we know about each symbol.
        /// </summary>
        List<COMPONENT_SYMBOLS> symbols = null;
        Dictionary<string, COMPONENT_SYMBOLS> legacyNames = null;
        #endregion

        /// <summary>
        /// Converts XML from a .csetd file into the equivalent XML for draw.io.
        /// </summary>
        /// <param name="csetd"></param>
        /// <returns></returns>
        public XmlDocument Translate(CSETContext context, string csetd)
        {
            this._context = context;

            InitializeSymbolFilenames();

            xCsetd.LoadXml(csetd);

            nsmgr = new XmlNamespaceManager(xCsetd.NameTable);
            nsmgr.AddNamespace("c", "http://www.dhs.gov/2012/cset");


            xDrawio.LoadXml("<mxGraphModel grid=\"1\" gridSize=\"10\"><root><mxCell id=\"0\"/></root></mxGraphModel>");
            xRoot = (XmlElement)xDrawio.SelectSingleNode("*/root");


            BuildLayers();


            BuildZones();


            BuildComponents();


            BuildMSCs();


            BuildShapes();


            AssignToMSCs();


            AssignToZones();


            BuildEdges();


            return xDrawio;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="xRoot"></param>
        private void BuildLayers()
        {
            XmlNodeList layerList = xCsetd.SelectNodes("//c:layerarray", nsmgr);
            foreach (XmlNode layer in layerList)
            {
                var xL = xDrawio.CreateElement("mxCell");
                xRoot.AppendChild(xL);
                xL.SetAttribute("id", GetID(""));
                xL.SetAttribute("parent", "0");
                xL.SetAttribute("value", ChildValue(layer, "c:layername"));
                string visible = ChildValue(layer, "c:visible");
                if (visible == null)
                {
                    visible = "true";
                }
                xL.SetAttribute("visible", bool.Parse(visible) ? "1" : "0");
                // translating <defaultlayer> not supported in draw.io
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="xRoot"></param>
        private void BuildZones()
        {
            XmlNodeList zoneList = xCsetd.SelectNodes("//c:zone", nsmgr);
            foreach (XmlNode zone in zoneList)
            {
                string oldID = ChildValue(zone, "c:id");
                string newID = GetID(oldID);


                var xObject = xDrawio.CreateElement("object");
                xRoot.AppendChild(xObject);
                xObject.SetAttribute("id", newID);

                var sal = ChildValue(zone, "c:sallevel");
                xObject.SetAttribute("SAL", sal);

                var label = ChildValue(zone, "c:tag/c:label");
                xObject.SetAttribute("label", label);
                xObject.SetAttribute("internalLabel", label);

                var xZone = xDrawio.CreateElement("mxCell");
                xObject.AppendChild(xZone);
                xZone.SetAttribute("vertex", "1");

                // zone type
                string zoneType = ChildValue(zone, "c:type");
                if (zoneType == null)
                {
                    zoneType = "Other";
                }

                if (zoneType.ToLower() == "externaldmz")
                {
                    // add space for readability
                    zoneType = "External DMZ";
                }
                xObject.SetAttribute("ZoneType", zoneType);
                xObject.SetAttribute("zone", "1");

                // zone colors
                GetZoneColors(zoneType, out string zoneColor, out string zoneHeaderColor);
                xZone.SetAttribute("style", "swimlane;zone=1;fillColor=" + zoneHeaderColor + ";swimlaneFillColor=" + zoneColor + ";");


                // determine the parent layer
                var layerName = ChildValue(zone, "c:layername");
                var newLayerID = xDrawio.SelectSingleNode(string.Format("//mxCell[@value='{0}']", layerName)).Attributes["id"].InnerText;
                xZone.SetAttribute("parent", newLayerID);


                // geometry
                var xGeometry = xDrawio.CreateElement("mxGeometry");
                xZone.AppendChild(xGeometry);
                xGeometry.SetAttribute("as", "geometry");
                string v = ChildValue(zone, "c:rect/c:width");
                xGeometry.SetAttribute("width", v);
                v = ChildValue(zone, "c:rect/c:height");
                xGeometry.SetAttribute("height", v);
                v = ChildValue(zone, "c:rect/c:x");
                xGeometry.SetAttribute("x", v);
                v = ChildValue(zone, "c:rect/c:y");
                xGeometry.SetAttribute("y", v);
            }
        }


        /// <summary>
        /// Determines the zone colors for the zone type.
        /// </summary>
        /// <param name="zoneType"></param>
        /// <returns></returns>
        private void GetZoneColors(string zoneType, out string color, out string headerColor)
        {
            headerColor = "#ece4d7";
            color = "#f6f3ed";

            switch (zoneType.ToLower())
            {
                case "control dmz":
                    headerColor = "#ffe7e9";
                    color = "#fff1f2";
                    break;
                case "corporate":
                    headerColor = "#fdf9d9";
                    color = "#fffef4";
                    break;
                case "other":
                    headerColor = "#ece4d7";
                    color = "#f6f3ed";
                    break;
                case "safety":
                    headerColor = "#f6d06b";
                    color = "#ffe7a5";
                    break;
                case "external dmz":
                    headerColor = "#d3f1df";
                    color = "#ebf4ef";
                    break;
                case "plant system":
                    headerColor = "#e6dbee";
                    color = "#f2edf6";
                    break;
                case "control system":
                    headerColor = "#f6d06b";
                    color = "#f2f8f9";
                    break;
                case "classified":
                    headerColor = "#99cfff";
                    color = "#cce5ff";
                    break;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        private void BuildMSCs()
        {
            XmlNodeList mscList = xCsetd.SelectNodes("//c:multiServiceComponent", nsmgr);
            foreach (XmlNode msc in mscList)
            {
                string oldID = ChildValue(msc, "c:id");
                string newID = GetID(oldID);


                var xObject = xDrawio.CreateElement("object");
                xRoot.AppendChild(xObject);
                xObject.SetAttribute("id", newID);
                xObject.SetAttribute("label", ChildValue(msc, "c:label/c:label"));
                xObject.SetAttribute("ComponentGuid", Guid.NewGuid().ToString());
                var xZone = xDrawio.CreateElement("mxCell");
                xObject.AppendChild(xZone);
                xZone.SetAttribute("vertex", "1");

                xZone.SetAttribute("style", "swimlane;msc=1;fillColor=#FFF;swimlaneFillColor=#FFF;");


                // determine the parent layer
                var layerName = ChildValue(msc, "c:layername");
                var newLayerID = xDrawio.SelectSingleNode(string.Format("//mxCell[@value='{0}']", layerName)).Attributes["id"].InnerText;
                xZone.SetAttribute("parent", newLayerID);


                // geometry
                var xGeometry = xDrawio.CreateElement("mxGeometry");
                xZone.AppendChild(xGeometry);
                xGeometry.SetAttribute("as", "geometry");
                string v = ChildValue(msc, "c:position/c:width");
                xGeometry.SetAttribute("width", v);
                v = ChildValue(msc, "c:position/c:height");
                xGeometry.SetAttribute("height", v);
                v = ChildValue(msc, "c:position/c:x");
                xGeometry.SetAttribute("x", v);
                v = ChildValue(msc, "c:position/c:y");
                xGeometry.SetAttribute("y", v);
            }
        }


        /// <summary>
        /// 
        /// </summary>
        private void BuildComponents()
        {
            // find all components, including those inside MSCs
            XmlNodeList componentList = xCsetd.SelectNodes("//c:component | //c:multiServiceComponent/c:components", nsmgr);

            foreach (XmlNode component in componentList)
            {
                var componentXml = (XmlElement)component;
                // map the IDs
                string oldID = ChildValue(component, "c:id");
                string newID = GetID(oldID);


                var xObject = xDrawio.CreateElement("UserObject"); // v21.0.2 uses 'UserObject' instead of 'object'
                xRoot.AppendChild(xObject);
                xObject.SetAttribute("id", newID);
                xObject.SetAttribute("label", ChildValue(component, "c:label/c:label"));
                xObject.SetAttribute("ComponentGuid", Guid.NewGuid().ToString());
                xObject.SetAttribute("HasUniqueQuestions", componentXml.GetAttribute("hasuniquequestions"));
                xObject.SetAttribute("IPAddress", ((XmlElement)component).HasAttribute("ipaddress") ? componentXml.GetAttribute("ipaddress") : string.Empty);
                xObject.SetAttribute("Description", ((XmlElement)component).HasAttribute("description") ? componentXml.GetAttribute("description") : string.Empty);
                xObject.SetAttribute("Criticality", ((XmlElement)component).HasAttribute("criticality") ? componentXml.GetAttribute("criticality") : string.Empty);
                xObject.SetAttribute("HostName", ((XmlElement)component).HasAttribute("hostname") ? componentXml.GetAttribute("hostname") : string.Empty);


                var xComponent = xDrawio.CreateElement("mxCell");
                xObject.AppendChild(xComponent);
                xComponent.SetAttribute("vertex", "1");


                // style
                var myStyle = "whiteSpace=wrap;html=1;";
                var assetName = ChildValue(component, "c:assetname");
                myStyle += GetImagePath(assetName);

                var rotateAngle = ChildValue(component, "c:rotateangle");
                if (rotateAngle != "0")
                {
                    myStyle += "rotation=" + rotateAngle + ";";
                }
                xComponent.SetAttribute("style", myStyle);



                // determine the parent layer
                var layerName = ChildValue(component, "c:layername");
                var newLayerID = xDrawio.SelectSingleNode(string.Format("//mxCell[@value='{0}']", layerName)).Attributes["id"].InnerText;
                xComponent.SetAttribute("parent", newLayerID);


                // geometry
                var xGeometry = xDrawio.CreateElement("mxGeometry");
                xComponent.AppendChild(xGeometry);
                xGeometry.SetAttribute("as", "geometry");


                int.TryParse(ChildValue(component, "c:width"), out int width);
                int.TryParse(ChildValue(component, "c:height"), out int height);

                COMPONENT_SYMBOLS symbol;
                if (legacyNames.TryGetValue(assetName, out symbol))
                {
                    width = symbol.Width;
                    height = symbol.Height;
                }

                // Prevent any 0 pixel dimensions just in case
                width = (width > 0) ? width : 60;
                height = (height > 0) ? height : 60;

                xGeometry.SetAttribute("width", width.ToString());
                xGeometry.SetAttribute("height", height.ToString());


                string x = ChildValue(component, "c:position/c:x");
                xGeometry.SetAttribute("x", x);
                string y = ChildValue(component, "c:position/c:y");
                xGeometry.SetAttribute("y", y);
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="xRoot"></param>
        private void BuildShapes()
        {
            // build the shape map
            Dictionary<string, string> mapShapes = new Dictionary<string, string>
            {
                { "pentagon", "mxgraph.basic.pentagon" },
                { "ellipse", "ellipse" },
                { "hexagon", "hexagon" },
                { "octagon", "mxgraph.basic.octagon" },
                { "plus", "cross;size=.4" },
                { "rectangle", "rectangle" },
                { "righttriangle", "mxgraph.basic.orthogonal_triangle" },
                { "roundedrectangle", "rectangle;rounded=1;arcSize=20" },
                { "star", "mxgraph.basic.star" },
                { "triangle", "mxgraph.basic.acute_triangle;dx=.5" }
            };


            XmlNodeList shapeList = xCsetd.SelectNodes("//c:shape", nsmgr);
            foreach (XmlNode shape in shapeList)
            {
                // map the IDs
                string oldID = ChildValue(shape, "c:id");
                string newID = GetID(oldID);

                var xShape = xDrawio.CreateElement("mxCell");
                xRoot.AppendChild(xShape);
                xShape.SetAttribute("id", newID);
                xShape.SetAttribute("vertex", "1");
                xShape.SetAttribute("value", ChildValue(shape, "c:label/c:label"));


                // style
                var myStyle = "rounded=0;whiteSpace=wrap;html=1;shape=" + mapShapes[ChildValue(shape, "c:shapename").ToLower()] + ";";

                var rotateAngle = ChildValue(shape, "c:rotateangle");
                if (rotateAngle != "0")
                {
                    myStyle += "rotation=" + rotateAngle + ";";
                }

                var hex = GetColor(shape, "c:color");
                myStyle += "fillColor=#" + hex + ";";

                xShape.SetAttribute("style", myStyle);


                // determine the parent layer
                var layerName = ChildValue(shape, "c:layername");
                var newLayerID = xDrawio.SelectSingleNode(string.Format("//mxCell[@value='{0}']", layerName)).Attributes["id"].InnerText;
                xShape.SetAttribute("parent", newLayerID);

                // geometry
                var xGeometry = xDrawio.CreateElement("mxGeometry");
                xShape.AppendChild(xGeometry);
                xGeometry.SetAttribute("as", "geometry");
                string v = ChildValue(shape, "c:size/c:width");
                xGeometry.SetAttribute("width", v);
                v = ChildValue(shape, "c:size/c:height");
                xGeometry.SetAttribute("height", v);
                v = ChildValue(shape, "c:size/c:x");
                xGeometry.SetAttribute("x", v);
                v = ChildValue(shape, "c:size/c:y");
                xGeometry.SetAttribute("y", v);
            }
        }


        /// <summary>
        /// 
        /// </summary>
        private void AssignToMSCs()
        {
            XmlNodeList mscList = xCsetd.SelectNodes("//c:multiServiceComponent", nsmgr);
            foreach (XmlNode msc in mscList)
            {
                var newMscID = GetID(ChildValue(msc, "c:id"));


                XmlNodeList childList = msc.SelectNodes("c:components", nsmgr);
                foreach (XmlNode child in childList)
                {
                    var oldObjectID = ChildValue(child, "c:id");
                    var newObjectID = GetID(oldObjectID);


                    // get the MSC's geometry
                    var xZoneGeometry = (XmlElement)xDrawio.SelectSingleNode("//*[@id='" + newMscID + "']//mxGeometry");


                    // set the parent MSC on the object and its mxCell child
                    XmlElement xNewObject = (XmlElement)xDrawio.SelectSingleNode("//object[@id=" + newObjectID + "]");
                    if (xNewObject == null)
                    {
                        // couldn't find an object wrapper -- look for the mxCell directly
                        xNewObject = (XmlElement)xDrawio.SelectSingleNode("//mxCell[@id=" + newObjectID + "]");
                    }
                    xNewObject.SetAttribute("parent", newMscID);
                    ((XmlElement)xNewObject.FirstChild).SetAttribute("parent", newMscID);
                    var xObjGeometry = (XmlElement)xNewObject.SelectSingleNode(".//mxGeometry");


                    // adjust the child object coordinates to be relative to their parent MSC
                    var zoneX = float.Parse(xZoneGeometry.Attributes["x"].InnerText);
                    var objX = float.Parse(xObjGeometry.Attributes["x"].InnerText);
                    var zoneY = float.Parse(xZoneGeometry.Attributes["y"].InnerText);
                    var objY = float.Parse(xObjGeometry.Attributes["y"].InnerText);
                    xObjGeometry.SetAttribute("x", (objX - zoneX).ToString());
                    xObjGeometry.SetAttribute("y", (objY - zoneY).ToString());
                }
            }
        }


        /// <summary>
        /// Now that we have all zones, components and shapes defined, assign any
        /// objects that are children of a Zone to their parent.
        /// </summary>
        /// <param name="xRoot"></param>
        private void AssignToZones()
        {
            XmlNodeList zoneList = xCsetd.SelectNodes("//c:zone", nsmgr);
            foreach (XmlNode zone in zoneList)
            {
                var newZoneID = GetID(ChildValue(zone, "c:id"));


                XmlNodeList childList = zone.SelectNodes("c:objects/c:objects", nsmgr);
                foreach (XmlNode child in childList)
                {
                    var oldObjectID = ChildValue(child, "c:id");
                    var newObjectID = GetID(oldObjectID);


                    // get the zone's geometry
                    var xZoneGeometry = (XmlElement)xDrawio.SelectSingleNode("//*[@id='" + newZoneID + "']//mxGeometry");


                    // set the parent zone on the object and its mxCell child
                    XmlElement xNewObject = (XmlElement)xDrawio.SelectSingleNode("//object[@id=" + newObjectID + "]");
                    if (xNewObject == null)
                    {
                        // couldn't find an object wrapper -- look for the mxCell directly
                        xNewObject = (XmlElement)xDrawio.SelectSingleNode("//mxCell[@id=" + newObjectID + "]");
                    }
                    xNewObject.SetAttribute("parent", newZoneID);
                    ((XmlElement)xNewObject.FirstChild).SetAttribute("parent", newZoneID);
                    var xObjGeometry = (XmlElement)xNewObject.SelectSingleNode(".//mxGeometry");


                    // adjust the child object coordinates to be relative to their parent zone
                    var zoneX = float.Parse(xZoneGeometry.Attributes["x"].InnerText);
                    var objX = float.Parse(xObjGeometry.Attributes["x"].InnerText);
                    var zoneY = float.Parse(xZoneGeometry.Attributes["y"].InnerText);
                    var objY = float.Parse(xObjGeometry.Attributes["y"].InnerText);
                    xObjGeometry.SetAttribute("x", (objX - zoneX).ToString());
                    xObjGeometry.SetAttribute("y", (objY - zoneY).ToString());
                }
            }
        }


        /// <summary>
        /// TODO:  
        ///  - Watch for edges that don't have a component on both ends.  Don't assume the existence nodeId1 or nodeId2.
        ///  - For those, look at headpoint and tailpoint coordinates.
        ///  - Arrow head styles, color, thickness, etc.
        /// </summary>
        /// <param name="xRoot"></param>
        private void BuildEdges()
        {
            XmlNodeList edgeList = xCsetd.SelectNodes("//c:link", nsmgr);
            foreach (XmlNode edge in edgeList)
            {
                // map the IDs
                string oldID = ChildValue(edge, "c:id");
                string newID = GetID(oldID);

                var xEdge = xDrawio.CreateElement("mxCell");
                xRoot.AppendChild(xEdge);
                xEdge.SetAttribute("id", newID);
                xEdge.SetAttribute("edge", "1");


                // style
                var styleString = "rounded=0;orthogonalLoop=1;jettySize=auto;html=1;";
                var hex = GetColor(edge, "c:linecolor");
                styleString += "strokeColor=#" + hex + ";";

                // always seems to be exported as '1', regardless of width in 8.1
                var lineThickness = ChildValue(edge, "c:linethickness");
                if (lineThickness == "2")
                {
                    lineThickness = "1";
                }
                styleString += "strokeWidth=" + ((lineThickness != null) ? lineThickness : "1") + ";";

                styleString += "endArrow=none;";

                xEdge.SetAttribute("style", styleString);


                // geometry
                var xGeometry = xDrawio.CreateElement("mxGeometry");
                xGeometry.SetAttribute("relative", "1");
                xGeometry.SetAttribute("as", "geometry");
                xEdge.AppendChild(xGeometry);


                // Hook up/position the ends.  Note that CSET 8.1 may not export correct coordinates for unattached ends.
                var tailObjectID = ChildValue(edge, "c:nodeId1");
                if (tailObjectID != null)
                {
                    xEdge.SetAttribute("source", mapIDs[tailObjectID]);
                }
                else
                {
                    var x = ChildValue(edge, "c:tailpoint/c:x");
                    var y = ChildValue(edge, "c:tailpoint/c:y");
                    var xPoint = xDrawio.CreateElement("mxPoint");
                    xPoint.SetAttribute("as", "sourcePoint");
                    xPoint.SetAttribute("x", x);
                    xPoint.SetAttribute("y", y);
                    xGeometry.AppendChild(xPoint);
                }

                var headObjectID = ChildValue(edge, "c:nodeId2");
                if (headObjectID != null)
                {
                    xEdge.SetAttribute("target", mapIDs[headObjectID]);
                }
                else
                {
                    var x = ChildValue(edge, "c:headpoint/c:x");
                    var y = ChildValue(edge, "c:headpoint/c:y");
                    var xPoint = xDrawio.CreateElement("mxPoint");
                    xPoint.SetAttribute("as", "targetPoint");
                    xPoint.SetAttribute("x", x);
                    xPoint.SetAttribute("y", y);
                    xGeometry.AppendChild(xPoint);
                }


                // determine the parent layer
                var layerName = ChildValue(edge, "c:layername");
                var newLayerID = xDrawio.SelectSingleNode(string.Format("//mxCell[@value='{0}']", layerName)).Attributes["id"].InnerText;
                xEdge.SetAttribute("parent", newLayerID);

                // However ... if both ends' vertices have the same parent, then our edge should have that parent.
                // This assigns the edge to a zone that both vertices share.
                try
                {
                    var mySource = xRoot.SelectSingleNode("//*[@id=" + xEdge.Attributes["source"].InnerText + "]");
                    var myTarget = xRoot.SelectSingleNode("//*[@id=" + xEdge.Attributes["target"].InnerText + "]");

                    if (mySource.ChildNodes[0].Attributes["parent"].InnerText == myTarget.ChildNodes[0].Attributes["parent"].InnerText)
                    {
                        xEdge.SetAttribute("parent", mySource.ChildNodes[0].Attributes["parent"].InnerText);
                    }
                }
                catch (Exception exc)
                {
                    NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                    // leave the edge alone
                }
            }
        }


        /// <summary>
        /// Build a dictionary to quickly determine the filename
        /// for an imported component, based on its name.
        /// </summary>
        private void InitializeSymbolFilenames()
        {
            symbols = _context.COMPONENT_SYMBOLS.ToList();
            legacyNames = (from a in _context.COMPONENT_NAMES_LEGACY
                           join b in _context.COMPONENT_SYMBOLS on a.Component_Symbol_id equals
                           b.Component_Symbol_Id
                           select new { a, b }).ToDictionary(x => x.a.Old_Symbol_Name, x => x.b);
        }


        /// <summary>
        /// Returns a string describing the style (image file path) 
        /// for the component type / asset name.
        /// </summary>
        /// <param name="assetName"></param>
        /// <returns></returns>
        private string GetImagePath(string assetName)
        {
            COMPONENT_SYMBOLS symbol;
            if (legacyNames.TryGetValue(assetName, out symbol))
            {
                return string.Format("image;image=img/cset/{0};", symbol.File_Name);
            }
            else
            {
                throw new ApplicationException("could not find component symbol for" + assetName);
            }

        }


        /// <summary>
        /// Gets the RBG values from child nodes and constructs a hex value.
        /// </summary>
        /// <param name="xNode"></param>
        /// <param name="xPath"></param>
        /// <returns></returns>
        private string GetColor(XmlNode xNode, string xPath)
        {
            var r = int.Parse(ChildValue(xNode, xPath + "/c:red"));
            var g = int.Parse(ChildValue(xNode, xPath + "/c:green"));
            var b = int.Parse(ChildValue(xNode, xPath + "/c:blue"));
            Color myColor = Color.FromArgb(r, g, b);
            return myColor.R.ToString("X2") + myColor.G.ToString("X2") + myColor.B.ToString("X2");
        }


        /// <summary>
        /// Retrieves the value in a child node.
        /// </summary>
        /// <param name="xNode"></param>
        /// <param name="xPath"></param>
        /// <returns></returns>
        private string ChildValue(XmlNode xNode, string xPath)
        {
            var x = xNode.SelectSingleNode(xPath, nsmgr);
            if (x != null)
            {
                return x.InnerText;
            }

            return null;
        }


        /// <summary>
        /// Returns a unique integer ID as a string.  
        /// If an "old ID" is provided (like a GUID from the CSETD) the new ID is mapped to the GUID.  
        /// Supplying an already-mapped GUID will return the new int ID as a string.
        /// </summary>
        /// <returns></returns>
        private string GetID(string oldID)
        {
            // special case - nothing to map to, we just need an ID
            if (oldID == "")
            {
                return (++nextID).ToString();
            }

            // If the ID is already mapped, return it
            if (mapIDs.ContainsKey(oldID))
            {
                return mapIDs[oldID];
            }

            // Create and map a new ID
            var newID = (++nextID).ToString();
            mapIDs.Add(oldID, newID);

            return newID;
        }


        /// <summary>
        /// Adjusts the height or width a bit to shrink the component.
        /// </summary>
        /// <param name="v"></param>
        /// <returns></returns>
        private string ConvertObjSize(string v)
        {
            return Math.Round(float.Parse(v) * .83333, 0).ToString();
        }
    }
}
