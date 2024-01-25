//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using CSETWebCore.Enum;

namespace CSETWebCore.Model.Edm
{
    public class LeafNode : ScoringNode
    {
        public String Answer { get; set; }
        public int Mat_Question_Id { get; set; }
        public ScoringNode Parent { get; set; }


        public override double CalculatePartialScore()
        {
            this.totalCount++;
            switch (Answer)
            {
                case "Y":
                    this.Score = 1;
                    return Score;
                case "N":
                case "U":
                    this.Score = 0;
                    return Score;
                default:
                    this.Score = 0.5;
                    return Score;
            }
        }

        public override int CalculatePercentageScore()
        {
            this.PercentageTotalCount++;
            switch (Answer)
            {
                case "Y":
                    this.PercentageCountRight = 1;
                    break;
                default:
                    this.PercentageCountRight = 0;
                    break;
            }

            this.PercentageScore = this.PercentageCountRight / this.PercentageTotalCount;
            return this.PercentageCountRight;
        }

        public override ScoreStatus CalculateScoreStatus(List<EDMscore> scores)
        {
            if (this.ColorStatus != ScoreStatus.None)
                return this.ColorStatus;
            //this one just returns its score color
            //RED, YELLOW, or GREEN
            ScoreStatus score = ScoreStatus.None;
            switch (Answer)
            {
                case "Y":
                    score = ScoreStatus.Green;
                    break;
                case "N":
                    score = ScoreStatus.Red;
                    break;
                case "I":
                    score = ScoreStatus.Yellow;
                    break;
                default:
                    score = ScoreStatus.Red;
                    break;
            }

            this.ColorStatus = score;
            scores.Add(new EDMscore() { Title_Id = this.Title_Id, Color = this.ColorStatus.ToString() });
            return score;
        }
    }
}