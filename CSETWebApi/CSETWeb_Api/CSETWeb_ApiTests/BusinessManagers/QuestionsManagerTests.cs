//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSET_Main.Views.Questions.QuestionDetails;
using DataLayerCore.Model;
using CSET_Main.Questions.POCO;
using CSET_Main.Common.EnumHelper;

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
                Component_Id = 0,
                Is_Component = false
            };
            //TODO a setup and teardown that creates the assessment and then destroys it
            QuestionsManager manager = new QuestionsManager(26);
            QuestionDetailsContentViewModel viewModel = manager.GetDetails(14, 26);            
        }
    }
}

