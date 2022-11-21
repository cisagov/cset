using System.Collections.Generic;

namespace CSETWebCore.Business.GalleryParser
{
    public interface IGalleryEditor
    {
        List<string> GetLayout();
        void CloneGalleryItem(int item_To_Clone, int group_Id);
        void AddGalleryItem(string newIcon_File_Name_Small, string newIcon_File_Name_Large, string newDescription, string newTitle, int group_id, int columnId);
        void DeleteGalleryItem(int id, int group_id);
        void DeleteGalleryGroup(int id, string layout);
        int AddGalleryGroup(string group_title, string layout);
        GalleryItem[] GetUnused(string layout_Name);
        void CloneGalleryGroup(int group_Id, string layout_Name);
        List<GalleryLayout> GetLayouts();
    }
}