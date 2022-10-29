using System.Collections.Generic;

namespace CSETWebCore.Business.GalleryParser
{
    public interface IGalleryEditor
    {
        List<string> GetLayout();
        void CloneGalleryItem(int item_To_Clone, int group_Id);
        void AddGalleryItem(string newIcon_File_Name_Small, string newIcon_File_Name_Large, string newDescription, string newTitle, string group, int columnId);
        void DeleteGalleryItem(int id);
        void DeleteGalleryGroup(int id);
        void AddGalleryGroup(string group, string layout);
    }
}