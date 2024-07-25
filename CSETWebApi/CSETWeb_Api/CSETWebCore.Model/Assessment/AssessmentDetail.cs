//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Question;

namespace CSETWebCore.Model.Assessment
{
    public class AssessmentDetail
    {
        public bool is_PCII { get; set; }

        public int Id { get; set; }
        public string AssessmentName { get; set; }
        public DateTime CreatedDate { get; set; }
        public int? CreatorId { get; set; }
        public string CreatorName { get; set; }
        public DateTime? AssessmentDate { get; set; }
        public DateTime? AssessmentEffectiveDate { get; set; }
        public string FacilityName { get; set; }
        public string CityOrSiteName { get; set; }
        public string StateProvRegion { get; set; }
        public string PostalCode { get; set; }
        public int? RegionCode { get; set; }

        public string Charter { get; set; }
        public string CreditUnion { get; set; }
        public long Assets { get; set; }

        public string DiagramMarkup { get; set; }
        public string DiagramImage { get; set; }


        public int? SectorId { get; set; }
        public int? IndustryId { get; set; }


        // Selected features of the assessment
        public bool UseStandard { get; set; }
        public bool UseDiagram { get; set; }
        public bool UseMaturity { get; set; }
        public bool? IsAcetOnly { get; set; }
        public bool? IseSubmitted { get; set; }
        public bool? ISE_StateLed { get; set; }

        public List<string> HiddenScreens { get; set; } = new List<string>();

        public int? BaselineAssessmentId { get; set; }
        public string BaselineAssessmentName { get; set; }

        public string Workflow { get; set; }
        public Guid? GalleryItemGuid { get; set; }

        public Guid AssessmentGuid { get; set; }

        /// <summary>
        /// Created to be flexible to able to 'flag' an assessment for a special behavior
        /// </summary>
        public string Origin { get; set; }

        // Selected maturity model and the target level
        public MaturityModel MaturityModel { get; set; }

        public List<string> Standards { get; set; }

        public string ApplicationMode { get; set; }

        public QuestionRequirementCounts QuestionRequirementCounts { get; set; }


        /// <summary>
        /// The last time the Assessment was altered.
        /// </summary>
        public DateTime LastModifiedDate { get; set; }

        public string AdditionalNotesAndComments { get; set; }
        public string AssessmentDescription { get; set; }
        public string ExecutiveSummary { get; set; }
        public string TypeTitle { get; set; }
        public string TypeDescription { get; set; }
        public string PciiNumber { get; set; }
    }
}
