//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
    }
}
