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
    /// Provides component results by category analysis functionality.
    /// Replaces usp_getComponentsResultsByCategory stored procedure.
    /// </summary>
    public class ComponentsResultsByCategoryBusiness
    {
        private readonly CSETContext _context;

        public ComponentsResultsByCategoryBusiness(CSETContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Gets the component results by category data for an assessment.
        /// This replaces the usp_getComponentsResultsByCategory stored procedure.
        /// </summary>
        /// <param name="assessmentId">The assessment ID</param>
        /// <returns>List of ComponentCategoryResult containing category results data</returns>
        public async Task<List<ComponentCategoryResult>> GetComponentsResultsByCategoryAsync(int assessmentId)
        {
            // Get all non-NA answers grouped by Question_Group_Heading
            var totalCounts = await (
                from a in _context.Answer_Components_InScope.AsNoTracking()
                join q in _context.NEW_QUESTION.AsNoTracking() on a.Question_Or_Requirement_Id equals q.Question_Id
                join h in _context.vQUESTION_HEADINGS.AsNoTracking() on q.Heading_Pair_Id equals h.Heading_Pair_Id
                where a.Assessment_Id == assessmentId && a.Answer_Text != "NA"
                group a by h.Question_Group_Heading into g
                select new { Question_Group_Heading = g.Key, qc = g.Count() }
            ).ToListAsync();

            // Get passing answers (Y, A) grouped by Question_Group_Heading
            var passedCounts = await (
                from a in _context.Answer_Components_InScope.AsNoTracking()
                join q in _context.NEW_QUESTION.AsNoTracking() on a.Question_Or_Requirement_Id equals q.Question_Id
                join h in _context.vQUESTION_HEADINGS.AsNoTracking() on q.Heading_Pair_Id equals h.Heading_Pair_Id
                where a.Assessment_Id == assessmentId && (a.Answer_Text == "Y" || a.Answer_Text == "A")
                group a by h.Question_Group_Heading into g
                select new { Question_Group_Heading = g.Key, qc = g.Count() }
            ).ToListAsync();

            // Calculate totals and percentages
            var results = totalCounts
                .Select(t =>
                {
                    var passed = passedCounts.FirstOrDefault(p => p.Question_Group_Heading == t.Question_Group_Heading)?.qc ?? 0;
                    var percent = t.qc > 0 ? Math.Round((decimal)passed / t.qc * 100, 5) : 0;
                    return new ComponentCategoryResult
                    {
                        Question_Group_Heading = t.Question_Group_Heading,
                        passed = passed,
                        total = t.qc,
                        percent = percent
                    };
                })
                .OrderBy(r => r.Question_Group_Heading)
                .ToList();

            return results;
        }
    }
}
