using CSETWeb_Api.BusinessLogic.Scoring;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static CSETWeb_Api.BusinessLogic.Scoring.EDMScoring;

namespace DeleteMe
{
    class Program
    {
        static void Main(string[] args)
        {
            EDMScoring scoring = new EDMScoring();
            scoring.LoadDataStructure();
            scoring.SetAnswers(3361);            
            List<EDMscore> list = scoring.GetScores();
            foreach (EDMscore s in list)
            {
                Console.WriteLine(s.Title_Id + ":" + s.Color);
            }
            scoring.SetAnswers(3365);
            Console.WriteLine("Test 1---------------");
            var node= scoring.getPartialScore();
            writeoutNode(node);
            Console.WriteLine("Test 2");
            var node2 = scoring.getPercentageScore();
            writeoutPercentages(node2);
            Console.Read();
        }

        private static void writeoutPercentages(ScoringNode node)
        {
            while (node != null)
            {
                Console.WriteLine(node.PercentageCountRight + "/" + node.PercentageTotalCount + "="+node.PercentageScore + " "+ node.Title_Id);
                foreach (var c in node.Children)
                {
                    Console.WriteLine(c.PercentageCountRight + "/" + c.PercentageTotalCount + "=" + c.PercentageScore + " " + c.Title_Id);
                    if (c.Children.Count > 0)
                        writeoutPercentages(c);
                }
                if (node is TopLevelScoreNode)
                    node = ((TopLevelScoreNode)node).TopLevelChild;
                else
                    node = null;
            }
        }

        static void writeoutNode(ScoringNode node)
        {
            while (node != null)
            {
                Console.WriteLine(node.Score + "/" + node.totalCount + "" + node.Title_Id);
                foreach (var c in node.Children)
                {
                    Console.WriteLine(c.Score + "/" + c.totalCount + "" + c.Title_Id);                    
                    if(c.Children.Count>0)
                        writeoutNode(c);
                }
                if (node is TopLevelScoreNode)
                    node = ((TopLevelScoreNode)node).TopLevelChild;
                else
                    node = null;
            }
        }
    }
}
