//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using CSETWebCore.DataLayer.Model;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Model.Diagram;

namespace CSETWebCore.Business.Diagram.layers
{
    class LayerManager
    {
        private CSETContext db;
        private int assessment_id;


        public LayerManager(CSETContext db, int assessment_id)
        {
            this.db = db;
            this.assessment_id = assessment_id;


        }

        public LayerVisibility GetLastLayer(string drawIoId)
        {

            return (from node in db.ASSESSMENT_DIAGRAM_COMPONENTS
                    join parent in db.DIAGRAM_CONTAINER on node.Layer_Id equals parent.Container_Id
                    where node.Assessment_Id == assessment_id
                    select new LayerVisibility()
                    {
                        Container_Id = parent.Container_Id,
                        layerName = parent.Name,
                        DrawIo_id = node.DrawIO_id,
                        Parent_DrawIo_id = parent.DrawIO_id,
                        visible = (parent.Visible) ? "true" : "false"

                    }).FirstOrDefault();

            /*
            return (from node in db.ASSESSMENT_DIAGRAM_COMPONENTS
                    join parent in db.DIAGRAM_CONTAINER on node.Zone_Id equals parent.Container_Id
                    where node.Assessment_Id == assessment_id && node.Parent_DrawIO_Id == drawIoId
                    select new LayerVisibility()
                    {
                        Container_Id = parent.Container_Id,
                        layerName = parent.Name,
                        DrawIo_id = node.DrawIO_id,
                        Parent_DrawIo_id = parent.DrawIO_id,
                        visible = (parent.Visible ?? true) ? "true" : "false"

                    }).FirstOrDefault();
            */
        }

        internal void UpdateAllLayersAndZones()
        {
            Dictionary<string, IDToParent> allValues = new Dictionary<string, IDToParent>();
            //select all the node and parent nodes id's into a string,string dictionary
            //once we have a unified list then walk the tree until we find something
            //missing
            var list1 = (from a in db.ASSESSMENT_DIAGRAM_COMPONENTS
                         where a.Assessment_Id == assessment_id
                         select a);
            foreach (var item in list1)
            {
                allValues[item.DrawIO_id] = new IDToParent()
                {
                    DrawIO_Id = item.DrawIO_id,
                    Parent_DrawIO_Id = item.Parent_DrawIO_Id,
                    component = item
                };
            }
            var list2 = (from b in db.DIAGRAM_CONTAINER
                         where b.Assessment_Id == assessment_id
                         select b);
            foreach (var item in list2)
            {
                allValues[item.DrawIO_id] = new IDToParent()
                {
                    DrawIO_Id = item.DrawIO_id,
                    Parent_DrawIO_Id = item.Parent_Draw_IO_Id,
                    container = item
                };
            }
            foreach (IDToParent item in allValues.Values.Where(x => x.component != null).ToList())
            {
                string drawIoId = item.Parent_DrawIO_Id;
                IDToParent lastItem = null;
                bool zoneFound = false;
                while (allValues.TryGetValue(drawIoId, out IDToParent layer))
                {
                    //if we find the zone set it
                    //else the last one must be the layer
                    if (layer.container != null && !zoneFound)
                    {
                        if (layer.container.ContainerType == "Zone")
                        {
                            item.component.Zone_Id = layer.container.Container_Id;
                            zoneFound = true;
                        }
                    }
                    lastItem = layer;
                    if (layer.Parent_DrawIO_Id == null)
                        break;
                    drawIoId = layer.Parent_DrawIO_Id;
                }
                if (lastItem != null)
                {
                    item.component.Layer_Id = lastItem.container.Container_Id;
                }
            }
        }

        private class IDToParent
        {
            public string DrawIO_Id { get; set; }
            public string Parent_DrawIO_Id { get; set; }
            public ASSESSMENT_DIAGRAM_COMPONENTS component;
            public DIAGRAM_CONTAINER container { get; set; }
        }
    }
}
