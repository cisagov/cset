//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using DataLayerCore.Manual;
using DataLayerCore.Model;
using Snickler.EFCore;

namespace CSETWeb_Api.BusinessLogic.ReportEngine
{
    public class MaturityReportData : BasicReportData
    {
        public int MaturityLevel { get; set; }

        //public List<MaturityQuestion> MaturityQuestions { get; set; }
        public List<MaturityModel> MaturityModels { get; set; }
        

        public class MaturityModel
        {

            public string MaturityModelName { get; set; }
            public int MaturityModelID { get; set; }
            public int? TargetLevel { get; set; } = 0;
            public int? AcheivedLevel { get; set; } = 0;
            public int? TotalQuestions { get; set; } = 0;
            public List<LevelStats> StatsByLevel { get; set; }
            public List<DomainStats> StatsByDomainAndLevel { get; set; }
            public List<DomainStats> StatsByDomain { get; set; }
            public List<DomainStats> DomainAndQuestions { get; set; }
            public List<DomainStats> StatsByDomainAtUnderTarget { get; set; }
            public List<MaturityQuestion> MaturityQuestions { get; set; }
            public MaturityModel()
            {
                MaturityQuestions = new List<MaturityQuestion>();
            }
        }
        public class LevelStats
        {
            public int questionCount { get; set; }
            public int questionCountAggregateForLevelAndBelow { get; set; } //Possibly the longest variable name ive created
            public int questionAnswered { get; set; }
            public int questionUnAnswered { get; set; }
            public string ModelLevel { get; set; }
        }
        public class DomainStats
        {
            public DomainStats()
            {
                domainQuestions = new List<MaturityQuestion>();
            }
            public DomainStats(string domainName)
            {
                this.domainName = domainName;
                questionCount = 0;
                questionAnswered = 0;
                questionUnAnswered = 0;
                domainQuestions = new List<MaturityQuestion>();
            }
            public string domainName { get; set; }
            public int questionCount { get; set; }
            public int questionAnswered { get; set; }
            public int questionUnAnswered { get; set; }
            public string ModelLevel { get; set; }
            public List<MaturityQuestion> domainQuestions {get; set;}
        }

