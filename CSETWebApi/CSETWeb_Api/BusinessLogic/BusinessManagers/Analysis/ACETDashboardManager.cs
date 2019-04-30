using CSETWeb_Api.BusinessLogic.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataLayerCore.Model;
using CSETWeb_Api.BusinessLogic.BusinessManagers.AdminTab;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Analysis
{
    public class ACETDashboardManager
    {
        public ACETDashboard LoadDashboard(int assessmentId)
        {
            ACETDashboard result = new ACETDashboard();
            int idOffset = 1;


            using (var db = new CSET_Context())
            {
                // now just properties on an Assessment
                ASSESSMENTS assessment = db.ASSESSMENTS.FirstOrDefault(a => a.Assessment_Id == assessmentId);
                if (assessment == null) { return null; }
                result.CreditUnionName = assessment.CreditUnionName;
                result.Charter = assessment.Charter;
                result.Assets = assessment.Assets;

                result.Hours = (new AdminTabManager()).GetTabData(assessmentId).GrandTotal;

                //IRP Section
                result.Override = assessment.IRPTotalOverride ?? 0;
                result.OverrideReason = assessment.IRPTotalOverrideReason;
                foreach (IRP_HEADER header in db.IRP_HEADER)
                {
                    IRPSummary summary = new IRPSummary();
                    summary.HeaderText = header.Header;

                    ASSESSMENT_IRP_HEADER headerInfo = db.ASSESSMENT_IRP_HEADER.FirstOrDefault(h => h.IRP_Header_.IRP_Header_Id == header.IRP_Header_Id && h.Assessment_.Assessment_Id == assessmentId);
                    if (headerInfo != null)
                    {
                        summary.RiskLevelId = headerInfo.Header_Risk_Level_Id ?? 0;
                        summary.RiskLevel = headerInfo.Risk_Level.Value;
                        summary.Comment = headerInfo.Comment;
                    }
                    else
                    {
                        summary.RiskLevel = 0;
                        headerInfo = new ASSESSMENT_IRP_HEADER()
                        {
                            Risk_Level = 0,
                            IRP_Header_ = header
                        };
                        headerInfo.Assessment_ = assessment;
                        if (db.ASSESSMENT_IRP_HEADER.Count() == 0)
                        {
                            headerInfo.Header_Risk_Level_Id = header.IRP_Header_Id;
                        }
                        else
                        {
                            headerInfo.Header_Risk_Level_Id = db.ASSESSMENT_IRP_HEADER.Max(i => i.Header_Risk_Level_Id) + idOffset;
                            idOffset++;
                        }
                        summary.RiskLevelId = headerInfo.Header_Risk_Level_Id ?? 0;

                        db.ASSESSMENT_IRP_HEADER.Add(headerInfo);
                    }

                    List<IRP> irps = db.IRP.Where(i => i.Header_Id == header.IRP_Header_Id).ToList();
                    foreach (IRP irp in irps)
                    {
                        ASSESSMENT_IRP answer = db.ASSESSMENT_IRP.FirstOrDefault(a => a.IRP_Id == irp.IRP_ID && a.Assessment_Id == assessmentId);
                        //ASSESSMENT_IRP answer = irp.ASSESSMENT_IRP.FirstOrDefault(i => i.Assessment_.Assessment_Id == assessmentId);
                        if (answer != null && answer.Response != 0)
                        {
                            summary.RiskCount[answer.Response.Value - 1]++;
                            summary.RiskSum++;
                            result.SumRisk[answer.Response.Value - 1]++;
                            result.SumRiskTotal++;
                        }
                    }

                    result.IRPs.Add(summary);
                }

                //go back through the IRPs and calculate the Risk Level for each section
                foreach (IRPSummary irp in result.IRPs)
                {
                    int MaxRisk = 0;
                    irp.RiskLevel = 0;
                    for (int i = 0; i < irp.RiskCount.Length; i++)
                    {
                        if (irp.RiskCount[i] >= MaxRisk && irp.RiskCount[i] > 0)
                        {
                            MaxRisk = irp.RiskCount[i];
                            irp.RiskLevel = i + 1;
                        }
                    }
                }

                db.SaveChanges();

                result.SumRiskLevel = 1;
                int maxRisk = 0;
                for (int i = 0; i < result.SumRisk.Length; i++)
                {
                    if (result.SumRisk[i] >= maxRisk && result.SumRisk[i]>0)
                    {
                        result.SumRiskLevel = i+1;
                        maxRisk = result.SumRisk[i];
                    }  
                }

            }

            result.Domains = new List<DashboardDomain>();
            MaturityManager matManager = new MaturityManager();
            List<MaturityDomain> domains = matManager.GetMaturityAnswers(assessmentId);
            foreach (var d in domains)
            {
                result.Domains.Add(new DashboardDomain
                {
                    Maturity = d.DomainMaturity,
                    Name = d.DomainName
                });

            }

            return result;
        }

        public void UpdateACETDashboardSummary(int assessmentId, ACETDashboard summary)
        {
            if (assessmentId == 0 || summary == null) { return; }

            using (var db = new CSET_Context())
            {
                ASSESSMENTS assessment = db.ASSESSMENTS.FirstOrDefault(a => a.Assessment_Id == assessmentId);
                if (assessment != null)
                {
                    assessment.CreditUnionName = summary.CreditUnionName;
                    assessment.Charter = summary.Charter;
                    assessment.Assets = summary.Assets;

                    assessment.IRPTotalOverride = summary.Override;
                    assessment.IRPTotalOverrideReason = summary.OverrideReason;
                }

                foreach (IRPSummary irp in summary.IRPs)
                {
                    ASSESSMENT_IRP_HEADER dbSummary = db.ASSESSMENT_IRP_HEADER.FirstOrDefault(s => s.Assessment_Id == assessment.Assessment_Id && s.Header_Risk_Level_Id == irp.RiskLevelId);
                    if (dbSummary != null)
                    {
                        dbSummary.Risk_Level = irp.RiskLevel;
                        dbSummary.Comment = irp.Comment;
                    } // the else should never happen
                    else
                    {
                        return;
                    }
                }

                db.SaveChanges();
            }
        }
    }
}
