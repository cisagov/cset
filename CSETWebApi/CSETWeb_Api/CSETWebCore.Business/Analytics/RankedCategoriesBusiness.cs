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
using System.Threading.Tasks;

namespace CSETWebCore.Business.Analytics
{
    /// <summary>
    /// Provides ranked categories analysis functionality.
    /// Replaces usp_GetRankedCategoriesPage and RankedCategories stored procedures.
    /// </summary>
    public class RankedCategoriesBusiness
    {
        private readonly CSETContext _context;

        public RankedCategoriesBusiness(CSETContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Gets the ranked categories data for an assessment.
        /// This replaces the usp_GetRankedCategoriesPage and RankedCategories stored procedures.
        /// Note: FillEmptyQuestionsForAnalysis should be called before this method (done in AnalysisController constructor).
        /// </summary>
        /// <param name="assessmentId">The assessment ID</param>
        /// <returns>List of RankedCategories containing ranked category data</returns>
        public async Task<List<RankedCategories>> GetRankedCategoriesAsync(int assessmentId)
        {
            // Get application mode
            var applicationMode = await GetApplicationModeAsync(assessmentId);

            if (applicationMode == "Questions Based")
            {
                return await GetRankedCategoriesForQuestionsAsync(assessmentId);
            }
            else
            {
                return await GetRankedCategoriesForRequirementsAsync(assessmentId);
            }
        }

        /// <summary>
        /// Gets the application mode for the assessment.
        /// </summary>
        private async Task<string> GetApplicationModeAsync(int assessmentId)
        {
            var mode = await _context.STANDARD_SELECTION
                .AsNoTracking()
                .Where(s => s.Assessment_Id == assessmentId)
                .Select(s => s.Application_Mode)
                .FirstOrDefaultAsync();

            return mode ?? "Questions Based";
        }

        /// <summary>
        /// Gets ranked categories for Questions Based mode.
        /// </summary>
        private async Task<List<RankedCategories>> GetRankedCategoriesForQuestionsAsync(int assessmentId)
        {
            // Get the selected SAL level
            var standardSelection = await _context.STANDARD_SELECTION
                .AsNoTracking()
                .Where(s => s.Assessment_Id == assessmentId)
                .Select(s => new { s.Selected_Sal_Level })
                .FirstOrDefaultAsync();

            var selectedSalLevel = standardSelection?.Selected_Sal_Level ?? "L";

            // Get the universal SAL level for the selected SAL
            var universalSalLevel = await _context.UNIVERSAL_SAL_LEVEL
                .AsNoTracking()
                .Where(u => u.Full_Name_Sal == selectedSalLevel)
                .Select(u => u.Universal_Sal_Level1)
                .FirstOrDefaultAsync() ?? "L";

            // Get distinct question IDs in scope (selected standards at selected SAL level)
            var questionsInScope = await (
                from nqs in _context.NEW_QUESTION_SETS.AsNoTracking()
                join avs in _context.AVAILABLE_STANDARDS.AsNoTracking() on nqs.Set_Name equals avs.Set_Name
                join nql in _context.NEW_QUESTION_LEVELS.AsNoTracking() on nqs.New_Question_Set_Id equals nql.New_Question_Set_Id
                where avs.Assessment_Id == assessmentId
                      && avs.Selected
                      && nql.Universal_Sal_Level == universalSalLevel
                select nqs.Question_Id
            ).Distinct().ToListAsync();

            if (!questionsInScope.Any())
            {
                return new List<RankedCategories>();
            }

            // Get max ranking from questions in scope
            var maxRank = await _context.NEW_QUESTION
                .AsNoTracking()
                .Where(q => questionsInScope.Contains(q.Question_Id))
                .MaxAsync(q => (int?)q.Ranking) ?? 0;

            // Get category totals (all non-NA answers)
            var categoryTotals = await (
                from aq in _context.Answer_Questions.AsNoTracking()
                join nq in _context.NEW_QUESTION.AsNoTracking() on aq.Question_Or_Requirement_Id equals nq.Question_Id
                join vh in _context.vQUESTION_HEADINGS.AsNoTracking() on nq.Heading_Pair_Id equals vh.Heading_Pair_Id
                where aq.Assessment_Id == assessmentId
                      && questionsInScope.Contains(nq.Question_Id)
                      && aq.Answer_Text != "NA"
                group new { nq, maxRank } by new { vh.Question_Group_Heading, vh.Question_Group_Heading_Id } into g
                select new
                {
                    g.Key.Question_Group_Heading,
                    g.Key.Question_Group_Heading_Id,
                    qc = g.Count(),
                    cr = g.Sum(x => maxRank - (x.nq.Ranking ?? 0))
                }
            ).ToListAsync();

            // Calculate overall total
            var total = categoryTotals.Sum(c => c.cr);

            // Get answered counts (N or U answers only)
            var answeredCounts = await (
                from aq in _context.Answer_Questions.AsNoTracking()
                join nq in _context.NEW_QUESTION.AsNoTracking() on aq.Question_Or_Requirement_Id equals nq.Question_Id
                join vh in _context.vQUESTION_HEADINGS.AsNoTracking() on nq.Heading_Pair_Id equals vh.Heading_Pair_Id
                where aq.Assessment_Id == assessmentId
                      && questionsInScope.Contains(nq.Question_Id)
                      && (aq.Answer_Text == "N" || aq.Answer_Text == "U")
                group new { nq, maxRank } by new { vh.Question_Group_Heading, vh.Question_Group_Heading_Id } into g
                select new
                {
                    g.Key.Question_Group_Heading,
                    g.Key.Question_Group_Heading_Id,
                    nuCount = g.Count(),
                    cr = g.Sum(x => maxRank - (x.nq.Ranking ?? 0))
                }
            ).ToListAsync();

            // Join and compute results
            var results = (
                from t in categoryTotals
                join a in answeredCounts on t.Question_Group_Heading equals a.Question_Group_Heading into aj
                from a in aj.DefaultIfEmpty()
                let nuCount = a?.nuCount ?? 0
                let actualCr = a?.cr ?? 0
                let prc = total > 0 ? (decimal)actualCr / total * 100 : 0
                let percent = t.qc > 0 ? (decimal)nuCount / t.qc : 0
                orderby prc descending
                select new RankedCategories
                {
                    Question_Group_Heading = t.Question_Group_Heading,
                    QGH_Id = t.Question_Group_Heading_Id,
                    qc = t.qc,
                    cr = t.cr,
                    Total = total,
                    nuCount = nuCount,
                    Actualcr = actualCr,
                    prc = Math.Round(prc, 3),
                    Percent = Math.Round(percent, 3)
                }
            ).ToList();

            return results;
        }

        /// <summary>
        /// Gets ranked categories for Requirements Based mode.
        /// </summary>
        private async Task<List<RankedCategories>> GetRankedCategoriesForRequirementsAsync(int assessmentId)
        {
            // Get distinct requirement IDs in scope (selected standards)
            var requirementsInScope = await (
                from rs in _context.REQUIREMENT_SETS.AsNoTracking()
                join avs in _context.AVAILABLE_STANDARDS.AsNoTracking() on rs.Set_Name equals avs.Set_Name
                where avs.Assessment_Id == assessmentId && avs.Selected
                select rs.Requirement_Id
            ).Distinct().ToListAsync();

            if (!requirementsInScope.Any())
            {
                return new List<RankedCategories>();
            }

            // Get max ranking from requirements in scope
            var maxRank = await _context.NEW_REQUIREMENT
                .AsNoTracking()
                .Where(r => requirementsInScope.Contains(r.Requirement_Id))
                .MaxAsync(r => (int?)r.Ranking) ?? 0;

            // Get category totals (all answers)
            var categoryTotals = await (
                from ar in _context.Answer_Requirements.AsNoTracking()
                join nr in _context.NEW_REQUIREMENT.AsNoTracking() on ar.Question_Or_Requirement_Id equals nr.Requirement_Id
                join qgh in _context.QUESTION_GROUP_HEADING.AsNoTracking() on nr.Question_Group_Heading_Id equals qgh.Question_Group_Heading_Id
                where ar.Assessment_Id == assessmentId
                      && requirementsInScope.Contains(nr.Requirement_Id)
                group new { nr, maxRank } by new { qgh.Question_Group_Heading1, qgh.Question_Group_Heading_Id } into g
                select new
                {
                    Question_Group_Heading = g.Key.Question_Group_Heading1,
                    Question_Group_Heading_Id = g.Key.Question_Group_Heading_Id,
                    qc = g.Count(),
                    cr = g.Sum(x => maxRank - (x.nr.Ranking ?? 0))
                }
            ).ToListAsync();

            // Calculate overall total
            var total = categoryTotals.Sum(c => c.cr);

            // Compute results (requirements mode doesn't calculate nuCount/Actualcr/Percent in the original SP)
            var results = (
                from t in categoryTotals
                let prc = total > 0 ? (decimal)t.cr / total * 100 : 0
                orderby prc descending
                select new RankedCategories
                {
                    Question_Group_Heading = t.Question_Group_Heading,
                    QGH_Id = t.Question_Group_Heading_Id,
                    qc = t.qc,
                    cr = t.cr,
                    Total = total,
                    nuCount = null,
                    Actualcr = null,
                    prc = Math.Round(prc, 3),
                    Percent = null
                }
            ).ToList();

            return results;
        }
    }
}
