using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Maturity
{
    public class CmmcScores
    {
        public int TargetLevel { get; set; } = 0;


        public int Level1Score { get; set; }
        public int Level1MaxScore { get; set; }



        public int Level2Score { get; set; }
        public int Level2MaxScore { get; set; }

        /// <summary>
        /// Level 3 is only active if Level 1 is 100% compliant
        /// </summary>
        public bool Level2Active { get; set; } = false;



        public int Level3Score { get; set; }
        public int Level3MaxScore { get; set; }

        /// <summary>
        /// Level 3 is only active if Level 2 is 100% compliant
        /// </summary>
        public bool Level3Active { get; set; } = false;

    }
}
