//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Collections.Generic;
using ResourceLibrary.Nodes;

namespace CSETWeb_Api.Controllers.Tests
{
    [TestClass()]
    public class ResourceLibraryControllerTests
    {
       [TestMethod()]
        public void GetDetailsTest()
        {
            ResourceLibraryController controller = new ResourceLibraryController();
            List<ResourceNode> list =  controller.GetDetails(new SearchRequest()
            {
                term = "test"
            });
            Assert.IsNotNull(list);
            
        }
    }
}

