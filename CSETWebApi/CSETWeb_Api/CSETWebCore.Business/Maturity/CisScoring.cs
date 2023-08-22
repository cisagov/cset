//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Nested;

namespace CSETWebCore.Business.Maturity
{
    public class CisScoring
    {
        /// <summary>
        /// The structured model for a section/category in CIS.
        /// </summary>
        public NestedQuestions QuestionsModel;

        private List<FlatQuestion> allWeights = new List<FlatQuestion>();


        /// <summary>
        /// Calculates CIS scoring.
        /// </summary>
        public CisScoring(int assessmentId, int sectionId, CSETContext context)
        {
            var section = new NestedStructure(assessmentId, sectionId, context);
            QuestionsModel = section.MyModel;
        }


        /// <summary>
        /// Calculates CIS scoring.
        /// </summary>
        /// <param name="model"></param>
        public CisScoring(NestedQuestions model)
        {
            QuestionsModel = model;
        }

        /// <summary>
        /// Calculates the SD Score for grouping
        /// </summary>
        /// <returns></returns>
        public Score CalculateGroupingScoreSD()
        {
            if (QuestionsModel.Groupings.FirstOrDefault()?.Questions != null)
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
                            Weight = 1
                        };
                    var sumAllWeights = (decimal)sumGroupWeights.Sum(x => x.Weight);
                    var totalGroupWeights = from g in grouped
                        select new RollupOptions()
                        {
                            Type = g.OptionQuestions.FirstOrDefault().Type,
                            Weight = 1
                        };
                    var sumTotalWeights = (decimal)totalGroupWeights.Sum(x => x?.Weight);
                    decimal total = sumAllWeights != 0 ? sumTotalWeights / sumAllWeights : 0;
                }
            }

            return null;
        }

        /// <summary>
        /// Calculates the CIS score for a grouping/section.
        /// </summary>
        /// <returns></returns>
        public Score CalculateGroupingScore()
        {
            if (QuestionsModel.Groupings.FirstOrDefault()?.Questions != null)
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

                    /// special case for HYDRO, where the scores need to be grouped by impact severity and have a double for the score
                    if (QuestionsModel.ModelId == 13)
                    {
                        var totalGroupHighThreatWeight = from g in grouped
                                                select new RollupOptions()
                                                {
                                                    Type = g.OptionQuestions.FirstOrDefault().Type,
                                                    Weight = g.OptionQuestions.FirstOrDefault().Type != "radio"
                                                        ? g.OptionQuestions.Where(s => s.Selected && s.ThreatType == 3).Sum(x => x.Weight)
                                                        : g.OptionQuestions.FirstOrDefault(s => s.Selected && s.ThreatType == 3)?.Weight
                                                };
                        var totalGroupMediumThreatWeight = from g in grouped
                                                select new RollupOptions()
                                                {
                                                    Type = g.OptionQuestions.FirstOrDefault().Type,
                                                    Weight = g.OptionQuestions.FirstOrDefault().Type != "radio"
                                                        ? g.OptionQuestions.Where(s => s.Selected && s.ThreatType == 2).Sum(x => x.Weight)
                                                        : g.OptionQuestions.FirstOrDefault(s => s.Selected && s.ThreatType == 2)?.Weight
                                                };
                        var totalGroupLowThreatWeight = from g in grouped
                                                select new RollupOptions()
                                                {
                                                    Type = g.OptionQuestions.FirstOrDefault().Type,
                                                    Weight = g.OptionQuestions.FirstOrDefault().Type != "radio"
                                                        ? g.OptionQuestions.Where(s => s.Selected && s.ThreatType == 1).Sum(x => x.Weight)
                                                        : g.OptionQuestions.FirstOrDefault(s => s.Selected && s.ThreatType == 1)?.Weight
                                                };
                        var sumTotalHighThreatWeight = (double)totalGroupHighThreatWeight.Sum(x => x?.Weight);
                        var sumTotalMediumThreatWeight = (double)totalGroupMediumThreatWeight.Sum(x => x?.Weight);
                        var sumTotalLowThreatWeight = (double)totalGroupLowThreatWeight.Sum(x => x?.Weight);

                        return new Score
                        {
                            GroupingScoreDouble = (double)Math.Round(total * 100, 2, MidpointRounding.AwayFromZero),
                            LowDouble = sumTotalLowThreatWeight,
                            MediumDouble = sumTotalMediumThreatWeight,
                            HighDouble = sumTotalHighThreatWeight
                        };
                    }
                    return new Score
                    {
                        GroupingScore = (int)Math.Round(total * 100, MidpointRounding.AwayFromZero),
                        Low = 0,
                        Median = 0,
                        High = 0
                    };
                }
            }

            return new Score();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="questions"></param>
        private void FlattenQuestions(List<Model.Nested.Question> questions)
        {
            foreach (var q in questions)
            {
                allWeights.AddRange(q.Options.Select(x => new FlatQuestion
                {
                    QuestionText = q.QuestionText,
                    Weight = x.Weight,
                    Selected = x.Selected,
                    Type = x.OptionType,
                    ThreatType = x.ThreatType

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
