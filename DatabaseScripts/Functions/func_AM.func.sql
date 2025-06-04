-- =============================================
-- Author:		Randy Woods
-- Create date: 10-OCT-2023
-- Description:	Returns all applicable rows from the ANSWER_MATURITY view.
--              If the assessment has a "sub model" defined, only the answers
--              for the sub model are returned.  Otherwise all maturity answers
--              are returned for the assessment.
-- =============================================
CREATE FUNCTION [dbo].[func_AM]
(	
	@assessmentId int
)
RETURNS  @AM TABLE (
	   [Answer_Id] int
      ,[Assessment_Id] int
      ,[Mark_For_Review] bit
      ,[Comment] nvarchar(max)
      ,[Alternate_Justification] varchar(2048)
      ,[Is_Requirement] bit
      ,[Question_Or_Requirement_Id] int
      ,[Question_Number] int
      ,[Answer_Text] nvarchar(50)
      ,[Component_Guid] uniqueidentifier
      ,[Is_Component] bit
      ,[Is_Framework] bit
      ,[Is_Maturity] bit
      ,[Custom_Question_Guid] nvarchar(50)
      ,[Old_Answer_Id] int
      ,[Reviewed] bit
      ,[FeedBack] nvarchar(2048)
      ,[Maturity_Level_Id] int
      ,[Question_Text] nvarchar(max))
AS
BEGIN
	declare @modelId int
	select @modelId = model_id from AVAILABLE_MATURITY_MODELS where Assessment_Id = @assessmentId and selected = 1

	declare @submodel varchar(20)
    select @submodel = stringvalue from DETAILS_DEMOGRAPHICS where assessment_id = @assessmentId and DataItemName = 'MATURITY-SUBMODEL'


	if @submodel is null 
	begin
		insert into @AM select * from ANSWER_MATURITY 
		where Assessment_Id = @assessmentId and Is_Maturity = 1
	end
	else
	begin
		insert into @AM select * from ANSWER_MATURITY 
		where Assessment_Id = @assessmentId and is_Maturity = 1 
		and Question_Or_Requirement_Id in (select mat_question_id from MATURITY_SUB_MODEL_QUESTIONS where sub_model_name = @submodel)
	end

	RETURN
END
