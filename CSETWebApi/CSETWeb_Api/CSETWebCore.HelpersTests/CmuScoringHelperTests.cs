//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.XPath;

namespace CSETWebCore.Helpers.Tests
{
    [TestClass()]
    public class CmuScoringHelperTests
    {
        private DataLayer.Model.CSETContext context;

        private CmuScoringHelper cmuScoring;

        // until we get some insert statements, just set this to your assessment that has answers fleshed out
        private int assessmentId = 8054;


        [TestInitialize()]
        public void Initialize()
        {
            context = new DataLayer.Model.CSETContext();
            cmuScoring = new CmuScoringHelper(context);
        }


        [TestMethod()]
        public void Test01_AllNo()
        {
            // flip all answers to "NO"
            var myAnswers = context.ANSWER.Where(a => a.Assessment_Id == assessmentId).ToList();
            foreach (var ans in myAnswers)
            {
                ans.Answer_Text = "N";
            }
            context.SaveChanges();


            cmuScoring.InstantiateScoringHelper(assessmentId);

            var nonRed = cmuScoring.XDoc.Descendants("Question").Where(x =>
            x.Attribute("isparentquestion").Value == "false" &&
            x.Attribute("placeholder-p") == null &&
            x.Attribute("scorecolor").Value != "red").ToList();

            // there should be zero non-red questions
            Assert.AreEqual(nonRed.Count(), 0);
        }


        [TestMethod()]
        public void Test02_AllYes()
        {
            // flip all answers to "YES"
            var myAnswers = context.ANSWER.Where(a => a.Assessment_Id == assessmentId).ToList();
            foreach (var ans in myAnswers)
            {
                ans.Answer_Text = "Y";
            }
            context.SaveChanges();


            cmuScoring.InstantiateScoringHelper(assessmentId);

            // all MILs green
            Assert.AreEqual(GetMilScoreColor("AM", "MIL-1"), "green");
            Assert.AreEqual(GetMilScoreColor("AM", "MIL-2"), "green");
            Assert.AreEqual(GetMilScoreColor("AM", "MIL-3"), "green");
            Assert.AreEqual(GetMilScoreColor("AM", "MIL-4"), "green");
            Assert.AreEqual(GetMilScoreColor("AM", "MIL-5"), "green");

            // all domains should be green
            Assert.AreEqual(GetDomainScoreColor("AM"), "green");
            Assert.AreEqual(GetDomainScoreColor("CM"), "green");
            Assert.AreEqual(GetDomainScoreColor("CCM"), "green");
            Assert.AreEqual(GetDomainScoreColor("VM"), "green");
            Assert.AreEqual(GetDomainScoreColor("IM"), "green");
            Assert.AreEqual(GetDomainScoreColor("SCM"), "green");
            Assert.AreEqual(GetDomainScoreColor("RM"), "green");
            Assert.AreEqual(GetDomainScoreColor("EDM"), "green");
            Assert.AreEqual(GetDomainScoreColor("TA"), "green");
            Assert.AreEqual(GetDomainScoreColor("SA"), "green");


            // Now flip one answer in MIL-1 to "N" and MIL-2 thru 5 should turn red
            SetAnswer("AM:G5.Q6-F", "N");

            cmuScoring.InstantiateScoringHelper(assessmentId);

            Assert.AreEqual(GetMilScoreColor("AM", "MIL-1"), "yellow");
            Assert.AreEqual(GetMilScoreColor("AM", "MIL-2"), "red");
            Assert.AreEqual(GetMilScoreColor("AM", "MIL-3"), "red");
            Assert.AreEqual(GetMilScoreColor("AM", "MIL-4"), "red");
            Assert.AreEqual(GetMilScoreColor("AM", "MIL-5"), "red");
        }


        [TestMethod()]
        public void Test03_AllNoOneYes()
        {
            // flip all answers to "NO"
            var myAnswers = context.ANSWER.Where(a => a.Assessment_Id == assessmentId).ToList();
            foreach (var ans in myAnswers)
            {
                ans.Answer_Text = "N";
            }
            context.SaveChanges();

            // answer AM:G2.Q4-F as YES
            SetAnswer("AM:G2.Q4-F", "Y");

            cmuScoring.InstantiateScoringHelper(assessmentId);

            // AM's G2 should be yellow, other goals still red
            Assert.AreEqual(GetGoalScoreColor("AM", "AM:G1"), "red");
            Assert.AreEqual(GetGoalScoreColor("AM", "AM:G2"), "yellow");
            Assert.AreEqual(GetGoalScoreColor("AM", "AM:G3"), "red");
            Assert.AreEqual(GetGoalScoreColor("AM", "AM:G4"), "red");
            Assert.AreEqual(GetGoalScoreColor("AM", "AM:G5"), "red");
            Assert.AreEqual(GetGoalScoreColor("AM", "AM:G6"), "red");
            Assert.AreEqual(GetGoalScoreColor("AM", "AM:G7"), "red");

            // AM's MIL-1 element should be yellow, the other MILs red
            Assert.AreEqual(GetMilScoreColor("AM", "MIL-1"), "yellow");
            Assert.AreEqual(GetMilScoreColor("AM", "MIL-2"), "red");
            Assert.AreEqual(GetMilScoreColor("AM", "MIL-3"), "red");
            Assert.AreEqual(GetMilScoreColor("AM", "MIL-4"), "red");
            Assert.AreEqual(GetMilScoreColor("AM", "MIL-5"), "red");
        }


