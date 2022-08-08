using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Model.AdminTab;
using CSETWebCore.DataLayer.Model;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.Business.AdminTab
{
    public class AdminTabBusiness : IAdminTabBusiness
    {
        private CSETContext _context;

        public AdminTabBusiness(CSETContext context)
        {
            _context = context;
        }

        public async Task<AdminTabData> GetTabData(int assessmentId)
        {
            Dictionary<string, int> countStatementsReviewed = new Dictionary<string, int>();

            AdminTabData rvalue = new AdminTabData();

            try
            {
                var statementsRevList = await _context.usp_StatementsReviewed(assessmentId);
                var stmtCounts = statementsRevList.ToList<usp_StatementsReviewed_Result>();
                foreach (var row in stmtCounts)
                {
                    rvalue.DetailData.Add(new FINANCIAL_HOURS_OVERRIDE(row));
                    countStatementsReviewed[row.Component] = row.ReviewedCount ?? 0;
                }
                var statementsRevTabList = await _context.usp_StatementsReviewedTabTotals(assessmentId);
                var totals = statementsRevTabList.ToList<usp_StatementsReviewedTabTotals_Result>();
                foreach (var row in totals)
                {
                    rvalue.ReviewTotals.Add(new ReviewTotals() { Total = row.Totals, ReviewType = row.ReviewType });
                    rvalue.GrandTotal = row.GrandTotal ?? 0;
                }
            }
            catch (System.Exception exc)
            {
                log4net.LogManager.GetLogger(this.GetType()).Error($"... {exc}");
            }

            // add another total entry for Statements Reviewed   

            var totalReviewed = new ReviewTotals
            {
                ReviewType = "Statements Reviewed",
                Total = 0
            };
            foreach (var d in countStatementsReviewed)
            {
                totalReviewed.Total += d.Value;
            }
            rvalue.ReviewTotals.Add(totalReviewed);

            var financialAttribList = await _context.usp_financial_attributes(assessmentId);
            rvalue.Attributes = financialAttribList.ToList();
            return rvalue;
        }

        /// <summary>
        /// Saves the number of hours and maybe the OtherSpecifyValue to the FINANCIAL_HOURS database.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="save"></param>
        /// <returns></returns>
        public async Task<AdminSaveResponse> SaveData(int assessmentId, AdminSaveData save)
        {
            FINANCIAL_HOURS fh = null;

            var items = await _context.FINANCIAL_HOURS.Where(x => x.Assessment_Id == assessmentId && x.Component == save.Component).ToListAsync();

            if (items.Count == 0)
            {
                // No answers saved yet.  Build both records.
                fh = CreateNewFinancialHours(assessmentId, save);
                fh.ReviewType = "Documentation";
                await _context.FINANCIAL_HOURS.AddAsync(fh);

                fh = CreateNewFinancialHours(assessmentId, save);
                fh.ReviewType = "Interview Process";
                await _context.FINANCIAL_HOURS.AddAsync(fh);

                await _context.SaveChangesAsync();
            }
            else
            {
                foreach (FINANCIAL_HOURS item in items)
                {
                    if (item.ReviewType == save.ReviewType || string.IsNullOrEmpty(save.ReviewType))
                    {
                        if (item.ReviewType == save.ReviewType)
                        {
                            item.Hours = save.Hours;
                        }

                        item.OtherSpecifyValue = save.OtherSpecifyValue;

                        await _context.SaveChangesAsync();
                    }
                }
            }


            // Get totals for AdminSaveResponse
            AdminSaveResponse resp = new AdminSaveResponse
            {
                DocumentationTotal = 0,
                InterviewTotal = 0,
                GrandTotal = 0,
                ReviewedTotal = 0
            };
            AdminTabData d = await GetTabData(assessmentId);
            foreach (var t in d.ReviewTotals)
            {
                switch (t.ReviewType.ToLower())
                {
                    case "documentation":
                        resp.DocumentationTotal += (double)t.Total;
                        break;
                    case "interview process":
                        resp.InterviewTotal += (double)t.Total;
                        break;
                }
            };
            resp.GrandTotal = (double)d.GrandTotal;
            //resp.ReviewedTotal = ???;

            return resp;
        }

        public FINANCIAL_HOURS CreateNewFinancialHours(int assessmentId, AdminSaveData save)
        {
            return new FINANCIAL_HOURS()
            {
                Assessment_Id = assessmentId,
                Component = save.Component,
                ReviewType = save.ReviewType,
                Hours = save.Hours,
                OtherSpecifyValue = save.OtherSpecifyValue
            };
        }

        public async Task SaveDataAttribute(int assessmentId, AttributePair att)
        {

            var item = await _context.FINANCIAL_ASSESSMENT_VALUES.Where(x => x.Assessment_Id == assessmentId && x.AttributeName == att.AttributeName).FirstOrDefaultAsync();
            if (item == null)
            {
                await _context.FINANCIAL_ASSESSMENT_VALUES.AddAsync(new FINANCIAL_ASSESSMENT_VALUES()
                {
                    Assessment_Id = assessmentId,
                    AttributeName = att.AttributeName,
                    AttributeValue = att.AttributeValue
                });
                await _context.SaveChangesAsync();
            }
            else
            {
                item.AttributeValue = att.AttributeValue;
                await _context.SaveChangesAsync();
            }
        }
    }
}