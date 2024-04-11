//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CSETWebCore.Model.Edm;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.AdminTab;

namespace CSETWebCore.Business.Maturity
{
    public class EdmNistCsfMapping
    {

        private CSETContext _context;
        // private readonly IAssessmentUtil _assessmentUtil;
        //private readonly IAdminTabBusiness _adminTabBusiness;

        public EdmNistCsfMapping(CSETContext context)
        {
            _context = context;
            // _assessmentUtil = assessmentUtil;
            // _adminTabBusiness = adminTabBusiness;
        }


        /// <summary>
        /// Returns EDM answers mapped to the NIST CSF category structure.
        /// </summary>
        /// <returns></returns>
        public List<RelevantEDMAnswersAppendix> GetEdmNistCsfResults(int assessmentId)
        {
            _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

            // Here we query the db for all the edm answers
            var q = from a in _context.MATURITY_QUESTIONS
                    join b in _context.ANSWER on a.Mat_Question_Id equals b.Question_Or_Requirement_Id
                    where b.Assessment_Id == assessmentId && a.Maturity_Model_Id == 3
                    select new RelevantEDMAnswerResult() { QuestionTitle = a.Question_Title, QuestionText = a.Question_Text, AnswerText = b.Answer_Text };

            q.ToList();

            var answers = GetFrameworkFuctions(q.ToList());
            GetFrameworkTotals(ref answers);
            GetAnswersByGoalNumber(ref answers);

            return answers;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="answers"></param>
        public void GetAnswersByGoalNumber(ref List<RelevantEDMAnswersAppendix> answers)
        {
            string[] subGoalResultsName;
            string[] subGoalResultSection;
            IEnumerable<EDMSubcategoryGoalGroup> subGoalResults;
            IEnumerable<EDMSubcategoryGoalResults> subGoalSectionsResults;

            foreach (RelevantEDMAnswersAppendix function in answers)
            {
                foreach (Category cat in function.Categories)
                {
                    // (Note that only ID.BE has mapped questions at the Category level)
                    if (cat.AnsweredEDM != null)
                    {
                        cat.GoalResults = new List<EDMSubcategoryGoalGroup>();
                        foreach (var ans in cat.AnsweredEDM)
                        {
                            subGoalResultsName = ans.QuestionTitle.Split(':');
                            subGoalResults = cat.GoalResults.Where(g => g.GroupName == subGoalResultsName[0]);
                            if (subGoalResults.Count() <= 0)
                            {
                                cat.GoalResults.Add(new EDMSubcategoryGoalGroup
                                {
                                    GroupName = subGoalResultsName[0],
                                    SubResults = new List<EDMSubcategoryGoalResults>()
                                });
                                subGoalResults = cat.GoalResults.Where(g => g.GroupName == subGoalResultsName[0]);
                            }

                            subGoalResults.First().SubResults.Add(new EDMSubcategoryGoalResults
                            {
                                GoalName = subGoalResultsName[1],
                                Answer = ans.AnswerText
                            });
                        }
                    }

                    foreach (SubCategory subcat in cat.SubCategories)
                    {
                        subcat.GoalResults = new List<EDMSubcategoryGoalGroup>();
                        foreach (RelevantEDMAnswerResult ans in subcat.AnsweredEDM)
                        {
                            //Get subresults section, create new one if its new, add to previous if it exists
                            subGoalResultsName = ans.QuestionTitle.Split(':');
                            subGoalResults = subcat.GoalResults.Where(g => g.GroupName == subGoalResultsName[0]);
                            if (subGoalResults.Count() <= 0)
                            {
                                subcat.GoalResults.Add(new EDMSubcategoryGoalGroup
                                {
                                    GroupName = subGoalResultsName[0],
                                    SubResults = new List<EDMSubcategoryGoalResults>()
                                });
                                subGoalResults = subcat.GoalResults.Where(g => g.GroupName == subGoalResultsName[0]);
                            }

                            //Check if edm reference has further sub results
                            if (subGoalResultsName[1].Contains('-'))
                            {
                                subGoalResultSection = subGoalResultsName[1].Split('-');
                                subGoalSectionsResults = subGoalResults.First().SubResults.Where(s => s.GoalName == subGoalResultSection[0]);
                                if (subGoalSectionsResults.Count() == 0)
                                {
                                    subGoalResults.First().SubResults.Add(
                                        new EDMSubcategoryGoalResults
                                        {
                                            GoalName = subGoalResultSection[0],
                                            Answer = "N/A"
                                        }
                                    );
                                    subGoalSectionsResults = subGoalResults.First().SubResults.Where(s => s.GoalName == subGoalResultSection[0]);
                                    subGoalSectionsResults.First().SubResults = new List<EDMSubcategoryGoalResults>();
                                }
                                subGoalSectionsResults.First().SubResults.Add(
                                    new EDMSubcategoryGoalResults
                                    {
                                        GoalName = subGoalResultSection[1],
                                        Answer = ans.AnswerText
                                    }
                                );
                            }
                            else
                            {
                                subGoalResults.First().SubResults.Add(new EDMSubcategoryGoalResults
                                {
                                    GoalName = subGoalResultsName[1],
                                    Answer = ans.AnswerText
                                });
                            }
                        }
                    }
                }
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="answers"></param>
        /// <returns></returns>
        public List<RelevantEDMAnswersAppendix> GetFrameworkFuctions(List<RelevantEDMAnswerResult> answers)
        {
            var builtdata = new List<RelevantEDMAnswersAppendix>();

            var fucntionIdentify = new RelevantEDMAnswersAppendix
            {
                FunctionName = "Identify",
                Acronym = "ID",
                Summary = "The activities in the Identify Function are foundational for effective use of the Framework. Understanding the business context, the resources that support critical functions, and the related cybersecurity risks enables an organization to focus and prioritize its efforts, consistent with its risk management strategy and business needs.",
                Categories = new List<Category> {
                    new Category {
                        Name = "Asset Management",
                        Acronym = "AM",
                        Description = "The data, personnel, devices, systems, and facilities that enable the organization to achieve business purposes are identified and managed consistent with their relative importance to organizational objectives and the organization’s risk strategy",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "ID.AM-1",
                                Question_Text = "Physical devices and systems within the organization are inventoried",
                                EDMReferences = new List<string>{"RF:G1.Q3"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RF:G1.Q3"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.AM-2",
                                Question_Text = "Software platforms and applications within the organization are inventoried",
                                EDMReferences = new List<string>{"RF:G1.Q3"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RF:G1.Q3"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.AM-3",
                                Question_Text = "Organizational communication and data flows are mapped",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.AM-4",
                                Question_Text = "External information systems are catalogued",
                                EDMReferences = new List<string>{"RF:G1.Q3"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RF:G1.Q3"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.AM-5",
                                Question_Text = "Resources (e.g., hardware, devices, data, time, personnel, and software) are prioritized based on their classification, criticality, and business value",
                                EDMReferences = new List<string>{"RF:G1.Q2"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RF:G1.Q2"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.AM-6",
                                Question_Text = "Cybersecurity roles and responsibilities for the entire workforce and third - party stakeholders (e.g., suppliers, customers, partners) are established",
                                EDMReferences = new List<string>{"RMG:G6.Q2", "RMG:G6.Q3", "SPS:G3.Q1"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RMG:G6.Q2", "RMG:G6.Q3", "SPS:G3.Q1"}, answers)
                            }
                        }
                    },
                    new Category {
                        Name = "Business Environment",
                        Acronym = "BE",
                        Description = "The organization’s mission, objectives, stakeholders, and activities are understood and prioritized; this information is used to inform cybersecurity roles, responsibilities, and risk management decisions.",
                        AnsweredEDM = GetEDMAnswers(new List<string>() {"RF:G1.Q1", "RF:G1.Q2"}, answers),
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "ID.BE-1",
                                Question_Text = "The organization’s role in the supply chain is identified and communicated",
                                EDMReferences = new List<string>{"RF:G2.Q1", "RF:G2.Q2", "RF:G2.Q3", "RF:G2.Q4", "RF:G3.Q2-S", "RF:G3.Q2-IP", "RF:G3.Q2-GS", "RF:G4.Q2", "RF:G5.Q1", "RMG:G2.Q1", "RMG:G6.Q1" },
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RF:G2.Q1", "RF:G2.Q2", "RF:G2.Q3", "RF:G2.Q4", "RF:G3.Q2-S", "RF:G3.Q2-IP", "RF:G3.Q2-GS", "RF:G4.Q2", "RF:G5.Q1", "RMG:G2.Q1", "RMG:G6.Q1" }, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.BE-2",
                                Question_Text = "The organization’s place in critical infrastructure and its industry sector is identified and communicated",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.BE-3",
                                Question_Text = "Priorities for organizational mission, objectives, and activities are established and communicated",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.BE-4",
                                Question_Text = "Dependencies and critical functions for delivery of critical services are established",
                                EDMReferences = new List<string>{"RF:G2.Q4", "RF:G4.Q2", "RF:G6.Q2", "RMG:G1.Q1-S", "RMG:G1.Q1-IP", "RMG:G1.Q1-GS", "RMG:G1.Q2", "RMG:G1.Q3"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RF:G2.Q4", "RF:G4.Q2", "RF:G6.Q2", "RMG:G1.Q1-S", "RMG:G1.Q1-IP", "RMG:G1.Q1-GS", "RMG:G1.Q2", "RMG:G1.Q3"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.BE-5",
                                Question_Text = "Resilience requirements to support delivery of critical services are established for all operating states (e.g.under duress / attack, during recovery, normal operations)",
                                EDMReferences = new List<string>{"RF:G1.Q4", "RF:G2.Q3", "RF:G6.Q1", "RMG:G2.Q1", "RMG:G6.Q1"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RF:G1.Q4", "RF:G2.Q3", "RF:G6.Q1", "RMG:G2.Q1", "RMG:G6.Q1"}, answers)
                            }
                        }
                    },
                    new Category {
                        Name = "Governance",
                        Acronym = "GV",
                        Description = "The policies, procedures, and processes to manage and monitor the organization’s regulatory, legal, risk, environmental, and operational requirements are understood and inform the management of cybersecurity risk.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "ID.GV-1",
                                Question_Text = "Organizational cybersecurity policy is established and communicated",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.GV-2",
                                Question_Text = "Cybersecurity roles and responsibilities are coordinated and aligned with internal roles and external partners",
                                EDMReferences = new List<string>{"RMG:G6.Q2", "RMG:G6.Q3"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RMG:G6.Q2", "RMG:G6.Q3"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.GV-3",
                                Question_Text = "Legal and regulatory requirements regarding cybersecurity, including privacy and civil liberties obligations, are understood and managed",
                                EDMReferences = new List<string>{"RF:G1.Q4", "RF:G2.Q2"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RF:G1.Q4", "RF:G2.Q2"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.GV-4",
                                Question_Text = "Governance and risk management processes address cybersecurity risks",
                                EDMReferences = new List<string>{"RF:G3.Q1"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RF:G3.Q1"}, answers)
                            }
                        }
                    },
                    new Category {
                        Name = "Risk Assessment",
                        Acronym = "RA",
                        Description = "The organization understands the cybersecurity risk to organizational operations (including mission, functions, image, or reputation), organizational assets, and individuals.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "ID.RA-1",
                                Question_Text = "Asset vulnerabilities are identified and documented",
                                EDMReferences = new List<string>{ "RF:G6.Q2", "RMG:G2.Q4"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{ "RF:G6.Q2", "RMG:G2.Q4"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.RA-2",
                                Question_Text = "Cyber threat intelligence is received from information sharing forums and sources",
                                EDMReferences = new List<string>{"SPS:G3.Q1", "SPS:G3.Q2","SPS:G3.Q4","SPS:G3.Q5"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"SPS:G3.Q1", "SPS:G3.Q2","SPS:G3.Q4","SPS:G3.Q5"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.RA-3",
                                Question_Text = "Threats, both internal and external, are identified and documented",
                                EDMReferences = new List<string>{"SPS:G3.Q2", "SPS:G3.Q3-S","SPS:G3.Q3-IP"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"SPS:G3.Q2", "SPS:G3.Q3-S","SPS:G3.Q3-IP"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.RA-4",
                                Question_Text = "Potential business impacts and likelihoods are identified",
                                EDMReferences = new List<string>{"RF:G3.Q3"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RF:G3.Q3"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.RA-5",
                                Question_Text = "Threats, vulnerabilities, likelihoods, and impacts are used to determine risk",
                                EDMReferences = new List<string>{"RF:G3.Q2-S","RF:G3.Q2-IP","RF:G3.Q2-GS","RF:G3.Q3"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RF:G3.Q2-S","RF:G3.Q2-IP","RF:G3.Q2-GS","RF:G3.Q3"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.RA-6",
                                Question_Text = "Risk responses are identified and prioritized",
                                EDMReferences = new List<string>{"RF:G3.Q2-S","RF:G3.Q2-IP","RF:G3.Q2-GS"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RF:G3.Q2-S","RF:G3.Q2-IP","RF:G3.Q2-GS"}, answers)
                            }
                        }
                    },
                    new Category {
                        Name = "Risk Management Strategy",
                        Acronym = "RM",
                        Description = "The organization’s priorities, constraints, risk tolerances, and assumptions are established and used to support operational risk decisions.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "ID.RM-1",
                                Question_Text = "Risk management processes are established, managed, and agreed to by organizational stakeholders",
                                EDMReferences = new List<string>{"RF:G3.Q1", "RMG:G2.Q5", "RMG:G2.Q6", "RMG:G6.Q5"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RF:G3.Q1", "RMG:G2.Q5", "RMG:G2.Q6", "RMG:G6.Q5"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.RM-2",
                                Question_Text = "Organizational risk tolerance is determined and clearly expressed",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.RM-3",
                                Question_Text = "The organization’s determination of risk tolerance is informed by its role in critical infrastructure and sector specific risk analysis",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            }
                        }
                    },
                    new Category {
                        Name = "Supply Chain Risk Management",
                        Acronym = "SC",
                        Description = "The organization’s priorities, constraints, risk tolerances, and assumptions are established and used to support risk decisions associated with managing supply chain risk. The organization has established and implemented the processes to identify, assess and manage supply chain risks.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "ID.SC-1",
                                Question_Text = "Cyber supply chain risk management processes are identified, established, assessed, managed, and agreed to by organizational stakeholders",
                                EDMReferences = new List<string>{"RF:G2.Q1","RF:G3.Q1","RF:G3.Q2-S","RF:G3.Q2-IP","RF:G3.Q2-GS","RMG:G2.Q2","RMG:G2.Q5","RMG:G2.Q6","RMG:G3.Q2","RMG:G4.Q3","RMG:G4.Q4","RMG:G5.Q1","RMG:G5.Q2","RMG:G5.Q3","RMG:G6.Q5","SPS:G2.Q4"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RF:G2.Q1","RF:G3.Q1","RF:G3.Q2-S","RF:G3.Q2-IP","RF:G3.Q2-GS","RMG:G2.Q2","RMG:G2.Q5","RMG:G2.Q6","RMG:G3.Q2","RMG:G4.Q3","RMG:G4.Q4","RMG:G5.Q1","RMG:G5.Q2","RMG:G5.Q3","RMG:G6.Q5","SPS:G2.Q4"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.SC-2",
                                Question_Text = "Suppliers and third party partners of information systems, components, and services are identified, prioritized, and assessed using a cyber supply chain risk assessment process",
                                EDMReferences = new List<string>{
                                    "RF:G2.Q1",
                                    "RF:G3.Q2-S",
                                    "RF:G3.Q2-IP",
                                    "RF:G3.Q2-GS",
                                    "RF:G3.Q3",
                                    "RF:G4.Q1",
                                    "RF:G4.Q3",
                                    "RF:G4.Q4",
                                    "RF:G6.Q3",
                                    "RF:G6.Q4",
                                    "RF:G6.Q5",
                                    "RMG:G1.Q1-S",
                                    "RMG:G1.Q1-IP",
                                    "RMG:G1.Q1-GS",
                                    "RMG:G1.Q2",
                                    "RMG:G1.Q3",
                                    "RMG:G2.Q3",
                                    "RMG:G2.Q5",
                                    "RMG:G2.Q6",
                                    "SPS:G1.Q4-IM",
                                    "SPS:G1.Q4-SC",
                                    "SPS:G2.Q2-IM",
                                    "SPS:G2.Q2-SC",
                                    "SPS:G2.Q4" },
                                AnsweredEDM = GetEDMAnswers(new List<string>{
                                    "RF:G2.Q1",
                                    "RF:G3.Q2-S",
                                    "RF:G3.Q2-IP",
                                    "RF:G3.Q2-GS",
                                    "RF:G3.Q3",
                                    "RF:G4.Q1",
                                    "RF:G4.Q3",
                                    "RF:G4.Q4",
                                    "RF:G6.Q3",
                                    "RF:G6.Q4",
                                    "RF:G6.Q5",
                                    "RMG:G1.Q1-S",
                                    "RMG:G1.Q1-IP",
                                    "RMG:G1.Q1-GS",
                                    "RMG:G1.Q2",
                                    "RMG:G1.Q3",
                                    "RMG:G2.Q3",
                                    "RMG:G2.Q5",
                                    "RMG:G2.Q6",
                                    "SPS:G1.Q4-IM",
                                    "SPS:G1.Q4-SC",
                                    "SPS:G2.Q2-IM",
                                    "SPS:G2.Q2-SC",
                                    "SPS:G2.Q4" }, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.SC-3",
                                Question_Text = "Contracts with suppliers and third-party partners are used to implement appropriate measures designed to meet the objectives of an organization’s cybersecurity program and Cyber Supply Chain Risk Management Plan.",
                                EDMReferences = new List<string>{
                                    "RF:G2.Q1",
                                    "RF:G2.Q2",
                                    "RF:G2.Q3",
                                    "RF:G2.Q4",
                                    "RF:G4.Q1",
                                    "RF:G4.Q2",
                                    "RF:G4.Q3",
                                    "RF:G4.Q4",
                                    "RF:G5.Q1",
                                    "RF:G5.Q2",
                                    "RF:G5.Q3",
                                    "RF:G5.Q4",
                                    "RF:G5.Q5",
                                    "RF:G5.Q6",
                                    "RMG:G2.Q1",
                                    "RMG:G4.Q3",
                                    "RMG:G4.Q5",
                                    "RMG:G5.Q1",
                                    "RMG:G5.Q2",
                                    "RMG:G6.Q1",
                                    "SPS:G2.Q2-IM",
                                    "SPS:G2.Q2-SC",
                                    "SPS:G2.Q4" },
                                AnsweredEDM = GetEDMAnswers(new List<string>{
                                    "RF:G2.Q1",
                                    "RF:G2.Q2",
                                    "RF:G2.Q3",
                                    "RF:G2.Q4",
                                    "RF:G4.Q1",
                                    "RF:G4.Q2",
                                    "RF:G4.Q3",
                                    "RF:G4.Q4",
                                    "RF:G5.Q1",
                                    "RF:G5.Q2",
                                    "RF:G5.Q3",
                                    "RF:G5.Q4",
                                    "RF:G5.Q5",
                                    "RF:G5.Q6",
                                    "RMG:G2.Q1",
                                    "RMG:G4.Q3",
                                    "RMG:G4.Q5",
                                    "RMG:G5.Q1",
                                    "RMG:G5.Q2",
                                    "RMG:G6.Q1",
                                    "SPS:G2.Q2-IM",
                                    "SPS:G2.Q2-SC",
                                    "SPS:G2.Q4" }, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.SC-4",
                                Question_Text = "Suppliers and third-party partners are routinely assessed using audits, test results, or other forms of evaluations to confirm they are meeting their contractual obligations.",
                                EDMReferences = new List<string>{
                                    "RF:G3.Q2-S",
                                    "RF:G3.Q2-IP",
                                    "RF:G3.Q2-GS",
                                    "RF:G3.Q3",
                                    "RMG:G2.Q2",
                                    "RMG:G2.Q3",
                                    "RMG:G2.Q4",
                                    "RMG:G2.Q5",
                                    "RMG:G2.Q6",
                                    "RMG:G3.Q1",
                                    "RMG:G3.Q2",
                                    "RMG:G3.Q3",
                                    "RMG:G3.Q4",
                                    "RMG:G4.Q3",
                                    "RMG:G4.Q4",
                                    "RMG:G4.Q5",
                                    "RMG:G6.Q2",
                                    "RMG:G6.Q3",
                                    "RMG:G6.Q4",
                                    "SPS:G2.Q1-IM",
                                    "SPS:G2.Q1-SC",
                                    "SPS:G2.Q3",
                                    "SPS:G2.Q4" },
                                AnsweredEDM = GetEDMAnswers(new List<string>{
                                    "RF:G3.Q2-S",
                                    "RF:G3.Q2-IP",
                                    "RF:G3.Q2-GS",
                                    "RF:G3.Q3",
                                    "RMG:G2.Q2",
                                    "RMG:G2.Q3",
                                    "RMG:G2.Q4",
                                    "RMG:G2.Q5",
                                    "RMG:G2.Q6",
                                    "RMG:G3.Q1",
                                    "RMG:G3.Q2",
                                    "RMG:G3.Q3",
                                    "RMG:G3.Q4",
                                    "RMG:G4.Q3",
                                    "RMG:G4.Q4",
                                    "RMG:G4.Q5",
                                    "RMG:G6.Q2",
                                    "RMG:G6.Q3",
                                    "RMG:G6.Q4",
                                    "SPS:G2.Q1-IM",
                                    "SPS:G2.Q1-SC",
                                    "SPS:G2.Q3",
                                    "SPS:G2.Q4" },answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.SC-5",
                                Question_Text = "Response and recovery planning and testing are conducted with suppliers and third-party providers",
                                EDMReferences = new List<string>{
                                "RF:G5.Q6",
                                "SPS:G1.Q1",
                                "SPS:G1.Q3",
                                "SPS:G1.Q4-IM",
                                "SPS:G1.Q4-SC",
                                "SPS:G1.Q5-IM",
                                "SPS:G1.Q5-SC",
                                "SPS:G2.Q1-IM",
                                "SPS:G2.Q1-SC"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{
                                "RF:G5.Q6",
                                "SPS:G1.Q1",
                                "SPS:G1.Q3",
                                "SPS:G1.Q4-IM",
                                "SPS:G1.Q4-SC",
                                "SPS:G1.Q5-IM",
                                "SPS:G1.Q5-SC",
                                "SPS:G2.Q1-IM",
                                "SPS:G2.Q1-SC"}, answers)
                            }
                        }
                    },
                }
            };

            var fucntionProtect = new RelevantEDMAnswersAppendix
            {
                FunctionName = "Protect",
                Acronym = "PR",
                Summary = "The Protect Function supports the ability to limit or contain the impact of a potential cybersecurity event.",
                Categories = new List<Category> {
                    new Category {
                        Name = "Identity Management, Authentication and Access Control",
                        ShortName = "Access Control",
                        Acronym = "AC",
                        Description = "Access to physical and logical assets and associated facilities is limited to authorized users, processes, and devices, and is managed consistent with the assessed risk of unauthorized access to authorized activities and transactions.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "PR.AC-1",
                                Question_Text = "Identities and credentials are issued, managed, verified, revoked, and audited for authorized devices, users and processes",
                                EDMReferences = new List<string>{
                                    "RMG:G7.Q1",
                                    "RMG:G7.Q2",
                                    "RMG:G7.Q3-I",
                                    "RMG:G7.Q3-T",
                                    "RMG:G7.Q3-F",
                                    "RMG:G7.Q4-I",
                                    "RMG:G7.Q4-T",
                                    "RMG:G7.Q4-F"
                                },
                                AnsweredEDM = GetEDMAnswers(new List<string>{
                                    "RMG:G7.Q1",
                                    "RMG:G7.Q2",
                                    "RMG:G7.Q3-I",
                                    "RMG:G7.Q3-T",
                                    "RMG:G7.Q3-F",
                                    "RMG:G7.Q4-I",
                                    "RMG:G7.Q4-T",
                                    "RMG:G7.Q4-F"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.AC-2",
                                Question_Text = "Physical access to assets is managed and protected",
                                EDMReferences = new List<string>{
                                    "RMG:G7.Q1",
                                    "RMG:G7.Q2",
                                    "RMG:G7.Q3-I",
                                    "RMG:G7.Q3-T",
                                    "RMG:G7.Q3-F",
                                    "RMG:G7.Q4-I",
                                    "RMG:G7.Q4-T",
                                    "RMG:G7.Q4-F"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{
                                    "RMG:G7.Q1",
                                    "RMG:G7.Q2",
                                    "RMG:G7.Q3-I",
                                    "RMG:G7.Q3-T",
                                    "RMG:G7.Q3-F",
                                    "RMG:G7.Q4-I",
                                    "RMG:G7.Q4-T",
                                    "RMG:G7.Q4-F"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.AC-3",
                                Question_Text = "Remote access is managed",
                                EDMReferences = new List<string>{
                                    "RMG:G7.Q1",
                                    "RMG:G7.Q2",
                                    "RMG:G7.Q3-I",
                                    "RMG:G7.Q3-T",
                                    "RMG:G7.Q3-F",
                                    "RMG:G7.Q4-I",
                                    "RMG:G7.Q4-T",
                                    "RMG:G7.Q4-F"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{
                                    "RMG:G7.Q1",
                                    "RMG:G7.Q2",
                                    "RMG:G7.Q3-I",
                                    "RMG:G7.Q3-T",
                                    "RMG:G7.Q3-F",
                                    "RMG:G7.Q4-I",
                                    "RMG:G7.Q4-T",
                                    "RMG:G7.Q4-F"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.AC-4",
                                Question_Text = "Access permissions and authorizations are managed, incorporating the principles of least privilege and separation of duties",
                                EDMReferences = new List<string>{
                                    "RMG:G7.Q3-I",
                                    "RMG:G7.Q3-T",
                                    "RMG:G7.Q3-F"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{
                                    "RMG:G7.Q3-I",
                                    "RMG:G7.Q3-T",
                                    "RMG:G7.Q3-F"},answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.AC-5",
                                Question_Text = "Network integrity is protected (e.g., network segregation, network segmentation)",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.AC-6",
                                Question_Text = "Identities are proofed and bound to credentials and asserted in interactions",
                                EDMReferences = new List<string>{"RMG:G7.Q1"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RMG:G7.Q1"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.AC-7",
                                Question_Text = "Users, devices, and other assets are authenticated (e.g., singlefactor, multi-factor) commensurate with the risk of the transaction (e.g., individuals’ security and privacy risks and other organizational risks)",
                                EDMReferences = new List<string>{"RMG:G7.Q1"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RMG:G7.Q1"}, answers)
                            }
                        }
                    },
                    new Category {
                        Name = "Awareness and Training",
                        Acronym = "AT",
                        Description = "The organization’s personnel and partners are provided cybersecurity awareness education and are trained to perform their cybersecurity-related duties and responsibilities consistent with related policies, procedures, and agreements.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "PR.AT-1",
                                Question_Text = "All users are informed and trained",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.AT-2",
                                Question_Text = "Privileged users understand their roles and responsibilities",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.AT-3",
                                Question_Text = "Third-party stakeholders (e.g., suppliers, customers, partners) understand their roles and responsibilities",
                                EDMReferences = new List<string>{"RF:G5.Q1"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RF:G5.Q1"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.AT-4",
                                Question_Text = "Senior executives understand their roles and responsibilities",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.AT-5",
                                Question_Text = "Physical and cybersecurity personnel understand their roles and responsibilities",
                                EDMReferences = new List<string>{"SPS:G3.Q1"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"SPS:G3.Q1"}, answers)
                            }
                        }
                    },
                    new Category {
                        Name = "Data Security",
                        Acronym = "DS",
                        Description = "Information and records (data) are managed consistent with the organization’s risk strategy to protect the confidentiality, integrity, and availability of information.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "PR.DS-1",
                                Question_Text = "Data-at-rest is protected",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.DS-2",
                                Question_Text = "Data-in-transit is protected",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.DS-3",
                                Question_Text = "Assets are formally managed throughout removal, transfers, and disposition",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.DS-4",
                                Question_Text = "Adequate capacity to ensure availability is maintained",
                                EDMReferences = new List<string>{"RMG:G4.Q5"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RMG:G4.Q5"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.DS-5",
                                Question_Text = "Protections against data leaks are implemented",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.DS-6",
                                Question_Text = "Integrity checking mechanisms are used to verify software, firmware, and information integrity",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.DS-7",
                                Question_Text = "The development and testing environment(s) are separate from the production environment",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.DS-8",
                                Question_Text = "Integrity checking mechanisms are used to verify hardware integrity",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            }
                        }
                    },
                    new Category {
                        Name = "Information Protection Processes and Procedures",
                        Acronym = "IP",
                        Description = "Security policies (that address purpose, scope, roles, responsibilities, management commitment, and coordination among organizational entities), processes, and procedures are maintained and used to manage protection of information systems and assets.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "PR.IP-1",
                                Question_Text = "A baseline configuration of information technology/industrial control systems is created and maintained incorporating security principles (e.g. concept of least functionality) ",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.IP-2",
                                Question_Text = "A System Development Life Cycle to manage systems is implemented",
                                EDMReferences = new List<string>{ "RF:G6.Q5", "RMG:G5.Q1"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{ "RF:G6.Q5", "RMG:G5.Q1"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.IP-3",
                                Question_Text = "Configuration change control processes are in place",
                                EDMReferences = new List<string>{
                                    "RMG:G4.Q1-I",
                                    "RMG:G4.Q1-T",
                                    "RMG:G4.Q1-F",
                                    "RMG:G4.Q1-P",
                                    "RMG:G4.Q2-I",
                                    "RMG:G4.Q2-T",
                                    "RMG:G4.Q2-F",
                                    "RMG:G4.Q2-P"
                                },
                                AnsweredEDM = GetEDMAnswers(new List<string>{
                                    "RMG:G4.Q1-I",
                                    "RMG:G4.Q1-T",
                                    "RMG:G4.Q1-F",
                                    "RMG:G4.Q1-P",
                                    "RMG:G4.Q2-I",
                                    "RMG:G4.Q2-T",
                                    "RMG:G4.Q2-F",
                                    "RMG:G4.Q2-P"
                                }, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.IP-4",
                                Question_Text = "Backups of information are conducted, maintained, and tested",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.IP-5",
                                Question_Text = "Policy and regulations regarding the physical operating environment for organizational assets are met",
                                EDMReferences = new List<string>{"RF:G2.Q2","RMG:G3.Q1"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RF:G2.Q2","RMG:G3.Q1"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.IP-6",
                                Question_Text = "Data is destroyed according to policy",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.IP-7",
                                Question_Text = "Protection processes are improved",
                                EDMReferences = new List<string>{ "RMG:G5.Q3"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{ "RMG:G5.Q3"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.IP-8",
                                Question_Text = "Effectiveness of protection technologies is shared",
                                EDMReferences = new List<string>{
                                    "RMG:G5.Q3",
                                    "SPS:G3.Q3-S",
                                    "SPS:G3.Q3-IP",
                                    "SPS:G3.Q4",
                                    "SPS:G3.Q6"
                                },
                                AnsweredEDM = GetEDMAnswers(new List<string>{
                                    "RMG:G5.Q3",
                                    "SPS:G3.Q3-S",
                                    "SPS:G3.Q3-IP",
                                    "SPS:G3.Q4",
                                    "SPS:G3.Q6"
                                }, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.IP-9",
                                Question_Text = "Response plans (Incident Response and Business Continuity) and recovery plans (Incident Recovery and Disaster Recovery) are in place and managed",
                                EDMReferences = new List<string>{
                                    "SPS:G1.Q1",
                                    "SPS:G1.Q3",
                                    "SPS:G1.Q4-IM",
                                    "SPS:G1.Q4-SC",
                                    "SPS:G1.Q5-IM",
                                    "SPS:G1.Q5-SC"
                                },
                                AnsweredEDM = GetEDMAnswers(new List<string>{
                                    "SPS:G1.Q1",
                                    "SPS:G1.Q3",
                                    "SPS:G1.Q4-IM",
                                    "SPS:G1.Q4-SC",
                                    "SPS:G1.Q5-IM",
                                    "SPS:G1.Q5-SC"
                                }, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.IP-10",
                                Question_Text = "Response and recovery plans are tested",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.IP-11",
                                Question_Text = "Cybersecurity is included in human resources practices (e.g., deprovisioning, personnel screening)",
                                EDMReferences = new List<string>{"RMG:G7.Q2"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RMG:G7.Q2"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.IP-12",
                                Question_Text = "A vulnerability management plan is developed and implemented",
                                EDMReferences = new List<string>{"RMG:G2.Q4"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RMG:G2.Q4"}, answers)
                            }
                        }

                    },
                    new Category {
                        Name = "Maintenance",
                        Acronym = "MA",
                        Description = "Maintenance and repairs of industrial control and information system components are performed consistent with policies and procedures.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "PR.MA-1",
                                Question_Text = "Maintenance and repair of organizational assets are performed and logged, with approved and controlled tools",
                                EDMReferences = new List<string>{
                                    "RMG:G4.Q2-I",
                                    "RMG:G4.Q2-T",
                                    "RMG:G4.Q2-F",
                                    "RMG:G4.Q2-P"
                                },
                                AnsweredEDM = GetEDMAnswers(new List<string>{
                                    "RMG:G4.Q2-I",
                                    "RMG:G4.Q2-T",
                                    "RMG:G4.Q2-F",
                                    "RMG:G4.Q2-P"
                                }, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.MA-2",
                                Question_Text = "Remote maintenance of organizational assets is approved, logged, and performed in a manner that prevents unauthorized access",
                                EDMReferences = new List<string>{
                                    "RMG:G4.Q2-I",
                                    "RMG:G4.Q2-T",
                                    "RMG:G4.Q2-F",
                                    "RMG:G4.Q2-P",
                                    "RMG:G7.Q1",
                                    "RMG:G7.Q4-I",
                                    "RMG:G7.Q4-T",
                                    "RMG:G7.Q4-F"

                                },
                                AnsweredEDM = GetEDMAnswers(new List<string>{
                                    "RMG:G4.Q2-I",
                                    "RMG:G4.Q2-T",
                                    "RMG:G4.Q2-F",
                                    "RMG:G4.Q2-P",
                                    "RMG:G7.Q1",
                                    "RMG:G7.Q4-I",
                                    "RMG:G7.Q4-T",
                                    "RMG:G7.Q4-F"
                                }, answers)
                            }
                        }
                    },
                    new Category {
                        Name = "Protective Technology",
                        Acronym = "PT",
                        Description = "Technical security solutions are managed to ensure the security and resilience of systems and assets, consistent with related policies, procedures, and agreements.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "PR.PT-1",
                                Question_Text = "Audit/log records ar determined, documented, implemented, and reviewed in accordance with policy",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.PT-2",
                                Question_Text = "Removable media is protected and its use restricted according to policy",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.PT-3",
                                Question_Text = "The principle of least functionality is incorporated by configuring systems to provide only essential capabilities",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.PT-4",
                                Question_Text = "Communications and control networks are protected",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.PT-5",
                                Question_Text = "Mechanisms (e.g., failsafe, load balancing, hot swap) are implemented to achieve resilience requirements in normal and adverse situations",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                        }
                    },
                }
            };

            var fucntionDetect = new RelevantEDMAnswersAppendix
            {
                FunctionName = "Detect",
                Acronym = "DE",
                Summary = "The Detect Function enables timely discovery of cybersecurity events.",
                Categories = new List<Category> {
                    new Category {
                        Name = "Anomalies and Events",
                        Acronym = "AE",
                        Description = "Anomalous activity is detected and the potential impact of events is understood.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "DE.AE-1",
                                Question_Text = "A baseline of network operations and expected data flows for users and systems is established and managed",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.AE-2",
                                Question_Text = "Detected events are analyzed to understand attack targets and methods",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.AE-3",
                                Question_Text = "Event data are collected and correlated from multiple sources and sensors",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.AE-4",
                                Question_Text = "Impact of events is determined",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.AE-5",
                                Question_Text = "Incident alert thresholds are established",
                                EDMReferences = new List<string>{"SPS:G1.Q2"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"SPS:G1.Q2"}, answers)
                            }

                        }

                    },
                    new Category {
                        Name = "Security Continuous Monitoring",
                        Acronym = "CM",
                        Description = "The information system and assets are monitored to identify cybersecurity events and verify the effectiveness of protective measures.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "DE.CM-1",
                                Question_Text = "The network is monitored to detect potential cybersecurity events",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.CM-2",
                                Question_Text = "The physical environment is monitored to detect potential cybersecurity events",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.CM-3",
                                Question_Text = "Personnel activity is monitored to detect potential cybersecurity events",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.CM-4",
                                Question_Text = "Malicious code is detected",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.CM-5",
                                Question_Text = "Unauthorized mobile code is detected",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.CM-6",
                                Question_Text = "External service provider activity is monitored to detect potential cybersecurity events",
                                EDMReferences = new List<string>{"RMG:G3.Q1", "RMG:G4.Q4"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RMG:G3.Q1", "RMG:G4.Q4"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.CM-7",
                                Question_Text = "Monitoring for unauthorized personnel, connections, devices, and software is performed",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.CM-8",
                                Question_Text = "Vulnerability scans are performed",
                                EDMReferences = new List<string>{"RMG:G2.Q4"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RMG:G2.Q4"}, answers)
                            },
                        }
                    },
                    new Category {
                        Name = "Detection Processes",
                        Acronym = "DP",
                        Description = "Detection processes and procedures are maintained and tested to ensure awareness of anomalous event",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "DE.DP-1",
                                Question_Text = "Roles and responsibilities for detection are well defined to ensure accountability",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.DP-2",
                                Question_Text = "Detection activities comply with all applicable requirements",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.DP-3",
                                Question_Text = "Detection processes are tested",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.DP-4",
                                Question_Text = "Event detection information is communicated",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.DP-5",
                                Question_Text = "Detection processes are continuously improved",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                        }
                    }
                }
            };

            var fucntionRespond = new RelevantEDMAnswersAppendix
            {
                FunctionName = "Respond",
                Acronym = "RS",
                Summary = "The Respond function supports the ability to contain the impact of a potential cybersecurity event.",
                Categories = new List<Category> {
                    new Category {
                        Name = "Response Planning",
                        Acronym = "RP",
                        Description = "Response processes and procedures are executed and maintained, to ensure response to detected cybersecurity incidents.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "RS.RP-1",
                                Question_Text = "Response plan is executed during or after an incident",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            }
                        }
                    },
                    new Category {
                        Name = "Communications",
                        Acronym = "CO",
                        Description = "Response activities are coordinated with internal and external stakeholders (e.g.external support from law enforcement agencies)",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "RS.CO-1",
                                Question_Text = "Personnel know their roles and order of operations when a response is needed",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "RS.CO-2",
                                Question_Text = "Incidents are reported consistent with established criteria",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "RS.CO-3",
                                Question_Text = "Information is shared consistent with response plans",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "RS.CO-4",
                                Question_Text = "Coordination with stakeholders occurs consistent with response plans",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "RS.CO-5",
                                Question_Text = "Voluntary information sharing occurs with external stakeholders to achieve broader cybersecurity situational awareness.",
                                EDMReferences = new List<string>{ "SPS:G3.Q3-S", "SPS:G3.Q3-IP", "SPS:G3.Q4", "SPS:G3.Q5", "SPS:G3.Q6"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"SPS:G3.Q3-S", "SPS:G3.Q3-IP", "SPS:G3.Q4", "SPS:G3.Q5", "SPS:G3.Q6"}, answers)
                            }
                        }
                    },
                    new Category {
                        Name = "Analysis",
                        Acronym = "AN",
                        Description = "Analysis is conducted to ensure effective response and support recovery activities.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "RS.AN-1",
                                Question_Text = "Notifications from detection systems are investigated",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory {
                                Question_Title = "RS.AN-2",
                                Question_Text = "The impact of the incident is understood",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory {
                                Question_Title = "RS.AN-3",
                                Question_Text = "Forensics are performed",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory {
                                Question_Title = "RS.AN-4",
                                Question_Text = "Incidents are categorized consistent with response plans",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory {
                                Question_Title = "RS.AN-5",
                                Question_Text = "Processes are established to receive, analyze and respond to vulnerabilities disclosed to the organization from internal and external sources (e.g. internal testing, security bulletins, or security researchers)",
                                EDMReferences = new List<string>{ "RMG:G2.Q4"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RMG:G2.Q4"}, answers)
                            }
                        }
                    },
                    new Category {
                        Name = "Mitigation",
                        Acronym = "MI",
                        Description = "Activities are performed to prevent expansion of an event, mitigate its effects, and resolve the incident.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory {
                                Question_Title = "RS.MI-1",
                                Question_Text = "Incidents are contained",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory {
                                Question_Title = "RS.MI-2",
                                Question_Text = "Incidents are mitigated",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory {
                                Question_Title = "RS.MI-3",
                                Question_Text = "Newly identified vulnerabilities are mitigated or documented as accepted risks",
                                EDMReferences = new List<string>{ "RMG:G2.Q4"},
                                AnsweredEDM = GetEDMAnswers(new List<string>{"RMG:G2.Q4"}, answers)
                            }
                        }
                    },
                    new Category {
                        Name = "Improvements",
                        Acronym = "IM",
                        Description = "Organizational response activities are improved by incorporating lessons learned from current and previous detection/response activities.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory {
                                Question_Title = "RS.IM-1",
                                Question_Text = "Response plans incorporate lessons learned",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory {
                                Question_Title = "RS.IM-2",
                                Question_Text = "Response strategies are updated",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            }
                        }
                    },
                }
            };
            //Recover Planning
            var fucntionRecover = new RelevantEDMAnswersAppendix
            {
                FunctionName = "Recover",
                Acronym = "RC",
                Summary = "The Recover Function supports timely recovery to normal operations to reduce the impact from a cybersecurity event.",
                Categories = new List<Category> {
                    new Category {
                        Name = "Recovery Planning",
                        Acronym = "RP",
                        Description = "Recovery processes and procedures are executed and maintained to ensure restoration of systems or assets affected by cybersecurity incidents.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "RC.RP-1",
                                Question_Text = "Recovery plan is executed during or after a cybersecurity incident",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            }
                        }
                    },
                    new Category {
                        Name = "Improvements",
                        Acronym = "IM",
                        Description = "Recovery planning and processes are improved by incorporating lessons learned into future activities.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "RC.IM-1",
                                Question_Text = "Recovery plans incorporate lessons learned",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "RC.IM-2",
                                Question_Text = "Recovery strategies are updated",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            }
                        }
                    },
                    new Category {
                        Name = "Communications",
                        Acronym = "CO",
                        Description = "Restoration activities are coordinated with internal and external parties (e.g.coordinating centers, Internet Service Providers, owners of attacking systems, victims, other CSIRTs, and vendors).",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "RC.CO-1",
                                Question_Text = "Public relations are managed",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "RC.CO-2",
                                Question_Text = "Reputation is repaired after an incident",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "RC.CO-3",
                                Question_Text = "Recovery activities are communicated to internal and external stakeholders as well as executive and management teams",
                                EDMReferences = new List<string>(),
                                AnsweredEDM = new List<RelevantEDMAnswerResult>()
                            }
                        }
                    }
                }
            };

            builtdata.Add(fucntionIdentify);
            builtdata.Add(fucntionProtect);
            builtdata.Add(fucntionDetect);
            builtdata.Add(fucntionRespond);
            builtdata.Add(fucntionRecover);

            return builtdata;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="answers"></param>
        public void GetFrameworkTotals(ref List<RelevantEDMAnswersAppendix> answers)
        {
            var functionTotal = new EDMAnswerTotal();
            var catTotal = new EDMAnswerTotal();
            var subCatTotal = new EDMAnswerTotal();

            foreach (RelevantEDMAnswersAppendix function in answers)
            {
                functionTotal = new EDMAnswerTotal();
                foreach (Category cat in function.Categories)
                {
                    catTotal = new EDMAnswerTotal();
                    foreach (SubCategory subcat in cat.SubCategories)
                    {
                        subCatTotal = new EDMAnswerTotal();
                        foreach (RelevantEDMAnswerResult ans in subcat.AnsweredEDM)
                        {
                            functionTotal.AddToTotal(ans);
                            catTotal.AddToTotal(ans);
                            subCatTotal.AddToTotal(ans);
                        }

                        subcat.Totals = subCatTotal;
                    }

                    // include any category-level mapped answers (only ID.BE has these)
                    if (cat.AnsweredEDM != null)
                    {
                        foreach (RelevantEDMAnswerResult ans in cat.AnsweredEDM)
                        {
                            functionTotal.AddToTotal(ans);
                            catTotal.AddToTotal(ans);
                        }
                    }

                    cat.Totals = catTotal;
                }

                function.Totals = functionTotal;
            }
        }


        /// <summary>
        /// Locates the answers corresponding to the specified list of question titles.
        /// </summary>
        /// <param name="EDMReferences"></param>
        /// <param name="answers"></param>
        /// <returns></returns>
        public List<RelevantEDMAnswerResult> GetEDMAnswers(List<string> EDMReferences, List<RelevantEDMAnswerResult> answers)
        {
            var filtered = answers.Where(x => EDMReferences.Any(y => y == x.QuestionTitle)).ToList();


            // debug diagnostic code ...
            if (filtered.Count != EDMReferences.Count)
            {
                StringBuilder sbFiltered = new StringBuilder();
                StringBuilder sbRefs = new StringBuilder();

                filtered.ForEach(x =>
                {
                    sbFiltered.AppendLine(x.QuestionTitle);
                });

                EDMReferences.ForEach(x =>
                {
                    sbRefs.AppendLine(x);
                });
            }

            return filtered;
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public static class EDMExtensions
    {
        /// <summary>
        /// Increments the answer total.  Unanswered questions are
        /// totaled as "N".
        /// </summary>
        /// <param name="totals"></param>
        /// <param name="result"></param>
        public static void AddToTotal(this EDMAnswerTotal totals, RelevantEDMAnswerResult result)
        {
            if (result != null)
            {
                switch (result.AnswerText)
                {
                    case "Y":
                        totals.Y += 1;
                        break;
                    case "I":
                        totals.I += 1;
                        break;
                    case "N":
                    case "U":
                        totals.N += 1;
                        break;
                }
            }
        }
    }
}
