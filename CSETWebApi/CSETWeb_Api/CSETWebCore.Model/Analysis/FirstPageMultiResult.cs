//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Analysis
{
    public class FirstPageMultiResult : MultiResultBase
    {
        private List<GetCombinedOveralls> result1;
        public List<GetCombinedOveralls> Result1
        {
            get { return result1; }
            set { result1 = value; Count++; }
        }

        private List<RankedCategories> result2;
        public List<RankedCategories> Result2
        {
            get { return result2; }
            set { result2 = value; Count++; }
        }
    }
    public class RankedCategoriesMultiResult : MultiResultBase
    {
        private List<RankedCategories> result1;
        public List<RankedCategories> Result1
        {
            get { return result1; }
            set { result1 = value; Count++; }
        }
    }
    public class StandardSummaryOverallMultiResult : MultiResultBase
    {
        private List<DataRowsPie> result1;
        public List<DataRowsPie> Result1
        {
            get { return result1; }
            set { result1 = value; Count++; }
        }
    }

    public class StandardSummaryMultiResult : MultiResultBase
    {
        private List<DataRowsPie> result1;
        public List<DataRowsPie> Result1
        {
            get { return result1; }
            set { result1 = value; Count++; }
        }
    }
}