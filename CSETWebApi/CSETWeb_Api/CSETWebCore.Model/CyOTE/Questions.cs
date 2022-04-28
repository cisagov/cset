using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.CyOTE
{
    public class CyoteAttackResponse
    {
        public List<string> Questions { get; set; } = new List<string>();
    }

    public class CyotePathLevel
    {
        public int Level { get; set; }
        public List<CyoteOption> Options { get; set; } = new List<CyoteOption>();
    }

    public class CyoteQuestion
    {
        public string QuestionText { get; set; }
        public int QuestionId { get; set; }

        public List<CyoteOption> Options { get; set; }
    }

    public class CyoteOption
    {
        public string OptionText { get; set; }
        public int OptionId { get; set; }
    }
}