        /// <summary>
        /// Answer everything in AM:MIL-1 YES but other MILs NO
        /// </summary>
        [TestMethod()]
        public void Test04_Mil1Yes()
        {
            // flip all answers to "NO"
            var myAnswers = context.ANSWER.Where(a => a.Assessment_Id == assessmentId).ToList();
            foreach (var ans in myAnswers)
            {
                ans.Answer_Text = "N";
            }
            context.SaveChanges();

            // Answer AM MIL-1 all YES
            var amMil1Questions = context.MATURITY_QUESTIONS
                .Where(q => q.Question_Title.StartsWith("AM:G")).Select(x => x.Mat_Question_Id).ToList();
            myAnswers = context.ANSWER.Where(a => a.Assessment_Id == assessmentId
                && amMil1Questions.Contains(a.Question_Or_Requirement_Id)).ToList();
            foreach (var ans in myAnswers)
            {
                ans.Answer_Text = "Y";
            }
            context.SaveChanges();


            cmuScoring.InstantiateScoringHelper(assessmentId);


            // mil-1 should be green, but the domain (AM) should be yellow (mil 2-5 are still red)
            Assert.AreEqual(GetMilScoreColor("AM", "MIL-1"), "green");
            Assert.AreEqual(GetMilScoreColor("AM", "MIL-2"), "red");
            Assert.AreEqual(GetMilScoreColor("AM", "MIL-3"), "red");
            Assert.AreEqual(GetMilScoreColor("AM", "MIL-4"), "red");
            Assert.AreEqual(GetMilScoreColor("AM", "MIL-5"), "red");
            Assert.AreEqual(GetDomainScoreColor("AM"), "yellow");
        }


        [TestMethod()]
        public void Test05_Mil1And2()
        {
            // flip all answers to "NO"
            var myAnswers = context.ANSWER.Where(a => a.Assessment_Id == assessmentId).ToList();
            foreach (var ans in myAnswers)
            {
                ans.Answer_Text = "N";
            }
            context.SaveChanges();

            // Answer AM MIL-1 all YES
            var amMil1Questions = context.MATURITY_QUESTIONS
                .Where(q => q.Question_Title.StartsWith("AM:G")).Select(x => x.Mat_Question_Id).ToList();
            myAnswers = context.ANSWER.Where(a => a.Assessment_Id == assessmentId
                && amMil1Questions.Contains(a.Question_Or_Requirement_Id)).ToList();
            foreach (var ans in myAnswers)
            {
                ans.Answer_Text = "Y";
            }
            context.SaveChanges();

            // Answer one question in AM MIL-2 YES
            SetAnswer("AM:MIL2.Q1", "Y");


            cmuScoring.InstantiateScoringHelper(assessmentId);


            // MIL-1 should be green, MIL-2 still red
            Assert.AreEqual(GetMilScoreColor("AM", "MIL-1"), "green");
            Assert.AreEqual(GetMilScoreColor("AM", "MIL-2"), "red");
        }


        /// <summary>
        /// Sets the answer text of an ANSWER record by question title.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="title"></param>
        /// <param name="answer"></param>
        private void SetAnswer(string title, string answer)
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
        /// 
        /// </summary>
        /// <param name="domain"></param>
        /// <param name="goalLabel"></param>
        /// <returns></returns>
        private string GetGoalScoreColor(string domain, string goalLabel)
        {
            var g = cmuScoring.XDoc.XPathSelectElement($"//Domain[@abbreviation='{domain}']//Goal[@abbreviation='{goalLabel}']");
            return g?.Attribute("scorecolor")?.Value;
        }


        /// <summary>
        /// Returns the scorecolor attribute for the specified Domain/Mil.
        /// </summary>
        /// <param name="doc"></param>
        /// <param name="domain"></param>
        /// <param name="milLabel"></param>
        /// <returns></returns>
        private string GetMilScoreColor(string domain, string milLabel)
        {
            var m = cmuScoring.XDoc.XPathSelectElement($"//Domain[@abbreviation='{domain}']/Mil[@label='{milLabel}']");
            return m?.Attribute("scorecolor")?.Value;
        }


        /// <summary>
        /// Returns the scorecolor attribute for the specified Domain.
        /// </summary>
        /// <param name="doc"></param>
        /// <param name="domain"></param>
        /// <returns></returns>
        private string GetDomainScoreColor(string domain)
        {
            var d = cmuScoring.XDoc.XPathSelectElement($"//Domain[@abbreviation='{domain}']");
            return d?.Attribute("scorecolor")?.Value;
        }
    }
}