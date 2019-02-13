//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using DataLayerCore.Model;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Markup;

namespace CSET_Main.Data.ControlData.DiagramSymbolPalette
{
    public class SymbolRepository
	{
        //      public List<VisioCSETTypeInfo> VisioDiagramTypes { get; private set; }
        //      public SymbolGroupItem<SymbolShapeItem> ShapeGroup { get; private set; }
        //      public SymbolGroupItem<SymbolZoneItem> ZoneGroup { get; private set; }
        //      public IEnumerable<SymbolGroupItem<SymbolComponentItem>> ComponentGroups { get { return dictionaryComponentGroups.Values; } }
        public List<SymbolComponentData> ServiceTypes { get; private set; }
        public List<SymbolComponentData> NodeTypes { get; private set; }

        //private String unknownComponentName = "Unknown";
        //      private HashSet<String> setComponentTypes = new HashSet<String>();
        //private Dictionary<String, String> dictionaryCSET4ToCSET5ComponentNames = new Dictionary<string, string>() { { "EWS", "Engineering Workstation" }, { "Wireless", "Wireless Network" } };
        private Dictionary<String, SymbolComponentData> dictionarySymbolComponentData = new Dictionary<string, SymbolComponentData>();
        //      private Dictionary<String, VisioCSETTypeInfo> dictionaryVisioLookupCSETType = new Dictionary<string, VisioCSETTypeInfo>(StringComparer.OrdinalIgnoreCase);
        //private Dictionary<CommonShapeType, String> dictionaryTypeToShapeName  = new Dictionary<CommonShapeType, string>();
        //private Dictionary<String, CommonShapeType> dictionaryShapeData = new Dictionary<string, CommonShapeType>();    
        //      private Dictionary<CommonShapeType, String> shapeToVisioStencil = new Dictionary<CommonShapeType, string>();      
        //      private Dictionary<String, SymbolGroupItem<SymbolComponentItem>> dictionaryComponentGroups =  new Dictionary<string, SymbolGroupItem<SymbolComponentItem>>();
        //private SymbolShapeItem defaultShape;
        //      private CSET_Main.Common.ICSETGlobalProperties globalProperties;

        public SymbolRepository(CsetwebContext context)
        {
            // This gets all Component Symbols or NodeTypes/Service Types from the database
            foreach (COMPONENT_SYMBOLS symbolItemData in context.COMPONENT_SYMBOLS.Include(x => x.SYMBOL_GROUPS).OrderBy(x => x.Display_Name))
            {
                // Populate the DataTemplate files (for the vectors) into a Dictionary from the Component Symbols table. 
                // TODO: Handle possible null for file name
                SymbolComponentData symbolComponentData = new SymbolComponentData(symbolItemData);

                SymbolComponentItem componentItem = new SymbolComponentItem(symbolComponentData);             
                this.dictionarySymbolComponentData[symbolComponentData.XML_Name] = symbolComponentData;


                this.NodeTypes.Add(symbolComponentData);
                if (symbolComponentData.IsService)
                {
                    this.ServiceTypes.Add(symbolComponentData);
                }
            }         
        }

        //      public SymbolRepository(CSET_Main.Common.ICSETGlobalProperties globalProperties)
        //      {
        //          this.globalProperties = globalProperties;
        //          this.VisioDiagramTypes = new List<VisioCSETTypeInfo>();
        //          this.NodeTypes = new List<SymbolComponentData>();
        //          this.ServiceTypes = new List<SymbolComponentData>();

        //          using (CSET_ControlDataEntities context = new CSET_ControlDataEntities())
        //          {
        //              foreach (DIAGRAM_TYPES type in context.DIAGRAM_TYPES.Include(x => x.VISIO_MAPPING).Include(x => x.DIAGRAM_OBJECT_TYPES).OrderBy(x => x.Specific_Type))
        //              {
        //                  VisioCSETTypeInfo typeInfo = new VisioCSETTypeInfo(type);
        //			if (typeInfo.CSETXMLComponentType != Constants.MULTIPLESERVICESCOMPONENT_TYPE)
        //			{
        //                      this.VisioDiagramTypes.Add(typeInfo);
        //			}

