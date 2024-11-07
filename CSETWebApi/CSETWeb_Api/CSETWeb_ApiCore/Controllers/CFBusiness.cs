//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Question;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Nested;
using CSETWebCore.Model.Question;
using DocumentFormat.OpenXml.Office2010.ExcelAc;
using MathNet.Numerics;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure.Internal;
using Microsoft.EntityFrameworkCore.Query.Internal;
using NPOI.SS.Formula.Functions;
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

        public List<Answer> getMidInitialAnswers(int assessmentId)
        {
            /*
             * Don't love this but it is what it is. 
             * Just getting the answers based on what is in the list
             */
            List<int> questionIds = new List<int>()
            {
               9889,9896,9897,9900,9901,9906,9908,9909,9907,9898,9899,9894,9895,9916,9881,9883,9885,9886,9884,9914,9880,9882,9888,9891,9913,9887,9912,9911,9892,9893,9890,9904,9905,9915,9902,9903,9910,9917
            };
           
            
            List<Answer> answers = new List<Answer>();
            
                var answerslist = from a in _context.ANSWER
                                  where a.Assessment_Id == assessmentId && questionIds.Contains(a.Question_Or_Requirement_Id) && (a.Is_Maturity == true)
                                  select new Answer() { AnswerText = a.Answer_Text, QuestionId = a.Question_Or_Requirement_Id, Is_Maturity = a.Is_Maturity ?? false, Is_Requirement = a.Is_Requirement ?? false };
            return answerslist.ToList();
        }

        public List<CFBar> getBarChartInfo(int assessmentId)
        {
            var list = new List<CFBar>();

            var infoHolder = _context.ANSWER.Where(x => x.Assessment_Id == assessmentId && x.Is_Requirement == true).ToList();

            // CF full level goes from 0 to 8 on the backend,
            // but 0 1 2 3 4 5 5 6 7 for the user (two 5s, not sure why but they want it),
            // so we need to adjust 6, 7, and 8 down to be a high-5, 6, and 7 for the user

            // we'll do the 0 by itself
            var ansCount = infoHolder.Where(x => x.Answer_Text == "0" 
                                                || x.Answer_Text == "U" 
                                                || x.Answer_Text == "NA" 
                                                || x.Answer_Text == "A").Count();
            list.Add(new CFBar()
            {
                name = "0 - Unanswered / Not Mapped",
                value = ansCount
            });

            // now to do 1 - 8
            for (int i = 1; i < 9; i++)
            {
                var stringIndex = i.ToString();
                ansCount = infoHolder.Where(x => x.Answer_Text == stringIndex).Count();
                list.Add(new CFBar()
                {
                    name = convertAnsToScale(stringIndex),
                    value = ansCount
                });
            }

            return list;
        }


        public List<DomainScore> getGroupingScores(int assessmentId)
        {
            _context.FillEmptyQuestionsForAnalysis(assessmentId);
            var domainList = new List<DomainScore>();
            for (int i = 1; i < _context.NCSF_FUNCTIONS.Count() + 1; i++)
            {
                var tempList = new List<CFAverageScore>();
                var temp = new CFAverageScore();
                //string funcId = _context.NCSF_CATEGORY.Where(x => x.NCSF_Cat_Id == i).Select(x => x.NCSF_Function_Id).ToString();

                var groupings = from q in _context.NEW_REQUIREMENT
                                join func in _context.NCSF_FUNCTIONS on q.Standard_Category equals func.NCSF_Function_Name
                                    into tempFuncs
                                    from tempFunc in tempFuncs.DefaultIfEmpty()
                                join cat in _context.NCSF_CATEGORY on q.Standard_Sub_Category equals cat.NCSF_Category_Name
                                    into tempCats
                                    from tempCat in tempCats.DefaultIfEmpty()
                                join ans in _context.ANSWER on q.Requirement_Id equals ans.Question_Or_Requirement_Id
                                    into tempAnswers
                                    from tempAnswer in tempAnswers.DefaultIfEmpty()
                                where tempAnswer.Assessment_Id == assessmentId && q.Original_Set_Name == "NCSF_V2" && tempFunc.NCSF_Function_Order == i
                                select new { tempFunc, q, tempCat, tempAnswer };

                int runningAnswerTotal = 0;

                //var subcats = groupings.Select(x => x.q.Standard_Sub_Category).Distinct().ToList();
                var currSubcat = "";
                int index = 0;
                int questionCount = 0;
                var sortedList = groupings.ToList().OrderBy(x => x.tempAnswer.Question_Number);

                foreach (var pair in sortedList)
                {
                    if (pair.q.Standard_Sub_Category != currSubcat && index > 0)
                    {
                        
                        tempList.Add(new CFAverageScore()
                        {
                            score = decimal.Divide(runningAnswerTotal, questionCount).Round(2),
                            cat = _context.NCSF_CATEGORY.Where(x => x.NCSF_Category_Name == currSubcat).FirstOrDefault()
                        });

                        // prepping for new subcat
                        runningAnswerTotal = 0;
                        questionCount = 0;
                        currSubcat = pair.q.Standard_Sub_Category;
                    }
                    else
                    {
                        currSubcat = pair.q.Standard_Sub_Category;
                    }

                    if (Int32.TryParse(pair.tempAnswer.Answer_Text, out int ansInt))
                    {
                        runningAnswerTotal += ansInt;
                    }
                    questionCount++;
                    index++;
                }

                tempList.Add(new CFAverageScore()
                {
                    score = decimal.Divide(runningAnswerTotal, questionCount).Round(2),
                    cat = _context.NCSF_CATEGORY.Where(x => x.NCSF_Category_Name == currSubcat).FirstOrDefault()
                });

                decimal lastSubcatRunningAnswerTotal = 0;
                tempList.ForEach(x => lastSubcatRunningAnswerTotal += x.score);

                domainList.Add(new DomainScore()
                {
                    func = groupings.ToList().FirstOrDefault()?.tempFunc,
                    averageScores = tempList,
                    score = (tempList.Count == 0 ? 0 : decimal.Divide(lastSubcatRunningAnswerTotal, tempList.Count).Round(2))
                });
            }

            return domainList;
        }


        public string convertAnsToScale(string ansText)
        {
            // the two 5's are not a mistake
            switch (ansText){
                case "1":
                    return "1 - Not Performed";
                case "2":
                    return "2 - Informally Performed";
                case "3":
                    return "3 - Documented Policy";
                case "4":
                    return "4 - Partially Documented Standards and/or Procedures";
                case "5":
                    return "5 - Risk Formally Accepted";
                case "6":
                    return "5 - Implementation in Progress";
                case "7":
                    return "6 - Tested and Verified";
                case "8":
                    return "7 - Optimized";
                default:
                    return "0 - Unanswered / Not Mapped";
            }
        }

        public class CFBar
        { 
            public string name { get; set; }
            public int value { get; set; }

            public CFBar()
            {
            }
        }

        public class CFAverageScore
        {
            public NCSF_CATEGORY cat { get; set; }
            public int answerTotal { get; set; }
            public int questionsCount { get; set; }

            public decimal score { get; set; }

        }

        public class DomainScore
        {
            public NCSF_FUNCTIONS func { get; set; }
            public List<CFAverageScore> averageScores { get; set; }

            public decimal score { get; set; }
        }

    }
}

