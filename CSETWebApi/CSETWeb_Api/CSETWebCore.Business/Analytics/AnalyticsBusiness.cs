//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Manual;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Analytics;
using CSETWebCore.Model.Dashboard;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.Model.Analytics;
using Microsoft.EntityFrameworkCore;
using AggregationAssessment = CSETWebCore.Model.Assessment.AggregationAssessment;

namespace CSETWebCore.Business.Analytics
{
    public class AnalyticsBusiness : IAnalyticsBusiness
    {
        private CSETContext _context;

        public AnalyticsBusiness(CSETContext context)
        {
            _context = context;

        }


        public List<AnalyticsMinMaxAvgMedianByGroup> getMaturityDashboardData(int maturity_model_id, int? sectorId,
            int? industryId)
        {
            // var minMax = _context.analytics_Compute_MaturityAll(maturity_model_id,sectorId,industryId).ToList();
            // var median = _context.analytics_Compute_MaturityAll_Median(maturity_model_id).ToList();
            // var rvalue =  from a in minMax join b in median on a.Title equals b.Title
            //             select new DataRowsAnalytics() { title=a.Title, avg=(int)a.avg,max=(int)a.max,min=(int)a.min,median=b.median};
            // return rvalue.ToList();
            return _context.analytics_Compute_MaturityAll(maturity_model_id, sectorId, industryId).ToList();
        }

        public List<AnalyticsgetMedianOverall> GetMaturityGroupsForAssessment(int assessmentId, int maturity_model_id)
        {
            return _context.analytics_compute_single_averages_maturity(assessmentId, maturity_model_id).ToList();
        }

        public List<standardAnalyticsgetMedianOverall> GetStandardSingleAvg(int assessmentId, string set_name)
        {
            return _context.analytics_compute_single_averages_standard(assessmentId, set_name).ToList();
        }

        public List<SetStandard> GetStandardList(int assessmentId)
        {
            // var resultsList = from standards in _context.AVAILABLE_STANDARDS
            //     join sets in _context.SETS
            //         on standards.Set_Name equals sets.Set_Name
            //     where standards.Assessment_Id == assessmentId
            //     select sets.Full_Name;
            var results = _context.analytics_selectedStandardList(assessmentId);
            return results.ToList();
        }

        public List<AnalyticsStandardMinMaxAvg> GetStandardMinMaxAvg(int assessmentId, string setname, int? sectorId,
            int? industryId)
        {
            var minmaxavg = _context.analytics_Compute_standard_all(assessmentId, setname, sectorId, industryId);
            return minmaxavg.ToList();
        }

        public object GetAggregationAssessment(int assessmentId)
        {
            AggregationAssessment aggregationAssessment = new AggregationAssessment();
            
