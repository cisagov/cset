/*
Run this script on:

        (localdb)\INLLocalDB2022.CSETWeb12160    -  This database will be modified

to synchronize it with:

        (localdb)\INLLocalDB2022.CSETWeb12170

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.10.9.22680 from Red Gate Software Ltd at 4/25/2024 9:57:30 AM

*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL Serializable
GO
BEGIN TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[REQUIREMENT_QUESTIONS]'
GO
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS] DROP CONSTRAINT [FK_REQUIREMENT_QUESTIONS_NEW_QUESTION1]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS] DROP CONSTRAINT [FK_REQUIREMENT_QUESTIONS_NEW_REQUIREMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[REQUIREMENT_QUESTIONS]'
GO
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS] DROP CONSTRAINT [PK_REQUIREMENT_QUESTIONS_1]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[UNIVERSAL_SUB_CATEGORIES]'
GO
ALTER TABLE [dbo].[UNIVERSAL_SUB_CATEGORIES] DROP CONSTRAINT [PK_UNIVERSAL_SUB_CATEGORIES]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[REQUIREMENT_QUESTIONS]'
GO
DROP TABLE [dbo].[REQUIREMENT_QUESTIONS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[ASSESSMENTS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[ASSESSMENTS] ADD
[ModifiedSinceLastExport] [bit] NOT NULL CONSTRAINT [DF_ASSESSMENTS_ModifiedSinceLastExport] DEFAULT ((1))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[UNIVERSAL_SUB_CATEGORIES]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[UNIVERSAL_SUB_CATEGORIES] ALTER COLUMN [Universal_Sub_Category] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_UNIVERSAL_SUB_CATEGORIES] on [dbo].[UNIVERSAL_SUB_CATEGORIES]'
GO
ALTER TABLE [dbo].[UNIVERSAL_SUB_CATEGORIES] ADD CONSTRAINT [PK_UNIVERSAL_SUB_CATEGORIES] PRIMARY KEY CLUSTERED ([Universal_Sub_Category])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[clean_out_requirements_mode]'
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[clean_out_requirements_mode]
	   @standard_name nvarchar(50), @standard_name_with_mode nvarchar(50)
AS
BEGIN	
	SET NOCOUNT ON;

/**
we will do a sheet by sheet clean
select all the q_s_r id's into a temp table
delete out all the corresponding records.

*/


SELECT * INTO #tempSetList FROM dbo.REQUIREMENT_sets WHERE Set_Name = @standard_name_with_mode;

BEGIN TRANSACTION
IF @standard_name = 'ICS'
BEGIN
	delete  [dbo].[Requirement_SETS] where set_name = @standard_name_with_mode
end
ELSE
begin
	DELETE FROM dbo.REQUIREMENT_SOURCE_FILES
	FROM dbo.REQUIREMENT_SOURCE_FILES a INNER JOIN #tempSetList b ON a.Requirement_Id = b.Requirement_Id
	DELETE FROM dbo.REQUIREMENT_REFERENCES
	FROM dbo.REQUIREMENT_REFERENCES a INNER JOIN #tempSetList b ON a.Requirement_Id=b.Requirement_Id
	DELETE FROM dbo.REQUIREMENT_levels
	FROM dbo.REQUIREMENT_levels a INNER JOIN #tempSetList b ON a.Requirement_Id = b.Requirement_Id
	DELETE FROM dbo.REQUIREMENT_QUESTIONS_SETS
	FROM dbo.REQUIREMENT_QUESTIONS_SETS a INNER JOIN #tempSetList b ON a.Requirement_Id=b.Requirement_Id
	DELETE  [dbo].[Requirement_SETS] where set_name = @standard_name_with_mode
end
COMMIT TRANSACTION

DROP TABLE #tempsetlist;


END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[requirement_final_moves]'
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[requirement_final_moves]	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   update QUESTION_REQUIREMENT_SUPPLEMENTAL set Weight = s.weight from(
	SELECT r.Requirement_Id,nq.Weight
	  FROM 
	  QUESTION_REQUIREMENT_SUPPLEMENTAL r 
	  join REQUIREMENT_QUESTIONS_SETS rq on r.Requirement_Id=rq.Question_Id
	  join NEW_QUESTION nq on rq.Question_Id = nq.Question_Id
	  ) s
	  where QUESTION_REQUIREMENT_SUPPLEMENTAL.Requirement_Id = s.requirement_id

	update QUESTION_REQUIREMENT_SUPPLEMENTAL set Weight = 1 where Weight = 0;
	update QUESTION_REQUIREMENT_SUPPLEMENTAL set Weight = 1 where Weight is null;
	
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[View_Alts]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
		DROP TABLE [dbo].[View_Alts]
		
