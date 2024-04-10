//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Org.BouncyCastle.Bcpg.OpenPgp;

namespace CSETWebCore.Model.Question
{
    /// <summary>
    /// Represents a document attached to a question.  Used to assemble
    /// lists of reference documents.
    /// </summary>
    public class GenFileView
    {
        public int File_Id { get; set; }
        public string Title { get; set; }
        public string File_Name { get; set; }
        public string Url { get; set; }
        public decimal File_Type_Id { get; set; }
        public string Section_Ref { get; set; }
        public string Destination_String { get; set; }
        public bool Is_Uploaded { get; set; }
        public int? Sequence { get; set; }

        public GenFileView()
        {
        }

        public GenFileView(int id, string title, string fileName, string url, int fileTypeId, string sectionRef, bool isUploaded)
        {
            this.File_Id = id;
            this.Title = title;
            this.File_Name = fileName;
            this.Url = url;
            this.File_Type_Id = fileTypeId;
            this.Section_Ref = sectionRef;
            this.Is_Uploaded = isUploaded;
        }
    }


    /// <summary>
    /// The 'public' structure of a linked document for a question.
    /// </summary>
    public class ReferenceDocLink
    {
        public int FileId { get; set; }
        public string FileName { get; set; }
        public string Title { get; set; }
        public string Url { get; set; }
        public string SectionRef { get; set; }
        public string DestinationString { get; set;}
    }
}