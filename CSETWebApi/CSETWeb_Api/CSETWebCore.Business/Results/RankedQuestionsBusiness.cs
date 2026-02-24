////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using CSETWebCore.DataLayer.Model;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Results
{
    /// <summary>
    /// Provides ranked questions analysis functionality.
    /// Replaces usp_GetRankedQuestions stored procedure.
    /// </summary>
    public class RankedQuestionsBusiness
    {
        private readonly CSETContext _context;

        public RankedQuestionsBusiness(CSETContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Gets the ranked questions data for an assessment.
        /// This replaces the usp_GetRankedQuestions stored procedure.
        /// Note: FillEmptyQuestionsForAnalysis should be called before this method (done in AnalysisController constructor).
        /// </summary>
        /// <param name="assessmentId">The assessment ID</param>
        /// <returns>List of usp_GetRankedQuestions_Result containing ranked questions with 'N' or 'U' answers</returns>
        public async Task<List<usp_GetRankedQuestions_Result>> GetRankedQuestionsAsync(int assessmentId)
        {
            // Get application mode
            var applicationMode = await GetApplicationModeAsync(assessmentId);

            if (applicationMode == "Questions Based")
            {
                return await GetRankedQuestionsForQuestionsBasedAsync(assessmentId);
            }
            else
            {
                return await GetRankedQuestionsForRequirementsBasedAsync(assessmentId);
            }
        }

        /// <summary>
        /// Gets the application mode for the assessment.
        /// </summary>
        private async Task<string> GetApplicationModeAsync(int assessmentId)
        {
            var mode = await _context.STANDARD_SELECTION
                .AsNoTracking()
                .Where(s => s.Assessment_Id == assessmentId)
                .Select(s => s.Application_Mode)
                .FirstOrDefaultAsync();

            return mode ?? "Questions Based";
        }

        /// <summary>
        /// Gets ranked questions for Questions Based mode.
        /// Returns questions with 'N' or 'U' answers ordered by ranking.
        /// </summary>
        private async Task<List<usp_GetRankedQuestions_Result>> GetRankedQuestionsForQuestionsBasedAsync(int assessmentId)
        {
            // Get the selected SAL level and universal SAL level
            var standardSelection = await _context.STANDARD_SELECTION
                .AsNoTracking()
                .Where(s => s.Assessment_Id == assessmentId)
                .Select(s => s.Selected_Sal_Level)
                .FirstOrDefaultAsync();

            var selectedSalLevel = standardSelection ?? "L";

            var universalSalLevel = await _context.UNIVERSAL_SAL_LEVEL
                .AsNoTracking()
                .Where(u => u.Full_Name_Sal == selectedSalLevel)
                .Select(u => u.Universal_Sal_Level1)
                .FirstOrDefaultAsync() ?? "L";

            // Get distinct question IDs in scope (selected standards at selected SAL level)
            // with their corresponding short names
            var questionsInScope = await (
                from nqs in _context.NEW_QUESTION_SETS.AsNoTracking()
                join avs in _context.AVAILABLE_STANDARDS.AsNoTracking() on nqs.Set_Name equals avs.Set_Name
                join sets in _context.SETS.AsNoTracking() on nqs.Set_Name equals sets.Set_Name
                join nql in _context.NEW_QUESTION_LEVELS.AsNoTracking() on nqs.New_Question_Set_Id equals nql.New_Question_Set_Id
                where avs.Assessment_Id == assessmentId
                      && avs.Selected
                      && nql.Universal_Sal_Level == universalSalLevel
                select new { nqs.Question_Id, sets.Short_Name }
            ).Distinct().ToListAsync();

            if (!questionsInScope.Any())
            {
                return new List<usp_GetRankedQuestions_Result>();
            }

            var questionIds = questionsInScope.Select(q => q.Question_Id).ToHashSet();
            var shortNameLookup = questionsInScope.GroupBy(q => q.Question_Id)
                .ToDictionary(g => g.Key, g => g.First().Short_Name);

            // Query for ranked questions with 'N' or 'U' answers
            var rankedQuestions = await (
                from aq in _context.Answer_Questions.AsNoTracking()
                join nq in _context.NEW_QUESTION.AsNoTracking() on aq.Question_Or_Requirement_Id equals nq.Question_Id
                join vh in _context.vQUESTION_HEADINGS.AsNoTracking() on nq.Heading_Pair_Id equals vh.Heading_Pair_Id
                where aq.Assessment_Id == assessmentId
                      && questionIds.Contains(nq.Question_Id)
                      && (aq.Answer_Text == "N" || aq.Answer_Text == "U")
                orderby nq.Ranking
                select new
                {
                    nq.Question_Id,
                    vh.Question_Group_Heading,
                    nq.Simple_Question,
                    aq.Answer_Id,
                    aq.Answer_Text,
                    nq.Universal_Sal_Level,
                    aq.Question_Number,
                    nq.Ranking
                }
            ).ToListAsync();

            // Apply ROW_NUMBER equivalent and project to result
            var results = rankedQuestions
                .Select((q, index) => new usp_GetRankedQuestions_Result
                {
                    Standard = shortNameLookup.TryGetValue(q.Question_Id, out var shortName) ? shortName : string.Empty,
                    Category = q.Question_Group_Heading,
                    Rank = index + 1,
                    QuestionText = q.Simple_Question,
                    QuestionId = q.Question_Id,
                    RequirementId = null,
                    AnswerID = q.Answer_Id,
                    AnswerText = q.Answer_Text,
                    Level = q.Universal_Sal_Level,
                    QuestionRef = q.Question_Number.ToString(),
                    QuestionOrRequirementID = q.Question_Id
                })
                .ToList();

            return results;
        }

        /// <summary>
        /// Gets ranked questions for Requirements Based mode.
        /// Returns requirements with 'N' or 'U' answers ordered by ranking.
        /// </summary>
        private async Task<List<usp_GetRankedQuestions_Result>> GetRankedQuestionsForRequirementsBasedAsync(int assessmentId)
        {
            // Get the selected SAL level and universal SAL level
            var standardSelection = await _context.STANDARD_SELECTION
                .AsNoTracking()
                .Where(s => s.Assessment_Id == assessmentId)
                .Select(s => s.Selected_Sal_Level)
                .FirstOrDefaultAsync();

            var selectedSalLevel = standardSelection ?? "L";

            var universalSalLevel = await _context.UNIVERSAL_SAL_LEVEL
                .AsNoTracking()
                .Where(u => u.Full_Name_Sal == selectedSalLevel)
                .Select(u => u.Universal_Sal_Level1)
                .FirstOrDefaultAsync() ?? "L";

            // Get selected set names
            var selectedSetNames = await _context.AVAILABLE_STANDARDS
                .AsNoTracking()
                .Where(avs => avs.Assessment_Id == assessmentId && avs.Selected)
                .Select(avs => avs.Set_Name)
                .ToListAsync();

            if (!selectedSetNames.Any())
            {
                return new List<usp_GetRankedQuestions_Result>();
            }

            // Query for ranked requirements with 'N' or 'U' answers
            var rankedRequirements = await (
                from rs in _context.REQUIREMENT_SETS.AsNoTracking()
                join ans in _context.ANSWER.AsNoTracking() on rs.Requirement_Id equals ans.Question_Or_Requirement_Id
                join sets in _context.SETS.AsNoTracking() on rs.Set_Name equals sets.Set_Name
                join req in _context.NEW_REQUIREMENT.AsNoTracking() on rs.Requirement_Id equals req.Requirement_Id
                join rl in _context.REQUIREMENT_LEVELS.AsNoTracking() on req.Requirement_Id equals rl.Requirement_Id
                where selectedSetNames.Contains(rs.Set_Name)
                      && ans.Assessment_Id == assessmentId
                      && rl.Standard_Level == universalSalLevel
                      && (ans.Answer_Text == "N" || ans.Answer_Text == "U")
                orderby req.Ranking
                select new
                {
                    sets.Short_Name,
                    req.Standard_Category,
                    req.Requirement_Text,
                    req.Requirement_Id,
                    ans.Answer_Id,
                    ans.Answer_Text,
                    UniversalSalLevel = universalSalLevel,
                    req.Requirement_Title,
                    req.Ranking
                }
            ).ToListAsync();

            // Apply ROW_NUMBER equivalent and project to result
            var results = rankedRequirements
                .Select((r, index) => new usp_GetRankedQuestions_Result
                {
                    Standard = r.Short_Name,
                    Category = r.Standard_Category,
                    Rank = index + 1,
                    QuestionText = r.Requirement_Text,
                    QuestionId = null,
                    RequirementId = r.Requirement_Id,
                    AnswerID = r.Answer_Id,
                    AnswerText = r.Answer_Text,
                    Level = r.UniversalSalLevel,
                    QuestionRef = r.Requirement_Title,
                    QuestionOrRequirementID = r.Requirement_Id
                })
                .ToList();

            return results;
        }
    }
}
