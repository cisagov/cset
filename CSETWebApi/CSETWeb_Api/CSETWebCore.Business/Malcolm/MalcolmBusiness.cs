using CSETWebCore.Business.Aggregation;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Malcolm;
using CSETWebCore.Model.Malcolm;
using CSETWebCore.Model.Question;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using CSETWebCore.Business.Diagram.Analysis;
using System.Xml;
using Lucene.Net.Util;

namespace CSETWebCore.Business.Malcolm
{
    public class MalcolmBusiness : IMalcolmBusiness
    {
        private CSETContext _context;
        private ITokenManager _token;

        private Dictionary<string, TempNode> networkOfNodes = new Dictionary<string, TempNode>();



        public MalcolmBusiness(CSETContext context, ITokenManager token)
        {
            _context = context;
            _token = token;
        }

        public List<MalcolmData> GetMalcolmJsonData(List<MalcolmData> datalist)
        {   
            foreach (MalcolmData malcolmData in datalist)
            {
                if (malcolmData != null)
                {
                    foreach (var bucket in malcolmData.Values.Buckets)
                    {
                        //if (!networkOfNodes.ContainsKey(bucket.Key))
                        //{
                            var buckets = new List<Buckets>() { bucket };
                            BuildNetwork(null, buckets);
                        //}
                    }
                    malcolmData.Graphs = networkOfNodes;
                    networkOfNodes = new Dictionary<string, TempNode>();           
                }
            }
            datalist = GetTreesFromMalcolmData(datalist);
            return datalist;

        }
        public List<MalcolmData> GetTreesFromMalcolmData(List<MalcolmData> datalist)
        {
            var malcolmDataList = new List<MalcolmData>();            
            foreach (MalcolmData malcolmData in datalist)
            {
                if (malcolmData != null)
                {   
                    MalcolmTree trees = new MalcolmTree();
                    malcolmData.Trees = trees.StartTheTreeWalk(malcolmData.Graphs);
                    malcolmDataList.Add(malcolmData);
                }
            }
            return malcolmDataList;

        }

        private void BuildNetwork(TempNode parent, List<Buckets> buckets)
        {
            foreach (var bucket in buckets)
            {
                TempNode tnode;
                if (String.IsNullOrEmpty(bucket.Key))
                {
                    continue;
                }
                if (networkOfNodes.TryGetValue(bucket.Key, out tnode))
                {
                    if (parent != null)
                        parent.AddChildGraphOnly(tnode);                    
                }
                else
                {
                    // checking for role
                    if (!bucket.Key.Contains('.') && !bucket.Key.Contains(':'))
                    {
                        parent.Role = bucket.Key;
                        if (bucket.Values != null)
                            BuildNetwork(parent, bucket.Values.Buckets);
                        return;
                    }
                    tnode = new TempNode(bucket.Key);
                    networkOfNodes.TryAdd(bucket.Key, tnode);
                    if (parent != null)
                        parent.AddChildGraphOnly(tnode);
                }
                if (bucket.Values != null)
                {
                    BuildNetwork(tnode, bucket.Values.Buckets);
                }
            }
        }

        // name is TBD
        public void VerificationAndValidation()
        {
            int assessment_Id = _token.AssessmentForUser();

            var xmlMarkup = _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessment_Id).Select(x => x.Diagram_Markup).FirstOrDefault();

            if (xmlMarkup == null)
            {
                return;
            }

            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(xmlMarkup);
            List<int> malcolmRulesViolated = new DiagramAnalysis(_context, assessment_Id).PerformMalcolmAnalysis(xmlDoc);

            var warnings = _context.NETWORK_WARNINGS.Where(x => x.Assessment_Id == assessment_Id).Select(x => x.Rule_Violated).Distinct().ToList();

            if (malcolmRulesViolated.Count > 0)
            {
                foreach(int rule in malcolmRulesViolated)
                {
                    warnings.Add(rule);
                }
            }
            var questions = _context.NEW_QUESTION.Where(y => y.Std_Ref == "Comp").Select(y => y.Question_Id).ToList();

            if (warnings != null && warnings.Count > 0)
            {
                CheckQuestionsForViolations(warnings, assessment_Id, questions);
            }

        }

        public void CheckQuestionsForViolations(List<int?> warnings, int assessment_Id, List<int> questions)
        {
            var malcolmAnswerables = _context.MALCOLM_MAPPING.ToList(); // questions we can answer for the user

            foreach (var temp in malcolmAnswerables) {
                var dbAnswer = _context.ANSWER.Where(x => x.Assessment_Id == assessment_Id && x.Question_Or_Requirement_Id == temp.Question_Id).FirstOrDefault();
                // prevents overwriting the user's answer over and over
                if (dbAnswer == null)
                {
                    foreach (int warning in warnings)
                    {
                        if (temp.Rule_Violated == warning)
                        {
                            // 2: IDS doesn't exist in a helpful way
                            // 5: firewall isn't connected properly
                            // 8: IPS doesn't exist in a helpful way
                            var answer = new ANSWER
                            {
                                Assessment_Id = assessment_Id,
                                Question_Or_Requirement_Id = temp.Question_Id,
                                Answer_Text = "N",
                                Question_Type = "Component",
                                Is_Component = true
                            };
                            _context.ANSWER.Add(answer);
                        }
                    }
                }
            }

            _context.SaveChanges();
        }

        public ANSWER SetUpAnswer(int assessId, int questionId, string answerText)
        {
            var answer = new ANSWER();
            answer.Assessment_Id = assessId;
            answer.Question_Or_Requirement_Id = questionId;
            answer.Answer_Text = answerText;

            return answer;
        }
    }
}
