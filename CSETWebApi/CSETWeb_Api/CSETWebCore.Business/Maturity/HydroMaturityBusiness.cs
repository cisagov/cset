using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Hydro;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Maturity
{
    public class HydroMaturityBusiness : MaturityBusiness
    {
        private CSETContext _context;
        public HydroMaturityBusiness(CSETContext context, IAssessmentUtil assessmentUtil, IAdminTabBusiness adminTabBusiness) : base(context, assessmentUtil, adminTabBusiness)
        {
            this._context = context;
        }

        public List<HydroDonutData> GetHydroDonutData(int assessmentId)
        {
            var result = from question in _context.MATURITY_QUESTIONS
                         join action in _context.HYDRO_DATA on question.Mat_Question_Id equals action.Mat_Question_Id
                         join answer in _context.ANSWER on question.Mat_Question_Id equals answer.Question_Or_Requirement_Id
                         join answerOption in _context.MATURITY_ANSWER_OPTIONS on answer.Mat_Option_Id equals answerOption.Mat_Option_Id
                         where question.Maturity_Model_Id == 13 && answer.Answer_Text == "S" && answerOption.Mat_Option_Id == action.Mat_Option_Id && answer.Assessment_Id == assessmentId
                         select new { question, action, answerOption };

            List<HydroDonutData> response = new List<HydroDonutData>();

            foreach (var item in result.Distinct().ToList())
            {
                HydroDonutData data = new HydroDonutData()
                {
                    Actions = item.action,
                    //Answer = item.answer,
                    AnswerOption = item.answerOption,
                    Question = item.question
                };

                response.Add(data);
            }

            return response;
        }

        public List<HydroActionsByDomain> GetHydroActions(int assessmentId)
        {

            var result = from subGrouping in _context.MATURITY_GROUPINGS
                         join domain in _context.MATURITY_GROUPINGS on subGrouping.Parent_Id equals domain.Grouping_Id
                         join question in _context.MATURITY_QUESTIONS on subGrouping.Grouping_Id equals question.Grouping_Id
                         join action in _context.HYDRO_DATA on question.Mat_Question_Id equals action.Mat_Question_Id
                         join answer in _context.ANSWER on action.Mat_Option_Id equals answer.Mat_Option_Id
                         where question.Maturity_Model_Id == 13 && answer.Answer_Text == "S"
                              && answer.Mat_Option_Id == action.Mat_Option_Id
                              && answer.Assessment_Id == assessmentId
                              && action.Sequence != null
                         select new { subGrouping, domain, question, action, answer };

            List<HydroActionsByDomain> actionsByDomains = new List<HydroActionsByDomain>();
            List<HydroActionQuestion> actionQuestions = new List<HydroActionQuestion>();

            if (!result.Any())
            {
                return actionsByDomains;
            }

            var currDomain = result.ToList().FirstOrDefault().domain;

            foreach (var item in result.Distinct().ToList())
            {
                if (item.domain != currDomain)
                {
                    HydroActionsByDomain domainData = new HydroActionsByDomain()
                    {
                        DomainName = currDomain.Title,
                        DomainSequence = currDomain.Sequence,
                        ActionsQuestions = actionQuestions
                    };

                    actionsByDomains.Add(domainData);
                    currDomain = item.domain;
                    actionQuestions = new List<HydroActionQuestion>();
                }


                if (_context.HYDRO_DATA_ACTIONS.Find(item.answer.Answer_Id) == null)
                {
                    _context.HYDRO_DATA_ACTIONS.Add(
                        new HYDRO_DATA_ACTIONS()
                        {
                            Answer = item.answer,
                            Answer_Id = item.answer.Answer_Id,
                            Progress_Id = 1,
                            Comment = ""
                        }
                    );
                    _context.SaveChanges();
                }

                HYDRO_DATA_ACTIONS actionData = _context.HYDRO_DATA_ACTIONS.Where(x => x.Answer_Id == item.answer.Answer_Id).FirstOrDefault();

                actionQuestions.Add(
                    new HydroActionQuestion()
                    {
                        Action = item.action,
                        Question = item.question,
                        ActionData = actionData
                    }
                );
            }



            actionsByDomains.Add(
                new HydroActionsByDomain()
                {
                    DomainName = currDomain.Title,
                    DomainSequence = currDomain.Sequence,
                    ActionsQuestions = actionQuestions
                }
            );

            return actionsByDomains;
        }

        public List<HydroActionQuestion> GetHydroActionsReport(int assessmentId)
        {

            var result = from subGrouping in _context.MATURITY_GROUPINGS
                         join domain in _context.MATURITY_GROUPINGS on subGrouping.Parent_Id equals domain.Grouping_Id
                         join question in _context.MATURITY_QUESTIONS on subGrouping.Grouping_Id equals question.Grouping_Id
                         join action in _context.HYDRO_DATA on question.Mat_Question_Id equals action.Mat_Question_Id
                         join answer in _context.ANSWER on action.Mat_Option_Id equals answer.Mat_Option_Id
                         where question.Maturity_Model_Id == 13 && answer.Answer_Text == "S"
                              && answer.Mat_Option_Id == action.Mat_Option_Id
                              && answer.Assessment_Id == assessmentId
                              && action.Sequence != null
                         select new { subGrouping, domain, question, action, answer };

            List<HydroActionQuestion> actionQuestions = new List<HydroActionQuestion>();

            if (!result.Any())
            {
                return actionQuestions;
            }

            var currDomain = result.ToList().FirstOrDefault()?.domain;

            foreach (var item in result.Distinct().ToList())
            {
                if (_context.HYDRO_DATA_ACTIONS.Find(item.answer.Answer_Id) == null)
                {
                    _context.HYDRO_DATA_ACTIONS.Add(
                        new HYDRO_DATA_ACTIONS()
                        {
                            Answer_Id = item.answer.Answer_Id,
                            Progress_Id = 1,
                            Comment = ""
                        }
                    );
                    _context.SaveChanges();
                }

                HYDRO_DATA_ACTIONS actionData = _context.HYDRO_DATA_ACTIONS.Where(x => x.Answer_Id == item.answer.Answer_Id).FirstOrDefault();

                actionQuestions.Add(
                    new HydroActionQuestion()
                    {
                        Action = item.action,
                        Question = item.question,
                        ActionData = actionData
                    }
                );
            };

            return actionQuestions;
        }

        public List<HydroResults> GetResultsData(int assessmentId)
        {
            var response = from answer in _context.ANSWER
                           join data in _context.HYDRO_DATA on answer.Mat_Option_Id equals data.Mat_Option_Id
                           join question in _context.MATURITY_QUESTIONS
                                 on answer.Question_Or_Requirement_Id equals question.Mat_Question_Id
                           join grouping in _context.MATURITY_GROUPINGS
                                 on question.Grouping_Id equals grouping.Grouping_Id
                           join parentGrouping in _context.MATURITY_GROUPINGS
                                 on grouping.Parent_Id equals parentGrouping.Grouping_Id
                           where answer.Assessment_Id == assessmentId && answer.Answer_Text == "S"
                           select new { answer, data, question, grouping, parentGrouping };

            List<HydroResults> resultsList = new List<HydroResults>();
            List<HYDRO_DATA> groupItems = new List<HYDRO_DATA>();
            int currParentSequence = 0;
            int currParentId = 0;
            int currQuestionId = 0;
            bool notFirst = false;
            bool impactLimitNotReached = true;
            bool feasibilityLimitNotReached = true;

            HydroImpacts impactTotals = new HydroImpacts();
            HydroFeasibilities feasibilityTotals = new HydroFeasibilities();

            foreach (var item in response)
            {
                if (currParentId != item.parentGrouping.Grouping_Id && notFirst)
                {
                    HydroResults results = new HydroResults()
                    {
                        HydroData = groupItems,
                        impactTotals = impactTotals,
                        feasibilityTotals = feasibilityTotals,
                        parentGroupId = currParentId,
                        parentSequence = currParentSequence
                    };
                    resultsList.Add(results);

                    groupItems = new List<HYDRO_DATA>(); // clear the groupItems list
                    impactTotals = new HydroImpacts();
                    feasibilityTotals = new HydroFeasibilities();
                }

                if (currQuestionId != item.question.Mat_Question_Id)
                {
                    impactLimitNotReached = true;
                    feasibilityLimitNotReached = true;
                }

                var impactStrings = item.data.Impact.Split(',');

                if (impactLimitNotReached && (impactStrings.Length != 1 || !string.IsNullOrEmpty(impactStrings[0])))
                {
                    foreach (string impact in impactStrings) // start here, incorperate the impactLimits per question (checkboxes don't count mulitple times for one question))
                    {
                        if (impact.Equals("1"))
                        {
                            impactTotals.Economic++;
                            impactLimitNotReached = false;
                        }
                        else if (impact.Equals("2"))
                        {
                            impactTotals.Environmental++;
                            impactLimitNotReached = false;
                        }
                        else if (impact.Equals("3"))
                        {
                            impactTotals.Operational++;
                            impactLimitNotReached = false;
                        }
                        else if (impact.Equals("4"))
                        {
                            impactTotals.Safety++;
                            impactLimitNotReached = false;
                        }
                    }
                }

                var feasibilityStrings = item.data.Feasibility.Split(',');

                if (feasibilityLimitNotReached && (feasibilityStrings.Length != 1 || !string.IsNullOrEmpty(feasibilityStrings[0])))
                {
                    foreach (string feas in feasibilityStrings) // start here, incorperate the impactLimits per question (checkboxes don't count mulitple times for one question))
                    {
                        if (feas.Equals("1"))
                        {
                            feasibilityTotals.Easy++;
                            feasibilityLimitNotReached = false;
                        }
                        else if (feas.Equals("2"))
                        {
                            feasibilityTotals.Medium++;
                            feasibilityLimitNotReached = false;
                        }
                        else if (feas.Equals("3"))
                        {
                            feasibilityTotals.Hard++;
                            feasibilityLimitNotReached = false;
                        }
                    }
                }

                currParentId = item.parentGrouping.Grouping_Id; // update the current ID and name
                currParentSequence = item.parentGrouping.Sequence;
                currQuestionId = item.question.Mat_Question_Id;

                groupItems.Add(item.data);
                notFirst = true;
            }

            HydroResults lastResults = new HydroResults()
            {
                HydroData = groupItems,
                impactTotals = impactTotals,
                feasibilityTotals = feasibilityTotals,
                parentGroupId = currParentId,
                parentSequence = currParentSequence
            };
            resultsList.Add(lastResults);

            return resultsList;
        }

        public List<HYDRO_PROGRESS> GetHydroProgress()
        {
            return _context.HYDRO_PROGRESS.ToList();
        }
    }
}
