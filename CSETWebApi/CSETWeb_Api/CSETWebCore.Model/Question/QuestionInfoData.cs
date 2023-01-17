//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Model.Question
{
    public class QuestionInfoData : BaseQuestionInfoData

    {
        public Dictionary<string, SETS> Sets { get; set; }
    }
}