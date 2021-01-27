using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.Models
{
    public class MaturityModel
    {
        public int ModelId { get; set; }
        public string ModelName { get; set; }
        public int MaturityTargetLevel { get; set; }
        public string QuestionsAlias { get; set; }
    }
}
