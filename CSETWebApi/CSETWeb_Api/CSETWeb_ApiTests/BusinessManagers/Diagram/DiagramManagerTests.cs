using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWeb_Api.BusinessManagers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessManagers.Tests
{
    [TestClass()]
    public class DiagramManagerTests
    {
        [TestMethod()]
        public void getLayerVisibilityTest()
        {
            DiagramManager manager = new DiagramManager();
            manager.getLayerVisibility();


        }
    }
}