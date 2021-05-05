//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;

namespace CSET_Main.Data.ControlData.DiagramSymbolPalette
{
    public class SymbolRepository
	{
        
        public List<SymbolComponentData> ServiceTypes { get; private set; }
        public List<SymbolComponentData> NodeTypes { get; private set; }

        private Dictionary<int, SymbolComponentData> dictionarySymbolComponentData = new Dictionary<int, SymbolComponentData>();
        
        public SymbolRepository(CSET_Context context)
        {
            // This gets all Component Symbols or NodeTypes/Service Types from the database
            foreach (COMPONENT_SYMBOLS symbolItemData in context.COMPONENT_SYMBOLS.Include(x => x.Symbol_Group_).OrderBy(x => x.Symbol_Name))
            {
                // Populate the DataTemplate files (for the vectors) into a Dictionary from the Component Symbols table. 
                // TODO: Handle possible null for file name
                SymbolComponentData symbolComponentData = new SymbolComponentData(symbolItemData);

                SymbolComponentItem componentItem = new SymbolComponentItem(symbolComponentData);             
                this.dictionarySymbolComponentData[symbolComponentData.Component_Symbol_Id] = symbolComponentData;


                this.NodeTypes.Add(symbolComponentData);
                if (symbolComponentData.IsService)
                {
                    this.ServiceTypes.Add(symbolComponentData);
                }
            }         
        }

        

        public Dictionary<int, SymbolComponentInfoData> GetComponentInfoTabData()
        {
            Dictionary<int, SymbolComponentInfoData> dictionaryData = new Dictionary<int, SymbolComponentInfoData>();
            foreach (SymbolComponentData data in dictionarySymbolComponentData.Values)
            {
                dictionaryData[data.Component_Symbol_Id] = new SymbolComponentInfoData() { Symbol_Name = data.Display_Name, Component_Symbol_Id = data.Component_Symbol_Id };
            }
            return dictionaryData;
        }
    }
}


