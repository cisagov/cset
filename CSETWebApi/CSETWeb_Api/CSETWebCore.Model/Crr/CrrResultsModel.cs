using CSETWebCore.Business.Reports;
using System;
using System.Collections.Generic;
using System.Xml.Linq;
using System.Linq;

namespace CSETWebCore.Reports.Models
{
    public class CrrResultsModel
    {
        public List<CrrMaturityDomainModel> CrrDomains { get; set; }


        /// <summary>
        /// 
        /// </summary>
        public CrrResultsModel()
        {
            CrrDomains = new List<CrrMaturityDomainModel>();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="data"></param>
        public void EvaluateDataList(List<DomainStats> data)
        {
            foreach (DomainStats d in data)
            {
                if (CrrDomains.Find(f => f.DomainName == d.domainName) is null)
                {
                    CrrDomains.Add(new CrrMaturityDomainModel(d.domainName));
                }
                CrrDomains.Find(c => c.DomainName == d.domainName).AddLevelData(d);
            }
            // crrDomains.ForEach(c => c.CalcLevelAcheived());
        }


        //TESTING
        public void TrimToNElements(int elementCount)
        {
            int countToRemove = CrrDomains.Count - elementCount;
            CrrDomains.RemoveRange(elementCount, countToRemove);
        }


        // public void GenerateWidth

        /// <summary>
        /// 
        /// </summary>
        public void GenerateWidthValues()
        {
            double pageWidth = 900;
            double tableMargins = 0;
            double nameSectionWidth = 160;
            double mil1Ratio = .5;
            double milUpperRatio = 1 - mil1Ratio;

            double tableWidth = pageWidth - (tableMargins * 2);
            double barWidth = tableWidth - nameSectionWidth;
            double mil1Width = barWidth * mil1Ratio;
            double milUpperWidth = barWidth * milUpperRatio;

            var scoringBreakdown = ShowScoringBreakdown();



            foreach (CrrMaturityDomainModel domain in CrrDomains)
            {
                domain.WidthValpx = mil1Width * domain.DomainScore;
                
                if (domain.DomainScore > 1)
                {
                    // reset to MIL-1 complete
                    domain.WidthValpx = mil1Width;

                    // then add the remaining width
                    var residual = domain.DomainScore - 1;
                    domain.WidthValpx += milUpperWidth * (residual / 4);
                }
            }
        }


        /// <summary>
        /// A debug method that generates text that can be pasted into an Excel worksheet.
        /// It indicates the numbers behind the "Maturity Indicator Level By Domain" (brown bar) chart.
        /// </summary>
        private string ShowScoringBreakdown()
        {
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            foreach (var d in CrrDomains)
            {
                sb.AppendLine(d.DomainName);

                foreach (var l in d.StatsByLevel)
                {
                    sb.AppendLine(l.level.ToString() + '\t' + l.questionCount + '\t' + l.questionsAnswered + '\t' + l.percentAnswered);
                }
            }

            return sb.ToString();
        }
    }


    /// <summary>
    /// 
    /// </summary>
    public class CrrMaturityDomainModel
    {
        public CrrMaturityDomainModel(string DomainName)
        {
            this.DomainName = DomainName;
            StatsByLevel = new List<CRRMaturityLevelStats>();
            WidthValpx = 0;
        }

        public string DomainName { get; set; }
        public int AcheivedLevel { get; set; }
        public double DomainScore { get; set; }
        public double WidthValpx { get; set; }

        public List<CRRMaturityLevelStats> StatsByLevel { get; set; }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="data"></param>
        public void AddLevelData(DomainStats data)
        {
            StatsByLevel.Add(
                new CRRMaturityLevelStats(
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
    public class CRRMaturityLevelStats
    {
        public CRRMaturityLevelStats(int Level, double QuestionCount, double QuestionsAnswered)
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