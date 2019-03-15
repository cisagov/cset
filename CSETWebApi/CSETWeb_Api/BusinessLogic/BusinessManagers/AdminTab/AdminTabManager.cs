//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using DataLayerCore.Model;
using System.Linq;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.AdminTab
{
    public class AdminTabManager
    {
        public AdminTabData getTabData(int assessmentId)
        {
            AdminTabData rvalue = new AdminTabData();
            using (var db = new CSET_Context())
            {
                var stmtCounts = db.usp_StatementsReviewed(assessmentId).ToList<usp_StatementsReviewed_Result>();

                var totals = db.usp_StatementsReviewedTabTotals(assessmentId).ToList<usp_StatementsReviewedTabTotals_Result>();
                foreach (var row in stmtCounts)
                {
                    rvalue.DetailData.Add(new FINANCIAL_HOURS_OVERRIDE(row));
                }
                foreach (var row in totals)
                {
                    rvalue.ReviewTotals.Add(new ReviewTotals() { Total = row.Totals, ReviewType = row.ReviewType });
                    rvalue.GrandTotal = row.GrandTotal ?? 0;
                }
                rvalue.Attributes = db.usp_financial_attributes(assessmentId).ToList();
            }
            return rvalue;
        }

        public AdminSaveResponse SaveData(int assessmentId, AdminSaveData save)
        {
            using (var db = new CSET_Context())
            {
                var item = db.FINANCIAL_HOURS.Where(x => x.Assessment_Id == assessmentId && x.Component == save.Component && x.ReviewType == save.ReviewType).FirstOrDefault();
                if (item == null)
                {
                    db.FINANCIAL_HOURS.Add(new FINANCIAL_HOURS()
                    {
                        Assessment_Id = assessmentId,
                        Component = save.Component,
                        ReviewType = save.ReviewType,
                        Hours = save.Hours,
                        OtherSpecifyValue = save.OtherSpecifyValue,
                        ReviewedCountOverride = save.ReviewedCountOverride == 0 ? null : save.ReviewedCountOverride
                    });
                    db.SaveChanges();
                }
                else
                {
                    item.Hours = save.Hours;
                    item.OtherSpecifyValue = save.OtherSpecifyValue;
                    item.ReviewedCountOverride = save.ReviewedCountOverride == 0 ? null : save.ReviewedCountOverride;
                    db.SaveChanges();
                }


                // Get totals for AdminSaveResponse
                AdminSaveResponse resp = new AdminSaveResponse
                {
                    DocumentationTotal = 0,
                    InterviewTotal = 0,
                    GrandTotal = 0,
                    ReviewedTotal = 0
                };
                AdminTabData d = getTabData(assessmentId);
                foreach (var t in d.ReviewTotals)
                {
                    switch (t.ReviewType.ToLower())
                    {
                        case "documentation":
                            resp.DocumentationTotal += (int)t.Total;
                            break;
                        case "interview process":
                            resp.InterviewTotal += (int)t.Total;
                            break;
                    }                    
                };
                resp.GrandTotal = (int)d.GrandTotal;
                //resp.ReviewedTotal = ???;

                return resp;
            }
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
