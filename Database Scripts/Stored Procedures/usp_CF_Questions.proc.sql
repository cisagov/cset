-- =============================================
-- Author:		Matt Winston
-- Create date: 11/8/24
-- Description:	All questions and their scores
-- =============================================
CREATE PROCEDURE [dbo].[usp_CF_Questions]
	@Assessment_Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select Standard_Category, Standard_Sub_Category, requirement_text, Requirement_Title, Answer_Value, Display_Tag from (
	select r.Standard_Category, r.Standard_Sub_Category, r.requirement_text, r.Requirement_Title, 	
	cast(case when a.Answer_Text = 'U' then 0 else a.Answer_Text end as int) as Answer_Value,
	s.requirement_sequence
	from NEW_REQUIREMENT r
	join REQUIREMENT_SETS s on r.Requirement_Id = s.Requirement_Id
	join ANSWER a on s.Requirement_Id = a.Question_Or_Requirement_Id and a.Is_Requirement = 1
	where s.Set_Name = 'NCSF_V2' and a.Assessment_Id = @Assessment_Id) a
	join NCSF_INDEX_ANSWERS n on Answer_Value = n.Raw_Answer_Value
	order by Requirement_Sequence
	
End







