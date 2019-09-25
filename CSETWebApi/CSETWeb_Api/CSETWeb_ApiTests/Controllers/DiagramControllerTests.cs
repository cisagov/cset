using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWeb_Api.Controllers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWeb_Api.Models;
using System.IO;

namespace CSETWeb_Api.Controllers.Tests
{
    [TestClass()]
    public class DiagramControllerTests
    {
        [TestMethod()]
        public void PerformAnalysisTest()
        {
            DiagramController controller = new DiagramController();
            DiagramRequest request = new DiagramRequest();
            request.DiagramXml = File.ReadAllText("TestItems\\SampleDiagram.txt");
            controller.performAnalysis(request, 2);
        }
    }
}