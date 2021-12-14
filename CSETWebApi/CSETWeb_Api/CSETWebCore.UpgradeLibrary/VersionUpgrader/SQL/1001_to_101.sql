DECLARE @rolename sysname = 'aduser_role';
DECLARE @cmd AS NVARCHAR(MAX) = N'';

SELECT @cmd = @cmd + '
    ALTER ROLE ' + QUOTENAME(@rolename) + ' DROP MEMBER ' + QUOTENAME(members.[name]) + ';'
FROM sys.database_role_members AS rolemembers
    JOIN sys.database_principals AS roles 
        ON roles.[principal_id] = rolemembers.[role_principal_id]
    JOIN sys.database_principals AS members 
        ON members.[principal_id] = rolemembers.[member_principal_id]
WHERE roles.[name]=@rolename

EXEC(@cmd);
GO
/*
Run this script on:

        (localdb)\v11.0.CSETWeb1001    -  This database will be modified

to synchronize it with:

        (localdb)\v11.0.CSETWeb101

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.4.4.16824 from Red Gate Software Ltd at 10/22/2020 12:42:00 PM

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
PRINT N'Altering [dbo].[ANSWER]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
IF COL_LENGTH('ANSWER','Is_Maturity') IS NULL
	ALTER TABLE [dbo].[ANSWER] ADD
	[Is_Maturity] [bit] NOT NULL CONSTRAINT [DF_ANSWER_Is_Maturity] DEFAULT ((0))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[ANSWER] ALTER COLUMN [Comment] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[ASSESSMENTS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[ASSESSMENTS] ADD
[UseDiagram] [bit] NOT NULL CONSTRAINT [DF_ASSESSMENTS_UseDiagram] DEFAULT ((0)),
[UseStandard] [bit] NOT NULL CONSTRAINT [DF_ASSESSMENTS_UseStandard] DEFAULT ((0)),
[UseMaturity] [bit] NOT NULL CONSTRAINT [DF_ASSESSMENTS_UseMaturity] DEFAULT ((0))
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_MODELS]'
GO
CREATE TABLE [dbo].[MATURITY_MODELS]
(
[Model_Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Maturity_Model_Id] [int] NOT NULL IDENTITY(1, 1),
[Answer_Options_Suppressed] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_MODELS] on [dbo].[MATURITY_MODELS]'
GO
ALTER TABLE [dbo].[MATURITY_MODELS] ADD CONSTRAINT [PK_MATURITY_MODELS] PRIMARY KEY CLUSTERED  ([Maturity_Model_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[AVAILABLE_MATURITY_MODELS]'
GO
CREATE TABLE [dbo].[AVAILABLE_MATURITY_MODELS]
(
[Assessment_Id] [int] NOT NULL,
[Selected] [bit] NOT NULL CONSTRAINT [DF_AVAILABLE_MATURITY_MODELS_Selected] DEFAULT ((0)),
[model_id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_AVAILABLE_MATURITY_MODELS] on [dbo].[AVAILABLE_MATURITY_MODELS]'
GO
ALTER TABLE [dbo].[AVAILABLE_MATURITY_MODELS] ADD CONSTRAINT [PK_AVAILABLE_MATURITY_MODELS] PRIMARY KEY CLUSTERED  ([Assessment_Id], [model_id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_LEVELS]'
GO
CREATE TABLE [dbo].[MATURITY_LEVELS]
(
[Level] [int] NOT NULL,
[Level_Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Maturity_Level_Id] [int] NOT NULL IDENTITY(1, 1),
[Maturity_Model_Id] [int] NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_LEVELS] on [dbo].[MATURITY_LEVELS]'
GO
ALTER TABLE [dbo].[MATURITY_LEVELS] ADD CONSTRAINT [PK_MATURITY_LEVELS] PRIMARY KEY CLUSTERED  ([Maturity_Level_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_QUESTIONS]'
GO
CREATE TABLE [dbo].[MATURITY_QUESTIONS]
(
[Mat_Question_Id] [int] NOT NULL IDENTITY(1, 1),
[Question_Title] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Question_Text] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Supplemental_Info] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sub_Category] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Maturity_Level] [int] NOT NULL,
[Sequence] [int] NOT NULL,
[Text_Hash] AS (CONVERT([varbinary](20),hashbytes('SHA1',[Question_Text]),(0))) PERSISTED,
[Maturity_Model_Id] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK__MATURITY__EBDCEAE635AFA091] on [dbo].[MATURITY_QUESTIONS]'
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] ADD CONSTRAINT [PK__MATURITY__EBDCEAE635AFA091] PRIMARY KEY CLUSTERED  ([Mat_Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_REFERENCES]'
GO
CREATE TABLE [dbo].[MATURITY_REFERENCES]
(
[Mat_Question_Id] [int] NOT NULL,
[Gen_File_Id] [int] NOT NULL,
[Section_Ref] [varchar] (850) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Page_Number] [int] NULL,
[Destination_String] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_REFERENCES] on [dbo].[MATURITY_REFERENCES]'
GO
ALTER TABLE [dbo].[MATURITY_REFERENCES] ADD CONSTRAINT [PK_MATURITY_REFERENCES] PRIMARY KEY CLUSTERED  ([Mat_Question_Id], [Gen_File_Id], [Section_Ref])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[MATURITY_SOURCE_FILES]'
GO
CREATE TABLE [dbo].[MATURITY_SOURCE_FILES]
(
[Mat_Question_Id] [int] NOT NULL,
[Gen_File_Id] [int] NOT NULL,
[Section_Ref] [varchar] (850) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Page_Number] [int] NULL,
[Destination_String] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_MATURITY_SOURCE_FILES] on [dbo].[MATURITY_SOURCE_FILES]'
GO
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] ADD CONSTRAINT [PK_MATURITY_SOURCE_FILES] PRIMARY KEY CLUSTERED  ([Mat_Question_Id], [Gen_File_Id], [Section_Ref])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_financial_attributes]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[usp_financial_attributes]
	@Assessment_Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    
	INSERT INTO [FINANCIAL_ASSESSMENT_VALUES]
			   ([Assessment_Id]
			   ,[AttributeName]
			   ,[AttributeValue])
	SELECT Assessment_Id = @Assessment_Id,a.AttributeName, isnull(AttributeValue, '') AttributeValue
	  FROM [FINANCIAL_ATTRIBUTES] a
		left join [FINANCIAL_ASSESSMENT_VALUES] v on a.AttributeName = v.AttributeName and v.Assessment_Id = @Assessment_Id
		where v.AttributeName is null

	select * from FINANCIAL_ASSESSMENT_VALUES where Assessment_Id = @Assessment_Id
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[FillEmptyQuestionsForAnalysis]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 7/9/2018
-- Description:	CopyData
-- =============================================
ALTER PROCEDURE [dbo].[FillEmptyQuestionsForAnalysis]
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

	DECLARE @result int;  
	exec GetApplicationModeDefault @assessment_id,@applicationmode output
	if(@ApplicationMode = 'Questions Based')
		begin
		BEGIN TRANSACTION;  
		
		EXEC @result = sp_getapplock @DbPrincipal = 'dbo', @Resource = '[Answer]', @LockMode = 'Exclusive';  
			INSERT INTO [dbo].[ANSWER]  ([Is_Requirement],[Question_Or_Requirement_Id],[Answer_Text],[Is_Component],[Is_Framework],[Is_Maturity],[Assessment_Id])     
		select Is_Requirement=0,s.Question_id,Answer_Text = 'U', Is_Component='0',Is_Framework=0, Is_Maturity=0, Assessment_Id =@Assessment_Id
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
			EXEC sp_releaseapplock @DbPrincipal = 'dbo', @Resource = '[Answer]'; 	
			COMMIT TRANSACTION;  
		END;  
		if(@@ROWCOUNT>0) 
			begin 			
			exec usp_BuildCatNumbers @assessment_id
			end
		end
	else
	begin
		BEGIN TRANSACTION;  		
		EXEC @result = sp_getapplock @DbPrincipal = 'dbo', @Resource = '[Answer]', @LockMode = 'Exclusive';  
		INSERT INTO [dbo].[ANSWER]  ([Is_Requirement],[Question_Or_Requirement_Id]
           ,[Answer_Text],[Is_Component],[Is_Framework],[Is_Maturity],[Assessment_Id])     
		select distinct Is_Requirement=1,s.Requirement_Id, Answer_Text = 'U', Is_Component='0',Is_Framework=0,is_maturity=0,av.Assessment_Id 
			from requirement_sets s 
			join AVAILABLE_STANDARDS av on s.Set_Name=av.Set_Name
			join REQUIREMENT_LEVELS rl on s.Requirement_Id = rl.Requirement_Id
			left join (select * from ANSWER where Assessment_Id = @Assessment_Id and Is_Requirement = 1) a on s.Requirement_Id = a.Question_Or_Requirement_Id
		where av.Selected = 1 and av.Assessment_Id = @Assessment_Id and a.Question_Or_Requirement_Id is null and rl.Standard_Level = @SALevel and rl.Level_Type = 'NST'
			IF @result = -3  
		BEGIN  
			ROLLBACK TRANSACTION;  
		END  
		ELSE  
		BEGIN  
			EXEC sp_releaseapplock @DbPrincipal = 'dbo', @Resource = '[Answer]'; 	
			COMMIT TRANSACTION;  
		END;  
		if(@@ROWCOUNT>0) exec usp_BuildCatNumbers @assessment_id
	end   
	
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_getExplodedComponent]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[usp_getExplodedComponent]
	-- Add the parameters for the stored procedure here
	@assessment_id int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

SELECT CONVERT(varchar(100), ROW_NUMBER() OVER (ORDER BY a.Question_id)) as UniqueKey,
	a.Assessment_Id, b.Answer_Id, a.Question_Id, isnull(b.Answer_Text, c.Answer_Text) as Answer_Text, 
	CONVERT(nvarchar(1000), b.Comment) AS Comment, CONVERT(nvarchar(1000), b.Alternate_Justification) AS Alternate_Justification, 
	b.FeedBack,
	b.Question_Number, a.Simple_Question AS QuestionText, 	
	a.label AS ComponentName, a.Symbol_Name, 
	a.Question_Group_Heading, a.GroupHeadingId, 
	a.Universal_Sub_Category, a.SubCategoryId, 
	isnull(b.Is_Component,1) as Is_Component, a.Component_Guid, 
	a.Layer_Id, a.LayerName, a.Container_Id, 
	a.ZoneName, dbo.convert_sal(a.SAL) as SAL, 
	b.Mark_For_Review, Is_Requirement=cast(0 as bit), Is_Framework=cast(0 as bit),
	b.Reviewed, a.Simple_Question, a.Sub_Heading_Question_Description, a.heading_pair_id, a.label, a.Component_Symbol_Id
from (
SELECT CONVERT(varchar(100), ROW_NUMBER() OVER (ORDER BY q.Question_id)) as UniqueKey,
	adc.Assessment_Id, q.Question_Id, q.Simple_Question,
	adc.label, adc.Component_Symbol_Id, 
	h.Question_Group_Heading, usch.Question_Group_Heading_Id as GroupHeadingId, 
	h.Universal_Sub_Category, usch.Universal_Sub_Category_Id as SubCategoryId,
	adc.Component_Guid, adc.Layer_Id, l.Name AS LayerName, z.Container_Id, 
	z.Name AS ZoneName,  dbo.convert_sal(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level)) AS SAL,
	h.Sub_Heading_Question_Description,h.Heading_Pair_Id, cs.Symbol_Name
from	 ASSESSMENT_DIAGRAM_COMPONENTS AS adc
			join STANDARD_SELECTION ss on adc.Assessment_Id = ss.Assessment_Id
			join COMPONENT_QUESTIONS AS cq ON adc.Component_Symbol_Id = cq.Component_Symbol_Id			
			join COMPONENT_SYMBOLS as cs on adc.Component_Symbol_Id = cs.Component_Symbol_Id
            join NEW_QUESTION AS q ON cq.Question_Id = q.Question_Id 			
            join DIAGRAM_CONTAINER AS l ON adc.Layer_Id = l.Container_Id  
            left join DIAGRAM_CONTAINER AS z ON adc.Zone_Id =z.Container_Id and adc.Assessment_Id=adc.Assessment_Id
			join (select s.*,nql.Universal_Sal_Level from NEW_QUESTION_SETS s
			join NEW_QUESTION_LEVELS nql on s.New_Question_Set_Id = nql.New_Question_Set_Id
			where set_name = 'Components' ) s on q.Question_Id = s.Question_Id and s.Universal_Sal_Level = dbo.convert_sal_short(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level))		
			left join vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id
			left join UNIVERSAL_SUB_CATEGORY_HEADINGS usch on usch.Heading_Pair_Id = h.Heading_Pair_Id		 
WHERE l.Visible = 1 and adc.Assessment_Id = @assessment_id) a left join Answer_Components AS b on a.Question_Id = b.Question_Or_Requirement_Id and a.Assessment_Id = b.Assessment_Id and a.component_guid = b.component_guid
left join (SELECT a.Assessment_Id, q.Question_Id, a.Answer_Text		
from   (SELECT distinct q.question_id,adc.assessment_id
				FROM [ASSESSMENT_DIAGRAM_COMPONENTS] adc 			
				join component_questions q on adc.Component_Symbol_Id = q.Component_Symbol_Id
				join STANDARD_SELECTION ss on adc.Assessment_Id = ss.Assessment_Id
				join new_question nq on q.question_id=nq.question_id		
				join new_question_sets qs on nq.question_id=qs.question_id	and qs.Set_Name = 'Components'						
				join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id 
					and nql.Universal_Sal_Level = dbo.convert_sal(ss.Selected_Sal_Level)) as f  
            join NEW_QUESTION AS q ON f.Question_Id = q.Question_Id 			
			join Answer_Components AS a on f.Question_Id = a.Question_Or_Requirement_Id and f.assessment_id = a.assessment_id	  
where component_guid = '00000000-0000-0000-0000-000000000000') c on a.Assessment_Id=c.Assessment_Id and a.Question_Id = c.Question_Id
end 
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[FillNetworkDiagramQuestions]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 9/27/2019
-- Description:	calll to get defaults
-- =============================================
ALTER PROCEDURE [dbo].[FillNetworkDiagramQuestions]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- SET NOCOUNT ON;

	  delete a from ANSWER a 
		left join (SELECT distinct q.question_id 
				FROM [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] a 			
				join component_questions q on a.Component_Symbol_Id = q.Component_Symbol_Id
				join STANDARD_SELECTION ss on a.Assessment_Id = ss.Assessment_Id
				join new_question nq on q.question_id=nq.question_id
				join new_question_sets qs on nq.question_id=qs.question_id		
				left join dbo.DIAGRAM_CONTAINER AS z ON a.Zone_Id =z.Container_Id
				join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id and nql.Universal_Sal_Level = dbo.convert_sal(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level))
				where a.assessment_id = @assessment_id and qs.Set_Name = 'Components') b on a.Question_Or_Requirement_Id = b.Question_Id and a.Assessment_Id = @assessment_id
		where b.Question_Id is null and Is_Component = 1 and Assessment_Id = @assessment_id 

    /*Rules for Component questions
	For the default questions 
	select the set of component types and questions associated with the component types
	then insert an answer for each unique question in that list. 
	this needs filterd for level

	the major dimensions are 
	*/
	--generate defaults 
	INSERT INTO [dbo].[ANSWER]  ([Is_Requirement],[Question_Or_Requirement_Id],[Answer_Text],[Is_Component],[Is_Framework],[Is_Maturity],[Assessment_Id])   	  		
		select Is_Requirement = 0,Question_id, Answer_Text = 'U', Is_Component = '1', Is_Framework = 0, Is_Maturity = 0, Assessment_Id = @Assessment_Id 
		from (select * from [ANSWER] where [Assessment_Id] = @assessment_id and [IS_COMPONENT] = 1) a 		
		right join 
		(SELECT distinct q.question_id 
		FROM [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS] a 			
		join component_questions q on a.Component_Symbol_Id = q.Component_Symbol_Id
		join STANDARD_SELECTION ss on a.Assessment_Id = ss.Assessment_Id
		join new_question nq on q.question_id=nq.question_id
		join new_question_sets qs on nq.question_id=qs.question_id		
		left join dbo.DIAGRAM_CONTAINER AS z ON a.Zone_Id =z.Container_Id
		join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id and nql.Universal_Sal_Level = dbo.convert_sal(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level))
		where a.assessment_id = @assessment_id and qs.Set_Name = 'Components'
		) t 		
		on a.Question_Or_Requirement_Id = t.question_id
		where assessment_id is null
		--and Question_Or_Requirement_Id not in 
		--(select [Question_Or_Requirement_Id] from [ANSWER] where [Assessment_Id] = @assessment_id and [Component_Guid] = CAST(CAST(0 AS BINARY) AS UNIQUEIDENTIFIER))
