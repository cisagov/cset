using System.Collections.Generic;
using DataLayerCore.Model;

namespace CSETWebCore.Model.Question
{
    public class MaturityQuestionInfoData : BaseQuestionInfoData
    {
        public Dictionary<string, MATURITY_MODELS> Models { get; set; }
    }
}