        //                  foreach (VISIO_MAPPING visioMapping in type.VISIO_MAPPING)
        //                  {
        //                      dictionaryVisioLookupCSETType[visioMapping.Stencil_Name] = typeInfo;
        //                  }
        //              }

        //              //Create all the unique SymbolPaletteGroups
        //              foreach (SYMBOL_GROUPS group_data in context.SYMBOL_GROUPS)
        //              {
        //                  SymbolGroupItem<SymbolComponentItem> group = new SymbolGroupItem<SymbolComponentItem>()
        //                  {
        //                      Name = group_data.Symbol_Group_Name,
        //                      Title = group_data.Symbol_Group_Title	
        //                  };
        //                  group.IsExpanded = true;
        //                  dictionaryComponentGroups[group.Name] = group;
        //                  dictionaryComponentGroups[group_data.Symbol_Group_Name ?? "ICSComponent"].RelatedItems = new List<SymbolComponentItem>(dictionaryComponentGroups[group_data.Symbol_Group_Name ?? "ICSComponent"].RelatedItems.OrderBy(x => x.DisplayName));
        //              }

        //              // This gets all Component Symbols or NodeTypes/Service Types from the database
        //              foreach (COMPONENT_SYMBOLS symbolItemData in context.COMPONENT_SYMBOLS.Include(x => x.SYMBOL_GROUPS).OrderBy(x => x.Display_Name))
        //              {
        //                  // Populate the DataTemplate files (for the vectors) into a Dictionary from the Component Symbols table. 
        //                  // TODO: Handle possible null for file name
        //                  DataTemplate diagramtemplate = this.GetDataTemplateForComponentFile("NetworkComponents",symbolItemData.File_Name);
        //                  DataTemplate symbolPaletteTemplate = this.GetDataTemplateForComponentFile("NetworkComponentsSymbolPalette", symbolItemData.File_Name);
        //                  if (diagramtemplate != null && symbolPaletteTemplate !=null)
        //                  {
        //                      SymbolComponentData symbolComponentData = new SymbolComponentData(symbolItemData, diagramtemplate, symbolPaletteTemplate);

        //                      SymbolComponentItem componentItem = new SymbolComponentItem(symbolComponentData);
        //                      setComponentTypes.Add(symbolComponentData.XML_Name);
        //                      dictionaryComponentGroups[symbolItemData.SYMBOL_GROUPS.Symbol_Group_Name].RelatedItems.Add(componentItem);
        //                      this.dictionarySymbolComponentData[symbolComponentData.XML_Name] = symbolComponentData;


        //                      this.NodeTypes.Add(symbolComponentData);
        //                      if (symbolComponentData.IsService)
        //                      {
        //                          this.ServiceTypes.Add(symbolComponentData);
        //                      }
        //                  }
        //              }



        //              ShapeGroup = new SymbolGroupItem<SymbolShapeItem>() { Title = "Shapes" };
        //              try {
        //                  foreach (SHAPE_TYPES shapeData in context.SHAPE_TYPES)
        //                  {
        //                      SymbolShapeItem shape = new SymbolShapeItem(shapeData);
        //                      if (shape.IsDefault)
        //                      {
        //                          this.defaultShape = shape;
        //                      }

        //                      ShapeGroup.RelatedItems.Add(shape);
        //                      dictionaryShapeData[shape.ShapeName] = shape.ShapeType;
        //                      dictionaryTypeToShapeName[shape.ShapeType] = shape.ShapeName;
        //                      shapeToVisioStencil[shape.ShapeType] = shapeData.Visio_Shape_Type;
        //                  }
        //                  Debug.Assert(defaultShape != null, "Default shape is not set.");
        //              }catch(Exception e)
        //              {
        //                  String t =  e.Message;
        //              }
        //          }

        //          String zoneName = "Zone";
        //          ZoneGroup = new SymbolGroupItem<SymbolZoneItem>() { Title = zoneName };
        //          SymbolZoneItem zoneItem = new SymbolZoneItem() { Title = zoneName };
        //          ZoneGroup.RelatedItems.Add(zoneItem);
        //      }




