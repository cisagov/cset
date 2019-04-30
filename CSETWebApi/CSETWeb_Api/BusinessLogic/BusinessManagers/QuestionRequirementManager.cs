//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CSETWeb_Api.BusinessLogic.Helpers;
using CSETWeb_Api.Models;
using DataLayerCore.Model;
using Microsoft.EntityFrameworkCore;

namespace CSETWeb_Api.BusinessManagers
{
    public abstract class QuestionRequirementManager
    {
        /// <summary>
        /// 
        /// </summary>
        protected int _assessmentId;

        /// <summary>
        /// 
        /// </summary>
        protected string _standardLevel;

        /// <summary>
        /// 
        /// </summary>
        protected List<string> _setNames = null;

        /// <summary>
        /// 
        /// </summary>
        protected string applicationMode = "";

        /// <summary>
        /// 
        /// </summary>
        public string ApplicationMode
        {
            get
            {
                return this.applicationMode;
            }
        }


        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="assessmentId"></param>
        protected QuestionRequirementManager(int assessmentId)
        {
            using (var db = new CSET_Context())
            {
                _assessmentId = assessmentId;
                InitializeApplicationMode(db);
                InitializeSalLevel(db);
                InitializeStandardsForAssessment(db);
            }
        }


        /// <summary>
        /// Determines whether the assessment is questions based or requirements based.
        /// Sets a Q or R that is returned to the client.
        /// </summary>
        /// <returns></returns>
        protected void InitializeApplicationMode(CSET_Context db)
        {   
            applicationMode = db.STANDARD_SELECTION.Where(x => x.Assessment_Id == _assessmentId)
                .Select(x => x.Application_Mode).FirstOrDefault();

            // Default to 'questions mode' if not already set
            if (applicationMode == null)
            {
                applicationMode = "Q";
                SetApplicationMode(applicationMode);
            }
            else if (applicationMode.ToLower().StartsWith("questions"))
            {
                applicationMode = "Q";
            }
            else if (applicationMode.ToLower().StartsWith("requirements"))
            {
                applicationMode = "R";
            }
        }


        /// <summary>
        /// Determines the assessment's SAL standard level (letter code)
        /// </summary>
        /// <returns></returns>
        protected void InitializeSalLevel(CSET_Context db)
        {
            
            var querySalLevel = from usl in db.UNIVERSAL_SAL_LEVEL
                                from ss in db.STANDARD_SELECTION
                                    .Where(s => s.Assessment_Id == _assessmentId && s.Selected_Sal_Level == usl.Full_Name_Sal)
                                select usl.Universal_Sal_Level1;
            _standardLevel = querySalLevel.ToList().FirstOrDefault();
            
        }


        /// <summary>
        /// Creates a list of standards selected for the assessment.
        /// </summary>
        /// <returns></returns>
        protected void InitializeStandardsForAssessment(CSET_Context db)
        {
            List<string> result = new List<string>();            
            var sets = db.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == _assessmentId && x.Selected)
                .Select(x => x.Set_Name);
            _setNames = sets.ToList();
        }


        /// <summary>
        /// Stores the requested application mode in the STANDARD_SELECTION table.
        /// </summary>
        /// <param name="mode"></param>
        public void SetApplicationMode(string mode)
        {
            var db = new CSET_Context();
            var standardSelection = db.STANDARD_SELECTION.Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();
            if (standardSelection != null)
            {
                standardSelection.Application_Mode = (mode == "Q") ? "Questions Based" : "Requirements Based";
                db.STANDARD_SELECTION.AddOrUpdate( standardSelection,x=> x.Assessment_Id);
                db.SaveChanges();
            }

            AssessmentUtil.TouchAssessment(_assessmentId);
        }


        /// <summary>
        /// Stores an answer.
        /// </summary>
        /// <param name="answer"></param>
        public int StoreAnswer(Answer answer)
        {
            var db = new CSET_Context();

            // Find the Question or Requirement
            var question = db.NEW_QUESTION.Where(q => q.Question_Id == answer.QuestionId).FirstOrDefault();
            var requirement = db.NEW_REQUIREMENT.Where(r => r.Requirement_Id == answer.QuestionId).FirstOrDefault();

            if (question == null && requirement == null)
            {
                throw new Exception("Unknown question or requirement ID: " + answer.QuestionId);
            }

            InitializeApplicationMode(db);
            bool isRequirement = (applicationMode == "R");



            // in case a null is passed, store 'unanswered'
            if (string.IsNullOrEmpty(answer.AnswerText))
            {
                answer.AnswerText = "U";
            }

            ANSWER dbAnswer = null;

            if (answer != null)
            {
                dbAnswer = db.ANSWER.Where(x => x.Assessment_Id == _assessmentId 
                && x.Question_Or_Requirement_Id == answer.QuestionId
                && x.Is_Requirement == isRequirement).FirstOrDefault();
            }

            if (dbAnswer == null)
            {
                dbAnswer = new ANSWER();
            }

            dbAnswer.Assessment_Id = _assessmentId;
            dbAnswer.Question_Or_Requirement_Id = answer.QuestionId;
            dbAnswer.Question_Number = answer.QuestionNumber;
            dbAnswer.Is_Requirement = isRequirement;
            dbAnswer.Answer_Text = answer.AnswerText;
            dbAnswer.Alternate_Justification = answer.AltAnswerText;
            dbAnswer.Comment = answer.Comment;
            dbAnswer.Mark_For_Review = answer.MarkForReview;
            dbAnswer.Reviewed = answer.Reviewed;

            db.ANSWER.AddOrUpdate(dbAnswer, x=> x.Answer_Id);
            db.SaveChanges();

            AssessmentUtil.TouchAssessment(_assessmentId);

            return dbAnswer.Answer_Id;
        }
    }
}

