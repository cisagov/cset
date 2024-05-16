//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Question;
using DocumentFormat.OpenXml.Office2010.ExcelAc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Query.Internal;
using System;
using System.Collections.Generic;
using System.Linq;

namespace CSETWebCore.Api.Controllers
{
    internal class CFBusiness
    {
        private CSETContext _context;
        private IAssessmentUtil assessmentUtil;

        public CFBusiness(CSETContext context, IAssessmentUtil assessmentUtil)
        {
            this._context = context;
            this.assessmentUtil = assessmentUtil;
        }

        public List<List<Answer>> getInitialAnswers(int assessmentId)
        {
            /*
             * Don't love this but it is what it is. 
             * Just getting the answers based on what is in the list
             */
            List<int> questionIds1 = new List<int>()
            {
               12297, 12314, 12331, 12334, 12340, 12342, 12343, 12344, 12374, 28188, 28189, 28190, 28191, 28192, 28195, 1920, 1925, 1937, 1938, 1939
            };
            List<int> questionIds2 = new List<int>()
            {
               36409, 36417, 36419, 36429, 36439, 36442, 36444, 36445, 36479, 36484, 36487, 36491, 36494, 36497, 36503, 1920, 1925, 1937, 1938, 1939
            };
            List<List<int>> listOfQuestions = new List<List<int>>()
            {
                questionIds1,
                questionIds2
            };
            List < List < Answer >> answers = new List<List<Answer>>();
            foreach (var questionIds in listOfQuestions)
            {
                var answerslist = from a in _context.ANSWER
                                  where a.Assessment_Id == assessmentId && questionIds.Contains(a.Question_Or_Requirement_Id) && (a.Is_Requirement == true || a.Is_Maturity == true)
                                  select new Answer() { AnswerText = a.Answer_Text, QuestionId = a.Question_Or_Requirement_Id, Is_Maturity = a.Is_Maturity ?? false, Is_Requirement = a.Is_Requirement ?? false };
                answers.Add(answerslist.ToList());
            }
            return answers;
        }
    }
}