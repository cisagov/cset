//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Malcolm;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.EntityFrameworkCore;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Model.Question;
using Nelibur.ObjectMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;


namespace CSETWebCore.Business.Question
{
    public class ComponentQuestionBusiness
    {
        private CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly ITokenManager _tokenManager;
        private readonly IQuestionRequirementManager _questionRequirement;

        /// <summary>
        ///
        /// </summary>
        public List<SubCategoryAnswersPlus> SubCatAnswers;

        /// <summary>
        /// Dictionary for O(1) lookup of answers by Question_Or_Requirement_Id
        /// </summary>
        private Dictionary<int, FullAnswer> _answersByQuestionId = new Dictionary<int, FullAnswer>();

        /// <summary>
        /// Dictionary for O(1) lookup of SubCatAnswers by HeadingId
        /// </summary>
        private Dictionary<int, SubCategoryAnswersPlus> _subCatAnswersByHeadingId = new Dictionary<int, SubCategoryAnswersPlus>();


        /// <summary>
        /// 
        /// </summary>
        protected string ApplicationMode = "";


        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="assessmentID"></param>
        public ComponentQuestionBusiness(CSETContext context, IAssessmentUtil assessmentUtil, ITokenManager tokenManager, IQuestionRequirementManager questionRequirement)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
            _tokenManager = tokenManager;
            _questionRequirement = questionRequirement;
        }


        /// <summary>
        /// Gathers applicable questions for the assessment's network components as defined the by Diagram.
        /// </summary>
        /// <param name="resp"></param>        
        public QuestionResponse GetResponse()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var resp = new QuestionResponse();
            var mb = new MalcolmBusiness(_context);
            //mb.VerificationAndValidation(assessmentId);

            // Ideally, we would not call this proc each time we fetch the questions.
            // Is there a quick way to tell if all the diagram answers have already been filled?
            _context.FillNetworkDiagramQuestions(assessmentId);

            // Get component defaults using scoped SQL to avoid cross-assessment view scan
            FormattableString defaultSql = $"""
                SELECT
                    ISNULL(CONVERT(int, ROW_NUMBER() OVER (ORDER BY q.Question_id)), 0) AS UniqueKey,
                    a.Assessment_Id, a.Answer_Id, q.Question_Id, a.Answer_Text,
                    CONVERT(nvarchar(1000), a.Comment) AS Comment,
                    CONVERT(nvarchar(1000), a.Alternate_Justification) AS Alternate_Justification,
                    a.Question_Number, q.Simple_Question AS QuestionText,
                    h.Question_Group_Heading, usch.Question_Group_Heading_Id AS GroupHeadingId,
                    h.Universal_Sub_Category, usch.Universal_Sub_Category_Id AS SubCategoryId,
                    a.FeedBack, a.Is_Component, a.Component_Guid,
                    dbo.convert_sal(ss.Selected_Sal_Level) AS SAL,
                    a.Mark_For_Review, a.Is_Requirement, a.Is_Framework,
                    q.heading_pair_id, h.Sub_Heading_Question_Description,
                    q.Simple_Question, a.Reviewed,
                    CAST(NULL AS nvarchar) AS label,
                    CAST(NULL AS nvarchar) AS ComponentName,
                    CAST(NULL AS nvarchar) AS Symbol_Name,
                    0 AS Component_Symbol_id
                FROM STANDARD_SELECTION ss
                JOIN (
                    SELECT DISTINCT q.question_id, adc.assessment_id
                    FROM ASSESSMENT_DIAGRAM_COMPONENTS adc
                    JOIN component_questions q ON adc.Component_Symbol_Id = q.Component_Symbol_Id
                    JOIN STANDARD_SELECTION ss ON adc.Assessment_Id = ss.Assessment_Id
                    JOIN new_question nq ON q.question_id = nq.question_id
                    JOIN new_question_sets qs ON nq.question_id = qs.question_id AND qs.Set_Name = 'Components'
                    JOIN DIAGRAM_CONTAINER l ON adc.Layer_id = l.Container_Id
                    LEFT JOIN DIAGRAM_CONTAINER z ON adc.Zone_Id = z.Container_Id
                    JOIN NEW_QUESTION_LEVELS nql ON qs.New_Question_Set_Id = nql.New_Question_Set_Id
                        AND nql.Universal_Sal_Level = dbo.convert_sal(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level))
                    WHERE l.visible = 1 AND adc.Assessment_Id = {assessmentId}
                ) AS f ON ss.assessment_id = f.assessment_id
                JOIN NEW_QUESTION q ON f.Question_Id = q.Question_Id
                JOIN vQUESTION_HEADINGS h ON q.Heading_Pair_Id = h.Heading_Pair_Id
                JOIN UNIVERSAL_SUB_CATEGORY_HEADINGS usch ON usch.Heading_Pair_Id = h.Heading_Pair_Id
                JOIN Answer_Components a ON f.Question_Id = a.Question_Or_Requirement_Id
                    AND f.assessment_id = a.assessment_id
                WHERE a.component_guid = '00000000-0000-0000-0000-000000000000'
                    AND a.Assessment_Id = {assessmentId}
                ORDER BY h.Question_Group_Heading, h.Universal_Sub_Category
                """;

            var rawDefaults = _context.Answer_Components_Default
                .FromSqlInterpolated(defaultSql)
                .AsNoTracking()
                .ToList();

