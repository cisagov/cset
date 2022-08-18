namespace CSETWebCore.Business.GalleryParser
{
    public interface IGalleryState
    {
        void ProcessParserState(int assessment_id, int gallery_item_id);
        GalleryBoardData GetGalleryBoard(string layout_name);
    }
}