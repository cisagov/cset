//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using System;
using System.Collections.Generic;
using System.Windows;


namespace CSET_Main.Data.ControlData.DiagramSymbolPalette
{
    public interface ISymbolRepository
    {
        List<VisioCSETTypeInfo> VisioDiagramTypes { get; }
        SymbolGroupItem<SymbolShapeItem> ShapeGroup { get; }
        SymbolGroupItem<SymbolZoneItem> ZoneGroup { get; }
        
        IEnumerable<SymbolGroupItem<SymbolComponentItem>> ComponentGroups { get; }
        List<SymbolComponentData> ServiceTypes { get;  }
        List<SymbolComponentData> NodeTypes { get; }
   

        String GetCSET4NodeType(String assetType);
        String GetCSET5NodeType(String assetType);

        VisioCSETTypeInfo VisioLookupCSETType(String visioName);
        SymbolComponentData GetComponentTypeData(String componentTypeXML);

        Dictionary<String, SymbolComponentInfoData> GetComponentInfoTabData();
       
    }
}


