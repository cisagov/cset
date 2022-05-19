using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Cis;

namespace CSETWebCore.Business.Maturity
{
    public class CisScoring
    {
        /// <summary>
        /// The structured model for a section/category in CIS.
        /// </summary>
        public CisQuestions QuestionsModel;

        private List<FlatQuestion> allWeights = new List<FlatQuestion>();


        /// <summary>
        /// Calculates CIS scoring.
        /// </summary>
        public CisScoring(int assessmentId, int sectionId, CSETContext context)
        {
            var section = new CisStructure(assessmentId, sectionId, context);
            QuestionsModel = section.MyModel;
        }


        /// <summary>
        /// Calculates CIS scoring.
        /// </summary>
        /// <param name="model"></param>
        public CisScoring(CisQuestions model)
        {
            QuestionsModel = model;
        }


        /// <summary>
        /// Calculates the CIS score for a grouping/section.
        /// </summary>
        /// <returns></returns>
        public Score CalculateGroupingScore()
        {
            if (QuestionsModel.Groupings.FirstOrDefault().Questions != null)
            {
                FlattenQuestions(QuestionsModel.Groupings.FirstOrDefault()?.Questions);

                if (allWeights.Any())
                {
                    var grouped = allWeights.GroupBy(q => q.QuestionText).Select(r => new GroupedQuestions
                    {
                        QuestionText = r.Key,
                        OptionQuestions = r.ToList()
                    });
                    var sumGroupWeights = from g in grouped
                                          select new RollupOptions
                                          {
                                              Type = g.OptionQuestions.FirstOrDefault().Type,
                                              Weight = g.OptionQuestions.FirstOrDefault().Type != "radio"
                                                  ? g.OptionQuestions.Sum(x => x.Weight) : g.OptionQuestions.MaxBy(x => x.Weight)?.Weight
                                          };
                    var sumAllWeights = (decimal)sumGroupWeights.Sum(x => x.Weight);
                    var totalGroupWeights = from g in grouped
                                            select new RollupOptions()
                                            {
                                                Type = g.OptionQuestions.FirstOrDefault().Type,
                                                Weight = g.OptionQuestions.FirstOrDefault().Type != "radio"
                                                    ? g.OptionQuestions.Where(s => s.Selected).Sum(x => x.Weight)
                                                    : g.OptionQuestions.FirstOrDefault(s => s.Selected)?.Weight
                                            };
                    var sumTotalWeights = (decimal)totalGroupWeights.Sum(x => x?.Weight);
                    decimal total = sumAllWeights != 0 ? sumTotalWeights / sumAllWeights : 0;
                    return new Score
                    {
                        GroupingScore = (int)Math.Round(total * 100, MidpointRounding.AwayFromZero),
                        Low = 0,
                        Median = 0,
                        High = 0,
                        BaselineGroupingScore = null
                    };
                }
            }

            return new Score();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="questions"></param>
        private void FlattenQuestions(List<Model.Cis.Question> questions)
        {
            foreach (var q in questions)
            {
                allWeights.AddRange(q.Options.Select(x => new FlatQuestion
                {
                    QuestionText = q.QuestionText,
                    Weight = x.Weight,
                    Selected = x.Selected,
                    Type = x.OptionType

                }).ToList());
                foreach (var o in q.Options)
                {
                    if (o.Followups.Any())
                    {
                        FlattenQuestions(o.Followups);
                    }
                }

                if (q.Followups.Any())
                {
                    FlattenQuestions(q.Followups);
                }
            }
        }
    }
}
