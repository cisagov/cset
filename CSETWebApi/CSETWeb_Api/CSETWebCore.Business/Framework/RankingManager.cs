//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Linq;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Business.Framework
{
    public class RankingManager
    {
        private CSETContext ControlDataRepository;

        public RankingManager(CSETContext controlDataRepository)
        {
            this.ControlDataRepository = controlDataRepository;
        }


        public int GetMaxQuestionRanking()
        {
            try
            {
                int maxReqRank = Convert.ToInt32(this.ControlDataRepository.NEW_REQUIREMENT.Max(x => x.Ranking).Value);
                int maxQuestionRank = Convert.ToInt32(this.ControlDataRepository.NEW_QUESTION.Max(x => x.Ranking).Value);

                if (maxReqRank > maxQuestionRank)
                    return maxReqRank;
                else
                    return maxQuestionRank;
            }
            catch
            {
                return 10000;
            }
        }
    }
}