//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.Model.Acet;
using CSETWebCore.Business.Maturity;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.AdminTab;
using System.IO;
using NPOI.SS.UserModel;
using Npoi.Mapper;
using CSETWebCore.DataLayer.Manual;
using CSETWebCore.Model.Maturity;
using NPOI.SS.Formula.Functions;

namespace CSETWebCore.Business.Acet
{
    public class AcetBusiness
    {
        private CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;

        public AcetBusiness(CSETContext context, IAssessmentUtil assessmentUtil, IAdminTabBusiness adminTabBusiness)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
        }


        /// <summary>
        /// Get IRP calculations and domains for dashboard display
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public Model.Acet.ACETDashboard LoadDashboard(int assessmentId)
        {

            Model.Acet.ACETDashboard result = GetIrpCalculation(assessmentId);

            result.Domains = new List<DashboardDomain>();
            MaturityBusiness matManager = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);

            var domains = matManager.GetMaturityAnswers(assessmentId);
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
            return overall == 1 ? Constants.Constants.LeastIrp :
                overall == 2 ? Constants.Constants.MinimalIrp :
                overall == 3 ? Constants.Constants.ModerateIrp :
                overall == 4 ? Constants.Constants.SignificantIrp :
                overall == 5 ? Constants.Constants.MostIrp : string.Empty;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public int GetOverallIrpNumber(int assessmentId)
        {
            var calc = GetIrpCalculation(assessmentId);
            int overall = calc.Override > 0 ? calc.Override : calc.SumRiskLevel;
            return overall;
        }


        /// <summary>
        /// Get all IRP calculations for display
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public Model.Acet.ACETDashboard GetIrpCalculation(int assessmentId)
        {
            Model.Acet.ACETDashboard result = new Model.Acet.ACETDashboard();
            
            // now just properties on an Assessment
            ASSESSMENTS assessment = _context.ASSESSMENTS.FirstOrDefault(a => a.Assessment_Id == assessmentId);
            if (assessment == null) { return null; }
            result.CreditUnionName = assessment.CreditUnionName;
            result.Charter = assessment.Charter;
            result.Assets = assessment.Assets;

            result.Hours = _adminTabBusiness.GetTabData(assessmentId).GrandTotal;

            //IRP Section
            result.Override = assessment.IRPTotalOverride ?? 0;
            result.OverrideReason = assessment.IRPTotalOverrideReason;
            foreach (IRP_HEADER header in _context.IRP_HEADER)
            {
                IRPSummary summary = new IRPSummary();
                summary.HeaderText = header.Header;

                ASSESSMENT_IRP_HEADER headerInfo = _context.ASSESSMENT_IRP_HEADER.FirstOrDefault(h => h.IRP_HEADER.IRP_Header_Id == header.IRP_Header_Id && h.ASSESSMENT.Assessment_Id == assessmentId);
                if (headerInfo != null)
                {
                    summary.RiskLevelId = headerInfo.HEADER_RISK_LEVEL_ID ?? 0;
                    summary.RiskLevel = headerInfo.RISK_LEVEL.Value;
                    summary.Comment = headerInfo.COMMENT;
                }

                List<DataLayer.Model.IRP> irps = _context.IRP.Where(i => i.Header_Id == header.IRP_Header_Id).ToList();
                Dictionary<int, ASSESSMENT_IRP> dictionaryIRPS = _context.ASSESSMENT_IRP.Where(x => x.Assessment_Id == assessmentId).ToDictionary(x => x.IRP_Id, x => x);
                foreach (DataLayer.Model.IRP irp in irps)
                {
                    ASSESSMENT_IRP answer = null;
                    dictionaryIRPS.TryGetValue(irp.IRP_ID, out answer);
                    if (answer != null && answer.Response != 0)
                    {
                        summary.RiskCount[answer.Response.Value - 1]++;
                        summary.RiskSum++;
                        result.SumRisk[answer.Response.Value - 1]++;
                        result.SumRiskTotal++;
                    }
                }

                result.Irps.Add(summary);
            }

            //go back through the IRPs and calculate the Risk Level for each section
            foreach (IRPSummary irp in result.Irps)
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

            _context.SaveChanges();

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


            return result;
        }

