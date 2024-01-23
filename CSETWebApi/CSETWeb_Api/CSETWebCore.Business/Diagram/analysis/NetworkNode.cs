//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Diagram.Analysis;
using System;

namespace CSETWebCore.Business
{
    public abstract class NetworkNode
    {
        public string ID { get; set; }
        //public string ComponentType { get; set; }
        public int Component_Symbol_Id { get; set; }
        public Guid ComponentGuid { get; internal set; }
        public bool IsVisible { get; internal set; }
        public string ComponentName { get; internal set; }
        public NetworkGeometry Geometry { get; internal set; }
        public string Parent_id { get; internal set; }

        /// <summary>
        /// This can be either a Layer or zone change.  Components in a zone 
        /// have a different parent then their layer.
        /// </summary>
        public bool ParentChanged { get; set; }

        public void SetValue(string name, string value)
        {
            switch (name)
            {
                case "label":
                    this.ComponentName = value;
                    break;
                case "ComponentGuid":
                    this.ComponentGuid = new Guid(value);
                    break;
                case "id":
                    this.ID = value;
                    break;
                case "zone":
                    this.Component_Symbol_Id = Constants.Constants.ZONE;// 121;
                    break;
                case "parent":
                    this.Parent_id = value;
                    break;
            }
        }
    }
}