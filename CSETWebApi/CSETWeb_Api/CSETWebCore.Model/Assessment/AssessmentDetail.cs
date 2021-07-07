using System;
using System.Collections.Generic;
using CSETWebCore.Model.Maturity;

namespace CSETWebCore.Model.Assessment
{
    public class AssessmentDetail
    {
        public int Id { get; set; }
        public string AssessmentName{ get; set; }
        public DateTime CreatedDate{ get; set; }
        public int CreatorId{ get; set; }
        public DateTime? AssessmentDate{ get; set; }
        public string FacilityName{ get; set; }
        public string CityOrSiteName{ get; set; }
        public string StateProvRegion{ get; set; }

        public string Charter{ get; set; }
        public string CreditUnion{ get; set; }
        public int? Assets{ get; set; }

        public string DiagramMarkup{ get; set; }
        public string DiagramImage{ get; set; }

        // Selected features of the assessment
        public bool UseStandard{ get; set; }
        public bool UseDiagram{ get; set; }
        public bool UseMaturity{ get; set; }
        public bool? IsAcetOnly{ get; set; }

        // Selected maturity model and the target level
        public MaturityModel MaturityModel{ get; set; }

        public List<string> Standards{ get; set; }


        /// <summary>
        /// The last time the Assessment was altered.
        /// </summary>
        public DateTime LastModifiedDate{ get; set; }

        public string AdditionalNotesAndComments { get; set; }
        public string AssessmentDescription { get; set; }
        public string ExecutiveSummary { get; set; }
    }
}
