using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWebCore.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Helpers.Tests
{
    [TestClass()]
    public class CrrScoringHelperTests
    {
        [TestMethod()]
        public void InstantiateScoringHelperTest()
        {
            CSETWebCore.DataLayer.CSETContext context = new DataLayer.CSETContext();
            context.OverrideConnectionString("data source=(localdb)\\MSSQLLocalDb;initial catalog=CSETWeb;persist security info=True;Integrated Security=SSPI;MultipleActiveResultSets=True");
            CrrScoringHelper crrScoring = new CrrScoringHelper(context);

            crrScoring.InstantiateScoringHelper(59);

        }
    }
}