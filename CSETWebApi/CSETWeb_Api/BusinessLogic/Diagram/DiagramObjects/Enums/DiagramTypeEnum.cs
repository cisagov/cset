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

namespace CSET_Main.Diagram.DiagramObjects.Enums
{
    /// <summary>
    /// Note: If you change or add an entry to this enum then need to change it in the DIAGRAM_OBJECT_TYPES in the Control Database.
    /// Otherwise will get an exception when importing Visio Files. See VisioCSETTypeInfo constructor where an error would occur.
    /// </summary>
    public enum DiagramTypeEnum
    {
		Zone, Shape, Component, Text, MultiServicesComponent
    }
}


