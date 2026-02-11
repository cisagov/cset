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
    /// Provides maturity answer totals analysis functionality.
    /// Replaces usp_GetMaturityAnswerTotals stored procedure.
    /// </summary>
    public class MaturityAnswerTotalsBusiness
    {
        private readonly CSETContext _context;

        public MaturityAnswerTotalsBusiness(CSETContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Gets the maturity answer totals for an assessment.
        /// Returns answer counts and percentages for each answer type.
        /// </summary>
        /// <param name="assessmentId">The assessment ID</param>
        /// <param name="modelId">Optional maturity model ID. If not provided, uses the assigned model.</param>
        /// <returns>List of AnswerCountsAndPercentages containing answer distribution</returns>
        public async Task<List<AnswerCountsAndPercentages>> GetMaturityAnswerTotalsAsync(
            int assessmentId, int? modelId = null)
        {
            // 1. Resolve model_id if not provided
            var resolvedModelId = modelId ?? await _context.AVAILABLE_MATURITY_MODELS
                .AsNoTracking()
                .Where(m => m.Assessment_Id == assessmentId)
                .Select(m => m.model_id)
                .FirstOrDefaultAsync();

            if (resolvedModelId == 0)
                return new List<AnswerCountsAndPercentages>();

            // 2. Fill empty maturity questions (still calls SP for now)
            _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

            // 3. Query answers for maturity questions of this model
            // Use subquery instead of loading IDs into memory (more efficient)
            var answerGroups = await _context.ANSWER
                .AsNoTracking()
                .Where(a => a.Assessment_Id == assessmentId
                         && a.Question_Type == "Maturity"
                         && _context.MATURITY_QUESTIONS
                             .Where(q => q.Maturity_Model_Id == resolvedModelId)
                             .Select(q => q.Mat_Question_Id)
                             .Contains(a.Question_Or_Requirement_Id))
                .GroupBy(a => a.Answer_Text)
                .Select(g => new { Answer_Text = g.Key, QC = g.Count() })
                .ToListAsync();

            var total = answerGroups.Sum(x => x.QC);

            // 4. Build result with percentages (matching SP output format)
            return answerGroups.Select(g => new AnswerCountsAndPercentages
            {
                Answer_Text = g.Answer_Text,
                QC = g.QC,
                Total = total,
                Percent = total > 0 ? (int)Math.Round((double)g.QC / total * 100, 0) : 0
            }).ToList();
        }
    }
}
