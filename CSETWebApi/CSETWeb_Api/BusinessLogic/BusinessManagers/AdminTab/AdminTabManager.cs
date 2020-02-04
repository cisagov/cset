//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using DataLayerCore.Model;
using System.Linq;
using System.Collections.Generic;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.AdminTab
{
    public class AdminTabManager
    {
        public AdminTabData GetTabData(int assessmentId)
        {
            Dictionary<string, int> countStatementsReviewed = new Dictionary<string, int>();

            AdminTabData rvalue = new AdminTabData();
            using (var db = new CSET_Context())
            {
                var stmtCounts = db.usp_StatementsReviewed(assessmentId).ToList<usp_StatementsReviewed_Result>();

                var totals = db.usp_StatementsReviewedTabTotals(assessmentId).ToList<usp_StatementsReviewedTabTotals_Result>();
                foreach (var row in stmtCounts)
                {
                    rvalue.DetailData.Add(new FINANCIAL_HOURS_OVERRIDE(row));
                    countStatementsReviewed[row.Component] = row.ReviewedCount ?? 0;
                }
                foreach (var row in totals)
                {
                    rvalue.ReviewTotals.Add(new ReviewTotals() { Total = row.Totals, ReviewType = row.ReviewType });
                    rvalue.GrandTotal = row.GrandTotal ?? 0;
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


                rvalue.Attributes = db.usp_financial_attributes(assessmentId).ToList();
            }
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
            using (var db = new CSET_Context())
            {
                FINANCIAL_HOURS fh = null;

                var items = db.FINANCIAL_HOURS.Where(x => x.Assessment_Id == assessmentId && x.Component == save.Component).ToList();

                if (items.Count == 0)
                {
                    // No answers saved yet.  Build both records.
                    fh = CreateNewFinancialHours(assessmentId, save);
                    fh.ReviewType = "Documentation";
                    db.FINANCIAL_HOURS.Add(fh);

                    fh = CreateNewFinancialHours(assessmentId, save);
                    fh.ReviewType = "Interview Process";
                    db.FINANCIAL_HOURS.Add(fh);

                    db.SaveChanges();
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

                            db.SaveChanges();
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
        }

        private FINANCIAL_HOURS CreateNewFinancialHours(int assessmentId, AdminSaveData save)
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
            using (var db = new CSET_Context())
            {
                var item = db.FINANCIAL_ASSESSMENT_VALUES.Where(x => x.Assessment_Id == assessmentId && x.AttributeName == att.AttributeName).FirstOrDefault();
                if (item == null)
                {
                    db.FINANCIAL_ASSESSMENT_VALUES.Add(new FINANCIAL_ASSESSMENT_VALUES()
                    {
                        Assessment_Id = assessmentId,
                        AttributeName = att.AttributeName,
                        AttributeValue = att.AttributeValue
                    });
                    db.SaveChanges();
                }
                else
                {
                    item.AttributeValue = att.AttributeValue;
                    db.SaveChanges();
                }
            }
        }
    }

    public class AttributePair
    {
        public string AttributeName { get; set; }
        public string AttributeValue { get; set; }
    }
}
