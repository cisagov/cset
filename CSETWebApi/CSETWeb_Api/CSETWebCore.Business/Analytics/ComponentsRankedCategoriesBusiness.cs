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
    /// Provides components ranked categories analysis functionality.
    /// Replaces usp_getComponentsRankedCategories stored procedure.
    /// </summary>
    public class ComponentsRankedCategoriesBusiness
    {
        private readonly CSETContext _context;

        public ComponentsRankedCategoriesBusiness(CSETContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Gets the components ranked categories data for an assessment.
        /// This replaces the usp_getComponentsRankedCategories stored procedure.
        /// Note: FillEmptyQuestionsForAnalysis should be called before this method (done in AnalysisController constructor).
        /// </summary>
        /// <param name="assessmentId">The assessment ID</param>
        /// <returns>List of ComponentsRankedCategory containing ranked category data</returns>
        public async Task<List<ComponentsRankedCategory>> GetComponentsRankedCategoriesAsync(int assessmentId)
        {
            // Get distinct question IDs from the 'Components' set
            var componentsQuestionIds = await (
                from nqs in _context.NEW_QUESTION_SETS.AsNoTracking()
                join nql in _context.NEW_QUESTION_LEVELS.AsNoTracking() on nqs.New_Question_Set_Id equals nql.New_Question_Set_Id
                where nqs.Set_Name == "Components"
                select nqs.Question_Id
            ).Distinct().ToListAsync();

            if (!componentsQuestionIds.Any())
            {
                return new List<ComponentsRankedCategory>();
            }

            // Get max ranking from questions in the 'Components' set
            var maxRank = await _context.NEW_QUESTION
                .AsNoTracking()
                .Where(q => componentsQuestionIds.Contains(q.Question_Id))
                .MaxAsync(q => (int?)q.Ranking) ?? 0;

            // Get category totals (all non-NA answers) grouped by Question_Group_Heading
            // This replicates the first temp table (#Temp) in the SP
            var categoryTotals = await (
                from ac in _context.Answer_Components.AsNoTracking()
                join nq in _context.NEW_QUESTION.AsNoTracking() on ac.Question_Or_Requirement_Id equals nq.Question_Id
                join vh in _context.vQUESTION_HEADINGS.AsNoTracking() on nq.Heading_Pair_Id equals vh.Heading_Pair_Id
                where ac.Assessment_Id == assessmentId
                      && ac.Answer_Text != "NA"
                      && componentsQuestionIds.Contains(nq.Question_Id)
                group new { nq, maxRank } by vh.Question_Group_Heading into g
                select new
                {
                    Question_Group_Heading = g.Key,
                    qc = g.Count(),
                    cr = g.Sum(x => maxRank - (x.nq.Ranking ?? 0))
                }
            ).ToListAsync();

            if (!categoryTotals.Any())
            {
                return new List<ComponentsRankedCategory>();
            }

            // Calculate overall total
            var total = categoryTotals.Sum(c => c.cr);

            // Get unanswered counts (N or U answers only) grouped by Question_Group_Heading
            // This replicates the second temp table (#TempAnswered) in the SP
            var answeredCounts = await (
                from ac in _context.Answer_Components.AsNoTracking()
                join nq in _context.NEW_QUESTION.AsNoTracking() on ac.Question_Or_Requirement_Id equals nq.Question_Id
                join vh in _context.vQUESTION_HEADINGS.AsNoTracking() on nq.Heading_Pair_Id equals vh.Heading_Pair_Id
                where ac.Assessment_Id == assessmentId
                      && (ac.Answer_Text == "N" || ac.Answer_Text == "U")
                      && componentsQuestionIds.Contains(nq.Question_Id)
                group new { nq, maxRank } by vh.Question_Group_Heading into g
                select new
                {
                    Question_Group_Heading = g.Key,
                    nuCount = g.Count(),
                    cr = g.Sum(x => maxRank - (x.nq.Ranking ?? 0))
                }
            ).ToListAsync();

            // Join and compute results (replicates final SELECT in SP)
            var results = (
                from t in categoryTotals
                join a in answeredCounts on t.Question_Group_Heading equals a.Question_Group_Heading into aj
                from a in aj.DefaultIfEmpty()
                let nuCount = a?.nuCount ?? 0
                let actualCr = a?.cr ?? 0
                let prc = total > 0 ? Math.Round((decimal)actualCr / total * 100, 4) : 0
                let percent = t.qc > 0 ? Math.Round((decimal)nuCount / t.qc, 4) : 0
                orderby prc descending
                select new ComponentsRankedCategory
                {
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
    }
}
