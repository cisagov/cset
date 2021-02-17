using CSETWeb_Api.BusinessManagers;
//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSET_Main.Views.Questions.QuestionDetails;
using DataLayerCore.Model;
using CSET_Main.Questions.POCO;
using CSET_Main.Common.EnumHelper;
using System;
using System.Linq;
using BusinessLogic.Helpers;
using System.Collections.Generic;

namespace CSETWeb_Api.BusinessManagers.Tests
{
    [TestClass()]
    public class QuestionsManagerTests
    {
        [TestMethod()]
        public void GetDetailsTest()
        {

            ANSWER newAnswer = new ANSWER()
            {
                Is_Requirement = false,
                Question_Or_Requirement_Id = 14,
                Answer_Text = AnswerEnum.UNANSWERED.GetStringAttribute(),
                Mark_For_Review = false,
                Is_Component = false
            };
            //TODO a setup and teardown that creates the assessment and then destroys it
            QuestionsManager manager = new QuestionsManager(26);
            QuestionDetailsContentViewModel viewModel = manager.GetDetails(14, false, false);
        }

        [TestMethod()]
        public void HandleGuidTest()
        {
            using (CSET_Context db = new CSET_Context())
            {
                var test = db.ASSESSMENT_DIAGRAM_COMPONENTS.Where(x => x.Component_Guid != null).FirstOrDefault();
                if (test == null)
                    Assert.Fail("no data to test");
                try
                {
                    ComponentQuestionManager manager = new ComponentQuestionManager(test.Assessment_Id);
  
                    manager.HandleGuid(test.Component_Guid, true);
                    var list = db.ANSWER.Where(x => x.Component_Guid == test.Component_Guid).ToList();
                    Assert.IsTrue(list.Count > 0);
                    manager.HandleGuid(test.Component_Guid, false);
                    list = db.ANSWER.Where(x => x.Component_Guid == test.Component_Guid).ToList();
                    Assert.IsTrue(list.Count == 0);
                }
                catch (Exception e)
                {
                    throw e;
                }
            }
        }

        [TestMethod()]
        public void GetOverrideQuestionsTest()
        {
            using (CSET_Context db = new CSET_Context())
            {
                var test = db.ASSESSMENTS.FirstOrDefault();
                if (test == null)
                    Assert.Fail("no data to test");
                try
                {
                    // QuestionsManager manager = new QuestionsManager(test.Assessment_Id);
                    ComponentQuestionManager manager = new ComponentQuestionManager(test.Assessment_Id);


                    List<Answer_Components_Exploded_ForJSON> list =  manager.GetOverrideQuestions(16, 1586, Constants.FIREWALL);
                    
                    Assert.IsTrue(list.Count>0);
                }
                catch (Exception e)
                {
                    throw e;
                }
            }

        }
    }
}