            var assessment = (from a in _context.ASSESSMENTS
                where a.Assessment_Id == assessmentId
                select new AgAssessment
                {
                    AssessmentId = a.Assessment_Id,
                    AssessmentGuid = a.Assessment_GUID,
                    AssessmentCreatedDate = a.AssessmentCreatedDate,
                    LastModifiedDate = a.LastModifiedDate,
                    Alias = a.Alias,
                    AssessmentDate = a.Assessment_Date,
                    CreditUnionName = a.CreditUnionName,
                    Charter = a.Charter,
                    Assets = a.Assets,
                    IrptotalOverride = a.IRPTotalOverride,
                    IrptotalOverrideReason = a.IRPTotalOverrideReason,
                    MatDetailTargetBandOnly = a.MatDetail_targetBandOnly,
                    DiagramMarkup = a.Diagram_Markup,
                    LastUsedComponentNumber = a.LastUsedComponentNumber,
                    DiagramImage = a.Diagram_Image,
                    AnalyzeDiagram = a.AnalyzeDiagram,
                    UseDiagram = a.UseDiagram,
                    UseStandard = a.UseStandard,
                    UseMaturity = a.UseStandard,
                    AssessmentEffectiveDate = a.AssessmentEffectiveDate,
                    GalleryItemGuid = a.GalleryItemGuid,
                    IseStateLed = a.ISE_StateLed,
                    PciiNumber = a.PCII_Number,
                    IsPcii = a.Is_PCII
                }).FirstOrDefault();
            var answers = (from a in _context.ANSWER
                where a.Assessment_Id == assessmentId
                select new AgAnswer
                {
                    AnswerId = a.Answer_Id,
                    QuestionOrRequirementId = a.Question_Or_Requirement_Id,
                    MarkForReview = a.Mark_For_Review,
                    Comment = a.Comment,
                    AlternateJustification = a.Alternate_Justification,  
                    QuestionNumber = a.Question_Number,
                    AnswerText = a.Answer_Text,
                    ComponentGuid = a.Component_Guid,
                    CustomQuestionGuid = a.Custom_Question_Guid,
                    OldAnswerId = a.Old_Answer_Id,
                    Reviewed = a.Reviewed,
                    FeedBack = a.FeedBack,
                    QuestionType = a.Question_Type,
                    IsRequirement  = a.Is_Requirement,
                    IsComponent = a.Is_Component,
                    IsFramework = a.Is_Framework,
                    IsMaturity = a.Is_Maturity,
                    FreeResponseAnswer = a.Free_Response_Answer,
                    MatOptionId = a.Mat_Option_Id,
                    AssessmentId = a.Assessment_Id
                }).ToList();
            var demographics = (from d in _context.DEMOGRAPHICS
                where d.Assessment_Id == assessmentId
                select new AgDemographics
                {
                    SectorId = d.SectorId,
                    IndustryId = d.IndustryId,
                    Size = d.Size,
                    AssetValue = d.AssetValue,
                    NeedsPrivacy = d.NeedsPrivacy,
                    NeedsSupplyChain = d.NeedsSupplyChain,
                    NeedsIcs = d.NeedsICS,
                    OrganizationName = d.OrganizationName, 
                    Agency = d.Agency,
                    OrganizationType = d.OrganizationType,
                    Facilitator = d.Facilitator,
                    PointOfContact = d.PointOfContact,
                    IsScoped = d.IsScoped,
                    CriticalService = d.CriticalService,
                    AssessmentId = d.Assessment_Id
                }).FirstOrDefault();

            var documents = (from d in _context.DOCUMENT_FILE
                where d.Assessment_Id == assessmentId
                select new AgDocuments
                {
                    DocumentId = d.Document_Id,
                    Path = d.Path,
                    Title = d.Title,
                    FileMd5 = d.FileMd5,
                    ContentType = d.ContentType,
                    CreatedTimeStamp = d.CreatedTimestamp,
                    UpdatedTimeStamp = d.UpdatedTimestamp,
                    Name = d.Name,
                    Data = d.Data,
                    AssessmentId = d.Assessment_Id
                }).ToList();
            List<AgFinding> findings = new List<AgFinding>();
            foreach (var a in answers)
            {
                var tempFindings = (from f in _context.FINDING
                    where f.Answer_Id == a.AnswerId
                    select new AgFinding
                    {
                        AnswerId  = f.Answer_Id,
                        FindingId = f.Finding_Id,
                        Summary = f.Summary,
                        Issue = f.Issue,
                        Impact = f.Impact,
                        Recommendations = f.Recommendations,
                        Vulnerabilities = f.Vulnerabilities,
                        ResolutionDate = f.Resolution_Date, 
                        ImportanceId = f.Importance_Id,
                        Title = f.Title,
                        Type = f.Type,
                        Description = f.Description,
                        AutoGenerated = f.Auto_Generated,
                        Citations = f.Citations,
                        RiskArea = f.Risk_Area,
                        SubRisk = f.Sub_Risk,
                        ActionItems = f.ActionItems,
                        SuppGuidance = f.Supp_Guidance
                    }).ToList();
                findings.AddRange(tempFindings);
            }

            return new
            {
                assessment,
                findings,
                answers,
                demographics,
                documents
            };
        }

       
    }
}
