using System.Collections.Generic;

namespace CSETWebCore.Model.Diagram
{
    public class ComponentSymbolGroup
    {
        public int SymbolGroupID;
        public string GroupName;
        public string SymbolGroupTitle;
        public List<ComponentSymbol> Symbols;
    }
}