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
    /// Provides component types analysis functionality.
    /// Replaces usp_getComponentTypes stored procedure.
    /// </summary>
    public class ComponentTypesBusiness
    {
        private readonly CSETContext _context;

        public ComponentTypesBusiness(CSETContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Gets the component types data for an assessment.
        /// This replaces the usp_getComponentTypes stored procedure.
        /// Returns answer percentages (Y, N, NA, A, U) grouped by component symbol.
        /// </summary>
        /// <param name="assessmentId">The assessment ID</param>
        /// <returns>List of usp_getComponentTypes containing component type answer data</returns>
        public async Task<List<usp_getComponentTypes>> GetComponentTypesAsync(int assessmentId)
        {
            // Get answer counts grouped by component symbol
            var answerCounts = await _context.Answer_Components_InScope
                .AsNoTracking()
                .Where(a => a.Assessment_Id == assessmentId)
                .GroupBy(a => a.Component_Symbol_Id)
                .Select(g => new
                {
                    Component_Symbol_Id = g.Key,
                    Total = g.Count(),
                    Y = g.Count(x => x.Answer_Text == "Y"),
                    N = g.Count(x => x.Answer_Text == "N"),
                    NA = g.Count(x => x.Answer_Text == "NA"),
                    A = g.Count(x => x.Answer_Text == "A"),
                    U = g.Count(x => x.Answer_Text == "U")
                })
                .ToListAsync();

            if (!answerCounts.Any())
            {
                return new List<usp_getComponentTypes>();
            }

            // Get component symbol IDs to fetch symbol names
            var componentSymbolIds = answerCounts.Select(a => a.Component_Symbol_Id).ToList();

            // Get symbol names for the components
            var symbols = await _context.COMPONENT_SYMBOLS
                .AsNoTracking()
                .Where(s => componentSymbolIds.Contains(s.Component_Symbol_Id))
                .Select(s => new { s.Component_Symbol_Id, s.Symbol_Name })
                .ToListAsync();

            // Join answer counts with symbol names and calculate percentages
            var results = answerCounts
                .Join(symbols,
                    a => a.Component_Symbol_Id,
                    s => s.Component_Symbol_Id,
                    (a, s) => new usp_getComponentTypes
                    {
                        Assessment_Id = assessmentId,
                        Symbol_Name = s.Symbol_Name,
                        Total = a.Total,
                        Y = CalculatePercent(a.Y, a.Total),
                        N = CalculatePercent(a.N, a.Total),
                        NA = CalculatePercent(a.NA, a.Total),
                        A = CalculatePercent(a.A, a.Total),
                        U = CalculatePercent(a.U, a.Total),
                        Value = CalculateValue(a.Y, a.A, a.Total, a.NA),
                        TotalNoNA = a.Total - a.NA
                    })
                .OrderBy(r => r.Symbol_Name)
                .ToList();

            return results;
        }

        /// <summary>
        /// Calculates the percentage of count out of total, rounded to nearest integer.
        /// Matches the SP logic: cast(IsNull(Round((cast(([Y]) as float)/(isnull(nullif(Total,0),1)))*100,0),0) as int)
        /// </summary>
        private static int CalculatePercent(int count, int total)
        {
            if (total == 0)
            {
                return 0;
            }
            return (int)Math.Round((double)count / total * 100, 0);
        }

        /// <summary>
        /// Calculates the Value field: percentage of (Y + A) out of non-NA answers.
        /// Matches the SP logic: ((cast(([Y]+ isnull([A],0)) as float)/isnull(nullif(Total-nullif([NA],0),0),1))*100)
        /// </summary>
        private static double CalculateValue(int y, int a, int total, int na)
        {
            var denominator = total - na;
            if (denominator == 0)
            {
                return 0;
            }
            return ((double)(y + a) / denominator) * 100;
        }
    }
}
