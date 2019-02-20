//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Helpers;
using CSETWeb_Api.Helpers;
using DataLayerCore.Model;
using System;

namespace CSET_Main.Data.ControlData
{
    public class SymbolComponentData 
	{
		public String Name { get; set; }
		public String XML_Name { get; set; }
		public String Abbreviation { get; set; }
		public String File_Name { get; set; }
        public bool IsService { get; set; }

		public String Long_Name { get; set; }
		public String Display_Name { get; set; }

		
		public SymbolComponentData(COMPONENT_SYMBOLS componentSymbol) 
		{
			this.Name = componentSymbol.Name;
			this.XML_Name = componentSymbol.Diagram_Type_Xml;
			this.Abbreviation = componentSymbol.Abbreviation;
			this.File_Name = componentSymbol.File_Name;
            
			this.Long_Name = componentSymbol.Long_Name;
			this.Display_Name = componentSymbol.Display_Name;
            this.IsService = componentSymbol.IsService;
		}


        internal bool IsLinkConnector()
        {
            if (this.XML_Name == Constants.CONNECTOR_TYPE)
                return true;
            else
                return false;
        }
    }
}


