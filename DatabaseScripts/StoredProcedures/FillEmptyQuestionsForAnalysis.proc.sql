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
	declare @ApplicationMode nvarchar(100)
	declare @SALevel nvarchar(10)
	declare @NumRowsChanged int

	select @SALevel = ul.Universal_Sal_Level from STANDARD_SELECTION ss join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
	where @Assessment_Id = @Assessment_Id 

	DECLARE @result int;  
	exec GetApplicationModeDefault @assessment_id, @applicationmode output
	if(@ApplicationMode = 'Questions Based')
		BEGIN
			BEGIN TRANSACTION;  
		
			EXEC @result = sp_getapplock @Resource = '[Answer]', @LockMode = 'Exclusive';  
				INSERT INTO [dbo].[ANSWER]  ([Question_Or_Requirement_Id], [Answer_Text], [Question_Type], [Assessment_Id])     
			select s.Question_id, Answer_Text = 'U', Question_Type='Question', Assessment_Id = @Assessment_Id
				from (select distinct s.Question_Id from NEW_QUESTION_SETS s 
					join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
					join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.new_question_set_id
					where v.Selected = 1 and v.Assessment_Id = @assessment_id and l.Universal_Sal_Level = @SALevel) s
				left join (select * from ANSWER where Assessment_Id = @Assessment_Id and Is_Requirement = 0) a on s.Question_Id = a.Question_Or_Requirement_Id
			where a.Question_Or_Requirement_Id is null
			IF @result = -3  
			BEGIN  
				ROLLBACK TRANSACTION;  
			END  
			ELSE  
			BEGIN  
				EXEC sp_releaseapplock @Resource = '[Answer]'; 	
				COMMIT TRANSACTION;  
			END;  

			EXEC usp_BuildCatNumbers @assessment_id
		END
	else
	BEGIN
		BEGIN TRANSACTION;  		
		EXEC @result = sp_getapplock @Resource = '[Answer]', @LockMode = 'Exclusive';  
		INSERT INTO [dbo].[ANSWER]  ([Question_Or_Requirement_Id], 
           [Answer_Text], [Question_Type], [Assessment_Id])     
		select distinct s.Requirement_Id, Answer_Text = 'U', Question_Type='Requirement', av.Assessment_Id 
			from requirement_sets s 
			join AVAILABLE_STANDARDS av on s.Set_Name = av.Set_Name
			join REQUIREMENT_LEVELS rl on s.Requirement_Id = rl.Requirement_Id
			left join (select * from ANSWER where Assessment_Id = @Assessment_Id and Question_Type='Requirement') a on s.Requirement_Id = a.Question_Or_Requirement_Id
		where av.Selected = 1 and av.Assessment_Id = @Assessment_Id and a.Question_Or_Requirement_Id is null and rl.Standard_Level = @SALevel and rl.Level_Type = 'NST'
			IF @result = -3  
		BEGIN  
			ROLLBACK TRANSACTION;  
		END  
		ELSE  
		BEGIN  
			EXEC sp_releaseapplock @Resource = '[Answer]'; 	
			COMMIT TRANSACTION;  
		END;  
		
		EXEC usp_BuildCatNumbers @assessment_id
	END   
	
END
/****** Object:  StoredProcedure [dbo].[FillNetworkDiagramQuestions]    Script Date: 12/16/2020 11:01:45 AM ******/
SET ANSI_NULLS ON
