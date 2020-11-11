//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using DataLayerCore.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSET_Main.Questions.InformationTabData
{
    public class BaseQuestionInfoData
    {
        public SETS Set { get; set; }
        public int QuestionID { get; set; }
        public NEW_QUESTION Question { get; set; }
        public NEW_REQUIREMENT Requirement { get; set; }
        public MATURITY_QUESTIONS MaturityQuestion { get; set; }
    }
}