select distinct a.Requirement_Id,r.Question_Id,a.Top_U,b.User_Number,b.Top_Answer_User_Number,Alt_Text into dbo.VIEW_ALTS from 
	(SELECT Top_U,ru.User_Number,ru.REQUIREMENT_id,ru.Is_Alt
	  FROM [CSET_Control].[dbo].[REQUIREMENT_USER_NUMBERS] ru join OLD_CONTAINERS o on ru.User_Number = o.User_Number
	  where Is_Alt = 0
	  ) a
	join (
	SELECT Requirement_Title,Top_U,ru.User_Number,ru.Top_Answer_User_Number, ru.REQUIREMENT_id,ru.Is_Alt,ru.Alt_Text
	  FROM [CSET_Control].[dbo].[REQUIREMENT_USER_NUMBERS] ru join OLD_CONTAINERS o on ru.User_Number = o.User_Number
	  join QUESTION_REQUIREMENT_SUPPLEMENTAL r on ru.Requirement_Id = r.Requirement_Id  
	where Is_Alt=1) b on a.Requirement_Id = b.Requirement_Id
	join REQUIREMENT_QUESTIONS_SETS r on a.Requirement_Id = r.Requirement_Id
	
	
ALTER TABLE [dbo].[VIEW_ALTS] ADD CONSTRAINT [PK_VIEW_ALTS] PRIMARY KEY CLUSTERED  ([Requirement_Id], [Question_Id], [Top_U], [User_Number])

END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_CopyIntoSet]'
GO

-- =============================================
-- Author:		Barry Hansen
-- Create date: 2/18/2021
-- Description:	copy a base set into an existing custom set
-- =============================================
ALTER PROCEDURE [dbo].[usp_CopyIntoSet]
	-- Add the parameters for the stored procedure here
	@SourceSetName nvarchar(50),
	@DestinationSetName nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--check to make sure the destination set is a custom set
	--cannot modify existing standards
	if exists (select * from sets where Set_Name = @DestinationSetName and Is_Custom = 0)
	begin
		raiserror('Destination set is not a custom set.  Standard sets cannot be modified.',18,1);
		return 
	end

    -- Insert statements for procedure here
	insert CUSTOM_STANDARD_BASE_STANDARD (Custom_Questionaire_Name,Base_Standard) values(@DestinationSetName,@SourceSetName)
	--do the headers first
	INSERT INTO [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS]
			   ([Sub_Heading_Question_Description]
			   ,[Question_Group_Heading_Id]
			   ,[Universal_Sub_Category_Id]
			   ,[Set_Name])
	select a.* from
	(select [Sub_Heading_Question_Description]
			   ,[Question_Group_Heading_Id]
			   ,[Universal_Sub_Category_Id]
			   ,@DestinationSetName as [Set_Name] from UNIVERSAL_SUB_CATEGORY_HEADINGS
	where Set_Name = @SourceSetName ) a 
	left join (select [Sub_Heading_Question_Description]
			   ,[Question_Group_Heading_Id]
			   ,[Universal_Sub_Category_Id]
			   ,@DestinationSetName as [Set_Name] from UNIVERSAL_SUB_CATEGORY_HEADINGS
	where Set_Name = @DestinationSetName ) b on a.Question_Group_Heading_Id=b.Question_Group_Heading_Id
	and a.Universal_Sub_Category_Id = b.Universal_Sub_Category_Id
	where b.Question_Group_Heading_Id is not null

	INSERT INTO [dbo].[NEW_REQUIREMENT]
           ([Requirement_Title]
           ,[Requirement_Text]
           ,[Supplemental_Info]
           ,[Standard_Category]
           ,[Standard_Sub_Category]
           ,[Weight]
           ,[Implementation_Recommendations]
           ,[Original_Set_Name]
           ,[NCSF_Cat_Id]
           ,[NCSF_Number]
           ,[Ranking]
           ,[Question_Group_Heading_Id]
           ,[ExaminationApproach]
           ,[Old_Id_For_Copy])
	select 		
		Requirement_Title,
		Requirement_Text,
		Supplemental_Info,
		Standard_Category,
		Standard_Sub_Category,
		Weight,
		Implementation_Recommendations,
		Original_Set_Name = @DestinationSetName,
		NCSF_Cat_Id,
		NCSF_Number,
		Ranking,
		Question_Group_Heading_Id,
		ExaminationApproach,
		r.Requirement_Id as Old_Id_For_Copy
		from REQUIREMENT_SETS s
	join NEW_REQUIREMENT r on s.Requirement_Id=r.Requirement_Id	
	where set_name = @SourceSetName
	order by Requirement_Sequence

	INSERT INTO [dbo].[REQUIREMENT_SETS]
           ([Requirement_Id]
           ,[Set_Name]
           ,[Requirement_Sequence])
	select nr.Requirement_Id,Set_name = @DestinationSetName,ns.Requirement_Sequence from NEW_REQUIREMENT nr 
	join (select s.Requirement_Id,s.Requirement_Sequence,s.Set_Name 
		from NEW_REQUIREMENT r join REQUIREMENT_SETS s on r.Requirement_Id=s.Requirement_Id 
		where s.Set_Name = @SourceSetName) ns on nr.Old_Id_For_Copy=ns.Requirement_Id
	where Original_Set_Name = @DestinationSetName

	insert into REQUIREMENT_LEVELS (Requirement_Id,Level_Type,Standard_Level)
	select a.Requirement_Id,b.Level_Type,b.Standard_Level from (
	select r.* from REQUIREMENT_SETS s join NEW_REQUIREMENT r
	on s.Requirement_Id = r.Requirement_Id
	where s.Set_Name = @DestinationSetName) a join (	
	select l.* from requirement_levels l 
	join REQUIREMENT_SETS s on l.Requirement_Id=s.Requirement_Id	
	where s.Set_Name = @SourceSetName) b on a.Old_Id_For_Copy=b.Requirement_Id


	insert into REQUIREMENT_QUESTIONS_SETS (Question_Id,Requirement_Id,Set_Name)
	select b.Question_Id,b.Requirement_Id,set_name = @DestinationSetName from REQUIREMENT_QUESTIONS_SETS a right join (
	select question_id,r.Requirement_Id
		from REQUIREMENT_QUESTIONS_SETS s
		join (select * from NEW_REQUIREMENT where Original_Set_Name= @DestinationSetName) r on s.Requirement_Id=r.Old_Id_For_Copy
		where set_name = @SourceSetName) b on a.Question_Id=b.Question_Id and a.Set_Name=@DestinationSetName
	where a.Question_Id is null

	
	INSERT INTO [dbo].[NEW_QUESTION_SETS]
           ([Set_Name]
           ,[Question_Id])    
	select a.set_name,a.Question_Id from (
	select set_name = @DestinationSetName,question_id
	from NEW_QUESTION_SETS where Set_Name = @SourceSetName) a 
	left join NEW_QUESTION_SETS b on a.Question_Id=b.Question_Id and a.set_name=b.Set_Name
	where b.Question_Id is null

	--insert the question sets records then join that with the old 
	--question sets records 		
	INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([New_Question_Set_Id],[Universal_Sal_Level])                
	select distinct b.New_Question_Set_Id,l.Universal_Sal_Level
	from NEW_QUESTION_SETS s
	join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id
	join (select ss.Question_Id,ss.New_Question_Set_Id 
	from NEW_QUESTION_SETS ss
		left join NEW_QUESTION_LEVELS ls on ss.New_Question_Set_Id=ls.New_Question_Set_Id
		where set_name = @DestinationSetName and ls.New_Question_Set_Id is null) b on s.Question_Id=b.Question_Id 
	where s.Set_Name = @SourceSetName