END

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[Answer_Maturity]'
GO


CREATE VIEW [dbo].[Answer_Maturity]
AS
SELECT 
	a.Answer_Id, a.Assessment_Id, a.Mark_For_Review, a.Comment, a.Alternate_Justification, 
	a.Is_Requirement, a.Question_Or_Requirement_Id, a.Question_Number, a.Answer_Text, 
	a.Component_Guid, a.Is_Component, a.Is_Framework, a.Is_Maturity,
    a.Custom_Question_Guid, a.Old_Answer_Id, a.Reviewed, a.FeedBack, q.Maturity_Level, q.Question_Text
FROM       [ANSWER] a
LEFT JOIN  [MATURITY_QUESTIONS] q on q.Mat_Question_Id = a.Question_Or_Requirement_Id
LEFT JOIN  [ASSESSMENT_SELECTED_LEVELS] l on l.Assessment_Id = a.Assessment_Id and l.Standard_Specific_Sal_Level = q.Maturity_Level and l.Level_Name = 'Maturity_Level'
WHERE      a.Is_Maturity = 1
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[Assessments_For_User]'
GO




ALTER VIEW [dbo].[Assessments_For_User]
AS
select 	
    AssessmentId = a.Assessment_Id,
	AssessmentName = Assessment_Name,
	AssessmentDate = Assessment_Date,
	AssessmentCreatedDate,
	CreatorName = u.FirstName + ' ' + u.LastName,
	LastModifiedDate = LastAccessedDate,
	MarkedForReview = isnull(mark_for_review,0),
	c.UserId
	from ASSESSMENTS a 
		join INFORMATION i on a.Assessment_Id = i.Id
		join USERS u on a.AssessmentCreatorId = u.UserId
		join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id
		left join (
			select distinct a.Assessment_Id, Mark_For_Review 
			from ASSESSMENTS a 
			join Answer_Standards_InScope v on a.Assessment_Id = v.Assessment_Id 
			where v.Mark_For_Review = 1
			union
			select distinct a.Assessment_Id, Mark_For_Review
			from ASSESSMENTS a
			join Answer_Maturity v on a.Assessment_id = v.Assessment_Id
			where v.Mark_For_Review = 1
			union 
			select distinct a.Assessment_Id, Mark_For_Review 
			from ASSESSMENTS a 
			join Answer_Components_InScope v on a.Assessment_Id = v.Assessment_Id 
			where v.Mark_For_Review = 1) b on a.Assessment_Id = b.Assessment_Id
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_Answer_Components_Default]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[usp_Answer_Components_Default]
	-- Add the parameters for the stored procedure here
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT                   
		-- This guarantees a unique column to key on in the model
		cast(ROW_NUMBER() OVER (ORDER BY q.Question_id)as int) as UniqueKey,
		a.Assessment_Id, a.Answer_Id, q.Question_Id, a.Answer_Text, 
		CONVERT(nvarchar(1000), a.Comment) AS Comment, CONVERT(nvarchar(1000), a.Alternate_Justification) AS Alternate_Justification, 
		a.Question_Number, q.Simple_Question AS QuestionText, 		
		h.Question_Group_Heading, usch.Question_Group_Heading_Id as GroupHeadingId, 
		h.Universal_Sub_Category, usch.Universal_Sub_Category_Id as SubCategoryId,
		a.FeedBack,
		a.Is_Component, a.Component_Guid, 
		dbo.convert_sal(ss.Selected_Sal_Level) AS SAL, 
		a.Mark_For_Review, a.Is_Requirement, a.Is_Framework,	
		q.heading_pair_id, h.Sub_Heading_Question_Description,
		q.Simple_Question, 
		a.Reviewed, label = null, ComponentName = null, Symbol_Name = null, Component_Symbol_id = 0
	from   STANDARD_SELECTION ss
			 join 
			 (SELECT distinct q.question_id,adc.assessment_id
					FROM [ASSESSMENT_DIAGRAM_COMPONENTS] adc 			
					join component_questions q on adc.Component_Symbol_Id = q.Component_Symbol_Id
					join STANDARD_SELECTION ss on adc.Assessment_Id = ss.Assessment_Id
					join new_question nq on q.question_id=nq.question_id		
					join new_question_sets qs on nq.question_id=qs.question_id	and qs.Set_Name = 'Components'		
					join DIAGRAM_CONTAINER l on adc.Layer_id=l.Container_Id
					left join DIAGRAM_CONTAINER AS z ON adc.Zone_Id =z.Container_Id
					join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id 
						and nql.Universal_Sal_Level = dbo.convert_sal(ISNULL(z.Universal_Sal_Level, ss.Selected_Sal_Level))
					where l.visible = 1) as f  on ss.assessment_id=f.assessment_id							
				join NEW_QUESTION AS q ON f.Question_Id = q.Question_Id 
				join vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id	
				join UNIVERSAL_SUB_CATEGORY_HEADINGS usch on usch.Heading_Pair_Id = h.Heading_Pair_Id		    
				join Answer_Components AS a on f.Question_Id = a.Question_Or_Requirement_Id and f.assessment_id = a.assessment_id	  
	where component_guid = '00000000-0000-0000-0000-000000000000' and a.Assessment_Id = @assessment_id
	order by Question_Group_Heading,Universal_Sub_Category
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FillEmptyMaturityQuestionsForAnalysis]'
GO
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
		from [dbo].[MATURITY_QUESTIONS] mq
			where Maturity_Model_Id in
			(select model_id from [dbo].[AVAILABLE_MATURITY_MODELS]
			where Assessment_Id = @Assessment_Id) 
			and Mat_Question_Id not in 
			(select Question_Or_Requirement_Id from [dbo].[ANSWER] 
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
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_getComponentsSummary]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[usp_getComponentsSummary]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select l.Answer_Text, l.Answer_Full_Name, isnull(b.vcount, 0) vcount, round(isnull(b.value, 0),0) [value] 
	from ANSWER_LOOKUP l 
	left join (select Answer_Text, count(answer_text) vcount, cast((count(answer_text) * 100.0)/sum(count(*)) over() as decimal(18,1)) [value] 
		from (select distinct answer_text, assessment_id, answer_id from Answer_Components_InScope
	where assessment_id = @assessment_id) ac
	group by answer_text) b on l.Answer_Text = b.Answer_Text
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_StatementsReviewed]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[usp_StatementsReviewed]
	@Assessment_Id int	
