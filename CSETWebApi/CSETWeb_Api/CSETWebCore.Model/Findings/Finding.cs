using System;
using System.Collections.Generic;
using System.Linq;

namespace CSETWebCore.Model.Findings
{
    public class Finding
    {
        public int Question_Id { get; set; }
        public int Answer_Id { get; set; }
        public int Finding_Id { get; set; }
        public string Summary { get; set; }
        public string Issue { get; set; }
        public string Impact { get; set; }
        public string Recommendations { get; set; }
        public string Vulnerabilities { get; set; }
        public Nullable<System.DateTime> Resolution_Date { get; set; }
        public Nullable<int> Importance_Id { get; set; }
        public Importance Importance { get; set; }
        public List<FindingContact> Finding_Contacts { get; set; }

        public bool IsFindingEmpty()
        {
            bool noValue = true;

            noValue = noValue && String.IsNullOrWhiteSpace(Impact);
            //hasValues = hasValues && webFinding.Importance
            noValue = noValue && String.IsNullOrWhiteSpace(Issue);
            noValue = noValue && String.IsNullOrWhiteSpace(Recommendations);
            noValue = noValue && String.IsNullOrWhiteSpace(Impact);
            noValue = noValue && String.IsNullOrWhiteSpace(Summary);
            noValue = noValue && String.IsNullOrWhiteSpace(Vulnerabilities);
            noValue = noValue && Resolution_Date == null;
            noValue = noValue && Finding_Contacts.Count(x => x.Selected) == 0;

            return noValue;
        }
    }
}