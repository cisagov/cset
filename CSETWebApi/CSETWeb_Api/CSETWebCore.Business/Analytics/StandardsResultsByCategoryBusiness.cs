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
    /// Provides standards results by category analysis functionality.
    /// Replaces StandardsCategoryResult stored procedure.
    /// </summary>
    public class StandardsResultsByCategoryBusiness
    {
        private readonly CSETContext _context;

        public StandardsResultsByCategoryBusiness(CSETContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Gets the standards results by category data for an assessment.
        /// This replaces the StandardsCategoryResult stored procedure.
        /// </summary>
        /// <param name="assessmentId">The assessment ID</param>
        /// <returns>List of StandardsCategoryResult containing category results data</returns>
        public async Task<List<StandardsCategoryResult>> GetStandardsResultsByCategoryAsync(int assessmentId)
        {
            var applicationMode = await GetApplicationModeAsync(assessmentId);

            if (applicationMode == "Questions Based")
            {
                return await GetResultsForQuestionsAsync(assessmentId);
            }
            else
            {
                return await GetResultsForRequirementsAsync(assessmentId);
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
        /// Gets standards results by category for Questions Based mode.
        /// </summary>
        private async Task<List<StandardsCategoryResult>> GetResultsForQuestionsAsync(int assessmentId)
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

            // Get all non-NA answered questions grouped by Set_Name and Question_Group_Heading
            var totalCounts = await (
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
                group aq by new { nqs.Set_Name, vh.Question_Group_Heading, vh.Question_Group_Heading_Id } into g
                select new
                {
                    g.Key.Set_Name,
                    g.Key.Question_Group_Heading,
                    g.Key.Question_Group_Heading_Id,
                    qc = g.Count()
                }
            ).ToListAsync();

            // Get all Y/A (compliant) answered questions grouped by Set_Name and Question_Group_Heading
            var yaCounts = await (
                from aq in _context.Answer_Questions.AsNoTracking()
                join nq in _context.NEW_QUESTION.AsNoTracking() on aq.Question_Or_Requirement_Id equals nq.Question_Id
                join vh in _context.vQUESTION_HEADINGS.AsNoTracking() on nq.Heading_Pair_Id equals vh.Heading_Pair_Id
                join nqs in _context.NEW_QUESTION_SETS.AsNoTracking() on nq.Question_Id equals nqs.Question_Id
                join avs in _context.AVAILABLE_STANDARDS.AsNoTracking() on new { nqs.Set_Name, Assessment_Id = assessmentId } equals new { avs.Set_Name, avs.Assessment_Id }
                join nql in _context.NEW_QUESTION_LEVELS.AsNoTracking() on nqs.New_Question_Set_Id equals nql.New_Question_Set_Id
                where aq.Assessment_Id == assessmentId
                      && (aq.Answer_Text == "Y" || aq.Answer_Text == "A")
                      && avs.Selected
                      && nql.Universal_Sal_Level == universalSalLevel
                group aq by new { nqs.Set_Name, vh.Question_Group_Heading, vh.Question_Group_Heading_Id } into g
                select new
                {
                    g.Key.Set_Name,
                    g.Key.Question_Group_Heading,
                    g.Key.Question_Group_Heading_Id,
                    qc = g.Count()
                }
            ).ToListAsync();

            // Get all distinct Set_Names and Question_Group_Headings to fill in missing combinations
            var allSetNames = totalCounts.Select(x => x.Set_Name).Distinct().ToList();
            var allHeadings = totalCounts
                .Select(x => new { x.Question_Group_Heading, x.Question_Group_Heading_Id })
                .Distinct()
                .ToList();

            // Create cross product and fill missing combinations
            var allCombinations = (
                from setName in allSetNames
                from heading in allHeadings
                let totalEntry = totalCounts.FirstOrDefault(t => t.Set_Name == setName && t.Question_Group_Heading == heading.Question_Group_Heading)
                let yaEntry = yaCounts.FirstOrDefault(y => y.Set_Name == setName && y.Question_Group_Heading == heading.Question_Group_Heading)
                let totalCount = totalEntry?.qc ?? 0
                let yaCount = yaEntry?.qc ?? 0
                let prc = totalCount > 0 ? Math.Round((decimal)yaCount / totalCount * 100, 5) : 0
                select new { setName, heading.Question_Group_Heading, heading.Question_Group_Heading_Id, totalCount, yaCount, prc }
            ).ToList();

            // Get short names for sets
            var setShortNames = await _context.SETS
                .AsNoTracking()
                .Where(s => allSetNames.Contains(s.Set_Name))
                .Select(s => new { s.Set_Name, s.Short_Name })
                .ToDictionaryAsync(s => s.Set_Name, s => s.Short_Name);

            // Build final results
            var results = allCombinations
                .Select(c => new StandardsCategoryResult
                {
                    Set_Name = c.setName,
                    Short_Name = setShortNames.GetValueOrDefault(c.setName, ""),
                    Question_Group_Heading = c.Question_Group_Heading,
                    QGH_Id = c.Question_Group_Heading_Id,
                    yaCount = c.yaCount,
                    Actualcr = c.totalCount,
                    prc = c.prc
                })
                .OrderByDescending(r => r.Question_Group_Heading)
                .ToList();

            return results;
        }

        /// <summary>
        /// Gets standards results by category for Requirements Based mode.
        /// </summary>
        private async Task<List<StandardsCategoryResult>> GetResultsForRequirementsAsync(int assessmentId)
        {
            // Get all non-NA answered requirements grouped by Set_Name and Standard_Category
            var totalCounts = await (
                from ar in _context.Answer_Requirements.AsNoTracking()
                join nr in _context.NEW_REQUIREMENT.AsNoTracking() on ar.Question_Or_Requirement_Id equals nr.Requirement_Id
                join rs in _context.REQUIREMENT_SETS.AsNoTracking() on nr.Requirement_Id equals rs.Requirement_Id
                join avs in _context.AVAILABLE_STANDARDS.AsNoTracking() on new { rs.Set_Name, Assessment_Id = assessmentId } equals new { avs.Set_Name, avs.Assessment_Id }
                where ar.Assessment_Id == assessmentId
                      && avs.Selected
                      && ar.Answer_Text != "NA"
                group ar by new { rs.Set_Name, nr.Standard_Category } into g
                select new
                {
                    g.Key.Set_Name,
                    g.Key.Standard_Category,
                    qc = g.Count()
                }
            ).ToListAsync();

            // Get all Y/A (compliant) answered requirements grouped by Set_Name and Standard_Category
            var yaCounts = await (
                from ar in _context.Answer_Requirements.AsNoTracking()
                join nr in _context.NEW_REQUIREMENT.AsNoTracking() on ar.Question_Or_Requirement_Id equals nr.Requirement_Id
                join rs in _context.REQUIREMENT_SETS.AsNoTracking() on nr.Requirement_Id equals rs.Requirement_Id
                join avs in _context.AVAILABLE_STANDARDS.AsNoTracking() on new { rs.Set_Name, Assessment_Id = assessmentId } equals new { avs.Set_Name, avs.Assessment_Id }
                where ar.Assessment_Id == assessmentId
                      && avs.Selected
                      && (ar.Answer_Text == "Y" || ar.Answer_Text == "A")
                group ar by new { rs.Set_Name, nr.Standard_Category } into g
                select new
                {
                    g.Key.Set_Name,
                    g.Key.Standard_Category,
                    qc = g.Count()
                }
            ).ToListAsync();

            // Get all distinct Set_Names and Standard_Categories to fill in missing combinations
            var allSetNames = totalCounts.Select(x => x.Set_Name).Distinct().ToList();
            var allCategories = totalCounts.Select(x => x.Standard_Category).Distinct().ToList();

            // Create cross product and fill missing combinations
            var allCombinations = (
                from setName in allSetNames
                from category in allCategories
                let totalEntry = totalCounts.FirstOrDefault(t => t.Set_Name == setName && t.Standard_Category == category)
                let yaEntry = yaCounts.FirstOrDefault(y => y.Set_Name == setName && y.Standard_Category == category)
                let totalCount = totalEntry?.qc ?? 0
                let yaCount = yaEntry?.qc ?? 0
                let prc = totalCount > 0 ? Math.Round((decimal)yaCount / totalCount * 100, 5) : 0
                select new { setName, category, totalCount, yaCount, prc }
            ).ToList();

            // Get short names for sets
            var setShortNames = await _context.SETS
                .AsNoTracking()
                .Where(s => allSetNames.Contains(s.Set_Name))
                .Select(s => new { s.Set_Name, s.Short_Name })
                .ToDictionaryAsync(s => s.Set_Name, s => s.Short_Name);

            // Get QGH_Id mapping from Standard_Category to QUESTION_GROUP_HEADING
            var qghMapping = await _context.QUESTION_GROUP_HEADING
                .AsNoTracking()
                .Where(qgh => allCategories.Contains(qgh.Question_Group_Heading1))
                .Select(qgh => new { qgh.Question_Group_Heading1, qgh.Question_Group_Heading_Id })
                .ToDictionaryAsync(q => q.Question_Group_Heading1, q => q.Question_Group_Heading_Id);

            // Build final results
            var results = allCombinations
                .Select(c => new StandardsCategoryResult
                {
                    Set_Name = c.setName,
                    Short_Name = setShortNames.GetValueOrDefault(c.setName, ""),
                    Question_Group_Heading = c.category,
                    QGH_Id = qghMapping.GetValueOrDefault(c.category, 0),
                    yaCount = c.yaCount,
                    Actualcr = c.totalCount,
                    prc = c.prc
                })
                .OrderByDescending(r => r.Question_Group_Heading)
                .ToList();

            return results;
        }
    }
}
