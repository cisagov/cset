using CSETWeb_Api.BusinessLogic.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BusinessLogic.Helpers;
using DataLayerCore.Model;
using CSETWeb_Api.BusinessLogic.BusinessManagers.AdminTab;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Analysis
{
    public class ACETDashboardManager
    {
        /// <summary>
        /// Get IRP calculations and domains for dashboard display
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public ACETDashboard LoadDashboard(int assessmentId)
        {

            ACETDashboard result = GetIrpCalculation(assessmentId);

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
        /// <summary>
        /// Get the string value for the overall IRP mapping
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public string GetOverallIrp(int assessmentId)
        {
            var calc = GetIrpCalculation(assessmentId);
            int overall = calc.Override > 0 ? calc.Override : calc.SumRiskLevel;
            return overall == 1 ? Constants.LeastIrp :
                overall == 2 ? Constants.MinimalIrp :
                overall == 3 ? Constants.ModerateIrp :
                overall == 4 ? Constants.SignificantIrp :
                overall == 5 ? Constants.MostIrp : string.Empty;
        }

        /// <summary>
        /// Get all IRP calculations for display
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public ACETDashboard GetIrpCalculation(int assessmentId)
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

                    ASSESSMENT_IRP_HEADER headerInfo = db.ASSESSMENT_IRP_HEADER.FirstOrDefault(h => h.IRP_HEADER_.IRP_Header_Id == header.IRP_Header_Id && h.ASSESSMENT_.Assessment_Id == assessmentId);
                    if (headerInfo != null)
                    {
                        summary.RiskLevelId = headerInfo.HEADER_RISK_LEVEL_ID ?? 0;
                        summary.RiskLevel = headerInfo.RISK_LEVEL.Value;
                        summary.Comment = headerInfo.COMMENT;
                    }
                    
                    List<IRP> irps = db.IRP.Where(i => i.Header_Id == header.IRP_Header_Id).ToList();
                    Dictionary<int, ASSESSMENT_IRP> dictionaryIRPS = db.ASSESSMENT_IRP.Where(x => x.Assessment_Id == assessmentId).ToDictionary(x => x.IRP_Id, x=> x);
                    foreach (IRP irp in irps)
                    {
                        ASSESSMENT_IRP answer = null; 
                        dictionaryIRPS.TryGetValue(irp.IRP_ID, out answer);
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
                    if (result.SumRisk[i] >= maxRisk && result.SumRisk[i] > 0)
                    {
                        result.SumRiskLevel = i + 1;
                        maxRisk = result.SumRisk[i];
                    }
                }
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
                    ASSESSMENT_IRP_HEADER dbSummary = db.ASSESSMENT_IRP_HEADER.FirstOrDefault(s => s.ASSESSMENT_ID == assessment.Assessment_Id && s.HEADER_RISK_LEVEL_ID == irp.RiskLevelId);
                    if (dbSummary != null)
                    {
                        dbSummary.RISK_LEVEL = irp.RiskLevel;
                        dbSummary.COMMENT = irp.Comment;
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
