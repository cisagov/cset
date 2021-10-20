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

        [TestMethod()]
        public void InstantiateScoringHelperTest()
        {
            context = new DataLayer.CSETContext();            
            CrrScoringHelper crrScoring = new CrrScoringHelper(context);

            // until we get some insert statements, just set this to your assessment that has answers fleshed out
            int assessmentId = 8054;

            // this is a hack because the connection string is very slow to become available in the context
            //context._connectionString = "data source=(localdb)\\v11.0;initial catalog=CSETWeb;persist security info=True;Integrated Security=SSPI;MultipleActiveResultSets=True";


            var dbio = new DBIO(context);


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



            // answer AM:G2.Q4-F as YES
            SetAnswer(assessmentId, "AM:G2.Q4-F", "Y");
 
            crrScoring.InstantiateScoringHelper(assessmentId);


            // AM's MIL-1 element should be yellow, the other MILs red
            var mil1 = crrScoring.XDoc.XPathSelectElement("//Domain[@abbreviation='AM']/Mil[@label='MIL-1']");
            Assert.AreEqual(mil1.Attribute("scorecolor").Value, "yellow");
            var mil2 = crrScoring.XDoc.XPathSelectElement("//Domain[@abbreviation='AM']/Mil[@label='MIL-2']");
            Assert.AreEqual(mil2.Attribute("scorecolor").Value, "red");
            var mil3 = crrScoring.XDoc.XPathSelectElement("//Domain[@abbreviation='AM']/Mil[@label='MIL-3']");
            Assert.AreEqual(mil3.Attribute("scorecolor").Value, "red");
            var mil4 = crrScoring.XDoc.XPathSelectElement("//Domain[@abbreviation='AM']/Mil[@label='MIL-4']");
            Assert.AreEqual(mil4.Attribute("scorecolor").Value, "red");
            var mil5 = crrScoring.XDoc.XPathSelectElement("//Domain[@abbreviation='AM']/Mil[@label='MIL-5']");
            Assert.AreEqual(mil5.Attribute("scorecolor").Value, "red");



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
    }
}