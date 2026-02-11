////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
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
    /// Provides components summary analysis functionality.
    /// Replaces usp_getComponentsSummary stored procedure.
    /// </summary>
    public class ComponentsSummaryBusiness
    {
        private readonly CSETContext _context;

        public ComponentsSummaryBusiness(CSETContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Gets the components summary data for an assessment.
        /// This replaces the usp_getComponentsSummary stored procedure.
        /// </summary>
        /// <param name="assessmentId">The assessment ID</param>
        /// <returns>List of component answer summary with counts and percentages</returns>
        public async Task<List<usp_getComponentsSummmary>> GetComponentsSummaryAsync(int assessmentId)
        {
            // Get component answers for the assessment using the simpler Answer_Components view
            // This is more efficient than Answer_Components_InScope which has 8+ table joins
            // Answer_Components already filters for Is_Component = 1 and Is_Requirement = 0
            var componentAnswers = await _context.Answer_Components
                .AsNoTracking()
                .Where(ac => ac.Assessment_Id == assessmentId)
                .Select(ac => new { ac.Answer_Text, ac.Answer_Id })
                .ToListAsync();

            // Group by answer text and calculate counts
            var answerCounts = componentAnswers
                .GroupBy(ac => ac.Answer_Text)
                .Select(g => new { Answer_Text = g.Key, vcount = g.Count() })
                .ToList();

            // Calculate total for percentage calculation
            var total = answerCounts.Sum(x => x.vcount);

            // Get all answer lookup values
            var answerLookups = await _context.ANSWER_LOOKUP
                .AsNoTracking()
                .Select(l => new { l.Answer_Text, l.Answer_Full_Name })
                .ToListAsync();

            // Left join with answer lookup and calculate percentages
            // Matches SP: ROUND(ISNULL(b.value, 0), 0) and ISNULL(b.vcount, 0)
            var results = answerLookups
                .Select(l =>
                {
                    var count = answerCounts.FirstOrDefault(c => c.Answer_Text == l.Answer_Text);
                    var vcount = count?.vcount ?? 0;
                    var value = total > 0 ? Math.Round((decimal)vcount * 100.0m / total, 0) : 0;
                    return new usp_getComponentsSummmary
                    {
                        Answer_Text = l.Answer_Text,
                        Answer_Full_Name = l.Answer_Full_Name,
                        vcount = vcount,
                        value = value
                    };
                })
                .ToList();

            return results;
        }
    }
}
