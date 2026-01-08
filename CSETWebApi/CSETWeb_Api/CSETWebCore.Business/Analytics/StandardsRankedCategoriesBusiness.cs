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
    /// Provides standards ranked categories analysis functionality.
    /// Replaces StandardsRankedCategory stored procedure.
    /// </summary>
    public class StandardsRankedCategoriesBusiness
    {
        private readonly CSETContext _context;

        public StandardsRankedCategoriesBusiness(CSETContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Gets the standards ranked categories data for an assessment.
        /// This replaces the StandardsRankedCategory stored procedure.
        /// Note: FillEmptyQuestionsForAnalysis should be called before this method (done in AnalysisController constructor).
        /// </summary>
        /// <param name="assessmentId">The assessment ID</param>
        /// <returns>List of StandardsRankedCategory containing ranked category data</returns>
        public async Task<List<StandardsRankedCategory>> GetStandardsRankedCategoriesAsync(int assessmentId)
        {
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
        private async Task<List<StandardsRankedCategory>> GetRankedCategoriesForQuestionsAsync(int assessmentId)
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
                return new List<StandardsRankedCategory>();
            }

            // Get max ranking from questions in scope
            var maxRank = await _context.NEW_QUESTION
                .AsNoTracking()
                .Where(q => questionsInScope.Contains(q.Question_Id))
                .MaxAsync(q => (int?)q.Ranking) ?? 0;

            // Get category totals (all non-NA answers) grouped by Set_Name and Question_Group_Heading
            var categoryTotals = await (
                from aq in _context.Answer_Questions.AsNoTracking()
                join nq in _context.NEW_QUESTION.AsNoTracking() on aq.Question_Or_Requirement_Id equals nq.Question_Id
                join vh in _context.vQUESTION_HEADINGS.AsNoTracking() on nq.Heading_Pair_Id equals vh.Heading_Pair_Id
                join nqs in _context.NEW_QUESTION_SETS.AsNoTracking() on nq.Question_Id equals nqs.Question_Id
                join avs in _context.AVAILABLE_STANDARDS.AsNoTracking() on new { nqs.Set_Name, Assessment_Id = assessmentId } equals new { avs.Set_Name, avs.Assessment_Id }
                join nql in _context.NEW_QUESTION_LEVELS.AsNoTracking() on nqs.New_Question_Set_Id equals nql.New_Question_Set_Id
                where aq.Assessment_Id == assessmentId
                      && aq.Answer_Text != "NA"
                      && avs.Selected
                      && nql.Universal_Sal_Level == universalSalLevel
                group new { nq, maxRank } by new { avs.Set_Name, vh.Question_Group_Heading } into g
                select new
                {
                    g.Key.Set_Name,
                    g.Key.Question_Group_Heading,
                    qc = g.Count(),
                    cr = g.Sum(x => maxRank - (x.nq.Ranking ?? 0))
                }
            ).ToListAsync();

            // Calculate overall total
            var total = categoryTotals.Sum(c => c.cr);

            // Get answered counts (N or U answers only) grouped by Set_Name and Question_Group_Heading
            var answeredCounts = await (
                from aq in _context.Answer_Questions.AsNoTracking()
                join nq in _context.NEW_QUESTION.AsNoTracking() on aq.Question_Or_Requirement_Id equals nq.Question_Id
                join vh in _context.vQUESTION_HEADINGS.AsNoTracking() on nq.Heading_Pair_Id equals vh.Heading_Pair_Id
                join nqs in _context.NEW_QUESTION_SETS.AsNoTracking() on nq.Question_Id equals nqs.Question_Id
                join avs in _context.AVAILABLE_STANDARDS.AsNoTracking() on new { nqs.Set_Name, Assessment_Id = assessmentId } equals new { avs.Set_Name, avs.Assessment_Id }
                join nql in _context.NEW_QUESTION_LEVELS.AsNoTracking() on nqs.New_Question_Set_Id equals nql.New_Question_Set_Id
                where aq.Assessment_Id == assessmentId
                      && (aq.Answer_Text == "N" || aq.Answer_Text == "U")
                      && avs.Selected
                      && nql.Universal_Sal_Level == universalSalLevel
                group new { nq, maxRank } by new { avs.Set_Name, vh.Question_Group_Heading } into g
                select new
                {
                    g.Key.Set_Name,
                    g.Key.Question_Group_Heading,
                    nuCount = g.Count(),
                    cr = g.Sum(x => maxRank - (x.nq.Ranking ?? 0))
                }
            ).ToListAsync();

            // Join and compute results
            var results = (
                from t in categoryTotals
                join a in answeredCounts on new { t.Set_Name, t.Question_Group_Heading } equals new { a.Set_Name, a.Question_Group_Heading } into aj
                from a in aj.DefaultIfEmpty()
                let nuCount = a?.nuCount ?? 0
                let actualCr = a?.cr ?? 0
                let prc = total > 0 ? Math.Round((decimal)actualCr / total * 100, 4) : 0
                let percent = t.qc > 0 ? Math.Round((decimal)nuCount / t.qc * 100, 4) : 0
                orderby prc descending
                select new StandardsRankedCategory
                {
                    Set_Name = t.Set_Name,
                    Question_Group_Heading = t.Question_Group_Heading,
                    qc = t.qc,
                    cr = t.cr,
                    Total = total,
                    nuCount = nuCount,
                    Actualcr = actualCr,
                    prc = prc,
                    Percent = percent
                }
            ).ToList();

            return results;
        }

        /// <summary>
        /// Gets ranked categories for Requirements Based mode.
        /// </summary>
        private async Task<List<StandardsRankedCategory>> GetRankedCategoriesForRequirementsAsync(int assessmentId)
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
                return new List<StandardsRankedCategory>();
            }

            // Get max ranking from requirements in scope
            var maxRank = await _context.NEW_REQUIREMENT
                .AsNoTracking()
                .Where(r => requirementsInScope.Contains(r.Requirement_Id))
                .MaxAsync(r => (int?)r.Ranking) ?? 0;

            // Get category totals (all answers) grouped by Question_Group_Heading
            // Note: Requirements mode in the original SP doesn't group by Set_Name, only Question_Group_Heading
            var categoryTotals = await (
                from ar in _context.Answer_Requirements.AsNoTracking()
                join nr in _context.NEW_REQUIREMENT.AsNoTracking() on ar.Question_Or_Requirement_Id equals nr.Requirement_Id
                join qgh in _context.QUESTION_GROUP_HEADING.AsNoTracking() on nr.Question_Group_Heading_Id equals qgh.Question_Group_Heading_Id
                where ar.Assessment_Id == assessmentId
                      && requirementsInScope.Contains(nr.Requirement_Id)
                group new { nr, maxRank } by qgh.Question_Group_Heading1 into g
                select new
                {
                    Question_Group_Heading = g.Key,
                    qc = g.Count(),
                    cr = g.Sum(x => maxRank - (x.nr.Ranking ?? 0))
                }
            ).ToListAsync();

            // Calculate overall total
            var total = categoryTotals.Sum(c => c.cr);

            // Compute results (requirements mode doesn't calculate nuCount/Actualcr/Percent in the original SP)
            var results = (
                from t in categoryTotals
                let prc = total > 0 ? Math.Round((decimal)t.cr / total * 100, 4) : 0
                orderby prc descending
                select new StandardsRankedCategory
                {
                    Set_Name = null,
                    Question_Group_Heading = t.Question_Group_Heading,
                    qc = t.qc,
                    cr = t.cr,
                    Total = total,
                    nuCount = null,
                    Actualcr = null,
                    prc = prc,
                    Percent = null
                }
            ).ToList();

            return results;
        }
    }
}
