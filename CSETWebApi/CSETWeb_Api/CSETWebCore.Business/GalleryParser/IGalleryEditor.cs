//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using System;
using System.Collections.Generic;

namespace CSETWebCore.Business.GalleryParser
{
    public interface IGalleryEditor
    {
        List<string> GetLayout();
        void CloneGalleryItem(Guid item_To_Clone, int group_Id, bool new_Id);
        void AddGalleryItem(string newIcon_File_Name_Small, string newIcon_File_Name_Large, string newDescription, string newTitle, string newConfigSetup, int group_id, int columnId);
        void DeleteGalleryItem(Guid id, int group_id);
        void DeleteGalleryGroup(int id, string layout);
        int AddGalleryGroup(string group_title, string layout);
        int AddCustomGalleryGroup(string group, string layout);
        GalleryItem[] GetUnused(string layout_Name);
        void CloneGalleryGroup(int group_Id, string layout_Name);
        List<GalleryLayout> GetLayouts();
        void UpdateItem(GALLERY_ITEM item);
        void RenumberGroup(List<GALLERY_GROUP_DETAILS> detailsList);
        void RenumberGroup(List<GALLERY_ROWS> rows);
        void UpdatePosition(MoveItem moveItem);
    }
}