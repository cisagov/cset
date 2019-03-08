using CSETWeb_Api.BusinessLogic.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataLayerCore.Model;

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

                //IRP Section
                foreach (IRP_HEADER header in db.IRP_HEADER)
                {
                    IRPSummary summary = new IRPSummary();
                    summary.HeaderText = header.Header;

                    ASSESSMENT_IRP_HEADER headerInfo = db.ASSESSMENT_IRP_HEADER.FirstOrDefault(h => h.IRP_HEADER_.IRP_Header_Id == header.IRP_Header_Id && h.ASSESSMENT_.Assessment_Id == assessmentId);
                    if (headerInfo != null)
                    {
                        summary.RiskLevelId = headerInfo.HEADER_RISK_LEVEL_ID;
                        summary.RiskLevel = headerInfo.RISK_LEVEL.Value;
                    }
                    else
                    {
                        summary.RiskLevel = 0;
                        headerInfo = new ASSESSMENT_IRP_HEADER()
                        {
                            RISK_LEVEL = 0,
                            IRP_HEADER_ = header
                        };
                        headerInfo.ASSESSMENT_ = assessment;
                        if (db.ASSESSMENT_IRP_HEADER.Count() == 0)
                        {
                            headerInfo.HEADER_RISK_LEVEL_ID = header.IRP_Header_Id;
                        }
                        else
                        {
                            headerInfo.HEADER_RISK_LEVEL_ID = db.ASSESSMENT_IRP_HEADER.Max(i => i.HEADER_RISK_LEVEL_ID) + idOffset;
                            idOffset++;
                        }
                        summary.RiskLevelId = headerInfo.HEADER_RISK_LEVEL_ID;

                        db.ASSESSMENT_IRP_HEADER.Add(headerInfo);
                    }

                    foreach (IRP irp in header.IRP)
                    {
                        ASSESSMENT_IRP answer = irp.ASSESSMENT_IRP.FirstOrDefault(i => i.Assessment_.Assessment_Id == assessmentId);
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

                db.SaveChanges();
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
                }

                foreach (IRPSummary irp in summary.IRPs)
                {
                    ASSESSMENT_IRP_HEADER dbSummary = db.ASSESSMENT_IRP_HEADER.FirstOrDefault(s => s.HEADER_RISK_LEVEL_ID == irp.RiskLevelId);
                    if (dbSummary != null)
                    {
                        dbSummary.RISK_LEVEL = irp.RiskLevel;
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
