//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;

namespace CSETWebCore.Model.Observations
{
    public class Observation
    {
        public int Question_Id { get; set; }
        public int Answer_Id { get; set; }
        public int Observation_Id { get; set; }
        public string Summary { get; set; }
        public string Issue { get; set; }
        public string Impact { get; set; }
        public string Recommendations { get; set; }
        public string Vulnerabilities { get; set; }
        public Nullable<System.DateTime> Resolution_Date { get; set; }
        public Nullable<int> Importance_Id { get; set; }
        public Importance Importance { get; set; }
        public string Title { get; set; }
        public string Type { get; set; }
        public string Risk_Area { get; set; }
        public string Sub_Risk { get; set; }
        public string Description { get; set; }
        public string Citations { get; set; }
        public string ActionItems { get; set; }
        public int Auto_Generated { get; set; }
        public string Supp_Guidance { get; set; }
        public List<ObservationContact> Observation_Contacts { get; set; }

        public bool IsObservationEmpty(bool cancel = false)
        {
            bool noValue = true;

            if (cancel == true)
            {
                return noValue;
            }

            noValue = noValue && String.IsNullOrWhiteSpace(Impact);
            noValue = noValue && String.IsNullOrWhiteSpace(Issue);
            noValue = noValue && String.IsNullOrWhiteSpace(Recommendations);
            noValue = noValue && String.IsNullOrWhiteSpace(Impact);
            noValue = noValue && String.IsNullOrWhiteSpace(Summary);
            noValue = noValue && String.IsNullOrWhiteSpace(Vulnerabilities);
            noValue = noValue && Resolution_Date == null;
            noValue = noValue && String.IsNullOrWhiteSpace(Title);
            noValue = noValue && Type == null;
            noValue = noValue && String.IsNullOrWhiteSpace(Description);
            noValue = noValue && !Observation_Contacts.Any(x => x.Selected);

            return noValue;
        }
    }
}