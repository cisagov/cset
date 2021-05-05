using System.Collections.Generic;
using CSETWebCore.DataLayer;

namespace CSETWebCore.Model.Question
{
    public class MaturityQuestionInfoData : BaseQuestionInfoData
    {
        public Dictionary<string, MATURITY_MODELS> Models { get; set; }
    }
}