        public void UpdateACETDashboardSummary(int assessmentId, Model.Acet.ACETDashboard summary)
        {
            if (assessmentId == 0 || summary == null) { return; }


            ASSESSMENTS assessment = _context.ASSESSMENTS.FirstOrDefault(a => a.Assessment_Id == assessmentId);
            if (assessment != null)
            {
                assessment.CreditUnionName = summary.CreditUnionName;
                assessment.Charter = summary.Charter;
                assessment.Assets = summary.Assets;

                assessment.IRPTotalOverride = summary.Override;
                assessment.IRPTotalOverrideReason = summary.OverrideReason;
            }

            foreach (IRPSummary irp in summary.Irps)
            {
                ASSESSMENT_IRP_HEADER dbSummary = _context.ASSESSMENT_IRP_HEADER.FirstOrDefault(s => s.ASSESSMENT_ID == assessment.Assessment_Id && s.HEADER_RISK_LEVEL_ID == irp.RiskLevelId);
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

            _context.SaveChanges();

        }

        private static Dictionary<int, SpanishQuestionRow> dict = null;

        public static Dictionary<int, SpanishQuestionRow> buildQuestionDictionary()
        {
            if (AcetBusiness.dict != null)
            {
                return AcetBusiness.dict;
            }

            String defaultPath = "App_Data\\ACET Spanish Question Mapping.xlsx";
            MemoryStream memStream = new MemoryStream();
            if(Path.Exists("..\\CSETWebCore.Business\\App_Data\\ACET Spanish Question Mapping.xlsx"))
            {
                defaultPath = "..\\CSETWebCore.Business\\App_Data\\ACET Spanish Question Mapping.xlsx";
            }
            FileStream file = File.OpenRead(defaultPath);
            file.CopyTo(memStream);

            IWorkbook workbook = WorkbookFactory.Create(memStream);

            var mapper = new Mapper(workbook);
            List<RowInfo<SpanishQuestionRow>> myExcelObjects = mapper.Take<SpanishQuestionRow>(workbook.ActiveSheetIndex).ToList();

            var rowCount = myExcelObjects.Count;

            AcetBusiness.dict = new Dictionary<int, SpanishQuestionRow>();

            foreach (RowInfo<SpanishQuestionRow> item in myExcelObjects)
            {
                try
                {
                    dict.Add(item.Value.Mat_Question_Id, item.Value);
                }
                catch (Exception e)
                {
                    NLog.LogManager.GetCurrentClassLogger().Error($"... {e}");
                }
            }
            return dict;
        }

        public static Dictionary<int, GroupingSpanishRow> buildGroupingDictionary()
        {
            String defaultPath = "App_Data\\Spanish ACET Groupings.xlsx";
            MemoryStream memStream = new MemoryStream();
            if (Path.Exists("..\\CSETWebCore.Business\\App_Data\\Spanish ACET Groupings.xlsx"))
            {
                defaultPath = "..\\CSETWebCore.Business\\App_Data\\Spanish ACET Groupings.xlsx";
            }
            FileStream file = File.OpenRead(defaultPath);
            file.CopyTo(memStream);

            IWorkbook workbook = WorkbookFactory.Create(memStream);

            var mapper = new Mapper(workbook);
            List<RowInfo<GroupingSpanishRow>> myExcelObjects = mapper.Take<GroupingSpanishRow>(workbook.ActiveSheetIndex).ToList();

            var rowCount = myExcelObjects.Count;

            var dict = new Dictionary<int, GroupingSpanishRow>();
            foreach (RowInfo<GroupingSpanishRow> item in myExcelObjects)
            {
                try
                {
                    dict.Add(item.Value.Grouping_Id, item.Value);
                }
                catch (Exception e)
                {
                    NLog.LogManager.GetCurrentClassLogger().Error($"... {e}");
                }
            }

            return dict;
        }

        public static Dictionary<string, GroupingSpanishRow> buildResultsGroupingDictionary()
        {
            
            String defaultPath = "App_Data\\Spanish ACET Groupings.xlsx";
            MemoryStream memStream = new MemoryStream();
            if (Path.Exists("..\\CSETWebCore.Business\\App_Data\\Spanish ACET Groupings.xlsx"))
            {
                defaultPath = "..\\CSETWebCore.Business\\App_Data\\Spanish ACET Groupings.xlsx";
            }
            FileStream file = File.OpenRead(defaultPath);
            file.CopyTo(memStream);

            IWorkbook workbook = WorkbookFactory.Create(memStream);

            var mapper = new Mapper(workbook);
            List<RowInfo<GroupingSpanishRow>> myExcelObjects = mapper.Take<GroupingSpanishRow>(workbook.ActiveSheetIndex).ToList();

            var rowCount = myExcelObjects.Count;

            var dict = new Dictionary<string, GroupingSpanishRow>();

            foreach (RowInfo<GroupingSpanishRow> item in myExcelObjects)
            {
                try
                {
                    dict.Add(item.Value.English_Title, item.Value);
                }
                catch (Exception e)
                {
                    NLog.LogManager.GetCurrentClassLogger().Error($"... {e}");
                }
            }
            return dict;
        }

        public static Dictionary<int, IRPModel> buildIRPDictionary()
        {
            String defaultPath = "App_Data\\Spanish_Mapped_IRPS.xlsx";
            MemoryStream memStream = new MemoryStream();
            if (Path.Exists("..\\CSETWebCore.Business\\App_Data\\Spanish_Mapped_IRPS.xlsx"))
            {
                defaultPath = "..\\CSETWebCore.Business\\App_Data\\Spanish_Mapped_IRPS.xlsx";
            }
            FileStream file = File.OpenRead(defaultPath);
            file.CopyTo(memStream);

            IWorkbook workbook = WorkbookFactory.Create(memStream);

            var mapper = new Mapper(workbook);
            List<RowInfo<IRPModel>> myExcelObjects = mapper.Take<IRPModel>(workbook.ActiveSheetIndex).ToList();

            var rowCount = myExcelObjects.Count;

            var dict = new Dictionary<int, IRPModel>();

            foreach (RowInfo<IRPModel> item in myExcelObjects)
            {
                try
                {
                    dict.Add(item.Value.IRP_Id, item.Value);
                }
                catch (Exception e)
                {
                    NLog.LogManager.GetCurrentClassLogger().Error($"... {e}");
                }
            }
            return dict;
        }

        public static Dictionary<int, IRPSpanishRow> buildIRPHeaderDictionary()
        {
            String defaultPath = "App_Data\\Spanish_Mapped_IRP_Headers.xlsx";
            MemoryStream memStream = new MemoryStream();
            if (Path.Exists("..\\CSETWebCore.Business\\App_Data\\Spanish_Mapped_IRP_Headers.xlsx"))
            {
                defaultPath = "..\\CSETWebCore.Business\\App_Data\\Spanish_Mapped_IRP_Headers.xlsx";
            }
            FileStream file = File.OpenRead(defaultPath);
            file.CopyTo(memStream);

            IWorkbook workbook = WorkbookFactory.Create(memStream);

            var mapper = new Mapper(workbook);
            List<RowInfo<IRPSpanishRow>> myExcelObjects = mapper.Take<IRPSpanishRow>(workbook.ActiveSheetIndex).ToList();

            var rowCount = myExcelObjects.Count;
            var dict = new Dictionary<int, IRPSpanishRow>();
            
            foreach (RowInfo<IRPSpanishRow> item in myExcelObjects)
            {
                try
                {
                    dict.Add(item.Value.IRP_Header_Id, item.Value);
                }
                catch (Exception e)
                {
                    NLog.LogManager.GetCurrentClassLogger().Error($"... {e}");
                }
            }

            return dict;
        }

        public static Dictionary<string, IRPSpanishRow> buildIRPDashboardDictionary()
        {
            String defaultPath = "App_Data\\Spanish_Mapped_IRP_Headers.xlsx";
            MemoryStream memStream = new MemoryStream();
            if (Path.Exists("..\\CSETWebCore.Business\\App_Data\\Spanish_Mapped_IRP_Headers.xlsx"))
            {
                defaultPath = "..\\CSETWebCore.Business\\App_Data\\Spanish_Mapped_IRP_Headers.xlsx";
            }
            FileStream file = File.OpenRead(defaultPath);
            file.CopyTo(memStream);

            IWorkbook workbook = WorkbookFactory.Create(memStream);

            var mapper = new Mapper(workbook);
            List<RowInfo<IRPSpanishRow>> myExcelObjects = mapper.Take<IRPSpanishRow>(workbook.ActiveSheetIndex).ToList();

            var rowCount = myExcelObjects.Count;
            var dict = new Dictionary<string, IRPSpanishRow>();

            // ACETDashboard
            foreach (RowInfo<IRPSpanishRow> item in myExcelObjects)
            {
                try
                {
                    dict.Add(item.Value.EnglishHeader, item.Value);
                }
                catch (Exception e)
                {
                    NLog.LogManager.GetCurrentClassLogger().Error($"... {e}");
                }
            }

            return dict;
        }

    }
}
