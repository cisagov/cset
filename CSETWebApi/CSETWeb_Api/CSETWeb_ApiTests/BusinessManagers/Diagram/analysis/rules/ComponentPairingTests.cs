using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.rules;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.rules.Tests
{
    [TestClass()]
    public class ComponentPairingTests
    {
        [TestMethod()]
        public void EqualsTest()
        {
            Guid a = Guid.NewGuid();
            Guid b = Guid.NewGuid();
            ComponentPairing pair = new ComponentPairing()
            {
                Source = a,
                Target = b
            };
            ComponentPairing pair2 = new ComponentPairing()
            {
                Source = b,
                Target = a
            };

            Assert.IsTrue(pair.Equals(pair2));
            Assert.AreEqual(pair, pair2);

            Dictionary<ComponentPairing, string> test = new Dictionary<ComponentPairing, string>();
            test.Add(pair, "Pair1");
            Assert.ThrowsException<ArgumentException>(() => { test.Add(pair2, "Pair2"); });
        }
    }
}