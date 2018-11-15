USE [CSETWeb]
GO
/****** Object:  StoredProcedure [dbo].[usp_AggregationCustomQuestionnaireLoad]    Script Date: 11/14/2018 3:57:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--drop procedure usp_AggregationCustomQuestionnaireLoad
-- =============================================
-- Author:		hansbk
-- Create date: 6-16-2016
-- Description:	Note that this returns your expected custom control set name it may 
-- not be the same name that went in. 
-- =============================================
CREATE PROCEDURE [dbo].[usp_AggregationCustomQuestionnaireLoad]
	@AssessmentDBName varchar(5000),	
	@entity_name varchar(50)
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
declare @tempEntityName varchar(50)
declare @i int
declare @addNew bit
declare @sql nvarchar(max)

Set @addNew = 1

IF (1=0) 
BEGIN 
    SET FMTONLY OFF 
    if @entity_name is null 
        begin
            select cast(null as varchar(50)) as [entity_name]            
        END
END   

set @tempEntityName = @entity_name

set @sql = 
'if @entity_name is not null
begin '+
'--copy the entity name to the sets table '+  CHAR(13)+CHAR(10) + 
'--copy all the questions over to new_question_sets '+  CHAR(13)+CHAR(10) + 
'set @tempEntityName = @entity_name '+  CHAR(13)+CHAR(10) +
'set @i =0 '+ CHAR(13)+CHAR(10) + 
'--first get a unique name for the set'+ CHAR(13)+CHAR(10) + 
'	if @addNew = 1'+ CHAR(13)+CHAR(10) + 
'	begin'+ CHAR(13)+CHAR(10) + 
'		while exists (select * from dbo.sets where set_name = @tempEntityName)'+ CHAR(13)+CHAR(10) + 
'		begin'+ CHAR(13)+CHAR(10) + 
'			set @i = @i+1'+ CHAR(13)+CHAR(10) + 
'			set @tempEntityName = @entity_name +convert(varchar,@i)'+CHAR(13)+CHAR(10) + 
'		end'+CHAR(13)+CHAR(10) + 
'	end'+CHAR(13)+CHAR(10) + 
'	INSERT INTO [dbo].[SETS]'+CHAR(13)+CHAR(10) + 
'			   ([Set_Name],[Full_Name],[Short_Name],[Is_Displayed],[Is_Pass_Fail],[Old_Std_Name],[Set_Category_Id],[Order_In_Category],[Report_Order_Section_Number],[Aggregation_Standard_Number],[Is_Question],[Is_Requirement],[Order_Framework_Standards],[Standard_ToolTip],[Is_Deprecated],[Upgrade_Set_Name],[Is_Custom],[Date],[IsEncryptedModule],[IsEncryptedModuleOpen])'+CHAR(13)+CHAR(10) + 
'		 VALUES(@tempEntityName,@entity_name,@entity_name,1,1,null,1,1,35,35,1,0,35,null,0,null,1,getdate(),0,0)'+CHAR(13)+CHAR(10) + 
'	INSERT INTO [dbo].[NEW_QUESTION_SETS] ([Set_Name],[Question_Id])     '+CHAR(13)+CHAR(10) + 
'		SELECT [Custom_Questionaire_Name]=@tempEntityName'+CHAR(13)+CHAR(10) + 
'			  ,[Question_Id]'+CHAR(13)+CHAR(10) + 
'		FROM ['+@AssessmentDBName+'].[dbo].[CUSTOM_QUESTIONAIRE_QUESTIONS]'+CHAR(13)+CHAR(10) + 
'end';

print @sql

EXECUTE sp_executesql   
          @sql, 
		  N'@entity_name varchar(50), @tempEntityName varchar(50) output, @i int, @addNew bit',
          @entity_name,
		  @tempEntityName out,
		  @i,
		  @addNew;

		  set @entity_name = @tempEntityName;

select [entity_name] = @entity_name 

END
GO
