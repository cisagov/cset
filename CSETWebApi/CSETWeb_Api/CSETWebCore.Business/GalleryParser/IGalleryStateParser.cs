using System.Collections.Generic;

namespace CSETWebCore.Business.GalleryParser
{
    public interface IGalleryState
    {
        GalleryBoardData GetGalleryBoard(string layout_name);
        List<string> GetLayout();
        GalleryBoardData CloneGalleryItem(GalleryItem item_To_Clone);
        List<string> AddGalleryItem(string newIcon_File_Name_Small, string newIcon_File_Name_Large, string newConfiguration_Setup, string newConfiguration_Setup_Client, string newDescription, string newTitle);
    }
}