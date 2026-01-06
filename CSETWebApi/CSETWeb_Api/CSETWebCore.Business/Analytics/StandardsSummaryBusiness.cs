////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Analysis;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Analytics
{
    /// <summary>
    /// Provides standards summary analysis functionality.
    /// Replaces usp_GetStandardsSummaryPage and usp_getStandardsSummary stored procedures.
    /// </summary>
    public class StandardsSummaryBusiness
    {
        private readonly CSETContext _context;

        public StandardsSummaryBusiness(CSETContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Gets the standards summary data for an assessment.
        /// This replaces the usp_GetStandardsSummaryPage stored procedure.
        /// </summary>
        /// <param name="assessmentId">The assessment ID</param>
        /// <returns>List of DataRowsPie containing answer distribution by standard</returns>
        public async Task<List<DataRowsPie>> GetStandardsSummaryAsync(int assessmentId)
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

            if (applicationMode == "Questions Based")
            {
                return await GetQuestionBasedSummaryAsync(assessmentId, universalSalLevel);
            }
            else
            {
                return await GetRequirementsBasedSummaryAsync(assessmentId, universalSalLevel);
            }
        }

        /// <summary>
        /// Gets standards summary for Questions Based mode.
        /// </summary>
        private async Task<List<DataRowsPie>> GetQuestionBasedSummaryAsync(int assessmentId, string universalSalLevel)
        {
            // Get available (selected) standards with their short names
            var availableStandards = await (
                from avs in _context.AVAILABLE_STANDARDS.AsNoTracking()
                join s in _context.SETS.AsNoTracking() on avs.Set_Name equals s.Set_Name
                where avs.Assessment_Id == assessmentId && avs.Selected
                select new { avs.Set_Name, s.Short_Name }
            ).ToListAsync();

            // Get all answer lookup values
            var answerLookups = await _context.ANSWER_LOOKUP
                .AsNoTracking()
                .Select(a => new { a.Answer_Text, a.Answer_Full_Name })
                .ToListAsync();

            // Create a cross join of standards and answer types
            var standardAnswerCombinations = (
                from standard in availableStandards
                from answer in answerLookups
                select new { standard.Set_Name, standard.Short_Name, answer.Answer_Text, answer.Answer_Full_Name }
            ).ToList();

            // Get total questions per standard at the selected SAL level
            var totalsByStandard = await (
                from nq in _context.NEW_QUESTION.AsNoTracking()
                join nqs in _context.NEW_QUESTION_SETS.AsNoTracking() on nq.Question_Id equals nqs.Question_Id
                join nql in _context.NEW_QUESTION_LEVELS.AsNoTracking() on nqs.New_Question_Set_Id equals nql.New_Question_Set_Id
                join avs in _context.AVAILABLE_STANDARDS.AsNoTracking() on nqs.Set_Name equals avs.Set_Name
                join s in _context.SETS.AsNoTracking() on nqs.Set_Name equals s.Set_Name
                where avs.Assessment_Id == assessmentId
                      && avs.Selected
                      && nql.Universal_Sal_Level == universalSalLevel
                group nq by s.Short_Name into g
                select new { Short_Name = g.Key, TotalQuestions = g.Select(x => x.Question_Id).Distinct().Count() }
            ).ToListAsync();

            // Get answer counts per standard and answer type
            var answerCounts = await (
                from aq in _context.Answer_Questions.AsNoTracking()
                join nq in _context.NEW_QUESTION.AsNoTracking() on aq.Question_Or_Requirement_Id equals nq.Question_Id
                join nqs in _context.NEW_QUESTION_SETS.AsNoTracking() on nq.Question_Id equals nqs.Question_Id
                join nql in _context.NEW_QUESTION_LEVELS.AsNoTracking() on nqs.New_Question_Set_Id equals nql.New_Question_Set_Id
                join avs in _context.AVAILABLE_STANDARDS.AsNoTracking() on nqs.Set_Name equals avs.Set_Name
                join s in _context.SETS.AsNoTracking() on nqs.Set_Name equals s.Set_Name
                where aq.Assessment_Id == assessmentId
                      && avs.Assessment_Id == assessmentId
                      && avs.Selected
                      && nql.Universal_Sal_Level == universalSalLevel
                group aq by new { s.Short_Name, aq.Answer_Text } into g
                select new { g.Key.Short_Name, g.Key.Answer_Text, Count = g.Select(x => x.Question_Or_Requirement_Id).Count() }
            ).ToListAsync();

            // Build the result
            var results = (
                from combo in standardAnswerCombinations
                let total = totalsByStandard.FirstOrDefault(t => t.Short_Name == combo.Short_Name)?.TotalQuestions ?? 0
                let count = answerCounts.FirstOrDefault(c => c.Short_Name == combo.Short_Name && c.Answer_Text == combo.Answer_Text)?.Count ?? 0
                let percent = total > 0 ? (int)Math.Round((double)count / total * 100, 0) : 0
                orderby combo.Short_Name
                select new DataRowsPie
                {
                    Answer_Full_Name = combo.Answer_Full_Name,
                    Short_Name = combo.Short_Name,
                    Answer_Text = combo.Answer_Text,
                    qc = count,
                    Total = total,
                    Percent = percent
                }
            ).ToList();

            return results;
        }

        /// <summary>
        /// Gets standards summary for Requirements Based mode.
        /// </summary>
        private async Task<List<DataRowsPie>> GetRequirementsBasedSummaryAsync(int assessmentId, string universalSalLevel)
        {
            // Get available (selected) standards with their short names
            var availableStandards = await (
                from avs in _context.AVAILABLE_STANDARDS.AsNoTracking()
                join s in _context.SETS.AsNoTracking() on avs.Set_Name equals s.Set_Name
                where avs.Assessment_Id == assessmentId && avs.Selected
                select new { avs.Set_Name, s.Short_Name }
            ).ToListAsync();

            // Get all answer lookup values
            var answerLookups = await _context.ANSWER_LOOKUP
                .AsNoTracking()
                .Select(a => new { a.Answer_Text, a.Answer_Full_Name })
                .ToListAsync();

            // Create a cross join of standards and answer types
            var standardAnswerCombinations = (
                from standard in availableStandards
                from answer in answerLookups
                select new { standard.Set_Name, standard.Short_Name, answer.Answer_Text, answer.Answer_Full_Name }
            ).ToList();

            // Get total requirements per standard at the selected SAL level
            var totalsByStandard = await (
                from nr in _context.NEW_REQUIREMENT.AsNoTracking()
                join rs in _context.REQUIREMENT_SETS.AsNoTracking() on nr.Requirement_Id equals rs.Requirement_Id
                join rl in _context.REQUIREMENT_LEVELS.AsNoTracking() on nr.Requirement_Id equals rl.Requirement_Id
                join avs in _context.AVAILABLE_STANDARDS.AsNoTracking() on rs.Set_Name equals avs.Set_Name
                join s in _context.SETS.AsNoTracking() on rs.Set_Name equals s.Set_Name
                where avs.Assessment_Id == assessmentId
                      && avs.Selected
                      && rl.Standard_Level == universalSalLevel
                group nr by s.Short_Name into g
                select new { Short_Name = g.Key, TotalRequirements = g.Select(x => x.Requirement_Id).Distinct().Count() }
            ).ToListAsync();

            // Get answer counts per standard and answer type
            var answerCounts = await (
                from ar in _context.Answer_Requirements.AsNoTracking()
                join nr in _context.NEW_REQUIREMENT.AsNoTracking() on ar.Question_Or_Requirement_Id equals nr.Requirement_Id
                join rs in _context.REQUIREMENT_SETS.AsNoTracking() on nr.Requirement_Id equals rs.Requirement_Id
                join rl in _context.REQUIREMENT_LEVELS.AsNoTracking() on nr.Requirement_Id equals rl.Requirement_Id
                join avs in _context.AVAILABLE_STANDARDS.AsNoTracking() on rs.Set_Name equals avs.Set_Name
                join s in _context.SETS.AsNoTracking() on rs.Set_Name equals s.Set_Name
                where ar.Assessment_Id == assessmentId
                      && avs.Assessment_Id == assessmentId
                      && avs.Selected
                      && rl.Standard_Level == universalSalLevel
                group ar by new { s.Short_Name, ar.Answer_Text } into g
                select new { g.Key.Short_Name, g.Key.Answer_Text, Count = g.Select(x => x.Question_Or_Requirement_Id).Count() }
            ).ToListAsync();

            // Build the result
            var results = (
                from combo in standardAnswerCombinations
                let total = totalsByStandard.FirstOrDefault(t => t.Short_Name == combo.Short_Name)?.TotalRequirements ?? 0
                let count = answerCounts.FirstOrDefault(c => c.Short_Name == combo.Short_Name && c.Answer_Text == combo.Answer_Text)?.Count ?? 0
                let percent = total > 0 ? (int)Math.Round((double)count / total * 100, 0) : 0
                orderby combo.Short_Name
                select new DataRowsPie
                {
                    Answer_Full_Name = combo.Answer_Full_Name,
                    Short_Name = combo.Short_Name,
                    Answer_Text = combo.Answer_Text,
                    qc = count,
                    Total = total,
                    Percent = percent
                }
            ).ToList();

            return results;
        }
    }
}
