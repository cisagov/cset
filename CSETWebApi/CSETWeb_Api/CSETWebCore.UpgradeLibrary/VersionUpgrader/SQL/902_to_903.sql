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
			INSERT INTO [dbo].[ANSWER]  ([Is_Requirement],[Question_Or_Requirement_Id],[Component_Id]
           ,[Answer_Text],[Is_Component],[Is_Framework],[Assessment_Id])     
		select Is_Requirement=0,s.Question_id,Component_Id =0, Answer_Text = 'U', Is_Component='0',Is_Framework=0, Assessment_Id =@Assessment_Id
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
		INSERT INTO [dbo].[ANSWER]  ([Is_Requirement],[Question_Or_Requirement_Id],[Component_Id]
           ,[Answer_Text],[Is_Component],[Is_Framework],[Assessment_Id])     
		select distinct Is_Requirement=1,s.Requirement_Id,Component_Id =0, Answer_Text = 'U', Is_Component='0',Is_Framework=0,av.Assessment_Id 
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
PRINT N'Dropping foreign keys from [dbo].[ASSESSMENT_CONTACTS]'
GO
ALTER TABLE [dbo].[ASSESSMENT_CONTACTS] DROP CONSTRAINT [FK_ASSESSMENT_CONTACTS_USERS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[ASSESSMENTS]'
GO
ALTER TABLE [dbo].[ASSESSMENTS] DROP CONSTRAINT [FK_ASSESSMENTS_USERS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[USER_SECURITY_QUESTIONS]'
GO
ALTER TABLE [dbo].[USER_SECURITY_QUESTIONS] DROP CONSTRAINT [FK_USER_SECURITY_QUESTIONS_USERS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[USERS]'
GO
ALTER TABLE [dbo].[USERS] DROP CONSTRAINT [IX_USERS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[FiltersNormalized]'
GO
CREATE TABLE [dbo].[FiltersNormalized]
(
[Assessment_Id] [int] NOT NULL,
[DomainId] [int] NOT NULL,
[MaturityId] [int] NOT NULL
)
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_FiltersNormalized] on [dbo].[FiltersNormalized]'
GO
ALTER TABLE [dbo].[FiltersNormalized] ADD CONSTRAINT [PK_FiltersNormalized] PRIMARY KEY CLUSTERED  ([Assessment_Id], [DomainId], [MaturityId])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating trigger [dbo].[Move_Domain_Filters_To_Normal_Form] on [dbo].[FINANCIAL_DOMAIN_FILTERS]'
GO
CREATE trigger [dbo].[Move_Domain_Filters_To_Normal_Form]
on [dbo].[FINANCIAL_DOMAIN_FILTERS]
	after UPDATE, INSERT, DELETE
as
--delete first
    delete filtersnormalized from deleted
	where filtersnormalized.Assessment_Id = deleted.assessment_id
		 and filtersnormalized.DomainId = deleted.DomainId 
		 and maturityid = 1		 
	delete filtersnormalized from deleted
	where filtersnormalized.Assessment_Id = deleted.assessment_id
		 and filtersnormalized.DomainId = deleted.DomainId 
		 and maturityid = 2		 
	delete filtersnormalized from deleted
	where filtersnormalized.Assessment_Id = deleted.assessment_id
		 and filtersnormalized.DomainId = deleted.DomainId 
		 and maturityid = 3		 
	delete filtersnormalized from deleted
	where filtersnormalized.Assessment_Id = deleted.assessment_id
		 and filtersnormalized.DomainId = deleted.DomainId 
		 and maturityid = 4		 
	delete filtersnormalized from deleted
	where filtersnormalized.Assessment_Id = deleted.assessment_id
		 and filtersnormalized.DomainId = deleted.DomainId 
		 and maturityid = 5		 
--then insert
	INSERT INTO [dbo].[FiltersNormalized] ([Assessment_Id],[DomainId],[MaturityId])
	select assessment_id, domainid, 1 from inserted where B = 1;
	INSERT INTO [dbo].[FiltersNormalized] ([Assessment_Id],[DomainId],[MaturityId])
	select assessment_id, domainid, 2 from inserted where E = 1;
	INSERT INTO [dbo].[FiltersNormalized] ([Assessment_Id],[DomainId],[MaturityId])
	select assessment_id, domainid, 3 from inserted where [int] = 1;
	INSERT INTO [dbo].[FiltersNormalized] ([Assessment_Id],[DomainId],[MaturityId])
	select assessment_id, domainid, 4 from inserted where [A] = 1;
	INSERT INTO [dbo].[FiltersNormalized] ([Assessment_Id],[DomainId],[MaturityId])
	select assessment_id, domainid, 5 from inserted where [inn] = 1;




GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating [dbo].[usp_getFinancialQuestions]'
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getFinancialQuestions]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select r.Requirement_title, r.Requirement_text, a.Answer_text, m.MaturityLevel  from 
	filtersNormalized f 	
	join FINANCIAL_GROUPS g on f.domainid = g.domainid and f.MaturityId = g.MaturityId
	join FINANCIAL_MATURITY m on g.MaturityId = m.MaturityId
	join FINANCIAL_DETAILS fd on g.FinancialGroupId = fd.FinancialGroupId
	join FINANCIAL_REQUIREMENTS fr on fd.StmtNumber = fr.StmtNumber
	join NEW_REQUIREMENT r on fr.Requirement_Id=r.Requirement_Id
	join Answer_Requirements a on r.requirement_id = a.Question_Or_Requirement_Id 
where a.assessment_id = @assessment_id and f.assessment_id = @assessment_id
END
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[USERS]'
GO
ALTER TABLE [dbo].[USERS] ADD CONSTRAINT [IX_USERS] UNIQUE NONCLUSTERED  ([PrimaryEmail])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ASSESSMENT_CONTACTS]'
GO
ALTER TABLE [dbo].[ASSESSMENT_CONTACTS] ADD CONSTRAINT [FK_ASSESSMENT_CONTACTS_USERS] FOREIGN KEY ([UserId]) REFERENCES [dbo].[USERS] ([UserId]) ON DELETE CASCADE ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[ASSESSMENTS]'
GO
ALTER TABLE [dbo].[ASSESSMENTS] ADD CONSTRAINT [FK_ASSESSMENTS_USERS] FOREIGN KEY ([AssessmentCreatorId]) REFERENCES [dbo].[USERS] ([UserId]) ON DELETE SET NULL
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[USER_SECURITY_QUESTIONS]'
GO
ALTER TABLE [dbo].[USER_SECURITY_QUESTIONS] ADD CONSTRAINT [FK_USER_SECURITY_QUESTIONS_USERS] FOREIGN KEY ([UserId]) REFERENCES [dbo].[USERS] ([UserId]) ON DELETE CASCADE ON UPDATE CASCADE
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
update [FINANCIAL_DOMAIN_FILTERS] set B = B
GO