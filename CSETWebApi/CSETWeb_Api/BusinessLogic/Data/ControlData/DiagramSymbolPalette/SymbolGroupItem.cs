//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.ObjectModel;

namespace CSET_Main.Data.ControlData.DiagramSymbolPalette
{
    public class SymbolGroupItem<T>:BaseSymbolGroupItem
    {
      
        public IList<T> RelatedItems { get; set; }

       


        public SymbolGroupItem()
        {
            this.SymbolColumnCount = 1;
            RelatedItems = new ObservableCollection<T>();
        }


    }
}


