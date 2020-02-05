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
using CSET_Main.Common.EnumHelper;
using CSET_Main.Diagram.DiagramObjects;
using CSET_Main.Diagram.DiagramObjects.Enums;
using DataLayerCore.Model;

namespace CSET_Main.Data.ControlData
{

   
    public class VisioCSETTypeInfo
    {
        public String CSETVisioDisplayName { get; set; }
        public String CSETXMLComponentType { get; set; }
        public DiagramTypeEnum DiagramShapeType { get; set; }


        public bool IsComponent 
        {
            get
            {
                if (DiagramShapeType == DiagramTypeEnum.Component)
                    return true;
                else
                    return false;
            } 
        }

        public bool IsZone
        {
            get
            {
                if (DiagramShapeType == DiagramTypeEnum.Zone)
                    return true;
                else
                    return false;
            }
        }

        public bool IsMultipleServiceComponent
        {
            get
            {
                if (DiagramShapeType == DiagramTypeEnum.MultiServicesComponent)
                    return true;
                else
                    return false;
            }
        }

        public bool IsShape
        {
            get
            {
                if (DiagramShapeType == DiagramTypeEnum.Shape)
                    return true;
                else
                    return false;
            }
        }

        public bool IsText
        {
            get
            {
                if (DiagramShapeType == DiagramTypeEnum.Text)
                    return true;
                else
                    return false;
            }
        }


        public VisioCSETTypeInfo()
        {

        }

        public VisioCSETTypeInfo(DIAGRAM_TYPES type)
        {
            this.CSETVisioDisplayName = (type.Specific_Type != null) ? type.Specific_Type.Trim() : null;
            this.CSETXMLComponentType = (type.Diagram_Type_XML != null) ? type.Diagram_Type_XML.Trim() : null;
            this.DiagramShapeType = StringToEnum.ToEnum<DiagramTypeEnum>(type.Object_Type);
        }

        public override int GetHashCode()
        {
            return CSETVisioDisplayName.GetHashCode();
        }


        /// <summary>
        ///  
        /// Overide the equals method so that binding works on combobox on VisioImportWindow.
        /// 
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public override bool Equals(Object obj)
        {
            // If parameter is null return false:
            if (obj == null || GetType() != obj.GetType())
                return false;

            VisioCSETTypeInfo type = (VisioCSETTypeInfo)obj;
            // Return true if the fields match:
            bool isEqual = (type.CSETVisioDisplayName == this.CSETVisioDisplayName);
            return isEqual;
        }

        public static bool operator ==(VisioCSETTypeInfo a, VisioCSETTypeInfo b)
        {
            // If both are null, or both are same instance, return true.
            if (System.Object.ReferenceEquals(a, b))
            {
                return true;
            }

            // If one is null, but not both, return false.
            if (((object)a == null) || ((object)b == null))
            {
                return false;
            }

            // Return true if the fields match:
            return a.CSETVisioDisplayName == b.CSETVisioDisplayName;
        }

        public static bool operator !=(VisioCSETTypeInfo a, VisioCSETTypeInfo b)
        {
            return !(a == b);
        }










      
    }
}


