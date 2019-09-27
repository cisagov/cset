using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWeb_Api.BusinessManagers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataLayerCore.Model;

namespace CSETWeb_Api.BusinessManagers.Tests
{
    [TestClass()]
    public class DiagramManagerTests
    {
        [TestMethod()]
        public void getLayerVisibilityTest()
        {
            using(CSET_Context db =new CSET_Context())
            {
                DiagramManager manager = new DiagramManager(db);
                //manager.getLayerVisibility(;
            }
            


        }
    }
}