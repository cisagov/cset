using CSETWebCore.Business.Reports;
using System;
using System.Collections.Generic;

namespace CSETWebCore.Reports.Models
{
    public class CrrResultsModel
    {
        public CrrResultsModel()
        {
            crrDomains = new List<CrrMaturityDomainModel>();
        }
        public List<CrrMaturityDomainModel> crrDomains { get; set; }

        public void EvaluateDataList(List<DomainStats> data)
        {
            foreach(DomainStats d in data){
                if(crrDomains.Find(f => f.domainName == d.domainName) is null)
                {
                    crrDomains.Add(new CrrMaturityDomainModel(d.domainName));
                }
                crrDomains.Find(c => c.domainName == d.domainName).addLevelData(d);
            }
            crrDomains.ForEach(c => c.CalcLevelAcheived());
        }

        //TESTING
        public void TrimToNElements(int elementCount)
        {
            int countToRemove = crrDomains.Count - elementCount;
            crrDomains.RemoveRange(elementCount, countToRemove);
        }

        public void GenerateWidthValues()
        {
            double pageWidth = 1120;
            double tableMargins = 38;
            double nameSectionWidth = 160;
            double mil1Ratio = .6;
            double milUpperRatio = 1 - mil1Ratio;

            double tableWidth = pageWidth - (tableMargins * 2);
            double barWidth = tableWidth - nameSectionWidth;
            double mil1Width = barWidth * mil1Ratio;
            double milUpperWidth = barWidth * milUpperRatio;

            foreach (CrrMaturityDomainModel dom in crrDomains)
            {
                for(int i = 1; i<=5; i++)
                {
                    if (i <= dom.levelAcheived || dom.levelAcheived == 0)
                    {
                        if (i == 1)
                        {
                            double domCalc =
                                Math.Ceiling(mil1Width * dom.statsByLevel.Find(a => a.level == 1).percentAnswered);
                            dom.widthValpx = domCalc > mil1Width ? mil1Width : domCalc;
                        }
                        else
                        {
                            if (dom.levelAcheived > 1)
                            {
                                double domCalc = (milUpperWidth / 4) *
                                                 dom.statsByLevel.Find(a => a.level == i).percentAnswered;
                                dom.widthValpx += domCalc > (milUpperWidth / 4) ? milUpperWidth / 4 : domCalc;
                            }
                        }
                    }
                    else
                    {
                        break;
                    }
                }
            }
        }
    }

    public class CrrMaturityDomainModel
    {
        public CrrMaturityDomainModel(string DomainName)
        {
            domainName = DomainName;
            statsByLevel = new List<CRRMaturityLevelStats>();
            widthVal = 0;
        }
        public string domainName { get; set; }
        public int levelAcheived { get; set; }
        public double widthVal { get; set; }
        public double widthValpx { get; set; }
        public double percentOfNextLevel { get; set; }
        public List<CRRMaturityLevelStats> statsByLevel { get; set; }
        public void addLevelData(DomainStats data)
        {
            statsByLevel.Add(
                new CRRMaturityLevelStats(
                    Int32.Parse(data.ModelLevel),
                    data.questionCount,
                    data.questionAnswered
                    )
                );
        }
        public void CalcLevelAcheived()
        {
            for(int i = 1; i <=5; i++)
            {
                double percentOfLevelAcheived = statsByLevel.Find(s => s.level == i).percentAnswered;
                if (percentOfLevelAcheived == 1)
                {
                    levelAcheived = i;
                    widthVal += 1;
                } else
                {
                    percentOfNextLevel = percentOfLevelAcheived;
                    widthVal += percentOfLevelAcheived;
                    i = 6; //break out of for loop, magic numbers all around
                }
            }
        }
    }
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
                    percentAnswered = questionsAnswered  / questionCount ;
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