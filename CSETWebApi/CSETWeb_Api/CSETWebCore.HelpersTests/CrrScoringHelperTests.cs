using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWebCore;
using CSETWebCore.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using System.Xml.XPath;

namespace CSETWebCore.Helpers.Tests
{
    [TestClass()]
    public class CrrScoringHelperTests
    {
        private DataLayer.CSETContext context;

        private CrrScoringHelper crrScoring;

        // until we get some insert statements, just set this to your assessment that has answers fleshed out
        private int assessmentId = 8054;


        [TestInitialize()]
        public void Initialize()
        {
            context = new DataLayer.CSETContext();
            crrScoring = new CrrScoringHelper(context);
        }


        [TestMethod()]
        public void AllNoTest()
        {
            // flip all answers to "NO"
            var myAnswers = context.ANSWER.Where(a => a.Assessment_Id == assessmentId).ToList();
            foreach (var ans in myAnswers)
            {
                ans.Answer_Text = "N";
            }
            context.SaveChanges();


            crrScoring.InstantiateScoringHelper(assessmentId);

            var nonRed = crrScoring.XDoc.Descendants("Question").Where(x =>
            x.Attribute("isparentquestion").Value == "false" &&
            x.Attribute("placeholder-p") == null &&
            x.Attribute("scorecolor").Value != "red").ToList();

            // there should be zero non-red questions
            Assert.AreEqual(nonRed.Count(), 0);
        }


        [TestMethod()]
        public void AllYesTest()
        {
            // flip all answers to "YES"
            var myAnswers = context.ANSWER.Where(a => a.Assessment_Id == assessmentId).ToList();
            foreach (var ans in myAnswers)
            {
                ans.Answer_Text = "Y";
            }
            context.SaveChanges();


            crrScoring.InstantiateScoringHelper(assessmentId);

            // all MILs green
            Assert.AreEqual(GetMilScoreColor(crrScoring.XDoc, "AM", "MIL-1"), "green");
            Assert.AreEqual(GetMilScoreColor(crrScoring.XDoc, "AM", "MIL-2"), "green");
            Assert.AreEqual(GetMilScoreColor(crrScoring.XDoc, "AM", "MIL-3"), "green");
            Assert.AreEqual(GetMilScoreColor(crrScoring.XDoc, "AM", "MIL-4"), "green");
            Assert.AreEqual(GetMilScoreColor(crrScoring.XDoc, "AM", "MIL-5"), "green");
        }


        [TestMethod()]
        public void AllNoOneYesTest()
        {
            // flip all answers to "NO"
            var myAnswers = context.ANSWER.Where(a => a.Assessment_Id == assessmentId).ToList();
            foreach (var ans in myAnswers)
            {
                ans.Answer_Text = "N";
            }
            context.SaveChanges();

            // answer AM:G2.Q4-F as YES
            SetAnswer(assessmentId, "AM:G2.Q4-F", "Y");

            crrScoring.InstantiateScoringHelper(assessmentId);

            // AM's MIL-1 element should be yellow, the other MILs red
            Assert.AreEqual(GetMilScoreColor(crrScoring.XDoc, "AM", "MIL-1"), "yellow");
            Assert.AreEqual(GetMilScoreColor(crrScoring.XDoc, "AM", "MIL-2"), "red");
            Assert.AreEqual(GetMilScoreColor(crrScoring.XDoc, "AM", "MIL-3"), "red");
            Assert.AreEqual(GetMilScoreColor(crrScoring.XDoc, "AM", "MIL-4"), "red");
            Assert.AreEqual(GetMilScoreColor(crrScoring.XDoc, "AM", "MIL-5"), "red");
        }


        /// <summary>
        /// Sets the answer text of an ANSWER record by question title.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="title"></param>
        /// <param name="answer"></param>
        private void SetAnswer(int assessmentId, string title, string answer)
        {
            var query = from aa in context.ANSWER
                        join qq in context.MATURITY_QUESTIONS on aa.Question_Or_Requirement_Id equals qq.Mat_Question_Id
                        where aa.Assessment_Id == assessmentId
                        && qq.Question_Title == title
                        select aa;

            foreach (var dbAnswer in query.ToList())
            {
                dbAnswer.Answer_Text = answer;
            }
            context.SaveChanges();
        }


        /// <summary>
        /// Returns the scorecolor attribute for the specified Domain/Mil.
        /// </summary>
        /// <param name="doc"></param>
        /// <param name="domain"></param>
        /// <param name="milLabel"></param>
        /// <returns></returns>
        private string GetMilScoreColor(XDocument doc, string domain, string milLabel)
        {
            var mil = doc.XPathSelectElement($"//Domain[@abbreviation='{domain}']/Mil[@label='{milLabel}']");
            return mil?.Attribute("scorecolor")?.Value;
        }
    }
}