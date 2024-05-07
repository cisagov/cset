using CSETWebCore.DataLayer.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Observations
{
    public class MergeObservation
    {
        public MergeObservation() { }

        public MergeObservation(int assessmentId, List<FINDING> observations) 
        {
            this.assessmentId = assessmentId;
            this.observations = observations;
        }


        public int assessmentId { get; set; }
        public List<FINDING> observations { get; set; }
    }
}
