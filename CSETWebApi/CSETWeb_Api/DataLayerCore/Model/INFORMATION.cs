using System;
using System.Collections.Generic;

namespace DataLayerCore.Model
{
    public partial class INFORMATION
    {
        public int Id { get; set; }
        public string Assessment_Name { get; set; }
        public string Facility_Name { get; set; }
        public string City_Or_Site_Name { get; set; }
        public string State_Province_Or_Region { get; set; }
        public string Assessor_Name { get; set; }
        public string Assessor_Email { get; set; }
        public string Assessor_Phone { get; set; }
        public string Assessment_Description { get; set; }
        public string Additional_Notes_And_Comments { get; set; }
        public string Additional_Contacts { get; set; }
        public string Executive_Summary { get; set; }
        public string Enterprise_Evaluation_Summary { get; set; }
        public string Real_Property_Unique_Id { get; set; }
        public int? eMass_Document_Id { get; set; }

        public virtual ASSESSMENTS IdNavigation { get; set; }
        public virtual DOCUMENT_FILE eMass_Document_ { get; set; }
    }
}
