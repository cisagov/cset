using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWeb_Api.Controllers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWeb_Api.Models;
using System.IO;
using Newtonsoft.Json;
using System.Diagnostics;

namespace CSETWeb_Api.Controllers.Tests
{
    [TestClass()]
    public class DiagramControllerTests
    {
        [TestMethod()]
        public void PerformAnalysisTestRule1()
        {
            DiagramController controller = new DiagramController();
            DiagramRequest request = new DiagramRequest();
            request.DiagramXml = File.ReadAllText("TestItems\\SampleDiagram.txt");
            var test = controller.performAnalysis(request, 2);
            Assert.AreEqual(test.Count,2);
            var jstring =  Newtonsoft.Json.JsonConvert.SerializeObject(test);
            Trace.Write(jstring);

        }

        [TestMethod()]
        public void PerformAnalysisTestRule7()
        {
            DiagramController controller = new DiagramController();
            DiagramRequest request = new DiagramRequest();
            request.DiagramXml = File.ReadAllText("TestItems\\SampleDiagram.txt");
            var test = controller.performAnalysis(request, 2);
            Assert.AreEqual(test.Count, 2);
            var jstring = Newtonsoft.Json.JsonConvert.SerializeObject(test);
            Trace.Write(jstring);

        }
    }
}