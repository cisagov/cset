-- =============================================
-- Author:		hansbk (Fixed to handle requirements)
-- Create date: 1/27/2020
-- Modified: 2/16/2026 - Added support for requirements
-- Description:	get the percentages for each area
-- line up the assessmen
ts 
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetTop5Areas]
	@Aggregation_id int
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON;

	-- Execute trend order setup
	EXEC usp_setTrendOrder @aggreg
ation_id
	
	-- Declare variables
	DECLARE @assessment1 int, @assessment2 int
	SET @assessment1 = NULL;
	SET @assessment2 = NULL; 

	-- Drop temp tables if they exist
	IF OBJECT_ID('tempdb..#answers') IS NOT NULL DROP TABLE #answers
	IF OBJECT_ID('tempdb..
#TopBottomType') IS NOT NULL DROP TABLE #TopBottomType
	
	-- Create temp tables
	CREATE TABLE #TopBottomType(
		[Question_Group_Heading] [nvarchar](100) NOT NULL,
		[pdifference] [float] NULL,
		[TopBottomType] [nvarchar](10) NOT NULL
	)

	CREATE TABLE #a
nswers (
		assessment_id int, 
		answer_id int, 
		is_requirement bit, 
		question_or_requirement_id int, 
		mark_for_review bit, 
		comment ntext, 
		alternate_justification ntext, 
		question_number int, 
		answer_text nvarchar(50), 
		component_guid nv
archar(36), 
		is_component bit, 
		custom_question_guid nvarchar(50), 
		is_framework bit, 
		old_answer_id int, 
		reviewed bit
	)

	-- Cursor to get assessments
	DECLARE sse CURSOR FOR 
	SELECT Assessment_Id 
	FROM AGGREGATION_ASSESSMENT 
	WHERE Aggreg
ation_Id = @Aggregation_id
	ORDER BY Sequence DESC
	
	DECLARE @assessment_id int

	OPEN sse
	FETCH NEXT FROM sse INTO @assessment_id 
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		IF (@assessment1 IS NULL) SET @assessment1 = @assessment_id 

		INSERT INTO #answers 
EXEC [GetRelevantAnswers] @assessment_id		
		
		FETCH NEXT FROM sse INTO @assessment_id 
		IF(@assessment2 IS NULL) SET @assessment2 = @assessment_id
	END
	CLOSE sse 
	DEALLOCATE sse
	
	-- Validate we have at least 2 assessments
	IF @assessment1 IS NULL O
