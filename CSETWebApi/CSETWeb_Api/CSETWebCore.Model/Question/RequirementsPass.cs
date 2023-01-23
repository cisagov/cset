//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using System.Linq;

namespace CSETWebCore.Model.Question
{
    public class RequirementsPass
    {
        public IQueryable<RequirementPlus> Requirements { get; set; }
        public IQueryable<FullAnswer> Answers { get; set; }
        public List<DomainAssessmentFactor> DomainAssessmentFactors { get; set; }
    }
}