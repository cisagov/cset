
-- =============================================
-- Author:		Mitch Carroll
-- Create date: 9 Aug 2018
-- Description:	Ranked Questions
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetRankedQuestions]
@assessment_id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	EXECUTE [dbo].[FillEmptyQuestionsForAnalysis]  @Assessment_Id

	-- get the application mode
	declare @applicationMode nvarchar(50)
	exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output

	-- get currently selected sets
	IF OBJECT_ID('tempdb..#mySets') IS NOT NULL DROP TABLE #mySets
	select set_name into #mySets from AVAILABLE_STANDARDS where Assessment_Id = @assessment_Id and Selected = 1
	

	if(@ApplicationMode = 'Questions Based')	
	begin
		SELECT Short_Name as [Standard], 
			Question_Group_Heading as [Category], 
			ROW_NUMBER() over (order by c.ranking asc) as [Rank], 
			Simple_Question as [QuestionText], 
			c.Question_Id as [QuestionId],
			null as [RequirementId],
			a.Answer_ID as [AnswerID],
			Answer_Text as [AnswerText], 
			c.Universal_Sal_Level as [Level], 
			CONVERT(varchar(10), a.Question_Number) as [QuestionRef],
			a.Question_Or_Requirement_Id as [QuestionOrRequirementID]
			FROM Answer_Questions a 
			join NEW_QUESTION c on a.Question_Or_Requirement_Id = c.Question_Id
			join vQuestion_Headings h on c.Heading_Pair_Id = h.heading_pair_Id		
			join (
				select distinct s.question_id, ns.Short_Name from NEW_QUESTION_SETS s 
					join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
					join SETS ns on s.Set_Name = ns.Set_Name
					join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id
					join STANDARD_SELECTION ss on v.Assessment_Id = ss.Assessment_Id
					join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
					where v.Selected = 1 and v.Assessment_Id = @assessment_id and l.Universal_Sal_Level = ul.Universal_Sal_Level
			)	s on c.Question_Id = s.Question_Id		
			where a.Assessment_Id = @assessment_id and a.Answer_Text in ('N','U')
			order by c.Ranking		
	end
	else
	begin
		SELECT Short_Name [standard], 
			Standard_Category as [Category], 
			ROW_NUMBER() over (order by req.ranking asc) as [Rank], 
			Requirement_Text as [QuestionText], 
			null as [QuestionId],
			req.Requirement_Id as [RequirementId],
			Answer_Id as [AnswerID],
			Answer_Text as [AnswerText], 
			u.Universal_Sal_Level as [Level], 
			requirement_title as [QuestionRef],
			rs.Requirement_Id as [QuestionOrRequirementID]
			from REQUIREMENT_SETS rs
				left join ANSWER ans on ans.Question_Or_Requirement_Id = rs.Requirement_Id
				left join [SETS] s on rs.Set_Name = s.Set_Name
				left join NEW_REQUIREMENT req on rs.Requirement_Id = req.Requirement_Id
				left join REQUIREMENT_LEVELS rl on rl.Requirement_Id = req.Requirement_Id		
				left join STANDARD_SELECTION ss on ss.Assessment_Id = @assessment_Id
				left join UNIVERSAL_SAL_LEVEL u on u.Full_Name_Sal = ss.Selected_Sal_Level
			where rs.Set_Name in (select set_name from #mySets)
			and ans.Assessment_Id = @assessment_id
			and rl.Standard_Level = u.Universal_Sal_Level and ans.Answer_Text in ('N','U')
			order by req.Ranking		
	end
END
