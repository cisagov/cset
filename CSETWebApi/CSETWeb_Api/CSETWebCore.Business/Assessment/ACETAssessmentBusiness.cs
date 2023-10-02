//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Contact;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.Sal;
using CSETWebCore.Interfaces.Standards;
using CSETWebCore.Model.Acet;
using CSETWebCore.Model.Assessment;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;

namespace CSETWebCore.Business.Assessment
{
    public class ACETAssessmentBusiness : AssessmentBusiness, ICreateAssessmentBusiness, IACETAssessmentBusiness
    {
        private CSETContext _context;

        public ACETAssessmentBusiness(IHttpContextAccessor httpContext, ITokenManager authentication, IUtilities utilities, IContactBusiness contactBusiness, ISalBusiness salBusiness, IMaturityBusiness maturityBusiness, IAssessmentUtil assessmentUtil, IStandardsBusiness standardsBusiness, IDiagramManager diagramManager, CSETContext context)
            : base(httpContext, authentication, utilities, contactBusiness, salBusiness, maturityBusiness, assessmentUtil, standardsBusiness, diagramManager, context)
        {

            this._context = context;
        }

        public new int SaveAssessmentDetail(int assessmentId, AssessmentDetail assessment)
        {
            assessmentId = base.SaveAssessmentDetail(assessmentId, assessment);
            var dbAssessment = _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            dbAssessment.Charter = string.IsNullOrEmpty(assessment.Charter) ? "00000" : assessment.Charter.PadLeft(5, '0');
            dbAssessment.CreditUnionName = assessment.CreditUnion;
            dbAssessment.Assets = assessment.Assets.ToString();
            dbAssessment.ISE_StateLed = assessment.ISE_StateLed;
            dbAssessment.MatDetail_targetBandOnly = true;

            
            if (!assessment.AssessmentName.StartsWith("ISE ") && (!assessment.AssessmentName.StartsWith("Merged ")))
            {
                var creditUnion = string.IsNullOrEmpty(assessment.CreditUnion)
                    ? string.Empty
                    : assessment.CreditUnion + " ";
                assessment.AssessmentName = "ACET " + dbAssessment.Charter + " " + creditUnion + dbAssessment.Assessment_Date.ToString("MMddyy");
            }
            var dbInformation = _context.INFORMATION.Where(x => x.Id == assessmentId).FirstOrDefault();
            dbInformation.Assessment_Name = assessment.AssessmentName;
            _context.INFORMATION.Update(dbInformation);
            _context.SaveChanges();

            return assessmentId;
        }

        public new AssessmentDetail CreateNewAssessment(int? currentUserId,
            string workflow, GalleryConfig config)
        {
            var detail =base.CreateNewAssessment(currentUserId, workflow, config);
            detail.AssessmentName = "ACET 00000 " + DateTime.Now.ToString("MMddyy");
            base.SaveAssessmentDetail(detail.Id, detail);

            if(UsesIRP(config.Model.ModelName))
            {
                CreateIrpHeaders(detail.Id);
            }
            return detail;
        }

        private static HashSet<String> supportedList = new HashSet<string>() { "ACET", "ISE" };

        public bool UsesIRP(string setOrModelName)
        {
            if (String.IsNullOrWhiteSpace(setOrModelName))
            {
                return false;
            }
            return supportedList.Contains(setOrModelName);
        }

        /// <summary>
        /// Create new headers for IRP calculations
        /// </summary>
        /// <param name="assessmentId"></param>
        public void CreateIrpHeaders(int assessmentId)
        {
            int idOffset = 1;
            // now just properties on an Assessment
            ASSESSMENTS assessment = _context.ASSESSMENTS.FirstOrDefault(a => a.Assessment_Id == assessmentId);

            foreach (IRP_HEADER header in _context.IRP_HEADER)
            {
                IRPSummary summary = new IRPSummary();
                summary.HeaderText = header.Header;               
                summary.RiskLevel = 0;

                ASSESSMENT_IRP_HEADER headerInfo = new ASSESSMENT_IRP_HEADER()
                {
                    RISK_LEVEL = 0,
                    IRP_HEADER = header
                };
                headerInfo.ASSESSMENT_ID = assessmentId;                
                if (_context.ASSESSMENT_IRP_HEADER.Count() == 0)
                {
                    headerInfo.HEADER_RISK_LEVEL_ID = header.IRP_Header_Id;
                }
                else
                {
                    headerInfo.HEADER_RISK_LEVEL_ID =
                        _context.ASSESSMENT_IRP_HEADER.Max(i => i.HEADER_RISK_LEVEL_ID) + idOffset;
                    idOffset++;
                }

                summary.RiskLevelId = headerInfo.HEADER_RISK_LEVEL_ID ?? 0;

                _context.ASSESSMENT_IRP_HEADER.Add(headerInfo);
            }

            _context.SaveChanges();
        }

    }
}