namespace CSETWebCore.Business.GalleryParser
{
    public interface IGalleryStateParser
    {
        void ProcessParserState(int assessment_id, int gallery_item_id);
    }
}