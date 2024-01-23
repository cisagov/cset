//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Maturity
{
    public class SprsScoreModel
    {
        public int SprsScore { get; set; }

        public List<SprsDomain> Domains { get; set; }

        public string GaugeSvg { get; set; }

        public SprsScoreModel()
        {
            this.Domains = new List<SprsDomain>();
        }
    }

    public class SprsDomain
    {
        public string DomainName { get; set; }

        public List<SprsQuestion> Questions { get; set; }

        public SprsDomain()
        {
            this.Questions = new List<SprsQuestion>();
        }
    }

    public class SprsQuestion
    {
        public string Id { get; set; }
        public string QuestionText { get; set; }

        public string AnswerText { get; set; }

        public int Score { get; set; }
    }
}
