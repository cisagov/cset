using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWeb_Api.BusinessManagers;
using System.Diagnostics;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.helpers.Tests
{
    [TestClass()]
    public class PermutationsGeneratorTests
    {
        [TestMethod()]
        public void GetPermutationsTest()
        {
            CombinationsGenerator permutations = new CombinationsGenerator();
            List<List<int>> combos = permutations.GetAllCombos(new int[] { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }.ToList()).Where(x => x.Count == 2).ToList();
            foreach (var permu in combos)
            {
                foreach (var i in permu)
                    Trace.Write(i.ToString() + " ");
                Trace.Write("\n");
            }

            List<NetworkComponent> test = new List<NetworkComponent>(){
                new NetworkComponent {ID = "1c" },
                new NetworkComponent {ID = "2c" },
                new NetworkComponent {ID = "3c" },
                new NetworkComponent {ID = "4c" },
                new NetworkComponent {ID = "5c" },
                new NetworkComponent {ID = "6c" },
            };
            List<List<NetworkComponent>> combosNC = permutations.GetAllCombos(test).Where(x => x.Count == 2).ToList();
            foreach (var permu in combosNC)
            {
                foreach (var i in permu)
                    Trace.Write(((NetworkComponent)i).ID.ToString() + " ");
                Trace.Write("\n");
            }
        }
    }
}