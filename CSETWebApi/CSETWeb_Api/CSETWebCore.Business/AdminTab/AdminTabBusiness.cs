//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Model.AdminTab;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Business.AdminTab
{
    public class AdminTabBusiness : IAdminTabBusiness
    {
        private CSETContext _context;

        public AdminTabBusiness(CSETContext context)
        {
            _context = context;
        }

        public AdminTabData GetTabData(int assessmentId)
        {
            Dictionary<string, int> countStatementsReviewed = new Dictionary<string, int>();

            AdminTabData rvalue = new AdminTabData();

            try
            {
                var stmtCounts = _context.usp_StatementsReviewed(assessmentId).ToList<usp_StatementsReviewed_Result>();
                foreach (var row in stmtCounts)
                {
                    rvalue.DetailData.Add(new FINANCIAL_HOURS_OVERRIDE(row));
                    countStatementsReviewed[row.Component] = row.ReviewedCount ?? 0;
                }

                var totals = _context.usp_StatementsReviewedTabTotals(assessmentId).ToList<usp_StatementsReviewedTabTotals_Result>();
                foreach (var row in totals)
                {
                    rvalue.ReviewTotals.Add(new ReviewTotals() { Total = row.Totals, ReviewType = row.ReviewType });
                    rvalue.GrandTotal = row.GrandTotal ?? 0;
                }
            }
            catch (System.Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
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


            rvalue.Attributes = _context.usp_financial_attributes(assessmentId).ToList();
            return rvalue;
        }

        /// <summary>
        /// Saves the number of hours and maybe the OtherSpecifyValue to the FINANCIAL_HOURS database.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="save"></param>
        /// <returns></returns>
        public AdminSaveResponse SaveData(int assessmentId, AdminSaveData save)
        {
            FINANCIAL_HOURS fh = null;

            var items = _context.FINANCIAL_HOURS.Where(x => x.Assessment_Id == assessmentId && x.Component == save.Component).ToList();

            if (items.Count == 0)
            {
                // No answers saved yet.  Build both records.
                fh = CreateNewFinancialHours(assessmentId, save);
                fh.ReviewType = "Documentation";
                _context.FINANCIAL_HOURS.Add(fh);

                fh = CreateNewFinancialHours(assessmentId, save);
                fh.ReviewType = "Interview Process";
                _context.FINANCIAL_HOURS.Add(fh);

                _context.SaveChanges();
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

                        _context.SaveChanges();
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
            AdminTabData d = GetTabData(assessmentId);
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

        public void SaveDataAttribute(int assessmentId, AttributePair att)
        {

            var item = _context.FINANCIAL_ASSESSMENT_VALUES.Where(x => x.Assessment_Id == assessmentId && x.AttributeName == att.AttributeName).FirstOrDefault();
            if (item == null)
            {
                _context.FINANCIAL_ASSESSMENT_VALUES.Add(new FINANCIAL_ASSESSMENT_VALUES()
                {
                    Assessment_Id = assessmentId,
                    AttributeName = att.AttributeName,
                    AttributeValue = att.AttributeValue
                });
                _context.SaveChanges();
            }
            else
            {
                item.AttributeValue = att.AttributeValue;
                _context.SaveChanges();
            }
        }
    }
}