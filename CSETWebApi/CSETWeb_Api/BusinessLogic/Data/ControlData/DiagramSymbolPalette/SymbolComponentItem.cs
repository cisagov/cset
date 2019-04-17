//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Helpers;
using System;

namespace CSET_Main.Data.ControlData.DiagramSymbolPalette
{
    public class SymbolComponentItem : IComponentSettings
	{
	

		#region Constructors
		public SymbolComponentItem(SymbolComponentData symbolData)
		{
			this.ComponentSymbolData = symbolData;
		}
		#endregion

		#region Properties
		public SymbolComponentData ComponentSymbolData { get; set; }

		
		//public Geometry Geometry { get; set; }
		public string ComponentTitle { get { return NodeType; } }

		public string Name { get { return ComponentSymbolData.Name; } }

		public string NodeType
		{
			get { return ComponentSymbolData.XML_Name; }
		}

        public Boolean IsLinkConnector
        {
            get
            {
                return IsComponentType(Constants.CONNECTOR_TYPE);
            }
        }

		public string Abbreviation { get { return ComponentSymbolData.Abbreviation; } }

		public string DisplayName { get { return ComponentSymbolData.Display_Name; } }
		public string LongName { get { return ComponentSymbolData.Long_Name; } }

	
		//public DataTemplate ComponentDiagramVisualTemplate
		//{
		//	get
		//	{				
  //              return ComponentSymbolData.ComponentDiagramVisualTemplate;
		//	}
		//}
      
  //      public DataTemplate SymbolPaletteComponentVisualTemplate
  //      {
  //          get
  //          {
  //              if (ComponentSymbolData != null)
  //                  return ComponentSymbolData.SymbolPaletteComponentVisualTemplate;
  //              else
  //                  return null;
  //          }
  //      }
		#endregion


        internal bool IsComponentType(string type)
        {
            return (this.NodeType == type) ? true : false;
        }
		
	}
}