R @assessment2 IS NULL
	BEGIN
		SELECT 'Error: Need at least 2 assessments for comparison' AS ErrorMessage
		RETURN
	END

	-- Calculate differences and insert into temp table
	INSERT INTO #TopBottomType(Question_Group_Heading, pdifference, TopBottomType)
	SELECT  
		assessment1.Question_Group_Heading,
		assessment1.percentage - assessment2.percentage AS pdifference,
		'None' AS TopBottomType
	FROM (
		-- Assessment 1 percentages
		SELECT 
			a.Assessment_Id,
			a.Question_Group_Heading,
			a.YesCount,
			
a.NoCount,
			a.NaCount,
			a.AlternateCount,
			a.UnansweredCount,
			b.Total, 
			(ISNULL(YesCount,0) + ISNULL(AlternateCount,0)) / CAST(Total AS FLOAT) AS percentage  
		FROM (
			SELECT 
				Assessment_Id, 
				Question_Group_Heading,
				[Y] AS [YesC
ount],			
				[N] AS [NoCount],
				[NA] AS [NaCount],
				[A] AS [AlternateCount],
				[U] AS [UnansweredCount]			
			FROM (
				-- FIXED: Handle both questions and requirements
				SELECT 
					Assessment_Id, 
					h.Question_Group_Heading, 
					Answer
_Text			 
				FROM #answers a 
				LEFT JOIN NEW_QUESTION q ON a.Question_Or_Requirement_Id = q.Question_Id AND a.is_requirement = 0
				LEFT JOIN NEW_REQUIREMENT r ON a.Question_Or_Requirement_Id = r.Requirement_Id AND a.is_requirement = 1
				JOIN vQUES
TION_HEADINGS h ON 
					(a.is_requirement = 0 AND q.Heading_Pair_Id = h.Heading_Pair_Id) OR
					(a.is_requirement = 1 AND r.Question_Group_Heading_Id = h.Question_Group_Heading_Id)
				WHERE answer_text <> 'NA'
			) p
			PIVOT (
				COUNT(Answer_Text)
	
			FOR Answer_Text IN ([Y],[N],[NA],[A],[U])
			) AS pvt 
			WHERE Assessment_Id IS NOT NULL
		) a 
		JOIN (
			SELECT 
				Assessment_Id, 
				h.Question_Group_Heading, 
				COUNT(answer_text) AS Total 	
			FROM #answers a 
			LEFT JOIN NEW_QUESTION q ON
 a.Question_Or_Requirement_Id = q.Question_Id AND a.is_requirement = 0
			LEFT JOIN NEW_REQUIREMENT r ON a.Question_Or_Requirement_Id = r.Requirement_Id AND a.is_requirement = 1
			JOIN vQUESTION_HEADINGS h ON 
				(a.is_requirement = 0 AND q.Heading_Pair
_Id = h.Heading_Pair_Id) OR
				(a.is_requirement = 1 AND r.Question_Group_Heading_Id = h.Question_Group_Heading_Id)
			WHERE answer_text <> 'NA' AND assessment_id = @assessment1
			GROUP BY Assessment_Id, h.Question_Group_Heading
		) b ON a.assessment_id
 = b.assessment_id AND a.Question_Group_Heading = b.Question_Group_Heading
	) assessment1 
	JOIN (
		-- Assessment 2 percentages (same logic)
		SELECT 
			a.Assessment_Id,
			a.Question_Group_Heading,
			a.YesCount,
			a.NoCount,
			a.NaCount,
			a.Altern
ateCount,
			a.UnansweredCount,
			b.Total, 
			(ISNULL(YesCount,0) + ISNULL(AlternateCount,0)) / CAST(Total AS FLOAT) AS percentage  
		FROM (
			SELECT 
				Assessment_Id, 
				Question_Group_Heading,
				[Y] AS [YesCount],			
				[N] AS [NoCount],
				
[NA] AS [NaCount],
				[A] AS [AlternateCount],
				[U] AS [UnansweredCount]			
			FROM (
				SELECT 
					Assessment_Id, 
					h.Question_Group_Heading, 
					Answer_Text			 
				FROM #answers a 
				LEFT JOIN NEW_QUESTION q ON a.Question_Or_Requirement_
Id = q.Question_Id AND a.is_requirement = 0
				LEFT JOIN NEW_REQUIREMENT r ON a.Question_Or_Requirement_Id = r.Requirement_Id AND a.is_requirement = 1
				JOIN vQUESTION_HEADINGS h ON 
					(a.is_requirement = 0 AND q.Heading_Pair_Id = h.Heading_Pair_Id)
 OR
					(a.is_requirement = 1 AND r.Question_Group_Heading_Id = h.Question_Group_Heading_Id)
				WHERE answer_text <> 'NA'
			) p
			PIVOT (
				COUNT(Answer_Text)
				FOR Answer_Text IN ([Y],[N],[NA],[A],[U])
			) AS pvt 
			WHERE Assessment_Id IS NOT N
ULL
		) a 
		JOIN (
			SELECT 
				Assessment_Id, 
				h.Question_Group_Heading, 
				COUNT(answer_text) AS Total 	
			FROM #answers a 
			LEFT JOIN NEW_QUESTION q ON a.Question_Or_Requirement_Id = q.Question_Id AND a.is_requirement = 0
			LEFT JOIN NEW_R
EQUIREMENT r ON a.Question_Or_Requirement_Id = r.Requirement_Id AND a.is_requirement = 1
			JOIN vQUESTION_HEADINGS h ON 
				(a.is_requirement = 0 AND q.Heading_Pair_Id = h.Heading_Pair_Id) OR
				(a.is_requirement = 1 AND r.Question_Group_Heading_Id = h
.Question_Group_Heading_Id)
			WHERE answer_text <> 'NA' AND assessment_id = @assessment2
			GROUP BY Assessment_Id, h.Question_Group_Heading
		) b ON a.assessment_id = b.assessment_id AND a.Question_Group_Heading = b.Question_Group_Heading
	) assessment2
 ON assessment1.Question_Group_Heading = assessment2.Question_Group_Heading
	ORDER BY pdifference DESC

	-- Mark bottom 5 (most declined)
	UPDATE #TopBottomType 
	SET TopBottomType = 'BOTTOM' 
	FROM (
		SELECT TOP 5 Question_Group_Heading 
		FROM #TopBott
omType 
		ORDER BY pdifference
	) a
	WHERE #TopBottomType.Question_Group_Heading = a.Question_Group_Heading

	-- Mark top 5 (most improved - only positive changes)
	UPDATE #TopBottomType 
	SET TopBottomType = 'TOP' 
	FROM (
		SELECT TOP 5 Question_Group_H
eading 
		FROM #TopBottomType 
		WHERE pdifference >= 0
		ORDER BY pdifference DESC
	) a
	WHERE #TopBottomType.Question_Group_Heading = a.Question_Group_Heading

	-- Final result set
	SELECT 
		a.Assessment_Id,
		a.Question_Group_Heading,
		a.YesCount,
		
