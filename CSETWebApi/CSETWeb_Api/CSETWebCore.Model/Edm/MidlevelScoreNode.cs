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
    public class MidlevelScoreNode : ScoringNode
    {
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
            //this one looks at all its children and 
            //return red if they are all red
            //yellow if anything is not red but not all green
            //green if they are all green
            ScoreStatus score = basicScore(scores);
            this.ColorStatus = score;
            scores.Add(new EDMscore() { Title_Id = this.Title_Id, Color = this.ColorStatus.ToString() });
            return score;
        }
    }
}