//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.CF;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Question;
using MathNet.Numerics;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.CF
{
    public class CFBusiness:ICFBusiness
    {
        private CSETContext _context;        

        public CFBusiness(CSETContext context)
        {
            this._context = context;
            
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
                                                //|| x.Answer_Text == "A"
                                                ).Count();

            Dictionary<int, string> answerLookup = _context.NCSF_INDEX_ANSWERS.ToDictionary(x => x.Raw_Answer_Value, y => y.Display_Tag);

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
                    name = answerLookup[i],
                    value = ansCount
                });
            }

            return list;
        }


        public async Task<List<usp_CF_Score_AveragesResult>> getGroupingScores(int assessmentId)
        {
            _context.FillEmptyQuestionsForAnalysis(assessmentId);
            var results = await _context.Procedures.usp_CF_Score_AveragesAsync(assessmentId);

            return results.ToList();
        }


        public async Task<List<usp_CF_QuestionsResult>> Top5LowestScoredForAllSubcats(int assessmentId)
        {
            var temp = await _context.Procedures.usp_CF_QuestionsAsync(assessmentId);
            //temp.ForEach(x =>
            //{
            //    x.Answer_Value
            //}
            return temp;
        }


        public async Task<decimal> GetTotalAverageForReports(int assessmentId)
        {
            decimal total = 0;
            var questions = await _context.Procedures.usp_CF_QuestionsAsync(assessmentId);
            questions.ForEach(x =>
            {
                total += (decimal)((x.Answer_Value ?? 0) == 6 ? 5.5m : x.Answer_Value ?? 0);
            });
            decimal totalAvg = decimal.Divide(total, questions.Count).Round(2);

            return totalAvg;
        }


        public class tempclass
        {

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

            public decimal score { get; set; }

        }

        public class DomainScore
        {
            public NCSF_FUNCTIONS func { get; set; }
            public List<CFAverageScore> averageScores { get; set; }

            public decimal score { get; set; }
        }

        public async Task<string> callBull(int assessmentId, int userId)
        {   
            var tojson = (from a in  _context.METRIC_ANSWER_DETAILS                
                         where a.Assessment_id == assessmentId && a.Question_Type == "Requirement"                         
                         select new CyberSecurityPlanExport() {  QuestionId = a.DisplayID, Response = a.Answer_Text=="U"?"0":a.Answer_Text }
                         ).ToList();

            var tmp = JsonConvert.SerializeObject(tojson);

            string jsonData = "{ \"UserId\": \"" + userId + "\", \"AssessmentID\": \"" + assessmentId + "\", \"SurveyIdentifier\": \"v3\", \"SurveyData\": " + tmp  + "}";
            // THE RESPONSE IS THE REDIRECT URL
            string response = await PostToApiAsync("https://edvision.ai/api/survey/data", jsonData);
            return response;

        }


        public async Task<string> PostToApiAsync(string url, string jsonContent)
        {
            using (HttpClient client = new HttpClient())
            {
                try
                {
                    // Set up the request content
                    var content = new StringContent(jsonContent, Encoding.UTF8, "application/json");

                    // Send the POST request
                    HttpResponseMessage response = await client.PostAsync(url, content);

                    // Ensure the request was successful
                    response.EnsureSuccessStatusCode();

                    // Read and return the response content
                    string responseBody = await response.Content.ReadAsStringAsync();
                    return responseBody;
                }catch(Exception e)
                {
                    Console.WriteLine(e);
                }
                return null;
            }
        }

    }

    public class CyberSecurityPlanExport
    {
        public string QuestionId { get; set; }
        public string Response { get; set; }
    }
}

