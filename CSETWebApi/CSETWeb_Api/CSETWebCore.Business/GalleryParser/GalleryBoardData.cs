//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using System.Collections.Generic;
using System;

namespace CSETWebCore.Business.GalleryParser
{
    public class GalleryBoardData
    {
        public GalleryBoardData()
        {
            Rows = new List<GalleryGroup>();
        }
        public string Layout_Name { get; set; }
        public List<GalleryGroup> Rows { get; set; }
    }

    public class GalleryGroup
    {
        public GalleryGroup()
        {
            GalleryItems = new List<GalleryItem>();
        }
        public string Group_Title { get; set; }
        public List<GalleryItem> GalleryItems { get; set; }
        public int Group_Id { get; internal set; }
    }

    /// <summary>
    /// NOTE THAT THE Constructor skips the setup configuration
    /// that is reserved for when the item returns from the client.
    /// </summary>
    public class GalleryItem
    {
        public GalleryItem()
        {
        }

        public GalleryItem(GALLERY_ITEM i, int group_id)
        {
            this.Gallery_Item_Guid = i.Gallery_Item_Guid;
            this.Icon_File_Name_Small = i.Icon_File_Name_Small;
            this.Icon_File_Name_Large = i.Icon_File_Name_Large;
            this.Configuration_Setup = i.Configuration_Setup;
            this.Configuration_Setup_Client = i.Configuration_Setup_Client;
            this.Description = i.Description;
            this.Title = i.Title;
            this.Parent_Id = group_id;
            this.Is_Visible = i.Is_Visible;
        }

        public Guid? Gallery_Item_Guid { get; set; }
        public string Icon_File_Name_Small { get; set; }
        public string Icon_File_Name_Large { get; set; }
        public string Configuration_Setup { get; set; }
        public string Configuration_Setup_Client { get; set; }
        public string Description { get; set; }
        public object Title { get; set; }
        public int Parent_Id { get; private set; }
        public bool? Is_Visible { get; set; }

        /// <summary>
        /// This is populated for custom set cards built on the fly 
        /// </summary>
        public string Custom_Set_Name { get; set; }
    }

}