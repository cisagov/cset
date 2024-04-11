//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Question
{
    public class DomainAssessmentFactor
    {
        public string DomainName;
        public string AssessmentFactorName;

        public override string ToString()
        {
            return string.Format("DomainName: {0}, AssessmentFactorName: {1}", this.DomainName, this.AssessmentFactorName);
        }
    }
}