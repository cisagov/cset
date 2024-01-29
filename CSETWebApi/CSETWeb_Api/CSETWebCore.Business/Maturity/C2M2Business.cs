//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Helpers;
using CSETWebCore.Model;
using CSETWebCore.Model.C2M2.Charts;
using CSETWebCore.Model.C2M2.Tables;
using CSETWebCore.Model.Nested;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace CSETWebCore.Business.Maturity
{
    public class C2M2Business
    {

        #region donuts and heatmaps

        /// <summary>
        /// Create the data structure that will populate the 
        /// donut charts for each Objective and the Practice 
        /// heatmaps for each Domain.
        /// </summary>
        /// <returns></returns>
        public List<Model.C2M2.Charts.Domain> DonutsAndHeatmap(MaturityStructureForModel model)
        {
            var response = new List<CSETWebCore.Model.C2M2.Charts.Domain>();

            int sequence = 0;

            foreach (Grouping domain in model.Model.Groupings.Where(x => x.GroupType == "Domain"))
            {
                var d = new Model.C2M2.Charts.Domain()
                {
                    Title = domain.Title,
                    ShortTitle = domain.Abbreviation,
                    Sequence = ++sequence,
                    Description = domain.Description
                };

                response.Add(d);

                InitializeDomainMilRollups(d);

                foreach (Grouping objective in domain.Groupings)
                {
                    var o = new Model.C2M2.Charts.Objective()
                    {
                        Title = objective.Title,
                        FI = objective.Questions.Count(x => x.AnswerText == "FI"),
                        LI = objective.Questions.Count(x => x.AnswerText == "LI"),
                        PI = objective.Questions.Count(x => x.AnswerText == "PI"),
                        NI = objective.Questions.Count(x => x.AnswerText == "NI"),
                        U = objective.Questions.Count(x => (x.AnswerText == "U" || x.AnswerText == null))
                    };

                    d.Objectives.Add(o);


                    // Build the heatmap rows by MIL for all questions in the domain
                    foreach (var q in objective.Questions)
                    {
                        var milRow = d.HeatmapRows.FirstOrDefault(x => x.Title == q.MaturityLevelName);

                        if (milRow == null)
                        {
                            milRow = new HeatmapRow()
                            {
                                Title = q.MaturityLevelName
                            };

                            d.HeatmapRows.Add(milRow);
                        }

                        milRow.Practices.Add(CreatePractice(q));


                        // add the answer to the rollup counts
                        var rollup = d.DomainMilRollup.First(x => x.MilName == q.MaturityLevelName);
                        switch (q.AnswerText)
                        {
                            case "FI":
                                rollup.FI++;
                                break;
                            case "LI":
                                rollup.LI++;
                                break;
                            case "PI":
                                rollup.PI++;
                                break;
                            case "NI":
                                rollup.NI++;
                                break;
                            default:
                                rollup.U++;
                                break;
                        }
                    }
                }

                // Now that the Domain rollups are populated, determine its achieved MIL level
                bool precedingMilAchieved = true;
                for (int i = 0; i < d.DomainMilRollup.Count(); i++)
                {
                    var r = d.DomainMilRollup[i];

                    // add the previous MIL level's totals to this one
                    if (i > 0)
                    {
                        r.FI += d.DomainMilRollup[i - 1].FI;
                        r.LI += d.DomainMilRollup[i - 1].LI;
                        r.PI += d.DomainMilRollup[i - 1].PI;
                        r.NI += d.DomainMilRollup[i - 1].NI;
                        r.U += d.DomainMilRollup[i - 1].U;
                    }

                    if (precedingMilAchieved && (r.PI + r.NI + r.U == 0) && (r.FI + r.LI > 0))
                    {
                        d.MilAchieved = r.Level;
                    }
                    else
                    {
                        precedingMilAchieved = false;
                    }
                }
            }

            return response;
        }


        /// <summary>
        /// Create an empty rollup object for each MIL level 1-3.  
        /// </summary>
        /// <param name="d"></param>
        private void InitializeDomainMilRollups(Model.C2M2.Charts.Domain d)
        {
            for (var i = 1; i <= 3; i++)
            {
                d.DomainMilRollup.Add(new MilRollup()
                {
                    Level = i,
                    MilName = $"MIL-{i}"
                });
            }
        }


        /// <summary>
        /// Creates a single heatmap practice element.
        /// </summary>
        /// <param name="q"></param>
        /// <returns></returns>
        private HeatmapPractice CreatePractice(Model.Nested.Question q)
        {
            var shortNumber = q.DisplayNumber.Contains('-') ? q.DisplayNumber.Split('-').Last() : q.DisplayNumber;
            return new HeatmapPractice()
            {
                Number = shortNumber,
                Answer = q.AnswerText
            };
        }

        #endregion


        #region question tables


        /// <summary>
        /// Reformats the structure object into a simpler format
        /// for the question/answer tables in the C2M2 report.
        /// </summary>
        public QuestionTablesResponse QuestionTables(MaturityStructureForModel model)
        {
            var response = new QuestionTablesResponse();

            response.DomainList = new List<Model.C2M2.Tables.Domain>();

            int sequence = 0;
            foreach (Grouping domain in model.Model.Groupings.Where(x => x.GroupType == "Domain"))
            {
                var d = new Model.C2M2.Tables.Domain()
                {
                    Title = domain.Title,
                    Sequence = ++sequence
                };

                response.DomainList.Add(d);

                foreach (Grouping objective in domain.Groupings)
                {
                    var o = new Model.C2M2.Tables.Objective()
                    {
                        Title = objective.Title
                    };

                    d.Objectives.Add(o);

                    foreach (var practice in objective.Questions)
                    {
                        var p = new Model.C2M2.Tables.Practice()
                        {
                            Title = practice.DisplayNumber,
                            QuestionText = DeGlossary(practice.QuestionText),
                            AnswerText = practice.AnswerText,
                            Comment = practice.Comment,
                            Mil = practice.MaturityLevelName
                        };

                        o.Practices.Add(p);
                    }
                }
            }

            response.ManagementQuestions = TabularizeManagementActivities(model);

            return response;
        }


        /// <summary>
        /// Remove glossary term markup from text.
        /// </summary>
        /// <param name="text"></param>
        /// <returns></returns>
        private string DeGlossary(string text)
        {
            var sb = new StringBuilder();

            var delim = '\x1f';
            var t = text.Replace("[[", $"{delim}[[").Replace("]]", $"]]{delim}");
            var chunks = t.Split(delim);

            foreach (var chunk in chunks)
            {
                var c = chunk;

                if (c.StartsWith("[[") && c.EndsWith("]]"))
                {
                    c = c.Replace("[[", "").Replace("]]", "");

                    if (c.Contains('|'))
                    {
                        c = c.Split('|').Last();
                    }
                }

                sb.Append(c);
            }

            return sb.ToString();
        }


        /// <summary>
        /// Returns an object with the six management activity questions and each domain's
        /// answer to those questions.
        /// </summary>
        private List<ManagementQuestions> TabularizeManagementActivities(MaturityStructureForModel model)
        {
            var response = new List<ManagementQuestions>();

            // this is hokey, but we currently don't store this "generic" version of the
            // management activity questions anywhere.  And trying to parse one of the domain-specific
            // versions will be difficult if the questions are not in English.
            var genericMaintQuestions = new List<string>() {
                "Documented procedures are established, followed, and maintained for activities in the domain",
                "Adequate resources (people, funding, and tools) are provided to support activities in the domain",
                "Up-to-date policies or other organizational directives define requirements for activities in the domain",
                "Responsibility, accountability, and authority for the performance of activities in the domain are assigned to personnel",
                "Personnel performing activities in the domain have the skills and knowledge needed to perform their assigned responsibilities",
                "The effectiveness of activities in the domain is evaluated and tracked"
            };

            for (int i = 0; i < genericMaintQuestions.Count(); i++)
            {
                response.Add(new ManagementQuestions()
                {
                    QuestionText = genericMaintQuestions[i]
                });
            }

            // build the questions, parse out the domain name from the text
            var domains = model.Model.Groupings.Where(x => x.GroupType == "Domain").ToList();

            for (int i = 0; i < domains.Count(); i++)
            {
                var d = domains[i];
                var maintObjective = d.Groupings.Last();

                for (int j = 0; j < maintObjective.Questions.Count(); j++)
                {
                    var q = maintObjective.Questions[j];
                    response[j].DomainAnswers.Add(new ManagementDomain() { DomainShortName = d.Abbreviation, Answer = q.AnswerText });
                }
            }

            return response;
        }


        #endregion

    }




}