AS
BEGIN

------------- get relevant answers ----------------
	IF OBJECT_ID('tempdb..#answers') IS NOT NULL DROP TABLE #answers

	create table #answers (assessment_id int, answer_id int, is_requirement bit, question_or_requirement_id int, mark_for_review bit, 
	comment ntext, alternate_justification ntext, question_number int, answer_text varchar(50), 
	component_guid varchar(36), is_component bit, custom_question_guid varchar(50), is_framework bit, old_answer_id int, reviewed bit)

	insert into #answers exec [GetRelevantAnswers] @assessment_id

----------------------------------------

	declare @applicationMode varchar(50)

	exec GetApplicationModeDefault @assessment_id, @ApplicationMode output

	SET NOCOUNT ON;

	EXECUTE [FillEmptyQuestionsForAnalysis]  @Assessment_Id

	if(@ApplicationMode = 'Questions Based')	
	BEGIN

		SELECT assessment_id, c.Component, ReviewType, Hours, isnull(ReviewedCount, 0) as ReviewedCount, f.OtherSpecifyValue, c.DomainId, PresentationOrder, grouporder acount
		from FINANCIAL_HOURS f 
			join FINANCIAL_HOURS_COMPONENT c on f.Component = c.Component
			left join (
				select grouporder, a.DomainId, isnull(ReviewedCount, 0) as ReviewedCount
				from (
						select distinct min(StmtNumber) as grouporder, d.Domain, g.DomainId,count(stmtnumber) Total from [FINANCIAL_DETAILS] fd 
						INNER JOIN FINANCIAL_GROUPS G on FD.FinancialGroupId = g.FinancialGroupId		
						INNER JOIN [FINANCIAL_DOMAINS] AS D ON g.[DomainId] = D.[DomainId]						
						group by g.DomainId, d.Domain
						)  a left join (
						SELECT  g.DomainId, isnull(count(ans_rev.answer_id), 0) as ReviewedCount
						FROM       [FINANCIAL_QUESTIONS] f			
						INNER JOIN [NEW_QUESTION] q ON f.[Question_Id] = q.[Question_Id]
						INNER JOIN #answers a ON q.[Question_Id] = a.[Question_Or_Requirement_Id]
						INNER JOIN #answers ans_rev ON q.[Question_Id] = ans_rev.[Question_Or_Requirement_Id]
						INNER JOIN [FINANCIAL_DETAILS] AS FD ON f.[StmtNumber] = FD.[StmtNumber]    
						inner join FINANCIAL_GROUPS G on FD.FinancialGroupId = g.FinancialGroupId
						WHERE ans_rev.Reviewed = 1
						group by g.DomainId
						) b  on a.DomainId = b.DomainId
		) b on c.DomainId = b.DomainId		
		where f.assessment_id = @assessment_id
		order by PresentationOrder

	END 
	ELSE
	BEGIN 

		SELECT Assessment_id, c.Component, ReviewType, Hours, isnull(ReviewedCount, 0) as ReviewedCount, f.OtherSpecifyValue, c.DomainId, PresentationOrder, grouporder acount
		from FINANCIAL_HOURS f 
		join FINANCIAL_HOURS_COMPONENT c on f.Component = c.Component
		left join (
			select grouporder, a.DomainId, isnull(ReviewedCount, 0) as ReviewedCount
			from (
					select distinct min(StmtNumber) as grouporder, d.Domain, g.DomainId, count(stmtnumber) Total from [FINANCIAL_DETAILS] fd 
					INNER JOIN FINANCIAL_GROUPS G on FD.FinancialGroupId = g.FinancialGroupId		
					INNER JOIN [FINANCIAL_DOMAINS] AS D ON g.[DomainId] = D.[DomainId]			
					group by g.DomainId, d.Domain
					)  a left join (
					SELECT  g.DomainId, isnull(count(ans_rev.Answer_Id), 0) as ReviewedCount
					FROM       [FINANCIAL_REQUIREMENTS] f
					INNER JOIN [NEW_REQUIREMENT] q ON f.[Requirement_Id] = q.[Requirement_Id]
					INNER JOIN #answers a ON q.[Requirement_Id] = a.[Question_Or_Requirement_Id]
					INNER JOIN #answers ans_rev ON q.[Requirement_Id] = ans_rev.[Question_Or_Requirement_Id]
					INNER JOIN [FINANCIAL_DETAILS] AS FD ON f.[StmtNumber] = FD.[StmtNumber]    
					inner join FINANCIAL_GROUPS G on FD.FinancialGroupId = g.FinancialGroupId
					WHERE ans_rev.Reviewed = 1
					group by g.DomainId
					) b  on a.DomainId = b.DomainId 		
		) b on c.DomainId = b.DomainId
		where f.assessment_id = @assessment_id
		order by PresentationOrder		
			
	END
	
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_StatementsReviewedTabTotals]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: Mar 2, 2019
-- Description:	fill it and if missing get the data 
-- =============================================
ALTER PROCEDURE [dbo].[usp_StatementsReviewedTabTotals]
	@Assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	INSERT INTO [FINANCIAL_HOURS]
				([Assessment_Id]
				,[Component]
				,[ReviewType]
				,[Hours])     
	select a.* from (
	SELECT @assessment_id Assessment_id, Component, ReviewType, [Hours] = 0
		FROM [FINANCIAL_HOURS_COMPONENT], FINANCIAL_REVIEWTYPE) a left join [FINANCIAL_HOURS] f on 
		a.Assessment_id = f.Assessment_Id and a.Component = f.Component and a.ReviewType = f.ReviewType
		where f.Assessment_Id is null
  
	select * from (select Assessment_Id,ReviewType,sum([Hours]) as Totals from FINANCIAL_HOURS
	where assessment_id = @Assessment_id
	group by Assessment_Id,ReviewType) a,(
	select SUM([Hours]) AS GrandTotal from FINANCIAL_HOURS
	where assessment_id = @Assessment_id) b
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_getComponentsRankedCategories]'
GO

