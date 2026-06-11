//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Manual;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Model.Maturity.CPG;
using System;
using System.Collections.Generic;
using System.Linq;


namespace CSETWebCore.Business.Maturity
{
    public class CpgBusiness
    {
        private readonly CSETContext _context;
        private readonly TranslationOverlay _overlay;
        private readonly string _lang;


        /// <summary>
        /// CTOR
        /// </summary>
        /// <param name="context"></param>
        public CpgBusiness(CSETContext context, string lang)
        {
            _context = context;

            _overlay = new TranslationOverlay();
            _lang = lang;
        }


        /// <summary>
        /// Returns the answer percentage distributions for each of the CPG domains.
        /// Also includes the compliance score, calculated from that distribution.
        /// </summary>
        /// <returns></returns>
        public AnswerDistribDomainResponse GetAnswerDistribForDomains(int assessmentId, int? modelId, string techDomain)
        {
            var resp = new AnswerDistribDomainResponse();

            if (modelId == null)
            {
                modelId = _context.AVAILABLE_MATURITY_MODELS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault()?.model_id;
            }

            // first, get the answer set
            var answerList = GetAnswerList(assessmentId, techDomain, modelId);


            // calculate the compliance scores
            var scoring = new CpgScoring();
            resp.ComplianceScore = scoring.CalculateNewImpactScore(answerList);


            // get the CPG question distribution
            var dbListCpg = GetAnswerDistribGroupings(answerList);

            foreach (var item in dbListCpg)
            {
                // translate if necessary
                item.title = _overlay.GetMaturityGrouping(item.grouping_id, _lang)?.Title ?? item.title;
                if (!resp.Distrib.Exists(x => x.Name == item.title))
                {
                    var domain = new AnswerDistribDomain()
                    {
                        Name = item.title,
                        Series = InitializeSeries()
                    };

                    resp.Distrib.Add(domain);
                }
            }

            // determine percentages for each answer count in the distribution
            resp.Distrib.ForEach(domain =>
            {
                domain.Series.ForEach(y =>
                {
                    double percent = CalculatePercent(dbListCpg.Where(g => g.title == domain.Name).ToList(), y.Name);
                    y.Value = percent;

                });
            });

            return resp;
        }


        /// <summary>
        /// Calculates the percentage based on all answer values for the domain
        /// </summary>
        /// <returns></returns>
        private double CalculatePercent(List<GetAnswerDistribGroupingsResult> r, string ansName)
        {
            var target = r.FirstOrDefault(x => x.answer_text == ansName)?.answer_count ?? 0;
            var total = r.Select(x => x.answer_count).Sum();

            return ((double)target * 100d / (double)total);
        }


        /// <summary>
        /// Initializes 'empty' percentge slots for potential CPG answers.
        /// </summary>
        /// <returns></returns>
        private List<Series> InitializeSeries()
        {
            var list = new List<Series>();

            var values = new List<string>() { "Y", "I", "S", "N", "U" };
            foreach (string s in values)
            {
                list.Add(new Series()
                {
                    Name = s,
                    Value = 0
                });
            }

            return list;
        }


        /// <summary>
        /// Figures out if an SSG model is applicable as a bonus.
        /// The SSG is based on the assessment's sector.
        /// Returns an empty list if no SSG is applicable.
        /// </summary>
        /// <returns></returns>
        public List<int> DetermineSsgModels(int assessmentId)
        {
            var sectorToModelMap = new Dictionary<int, int>
            {
                { 1, Constants.Constants.Model_SSG_CHEM },
                { 19, Constants.Constants.Model_SSG_CHEM },
                { 13, Constants.Constants.Model_SSG_IT },
                { 28, Constants.Constants.Model_SSG_IT },
            };

            var ssgModels = new HashSet<int>();
            var sectors = _context.ASSESSMENT_SECTOR_SUBSECTOR
                .Where(x => x.Assessment_Id == assessmentId)
                .ToList();

            foreach (var sector in sectors)
            {
                if (sectorToModelMap.TryGetValue((int)sector.SectorId, out var modelId))
                {
                    ssgModels.Add(modelId);
                }
            }

            return ssgModels.ToList();
        }


        /// <summary>
        /// Returns a list of answer quantities for each domain.  
        /// It considers question scope based on the technical domain
        /// of the assessment. 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="modelId"></param>
        /// <returns></returns>
        public IList<GetAnswerDistribGroupingsResult> GetAnswerDistribGroupings(List<AnswerImpact> answerList)
        {
            // group the answers 
            var groupedList = answerList
                .GroupBy(o => new { o.GroupingId, o.Title, o.AnswerText })
                .Select(g => new GetAnswerDistribGroupingsResult
                {
                    grouping_id = g.Key.GroupingId,
                    title = g.Key.Title,
                    answer_text = g.Key.AnswerText,
                    answer_count = g.Count()
                })
                .ToList();

            return groupedList;
        }


        /// <summary>
        /// Builds a list of in-scope answers for a model and tech domain.
        /// </summary>
        private List<AnswerImpact> GetAnswerList(int assessmentId, string techDomain, int? modelId)
        {
            _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

            if (modelId != null)
            {
                _context.FillEmptyMaturityQuestionsForModel(assessmentId, (int)modelId);
            }


            var resp = new List<GetAnswerDistribGroupingsResult>();


            var query = from a in _context.ANSWER
                        join q in _context.MATURITY_QUESTIONS on a.Question_Or_Requirement_Id equals q.Mat_Question_Id

                        let propsId = q.Parent_Question_Id != null ? (int)q.Parent_Question_Id : q.Mat_Question_Id
                        join p in _context.MATURITY_QUESTION_PROPS
                            on new
                            {
                                Mat_Question_Id = propsId,
                                PropertyName = "IMPACT"
                            }
                            equals new { p.Mat_Question_Id, p.PropertyName }
                            into props
                        from p in props.DefaultIfEmpty()

                        join g in _context.MATURITY_GROUPINGS on q.Grouping_Id equals g.Grouping_Id
                        where a.Question_Type == "Maturity" && q.Is_Answerable
                           && a.Assessment_Id == assessmentId && q.Maturity_Model_Id == modelId

                        select new AnswerImpact()
                        {
                            GroupingId = g.Grouping_Id,
                            QuestionId = q.Mat_Question_Id,
                            Title = g.Title,
                            Impact = p != null ? p.PropertyValue : null,
                            AnswerId = a.Answer_Id,
                            AnswerText = a.Answer_Text,
                        };

            var answerList = query.ToList();


            // Spin up the generic scope analyzer or a maturity model-specific one
            var _questionScope = new QuestionScopeAnalyzer(assessmentId);


            // CPG 2.0
            if (modelId == Constants.Constants.Model_CPG2)
            {
                _questionScope = new QuestionScopeAnalyzer(assessmentId, _context, techDomain);
            }

            answerList.RemoveAll(x => _questionScope.OutOfScopeQuestionIds.Contains(x.QuestionId));

            return answerList;
        }
    }
}
