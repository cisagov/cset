
-- =============================================
-- Author:		Randy Woods
-- Create date: 09/10/2024
-- Description:	Create empty data for questions that have not been filled out.
--              This version of the proc is designed for deliberately fleshing out SSG questions
--              because their relevance is not determined by AVAILABLE_MATURITY_MODELS.
-- =============================================
CREATE PROCEDURE [dbo].[FillEmptyMaturityQuestionsForModel]
	@Assessment_Id int,
	@Model_Id int
AS
BEGIN	
	DECLARE @result int;  
	begin
	BEGIN TRANSACTION;  
	EXEC @result = sp_getapplock @Resource = '[Answer]', @LockMode = 'Exclusive';
	INSERT INTO [dbo].[ANSWER]  ([Question_Or_Requirement_Id],[Answer_Text],[Question_Type],[Assessment_Id])     
		select mq.Mat_Question_Id,Answer_Text = 'U', Question_Type='Maturity', Assessment_Id = @Assessment_Id
		from [dbo].[MATURITY_QUESTIONS] mq
			where Maturity_Model_Id = @Model_Id
			and Mat_Question_Id not in 
			(select Question_Or_Requirement_Id from [dbo].[ANSWER] 
			where Assessment_Id = @Assessment_Id and Maturity_Model_Id = @Model_Id)
		IF @result = -3  
		BEGIN  
			ROLLBACK TRANSACTION;  
		END  
		ELSE  
		BEGIN  
			EXEC sp_releaseapplock @Resource = '[Answer]'; 	
			COMMIT TRANSACTION;  
		END
	end

END
/****** Object:  StoredProcedure [dbo].[FillEmptyQuestionsForAnalysis]    Script Date: 12/16/2020 11:01:33 AM ******/
SET ANSI_NULLS ON
