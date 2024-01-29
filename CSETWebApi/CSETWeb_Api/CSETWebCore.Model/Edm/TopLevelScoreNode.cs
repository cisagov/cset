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
    public class TopLevelScoreNode : ScoringNode
    {
        public ScoringNode TopLevelChild { get; set; }

        public override double CalculatePartialScore()
        {
            this.Score = 0;
            foreach (ScoringNode s in this.Children)
            {
                Score += s.CalculatePartialScore();
                this.totalCount += s.totalCount;
            }

            return Score;
        }

        public override int CalculatePercentageScore()
        {
            this.PercentageScore = 0;
            int totalRight = 0;
            foreach (ScoringNode s in this.Children)
            {
                totalRight += s.CalculatePercentageScore();
                this.PercentageTotalCount += s.PercentageTotalCount;
            }

            this.PercentageCountRight = totalRight;
            this.PercentageScore = (double)totalRight / (double)this.PercentageTotalCount;
            return this.PercentageCountRight;
        }

        public override ScoreStatus CalculateScoreStatus(List<EDMscore> scores)
        {
            if (this.ColorStatus != ScoreStatus.None)
                return this.ColorStatus;

            //if this is MIL 1 then it can be yellow 
            //  (Yellow if any of my children are not red)
            //else this is green if all my children are green
            //else red                
            if (this.Title_Id == "MIL1")
            {
                this.ColorStatus = basicScore(scores);
            }
            else
            {
                bool ok = false;
                ok = TopLevelChild.CalculateScoreStatus(scores) == ScoreStatus.Green;
                foreach (ScoringNode n in this.Children)
                {
                    var node = n as LeafNode;
                    var cStatus = node.CalculateScoreStatus(scores);
                    ok = ok && cStatus == ScoreStatus.Green;
                }

                this.ColorStatus = ok ? ScoreStatus.Green : ScoreStatus.Red;
            }

            scores.Add(new EDMscore() { Title_Id = this.Title_Id, Color = this.ColorStatus.ToString() });
            return this.ColorStatus;

        }
    }
}