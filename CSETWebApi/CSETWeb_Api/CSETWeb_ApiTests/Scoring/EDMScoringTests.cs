using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWeb_Api.BusinessLogic.Scoring;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;

namespace CSETWeb_Api.BusinessLogic.Scoring.Tests
{
    [TestClass()]
    public class EDMScoringTests
    {
        [TestMethod()]
        public void LoadDBDataTest()
        {
            EDMScoring scoring = new EDMScoring();
            scoring.LoadDataStructure();
            scoring.SetAnswers(3361);
            List<EDMscore> list = scoring.GetScores();
            foreach(EDMscore s in list)
            {
                Trace.WriteLine(s.Title_Id + ":" + s.Color);
            }
        }

        [TestMethod()]
        public void GetScoringTest()
        {
            EDMScoring scoring = new EDMScoring();
            EDMScoring.TopLevelScoreNode node =  scoring.getPartialScore();            
            Trace.WriteLine(node.Score);            
        }
    }
}