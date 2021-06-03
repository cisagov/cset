using System;

namespace CSETWebCore.Model.Set
{
    public class ReferenceDoc
    {
        public int ID;
        public string FileName;
        public string Title;
        public string Name;
        public string ShortName;
        public string DocumentNumber;
        public string DocumentVersion;
        public DateTime? PublishDate;
        public string Summary;
        public string Description;
        public string Comments;
        public string SectionRef;
        public bool IsUploaded;
        public bool Selected;

        /// <summary>
        /// To distinguish the documents whose information can be edited.
        /// </summary>
        public bool IsCustom;
    }
}