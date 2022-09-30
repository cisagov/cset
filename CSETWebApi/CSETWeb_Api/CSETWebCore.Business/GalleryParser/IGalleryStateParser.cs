using System.Collections.Generic;

namespace CSETWebCore.Business.GalleryParser
{
    public interface IGalleryState
    {
        GalleryBoardData GetGalleryBoard(string layout_name);
        List<string> GetLayout();
        void CloneGalleryItem(GalleryItem item_To_Clone);
        List<string> AddGalleryItem(string newIcon_File_Name_Small, string newIcon_File_Name_Large, string newDescription, string newTitle, string group, int columnId);
        void DeleteGalleryItem(int id);
        void DeleteGalleryGroup(int id);
    }
}