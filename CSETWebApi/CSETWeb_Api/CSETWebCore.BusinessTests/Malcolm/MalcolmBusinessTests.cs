using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWebCore.Business.Malcolm;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.Model.Malcolm;
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Diagnostics;

namespace CSETWebCore.Business.Malcolm.Tests
{
    [TestClass()]
    public class MalcolmBusinessTests
    {
        [TestMethod()]
        public void GetMalcolmJsonDataTest()
        {
            string dir = Directory.GetCurrentDirectory();
            string[] files = Directory.GetFiles(Path.Combine(dir,"MalcolmJson"), "source_to_destination_ip.json");
            List<MalcolmData> datalist = new List<MalcolmData>();
            foreach (string file in files)
            {
                string jsonString = File.ReadAllText(file);
                var malcolmData = JsonConvert.DeserializeObject<MalcolmData>(jsonString);
                datalist.Add(malcolmData);
            }
            MalcolmBusiness tst = new MalcolmBusiness(new DataLayer.Model.CSETContext());
            Dictionary<string,TmpNode> nodesList= tst.RunTest(datalist);
            foreach(TmpNode node in nodesList.Values)
            {
                Trace.WriteLine("node");
                Trace.WriteLine(node.Key);
                Trace.WriteLine(node.PrintChildrenList());
                
                foreach(var n in node.Children)
                    PrintChildren(n);
            }
        }
        private void PrintChildren(TmpNode node)
        {
            Trace.Write(node.Key);
            foreach (TmpNode c in node.Children)
            {
                Trace.WriteLine("->" + c.Key);
            }
        }
    }

   
}