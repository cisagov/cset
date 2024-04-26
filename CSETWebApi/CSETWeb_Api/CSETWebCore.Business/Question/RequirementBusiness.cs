//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Api.Models;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Model.Question;
using Nelibur.ObjectMapper;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace CSETWebCore.Business.Question
{
    public class RequirementBusiness : IRequirementBusiness
    {
        List<NEW_REQUIREMENT> Requirements;
        List<FullAnswer> Answers;


        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IQuestionRequirementManager _questionRequirement;
        private readonly ITokenManager _tokenManager;
        private CSETContext _context;


        /// <summary>
        /// Constructor.
        /// </summary>
        public RequirementBusiness(IAssessmentUtil assessmentUtil,
            IQuestionRequirementManager questionRequirement, CSETContext context, ITokenManager tokenManager)
        {
            _assessmentUtil = assessmentUtil;
            _questionRequirement = questionRequirement;
            _tokenManager = tokenManager;
            _context = context;
        }

        public void SetRequirementAssessmentId(int assessmentId)
        {
            _questionRequirement.InitializeManager(assessmentId);
        }


        /// <summary>
        /// Builds a response containing Requirements that are related to the
        /// assessment's SAL level.
        /// </summary>
        public QuestionResponse GetRequirementsList()
        {
            RequirementsPass controls = GetControls();
            return BuildResponse(controls.Requirements.ToList(), controls.Answers.ToList(), controls.DomainAssessmentFactors.ToList());
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="db"></param>
        /// <returns></returns>
        public RequirementsPass GetControls()
        {
            SetRequirementAssessmentId(_tokenManager.AssessmentForUser());

            var q = from rs in _context.REQUIREMENT_SETS
                    from s in _context.SETS.Where(x => x.Set_Name == rs.Set_Name)
                    from r in _context.NEW_REQUIREMENT.Where(x => x.Requirement_Id == rs.Requirement_Id)
                    from rl in _context.REQUIREMENT_LEVELS.Where(x => x.Requirement_Id == r.Requirement_Id)
                    where _questionRequirement.SetNames.Contains(rs.Set_Name)
                          && rl.Standard_Level == _questionRequirement.StandardLevel
                    select new { r, rs, s };
            var results = q.Distinct()
                .OrderBy(x => x.s.Short_Name)
                .ThenBy(x => x.rs.Requirement_Sequence)
                .Select(x => new RequirementPlus { Requirement = x.r, SetShortName = x.s.Short_Name, SetName = x.s.Set_Name });

            var domains = new List<DomainAssessmentFactor>();
            if (results.Any(r => r.SetName == "ACET_V1"))
            {
                domains = (from d in _context.FINANCIAL_DOMAINS
                           join fg in _context.FINANCIAL_GROUPS on d.DomainId equals fg.DomainId
                           join af in _context.FINANCIAL_ASSESSMENT_FACTORS on fg.AssessmentFactorId equals af.AssessmentFactorId
                           select new DomainAssessmentFactor { DomainName = d.Domain, AssessmentFactorName = af.AssessmentFactor }).Distinct().ToList();
            }


            // Get all REQUIREMENT answers for the assessment
            var answers = from a in _context.ANSWER.Where(x => x.Assessment_Id == _questionRequirement.AssessmentId && x.Question_Type == "Requirement")
                          from b in _context.VIEW_QUESTIONS_STATUS.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                          select new FullAnswer() { a = a, b = b };

            this.Requirements = q.Select(x => x.r).ToList();
            this.Answers = answers.ToList();

            return new RequirementsPass()
            {
                Requirements = results,
                Answers = answers,
                DomainAssessmentFactors = domains
            };
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="requirements"></param>
        /// <param name="answers"></param>
        /// <param name="domains"></param>
        /// <returns></returns>
        public QuestionResponse BuildResponse(List<RequirementPlus> requirements,
            List<FullAnswer> answers, List<DomainAssessmentFactor> domains)
        {
            // get the user's language
            var lang = _tokenManager.GetCurrentLanguage();

            var overlay = new TranslationOverlay();


            var response = new QuestionResponse();

            foreach (var req in requirements.OrderBy(x => x.SetShortName).ToList())
            {
                var dbR = req.Requirement;

                // Make sure there are no leading or trailing spaces - it will affect the tree structure that is built
                if (dbR.Standard_Category != null)
                {
                    dbR.Standard_Category = dbR.Standard_Category.Trim();
                }
                if (dbR.Standard_Sub_Category != null)
                {
                    dbR.Standard_Sub_Category = dbR.Standard_Sub_Category.Trim();
                }

                // If the Standard_Sub_Category is null (like CSC_V6), default it to the Standard_Category
                if (dbR.Standard_Sub_Category == null)
                {
                    dbR.Standard_Sub_Category = dbR.Standard_Category;
                }


                // translate the Category
                var translatedCategory = overlay.GetPropertyValue("STANDARD_CATEGORY", dbR.Standard_Category.ToLower(), lang);
                if (translatedCategory != null)
                {
                    dbR.Standard_Category = translatedCategory;
                }


                // find or create the category
                var category = response.Categories.Where(cat => cat.SetName == req.SetName && cat.GroupHeadingText == dbR.Standard_Category).FirstOrDefault();
                if (category == null)
                {
                    category = new QuestionGroup()
                    {
                        GroupHeadingText = dbR.Standard_Category,
                        SetName = req.SetName,
                        StandardShortName = req.SetShortName
                    };

                    response.Categories.Add(category);
                }


                // translate the Subcategory using the CATEGORIES translation object
                var translatedSubcategory = overlay.GetPropertyValue("STANDARD_CATEGORY", dbR.Standard_Sub_Category.ToLower(), lang);
                if (translatedSubcategory != null)
                {
                    dbR.Standard_Sub_Category = translatedSubcategory;
                }


                // find or create subcategory
                var subcat = category.SubCategories.Where(sub => sub.SubCategoryHeadingText == dbR.Standard_Sub_Category).FirstOrDefault();
                if (subcat == null)
                {
                    subcat = new QuestionSubCategory()
                    {
                        SubCategoryId = null,
                        SubCategoryHeadingText = dbR.Standard_Sub_Category
                    };

                    category.SubCategories.Add(subcat);
                }


                // add the question+answer into the subcategory
                FullAnswer answer = answers.Where(x => x.a.Question_Or_Requirement_Id == dbR.Requirement_Id).FirstOrDefault();

                var qa = new QuestionAnswer()
                {
                    DisplayNumber = dbR.Requirement_Title,
                    QuestionId = dbR.Requirement_Id,
                    QuestionText = dbR.Requirement_Text.Replace("\r\n", "<br/>").Replace("\n", "<br/>").Replace("\r", "<br/>"),
                    Answer = answer?.a.Answer_Text,
                    AltAnswerText = answer?.a.Alternate_Justification,
                    FreeResponseAnswer = answer?.a.Free_Response_Answer,
                    Comment = answer?.a.Comment,
                    Feedback = answer?.a.FeedBack,
                    MarkForReview = answer?.a.Mark_For_Review ?? false,
                    Reviewed = answer?.a.Reviewed ?? false,
                    SetName = req.SetName,
                    ShortName = req.SetShortName,
                    Is_Component = answer?.a.Is_Component ?? false,
                    Is_Requirement = answer?.a.Is_Requirement ?? true,
                    QuestionType = answer?.a.Question_Type
                };


                var reqOverlay = overlay.GetRequirement(dbR.Requirement_Id, lang);
                if (reqOverlay != null)
                {
                    qa.QuestionText = reqOverlay.RequirementText;
                }

                if (string.IsNullOrEmpty(qa.QuestionType))
                {
                    qa.QuestionType = _questionRequirement.DetermineQuestionType(qa.Is_Requirement, qa.Is_Component, false, qa.Is_Maturity);
                }

                if (answer != null)
                {
                    TinyMapper.Bind<VIEW_QUESTIONS_STATUS, QuestionAnswer>();
                    TinyMapper.Map<VIEW_QUESTIONS_STATUS, QuestionAnswer>(answer.b, qa);

                    // db view still uses the term "HasDiscovery" - map to "HasObservation"
                    qa.HasObservation = answer.b.HasDiscovery ?? false;
                }

                qa.ParmSubs = GetTokensForRequirement(qa.QuestionId, (answer != null) ? answer.a.Answer_Id : 0);

                subcat.Questions.Add(qa);
            }

            response.ApplicationMode = _questionRequirement.ApplicationMode;
            response.OnlyMode = _context.STANDARD_SELECTION.First(x => x.Assessment_Id == _questionRequirement.AssessmentId).Only_Mode;

            response.QuestionCount = _questionRequirement.NumberOfQuestions();
            response.RequirementCount = _questionRequirement.NumberOfRequirements();

            return response;
        }


        public CategoryContainer BuildDomainResponse(DomainAssessmentFactor domain)
        {
            var d = new CategoryContainer()
            {
                DisplayText = domain.DomainName,
                AssessmentFactorName = domain.AssessmentFactorName
            };

            return d;
        }


        public QuestionGroup BuildCategoryResponse()
        {
            return new QuestionGroup();
        }


        public QuestionSubCategory BuildSubcategoryResponse()
        {
            return new QuestionSubCategory();
        }


        /// <summary>
        /// Returns a list of answer IDs that are currently 'active' on the
        /// Assessment, given its SAL level and selected Standards.
        /// 
        /// This piggy-backs on GetRequirementsList() so that we don't need to support
        /// multiple copies of the question and answer queries.
        /// </summary>
        /// <returns></returns>
        public List<int> GetActiveAnswerIds()
        {
            QuestionResponse resp = this.GetRequirementsList();

            List<int> relevantAnswerIds = this.Answers.Where(ans =>
                this.Requirements.Select(q => q.Requirement_Id).Contains(ans.a.Question_Or_Requirement_Id))
                .Select(x => x.a.Answer_Id)
                .ToList<int>();

            return relevantAnswerIds;
        }


        /// <summary>
        /// Stores an answer.
        /// </summary>
        /// <param name="answer"></param>
        public int StoreAnswer(Answer answer)
        {
            // Find the Question or Requirement
            var question = _context.NEW_QUESTION.Where(q => q.Question_Id == answer.QuestionId).FirstOrDefault();
            var requirement = _context.NEW_REQUIREMENT.Where(r => r.Requirement_Id == answer.QuestionId).FirstOrDefault();

            if (question == null && requirement == null)
            {
                throw new Exception("Unknown question or requirement ID: " + answer.QuestionId);
            }

            int assessmentId = _tokenManager.AssessmentForUser();


            // in case a null is passed, store 'unanswered'
            if (string.IsNullOrEmpty(answer.AnswerText))
            {
                answer.AnswerText = "U";
            }
            string questionType = "Question";

            ANSWER dbAnswer = null;
            if (answer != null && answer.ComponentGuid != Guid.Empty)
            {
                dbAnswer = _context.ANSWER.Where(x => x.Assessment_Id == assessmentId
                            && x.Question_Or_Requirement_Id == answer.QuestionId
                            && x.Question_Type == answer.QuestionType && x.Component_Guid == answer.ComponentGuid).FirstOrDefault();
            }
            else if (answer != null)
            {
                dbAnswer = _context.ANSWER.Where(x => x.Assessment_Id == assessmentId
                && x.Question_Or_Requirement_Id == answer.QuestionId
                && x.Question_Type == answer.QuestionType).FirstOrDefault();
            }

            if (dbAnswer == null)
            {
                dbAnswer = new ANSWER();
            }

            dbAnswer.Assessment_Id = assessmentId;
            dbAnswer.Question_Or_Requirement_Id = answer.QuestionId;
            dbAnswer.Question_Type = answer.QuestionType ?? questionType;

            int tQuestion_ID = 0;
            if (int.TryParse(answer.QuestionNumber, out tQuestion_ID))
            {
                dbAnswer.Question_Number = tQuestion_ID;
            }
            dbAnswer.Answer_Text = answer.AnswerText;
            dbAnswer.Alternate_Justification = answer.AltAnswerText;
            dbAnswer.Free_Response_Answer = answer.FreeResponseAnswer;
            dbAnswer.Comment = answer.Comment;
            dbAnswer.FeedBack = answer.Feedback;
            dbAnswer.Mark_For_Review = answer.MarkForReview;
            dbAnswer.Reviewed = answer.Reviewed;
            dbAnswer.Component_Guid = answer.ComponentGuid;


            _context.ANSWER.Update(dbAnswer);
            _context.SaveChanges();
            _assessmentUtil.TouchAssessment(assessmentId);

            return dbAnswer.Answer_Id;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="db"></param>
        public void LoadParametersList()
        {
            SetRequirementAssessmentId(_tokenManager.AssessmentForUser());

            parametersDictionary = (from p in _context.PARAMETERS
                                    join r in _context.PARAMETER_REQUIREMENTS on p.Parameter_ID equals r.Parameter_Id
                                    select new { p, r }).AsEnumerable()
                .GroupBy(x => x.r.Requirement_Id)
                .ToDictionary(x => x.Key, x => x.Select(y => y.p).ToList());


            parametersAssessmentList = (from pa in _context.PARAMETER_ASSESSMENT
                                        join p in _context.PARAMETERS on pa.Parameter_ID equals p.Parameter_ID
                                        where pa.Assessment_ID == _questionRequirement.AssessmentId
                                        select new ParameterAssessment() { p = p, pa = pa }).ToList();

            parametersAnswerDictionary = (from p in _context.PARAMETERS
                                          join pv in _context.PARAMETER_VALUES on p.Parameter_ID equals pv.Parameter_Id
                                          select new ParameterValues() { p = p, pv = pv }).AsEnumerable()
            .GroupBy(x => x.pv.Answer_Id)
            .ToDictionary(x => x.Key, x => x.Select(y => y).ToList());
        }

        private Dictionary<int, List<PARAMETERS>> parametersDictionary = null;
        private List<ParameterAssessment> parametersAssessmentList;
        private Dictionary<int, List<ParameterValues>> parametersAnswerDictionary;


        /// <summary>
        /// Pull any 'global' parameters for the requirement, overlaid with any 'local' parameters for the answer.
        /// </summary>
        /// <param name="reqId"></param>
        /// <param name="ansId"></param>
        /// <returns></returns>
        public List<ParameterToken> GetTokensForRequirement(int reqId, int ansId)
        {
            ParameterSubstitution ps = new ParameterSubstitution();

            // get the 'base' parameter values (parameter_name) for the requirement
            if (parametersDictionary == null)
            {
                LoadParametersList();
            }

            List<PARAMETERS> qBaseLevel;
            if (parametersDictionary.TryGetValue(reqId, out qBaseLevel))
            {

                foreach (var b in qBaseLevel)
                {
                    ps.Set(b.Parameter_ID, b.Parameter_Name, b.Parameter_Name, reqId, 0);
                }
            }

            // overlay with any assessment-specific parameters for the requirement
            var qAssessLevel = parametersAssessmentList;

            foreach (var a in qAssessLevel)
            {
                ps.Set(a.p.Parameter_ID, a.p.Parameter_Name, a.pa.Parameter_Value_Assessment, reqId, 0);
            }

            // overlay with any 'inline' values for the answer
            if (ansId != 0)
            {
                List<ParameterValues> qLocal;
                if (parametersAnswerDictionary.TryGetValue(ansId, out qLocal))
                {
                    foreach (var local in qLocal.ToList())
                    {
                        ps.Set(local.p.Parameter_ID, local.p.Parameter_Name, local.pv.Parameter_Value, 0, local.pv.Answer_Id);
                    }
                }
            }


            ps.Tokens = ps.Tokens.OrderByDescending(x => x.Token.Length).ToList();

            return ps.Tokens;
        }



        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<ParameterToken> GetDefaultParametersForAssessment()
        {
            SetRequirementAssessmentId(_tokenManager.AssessmentForUser());

            ParameterSubstitution ps = new ParameterSubstitution();

            // Get the list of requirement IDs
            List<RequirementPlus> reqs = GetControls().Requirements.ToList();
            List<int> requirementIds = reqs.Select(r => r.Requirement.Requirement_Id).ToList();


            // get the 'base' parameter values (parameter_name) for the requirement
            var qBaseLevel = from p in _context.PARAMETERS
                             join r in _context.PARAMETER_REQUIREMENTS on p.Parameter_ID equals r.Parameter_Id
                             where requirementIds.Contains(r.Requirement_Id)
                             select new { p, r };

            foreach (var b in qBaseLevel)
            {
                ps.Set(b.p.Parameter_ID, b.p.Parameter_Name, b.p.Parameter_Name, b.r.Requirement_Id, 0);
            }

            // overlay with any assessment-specific parameters for the requirement
            var qAssessLevel = from pa in _context.PARAMETER_ASSESSMENT
                               join p in _context.PARAMETERS on pa.Parameter_ID equals p.Parameter_ID
                               join pr in _context.PARAMETER_REQUIREMENTS on p.Parameter_ID equals pr.Parameter_Id
                               where pa.Assessment_ID == _questionRequirement.AssessmentId
                                && requirementIds.Contains(pr.Requirement_Id)
                               select new { p, pa, pr };

            foreach (var a in qAssessLevel)
            {
                ps.Set(a.p.Parameter_ID, a.p.Parameter_Name, a.pa.Parameter_Value_Assessment, a.pr.Requirement_Id, 0);
            }


            return ps.Tokens;
        }


        /// <summary>
        /// Saves a new text value override in a PARAMETER_ASSESSMENT row.  
        /// </summary>
        /// <param name="requirementId"></param>
        /// <param name="parameterId"></param>
        /// <param name="answerId"></param>
        /// <param name="newText"></param>
        /// <returns></returns>
        public ParameterToken SaveAssessmentParameter(int parameterId, string newText)
        {
            SetRequirementAssessmentId(_tokenManager.AssessmentForUser());

            // If an empty value is supplied, delete the PARAMETER_VALUES row.
            if (string.IsNullOrEmpty(newText))
            {
                var g = _context.PARAMETER_ASSESSMENT.Where(p => p.Parameter_ID == parameterId
                        && p.Assessment_ID == _questionRequirement.AssessmentId).FirstOrDefault();
                if (g != null)
                {
                    _context.PARAMETER_ASSESSMENT.Remove(g);
                    _context.SaveChanges();
                }

                _assessmentUtil.TouchAssessment(_questionRequirement.AssessmentId);

                // build a partial return object just to inform the UI what the new value is
                var baseParameter = _context.PARAMETERS.Where(p => p.Parameter_ID == parameterId).First();
                return new ParameterToken(baseParameter.Parameter_ID, "", baseParameter.Parameter_Name, 0, 0);
            }


            // Otherwise, insert or update the PARAMETER_ASSESSMENT record
            var pa = _context.PARAMETER_ASSESSMENT.Where(p => p.Parameter_ID == parameterId
                    && p.Assessment_ID == _questionRequirement.AssessmentId).FirstOrDefault();

            if (pa == null)
            {
                pa = new PARAMETER_ASSESSMENT();
            }

            pa.Assessment_ID = _questionRequirement.AssessmentId;
            pa.Parameter_ID = parameterId;
            pa.Parameter_Value_Assessment = newText;

            if (_context.PARAMETER_ASSESSMENT.Find(pa.Parameter_ID, pa.Assessment_ID) == null)
            {
                _context.PARAMETER_ASSESSMENT.Add(pa);
            }
            else
            {
                _context.PARAMETER_ASSESSMENT.Update(pa);
            }
            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(_questionRequirement.AssessmentId);

            // build a partial return object just to inform the UI what the new value is
            return new ParameterToken(pa.Parameter_ID, "", pa.Parameter_Value_Assessment, 0, 0);
        }


        /// <summary>
        /// Saves a new text value override in a PARAMETER_VALUES row.  
        /// Creates a new Answer if need be.
        /// If no text is provided, any PARAMETER_VALUES is deleted.
        /// </summary>
        /// <param name="requirementId"></param>
        /// <param name="parameterId"></param>
        /// <param name="answerId"></param>
        /// <param name="newText"></param>
        /// <returns></returns>
        public ParameterToken SaveAnswerParameter(int requirementId, int parameterId, int answerId, string newText)
        {
            SetRequirementAssessmentId(_tokenManager.AssessmentForUser());

            // create an answer if there isn't one already
            if (answerId == 0)
            {
                Answer ans = new Answer()
                {
                    QuestionId = requirementId,
                    QuestionType = "Requirement",
                    MarkForReview = false,
                    QuestionNumber = "0",
                    AnswerText = "U"
                };
                answerId = _questionRequirement.StoreAnswer(ans);
            }

            // If an empty value is supplied, delete the PARAMETER_VALUES row.
            if (string.IsNullOrEmpty(newText))
            {
                var g = _context.PARAMETER_VALUES.Where(pv => pv.Parameter_Id == parameterId && pv.Answer_Id == answerId).FirstOrDefault();
                if (g != null)
                {
                    _context.PARAMETER_VALUES.Remove(g);
                    _context.SaveChanges();
                }

                _assessmentUtil.TouchAssessment(_questionRequirement.AssessmentId);

                return this.GetTokensForRequirement(requirementId, answerId).Where(p => p.Id == parameterId).First();
            }


            // Otherwise, add or update the PARAMETER_VALUES row
            var dbParameterValues = _context.PARAMETER_VALUES.Where(pv => pv.Parameter_Id == parameterId
                    && pv.Answer_Id == answerId).FirstOrDefault();

            if (dbParameterValues == null)
            {
                dbParameterValues = new PARAMETER_VALUES();
            }

            dbParameterValues.Answer_Id = answerId;
            dbParameterValues.Parameter_Id = parameterId;
            dbParameterValues.Parameter_Is_Default = false;
            dbParameterValues.Parameter_Value = newText;


            if (_context.PARAMETER_VALUES.Find(dbParameterValues.Answer_Id, dbParameterValues.Parameter_Id) == null)
            {
                _context.PARAMETER_VALUES.Add(dbParameterValues);
            }
            else
            {
                _context.PARAMETER_VALUES.Update(dbParameterValues);
            }
            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(_questionRequirement.AssessmentId);

            // Return the token that was just updated
            return this.GetTokensForRequirement(requirementId, answerId).Where(p => p.Id == parameterId).First();
        }


        /// <summary>
        /// Returns Requirement text with Parameter substitutions applied.
        /// Also converts linefeed characters to HTML.
        /// </summary>
        /// <param name="requirementText"></param>
        /// <returns></returns>
        public string ResolveParameters(int reqId, int ansId, string requirementText)
        {
            List<ParameterToken> tokens = this.GetTokensForRequirement(reqId, ansId);
            foreach (ParameterToken t in tokens)
            {
                requirementText = requirementText.Replace(t.Token, t.Substitution);
            }

            requirementText = requirementText.Replace("\r\n", "<br/>").Replace("\r", "<br/>").Replace("\n", "<br/>");

            return requirementText;
        }

        public string RichTextParameters(int reqId, int ansId, string requirementText)
        {
            List<ParameterToken> tokens = this.GetTokensForRequirement(reqId, ansId);
            foreach (ParameterToken t in tokens)
            {
                requirementText = requirementText.Replace(t.Token, t.Substitution);
            }

            requirementText = requirementText.Replace("\r\n", "%0D%0A").Replace("\r", "%0D%0A").Replace("\n", "%0D%0A");

            return requirementText;

        }
    }
}