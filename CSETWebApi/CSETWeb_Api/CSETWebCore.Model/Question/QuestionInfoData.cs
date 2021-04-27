using System.Collections.Generic;
using DataLayerCore.Model;

namespace CSETWebCore.Model.Question
{
    public class QuestionInfoData : BaseQuestionInfoData

    {
        public Dictionary<string, SETS> Sets { get; set; }
    }
}