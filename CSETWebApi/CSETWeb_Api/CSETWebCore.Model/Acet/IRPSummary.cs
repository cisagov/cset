namespace CSETWebCore.Model.Acet
{
    public class IRPSummary
    {
        public string HeaderText;
        public int[] RiskCount;
        public int RiskSum;
        public int RiskLevel;
        public int RiskLevelId;
        public string Comment;

        public IRPSummary()
        {
            RiskCount = new int[5];
        }
    }
}
