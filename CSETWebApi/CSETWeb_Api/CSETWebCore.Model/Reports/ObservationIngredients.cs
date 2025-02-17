using CSETWebCore.DataLayer.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Reports
{
    public class ObservationIngredients
    {
        public FINDING Finding { get; set; }
        public FINDING_CONTACT FC { get; set; }
        public ANSWER Answer { get; set; }
        public MATURITY_QUESTIONS MaturityQuestion { get; set; }
        public NEW_REQUIREMENT NewRequirement { get; set; }

        public IMPORTANCE Importance { get; set; }
    }
}
