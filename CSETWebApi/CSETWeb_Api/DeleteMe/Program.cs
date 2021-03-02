using CSETWeb_Api.BusinessLogic.Scoring;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
            foreach(var c in node.Children)
            {
                Console.WriteLine(c.Score + "" + c.Title_Id);
            }
            Console.Read();

        }
    }
}
