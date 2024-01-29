//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Diagram
{
    public class ComponentSymbolGroup
    {
        public int SymbolGroupID { get; set; }
        public string GroupName { get; set; }
        public string SymbolGroupTitle { get; set; }
        public List<ComponentSymbol> Symbols { get; set; }
    }
}