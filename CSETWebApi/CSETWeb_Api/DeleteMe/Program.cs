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
            //List<EDMscore> list = scoring.GetScores();
            //foreach (EDMscore s in list)
            //{
            //    Console.WriteLine(s.Title_Id + ":" + s.Color);
            //}
            var node= scoring.getPartialScore(3361);
            writeoutNode(node);
            Console.Read();
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
