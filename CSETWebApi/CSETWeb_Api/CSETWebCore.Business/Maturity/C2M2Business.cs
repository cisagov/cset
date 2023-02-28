//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Helpers;
using CSETWebCore.Model.C2M2.Charts;
using CSETWebCore.Model.Cis;
using DocumentFormat.OpenXml.Drawing;
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
        public List<Domain> DonutsAndHeatmap(MaturityStructureForModel model)
        {
            var response = new List<Domain>();

            int sequence = 0;

            foreach (Grouping domain in model.Model.Groupings.Where(x => x.GroupType == "Domain"))
            {
                var d = new Domain()
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
                    var o = new Objective()
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
        private void InitializeDomainMilRollups(Domain d)
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
        private HeatmapPractice CreatePractice(Model.Cis.Question q)
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
        public List<Model.C2M2.Tables.Domain> QuestionTables(MaturityStructureForModel model)
        {
            int sequence = 0;

            var response = new List<Model.C2M2.Tables.Domain>();

            foreach (Grouping domain in model.Model.Groupings.Where(x => x.GroupType == "Domain"))
            {
                var d = new Model.C2M2.Tables.Domain()
                {
                    Title = domain.Title,
                    Sequence = ++sequence
                };

                response.Add(d);

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

        #endregion

    }
}
