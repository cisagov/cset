////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Analysis;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;

namespace CSETWebCore.Business.Results
{
    /// <summary>
    /// Extension methods for CSETContext related to results analysis.
    /// </summary>
    public static class CsetContextExtensions
    {
        /// <summary>
        /// Gets combined answer distribution statistics for an assessment.
        /// LINQ equivalent of GetCombinedOveralls stored procedure.
        /// Returns statistics for Overall, Requirement, Questions, Components, and Framework stat types.
        /// </summary>
        /// <param name="context">The database context</param>
        /// <param name="assessmentId">The assessment ID</param>
        /// <returns>List of GetCombinedOveralls with answer distribution statistics</returns>
        public static List<GetCombinedOveralls> GetCombinedOveralls(this CsetwebContext context, int assessmentId)
        {
            // 1. Get application mode
            var applicationMode = context.STANDARD_SELECTION
                .Where(x => x.Assessment_Id == assessmentId)
                .Select(x => x.Application_Mode)
                .FirstOrDefault();

            bool isQuestionsMode = string.IsNullOrEmpty(applicationMode) ||
                                   applicationMode.StartsWith("Questions", StringComparison.OrdinalIgnoreCase);
            string mode = isQuestionsMode ? "Q" : "R";

            // 2. Get standards answers (filtered by mode) - already scoped by the view
            var standardsAnswers = context.Answer_Standards_InScope
                .AsNoTracking()
                .Where(a => a.assessment_id == assessmentId && a.mode == mode)
                .Select(a => new AnswerRecord
                {
                    AnswerText = a.answer_text,
                    IsRequirement = a.is_requirement != 0,
                    IsComponent = a.is_component ?? false,
                    IsFramework = a.is_framework ?? false
                })
                .ToList();

            // 3. Get component answers
            var componentAnswers = context.Answer_Components
                .AsNoTracking()
                .Where(a => a.Assessment_Id == assessmentId)
                .Select(a => new AnswerRecord
                {
                    AnswerText = a.Answer_Text,
                    IsRequirement = a.Is_Requirement ?? false,
                    IsComponent = a.Is_Component ?? false,
                    IsFramework = a.Is_Framework ?? false
                })
                .ToList();

            // 4. Combine all answers (standards + components)
            var allAnswers = standardsAnswers.Concat(componentAnswers).ToList();

            // 5. Compute statistics for each stat type
            var results = new List<GetCombinedOveralls>();

            // Overall - all answers
            results.Add(ComputeStatistics("Overall", allAnswers));

            // Requirement - only requirement answers (from standards)
            var requirementAnswers = standardsAnswers.Where(a => a.IsRequirement).ToList();
            results.Add(ComputeStatistics("Requirement", requirementAnswers));

            // Questions - only question answers (from standards, not requirements, not components)
            var questionAnswers = standardsAnswers.Where(a => !a.IsRequirement && !a.IsComponent).ToList();
            results.Add(ComputeStatistics("Questions", questionAnswers));

            // Components - only component answers
            results.Add(ComputeStatistics("Components", componentAnswers));

            // Framework - only framework answers (from all)
            var frameworkAnswers = allAnswers.Where(a => a.IsFramework).ToList();
            results.Add(ComputeStatistics("Framework", frameworkAnswers));

            return results.OrderBy(r => r.StatType).ToList();
        }

        /// <summary>
        /// Helper class to hold answer record data.
        /// </summary>
        private class AnswerRecord
        {
            public string AnswerText { get; set; }
            public bool IsRequirement { get; set; }
            public bool IsComponent { get; set; }
            public bool IsFramework { get; set; }
        }

        /// <summary>
        /// Computes answer distribution statistics for a given stat type and set of answers.
        /// </summary>
        private static GetCombinedOveralls ComputeStatistics(string statType, List<AnswerRecord> answers)
        {
            var total = answers.Count;

            // Count each answer type
            var yCount = answers.Count(a => a.AnswerText == "Y");
            var nCount = answers.Count(a => a.AnswerText == "N");
            var naCount = answers.Count(a => a.AnswerText == "NA");
            var aCount = answers.Count(a => a.AnswerText == "A");
            var uCount = answers.Count(a => a.AnswerText == "U");

            // Calculate percentages (rounded to nearest integer)
            int yPct = total > 0 ? (int)Math.Round((double)yCount / total * 100) : 0;
            int nPct = total > 0 ? (int)Math.Round((double)nCount / total * 100) : 0;
            int naPct = total > 0 ? (int)Math.Round((double)naCount / total * 100) : 0;
            int aPct = total > 0 ? (int)Math.Round((double)aCount / total * 100) : 0;
            int uPct = total > 0 ? (int)Math.Round((double)uCount / total * 100) : 0;

            // Calculate compliance value: (Y + A) / (Total - NA) * 100
            var totalNoNa = total - naCount;
            double value = totalNoNa > 0 ? ((double)(yCount + aCount) / totalNoNa) * 100 : 0;

            return new GetCombinedOveralls
            {
                StatType = statType,
                Total = total,
                Y = yPct,
                N = nPct,
                NA = naPct,
                A = aPct,
                U = uPct,
                YCount = yCount,
                NCount = nCount,
                NACount = naCount,
                ACount = aCount,
                UCount = uCount,
                Value = value,
                TotalNoNA = totalNoNa
            };
        }
    }
}