        public class MaturityQuestion
        {
            public int Mat_Question_Id { get; set; }
            public string Question_Title { get; set; }
            public string Question_Text { get; set; }
            public string Supplemental_Info { get; set; }
            public string Category { get; set; }
            public string Sub_Category { get; set; }
            public int Maturity_Level { get; set; }
            public string Set_Name { get; set; }
            public int Sequence { get; set; }
            public string Text_Hash { get; set; }
            public int Maturity_Model_Id { get; set; }
            //public int Answer_Id { get; set; } //Used for testing, can be removed at a later date
            //public int Answer_Mark_For_Review { get; set; }
            //public string Answer_Comment { get; set; }
            //public string Answer_Alt_Just { get; set; }
            //public int Ans_Question_Number { get; set; }
            //public string Answer_Text { get; set; }
            //public bool Is_Maturity { get; set; }//Used for testing, can be removed at a later date
            public ANSWER Answer { get; set; }
        }
        public void analyzeMaturityData()
        {
            if (this.MaturityModels == null) { return; }
            MaturityModel cmmcModel = this.MaturityModels
                .Where(a => a.MaturityModelName == "CMMC")
                .FirstOrDefault();
            if (cmmcModel != null) { analyzeCMMCData(cmmcModel); }
        }
        public void analyzeCMMCData(MaturityModel model)
        {
            model.StatsByLevel = new List<LevelStats>();
            model.StatsByDomainAndLevel = new List<DomainStats>();
            model.StatsByDomain = new List<DomainStats>();
            model.StatsByDomainAtUnderTarget = new List<DomainStats>();

            LevelStats aggregateLvlStats = new LevelStats();

            //Get the aggregate level stats
            aggregateLvlStats.ModelLevel = "Aggregate";
            aggregateLvlStats.questionCount = model.MaturityQuestions.Count();
            aggregateLvlStats.questionAnswered = model.MaturityQuestions.Where(qa => (qa.Answer.Answer_Text == "Y" || qa.Answer.Answer_Text == "A")).Count();
            aggregateLvlStats.questionUnAnswered = model.MaturityQuestions.Where(qa => qa.Answer.Answer_Text != "Y" || qa.Answer.Answer_Text != "A").Count();
            model.StatsByLevel.Add(aggregateLvlStats);


            var maturity_levels = model.MaturityQuestions.
                Select(mq => mq.Maturity_Level).
                Distinct();
            var domains = model.MaturityQuestions.
                Select(mq => mq.Category).
                Distinct();
            int questionCountAggregateForLevelAndBelow = 0;
            foreach (int level in maturity_levels)
            {
                //Get the stats for each level of question
                var questions_at_level = model.MaturityQuestions
                    .Where(mq => mq.Maturity_Level == level).ToList();
                model.StatsByLevel.Add(toLevelStats(questions_at_level, level.ToString(), questionCountAggregateForLevelAndBelow));
                questionCountAggregateForLevelAndBelow += questions_at_level.Count();
                if((questions_at_level.Where(q => q.Answer.Answer_Text == "N" || q.Answer.Answer_Text == "U").Count() == 0)){
                    model.AcheivedLevel = level;
                }

                //Get the questions by domain for each level                
                foreach (string domain in domains)
                {
                    var questions_of_domain_at_level = model.MaturityQuestions
                        .Where(mq => mq.Maturity_Level == level && mq.Category == domain).ToList();
                    model.StatsByDomainAndLevel.Add(toDomainStats(questions_of_domain_at_level, level.ToString(),domain));
                }
            }
            foreach (string domain in domains)
            {
                var questions_of_domain = model.MaturityQuestions
                    .Where(mq => mq.Category == domain && mq.Maturity_Level<= model.TargetLevel).ToList();
                model.StatsByDomain.Add(toDomainStats(questions_of_domain, domainName: domain));

                //flatten stats by domain and level
                DomainStats domainStats = new DomainStats();
                var domainSpecificAtTargetLevel = model.StatsByDomainAndLevel
                    .Where(sbdal => Int32.Parse(sbdal.ModelLevel) <= model.TargetLevel 
                    && sbdal.domainName == domain).ToList();

                DomainStats consolidatedDomainStat = new DomainStats(domain);
                foreach(var item in domainSpecificAtTargetLevel)
                {
                    consolidatedDomainStat.questionCount += item.questionCount;
                    consolidatedDomainStat.questionAnswered += item.questionAnswered;
                    consolidatedDomainStat.questionUnAnswered += item.questionUnAnswered;
                }
                model.StatsByDomainAtUnderTarget.Add(consolidatedDomainStat);

            }

            model.TotalQuestions = model.MaturityQuestions.Count();

        }
        public DomainStats toDomainStats(List<MaturityQuestion> questions, string level = null, string domainName = null)
        {
            DomainStats newDomainStats = new DomainStats();
            if (level != null) newDomainStats.ModelLevel = level;
            if (domainName != null) newDomainStats.domainName = domainName;
            newDomainStats.domainQuestions = questions;
            newDomainStats.questionCount = questions.Count();
            newDomainStats.questionAnswered = questions.Where(qa => (qa.Answer.Answer_Text == "Y" || qa.Answer.Answer_Text == "A")).Count();
            newDomainStats.questionUnAnswered = questions.Where(qa => (qa.Answer.Answer_Text != "Y" && qa.Answer.Answer_Text != "A")).Count();
            return newDomainStats;
        }
        public LevelStats toLevelStats(List<MaturityQuestion> questions, string level = null, int previousLevelQuestionCount = 0)
        {
            LevelStats newLevelStats = new LevelStats();
            if (level != null) newLevelStats.ModelLevel = level;
            newLevelStats.questionCount = questions.Count();
            newLevelStats.questionAnswered = questions.Where(qa => (qa.Answer.Answer_Text == "Y" || qa.Answer.Answer_Text == "A")).Count();
            newLevelStats.questionUnAnswered = questions.Where(qa => (qa.Answer.Answer_Text != "Y" && qa.Answer.Answer_Text != "A")).Count();
            newLevelStats.questionCountAggregateForLevelAndBelow = newLevelStats.questionCount + previousLevelQuestionCount;
            return newLevelStats;
        }
    }
}


