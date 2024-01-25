//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using CSETWebCore.Enum;

namespace CSETWebCore.Model.Edm
{
    public abstract class ScoringNode
    {
        public ScoringNode()
        {
            this.Children = new List<ScoringNode>();
            this.ColorStatus = ScoreStatus.None;
            this.totalCount = 0;
        }

        public ScoreStatus ColorStatus { get; set; }
        public double Score { get; set; }
        public int totalCount { get; set; }
        public int PercentageTotalCount { get; set; }
        public int PercentageCountRight { get; set; }
        public double PercentageScore { get; set; }
        public abstract ScoreStatus CalculateScoreStatus(List<EDMscore> scores);
        public abstract double CalculatePartialScore();
        public abstract int CalculatePercentageScore();

        public ScoreStatus basicScore(List<EDMscore> scores)
        {
            bool yellow = false;
            bool green = false;
            bool red = false;
            foreach (ScoringNode n in this.Children)
            {
                switch (n.CalculateScoreStatus(scores))
                {
                    case ScoreStatus.Green:
                        green = true;
                        break;
                    case ScoreStatus.Yellow:
                        yellow = true;
                        break;
                    case ScoreStatus.Red:
                        red = true;
                        break;
                }
            }

            ScoreStatus temp = ScoreStatus.None;
            //its all red
            if (!green && !yellow)
            {
                temp = ScoreStatus.Red;
            }
            //all green 
            else if (green && (!red && !yellow))
            {
                temp = ScoreStatus.Green;
            }
            // there is some kind of mix
            else
                temp = ScoreStatus.Yellow;

            return temp;
        }

        public int Grouping_Id { get; set; }
        public List<ScoringNode> Children { get; set; }

        public string Title_Id { get; set; }
        public string Description { get; set; }
    }
}