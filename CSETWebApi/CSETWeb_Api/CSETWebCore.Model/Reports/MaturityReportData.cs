//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using System;
using System.Collections.Generic;
using System.Linq;

namespace CSETWebCore.Business.Reports
{

    /// <summary>
    /// 
    /// </summary>
    public class DomainStats
    {
        /// <summary>
        /// 
        /// </summary>
        public DomainStats()
        {
            domainQuestions = new List<MaturityQuestion>();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="domainName"></param>
        public DomainStats(string domainName)
        {
            this.domainName = domainName;
            questionCount = 0;
            questionAnswered = 0;
            questionUnAnswered = 0;
            domainQuestions = new List<MaturityQuestion>();
        }

        public string domainName { get; set; }
        public double questionCount { get; set; }
        public double questionAnswered { get; set; }
        public int questionUnAnswered { get; set; }
        public string ModelLevel { get; set; }
        public List<MaturityQuestion> domainQuestions { get; set; }
    }


    /// <summary>
    /// 
    /// </summary>
    public class MaturityQuestion
    {
        public int Mat_Question_Id { get; set; }
        public string Question_Title { get; set; }
        public string Question_Text { get; set; }
        public string Supplemental_Info { get; set; }
        public string Examination_Approach { get; set; }
        public string Recommended_Action { get; set; }
        public int Maturity_Level { get; set; }
        public string Set_Name { get; set; }
        public int Sequence { get; set; }
        public string Text_Hash { get; set; }
        public int Maturity_Model_Id { get; set; }
        public int Grouping_Id { get; set; }
        public int? Parent_Question_Id { get; set; }
        public ANSWER Answer { get; set; }

        /// <summary>
        /// Convenience attribute for grouping
        /// </summary>
        public string Domain { get; set; }

        /// <summary>
        /// Convenience attribute for grouping
        /// </summary>
        public string Capability { get; set; }

        public string ReferenceText { get; set; }
    }

    public class MaturityReportData : BasicReportData
    {
        private readonly CSETContext _context;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public MaturityReportData(CSETContext context)
        {
            _context = context;
        }


        public int MaturityLevel { get; set; }


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


        /// <summary>
        /// 
        /// </summary>
        public class LevelStats
        {
            public int questionCount { get; set; }
            public int questionCountAggregateForLevelAndBelow { get; set; } //Possibly the longest variable name ive created
            public int questionAnswered { get; set; }
            public int questionUnAnswered { get; set; }
            public string ModelLevel { get; set; }
        }




        /// <summary>
        /// 
        /// </summary>
        public void AnalyzeMaturityData()
        {
            if (this.MaturityModels == null)
            {
                return;
            }

            MaturityModel cmmcModel = this.MaturityModels
                .Where(a => a.MaturityModelName == "CMMC")
                .FirstOrDefault();
            if (cmmcModel != null)
            {
                AnalyzeCMMCData(cmmcModel);
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="model"></param>
        public void AnalyzeCMMCData(MaturityModel model)
        {
            // flesh out the questions with their capability and domain names
            MATURITY_MODELS maturityModel;
            var domains = new List<MATURITY_GROUPINGS>();


            maturityModel = _context.MATURITY_MODELS.Where(x => x.Model_Name == "CMMC").FirstOrDefault();

            domains = _context.MATURITY_GROUPINGS.Where(x => x.Maturity_Model_Id == maturityModel.Maturity_Model_Id && x.Group_Level == 1)
                .ToList();

            var domainIds = domains.Select(d => d.Grouping_Id).ToList();

            var capabilities = _context.MATURITY_GROUPINGS.Where(x => domainIds.Contains((int)x.Parent_Id)).ToList();

            model.MaturityQuestions.ForEach(q =>
            {
                var myCapability = capabilities.Where(c => c.Grouping_Id == q.Grouping_Id).FirstOrDefault();
                q.Capability = myCapability.Title;
                q.Domain = domains.Where(d => d.Grouping_Id == myCapability.Parent_Id).FirstOrDefault().Title;
            });



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



            int questionCountAggregateForLevelAndBelow = 0;

            var maturity_levels = model.MaturityQuestions.
                Select(mq => mq.Maturity_Level).
                Distinct();

            foreach (int level in maturity_levels)
            {
                //Get the stats for each level of question
                var questions_at_level = model.MaturityQuestions
                    .Where(mq => mq.Maturity_Level == level).ToList();
                model.StatsByLevel.Add(ToLevelStats(questions_at_level, level.ToString(), questionCountAggregateForLevelAndBelow));
                questionCountAggregateForLevelAndBelow += questions_at_level.Count();
                if ((questions_at_level.Where(q => q.Answer.Answer_Text == "N" || q.Answer.Answer_Text == "U").Count() == 0))
                {
                    model.AcheivedLevel = level;
                }

                //Get the questions by domain for each level                
                foreach (string domain in domains.Select(x => x.Title))
                {
                    var questions_of_domain_at_level = model.MaturityQuestions
                        .Where(mq => mq.Maturity_Level == level && mq.Domain == domain)
                        .ToList();
                    model.StatsByDomainAndLevel.Add(ToDomainStats(questions_of_domain_at_level, level.ToString(), domain));
                }
            }

            foreach (string domain in domains.Select(x => x.Title))
            {
                var questions_of_domain = model.MaturityQuestions
                    .Where(mq => mq.Domain == domain && mq.Maturity_Level <= model.TargetLevel).ToList();
                model.StatsByDomain.Add(ToDomainStats(questions_of_domain, domainName: domain));

                //flatten stats by domain and level
                DomainStats domainStats = new DomainStats();
                var domainSpecificAtTargetLevel = model.StatsByDomainAndLevel
                    .Where(sbdal => Int32.Parse(sbdal.ModelLevel) <= model.TargetLevel
                    && sbdal.domainName == domain).ToList();

                DomainStats consolidatedDomainStat = new DomainStats(domain);
                foreach (var item in domainSpecificAtTargetLevel)
                {
                    consolidatedDomainStat.questionCount += item.questionCount;
                    consolidatedDomainStat.questionAnswered += item.questionAnswered;
                    consolidatedDomainStat.questionUnAnswered += item.questionUnAnswered;
                }
                model.StatsByDomainAtUnderTarget.Add(consolidatedDomainStat);

            }

            model.TotalQuestions = model.MaturityQuestions.Count();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="questions"></param>
        /// <param name="level"></param>
        /// <param name="domainName"></param>
        /// <returns></returns>
        public DomainStats ToDomainStats(List<MaturityQuestion> questions, string level = null, string domainName = null)
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


        /// <summary>
        /// 
        /// </summary>
        /// <param name="questions"></param>
        /// <param name="level"></param>
        /// <param name="previousLevelQuestionCount"></param>
        /// <returns></returns>
        public LevelStats ToLevelStats(List<MaturityQuestion> questions, string level = null, int previousLevelQuestionCount = 0)
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
