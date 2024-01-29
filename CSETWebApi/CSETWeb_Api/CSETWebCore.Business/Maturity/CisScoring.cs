//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Diagnostics.Metrics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Nested;
using DocumentFormat.OpenXml.Drawing;

namespace CSETWebCore.Business.Maturity
{
    public class CisScoring
    {
        /// <summary>
        /// The structured model for a section/category in CIS.
        /// </summary>
        public NestedQuestions QuestionsModel;

        private List<FlatOption> allWeights = new();

        private List<Model.Nested.Question> allDurationQuestions = new();


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
                    var grouped = allWeights.GroupBy(q => q.QuestionText).Select(r => new GroupedOptions
                    {
                        QuestionText = r.Key,
                        OptionQuestions = r.ToList()
                    });


                    // achieved weight points
                    var qAchieved = from g in grouped
                                    select new RollupOptions()
                                    {
                                        Type = g.OptionQuestions.FirstOrDefault().Type,
                                        Weight = g.OptionQuestions.FirstOrDefault().Type != "radio"
                                            ? g.OptionQuestions.Where(s => s.Selected).Sum(x => x.Weight)
                                            : g.OptionQuestions.FirstOrDefault(s => s.Selected)?.Weight
                                    };
                    var achievedWeights = qAchieved.ToList();

                    // possible weight points
                    var qPossible = from g in grouped
                                    select new RollupOptions
                                    {
                                        Type = g.OptionQuestions.FirstOrDefault().Type,
                                        Weight = g.OptionQuestions.FirstOrDefault().Type != "radio"
                                            ? g.OptionQuestions.Sum(x => x.Weight) : g.OptionQuestions.MaxBy(x => x.Weight)?.Weight
                                    };
                    var possibleWeights = qPossible.ToList();


                    // include duration question scores
                    AddScoreForDurationQuestions(achievedWeights, possibleWeights);


                    var sumAchievedWeights = (decimal)achievedWeights.Sum(x => x?.Weight);
                    var sumPossibleWeights = (decimal)possibleWeights.Sum(x => x.Weight);

                    decimal total = sumPossibleWeights != 0 ? sumAchievedWeights / sumPossibleWeights : 0;


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

                // save duration questions to their own collection
                if (q.QuestionType?.ToLower() == "min-hr-day")
                {
                    allDurationQuestions.Add(q);
                }
            }
        }


        /// <summary>
        /// This method calculates a score based on a duration and 
        /// adds it to the lists of RollupOptions containing the other "option-based" questions.
        /// 
        /// Currently the "possible" score is set to 100.
        /// 
        /// This makes it easy to sum up the two lists to determine the total score.
        /// </summary>
        private void AddScoreForDurationQuestions(List<RollupOptions> ach, List<RollupOptions> poss)
        {
            foreach (var q in allDurationQuestions)
            {
                decimal weightScore = 0;

                // calculate the number of hours of duration
                var hours = GetHours(q.AnswerMemo);


                // Get the threshold for this question
                DurationThreshold threshold = thresholds.TryGetValue(q.QuestionId, out DurationThreshold value) ? value : null;

                if (hours != null)
                {
                    if (threshold == null)
                    {
                        weightScore = 0;
                    }
                    else
                    {
                        var ratio = hours / threshold.DurationHours;


                        if (threshold.ShorterIsBetter)
                        {
                            // Give better scores for lower ratios.  
                            weightScore = 100 - (decimal)(ratio * 100);
                            if (weightScore < 0)
                            {
                                weightScore = 0;
                            }
                        }
                        else
                        {
                            // Longer is better.  Higher scores for higher ratios.
                            weightScore = (decimal)(ratio * 100);
                            if (weightScore > 100)
                            {
                                weightScore = 100;
                            }
                        }
                    }
                }


                // the "Type" added to these "options" is informational and doesn't affect any logic

                // achieved
                var achievedScore = new RollupOptions()
                {
                    Type = "min-hr-day",
                    Weight = weightScore
                };
                ach.Add(achievedScore);


                // possible
                var possibleScore = new RollupOptions()
                {
                    Type = "min-hr-day",
                    Weight = 100
                };
                poss.Add(possibleScore);
            }
        }


        /// <summary>
        /// Duration question threshold values.
        /// 
        /// Until we find an elegant place to store these thresholds in the database
        /// they live here.  There are only 13 questions that have this type of scoring.
        /// </summary>
        private readonly Dictionary<int, DurationThreshold> thresholds = new()
        {
            { 6019, new DurationThreshold(435.8, false) },
            { 6182, new DurationThreshold(12.4, true) },
            { 6183, new DurationThreshold(8.00, true) },
            { 6071, new DurationThreshold(5.66, false) },
            { 6074, new DurationThreshold(12.4, true) },
            { 6078, new DurationThreshold(5.84, false) },
            { 6083, new DurationThreshold(12.4, true) },
            { 6088, new DurationThreshold(5.84, false) },
            { 6093, new DurationThreshold(12.4, true) },
            { 6094, new DurationThreshold(5.85, false) },
            { 6185, new DurationThreshold(12.4, true) },
            { 6100, new DurationThreshold(6.24, false) },
            { 6104, new DurationThreshold(13.4, true) }
        };


        /// <summary>
        /// Parses a string like 8|day where the unit is min, hr or day
        /// and converts the numeric part to hours.
        /// 
        /// If the string is not parseable as such, returns null to the consumer.
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        private static double? GetHours(string s)
        {
            if (s == null)
            {
                return null;
            }

            if (!s.Contains('|'))
            {
                return null;
            }

            double hours = 0;

            var segments = s.Split('|');

            double number = 0;
            double.TryParse(segments[0], out number);

            var unit = segments[1].ToLower();

            switch (unit.ToLower())
            {
                case "min":
                    hours = number / 60.0;
                    break;
                case "hr":
                    hours = number;
                    break;
                case "day":
                    hours = number * 24.0;
                    break;
                default:
                    return null;
            }

            return hours;
        }
    }
}