-- =============================================
-- Author:		hansbk
-- Create date: 8/1/2018
-- Description:	Stub needs completed
-- =============================================
ALTER PROCEDURE [dbo].[usp_getComponentsRankedCategories]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

/*
TODO this needs to take into account requirements vs questions
get the question set then for all the questions take the total risk (in this set only)
then calculate the total risk in each question_group_heading(category) 
then calculate the actual percentage of the total risk in each category 
order by the total
*/
declare @applicationMode varchar(50)

exec dbo.GetApplicationModeDefault @assessment_id, @ApplicationMode output


declare @maxRank int 
begin

	--declare @assessment_id int
	--set @assessment_id = 1041
	select @maxRank = max(c.Ranking) 
		FROM NEW_QUESTION c 
		join (select distinct question_id from NEW_QUESTION_SETS where Set_Name = 'Components')
		s on c.Question_Id = s.Question_Id

	

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	IF OBJECT_ID('tempdb..#TempAnswered') IS NOT NULL DROP TABLE #TempAnswered

	SELECT h.Question_Group_Heading, isnull(count(c.question_id), 0) qc, isnull(SUM(@maxRank-c.Ranking),0) cr, sum(sum(@maxrank - c.Ranking)) OVER() AS Total into #temp
		FROM Answer_Components a 
		join NEW_QUESTION c on a.Question_Or_Requirement_Id = c.Question_Id
		join vQuestion_Headings h on c.Heading_Pair_Id = h.heading_pair_Id		
		join (
			select distinct s.question_id from NEW_QUESTION_SETS s 
				join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id				
				join UNIVERSAL_SAL_LEVEL ul on l.Universal_Sal_Level = ul.Universal_Sal_Level
				where s.Set_Name = 'Components'
		)
		s on c.Question_Id = s.Question_Id
		where a.Assessment_Id = @assessment_id and a.Answer_Text != 'NA'
		group by Question_Group_Heading
     
	 SELECT h.Question_Group_Heading, isnull(count(c.question_id), 0) nuCount, isnull(SUM(@maxRank-c.Ranking),0) cr into #tempAnswered
		FROM Answer_Components a 
		join NEW_QUESTION c on a.Question_Or_Requirement_Id = c.Question_Id
		join vQuestion_Headings h on c.Heading_Pair_Id = h.heading_pair_Id
		join (
			select distinct s.question_id from NEW_QUESTION_SETS s 
				join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.New_Question_Set_Id				
				join UNIVERSAL_SAL_LEVEL ul on l.Universal_Sal_Level = ul.Universal_Sal_Level
				where s.Set_Name = 'Components'
		)	s on c.Question_Id = s.Question_Id
		where a.Assessment_Id = @assessment_id and a.Answer_Text in ('N','U')
		group by Question_Group_Heading

	select t.*, isnull(a.nuCount,0) nuCount, isnull(a.cr,0) Actualcr, isnull(cast(a.cr as decimal(18,3))/Total,0)*100 [prc],  isnull(a.nuCount,0)/(cast(qc as decimal(18,3))) as [Percent]
	from #temp t left join #tempAnswered a on t.Question_Group_Heading = a.Question_Group_Heading
	order by prc desc	
