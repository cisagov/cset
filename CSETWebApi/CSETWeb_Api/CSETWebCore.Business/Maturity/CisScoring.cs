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

        private List<FlatOption> allWeights = new List<FlatOption>();


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
                FlattenOptions(QuestionsModel.Groupings.FirstOrDefault()?.Questions);
                if (allWeights.Any())
                {
                    var grouped = allWeights.GroupBy(q => q.QuestionText).Select(r => new GroupedOptions
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
                FlattenOptions(QuestionsModel.Groupings.FirstOrDefault()?.Questions);

                if (allWeights.Any())
                {

                    Console.WriteLine("allWeights:");
                    Console.WriteLine(Newtonsoft.Json.JsonConvert.SerializeObject(allWeights));
                    Console.WriteLine();


                    var grouped = allWeights.GroupBy(q => q.QuestionText).Select(r => new GroupedOptions
                    {
                        QuestionText = r.Key,
                        OptionQuestions = r.ToList()
                    });


                    Console.WriteLine("grouped:");
                    Console.WriteLine(Newtonsoft.Json.JsonConvert.SerializeObject(grouped));
                    Console.WriteLine();


                    var groupScoreWeights = from g in grouped
                                          select new RollupOptions
                                          {
                                              Type = g.OptionQuestions.FirstOrDefault().Type,
                                              Weight = g.OptionQuestions.FirstOrDefault().Type != "radio"
                                                  ? g.OptionQuestions.Sum(x => x.Weight) : g.OptionQuestions.MaxBy(x => x.Weight)?.Weight
                                          };

                    Console.WriteLine("groupScoreWeights:");
                    Console.WriteLine(Newtonsoft.Json.JsonConvert.SerializeObject(groupScoreWeights));
                    Console.WriteLine();

                    var sumScoreWeights = (decimal)groupScoreWeights.Sum(x => x.Weight);


                    var groupTotalWeights = from g in grouped
                                            select new RollupOptions()
                                            {
                                                Type = g.OptionQuestions.FirstOrDefault().Type,
                                                Weight = g.OptionQuestions.FirstOrDefault().Type != "radio"
                                                    ? g.OptionQuestions.Where(s => s.Selected).Sum(x => x.Weight)
                                                    : g.OptionQuestions.FirstOrDefault(s => s.Selected)?.Weight
                                            };

                    Console.WriteLine("groupTotalWeights:");
                    Console.WriteLine(Newtonsoft.Json.JsonConvert.SerializeObject(groupTotalWeights));
                    Console.WriteLine();

                    var sumTotalWeights = (decimal)groupTotalWeights.Sum(x => x?.Weight);


                    Console.WriteLine($"sumTotalWeights: {sumTotalWeights}");
                    Console.WriteLine($"sumAllWeights: {sumScoreWeights}");
                    Console.WriteLine();


                    decimal total = sumScoreWeights != 0 ? sumTotalWeights / sumScoreWeights : 0;


                    // special scoring for HYDRO
                    if (QuestionsModel.ModelId == 13)
                    {
                        return CalculateHydroScore(grouped, total);
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
        /// Special case for HYDRO, where the scores need to be grouped 
        /// by impact severity and have a double for the score.
        /// </summary>
        private Score CalculateHydroScore(IEnumerable<GroupedOptions> grouped, decimal total)
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



        //private void XXX(List<FlatOption> options)
        //{
        //    var o1 = new FlatOption() {
        //        OptionId = 1,
        //        OptionText = "Hey there",
        //        Weight = 
        //    };

        //    options.Add(o1);
        //}

        /// <summary>
        /// 
        /// </summary>
        /// <param name="questions"></param>
        private void FlattenOptions(List<Model.Nested.Question> questions)
        {
            foreach (var q in questions)
            {
                allWeights.AddRange(q.Options.Select(x => new FlatOption
                {
                    QuestionId = q.QuestionId,
                    QuestionText = q.QuestionText,
                    OptionId = x.OptionId,
                    OptionText = x.OptionText,
                    Weight = x.Weight,
                    Selected = x.Selected,
                    Type = x.OptionType,
                    ThreatType = x.ThreatType

                }).ToList());

                foreach (var o in q.Options)
                {
                    if (o.Followups.Any())
                    {
                        FlattenOptions(o.Followups);
                    }
                }

                if (q.Followups.Any())
                {
                    FlattenOptions(q.Followups);
                }

                if (q.Options.Count == 0 && q.QuestionType == "min-hr-day")
                {
                    var hrMinDay = 1;
                }
            }
        }
    }
}
