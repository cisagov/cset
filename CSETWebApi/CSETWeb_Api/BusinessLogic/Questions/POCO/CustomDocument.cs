//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSET_Main.Questions.POCO
{
    /// <summary>
    /// POCO object used to get data from two joined tables in the control database
    /// </summary>
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


