//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace ExportCSV
{
    internal class MaturityExport
    {
        public static string[] Headings = new string[] {"Mat_Question_Id",
        "Question_Title",
        "Question_Text",
        "Supplemental_Info",
        "Maturity_Level",
        "Sequence",
        "Maturity_Model_Id",
        "Parent_Question_Id",
        "Examination_Approach",
        "Title1",
        "Title2",
        "Title3",
        "Answer_Text",
        "Mark_For_Review",
        "Reviewed",
        "Comment",
        "Alternate_Justification",
        "Answer_Id"};

        public static string[] HeadingsOther = new string[] {"Mat_Question_Id",
        "Question_Title",
        "Question_Text",
        "Supplemental_Info",
        "Maturity_Level",
        "Sequence",
        "Maturity_Model_Id",
        "Parent_Question_Id",
        "Examination_Approach",
        "Title"
       };

        public int Mat_Question_Id { get; internal set; }
        public string Question_Title { get; internal set; }
        public string Question_Text { get; internal set; }
        public string Supplemental_Info { get; internal set; }
        public int Maturity_Level { get; internal set; }
        public int Sequence { get; internal set; }        
        public int Maturity_Model_Id { get; internal set; }
        public int? Parent_Question_Id { get; internal set; }
        public string Examination_Approach { get; internal set; }
        public string Title1 { get; internal set; }
        public string Title2 { get; internal set; }
        public string Title3 { get; internal set; }
        public string Answer_Text { get; internal set; }
        public bool? Mark_For_Review { get; internal set; }
        public bool Reviewed { get; internal set; }
        public string Comment { get; internal set; }
        public string Alternate_Justification { get; internal set; }
        public int Answer_Id { get; internal set; }
        public string Title { get; internal set; }
    }
}