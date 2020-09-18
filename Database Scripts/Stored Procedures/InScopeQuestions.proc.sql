
-- =============================================
-- Author:		Randy Woods
-- Create date: 15-May-2020
-- Description:	Returns a list of Question IDs that are
--              'in scope' for an Assessment.
-- =============================================
CREATE PROCEDURE [dbo].[InScopeQuestions]
	@assessment_id int
AS
BEGIN
select distinct s.Question_Id 
	from NEW_QUESTION_SETS s 
	join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
	join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.new_question_set_id
	where v.Selected = 1 and v.Assessment_Id = @assessment_id 
	and l.Universal_Sal_Level = (
		select ul.Universal_Sal_Level from STANDARD_SELECTION ss join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
		where Assessment_Id = @assessment_id 
	)
END

