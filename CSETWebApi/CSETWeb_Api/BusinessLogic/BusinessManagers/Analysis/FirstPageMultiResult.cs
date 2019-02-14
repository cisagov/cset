using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessManagers.Analysis
{
    public class FirstPageMultiResult:MultiResultBase
    {
        private List<GetCombinedOveralls> result1; 
        public List<GetCombinedOveralls> Result1
        {
            get { return result1; }
            set { result1 = value; Count++; }
        }
        
        private List<usp_getRankedCategories> result2;
        public List<usp_getRankedCategories> Result2
        {
            get { return result2; }
            set { result2 = value; Count++; }
        }
    }
}
