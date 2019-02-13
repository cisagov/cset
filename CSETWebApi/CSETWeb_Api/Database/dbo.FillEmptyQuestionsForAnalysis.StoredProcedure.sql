USE [CSETWeb]
GO
/****** Object:  StoredProcedure [dbo].[FillEmptyQuestionsForAnalysis]    Script Date: 11/14/2018 3:57:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		hansbk
-- Create date: 7/9/2018
-- Description:	CopyData
-- =============================================
CREATE PROCEDURE [dbo].[FillEmptyQuestionsForAnalysis]
	-- Add the parameters for the stored procedure here
	@Assessment_Id int	
AS
BEGIN	
	--SET NOCOUNT ON;
	--get the list of selected standards
	--get the mode
	--for the given mode 
	--select the new_questions_sets or requirement_sets table with left join answers (possibly on the view)
	-- and do the insert
	declare @ApplicationMode varchar(100)
	declare @SALevel varchar(10)
	declare @NumRowsChanged int

	select @SALevel = ul.Universal_Sal_Level from STANDARD_SELECTION ss join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
	where @Assessment_Id = @Assessment_Id 

	exec GetApplicationModeDefault @assessment_id,@applicationmode output
	if(@ApplicationMode = 'Questions Based')
		begin
			
		INSERT INTO [dbo].[ANSWER]  ([Is_Requirement],[Question_Or_Requirement_Id],[Component_Id]
           ,[Answer_Text],[Is_Component],[Is_Framework],[Assessment_Id])     
		select Is_Requirement=0,s.Question_id,Component_Id =0, Answer_Text = 'U', Is_Component='0',Is_Framework=0, Assessment_Id =@Assessment_Id
			from (select distinct s.Question_Id from NEW_QUESTION_SETS s 
				join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
				join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.new_question_set_id
				where v.Selected = 1 and v.Assessment_Id = @assessment_id and l.Universal_Sal_Level = @SALevel) s
			left join (select * from ANSWER where Assessment_Id = @Assessment_Id and Is_Requirement = 0) a on s.Question_Id = a.Question_Or_Requirement_Id
		where a.Question_Or_Requirement_Id is null
		if(@@ROWCOUNT>0) 
			begin 			
			exec usp_BuildCatNumbers @assessment_id
			end
		end
	else
	begin
		INSERT INTO [dbo].[ANSWER]  ([Is_Requirement],[Question_Or_Requirement_Id],[Component_Id]
           ,[Answer_Text],[Is_Component],[Is_Framework],[Assessment_Id])     
		select distinct Is_Requirement=1,s.Requirement_Id,Component_Id =0, Answer_Text = 'U', Is_Component='0',Is_Framework=0,av.Assessment_Id 
			from requirement_sets s 
			join AVAILABLE_STANDARDS av on s.Set_Name=av.Set_Name
			join REQUIREMENT_LEVELS rl on s.Requirement_Id = rl.Requirement_Id
			left join (select * from ANSWER where Assessment_Id = @Assessment_Id and Is_Requirement = 1) a on s.Requirement_Id = a.Question_Or_Requirement_Id
		where av.Selected = 1 and av.Assessment_Id = @Assessment_Id and a.Question_Or_Requirement_Id is null and rl.Standard_Level = @SALevel and rl.Level_Type = 'NST'
		if(@@ROWCOUNT>0) exec usp_BuildCatNumbers @assessment_id
	end   
	
END


GO
