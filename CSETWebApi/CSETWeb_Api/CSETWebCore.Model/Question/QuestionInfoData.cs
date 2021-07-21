using System.Collections.Generic;
using CSETWebCore.DataLayer;

namespace CSETWebCore.Model.Question
{
    public class QuestionInfoData : BaseQuestionInfoData

    {
        public Dictionary<string, SETS> Sets { get; set; }
    }
}