a.NoCount,
		a.NaCount,
		a.AlternateCount,
		a.UnansweredCount,
		b.Total, 
		((ISNULL(YesCount,0) + ISNULL(AlternateCount,0)) / CAST(Total AS FLOAT)) * 100 AS percentage,
		#TopBottomType.pdifference, 
		TopBottomType,
		Assessment_Date
	FROM (
		SELECT
 
			Assessment_Id, 
			Question_Group_Heading,
			[Y] AS [YesCount],			
			[N] AS [NoCount],
			[NA] AS [NaCount],
			[A] AS [AlternateCount],
			[U] AS [UnansweredCount]			
		FROM (
			SELECT 
				Assessment_Id, 
				h.Question_Group_Heading, 
				Answe
r_Text			 
			FROM #answers a 
			LEFT JOIN NEW_QUESTION q ON a.Question_Or_Requirement_Id = q.Question_Id AND a.is_requirement = 0
			LEFT JOIN NEW_REQUIREMENT r ON a.Question_Or_Requirement_Id = r.Requirement_Id AND a.is_requirement = 1
			JOIN vQUESTIO
N_HEADINGS h ON 
				(a.is_requirement = 0 AND q.Heading_Pair_Id = h.Heading_Pair_Id) OR
				(a.is_requirement = 1 AND r.Question_Group_Heading_Id = h.Question_Group_Heading_Id)
			WHERE answer_text <> 'NA'
		) p
		PIVOT (
			COUNT(Answer_Text)
			FOR Ans
wer_Text IN ([Y],[N],[NA],[A],[U])
		) AS pvt 
		WHERE Assessment_Id IS NOT NULL
	) a 
	JOIN (
		SELECT 
			Assessment_Id, 
			h.Question_Group_Heading, 
			COUNT(answer_text) AS Total 	
		FROM #answers a 
		LEFT JOIN NEW_QUESTION q ON a.Question_Or_Requi
rement_Id = q.Question_Id AND a.is_requirement = 0
		LEFT JOIN NEW_REQUIREMENT r ON a.Question_Or_Requirement_Id = r.Requirement_Id AND a.is_requirement = 1
		JOIN vQUESTION_HEADINGS h ON 
			(a.is_requirement = 0 AND q.Heading_Pair_Id = h.Heading_Pair_Id
) OR
			(a.is_requirement = 1 AND r.Question_Group_Heading_Id = h.Question_Group_Heading_Id)
		WHERE answer_text <> 'NA'
		GROUP BY Assessment_Id, h.Question_Group_Heading
	) b ON a.assessment_id = b.assessment_id AND a.Question_Group_Heading = b.Question
_Group_Heading 
	JOIN #TopBottomType ON b.Question_Group_Heading = #TopBottomType.Question_Group_Heading
	JOIN ASSESSMENTS ON a.assessment_id = assessments.Assessment_Id
	WHERE #TopBottomType.TopBottomType IN ('TOP','BOTTOM')  -- FIXED: Case sensitivity
	
ORDER BY TopBottomType DESC, pdifference DESC, Question_Group_Heading, Assessment_Date, Assessment_Id
	
END
