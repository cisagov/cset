-- =============================================
-- Author:		Randy Woods
-- Create date: 10-OCT-2023
-- Description:	Returns all MATURITY_QUESTIONS rows applicable for an assessment.
--              If the assessment is using a "sub model", only the questions in the
--              sub model are returned.  Otherwise, all questions for the assessment's
--              model are returned.
-- =============================================
CREATE FUNCTION [dbo].[func_MQ]
(
	@assessmentId int
)
RETURNS 
@MQ TABLE 
(
	[Mat_Question_Id] [int] NOT NULL,
	[Question_Title] [nvarchar](250) NULL,
	[Question_Text] [nvarchar](max) NOT NULL,
	[Supplemental_Info] [nvarchar](max) NULL,
	[Category] [nvarchar](250) NULL,
	[Sub_Category] [nvarchar](250) NULL,
	[Maturity_Level_Id] [int] NOT NULL,
	[Sequence] [int] NOT NULL,
	[Text_Hash]  [varbinary](20),
	[Maturity_Model_Id] [int] NOT NULL,
	[Parent_Question_Id] [int] NULL,
	[Ranking] [int] NULL,
	[Grouping_Id] [int] NULL,
	[Examination_Approach] [nvarchar](max) NULL,
	[Short_Name] [nvarchar](80) NULL,
	[Mat_Question_Type] [nvarchar](50) NULL,
	[Parent_Option_Id] [int] NULL,
	[Supplemental_Fact] [nvarchar](max) NULL,
	[Scope] [nvarchar](250) NULL,
	[Recommend_Action] [nvarchar](max) NULL,
	[Risk_Addressed] [nvarchar](max) NULL,
	[Services] [nvarchar](max) NULL
)
AS
BEGIN
	declare @modelId int
	select @modelId = model_id from AVAILABLE_MATURITY_MODELS where Assessment_Id = @assessmentId and selected = 1

	declare @submodel varchar(20)
    select @submodel = stringvalue from DETAILS_DEMOGRAPHICS where assessment_id = @assessmentId and DataItemName = 'MATURITY-SUBMODEL'


	if @submodel is null 
	begin
		insert into @MQ select * from MATURITY_QUESTIONS where maturity_model_id = @modelId
	end
	else
	begin
		insert into @MQ select * from MATURITY_QUESTIONS where maturity_model_id = @modelId
		and mat_question_id in (select mat_question_id from MATURITY_SUB_MODEL_QUESTIONS where sub_model_name = @submodel)
	end
	
	RETURN 
END
