//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSET_Main.Data.ControlData.DiagramSymbolPalette
{
    public class BaseSymbolGroupItem 
    {
        public String Name { get; set; }
        public String Title { get; set; }

        private bool isExpanded;
        public bool IsExpanded { get { return isExpanded; } set { isExpanded = value; } }

        private int symbolColumnCount;
        public int SymbolColumnCount
        {
            get { return symbolColumnCount; }
            set { symbolColumnCount = value; }
        }
    }
}


