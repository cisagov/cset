//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using CSETWebCore.DataLayer.Model;
using System.Linq;
using CSETWebCore.Model.Question;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.Helpers
{
    public class ParameterSubstitution
    {
        private CSETContext _context;
        private int _assessmentId;

        private Dictionary<int, List<PARAMETERS>> _parametersDictionary = null;
        private List<ParameterAssessment> _parametersAssessmentList;
        private Dictionary<int, List<ParameterValues>> _parametersAnswerDictionary;


        /// <summary>
        /// Constructs a new instance of ParameterSubstitution.
        /// </summary>
        /// <param name="context"></param>
        public ParameterSubstitution(CSETContext context, ITokenManager tokenManager)
        {
            _context = context;
            _assessmentId = tokenManager.AssessmentForUser();

            // get the 'base' parameter values (parameter_name) for the requirement
            LoadParametersLists();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="db"></param>
        public void LoadParametersLists()
        {
            _parametersDictionary = (from p in _context.PARAMETERS
                                     join r in _context.PARAMETER_REQUIREMENTS on p.Parameter_ID equals r.Parameter_Id
                                     select new { p, r }).AsEnumerable()
                .GroupBy(x => x.r.Requirement_Id)
            .ToDictionary(x => x.Key, x => x.Select(y => y.p).ToList());
            _parametersAssessmentList = (from pa in _context.PARAMETER_ASSESSMENT
                                         join p in _context.PARAMETERS on pa.Parameter_ID equals p.Parameter_ID
                                         where pa.Assessment_ID == _assessmentId
                                         select new ParameterAssessment() { p = p, pa = pa }).ToList();

            _parametersAnswerDictionary = (from p in _context.PARAMETERS
                                           join pv in _context.PARAMETER_VALUES on p.Parameter_ID equals pv.Parameter_Id
                                           select new ParameterValues() { p = p, pv = pv }).AsEnumerable()
            .GroupBy(x => x.pv.Answer_Id)
            .ToDictionary(x => x.Key, x => x.Select(y => y).ToList());
        }


        /// <summary>
        /// Pull any 'global' parameters for the requirement, overlaid with any 'local' parameters for the answer.
        /// </summary>
        /// <param name="reqId"></param>
        /// <param name="ansId"></param>
        /// <returns></returns>
        public List<ParameterToken> GetTokensForRequirement(int reqId, int ansId)
        {
            List<ParameterToken> pTokens = [];
            List<PARAMETERS> qBaseLevel;
            if (_parametersDictionary.TryGetValue(reqId, out qBaseLevel))
            {
                foreach (var b in qBaseLevel)
                {
                    Set(pTokens, b.Parameter_ID, b.Parameter_Name, null, reqId, 0);
                }
            }

            // overlay with any assessment-specific parameters for the requirement
            var qAssessLevel = _parametersAssessmentList;

            foreach (var a in qAssessLevel)
            {
                Set(pTokens, a.p.Parameter_ID, a.p.Parameter_Name, a.pa.Parameter_Value_Assessment, reqId, 0);
            }

            // overlay with any 'inline' values for the answer
            if (ansId != 0)
            {
                List<ParameterValues> qLocal;
                if (_parametersAnswerDictionary.TryGetValue(ansId, out qLocal))
                {
                    foreach (var local in qLocal.ToList())
                    {
                        Set(pTokens, local.p.Parameter_ID, local.p.Parameter_Name, local.pv.Parameter_Value, reqId, local.pv.Answer_Id);
                    }
                }
            }

            pTokens = pTokens.OrderByDescending(x => x.Token.Length).ToList();

            return pTokens;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<ParameterToken> GetDefaultParametersForAssessment(List<RequirementPlus> reqs)
        {
            List<ParameterToken> pTokens = [];

            // Get the list of requirement IDs
            List<int> requirementIds = reqs.Select(r => r.Requirement.Requirement_Id).ToList();


            // get the 'base' parameter values (parameter_name) for the requirement
            var qBaseLevel = from p in _context.PARAMETERS
                             join r in _context.PARAMETER_REQUIREMENTS on p.Parameter_ID equals r.Parameter_Id
                             where requirementIds.Contains(r.Requirement_Id)
                             select new { p, r };

            foreach (var b in qBaseLevel)
            {
                Set(pTokens, b.p.Parameter_ID, b.p.Parameter_Name, b.p.Parameter_Name, b.r.Requirement_Id, 0);
            }

            // overlay with any assessment-specific parameters for the requirement
            var qAssessLevel = from pa in _context.PARAMETER_ASSESSMENT
                               join p in _context.PARAMETERS on pa.Parameter_ID equals p.Parameter_ID
                               join pr in _context.PARAMETER_REQUIREMENTS on p.Parameter_ID equals pr.Parameter_Id
                               where pa.Assessment_ID == _assessmentId
                                && requirementIds.Contains(pr.Requirement_Id)
                               select new { p, pa, pr };

            foreach (var a in qAssessLevel)
            {
                Set(pTokens, a.p.Parameter_ID, a.p.Parameter_Name, a.pa.Parameter_Value_Assessment, a.pr.Requirement_Id, 0);
            }

            return pTokens;
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
        public ParameterToken SaveAnswerParameter(IQuestionRequirementManager qr, 
            int requirementId, int parameterId, int answerId, string newText)
        {
            var assessmentUtil = new AssessmentUtil(_context);

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
                answerId = qr.StoreAnswer(ans);
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

                assessmentUtil.TouchAssessment(_assessmentId);

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

            assessmentUtil.TouchAssessment(_assessmentId);


            // Return a ParameterToken with the value that was just updated
            var pt = new ParameterToken() { 
                Substitution = dbParameterValues.Parameter_Value,
                RequirementId = requirementId,
                AnswerId = dbParameterValues.Answer_Id,
                Id = dbParameterValues.Parameter_Id
            };
            return pt;
        }


        /// <summary>
        /// Returns Requirement text with Parameter substitutions applied.
        /// Also converts linefeed characters to HTML.
        /// </summary>
        /// <param name="requirementText"></param>
        /// <returns></returns>
        public string ResolveParameters(int reqId, int ansId, string requirementText)
        {
            List<ParameterToken> pTokens = this.GetTokensForRequirement(reqId, ansId);
            foreach (ParameterToken t in pTokens)
            {
                if (t.Substitution != null)
                {
                    requirementText = requirementText.Replace(
                        "{{" + t.Token + "}}",
                        "<em>" + t.Substitution + "</em>");
                }
            }

            // format anything still unresolved
            requirementText = requirementText.Replace("{{", "[<em>").Replace("}}", "</em>]");

            return requirementText;
        }


        public string RichTextParameters(int reqId, int ansId, string requirementText)
        {
            List<ParameterToken> pTokens = GetTokensForRequirement(reqId, ansId);
            foreach (ParameterToken t in pTokens)
            {
                requirementText = requirementText.Replace(t.Token, t.Substitution);
            }

            requirementText = requirementText.Replace("\r\n", "%0D%0A").Replace("\r", "%0D%0A").Replace("\n", "%0D%0A");

            return requirementText;
        }


        /// <summary>
        /// Adds a new element to the tokens list or overwrites
        /// if it already exists.  This is so that we can overlay
        /// global settings with local/answer settings.
        /// </summary>
        /// <param name="token"></param>
        /// <param name="substitution"></param>
        public void Set(List<ParameterToken> pTokens, int id, string token, string substitution, int reqId, int ansId)
        {
            var t = pTokens.Find(x => x.Token == token);
            if (t != null)
            {
                t.Substitution = substitution;
                t.RequirementId = reqId;
                t.AnswerId = ansId;
            }
            else
            {
                pTokens.Add(new ParameterToken(id, token, substitution, reqId, ansId));
            }
        }
    }
}