END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_CopyIntoSet_Delete]'
GO
-- =============================================
-- Author:		Barry Hansen
-- Create date: 2/18/2021
-- Description:	Delete a copied set
-- =============================================
ALTER PROCEDURE [dbo].[usp_CopyIntoSet_Delete]
	-- Add the parameters for the stored procedure here	
	@DestinationSetName nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	--check to make sure the destination set is a custom set
	--cannot modify existing standards
	if exists (select * from sets where Set_Name = @DestinationSetName and Is_Custom = 0)
	begin
		raiserror('Destination set is not a custom set.  Standard sets cannot be modified.',18,1);
		return 
	end
		
	delete [dbo].[REQUIREMENT_SETS] 	where Set_Name = @DestinationSetName

	
	delete REQUIREMENT_QUESTIONS_SETS where set_name = @DestinationSetName
	--do the headers first
	delete UNIVERSAL_SUB_CATEGORY_HEADINGS where Set_Name=@DestinationSetName

	delete NEW_QUESTION_SETS where Set_Name = @DestinationSetName

	
	delete NEW_REQUIREMENT where Original_Set_Name = @destinationSetName

	-- Insert statements for procedure here
	delete CUSTOM_STANDARD_BASE_STANDARD where Custom_Questionaire_Name = @DestinationSetName	

	
	
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
COMMIT TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
-- This statement writes to the SQL Server Log so SQL Monitor can show this deployment.
IF HAS_PERMS_BY_NAME(N'sys.xp_logevent', N'OBJECT', N'EXECUTE') = 1
BEGIN
    DECLARE @databaseName AS nvarchar(2048), @eventMessage AS nvarchar(2048)
    SET @databaseName = REPLACE(REPLACE(DB_NAME(), N'\', N'\\'), N'"', N'\"')
    SET @eventMessage = N'Redgate SQL Compare: { "deployment": { "description": "Redgate SQL Compare deployed to ' + @databaseName + N'", "database": "' + @databaseName + N'" }}'
    EXECUTE sys.xp_logevent 55000, @eventMessage
END
GO
DECLARE @Success AS BIT
SET @Success = 1
SET NOEXEC OFF
IF (@Success = 1) PRINT 'The database update succeeded'
ELSE BEGIN
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
	PRINT 'The database update failed'
END
GO
