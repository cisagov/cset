////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Aggregation;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Analytics
{
    /// <summary>
    /// Provides overall standards summary analysis functionality.
    /// Replaces usp_getStandardSummaryOverall stored procedure.
    /// </summary>
    public class StandardSummaryOverallBusiness
    {
        private readonly CSETContext _context;

        public StandardSummaryOverallBusiness(CSETContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Gets the overall standards summary data for an assessment.
        /// Returns answer counts and percentages for each answer type (Y, N, NA, A, U).
        /// </summary>
        /// <param name="assessmentId">The assessment ID</param>
        /// <returns>List of StandardSummaryOverallResult containing answer distribution</returns>
        public async Task<List<StandardSummaryOverallResult>> GetStandardSummaryOverallAsync(int assessmentId)
        {
            // Call FillEmptyQuestionsForAnalysis (this is still needed)
            _context.FillEmptyQuestionsForAnalysis(assessmentId);

            // Get application mode and SAL level
            var standardSelection = await _context.STANDARD_SELECTION
                .AsNoTracking()
                .Where(s => s.Assessment_Id == assessmentId)
                .Select(s => new { s.Application_Mode, s.Selected_Sal_Level })
                .FirstOrDefaultAsync();

            var applicationMode = standardSelection?.Application_Mode ?? "Questions Based";
            var selectedSalLevel = standardSelection?.Selected_Sal_Level ?? "L";

            // Get the universal SAL level for the selected SAL
            var universalSalLevel = await _context.UNIVERSAL_SAL_LEVEL
                .AsNoTracking()
                .Where(u => u.Full_Name_Sal == selectedSalLevel)
                .Select(u => u.Universal_Sal_Level1)
                .FirstOrDefaultAsync() ?? "L";

            // Get all answer lookup values
            var answerLookups = await _context.ANSWER_LOOKUP
                .AsNoTracking()
                .Select(a => new { a.Answer_Text, a.Answer_Full_Name })
                .ToListAsync();

            // Get answer counts based on mode
            Dictionary<string, int> answerCounts;
            if (applicationMode == "Questions Based")
            {
                answerCounts = await GetQuestionBasedAnswerCountsAsync(assessmentId, universalSalLevel);
            }
            else
            {
                answerCounts = await GetRequirementsBasedAnswerCountsAsync(assessmentId, universalSalLevel);
            }

            // Add component answer counts
            var componentCounts = await GetComponentAnswerCountsAsync(assessmentId);
            foreach (var kvp in componentCounts)
            {
                if (answerCounts.ContainsKey(kvp.Key))
                {
                    answerCounts[kvp.Key] += kvp.Value;
                }
                else
                {
                    answerCounts[kvp.Key] = kvp.Value;
                }
            }

            // Calculate total
            var total = answerCounts.Values.Sum();

            // Build the result with all answer types from ANSWER_LOOKUP
            var results = answerLookups.Select(a =>
            {
                var qc = answerCounts.TryGetValue(a.Answer_Text, out var count) ? count : 0;
                return new StandardSummaryOverallResult
                {
                    Answer_Full_Name = a.Answer_Full_Name,
                    Answer_Text = a.Answer_Text,
                    qc = qc,
                    Total = total,
                    Percent = total > 0 ? (int)Math.Round((double)qc / total * 100, 0) : 0
                };
            }).ToList();

            return results;
        }

        /// <summary>
        /// Gets answer counts for Questions Based mode.
        /// </summary>
        private async Task<Dictionary<string, int>> GetQuestionBasedAnswerCountsAsync(int assessmentId, string universalSalLevel)
        {
            var answerCounts = await (
                from aq in _context.Answer_Questions.AsNoTracking()
                join nq in _context.NEW_QUESTION.AsNoTracking() on aq.Question_Or_Requirement_Id equals nq.Question_Id
                join nqs in _context.NEW_QUESTION_SETS.AsNoTracking() on nq.Question_Id equals nqs.Question_Id
                join nql in _context.NEW_QUESTION_LEVELS.AsNoTracking() on nqs.New_Question_Set_Id equals nql.New_Question_Set_Id
                join avs in _context.AVAILABLE_STANDARDS.AsNoTracking() on nqs.Set_Name equals avs.Set_Name
                where aq.Assessment_Id == assessmentId
                      && avs.Assessment_Id == assessmentId
                      && avs.Selected
                      && nql.Universal_Sal_Level == universalSalLevel
                      && aq.Is_Requirement == 0
                group aq by aq.Answer_Text into g
                select new { Answer_Text = g.Key, Count = g.Select(x => x.Question_Or_Requirement_Id).Distinct().Count() }
            ).ToListAsync();

            return answerCounts.ToDictionary(x => x.Answer_Text, x => x.Count);
        }

        /// <summary>
        /// Gets answer counts for Requirements Based mode.
        /// </summary>
        private async Task<Dictionary<string, int>> GetRequirementsBasedAnswerCountsAsync(int assessmentId, string universalSalLevel)
        {
            var answerCounts = await (
                from ar in _context.Answer_Requirements.AsNoTracking()
                join nr in _context.NEW_REQUIREMENT.AsNoTracking() on ar.Question_Or_Requirement_Id equals nr.Requirement_Id
                join rs in _context.REQUIREMENT_SETS.AsNoTracking() on nr.Requirement_Id equals rs.Requirement_Id
                join rl in _context.REQUIREMENT_LEVELS.AsNoTracking() on nr.Requirement_Id equals rl.Requirement_Id
                join avs in _context.AVAILABLE_STANDARDS.AsNoTracking() on rs.Set_Name equals avs.Set_Name
                where ar.Assessment_Id == assessmentId
                      && avs.Assessment_Id == assessmentId
                      && avs.Selected
                      && rl.Standard_Level == universalSalLevel
                group ar by ar.Answer_Text into g
                select new { Answer_Text = g.Key, Count = g.Select(x => x.Question_Or_Requirement_Id).Distinct().Count() }
            ).ToListAsync();

            return answerCounts.ToDictionary(x => x.Answer_Text, x => x.Count);
        }

        /// <summary>
        /// Gets answer counts for Component questions.
        /// Component questions are not filtered by SAL level.
        /// </summary>
        private async Task<Dictionary<string, int>> GetComponentAnswerCountsAsync(int assessmentId)
        {
            var answerCounts = await _context.ANSWER
                .AsNoTracking()
                .Where(a => a.Assessment_Id == assessmentId && a.Question_Type == "Component")
                .GroupBy(a => a.Answer_Text)
                .Select(g => new { Answer_Text = g.Key, Count = g.Count() })
                .ToListAsync();

            return answerCounts.ToDictionary(x => x.Answer_Text, x => x.Count);
        }
    }
}
