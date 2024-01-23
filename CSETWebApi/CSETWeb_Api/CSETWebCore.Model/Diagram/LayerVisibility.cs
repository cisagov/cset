//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Diagram
{
    public class LayerVisibility
    {
        public string layerName { get; set; }
        public string visible { get; set; }

        public string Parent_DrawIo_id { get; set; }
        public string DrawIo_id { get; set; }
        public int Container_Id { get; set; }
    }
}