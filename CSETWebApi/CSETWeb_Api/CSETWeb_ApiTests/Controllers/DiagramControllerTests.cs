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
        public void CleanDiagramAnalysisTest()
        {
            DiagramController controller = new DiagramController();
            DiagramRequest request = new DiagramRequest();
            request.DiagramXml = File.ReadAllText("TestItems\\CleanDiagram.txt");
            var test = controller.performAnalysis(request, 1);
            Assert.AreEqual(test.Count, 0);
            var jstring = Newtonsoft.Json.JsonConvert.SerializeObject(test);
            Trace.Write(jstring);
        }

        [TestMethod()]
        public void PerformAnalysisTestRule2()
        {
            DiagramController controller = new DiagramController();
            DiagramRequest request = new DiagramRequest();
            request.DiagramXml = File.ReadAllText("TestItems\\Rule2.txt");
            var test = controller.performAnalysis(request, 1);
            Assert.AreEqual(test.Count, 1);
            var jstring = Newtonsoft.Json.JsonConvert.SerializeObject(test);
            Trace.Write(jstring);
        }

        [TestMethod()]
        public void PerformAnalysisTestRule1()
        {
            DiagramController controller = new DiagramController();
            DiagramRequest request = new DiagramRequest();
            request.DiagramXml = File.ReadAllText("TestItems\\SampleDiagram.txt");
            var test = controller.performAnalysis(request, 1);            
            var jstring =  Newtonsoft.Json.JsonConvert.SerializeObject(test);
            Trace.Write(jstring);
            Assert.AreEqual(test.Count, 3);
        }

        [TestMethod()]
        public void PerformAnalysisTestRules()
        {
            DiagramController controller = new DiagramController();
            DiagramRequest request = new DiagramRequest();
            string[] testDiagrams = new string[]
            {   
                "TestItems\\Rule2.txt",
                "TestItems\\Rule3.txt",
                "TestItems\\Rule4.xml",
                "TestItems\\Rule5.txt",
                "TestItems\\Rule6.xml"
            };
            foreach (string path in testDiagrams)
            {
                request.DiagramXml = File.ReadAllText(path);
                var test = controller.performAnalysis(request, 1);
                Assert.IsTrue(test.Count > 0,path);
                var jstring = Newtonsoft.Json.JsonConvert.SerializeObject(test);
                Trace.Write(jstring);
            }
        }

        [TestMethod()]
        public void PerformAnalysisTestRule5()
        {
            DiagramController controller = new DiagramController();
            DiagramRequest request = new DiagramRequest();
            request.DiagramXml = File.ReadAllText("TestItems\\Rule5.txt");
            var test = controller.performAnalysis(request, 1);
            Assert.AreEqual(test.Count, 3);
            var jstring = Newtonsoft.Json.JsonConvert.SerializeObject(test);
            Trace.Write(jstring);
        }


        [TestMethod()]
        public void PerformAnalysisTestRule7()
        {
            DiagramController controller = new DiagramController();
            DiagramRequest request = new DiagramRequest();
            request.DiagramXml = File.ReadAllText("TestItems\\Rule7.txt");
            var test = controller.performAnalysis(request, 1);
            Assert.AreEqual(test.Count, 1);
            var jstring = Newtonsoft.Json.JsonConvert.SerializeObject(test);
            Trace.Write(jstring);
        }

        [TestMethod()]
        public void PerformAnalysisTestRule4()
        {
            DiagramController controller = new DiagramController();
            DiagramRequest request = new DiagramRequest();
            request.DiagramXml = File.ReadAllText("TestItems\\Rule4.xml");
            var test = controller.performAnalysis(request, 1);
            Assert.IsTrue(test.Count==7, "Rule 4");
            var jstring = Newtonsoft.Json.JsonConvert.SerializeObject(test);
            Trace.Write(jstring);
        }


        [TestMethod()]
        public void PerformAnalysisTestRule6()
        {
            DiagramController controller = new DiagramController();
            DiagramRequest request = new DiagramRequest();
            request.DiagramXml = File.ReadAllText("TestItems\\Rule6.xml");
            var test = controller.performAnalysis(request, 1);
            Assert.IsTrue(test.Count >= 1, "Rule 6");
            var jstring = Newtonsoft.Json.JsonConvert.SerializeObject(test);
            Trace.Write(jstring);
        }
    }
}