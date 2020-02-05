//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace CSET_Main.Data.ControlData.DiagramSymbolPalette
{
    public interface IComponentSettings
    {
        int NodeType { get;  }
        string Symbol_Name { get; }
    }
}