            var list2 = rawDefaults.Select(x => new Answer_Components_Base
            {
                UniqueKey = x.UniqueKey,
                Assessment_Id = x.Assessment_Id,
                Answer_Id = x.Answer_Id,
                Question_Id = x.Question_Id,
                Answer_Text = x.Answer_Text,
                Comment = x.Comment,
                Alternate_Justification = x.Alternate_Justification,
                Question_Number = x.Question_Number,
                QuestionText = x.QuestionText,
                Question_Group_Heading = x.Question_Group_Heading,
                GroupHeadingId = x.GroupHeadingId,
                Universal_Sub_Category = x.Universal_Sub_Category,
                SubCategoryId = x.SubCategoryId,
                FeedBack = x.FeedBack,
                Is_Component = x.Is_Component ?? false,
                Component_Guid = x.Component_Guid,
                SAL = x.SAL,
                Mark_For_Review = x.Mark_For_Review,
                Is_Requirement = x.Is_Requirement ?? false,
                Is_Framework = x.Is_Framework ?? false,
                heading_pair_id = x.heading_pair_id,
                Sub_Heading_Question_Description = x.Sub_Heading_Question_Description,
                Simple_Question = x.Simple_Question,
                Reviewed = x.Reviewed,
                Label = x.label,
                ComponentName = x.ComponentName,
                Symbol_Name = x.Symbol_Name,
                Component_Symbol_Id = x.Component_Symbol_id
            }).ToList();

            // Get all answers for the assessment and build O(1) lookup dictionary
            LoadAnswersOptimized(assessmentId);

            // Populate SubCatAnswers for subcategory header answer display
            _questionRequirement.AssessmentId = assessmentId;
            _questionRequirement.InitializeSubCategoryAnswers();
            SubCatAnswers = _questionRequirement.SubCatAnswers;

            // Build SubCatAnswers dictionary for O(1) lookups
            if (SubCatAnswers != null)
            {
                _subCatAnswersByHeadingId = SubCatAnswers
                    .Where(x => x.HeadingId > 0)
                    .GroupBy(x => x.HeadingId)
                    .ToDictionary(g => g.Key, g => g.First());
            }

            AddResponse(resp, list2, "Component Defaults");
            BuildOverridesOnly(resp);

