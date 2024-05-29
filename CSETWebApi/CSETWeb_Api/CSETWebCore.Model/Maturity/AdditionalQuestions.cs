using CSETWebCore.DataLayer.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Maturity
{
    public class AdditionalQuestionDefinition
    {
        public MATURITY_QUESTIONS Question { get; set; }
        public MQ_BONUS MqAppend { get; set; }
    }
}