end
END

GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_AggregationCustomQuestionnaireLoad]'
GO

--drop procedure usp_AggregationCustomQuestionnaireLoad
-- =============================================
-- Author:		hansbk
-- Create date: 6-16-2016
-- Description:	Note that this returns your expected custom control set name it may 
-- not be the same name that went in. 
-- =============================================
ALTER PROCEDURE [dbo].[usp_AggregationCustomQuestionnaireLoad]
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
'		while exists (select * from sets where set_name = @tempEntityName)'+ CHAR(13)+CHAR(10) + 
'		begin'+ CHAR(13)+CHAR(10) + 
'			set @i = @i+1'+ CHAR(13)+CHAR(10) + 
'			set @tempEntityName = @entity_name +convert(varchar,@i)'+CHAR(13)+CHAR(10) + 
'		end'+CHAR(13)+CHAR(10) + 
'	end'+CHAR(13)+CHAR(10) + 
'	INSERT INTO [SETS]'+CHAR(13)+CHAR(10) + 
'			   ([Set_Name],[Full_Name],[Short_Name],[Is_Displayed],[Is_Pass_Fail],[Old_Std_Name],[Set_Category_Id],[Order_In_Category],[Report_Order_Section_Number],[Aggregation_Standard_Number],[Is_Question],[Is_Requirement],[Order_Framework_Standards],[Standard_ToolTip],[Is_Deprecated],[Upgrade_Set_Name],[Is_Custom],[Date],[IsEncryptedModule],[IsEncryptedModuleOpen])'+CHAR(13)+CHAR(10) + 
'		 VALUES(@tempEntityName,@entity_name,@entity_name,1,1,null,1,1,35,35,1,0,35,null,0,null,1,getdate(),0,0)'+CHAR(13)+CHAR(10) + 
'	INSERT INTO [NEW_QUESTION_SETS] ([Set_Name],[Question_Id])     '+CHAR(13)+CHAR(10) + 
'		SELECT [Custom_Questionaire_Name]=@tempEntityName'+CHAR(13)+CHAR(10) + 
'			  ,[Question_Id]'+CHAR(13)+CHAR(10) + 
'		FROM ['+@AssessmentDBName+'].[CUSTOM_QUESTIONAIRE_QUESTIONS]'+CHAR(13)+CHAR(10) + 
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
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_REFERENCES]'
GO
ALTER TABLE [dbo].[MATURITY_REFERENCES] WITH NOCHECK  ADD CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS] FOREIGN KEY ([Mat_Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MATURITY_REFERENCES] WITH NOCHECK  ADD CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE] FOREIGN KEY ([Gen_File_Id]) REFERENCES [dbo].[GEN_FILE] ([Gen_File_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_SOURCE_FILES]'
GO
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] WITH NOCHECK  ADD CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS] FOREIGN KEY ([Mat_Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] WITH NOCHECK  ADD CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE] FOREIGN KEY ([Gen_File_Id]) REFERENCES [dbo].[GEN_FILE] ([Gen_File_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[AVAILABLE_MATURITY_MODELS]'
GO
ALTER TABLE [dbo].[AVAILABLE_MATURITY_MODELS] ADD CONSTRAINT [FK_AVAILABLE_MATURITY_MODELS_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[AVAILABLE_MATURITY_MODELS] ADD CONSTRAINT [FK__AVAILABLE__model__6F6A7CB2] FOREIGN KEY ([model_id]) REFERENCES [dbo].[MATURITY_MODELS] ([Maturity_Model_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_QUESTIONS]'
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] ADD CONSTRAINT [FK__MATURITY___Matur__5B638405] FOREIGN KEY ([Maturity_Level]) REFERENCES [dbo].[MATURITY_LEVELS] ([Maturity_Level_Id])
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] ADD CONSTRAINT [FK__MATURITY___Matur__7152C524] FOREIGN KEY ([Maturity_Model_Id]) REFERENCES [dbo].[MATURITY_MODELS] ([Maturity_Model_Id])
GO
ALTER TABLE [dbo].[MATURITY_QUESTIONS] ADD CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTIONS1] FOREIGN KEY ([Mat_Question_Id]) REFERENCES [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[MATURITY_LEVELS]'
GO
ALTER TABLE [dbo].[MATURITY_LEVELS] ADD CONSTRAINT [FK_MATURITY_LEVELS_MATURITY_MODELS] FOREIGN KEY ([Maturity_Model_Id]) REFERENCES [dbo].[MATURITY_MODELS] ([Maturity_Model_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating extended properties'
GO
BEGIN TRY
	EXEC sp_addextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'MATURITY_REFERENCES', NULL, NULL
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'MATURITY_REFERENCES', NULL, NULL
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	EXEC sp_addextendedproperty N'BELONGS_IN_EA', N'YES', 'SCHEMA', N'dbo', 'TABLE', N'MATURITY_SOURCE_FILES', NULL, NULL
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
BEGIN TRY
	EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'MATURITY_SOURCE_FILES', NULL, NULL
END TRY
BEGIN CATCH
	DECLARE @msg nvarchar(max);
	DECLARE @severity int;
	DECLARE @state int;
	SELECT @msg = ERROR_MESSAGE(), @severity = ERROR_SEVERITY(), @state = ERROR_STATE();
	RAISERROR(@msg, @severity, @state);

	SET NOEXEC ON
END CATCH
GO
COMMIT TRANSACTION
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping roles'
GO
IF EXISTS (SELECT * FROM sys. database_principals WHERE name = N'aduser_role' AND type = 'R')
	DROP ROLE [aduser_role]
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