            return resp;
        }


        /// <summary>
        /// Async version of GetResponse with optimized database queries.
        /// Uses batched queries and O(1) dictionary lookups for better performance.
        /// </summary>
        public async Task<QuestionResponse> GetResponseAsync()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var resp = new QuestionResponse();

            // Only call SP if no component answers exist yet (optimization)
            var hasComponentAnswers = await _context.ANSWER
                .AsNoTracking()
                .AnyAsync(a => a.Assessment_Id == assessmentId && a.Question_Type == "Component");

            if (!hasComponentAnswers)
            {
                _context.FillNetworkDiagramQuestions(assessmentId);
            }

            // Get component defaults using scoped SQL to avoid cross-assessment view scan
            FormattableString defaultSql = $"""
                SELECT
                    ISNULL(CONVERT(int, ROW_NUMBER() OVER (ORDER BY q.Question_id)), 0) AS UniqueKey,
                    a.Assessment_Id, a.Answer_Id, q.Question_Id, a.Answer_Text,
                    CONVERT(nvarchar(1000), a.Comment) AS Comment,
                    CONVERT(nvarchar(1000), a.Alternate_Justification) AS Alternate_Justification,
                    a.Question_Number, q.Simple_Question AS QuestionText,
                    h.Question_Group_Heading, usch.Question_Group_Heading_Id AS GroupHeadingId,
                    h.Universal_Sub_Category, usch.Universal_Sub_Category_Id AS SubCategoryId,
                    a.FeedBack, a.Is_Component, a.Component_Guid,
                    dbo.convert_sal(ss.Selected_Sal_Level) AS SAL,
                    a.Mark_For_Review, a.Is_Requirement, a.Is_Framework,
                    q.heading_pair_id, h.Sub_Heading_Question_Description,
                    q.Simple_Question, a.Reviewed,
                    CAST(NULL AS nvarchar) AS label,
                    CAST(NULL AS nvarchar) AS ComponentName,
                    CAST(NULL AS nvarchar) AS Symbol_Name,
                    0 AS Component_Symbol_id
                FROM STANDARD_SELECTION ss
                JOIN (
                    SELECT DISTINCT q.question_id, adc.assessment_id
                    FROM ASSESSMENT_DIAGRAM_COMPONENTS adc
                    JOIN component_questions q ON adc.Component_Symbol_Id = q.Component_Symbol_Id
                    JOIN STANDARD_SELECTION ss ON adc.Assessment_Id = ss.Assessment_Id
                    JOIN new_question nq ON q.question_id = nq.question_id
                    JOIN new_question_sets qs ON nq.question_id = qs.question_id AND qs.Set_Name = 'Components'
                    JOIN DIAGRAM_CONTAINER l ON adc.Layer_id = l.Container_Id
                    LEFT JOIN DIAGRAM_CONTAINER z ON adc.Zone_Id = z.Container_Id
                    JOIN NEW_QUESTION_LEVELS nql ON qs.New_Question_Set_Id = nql.New_Question_Set_Id
                        AND nql.Universal_Sal_Level = dbo.convert_sal(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level))
                    WHERE l.visible = 1 AND adc.Assessment_Id = {assessmentId}
                ) AS f ON ss.assessment_id = f.assessment_id
                JOIN NEW_QUESTION q ON f.Question_Id = q.Question_Id
                JOIN vQUESTION_HEADINGS h ON q.Heading_Pair_Id = h.Heading_Pair_Id
                JOIN UNIVERSAL_SUB_CATEGORY_HEADINGS usch ON usch.Heading_Pair_Id = h.Heading_Pair_Id
                JOIN Answer_Components a ON f.Question_Id = a.Question_Or_Requirement_Id
                    AND f.assessment_id = a.assessment_id
                WHERE a.component_guid = '00000000-0000-0000-0000-000000000000'
                    AND a.Assessment_Id = {assessmentId}
                ORDER BY h.Question_Group_Heading, h.Universal_Sub_Category
                """;

            var rawDefaults = await _context.Answer_Components_Default
                .FromSqlInterpolated(defaultSql)
                .AsNoTracking()
                .ToListAsync();

            var list2 = rawDefaults.Select(x => new Answer_Components_Base
            {
                UniqueKey = x.UniqueKey,
                Assessment_Id = x.Assessment_Id,
                Answer_Id = x.Answer_Id,
                Question_Id = x.Question_Id,
                Answer_Text = x.Answer_Text,
                Comment = x.Comment,
                Alternate_Justification = x.Alternate_Justification,
                Question_Number = x.Question_Number,
                QuestionText = x.QuestionText,
                Question_Group_Heading = x.Question_Group_Heading,
                GroupHeadingId = x.GroupHeadingId,
                Universal_Sub_Category = x.Universal_Sub_Category,
                SubCategoryId = x.SubCategoryId,
                FeedBack = x.FeedBack,
                Is_Component = x.Is_Component ?? false,
                Component_Guid = x.Component_Guid,
                SAL = x.SAL,
                Mark_For_Review = x.Mark_For_Review,
                Is_Requirement = x.Is_Requirement ?? false,
                Is_Framework = x.Is_Framework ?? false,
                heading_pair_id = x.heading_pair_id,
                Sub_Heading_Question_Description = x.Sub_Heading_Question_Description,
                Simple_Question = x.Simple_Question,
                Reviewed = x.Reviewed,
                Label = x.label,
                ComponentName = x.ComponentName,
                Symbol_Name = x.Symbol_Name,
                Component_Symbol_Id = x.Component_Symbol_id
            }).ToList();

            // Load answers with optimized batched queries
            await LoadAnswersOptimizedAsync(assessmentId);

            // Populate SubCatAnswers for subcategory header answer display
            _questionRequirement.AssessmentId = assessmentId;
            _questionRequirement.InitializeSubCategoryAnswers();
            SubCatAnswers = _questionRequirement.SubCatAnswers;

            // Build SubCatAnswers dictionary for O(1) lookups
            if (SubCatAnswers != null)
            {
                _subCatAnswersByHeadingId = SubCatAnswers
                    .Where(x => x.HeadingId > 0)
                    .GroupBy(x => x.HeadingId)
                    .ToDictionary(g => g.Key, g => g.FirstOrDefault());
            }

            AddResponse(resp, list2, "Component Defaults");
            await BuildOverridesOnlyAsync(resp);

            return resp;
        }


        /// <summary>
        /// Loads all answers with optimized batched queries instead of N+1 pattern.
        /// Avoids expensive VIEW_QUESTIONS_STATUS view by computing status directly.
        /// </summary>
        private async Task LoadAnswersOptimizedAsync(int assessmentId)
        {
            // 1. Get all component answers (single query)
            var answers = await _context.ANSWER
                .AsNoTracking()
                .Where(x => x.Assessment_Id == assessmentId && x.Question_Type == "Component")
                .ToListAsync();

            if (!answers.Any())
            {
                _answersByQuestionId = new Dictionary<int, FullAnswer>();
                return;
            }

            var answerIds = answers.Select(a => a.Answer_Id).ToHashSet();

            // 2. Batch query for document counts (replaces VIEW_QUESTIONS_STATUS document part)
            var documentCounts = await _context.DOCUMENT_ANSWERS
                .AsNoTracking()
                .Where(d => answerIds.Contains(d.Answer_Id))
                .GroupBy(d => d.Answer_Id)
                .Select(g => new { AnswerId = g.Key, Count = g.Count() })
                .ToDictionaryAsync(x => x.AnswerId, x => x.Count);

            // 3. Batch query for finding counts (replaces VIEW_QUESTIONS_STATUS finding part)
            var findingCounts = await _context.FINDING
                .AsNoTracking()
                .Where(f => f.Answer_Id.HasValue && answerIds.Contains(f.Answer_Id.Value))
                .GroupBy(f => f.Answer_Id.Value)
                .Select(g => new { AnswerId = g.Key, Count = g.Count() })
                .ToDictionaryAsync(x => x.AnswerId, x => x.Count);

            // 4. Build O(1) lookup dictionary with computed status
            _answersByQuestionId = answers.ToDictionary(
                a => a.Question_Or_Requirement_Id,
                a =>
                {
                    documentCounts.TryGetValue(a.Answer_Id, out var docCount);
                    findingCounts.TryGetValue(a.Answer_Id, out var findCount);

                    return new FullAnswer
                    {
                        a = a,
                        b = new DataLayer.Model.VIEW_QUESTIONS_STATUS
                        {
                            Answer_Id = a.Answer_Id,
                            Assessment_Id = a.Assessment_Id,
                            Question_Or_Requirement_Id = a.Question_Or_Requirement_Id,
                            HasComment = !string.IsNullOrEmpty(a.Comment),
                            MarkForReview = a.Mark_For_Review,
                            HasDocument = docCount > 0,
                            docnum = docCount,
                            HasDiscovery = findCount > 0,
                            findingnum = findCount
                        },
                        ObservationsExist = findCount > 0
                    };
                });
        }


        /// <summary>
        /// Synchronous version of LoadAnswersOptimizedAsync for backward compatibility.
        /// Avoids expensive VIEW_QUESTIONS_STATUS view by computing status directly.
        /// </summary>
        private void LoadAnswersOptimized(int assessmentId)
        {
            // 1. Get all component answers (single query)
            var answers = _context.ANSWER
                .AsNoTracking()
                .Where(x => x.Assessment_Id == assessmentId && x.Question_Type == "Component")
                .ToList();

            if (!answers.Any())
            {
                _answersByQuestionId = new Dictionary<int, FullAnswer>();
                return;
            }

            var answerIds = answers.Select(a => a.Answer_Id).ToHashSet();

            // 2. Batch query for document counts (replaces VIEW_QUESTIONS_STATUS document part)
            var documentCounts = _context.DOCUMENT_ANSWERS
                .AsNoTracking()
                .Where(d => answerIds.Contains(d.Answer_Id))
                .GroupBy(d => d.Answer_Id)
                .Select(g => new { AnswerId = g.Key, Count = g.Count() })
                .ToDictionary(x => x.AnswerId, x => x.Count);

            // 3. Batch query for finding counts (replaces VIEW_QUESTIONS_STATUS finding part)
            var findingCounts = _context.FINDING
                .AsNoTracking()
                .Where(f => f.Answer_Id.HasValue && answerIds.Contains(f.Answer_Id.Value))
                .GroupBy(f => f.Answer_Id.Value)
                .Select(g => new { AnswerId = g.Key, Count = g.Count() })
                .ToDictionary(x => x.AnswerId, x => x.Count);

            // 4. Build O(1) lookup dictionary with computed status
            _answersByQuestionId = answers.ToDictionary(
                a => a.Question_Or_Requirement_Id,
                a =>
                {
                    documentCounts.TryGetValue(a.Answer_Id, out var docCount);
                    findingCounts.TryGetValue(a.Answer_Id, out var findCount);

                    return new FullAnswer
                    {
                        a = a,
                        b = new DataLayer.Model.VIEW_QUESTIONS_STATUS
                        {
                            Answer_Id = a.Answer_Id,
                            Assessment_Id = a.Assessment_Id,
                            Question_Or_Requirement_Id = a.Question_Or_Requirement_Id,
                            HasComment = !string.IsNullOrEmpty(a.Comment),
                            MarkForReview = a.Mark_For_Review,
                            HasDocument = docCount > 0,
                            docnum = docCount,
                            HasDiscovery = findCount > 0,
                            findingnum = findCount
                        },
                        ObservationsExist = findCount > 0
                    };
                });
        }


        /// <summary>
        /// Async version of BuildOverridesOnly.
        /// </summary>
        private async Task BuildOverridesOnlyAsync(QuestionResponse resp)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            // Get component overrides using scoped SQL to avoid cross-assessment view scan
            FormattableString overrideSql = $"""
                SELECT
                    CONVERT(nvarchar(100), ROW_NUMBER() OVER (ORDER BY a.Question_id)) AS UniqueKey,
                    a.Assessment_Id, b.Answer_Id, a.Question_Id,
                    ISNULL(b.Answer_Text, c.Answer_Text) AS Answer_Text,
                    CONVERT(nvarchar(1000), b.Comment) AS Comment,
                    CONVERT(nvarchar(1000), b.Alternate_Justification) AS Alternate_Justification,
                    b.FeedBack, b.Question_Number, a.Simple_Question AS QuestionText,
                    a.label AS ComponentName, a.Symbol_Name,
                    a.Question_Group_Heading, a.GroupHeadingId,
                    a.Universal_Sub_Category, a.SubCategoryId,
                    ISNULL(b.Is_Component, 1) AS Is_Component, a.Component_Guid,
                    a.Layer_Id, a.LayerName, a.Container_Id, a.ZoneName,
                    dbo.convert_sal(a.SAL) AS SAL,
                    b.Mark_For_Review,
                    CAST(0 AS bit) AS Is_Requirement,
                    CAST(0 AS bit) AS Is_Framework,
                    b.Reviewed, a.Simple_Question, a.Sub_Heading_Question_Description,
                    a.heading_pair_id, a.label, a.Component_Symbol_Id
                FROM (
                    SELECT
                        CONVERT(nvarchar(100), ROW_NUMBER() OVER (ORDER BY q.Question_id)) AS UniqueKey,
                        adc.Assessment_Id, q.Question_Id, q.Simple_Question,
                        adc.label, adc.Component_Symbol_Id,
                        h.Question_Group_Heading, usch.Question_Group_Heading_Id AS GroupHeadingId,
                        h.Universal_Sub_Category, usch.Universal_Sub_Category_Id AS SubCategoryId,
                        adc.Component_Guid, adc.Layer_Id, l.Name AS LayerName, z.Container_Id,
                        z.Name AS ZoneName,
                        dbo.convert_sal(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level)) AS SAL,
                        h.Sub_Heading_Question_Description, h.Heading_Pair_Id, cs.Symbol_Name
                    FROM ASSESSMENT_DIAGRAM_COMPONENTS adc
                    JOIN STANDARD_SELECTION ss ON adc.Assessment_Id = ss.Assessment_Id
                    JOIN COMPONENT_QUESTIONS cq ON adc.Component_Symbol_Id = cq.Component_Symbol_Id
                    JOIN COMPONENT_SYMBOLS cs ON adc.Component_Symbol_Id = cs.Component_Symbol_Id
                    JOIN NEW_QUESTION q ON cq.Question_Id = q.Question_Id
                    JOIN DIAGRAM_CONTAINER l ON adc.Layer_Id = l.Container_Id
                    LEFT JOIN DIAGRAM_CONTAINER z ON adc.Zone_Id = z.Container_Id
                    JOIN (
                        SELECT s.*, nql.Universal_Sal_Level
                        FROM NEW_QUESTION_SETS s
                        JOIN NEW_QUESTION_LEVELS nql ON s.New_Question_Set_Id = nql.New_Question_Set_Id
                        WHERE set_name = 'Components'
                    ) s ON q.Question_Id = s.Question_Id
                        AND s.Universal_Sal_Level = dbo.convert_sal_short(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level))
                    LEFT JOIN vQUESTION_HEADINGS h ON q.Heading_Pair_Id = h.Heading_Pair_Id
                    LEFT JOIN UNIVERSAL_SUB_CATEGORY_HEADINGS usch ON usch.Heading_Pair_Id = h.Heading_Pair_Id
                    WHERE l.Visible = 1 AND adc.Assessment_Id = {assessmentId}
                ) a
                LEFT JOIN Answer_Components b ON a.Question_Id = b.Question_Or_Requirement_Id
                    AND a.Assessment_Id = b.Assessment_Id
                    AND a.Component_Guid = b.Component_Guid
                LEFT JOIN (
                    SELECT a2.Assessment_Id, q.Question_Id, a2.Answer_Text
                    FROM (
                        SELECT DISTINCT q.question_id, adc.assessment_id
                        FROM ASSESSMENT_DIAGRAM_COMPONENTS adc
                        JOIN component_questions q ON adc.Component_Symbol_Id = q.Component_Symbol_Id
                        JOIN STANDARD_SELECTION ss ON adc.Assessment_Id = ss.Assessment_Id
                        JOIN new_question nq ON q.question_id = nq.question_id
                        JOIN new_question_sets qs ON nq.question_id = qs.question_id AND qs.Set_Name = 'Components'
                        JOIN NEW_QUESTION_LEVELS nql ON qs.New_Question_Set_Id = nql.New_Question_Set_Id
                            AND nql.Universal_Sal_Level = dbo.convert_sal(ss.Selected_Sal_Level)
                        WHERE adc.Assessment_Id = {assessmentId}
                    ) f
                    JOIN NEW_QUESTION q ON f.Question_Id = q.Question_Id
                    JOIN Answer_Components a2 ON f.Question_Id = a2.Question_Or_Requirement_Id
                        AND f.assessment_id = a2.assessment_id
                    WHERE a2.component_guid = '00000000-0000-0000-0000-000000000000'
                ) c ON a.Assessment_Id = c.Assessment_Id AND a.Question_Id = c.Question_Id
                WHERE b.Answer_Id IS NOT NULL
                ORDER BY a.Symbol_Name, a.label, a.Component_Guid, a.Universal_Sub_Category
                """;

            var rawOverrides = await _context.Answer_Components_Overrides
                .FromSqlInterpolated(overrideSql)
                .AsNoTracking()
                .ToListAsync();

            var dlist = rawOverrides.Select(x => new Answer_Components_Base
            {
                UniqueKey = int.TryParse(x.UniqueKey, out var uk) ? uk : 0,
                Assessment_Id = x.Assessment_Id,
                Answer_Id = x.Answer_Id ?? 0,
                Question_Id = x.Question_Id,
                Answer_Text = x.Answer_Text,
                Comment = x.Comment,
                Alternate_Justification = x.Alternate_Justification,
                Question_Number = x.Question_Number,
                QuestionText = x.QuestionText,
                ComponentName = x.ComponentName,
                Symbol_Name = x.Symbol_Name,
                Question_Group_Heading = x.Question_Group_Heading,
                GroupHeadingId = x.GroupHeadingId ?? 0,
                Universal_Sub_Category = x.Universal_Sub_Category,
                SubCategoryId = x.SubCategoryId ?? 0,
                Is_Component = x.Is_Component,
                Component_Guid = x.Component_Guid,
                SAL = x.SAL,
                Mark_For_Review = x.Mark_For_Review,
                Is_Requirement = x.Is_Requirement ?? false,
                Is_Framework = x.Is_Framework ?? false,
                Reviewed = x.Reviewed,
                Simple_Question = x.Simple_Question,
                Sub_Heading_Question_Description = x.Sub_Heading_Question_Description,
                heading_pair_id = x.heading_pair_id ?? 0,
                Label = x.label,
                Component_Symbol_Id = x.Component_Symbol_Id,
                FeedBack = x.FeedBack
            }).ToList();

            AddResponseComponentOverride(resp, dlist, "Component Overrides");
        }


        /// <summary>
        ///
        /// </summary>
        /// <param name="resp"></param>
        /// <param name="context"></param>
        public void BuildOverridesOnly(QuestionResponse resp)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            // Get component overrides using scoped SQL to avoid cross-assessment view scan
            FormattableString overrideSql = $"""
                SELECT
                    CONVERT(nvarchar(100), ROW_NUMBER() OVER (ORDER BY a.Question_id)) AS UniqueKey,
                    a.Assessment_Id, b.Answer_Id, a.Question_Id,
                    ISNULL(b.Answer_Text, c.Answer_Text) AS Answer_Text,
                    CONVERT(nvarchar(1000), b.Comment) AS Comment,
                    CONVERT(nvarchar(1000), b.Alternate_Justification) AS Alternate_Justification,
                    b.FeedBack, b.Question_Number, a.Simple_Question AS QuestionText,
                    a.label AS ComponentName, a.Symbol_Name,
                    a.Question_Group_Heading, a.GroupHeadingId,
                    a.Universal_Sub_Category, a.SubCategoryId,
                    ISNULL(b.Is_Component, 1) AS Is_Component, a.Component_Guid,
                    a.Layer_Id, a.LayerName, a.Container_Id, a.ZoneName,
                    dbo.convert_sal(a.SAL) AS SAL,
                    b.Mark_For_Review,
                    CAST(0 AS bit) AS Is_Requirement,
                    CAST(0 AS bit) AS Is_Framework,
                    b.Reviewed, a.Simple_Question, a.Sub_Heading_Question_Description,
                    a.heading_pair_id, a.label, a.Component_Symbol_Id
                FROM (
                    SELECT
                        CONVERT(nvarchar(100), ROW_NUMBER() OVER (ORDER BY q.Question_id)) AS UniqueKey,
                        adc.Assessment_Id, q.Question_Id, q.Simple_Question,
                        adc.label, adc.Component_Symbol_Id,
                        h.Question_Group_Heading, usch.Question_Group_Heading_Id AS GroupHeadingId,
                        h.Universal_Sub_Category, usch.Universal_Sub_Category_Id AS SubCategoryId,
                        adc.Component_Guid, adc.Layer_Id, l.Name AS LayerName, z.Container_Id,
                        z.Name AS ZoneName,
                        dbo.convert_sal(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level)) AS SAL,
                        h.Sub_Heading_Question_Description, h.Heading_Pair_Id, cs.Symbol_Name
                    FROM ASSESSMENT_DIAGRAM_COMPONENTS adc
                    JOIN STANDARD_SELECTION ss ON adc.Assessment_Id = ss.Assessment_Id
                    JOIN COMPONENT_QUESTIONS cq ON adc.Component_Symbol_Id = cq.Component_Symbol_Id
                    JOIN COMPONENT_SYMBOLS cs ON adc.Component_Symbol_Id = cs.Component_Symbol_Id
                    JOIN NEW_QUESTION q ON cq.Question_Id = q.Question_Id
                    JOIN DIAGRAM_CONTAINER l ON adc.Layer_Id = l.Container_Id
                    LEFT JOIN DIAGRAM_CONTAINER z ON adc.Zone_Id = z.Container_Id
                    JOIN (
                        SELECT s.*, nql.Universal_Sal_Level
                        FROM NEW_QUESTION_SETS s
                        JOIN NEW_QUESTION_LEVELS nql ON s.New_Question_Set_Id = nql.New_Question_Set_Id
                        WHERE set_name = 'Components'
                    ) s ON q.Question_Id = s.Question_Id
                        AND s.Universal_Sal_Level = dbo.convert_sal_short(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level))
                    LEFT JOIN vQUESTION_HEADINGS h ON q.Heading_Pair_Id = h.Heading_Pair_Id
                    LEFT JOIN UNIVERSAL_SUB_CATEGORY_HEADINGS usch ON usch.Heading_Pair_Id = h.Heading_Pair_Id
                    WHERE l.Visible = 1 AND adc.Assessment_Id = {assessmentId}
                ) a
                LEFT JOIN Answer_Components b ON a.Question_Id = b.Question_Or_Requirement_Id
                    AND a.Assessment_Id = b.Assessment_Id
                    AND a.Component_Guid = b.Component_Guid
                LEFT JOIN (
                    SELECT a2.Assessment_Id, q.Question_Id, a2.Answer_Text
                    FROM (
                        SELECT DISTINCT q.question_id, adc.assessment_id
                        FROM ASSESSMENT_DIAGRAM_COMPONENTS adc
                        JOIN component_questions q ON adc.Component_Symbol_Id = q.Component_Symbol_Id
                        JOIN STANDARD_SELECTION ss ON adc.Assessment_Id = ss.Assessment_Id
                        JOIN new_question nq ON q.question_id = nq.question_id
                        JOIN new_question_sets qs ON nq.question_id = qs.question_id AND qs.Set_Name = 'Components'
                        JOIN NEW_QUESTION_LEVELS nql ON qs.New_Question_Set_Id = nql.New_Question_Set_Id
                            AND nql.Universal_Sal_Level = dbo.convert_sal(ss.Selected_Sal_Level)
                        WHERE adc.Assessment_Id = {assessmentId}
                    ) f
                    JOIN NEW_QUESTION q ON f.Question_Id = q.Question_Id
                    JOIN Answer_Components a2 ON f.Question_Id = a2.Question_Or_Requirement_Id
                        AND f.assessment_id = a2.assessment_id
                    WHERE a2.component_guid = '00000000-0000-0000-0000-000000000000'
                ) c ON a.Assessment_Id = c.Assessment_Id AND a.Question_Id = c.Question_Id
                WHERE b.Answer_Id IS NOT NULL
                ORDER BY a.Symbol_Name, a.label, a.Component_Guid, a.Universal_Sub_Category
                """;

            var rawOverrides = _context.Answer_Components_Overrides
                .FromSqlInterpolated(overrideSql)
                .AsNoTracking()
                .ToList();

            var dlist = rawOverrides.Select(x => new Answer_Components_Base
            {
                UniqueKey = int.TryParse(x.UniqueKey, out var uk) ? uk : 0,
                Assessment_Id = x.Assessment_Id,
                Answer_Id = x.Answer_Id ?? 0,
                Question_Id = x.Question_Id,
                Answer_Text = x.Answer_Text,
                Comment = x.Comment,
                Alternate_Justification = x.Alternate_Justification,
                Question_Number = x.Question_Number,
                QuestionText = x.QuestionText,
                ComponentName = x.ComponentName,
                Symbol_Name = x.Symbol_Name,
                Question_Group_Heading = x.Question_Group_Heading,
                GroupHeadingId = x.GroupHeadingId ?? 0,
                Universal_Sub_Category = x.Universal_Sub_Category,
                SubCategoryId = x.SubCategoryId ?? 0,
                Is_Component = x.Is_Component,
                Component_Guid = x.Component_Guid,
                SAL = x.SAL,
                Mark_For_Review = x.Mark_For_Review,
                Is_Requirement = x.Is_Requirement ?? false,
                Is_Framework = x.Is_Framework ?? false,
                Reviewed = x.Reviewed,
                Simple_Question = x.Simple_Question,
                Sub_Heading_Question_Description = x.Sub_Heading_Question_Description,
                heading_pair_id = x.heading_pair_id ?? 0,
                Label = x.label,
                Component_Symbol_Id = x.Component_Symbol_Id,
                FeedBack = x.FeedBack
            }).ToList();

            AddResponseComponentOverride(resp, dlist, "Component Overrides");
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="resp"></param>
        /// <param name="context"></param>
        /// <param name="list"></param>
        /// <param name="listname"></param>
        private void AddResponseComponentOverride(QuestionResponse resp, List<Answer_Components_Base> list, string listname)
        {
            List<QuestionGroup> groupList = new List<QuestionGroup>();
            QuestionGroup qg = new QuestionGroup();
            QuestionSubCategory sc = new QuestionSubCategory();
            QuestionAnswer qa = new QuestionAnswer();

            string symbolType = null;
            string componentName = null;
            string curGroupHeading = null;
            string curSubHeading = null;
            int prevQuestionId = 0;
            QuestionSubCategoryComparator comparator = new QuestionSubCategoryComparator();

            int displayNumber = 0;

            //push a new group if component_type, component_name, or question_group_heading changes

            foreach (var dbQ in list)
            {
                if ((dbQ.Symbol_Name != symbolType)
                    || (dbQ.ComponentName != componentName))
                {
                    componentName = Helpers.Utilities.RemoveHtmlTags(dbQ.ComponentName, true);

                    qg = new QuestionGroup()
                    {
                        GroupHeadingText = dbQ.Question_Group_Heading,
                        GroupHeadingId = dbQ.GroupHeadingId,
                        StandardShortName = listname,
                        Symbol_Name = dbQ.Symbol_Name,
                        ComponentName = componentName,
                        IsOverride = true

                    };
                    groupList.Add(qg);
                    symbolType = dbQ.Symbol_Name;

                    curGroupHeading = qg.GroupHeadingText;
                    // start numbering again in new group
                    displayNumber = 0;
                }

                // new subcategory -- break on pairing ID to separate 'base' and 'custom' pairings
                if ((dbQ.Universal_Sub_Category != curSubHeading) || (dbQ.Question_Id == prevQuestionId))
                {
                    // O(1) dictionary lookup instead of O(N) linear search
                    _subCatAnswersByHeadingId.TryGetValue(dbQ.heading_pair_id, out var subCatAnswer);

                    sc = new QuestionSubCategory()
                    {
                        GroupHeadingId = dbQ.GroupHeadingId,
                        SubCategoryId = dbQ.SubCategoryId,
                        SubCategoryHeadingText = dbQ.Universal_Sub_Category,
                        HeaderQuestionText = dbQ.Sub_Heading_Question_Description,
                        SubCategoryAnswer = subCatAnswer?.AnswerText
                    };

                    qg.SubCategories.Add(sc);
                    curSubHeading = dbQ.Universal_Sub_Category;
                }
                prevQuestionId = dbQ.Question_Id;
                qa = new QuestionAnswer()
                {
                    DisplayNumber = (++displayNumber).ToString(),
                    QuestionId = dbQ.Question_Id,
                    QuestionType = "Component",
                    QuestionText = dbQ.Simple_Question,
                    Answer = dbQ.Answer_Text,
                    Answer_Id = dbQ.Answer_Id,
                    AltAnswerText = dbQ.Alternate_Justification,
                    FreeResponseAnswer = dbQ.Free_Response_Answer,
                    Comment = dbQ.Comment,
                    MarkForReview = dbQ.Mark_For_Review ?? false,
                    Reviewed = dbQ.Reviewed ?? false,
                    Feedback = dbQ.FeedBack,
                    ComponentGuid = dbQ.Component_Guid ?? Guid.Empty
                };

                // O(1) dictionary lookup instead of O(N) linear search
                _answersByQuestionId.TryGetValue(qa.QuestionId, out var answer);
                if (answer != null)
                {
                    TinyMapper.Bind<VIEW_QUESTIONS_STATUS, QuestionAnswer>();
                    TinyMapper.Map(answer.b, qa);

                    // db view still uses the term "HasDiscovery" - map to "HasObservation"
                    qa.HasObservation = answer.b.HasDiscovery ?? false;
                }

                sc.Questions.Add(qa);
            }


            resp.Categories.AddRange(groupList);
            resp.QuestionCount += list.Count;
            resp.DefaultComponentsCount = list.Count;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="resp"></param>
        /// <param name="context"></param>
        /// <param name="list"></param>
        /// <param name="listname"></param>
        private void AddResponse(QuestionResponse resp, List<Answer_Components_Base> list, string listname)
        {
            List<QuestionGroup> groupList = new List<QuestionGroup>();
            QuestionGroup qg = new QuestionGroup();
            QuestionSubCategory sc = new QuestionSubCategory();
            QuestionAnswer qa = new QuestionAnswer();

            string curGroupHeading = null;
            int curHeadingPairId = 0;


            int displayNumber = 0;


            foreach (var dbQ in list)
            {
                if (dbQ.Question_Group_Heading != curGroupHeading)
                {
                    qg = new QuestionGroup()
                    {
                        GroupHeadingText = dbQ.Question_Group_Heading,
                        GroupHeadingId = dbQ.GroupHeadingId,
                        StandardShortName = listname,
                        Symbol_Name = dbQ.Symbol_Name,
                        ComponentName = dbQ.ComponentName
                    };
                    groupList.Add(qg);
                    curGroupHeading = qg.GroupHeadingText;
                    // start numbering again in new group
                    displayNumber = 0;
                }

                // new subcategory -- break on pairing ID to separate 'base' and 'custom' pairings
                if (dbQ.heading_pair_id != curHeadingPairId)
                {
                    // O(1) dictionary lookup instead of O(N) linear search
                    _subCatAnswersByHeadingId.TryGetValue(dbQ.heading_pair_id, out var subCatAnswer);

                    sc = new QuestionSubCategory()
                    {
                        GroupHeadingId = dbQ.GroupHeadingId,
                        SubCategoryId = dbQ.SubCategoryId,
                        SubCategoryHeadingText = dbQ.Universal_Sub_Category,
                        HeaderQuestionText = dbQ.Sub_Heading_Question_Description ?? string.Empty,
                        SubCategoryAnswer = subCatAnswer?.AnswerText
                    };

                    qg.SubCategories.Add(sc);

                    curHeadingPairId = dbQ.heading_pair_id;
                }

                qa = new QuestionAnswer()
                {
                    DisplayNumber = (++displayNumber).ToString(),
                    QuestionId = dbQ.Question_Id,
                    QuestionType = "Component",
                    QuestionText = dbQ.Simple_Question,
                    Answer = dbQ.Answer_Text,
                    Answer_Id = dbQ.Answer_Id,
                    AltAnswerText = dbQ.Alternate_Justification,
                    FreeResponseAnswer = dbQ.Free_Response_Answer,
                    Comment = dbQ.Comment,
                    MarkForReview = dbQ.Mark_For_Review ?? false,
                    Reviewed = dbQ.Reviewed ?? false,
                    ComponentGuid = dbQ.Component_Guid ?? Guid.Empty,
                    Feedback = dbQ.FeedBack
                };

                // O(1) dictionary lookup instead of O(N) linear search
                _answersByQuestionId.TryGetValue(qa.QuestionId, out var answer);
                if (answer != null)
                {
                    TinyMapper.Bind<VIEW_QUESTIONS_STATUS, QuestionAnswer>();
                    TinyMapper.Map(answer.b, qa);

                    // db view still uses the term "HasDiscovery" - map to "HasObservation"
                    qa.HasObservation = answer.b.HasDiscovery ?? false;
                }

                sc.Questions.Add(qa);
            }

            resp.Categories.AddRange(groupList);
            resp.QuestionCount += list.Count;
            resp.DefaultComponentsCount = list.Count;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="question_id"></param>
        /// <param name="Component_Symbol_Id"></param>
        /// <returns></returns>
        public List<Answer_Components_Exploded_ForJSON> GetOverrideQuestions(int assessmentId, int question_id, int Component_Symbol_Id)
        {
            List<Answer_Components_Exploded_ForJSON> rlist = new List<Answer_Components_Exploded_ForJSON>();

            var questionlist = _context.Answer_Components_Exploded
                .AsNoTracking()
                .Where(c => c.Assessment_Id == assessmentId
                    && c.Question_Id == question_id
                    && c.Component_Symbol_Id == Component_Symbol_Id)
                .Select(c => new usp_getExplodedComponent
                {
                    UniqueKey = c.UniqueKey,
                    Assessment_Id = c.Assessment_Id,
                    Answer_Id = c.Answer_Id,
                    Question_Id = c.Question_Id,
                    Answer_Text = c.Answer_Text,
                    Comment = c.Comment,
                    Alternate_Justification = c.Alternate_Justification,
                    Question_Number = c.Question_Number,
                    QuestionText = c.QuestionText,
                    ComponentName = c.ComponentName,
                    Component_Symbol_Id = c.Component_Symbol_Id,
                    Is_Component = c.Is_Component,
                    Component_GUID = c.Component_Guid,
                    Layer_Id = c.Layer_Id,
                    LayerName = c.LayerName,
                    Container_Id = c.Container_Id,
                    ZoneName = c.ZoneName,
                    SAL = c.SAL,
                    Mark_For_Review = c.Mark_For_Review,
                    Feedback = c.FeedBack
                })
                .ToList();

            foreach (var question in questionlist)
            {
                Answer_Components_Exploded_ForJSON tmp = null;
                TinyMapper.Bind<usp_getExplodedComponent, Answer_Components_Exploded_ForJSON>();
                tmp = TinyMapper.Map<Answer_Components_Exploded_ForJSON>(question);
                tmp.Component_GUID = question.Component_GUID.ToString();
                rlist.Add(tmp);
            }

            return rlist;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public QuestionResponse GetOverrideListOnly()
        {
            QuestionResponse resp = new QuestionResponse
            {
                ApplicationMode = this.ApplicationMode
            };

            resp.Categories = new List<QuestionGroup>();
            resp.QuestionCount = 0;
            resp.RequirementCount = 0;

            BuildOverridesOnly(resp);
            return resp;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="answer"></param>
        /// <returns></returns>
        public Answer StoreAnswer(Answer answer)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            // Find the Question or Requirement
            var question = _context.NEW_QUESTION.Where(q => q.Question_Id == answer.QuestionId).FirstOrDefault();

            if (question == null)
            {
                throw new Exception("Unknown question or requirement ID: " + answer.QuestionId);
            }

            // in case a null is passed, store 'unanswered'
            if (string.IsNullOrEmpty(answer.AnswerText))
            {
                answer.AnswerText = "U";
            }

            int answerId;

            ANSWER dbAnswer = null;
            if (answer != null)
            {
                dbAnswer = _context.ANSWER.Where(x => x.Assessment_Id == assessmentId
                            && x.Question_Or_Requirement_Id == answer.QuestionId
                            && x.Is_Requirement == false && x.Component_Guid == answer.ComponentGuid).FirstOrDefault();
            }


            if (dbAnswer == null)
            {
                dbAnswer = new ANSWER();
                dbAnswer.Assessment_Id = assessmentId;
                dbAnswer.Answer_Text = "U";
                dbAnswer.Question_Type = "Component";

                _context.ANSWER.Add(dbAnswer);
                _context.SaveChanges();
                answerId = dbAnswer.Answer_Id;
            }
            else
            {
                answerId = dbAnswer.Answer_Id;
            }

            dbAnswer.Answer_Id = answerId;
            dbAnswer.Question_Or_Requirement_Id = answer.QuestionId;
            dbAnswer.Question_Number = int.Parse(answer.QuestionNumber);
            dbAnswer.Is_Requirement = false;
            dbAnswer.Answer_Text = answer.AnswerText;
            dbAnswer.Alternate_Justification = answer.AltAnswerText;
            dbAnswer.Free_Response_Answer = answer.FreeResponseAnswer;
            dbAnswer.Comment = answer.Comment;
            dbAnswer.FeedBack = answer.Feedback;
            dbAnswer.Mark_For_Review = answer.MarkForReview;
            dbAnswer.Reviewed = answer.Reviewed;
            dbAnswer.Component_Guid = answer.ComponentGuid;
            dbAnswer.Is_Component = true;

            _context.ANSWER.Update(dbAnswer);
            _context.SaveChanges();

            answer.AssessmentId = dbAnswer.Assessment_Id;
            answer.AnswerId = dbAnswer.Answer_Id;

            _assessmentUtil.TouchAssessment(assessmentId);

            return answer;
        }


        /// <summary>
        /// get the exploded view where assessment
        /// </summary>
        /// <param name="guid"></param>
        /// <param name="shouldSave"></param>
        public void HandleGuid(Guid guid, bool shouldSave)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            if (shouldSave)
            {
                var componentName = _context.ASSESSMENT_DIAGRAM_COMPONENTS.Where(x => x.Component_Guid == guid).FirstOrDefault();
                if (componentName != null)
                {
                    var creates = from a in _context.COMPONENT_QUESTIONS
                                  where a.Component_Symbol_Id == componentName.Component_Symbol_Id
                                  select a;

                    var alreadyThere = (from a in _context.ANSWER
                                        where a.Assessment_Id == assessmentId
                                        && a.Component_Guid == guid
                                        select a).ToDictionary(x => x.Question_Or_Requirement_Id, x => x);

                    foreach (var c in creates.ToList())
                    {
                        if (!alreadyThere.ContainsKey(c.Question_Id))
                        {
                            _context.ANSWER.Add(new ANSWER()
                            {
                                Answer_Text = Constants.Constants.UNANSWERED,
                                Assessment_Id = assessmentId,
                                Component_Guid = guid,
                                Question_Type = "Component",
                                Is_Component = true,
                                Is_Requirement = false,
                                Question_Or_Requirement_Id = c.Question_Id
                            });
                        }
                    }

                    _context.SaveChanges();
                }
                else
                {
                    throw new ApplicationException("could not find component for guid:" + guid);
                }
            }
            else
            {
                foreach (var a in _context.ANSWER.Where(x => x.Component_Guid == guid).ToList())
                {
                    _context.ANSWER.Remove(a);
                }

                _context.SaveChanges();
            }
        }
    }
}
