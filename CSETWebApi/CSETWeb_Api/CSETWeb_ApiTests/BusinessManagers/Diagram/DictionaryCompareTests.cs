using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.Tests
{
    [TestClass()]
    public class DictionaryCompareTests
    {
        [TestMethod()]
        public void processComparisonTest()
        {

            Dictionary<Guid, string> newDiagram = new Dictionary<Guid, string>();
            Dictionary<Guid, string> oldDiagram = new Dictionary<Guid, string>();
            string[] array = { "2b3e2630-e9fa-4e9c-a37c-2a9872ffd5f2", "7a8d2204-cd33-49ab-ad5d-210984ce65e4", "99258abc-fd8d-46f8-9727-bb2cde4d7807", "46ae2afb-16ce-49e4-bde0-0c79e1402fdf", "a60c8baa-c409-4e8f-9906-d626fabed910", "c093c9cb-1cc6-44a9-ab93-ddc638fa4802" };


            foreach (var g in convertStringToArray(array))
            {
                newDiagram.Add(g, "");
            }
            string[] array2 = { "1b39aa9e-d2bf-4d39-a7a4-e1d582a5dac4", "2bda4c53-69d9-4556-b1ab-9070a33f9113", "2a1cd561-a290-4d2c-936b-6c74421461f8", "fc081458-e6a7-4cd3-9d4d-738909bb45cc", "c093c9cb-1cc6-44a9-ab93-ddc638fa4802", "2b3e2630-e9fa-4e9c-a37c-2a9872ffd5f2" };
            foreach (var j in convertStringToArray(array2))
            {
                oldDiagram.Add(j, "");
            }
            DiagramDifferences testDictionary = new DiagramDifferences();
            testDictionary.processComparison(newDiagram, oldDiagram);
            Assert.IsTrue(testDictionary.AddedNodes.Count == 4);
            Assert.IsTrue(testDictionary.DeletedNodes.Count == 4);

            string ignorme = null;

            string[] array3 = { "7a8d2204-cd33-49ab-ad5d-210984ce65e4", "99258abc-fd8d-46f8-9727-bb2cde4d7807", "46ae2afb-16ce-49e4-bde0-0c79e1402fdf", "a60c8baa-c409-4e8f-9906-d626fabed910" };
            foreach (var k in convertStringToArray(array3))
            {
                Assert.IsTrue(testDictionary.AddedNodes.TryGetValue(k, out ignorme));
            }

            string[] array4 = {"1b39aa9e-d2bf-4d39-a7a4-e1d582a5dac4", "2bda4c53-69d9-4556-b1ab-9070a33f9113", "2a1cd561-a290-4d2c-936b-6c74421461f8", "fc081458-e6a7-4cd3-9d4d-738909bb45cc"};
            foreach (var l in convertStringToArray(array4))
            {
                Assert.IsTrue(testDictionary.DeletedNodes.TryGetValue(l, out ignorme));
            }

            Assert.IsFalse(testDictionary.AddedNodes.TryGetValue(new Guid("c093c9cb-1cc6-44a9-ab93-ddc638fa4802"), out ignorme));
            Assert.IsFalse(testDictionary.AddedNodes.TryGetValue(new Guid("2b3e2630-e9fa-4e9c-a37c-2a9872ffd5f2"), out ignorme));
            Assert.IsFalse(testDictionary.DeletedNodes.TryGetValue(new Guid("c093c9cb-1cc6-44a9-ab93-ddc638fa4802"), out ignorme));
            Assert.IsFalse(testDictionary.DeletedNodes.TryGetValue(new Guid("2b3e2630-e9fa-4e9c-a37c-2a9872ffd5f2"), out ignorme));
        }

        private Guid[] convertStringToArray(string [] stringArray)
        {
            Guid[] guids = Array.ConvertAll<String, Guid>
            (
           stringArray, 
            delegate (string s) { Guid gid; return gid = new Guid(s); }
            );
            return guids;
        }

        [TestMethod()]
        public void ShowDictionary()
        {
            Dictionary<Guid, string> newDiagram = new Dictionary<Guid, string>();
            Dictionary<Guid, string> oldDiagram = new Dictionary<Guid, string>();
            string[] array = { "2b3e2630-e9fa-4e9c-a37c-2a9872ffd5f2", "7a8d2204-cd33-49ab-ad5d-210984ce65e4", "99258abc-fd8d-46f8-9727-bb2cde4d7807", "46ae2afb-16ce-49e4-bde0-0c79e1402fdf", "a60c8baa-c409-4e8f-9906-d626fabed910", "c093c9cb-1cc6-44a9-ab93-ddc638fa4802" };
            
            newDiagram.Add(new Guid("2b3e2630-e9fa-4e9c-a37c-2a9872ffd5f2"), "This is my Value");

            string IgnoreMeForNow = null;
            if (newDiagram.TryGetValue(new Guid("2b3e2630-e9fa-4e9c-a37c-2a9872ffd5f2"),out IgnoreMeForNow))
            {
                Trace.WriteLine("it found it here it is"+IgnoreMeForNow);
            }
            else
            {
                Trace.WriteLine("didn't find it");
            }


        }
    }
}