//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Reports;
using System;
using System.Collections.Generic;
using System.Xml.Linq;
using System.Linq;

namespace CSETWebCore.Reports.Models
{
    public class CmuResultsModel
    {
        public List<CmuMaturityDomainModel> CmuDomains { get; set; }


        /// <summary>
        /// 
        /// </summary>
        public CmuResultsModel()
        {
            CmuDomains = new List<CmuMaturityDomainModel>();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="data"></param>
        public void EvaluateDataList(List<DomainStats> data)
        {
            foreach (DomainStats d in data)
            {
                if (CmuDomains.Find(f => f.DomainName == d.domainName) is null)
                {
                    CmuDomains.Add(new CmuMaturityDomainModel(d.domainName));
                }
                CmuDomains.Find(c => c.DomainName == d.domainName).AddLevelData(d);
            }
            // CmuDomains.ForEach(c => c.CalcLevelAcheived());
        }


        //TESTING
        public void TrimToNElements(int elementCount)
        {
            int countToRemove = CmuDomains.Count - elementCount;
            if (countToRemove > 0)
            {
                CmuDomains.RemoveRange(elementCount, countToRemove);
            }
        }


        /// <summary>
        /// Figures out how wide the brown bar should be in pixels, based on the domain score.
        /// </summary>
        public void GenerateWidthValues()
        {
            double pageWidth = 792;  // this needs to correspond to --page-width in CRRResults.css 
            double tableMargins = 0;
            double nameSectionWidth = 160;
            double mil1Ratio = .5;
            double milUpperRatio = 1 - mil1Ratio;

            double tableWidth = pageWidth - (tableMargins * 2);
            double barWidth = tableWidth - nameSectionWidth;
            double mil1Width = barWidth * mil1Ratio;
            double milUpperWidth = barWidth * milUpperRatio;


            foreach (CmuMaturityDomainModel domain in CmuDomains)
            {
                domain.WidthValpx = mil1Width * domain.DomainScore;

                if (domain.DomainScore > 1)
                {
                    // reset to MIL-1 complete ...
                    domain.WidthValpx = mil1Width;

                    // ... then add the remaining width
                    var residual = domain.DomainScore - 1;
                    domain.WidthValpx += milUpperWidth * (residual / 4);
                }
            }
        }
    }


    /// <summary>
    /// 
    /// </summary>
    public class CmuMaturityDomainModel
    {
        public CmuMaturityDomainModel(string DomainName)
        {
            this.DomainName = DomainName;
            StatsByLevel = new List<CMUMaturityLevelStats>();
            WidthValpx = 0;
        }

        public string DomainName { get; set; }
        public int AcheivedLevel { get; set; }
        public double DomainScore { get; set; }
        public double WidthValpx { get; set; }

        public List<CMUMaturityLevelStats> StatsByLevel { get; set; }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="data"></param>
        public void AddLevelData(DomainStats data)
        {
            StatsByLevel.Add(
                new CMUMaturityLevelStats(
                    Int32.Parse(data.ModelLevel),
                    data.questionCount,
                    data.questionAnswered
                    )
                );
        }
    }


    /// <summary>
    /// 
    /// </summary>
    public class CMUMaturityLevelStats
    {
        public CMUMaturityLevelStats(int Level, double QuestionCount, double QuestionsAnswered)
        {
            level = Level;
            questionCount = QuestionCount;
            questionsAnswered = QuestionsAnswered;
            if (questionCount != 0)
            {
                if (questionsAnswered != 0 && questionCount != 0)
                {
                    percentAnswered = questionsAnswered / questionCount;
                }
                else
                {
                    percentAnswered = questionsAnswered / questionCount;
                }
            }
            else
            {
                percentAnswered = 1;
            }
        }
        public int level { get; set; }
        public double questionCount { get; set; }
        public double questionsAnswered { get; set; }
        public double percentAnswered { get; set; }
    }
}