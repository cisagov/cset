-- =============================================
-- Author:		Dylan Johnson
-- Create date: 10/04/2020
-- Description:	Create empty data for questions that have not been filled out to ensure correct reporting values
-- =============================================
CREATE PROCEDURE [dbo].[FillEmptyMaturityQuestionsForAnalysis]
	@Assessment_Id int	
AS
BEGIN	
	DECLARE @result int;  
	begin
	BEGIN TRANSACTION;  
	EXEC @result = sp_getapplock @DbPrincipal = 'dbo', @Resource = '[Answer]', @LockMode = 'Exclusive';
	INSERT INTO [dbo].[ANSWER]  ([Is_Requirement],[Question_Or_Requirement_Id],[Answer_Text],[Is_Component],[Is_Framework],[Is_Maturity],[Assessment_Id])     
		select Is_Requirement=0,mq.Mat_Question_Id,Answer_Text = 'U', Is_Component='0',Is_Framework=0, Is_Maturity=1, Assessment_Id =@Assessment_Id
		from [CSETWeb].[dbo].[MATURITY_QUESTIONS] mq
			where Maturity_Model_Id in
			(select model_id from [CSETWeb].[dbo].[AVAILABLE_MATURITY_MODELS]
			where Assessment_Id = @Assessment_Id) 
			and Mat_Question_Id not in 
			(select Question_Or_Requirement_Id from [CSETWeb].[dbo].[ANSWER] 
			where Assessment_Id = @Assessment_Id)
		IF @result = -3  
		BEGIN  
			ROLLBACK TRANSACTION;  
		END  
		ELSE  
		BEGIN  
			EXEC sp_releaseapplock @DbPrincipal = 'dbo', @Resource = '[Answer]'; 	
			COMMIT TRANSACTION;  
		END
	end

END
