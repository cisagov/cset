//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
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

        public List<Answer> getInitialAnswers(int assessmentId)
        {
            /*
             * Don't love this but it is what it is. 
             * Just getting the answers based on what is in the list
             */
            List<int> questionIds = new List<int>()
            {
                12297,
                12314,
                12331,
                12334,
                12340,
                12342,
                12343,
                12344,
                12374,
                28188,
                28189,
                28190,
                28191,
                28192,
                28195,
                1920,
                1925,
                1937,
                1938,
                1939,
            };

            var answerslist = from a in _context.ANSWER
                              where a.Assessment_Id == assessmentId && questionIds.Contains(a.Question_Or_Requirement_Id) && (a.Is_Requirement == true || a.Is_Maturity == true)
                              select new Answer() { AnswerText = a.Answer_Text, QuestionId = a.Question_Or_Requirement_Id, Is_Maturity = a.Is_Maturity??false, Is_Requirement = a.Is_Requirement??false };
            return answerslist.ToList();
        }
    }
}