//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Business.Diagram.Analysis
{
    public interface IDiagramAnalysis
    {
        void AnalyzeNetwork();
        void ChangeItemsInZone();
        void DisableAnalysis();
        void EnableAnalysisAndRun();
        void EnableAnalysis();
    }
}
