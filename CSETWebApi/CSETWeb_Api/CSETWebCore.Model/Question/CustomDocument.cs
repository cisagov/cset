namespace CSETWebCore.Model.Question
{
    public class CustomDocument
    {
        public int File_Id { get; set; }
        public string Title { get; set; }
        public string File_Name { get; set; }
        public string Section_Ref { get; set; }
        public bool Is_Uploaded { get; set; }

        public CustomDocument()
        {
        }

        public CustomDocument(int id, string title, string fileName, string sectionRef, bool isUploaded)
        {
            this.File_Id = id;
            this.Title = title;
            this.File_Name = fileName;
            this.Section_Ref = sectionRef;
            this.Is_Uploaded = isUploaded;
        }
    }
}