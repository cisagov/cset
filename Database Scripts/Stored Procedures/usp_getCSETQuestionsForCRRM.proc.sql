-- =============================================
-- Author:		hansbk
-- Create date: 8/15/2023
-- Description:	gets the general questions regardless of maturity,new_question,or new_requirement
-- =============================================

--exec usp_getCSETQuestionsForCRRM 'SD02 Series'
CREATE PROCEDURE [dbo].[usp_getCSETQuestionsForCRRM]
	-- Add the parameters for the stored procedure here
	@setname varchar(100)		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select AssessmentMode='question', q.Std_Ref_Id as title ,   q.question_id as Id,Simple_Question as question
	,r.Supplemental_Info as Info
	,h.Question_Group_Heading as Heading,h.Universal_Sub_Category as SubHeading,Set_Name as SetName, IsComplete=cast(0 as bit), CRRMId = 0
	from NEW_QUESTION q 
	join REQUIREMENT_QUESTIONS_SETS s on q.Question_Id=s.Question_Id
	join NEW_REQUIREMENT r on s.Requirement_Id=r.Requirement_Id
	join vQUESTION_HEADINGS h on q.Heading_Pair_Id=h.Heading_Pair_Id
	where s.Set_Name = @setname
	union
	select AssessmentMode='requirement', r.Requirement_Title as title,  r.Requirement_Id as Id, r.Requirement_Text as question,r.Supplemental_Info as Info,r.Standard_Category as Heading,r.Standard_Sub_Category as SubHeading,s.Set_Name as setname , IsComplete
=cast(0 as bit), CRRMId = 0
	from REQUIREMENT_QUESTIONS_SETS s
	join NEW_REQUIREMENT r on s.Requirement_Id=r.Requirement_Id
	where s.Set_Name = @setname
	union
	select AssessmentMode='maturity', Question_Title as title, mat_question_id as Id ,Question_Text as queestion,Supplemental_Info as Info,g.Title as Heading, Question_Title as SubHeading, m.Model_Name as setname, IsComplete=cast(0 as bit), CRRMId = 0
	from MATURITY_QUESTIONS q 
	join MATURITY_GROUPINGS g on q.Grouping_Id=g.Grouping_Id
	join MATURITY_MODELS m on q.Maturity_Model_Id=m.Maturity_Model_Id and g.Maturity_Model_Id=m.Maturity_Model_Id
	where m.Model_Name = @setname
END
