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
using CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.rules.MalcolmRules;
using CSETWeb_Api.BusinessLogic.BusinessManagers.Diagram.analysis.rules;
using CSETWebCore.Business.Diagram.analysis.rules;
using System.Text;
using CSETWebCore.Business.BusinessManagers.Diagram.analysis;
using CSETWebCore.Model.Assessment;
using Newtonsoft.Json;

namespace CSETWebCore.Business.Malcolm
{
    public class MalcolmBusiness : IMalcolmBusiness
    {
        private CSETContext _context;

        private Dictionary<string, TempNode> networkOfNodes = new Dictionary<string, TempNode>();



        public MalcolmBusiness(CSETContext context)
        {
            _context = context;
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
        public void VerificationAndValidation(int assessment_Id)
        {
            var assessment = _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessment_Id).FirstOrDefault();
            string xmlMarkup = assessment.Diagram_Markup;

            if (xmlMarkup == null)
            {
                return;
            }

            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(xmlMarkup);
            List<MALCOLM_MAPPING> malcolmMappingInfo = new DiagramAnalysis(_context, assessment_Id).PerformMalcolmAnalysis(xmlDoc);
            
            if (malcolmMappingInfo.Count > 0)
            {
                foreach(MALCOLM_MAPPING m in malcolmMappingInfo)
                {
                    var dbAnswer = _context.ANSWER.Where(x => x.Assessment_Id == assessment_Id 
                        && x.Question_Or_Requirement_Id == m.Question_Or_Requirement_Id).FirstOrDefault();

                    // HYDRO uses Mat_Option_Id and has "S" for "Selected" instead of "N" or "Y"
                    string answerText = m.Mat_Option_Id == null ? "N" : "S";

                    if (dbAnswer == null)
                    {
                        // need to make sure the assessment uses the Set / Maturity before adding answers for it
                        GalleryConfig config = null;
                        var galleryItem = _context.GALLERY_ITEM.FirstOrDefault(x => x.Gallery_Item_Guid == assessment.GalleryItemGuid);
                        if (galleryItem != null)
                        {
                            config = JsonConvert.DeserializeObject<GalleryConfig>(galleryItem.Configuration_Setup);
                            config.GalleryGuid = (Guid)assessment.GalleryItemGuid;

                            // check if Maturity is used
                            if (config.Model != null)
                            {
                                var model = _context.MATURITY_MODELS.Where(x => x.Model_Name == config.Model.ModelName).FirstOrDefault();
                                if (model != null)
                                {
                                    var q = _context.MATURITY_QUESTIONS.Where(x => x.Maturity_Model_Id == model.Maturity_Model_Id
                                        && x.Mat_Question_Id == m.Question_Or_Requirement_Id).FirstOrDefault();

                                    if (q != null)
                                    {
                                        _context.MALCOLM_ANSWERS.Add(SetUpAnswer(assessment_Id, answerText, m));
                                    }
                                }
                            }

                            // check if Standard is used
                            if (config.Sets != null)
                            {
                                foreach (var set in config.Sets)
                                {
                                    var req = _context.NEW_REQUIREMENT.Where(x => x.Original_Set_Name == set 
                                        && x.Requirement_Id == m.Question_Or_Requirement_Id).FirstOrDefault();

                                    if (req != null)
                                    {
                                        var temp = _context.MALCOLM_ANSWERS.Where(x => x.Assessment_Id == assessment_Id && x.Question_Or_Requirement_Id == m.Question_Or_Requirement_Id)
                                        if (temp == null)
                                        {
                                            _context.MALCOLM_ANSWERS.Add(SetUpAnswer(assessment_Id, answerText, m));
                                        }
                                    }
                                }
                            }

                            // check if Diagram is used (which it should be)
                            if (config.Diagram != null && config.Diagram)
                            {
                                var new_q = _context.NEW_QUESTION.Where(x => x.Original_Set_Name == "Components"
                                        && x.Question_Id == m.Question_Or_Requirement_Id).FirstOrDefault();

                                if (new_q != null)
                                {
                                    _context.MALCOLM_ANSWERS.Add(SetUpAnswer(assessment_Id, answerText, m));
                                }
                            }
                        }
                    }

                    else if (dbAnswer.Answer_Text == "U" || dbAnswer.Answer_Text == "")
                    {
                        dbAnswer.Answer_Text = answerText;
                        dbAnswer.Mat_Option_Id = m.Mat_Option_Id;
                    }
                }

                _context.SaveChanges();
            }
        }

        public MALCOLM_ANSWERS SetUpAnswer(int assessId, string answerText, MALCOLM_MAPPING currentMalcolmMapRow)
        {
            var answer = new MALCOLM_ANSWERS();
            answer.Assessment_Id = assessId;
            answer.Question_Or_Requirement_Id = currentMalcolmMapRow.Question_Or_Requirement_Id;
            answer.Malcolm_Id = currentMalcolmMapRow.Malcolm_Id;
            answer.Answer_Text = answerText;
            answer.Mat_Option_Id = currentMalcolmMapRow.Mat_Option_Id;

            return answer;
        }

        


    }
}
