//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
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
		public String Abbreviation { get; set; }
		public String File_Name { get; set; }
        public string Symbol_Name { get; set; }
        public int Component_Symbol_Id { get; set; }
        public bool IsService { get; set; }

		public String Long_Name { get; set; }
		public String Display_Name { get; set; }

		
		public SymbolComponentData(COMPONENT_SYMBOLS componentSymbol) 
		{

            this.Component_Symbol_Id = componentSymbol.Component_Symbol_Id;
			this.Abbreviation = componentSymbol.Abbreviation;
			this.File_Name = componentSymbol.File_Name;
            this.Symbol_Name = componentSymbol.Symbol_Name;			
            this.IsService = componentSymbol.IsService;
		}


        internal bool IsLinkConnector()
        {
            if (this.Component_Symbol_Id == Constants.CONNECTOR_TYPE)
                return true;
            else
                return false;
        }
    }
}