        ///// <summary>
        ///// TODO: Loading from file doesn't work when installing. Change to load as resources instead!!!!!!!!!!!!!!!!!!!!!!!
        ///// </summary>
        ///// <param name="fileName"></param>
        ///// <returns></returns>
        //private DataTemplate GetDataTemplateForComponentFile(string directory, string fileName)
        //{
        //	string defaultdatatemplate = "<DataTemplate " +
        //		"    xmlns=\"http://schemas.microsoft.com/winfx/2006/xaml/presentation\"" +
        //		"    xmlns:x=\"http://schemas.microsoft.com/winfx/2006/xaml\">" +
        //		"    <Viewbox Stretch=\"Uniform\">" +
        //		"		<Canvas x:Name=\"DefaultComponentTemplate\" HorizontalAlignment=\"Left\" Height=\"256\" UseLayoutRounding=\"False\" VerticalAlignment=\"Top\" Width=\"256\">" +
        //		"            <Canvas x:Name=\"Layer_1\" Height=\"201.629\" Canvas.Left=\"56.252\" Canvas.Top=\"25.871\" Width=\"143.224\">" +
        //		"                <Path Data=\"F1M53.096,163.373L91.351,163.373 91.351,201.629 53.096,201.629z M87.812,150.167L53.096,150.167C53.005,145.176 52.96,142.135 52.96,141.045 52.96,129.792 54.82,120.533 58.541,113.272 62.263,106.012 69.706,97.843 80.869,88.766 92.033,79.691 98.704,73.745 100.883,70.931 104.24,66.485 105.92,61.584 105.92,56.227 105.92,48.787 102.946,42.409 97.003,37.099 91.057,31.79 83.047,29.135 72.973,29.135 63.261,29.135 55.139,31.905 48.603,37.44 42.068,42.977 37.576,51.418 35.125,62.762L0,58.406C0.998,42.16 7.917,28.365 20.762,17.018 33.604,5.673 50.463,0 71.34,0 93.304,0 110.775,5.741 123.755,17.222 136.733,28.705 143.224,42.068 143.224,57.316 143.224,65.758 140.841,73.745 136.075,81.278 131.311,88.813 121.122,99.067 105.512,112.046 97.433,118.764 92.418,124.163 90.467,128.247 88.516,132.332 87.63,139.639 87.812,150.167\" Fill=\"Black\" Height=\"201.629\" Canvas.Left=\"0\" Canvas.Top=\"0\" Width=\"143.224\"/>" +
        //		"            </Canvas>" +
        //		"        </Canvas>" +
        //		"    </Viewbox>" +
        //		"</DataTemplate>";

        //          try
        //          {
        //              DataTemplate template = null;
        //              string templateFile = string.Format("{0}DataTemplates\\{1}\\{2}", globalProperties.Application_Path, directory, fileName);
        //              if (File.Exists(templateFile))
        //              {
        //			// TODO: What if the file is invalid XML??
        //                  FileStream fs = new FileStream(templateFile, FileMode.Open, FileAccess.Read);
        //                  template = XamlReader.Load(fs) as DataTemplate;
        //              }
        //              else
        //              {
        //                  // convert string to stream
        //                  byte[] byteArray = Encoding.UTF8.GetBytes(defaultdatatemplate);
        //                  MemoryStream stream = new MemoryStream(byteArray);
        //                  template = XamlReader.Load(stream) as DataTemplate;
        //              }
        //              return template;
        //          }
        //          catch (Exception ex)
        //          {
        //              CSET_Main.Common.CSETLogger.Error("An error occurred when loading symbols: {0}", ex);

        //              // convert string to stream
        //              byte[] byteArray = Encoding.UTF8.GetBytes(defaultdatatemplate);
        //              MemoryStream stream = new MemoryStream(byteArray);
        //		return XamlReader.Load(stream) as DataTemplate;				
        //          }
        //}

