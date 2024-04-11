//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Maturity
{
    public class MaturityComponent
    {
        public int ComponentId { get; set; }
        public string ComponentName { get; set; }
        public bool Incomplete { get; set; }
        public double Baseline { get; set; }
        public double Evolving { get; set; }
        public double Intermediate { get; set; }
        public double Advanced { get; set; }
        public double Innovative { get; set; }
        public double Scuep { get; set; }
        public double Core { get; set; }
        public double CorePlus { get; set; }
        public string AssessedMaturityLevel { get; set; }
        public int Sequence { get; set; }
    }
}