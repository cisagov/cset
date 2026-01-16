////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
namespace CSETWebCore.Model.Analysis
{
    /// <summary>
    /// Result model for components ranked categories analysis.
    /// </summary>
    public class ComponentsRankedCategory
    {
        public string Question_Group_Heading { get; set; }
        public int qc { get; set; }
        public int cr { get; set; }
        public int Total { get; set; }
        public int nuCount { get; set; }
        public int Actualcr { get; set; }
        public decimal prc { get; set; }
        public decimal Percent { get; set; }
    }
}