        //      public SymbolComponentData GetComponentTypeData(String componentTypeXML)
        //      {
        //          if(componentTypeXML == null)
        //              return dictionarySymbolComponentData[unknownComponentName];

        //          SymbolComponentData data;
        //          if (!dictionarySymbolComponentData.TryGetValue(componentTypeXML, out data))
        //          {
        //              data = dictionarySymbolComponentData[unknownComponentName];
        //          }
        //          return data;
        //      }

        //public String GetCSET5NodeType(String assetType)
        //{
        //          if (setComponentTypes.Contains(assetType))
        //	{
        //		return assetType;
        //	}
        //	else
        //	{
        //		String componentType;
        //		dictionaryCSET4ToCSET5ComponentNames.TryGetValue(assetType, out componentType);
        //		if (componentType == null)
        //		{
        //			componentType = unknownComponentName;
        //		}
        //		return componentType;
        //	}
        //}

        //public String GetCSET4NodeType(String cset4Type)
        //{
        //	String nodeType = cset4Type;
        //	//Convert CSET 4.0 types to CSET 5.0 types
        //	if (dictionaryCSET4ToCSET5ComponentNames.ContainsKey(cset4Type))
        //		nodeType = dictionaryCSET4ToCSET5ComponentNames[cset4Type];

        //          if (setComponentTypes.Contains(nodeType))
        //	{
        //		return nodeType;
        //	}
        //	else
        //	{
        //		return Constants.UNKNOWN_TYPE;
        //	}
        //}

        //public CommonShapeType GetShape(String shapeName)
        //{
        //	if (shapeName == null)
        //		return defaultShape.ShapeType;
        //	if (dictionaryShapeData.ContainsKey(shapeName))
        //	{
        //		return dictionaryShapeData[shapeName];
        //	}
        //	else
        //	{
        //		Debug.Assert(false, "Can't find shape with this name: " + shapeName);
        //		return defaultShape.ShapeType;
        //	}

        //}

        //public String GetShapeString(CommonShapeType shapeType)
        //{
        //	if (dictionaryTypeToShapeName.ContainsKey(shapeType))
        //	{
        //		return dictionaryTypeToShapeName[shapeType];
        //	}
        //	else
        //	{
        //              CSET_Main.Common.CSETLogger.Error("Can't find shape with this name: " + shapeType);
        //		return defaultShape.ShapeName;
        //	}
        //}

        //      public String GetStencilShape(CommonShapeType shapeType)
        //      {
        //          String stencilName = "Rectangle";
        //          shapeToVisioStencil.TryGetValue(shapeType, out stencilName);
        //          return stencilName;
        //      }


        //public VisioCSETTypeInfo VisioLookupCSETType(String visioName)
        //{
        //	if (visioName == null)
        //		return dictionaryVisioLookupCSETType["Unknown"]; 
        //	VisioCSETTypeInfo csetType;
        //	if (dictionaryVisioLookupCSETType.TryGetValue(visioName, out csetType))
        //		return csetType;
        //	else
        //	{
        //		//The VisioName can be something like Rectangle.1.  So lookup everything before period.
        //		if (visioName.Contains("."))
        //		{
        //			int index = visioName.IndexOf(".");
        //			String visioNameSplit = visioName.Substring(0, index);
        //			if (dictionaryVisioLookupCSETType.TryGetValue(visioNameSplit, out csetType))
        //				return csetType;
        //			else
        //				return dictionaryVisioLookupCSETType["Unknown"];

        //		}
        //		else
        //			return dictionaryVisioLookupCSETType["Unknown"];
        //	}

        //}

        public Dictionary<String, SymbolComponentInfoData> GetComponentInfoTabData()
        {
            Dictionary<String, SymbolComponentInfoData> dictionaryData = new Dictionary<string, SymbolComponentInfoData>();
            foreach (SymbolComponentData data in dictionarySymbolComponentData.Values)
            {
                dictionaryData[data.XML_Name] = new SymbolComponentInfoData() { DisplayName = data.Display_Name, XMLName = data.XML_Name };
            }
            return dictionaryData;
        }
    }
}


