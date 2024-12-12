//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;


namespace CSETWebCore.Model.Maturity
{
    public class ScorecardResponse
    {
        public int TargetLevel { get; set; } = 0;
        public List<CmmcScoreModel> LevelScorecards { get; set; } = [];
    }


    public class CmmcScoreModel
    {
        public int Level { get; set; }

        public int LevelScore { get; set; }

        public List<CmmcDomain> Domains { get; set; }

        public string GaugeSvg { get; set; }

        public CmmcScoreModel()
        {
            this.Domains = new List<CmmcDomain>();
        }
    }


    public class CmmcDomain
    {
        public string DomainName { get; set; }

        public List<CmmcQuestion> Questions { get; set; }

        public CmmcDomain()
        {
            this.Questions = new List<CmmcQuestion>();
        }
    }


    public class CmmcQuestion
    {
        public int QuestionId { get; set; }

        public string Title { get; set; }
        public string QuestionText { get; set; }

        public string AnswerText { get; set; }

        public int Score { get; set; }
    }
}
