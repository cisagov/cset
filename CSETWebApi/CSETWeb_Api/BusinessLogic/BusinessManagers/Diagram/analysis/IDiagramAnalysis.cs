using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessManagers.Diagram.Analysis
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
