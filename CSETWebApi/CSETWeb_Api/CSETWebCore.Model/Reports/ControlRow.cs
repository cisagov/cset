//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Reports
{
    public class ControlRow
    {
        public int Requirement_Id;
        public int Question_Id;

        public string Requirement_Text;
        public string Requirement_Title;
        public string Standard_Level;
        public string Short_Name;
        public string Standard_Category;
        public string Standard_Sub_Category;
        public string Answer_Text;
        public string Comment;
        public string Simple_Question;

        public int Answer_Id { get; set; }
    }
}
