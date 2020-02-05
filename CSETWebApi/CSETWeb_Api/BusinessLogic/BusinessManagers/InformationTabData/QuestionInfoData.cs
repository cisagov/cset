//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Data;
using DataLayerCore.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSET_Main.Questions.InformationTabData
{
    public class QuestionInfoData:BaseQuestionInfoData
    {       
        public Dictionary<String, SETS> Sets { get; set; }
    }
}


