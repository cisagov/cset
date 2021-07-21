namespace CSETWebCore.Model.Question
{
    public class CustomDocument
    {
        public string Title { get; set; }
        public string File_Name { get; set; }
        public string Section_Ref { get; set; }
        public bool Is_Uploaded { get; set; }
        public CustomDocument()
        {
        }

        public CustomDocument(string title, string fileName, string sectionRef, bool isUploaded)
        {
            this.Title = title;
            this.File_Name = fileName;
            this.Section_Ref = sectionRef;
            this.Is_Uploaded = isUploaded;
        }
    }
}