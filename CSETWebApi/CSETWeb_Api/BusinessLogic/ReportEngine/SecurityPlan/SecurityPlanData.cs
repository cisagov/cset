//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSET_Main.Data;
using CSET_Main.Data.AssessmentData;
using CSET_Main.Diagram.DiagramObjects;
using CSET_Main.Questions.POCO;
using CSET_Main.Questions.Slice;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSET_Main.ReportEngine.SecurityPlan
{
    class SecurityPlanData
    {      
        //private bool hasNoComponentQuestions;
        
        

        //private Dictionary<int, HashSet<String>> reqID_to_Zone = new Dictionary<int, HashSet<string>>();
        //private Dictionary<int, HashSet<String>> reqID_To_Component = new Dictionary<int, HashSet<String>>();
        //private Dictionary<int, List<QuestionPoco>> reqID_to_Poco = new Dictionary<int, List<QuestionPoco>>();
        //private Dictionary<int, SecurityPlanStats> reqID_to_Stats = new Dictionary<int, SecurityPlanStats>();
        //private Dictionary<int, Requirement_And_Set> requirements;
        //private Dictionary<int, QuestionPoco> questionsDictionary;
        //private Dictionary<int, QuestionPoco> componentsDefaultQuestionsDictionary;
        //private Dictionary<String, HashSet<NEW_REQUIREMENT>> Zone_To_ReqSet = new Dictionary<string, HashSet<NEW_REQUIREMENT>>();

        //public Dictionary<int, Requirement_And_Set> Requirements
        //{
        //    get { return requirements; }
        //    set { requirements = value; }
        //}

        //public Dictionary<int, HashSet<String>> ReqID_to_Zone
        //{
        //    get { return reqID_to_Zone; }            
        //}
        

        //public Dictionary<int, HashSet<String>> ReqID_To_Component
        //{
        //    get { return reqID_To_Component; }            
        //}
        

        //public Dictionary<int, List<QuestionPoco>> ReqID_to_Poco
        //{
        //    get { return reqID_to_Poco; }            
        //}
        //public Dictionary<int, SecurityPlanStats> ReqID_to_Stats
        //{
        //    get { return reqID_to_Stats; }
        //    set { reqID_to_Stats = value; }
        //}

        ////public Dictionary<String, SecurityPlanStats> Zone_to_ImplementationStat { get; set; }
        
        //public string GetTextForRequirement(NEW_REQUIREMENT req)
        //{
        //    if(questionsDictionary.Keys.Contains(req.Requirement_Id))
        //    {
        //        return questionsDictionary[req.Requirement_Id].TextWithParameters;
        //    }
        //    else
        //    {
        //        return req.Requirement_Text;
        //    }
            
        //}

        //public SecurityPlanData(bool hasNoComponentQuestions,
        //    Dictionary<int,QuestionPoco> componentsDefaultQuestionsDictionary,
        //    Dictionary<int, QuestionPoco> questionsDictionary,
        //    Dictionary<int, Requirement_And_Set> requirements)
        //{
          
        //    this.hasNoComponentQuestions = hasNoComponentQuestions;
        //    this.componentsDefaultQuestionsDictionary = componentsDefaultQuestionsDictionary;
        //    this.questionsDictionary = questionsDictionary;
        //    this.requirements = requirements;
        //}
        //public void GetComponentRequirementsForSecurityPlan(IAssessmentModel assessmentModel)
        //{
        //     if(hasNoComponentQuestions)
        //        return;
             

        //    //Inorder to build multiComponent list and requirement multiServiceComponent list
        //    //in essence give me all the components that this requirement applies to 
        //    //and all the zones this requirement applies to
        //    //so then I have
        //    /**
        //     * a requirements that map to
        //     * a set of multiServiceComponent questions that maps to 
        //     * that have a set of multiServiceComponent types
        //     * that have a set of components
        //     * that have a multiComponent and a multiServiceComponent name
        //     */

        //     Dictionary<String, Dictionary<Guid, NetworkComponent>> dictionaryComponentTypes = assessmentModel.NetworkModel.NetworkData.GetDiagramAnalysisData().DictionaryComponentTypes;
             

        //    foreach(KeyValuePair<int,Requirement_And_Set> rkp in requirements){
        //        //TODO: this need uncommented and rebuilt
        //        //I need a list of all the components associated with this question
        //        //then for each multiServiceComponent I need to know the multiComponent they are associated with. 

                
        //        NEW_REQUIREMENT nr = rkp.Value.NewRequirement;
        //        foreach (NEW_QUESTION nq in nr.NEW_QUESTION.Where(x => x.Original_Set_Name  == "Components"))
        //        {
        //            QuestionPoco poco;
        //            if (componentsDefaultQuestionsDictionary.TryGetValue(nq.Question_Id, out poco))
        //            {
        //                foreach (COMPONENT_QUESTIONS compQuestion in poco.Question.COMPONENT_QUESTIONS)
        //                {
        //                    Dictionary<Guid, NetworkComponent> compdictionary;

        //                    if (dictionaryComponentTypes.TryGetValue(compQuestion.Component_Type, out compdictionary))
        //                    {
        //                        foreach (NetworkComponent comp in compdictionary.Values)
        //                        {
        //                            getUniqueList(nr, comp.ComponentZoneLabel, reqID_to_Zone);
        //                            getUniqueList(nr, comp.HostName, reqID_To_Component);
        //                        }
        //                    }
        //                }
        //                getRtoPoco(nr.Requirement_Id, poco, reqID_to_Poco);
        //                if (!requirements.ContainsKey(nr.Requirement_Id))
        //                {
        //                    requirements.Add(nr.Requirement_Id,
        //                        new Requirement_And_Set()
        //                        {                               
        //                            NewRequirement = nr                               
        //                        });
        //                }
        //            }
        //        }
                
        //    }

            
        //}


        ///// <summary>
        ///// I think I messed up when I smashed the requirements and components together
        ///// I need to know whether something is a multiServiceComponent requirement or a standalone requirement.
        ///// 
        ///// I could just say that if they answered the requirement yes then the answer is yes
        ///// if they didn't answer the requirement then it is based on the multiServiceComponent questions.
        ///// </summary>
        ///// <param name="requirements"></param>
        ///// <param name="questions"></param>
        //internal void calculatePrivacyStats(IActiveQuestions questions, bool IsRequirements)
        //{
        //    //need to go through every requirement get all the related questions and answers and then 
        //    //calculate the percent implemented for each one.

        //    //if we are in questions mode then we need to look up the questions
        //    //if we are in requirements mode then we need to just get the requirement answer and say yes or no 
        //    //based on the requirement answer directly.

         
        //    Dictionary<int, HashSet<QuestionPoco>> reqID_to_PocoList = new Dictionary<int, HashSet<QuestionPoco>>();
            
        //    if (IsRequirements)
        //    {
        //        foreach (KeyValuePair<int,QuestionPoco> rpoco in questions.DictonaryStandardQuestions)
        //        {
        //            SecurityPlanStats stat;
        //            if (!reqID_to_Stats.TryGetValue(rpoco.Key, out stat)){                   
        //                stat = new SecurityPlanStats()
        //                {
        //                    Yes=0,
        //                    Total=0
        //                };
        //                reqID_to_Stats.Add(rpoco.Key, stat);
        //            }
        //            if (rpoco.Value.IsAnswerPassed)
        //            {
        //                stat.Yes++;
        //            }
        //            stat.Total++;
        //        }
        //    }
        //    else
        //    {
        //        foreach (KeyValuePair<int,Requirement_And_Set> e in requirements)
        //        {
        //            SecurityPlanStats stat;
        //            if (!reqID_to_Stats.TryGetValue(e.Key, out stat))
        //            {
        //                stat = new SecurityPlanStats()
        //                {
        //                     Yes=0,
        //                     Total = 0
        //                };
        //                reqID_to_Stats.Add(e.Key, stat);
        //                HashSet<QuestionPoco> pocos;
        //                pocos = new HashSet<QuestionPoco>();                        
        //                reqID_to_PocoList.Add(e.Key, pocos);
        //            }
        //            foreach (NEW_QUESTION nq in e.Value.NewRequirement.NEW_QUESTION)
        //            {
        //                QuestionPoco poco;
        //                if (!questions.DictonaryStandardQuestions.TryGetValue(nq.Question_Id, out poco))
        //                {
        //                    continue;
        //                }
        //                reqID_to_PocoList[e.Key].Add(poco);
        //                if (poco.IsAnswerPassed)
        //                {
        //                    stat.Yes++;
        //                }
        //                stat.Total++;
                        
        //            }
                    
        //        }
        //    }

             
        //    //Zone_to_ImplementationStat = new Dictionary<string, SecurityPlanStats>();
        //    //foreach (KeyValuePair<String, HashSet<NEW_REQUIREMENT>> ztoi in Zone_To_ReqSet)
        //    //{
        //    //    foreach (NEW_REQUIREMENT znr in ztoi.Value)
        //    //    {
        //    //        if(IsRequirements){
        //    //            SecurityPlanStats mytempSps;
        //    //            //get the stats for each requirement in the multiComponent and 
        //    //            //add them into stats for the total multiComponent. 
        //    //            //note quite sure what is different between requirements and questions
        //    //            if (Zone_to_ImplementationStat.TryGetValue(ztoi.Key, out mytempSps))
        //    //            {
        //    //                SecurityPlanStats stat;
        //    //                if (reqID_to_Stats.TryGetValue(znr.Requirement_Id, out stat))
        //    //                {
        //    //                    mytempSps.Total += stat.Total;
        //    //                    mytempSps.Yes += stat.Yes;
        //    //                }
        //    //                else
        //    //                {
        //    //                    stat = new SecurityPlanStats();
        //    //                }
        //    //                Zone_to_ImplementationStat.Add(ztoi.Key, stat);
        //    //            }
        //    //        }
        //    //    }
        //    //}

            
        //}


        //private void getRtoPoco(int rid, QuestionPoco poco, Dictionary<int, List<QuestionPoco>> reqID_to_Poco)
        //{
        //    List<QuestionPoco> pocos;
        //    if(reqID_to_Poco.TryGetValue(rid,out pocos)){
        //        pocos.Add(poco);
        //    }
        //    else{
        //        List<QuestionPoco> pl = new List<QuestionPoco>();
        //        pl.Add(poco);
        //        reqID_to_Poco.Add(rid, pl);
        //    }
        //}

      
        //private void getUniqueList(NEW_REQUIREMENT nr, String label, Dictionary<int, HashSet<String>> reqID_to_Zone)
        //{
        //    HashSet<String> zones;
        //    if (reqID_to_Zone.TryGetValue(nr.Requirement_Id, out zones))
        //    {
        //        zones.Add(label);
        //    }
        //    else
        //    {
        //        zones = new HashSet<string>();
        //        zones.Add(label);
        //        reqID_to_Zone.Add(nr.Requirement_Id, zones);
        //    }
        //    HashSet<NEW_REQUIREMENT> zoneReq;
        //    if(Zone_To_ReqSet.TryGetValue(label,out zoneReq)){
        //        zoneReq.Add(nr);
        //    }
        //    else{
        //        HashSet<NEW_REQUIREMENT> tr =  new HashSet<NEW_REQUIREMENT>();
        //        tr.Add(nr);
        //        Zone_To_ReqSet.Add(label,tr);

        //    }
        //}


       


        //internal void merge(int requirementID, ICollection<NEW_QUESTION> collection)
        //{
        //    List<QuestionPoco> qlist;
        //    if (!reqID_to_Poco.TryGetValue(requirementID, out qlist))
        //    {
        //        qlist = new List<QuestionPoco>();
        //        reqID_to_Poco.Add(requirementID, qlist);
        //    }

        //    foreach (NEW_QUESTION q in collection)
        //    {
        //        QuestionPoco qp;
        //        if (questionsDictionary.TryGetValue(q.Question_Id,out qp))
        //        {
        //            qlist.Add(qp);
        //        }
        //    }
        //}

    
    }
}


