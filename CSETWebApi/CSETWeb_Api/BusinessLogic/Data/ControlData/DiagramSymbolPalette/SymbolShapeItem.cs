//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using CSET_Main.Common.EnumHelper;
using CSETWeb_Api.Diagram;
using DataLayer;

namespace CSET_Main.Data.ControlData.DiagramSymbolPalette
{
    public class SymbolShapeItem
    {
        //public Geometry ShapeGeometry { get; set; }
        public bool IsDefault { get; private set; }
        public CommonShapeType ShapeType {  get; private set;    }
        public String ShapeName { get; private set; }
		public String DisplayName { get; private set; }
        public double WidthData { get; set; }
        public double HeightData { get; set; }

        private SHAPE_TYPES shapeData;

        public SymbolShapeItem(SHAPE_TYPES shapeData)
        {
            this.shapeData = shapeData;
            //this.ShapeType = shapeData.Telerik_Shape_Type.ToEnum<CommonShapeType>();
            this.ShapeName = shapeData.Diagram_Type_XML;
			this.DisplayName = shapeData.DisplayName;
            this.IsDefault = shapeData.IsDefault;
            //this.ShapeGeometry = Telerik.Windows.Controls.Diagrams.ShapeFactory.GetShapeGeometry(ShapeType);
        }



       
    }
}


