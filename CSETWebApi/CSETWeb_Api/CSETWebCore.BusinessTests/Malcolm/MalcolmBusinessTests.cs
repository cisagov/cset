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
using NPOI.HSSF.Record.Chart;

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
            string[] assertFile = File.ReadAllLines(Path.Combine(dir, "MalcolmJson", "TestHarness.txt"));
            List<MalcolmData> datalist = new List<MalcolmData>();
            foreach (string file in files)
            {
                string jsonString = File.ReadAllText(file);
                var malcolmData = JsonConvert.DeserializeObject<MalcolmData>(jsonString);
                datalist.Add(malcolmData);
            }
            MalcolmBusiness tst = new MalcolmBusiness(new DataLayer.Model.CSETContext());
            List<MalcolmData> list = tst.GetMalcolmJsonData(datalist);
            Dictionary<string, TempNode> nodesList = list[0].Graphs;
            foreach(TempNode node in nodesList.Values)
            {
                Trace.WriteLine("");
                Trace.WriteLine("node");
                Trace.WriteLine(node.Key);
                Trace.WriteLine(node.PrintChildrenList());
            }

            Dictionary<string, bool> AllNodes = new Dictionary<string, bool>();
            foreach(String line in assertFile)
            {
                AllNodes.TryAdd(line.Trim(), false);
            }
            foreach(var ip in AllNodes.Keys)
            {
                if (!nodesList.ContainsKey(ip))
                {
                    Trace.WriteLine("Missing key: " + ip);
                }
            }
            Assert.IsTrue(AllNodes.Count == nodesList.Count);
            TempNode parent = null;
            foreach (String item  in assertFile)
            {
                /**
                 * look to see that the node list contains the parent. 
                 * then look to see that each node was represented (we didn't accidentally miss one)
                 * then look to see that each child is in the list
                 * then look to see that we didn't miss any children
                 * look to at the child list for each parent does it contain the children. 
                 */
                if (item.StartsWith("            "))
                {
                    Assert.IsTrue(parent.ChildrenKeys.Contains(item.Trim()));
                    Assert.IsTrue(nodesList.ContainsKey(item.Trim()));
                }
                else
                {
                    Assert.IsTrue(nodesList.ContainsKey(item.Trim()),"couldn't find"+item);
                    parent = nodesList[item.Trim()];
                }
            }

        }
        [TestMethod()]
        public void TestMalcomTreeWalk()
        {
            string dir = Directory.GetCurrentDirectory();
            string[] files = Directory.GetFiles(Path.Combine(dir, "MalcolmJson"), "source_to_destination_ip.json");
            string[] assertFile = File.ReadAllLines(Path.Combine(dir, "MalcolmJson", "TestHarness.txt"));
            List<MalcolmData> datalist = new List<MalcolmData>();
            foreach (string file in files)
            {
                string jsonString = File.ReadAllText(file);
                var malcolmData = JsonConvert.DeserializeObject<MalcolmData>(jsonString);
                datalist.Add(malcolmData);
            }
            MalcolmBusiness tst = new MalcolmBusiness(new DataLayer.Model.CSETContext());
            
            List<MalcolmData> data =  tst.GetMalcolmJsonData(datalist);
            MalcolmTree tree = new MalcolmTree();
            var root = new TempNode("10.10.30.1");
            tree.WalkTree(null, root, data[0].Graphs["10.10.30.1"]);

            printTree(root,0);

        }

        [TestMethod()]
        public void TestPreconstructedGraph()
        {
            TempNode node3 = new TempNode("3");
            TempNode node6 = new TempNode("6");
            TempNode node8 = new TempNode("8");
            TempNode node255 = new TempNode("255");
            node3.Children.Add(node6);
            node3.Children.Add(node8);
            node6.Children.Add(node3);
            node8.Children.Add(node3);
            node6.Children.Add(node255);
            node255.Children.Add(node6);
            node8.Children.Add(node255);
            node255.Children.Add(node8);


            MalcolmTree tree = new MalcolmTree();
            TempNode root = new TempNode("3");
            tree.WalkTree(null, root, node3);

            printTree(root,0);

        }

        private void printTree(TempNode node, int indent)
        {
            string tkey = node.Key; 
            if(indent > 0)
            {
                tkey = "->" + tkey;
            }
            Trace.WriteLine(tkey.PadLeft(tkey.Length+ (2*indent)));
            foreach(var c in node.Children)
            {                
                printTree(c,(++indent));                
            }
        }

        
    }

   
}