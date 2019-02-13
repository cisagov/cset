//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Data;
using DataLayer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSET_Main.Questions.InformationTabData
{
    public class QuestionInfoData:BaseQuestionInfoData
    {       
        public Dictionary<String, SET> Sets { get; set; }
    }
}


