/*
Run this script on:

        (localdb)\MSSQLLocalDB.CSETWeb11100    -  This database will be modified

to synchronize it with:

        (localdb)\MSSQLLocalDB.CSETWeb11200

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.6.10.20102 from Red Gate Software Ltd at 6/15/2022 12:39:53 PM

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
PRINT N'Dropping foreign keys from [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS] DROP CONSTRAINT [FK_CIST_CS_SITE_INFORMATION_ASSESSMENTS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS] DROP CONSTRAINT [FK_CIST_CSI_ORGANIZATION_DEMOGRAPHICS_CIST_CSI_STAFF_COUNTS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS] DROP CONSTRAINT [FK_CIST_CSI_ORGANIZATION_DEMOGRAPHICS_CIST_CSI_STAFF_COUNTS_2]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[CIST_CSI_SERVICE_COMPOSITION]'
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_COMPOSITION] DROP CONSTRAINT [FK_CIST_CSI_SERVICE_COMPOSITION_ASSESSMENTS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_COMPOSITION] DROP CONSTRAINT [FK_CIST_CSI_SERVICE_COMPOSITION_CIST_CSI_DEFINING_SYSTEMS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[CIST_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS]'
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS] DROP CONSTRAINT [FK_CIST_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS_CIST_CSI_DEFINING_SYSTEMS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS] DROP CONSTRAINT [FK_CIST_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS_CIST_CSI_SERVICE_COMPOSITION]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS] DROP CONSTRAINT [FK_CIST_CS_DEMOGRAPHICS_ASSESSMENTS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS] DROP CONSTRAINT [FK_CIST_CSI_SERVICE_DEMOGRAPHICS_CIST_CSI_BUDGET_BASES]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS] DROP CONSTRAINT [FK_CIST_CSI_SERVICE_DEMOGRAPHICS_CIST_CSI_CUSTOMER_COUNTS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS] DROP CONSTRAINT [FK_CIST_CSI_SERVICE_DEMOGRAPHICS_CIST_CSI_STAFF_COUNTS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS] DROP CONSTRAINT [FK_CIST_CSI_SERVICE_DEMOGRAPHICS_CIST_CSI_STAFF_COUNTS_2]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS] DROP CONSTRAINT [FK_CIST_CSI_SERVICE_DEMOGRAPHICS_CIST_CSI_USER_COUNTS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping foreign keys from [dbo].[CYOTE_ANSWERS]'
GO
ALTER TABLE [dbo].[CYOTE_ANSWERS] DROP CONSTRAINT [FK_CYOTE_ANSWERS_ASSESSMENT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[CYOTE_ANSWERS] DROP CONSTRAINT [FK_CYOTE_ANSWERS_CYOTE_ANSWERS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[CYOTE_ANSWERS] DROP CONSTRAINT [FK_CYOTE_ANSWERS_OBS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[CYOTE_ANSWERS] DROP CONSTRAINT [FK_CYOTE_ANSWERS_OPTION]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[CYOTE_ANSWERS] DROP CONSTRAINT [FK_CYOTE_ANSWERS_PATH]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CIST_CSI_BUDGET_BASES]'
GO
ALTER TABLE [dbo].[CIST_CSI_BUDGET_BASES] DROP CONSTRAINT [PK_CIST_CSI_BUDGET_BASES]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CIST_CSI_CUSTOMER_COUNTS]'
GO
ALTER TABLE [dbo].[CIST_CSI_CUSTOMER_COUNTS] DROP CONSTRAINT [PK_CIST_CSI_CUSTOMER_AMOUNTS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CIST_CSI_DEFINING_SYSTEMS]'
GO
ALTER TABLE [dbo].[CIST_CSI_DEFINING_SYSTEMS] DROP CONSTRAINT [PK_CIST_CSI_DEFINING_SYSTEMS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS] DROP CONSTRAINT [PK_CIST_CS_SITE_INFORMATION]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CIST_CSI_SERVICE_COMPOSITION]'
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_COMPOSITION] DROP CONSTRAINT [PK_CIST_CSI_SERVICE_COMPOSITION]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CIST_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS]'
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS] DROP CONSTRAINT [PK_CIST_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS] DROP CONSTRAINT [PK_CIST_CS_DEMOGRAPHICS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CIST_CSI_STAFF_COUNTS]'
GO
ALTER TABLE [dbo].[CIST_CSI_STAFF_COUNTS] DROP CONSTRAINT [PK_CIST_CSI_STAFF_AMOUNTS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CIST_CSI_USER_COUNTS]'
GO
ALTER TABLE [dbo].[CIST_CSI_USER_COUNTS] DROP CONSTRAINT [PK_CIST_CSI_USER_AMOUNTS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CYOTE_ANSWERS]'
GO
ALTER TABLE [dbo].[CYOTE_ANSWERS] DROP CONSTRAINT [PK_CYOTE_ANSWERS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CYOTE_OBSERVABLES]'
GO
ALTER TABLE [dbo].[CYOTE_OBSERVABLES] DROP CONSTRAINT [PK_CYOTE_OBSERVABLES]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CYOTE_OPTIONS]'
GO
ALTER TABLE [dbo].[CYOTE_OPTIONS] DROP CONSTRAINT [PK__CYOTE_OP__3260907E3CCCC788]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CYOTE_PATHS]'
GO
ALTER TABLE [dbo].[CYOTE_PATHS] DROP CONSTRAINT [PK_CYOTE_PATHS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CYOTE_PATH_QUESTION]'
GO
ALTER TABLE [dbo].[CYOTE_PATH_QUESTION] DROP CONSTRAINT [PK_CYOTE_PATH_QUESTION]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CYOTE_QUESTIONS]'
GO
ALTER TABLE [dbo].[CYOTE_QUESTIONS] DROP CONSTRAINT [PK__CYOTE_QU__B0B2E4E65627EA23]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[ASSESSMENTS]'
GO
ALTER TABLE [dbo].[ASSESSMENTS] DROP CONSTRAINT [DF_ASSESSMENTS_UseCyote]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CIST_CSI_CUSTOMER_COUNTS]'
GO
ALTER TABLE [dbo].[CIST_CSI_CUSTOMER_COUNTS] DROP CONSTRAINT [DF_CIST_CSI_CUSTOMER_COUNTS_Sequence]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS] DROP CONSTRAINT [DF_CIST_CS_SITE_INFORMATION_Motivation_CRR]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS] DROP CONSTRAINT [DF_CIST_CS_SITE_INFORMATION_Motivation_RRAP]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS] DROP CONSTRAINT [DF_CIST_CS_SITE_INFORMATION_Motivation_Organization_Request]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS] DROP CONSTRAINT [DF_CIST_CS_SITE_INFORMATION_Motivation_Law_Enforcement_Request]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS] DROP CONSTRAINT [DF_CIST_CS_SITE_INFORMATION_Motivation_Direct_Threats]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS] DROP CONSTRAINT [DF_CIST_CS_SITE_INFORMATION_Motivation_Special_Event]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS] DROP CONSTRAINT [DF_CIST_CS_SITE_INFORMATION_Motivation_Other]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS] DROP CONSTRAINT [DF_CIST_CS_SITE_INFORMATION_Completed_For_SLTT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS] DROP CONSTRAINT [DF_CIST_CS_SITE_INFORMATION_Completed_For_Federal]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS] DROP CONSTRAINT [DF_CIST_CS_SITE_INFORMATION_Completed_For_National_Special_Event]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS] DROP CONSTRAINT [DF_CIST_CS_DEMOGRAPHICS_Multi_Site]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CIST_CSI_USER_COUNTS]'
GO
ALTER TABLE [dbo].[CIST_CSI_USER_COUNTS] DROP CONSTRAINT [DF_CIST_CSI_USER_COUNTS_Sequence]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CYOTE_OBSERVABLES]'
GO
ALTER TABLE [dbo].[CYOTE_OBSERVABLES] DROP CONSTRAINT [DF__CYOTE_OBS__Seque__13FCE2E3]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CYOTE_OBSERVABLES]'
GO
ALTER TABLE [dbo].[CYOTE_OBSERVABLES] DROP CONSTRAINT [DF__CYOTE_OBS__Physi__3B16B004]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CYOTE_OBSERVABLES]'
GO
ALTER TABLE [dbo].[CYOTE_OBSERVABLES] DROP CONSTRAINT [DF__CYOTE_OBS__Digit__3C0AD43D]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CYOTE_OBSERVABLES]'
GO
ALTER TABLE [dbo].[CYOTE_OBSERVABLES] DROP CONSTRAINT [DF__CYOTE_OBS__Netwo__3CFEF876]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CYOTE_OBSERVABLES]'
GO
ALTER TABLE [dbo].[CYOTE_OBSERVABLES] DROP CONSTRAINT [DF__CYOTE_OBS__IsFir__3DF31CAF]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CYOTE_OBSERVABLES]'
GO
ALTER TABLE [dbo].[CYOTE_OBSERVABLES] DROP CONSTRAINT [DF_CYOTE_OBSERVABLES_IsAffectingOperations]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CYOTE_OBSERVABLES]'
GO
ALTER TABLE [dbo].[CYOTE_OBSERVABLES] DROP CONSTRAINT [DF_CYOTE_OBS_IsAff_123]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CYOTE_OBSERVABLES]'
GO
ALTER TABLE [dbo].[CYOTE_OBSERVABLES] DROP CONSTRAINT [DF__CYOTE_OBS__IsMul__3EE740E8]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CYOTE_OBSERVABLES]'
GO
ALTER TABLE [dbo].[CYOTE_OBSERVABLES] DROP CONSTRAINT [DF__CYOTE_OBS__IsMul__3FDB6521]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping constraints from [dbo].[CYOTE_PATH_QUESTION]'
GO
ALTER TABLE [dbo].[CYOTE_PATH_QUESTION] DROP CONSTRAINT [DF_CYOTE_PATH_QUESTION_Sequence]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping index [IX_CIST_CSI_DEFINING_SYSTEMS] from [dbo].[CIST_CSI_DEFINING_SYSTEMS]'
GO
DROP INDEX [IX_CIST_CSI_DEFINING_SYSTEMS] ON [dbo].[CIST_CSI_DEFINING_SYSTEMS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[CYOTE_QUESTIONS]'
GO
DROP TABLE [dbo].[CYOTE_QUESTIONS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[CYOTE_PATH_QUESTION]'
GO
DROP TABLE [dbo].[CYOTE_PATH_QUESTION]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[CYOTE_PATHS]'
GO
DROP TABLE [dbo].[CYOTE_PATHS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[CYOTE_OPTIONS]'
GO
DROP TABLE [dbo].[CYOTE_OPTIONS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[CYOTE_OBSERVABLES]'
GO
DROP TABLE [dbo].[CYOTE_OBSERVABLES]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Dropping [dbo].[CYOTE_ANSWERS]'
GO
DROP TABLE [dbo].[CYOTE_ANSWERS]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'[dbo].[CIST_CSI_BUDGET_BASES]', N'CIS_CSI_BUDGET_BASES', N'OBJECT'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'[dbo].[CIST_CSI_CUSTOMER_COUNTS]', N'CIS_CSI_CUSTOMER_COUNTS', N'OBJECT'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'[dbo].[CIST_CSI_DEFINING_SYSTEMS]', N'CIS_CSI_DEFINING_SYSTEMS', N'OBJECT'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'[dbo].[CIST_CSI_ORGANIZATION_DEMOGRAPHICS]', N'CIS_CSI_ORGANIZATION_DEMOGRAPHICS', N'OBJECT'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'[dbo].[CIST_CSI_SERVICE_COMPOSITION]', N'CIS_CSI_SERVICE_COMPOSITION', N'OBJECT'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'[dbo].[CIST_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS]', N'CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS', N'OBJECT'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'[dbo].[CIST_CSI_SERVICE_DEMOGRAPHICS]', N'CIS_CSI_SERVICE_DEMOGRAPHICS', N'OBJECT'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'[dbo].[CIST_CSI_STAFF_COUNTS]', N'CIS_CSI_STAFF_COUNTS', N'OBJECT'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
EXEC sp_rename N'[dbo].[CIST_CSI_USER_COUNTS]', N'CIS_CSI_USER_COUNTS', N'OBJECT'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[ASSESSMENTS]'
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[ASSESSMENTS] DROP
COLUMN [UseCyote]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_Assessments_Completion_For_User]'
GO

ALTER PROCEDURE [dbo].[usp_Assessments_Completion_For_User]
@User_Id int
AS
BEGIN
	SET NOCOUNT ON;

	--This procedure returns the number of answers and total number of available standard, maturity, and diagram questions
	--	available for each of the user's assessments.

	--Creating table variables
	declare @AssessmentCompletedQuestions table(AssessmentId INT, CompletedCount INT)
	declare @AssessmentTotalMaturityQuestionsCount table(AssessmentId INT, TotalMaturityQuestionsCount INT)
	declare @AssessmentTotalStandardQuestionsCount table(AssessmentId INT, TotalStandardQuestionsCount INT)
	declare @AssessmentTotalDiagramQuestionsCount table(AssessmentId INT, TotalDiagramQuestionsCount INT)


	--Creating temp tables to hold applicable questions for each type of question
	select a.Assessment_Id, mq.Mat_Question_Id into #AvailableMatQuestions
		from MATURITY_QUESTIONS mq
		join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			full join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join USERS u on a.AssessmentCreatorId = u.UserId
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where u.UserId = @User_Id and a.UseMaturity = 1 and amm.model_id != 1 and amm.model_id != 2 and amm.model_id != 6


	select a.Assessment_Id, mq.Mat_Question_Id into #AvailableMatQuestionsWithLevels
		from MATURITY_QUESTIONS mq
			join AVAILABLE_MATURITY_MODELS amm on amm.model_id = mq.Maturity_Model_Id
			full join ASSESSMENTS a on a.Assessment_Id = amm.Assessment_Id
			join USERS u on a.AssessmentCreatorId = u.UserId
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			join ASSESSMENT_SELECTED_LEVELS asl on asl.Assessment_Id = a.Assessment_Id
			join MATURITY_LEVELS ml on ml.Maturity_Level_Id = mq.Maturity_Level
			where u.UserId = @User_Id
			and asl.Level_Name = 'Maturity_Level' and asl.Standard_Specific_Sal_Level >= ml.Level


	select a.Assessment_Id, q.question_Id into #AvailableQuestionBasedStandard
		from NEW_QUESTION q
			join NEW_QUESTION_SETS qs on q.Question_Id = qs.Question_Id
			join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id
			join UNIVERSAL_SUB_CATEGORY_HEADINGS usch on q.Heading_Pair_Id = usch.Heading_Pair_Id
			join AVAILABLE_STANDARDS stand on qs.Set_Name = stand.Set_Name
			join QUESTION_GROUP_HEADING qgh on usch.Question_Group_Heading_Id = qgh.Question_Group_Heading_Id
			join UNIVERSAL_SUB_CATEGORIES usc on usch.Universal_Sub_Category_Id = usc.Universal_Sub_Category_Id
			full join ASSESSMENTS a on a.Assessment_Id = stand.Assessment_Id
			join STANDARD_SELECTION ss on ss.Assessment_Id = stand.Assessment_Id and Application_Mode = 'Questions Based'
			join UNIVERSAL_SAL_LEVEL usl on ss.Selected_Sal_Level = usl.Full_Name_Sal
			join USERS u on a.AssessmentCreatorId = u.UserId
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where u.UserId = @User_Id and stand.Selected = 1 and nql.Universal_Sal_Level = usl.Universal_Sal_Level and a.UseStandard = 1


	select a.Assessment_Id, r.Requirement_Id into #AvailableRequirementBasedStandard
		from REQUIREMENT_SETS rs
			join AVAILABLE_STANDARDS stand on stand.Set_Name = rs.Set_Name and stand.Selected = 1
			join NEW_REQUIREMENT r on r.Requirement_Id = rs.Requirement_Id
			full join ASSESSMENTS a on a.Assessment_Id = stand.Assessment_Id
			join STANDARD_SELECTION ss on ss.Assessment_Id = a.assessment_Id and Application_Mode = 'Requirements Based'
			join UNIVERSAL_SAL_LEVEL usl on usl.Full_Name_Sal = ss.Selected_Sal_Level
			join REQUIREMENT_LEVELS rl on rl.Requirement_Id = r.Requirement_Id
			join USERS u on a.AssessmentCreatorId = u.UserId
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where u.UserId = @User_Id and rl.Standard_Level = usl.Universal_Sal_Level


	select a.Assessment_Id, q.Question_Id into #AvailableDiagramQuestions
		from STANDARD_SELECTION ss
			join 
			(select q.question_id, adc.assessment_id
				from ASSESSMENT_DIAGRAM_COMPONENTS adc 			
				join component_questions q on adc.Component_Symbol_Id = q.Component_Symbol_Id
				join STANDARD_SELECTION ss on adc.Assessment_Id = ss.Assessment_Id
				join new_question nq on q.question_id = nq.question_id		
				join new_question_sets qs on nq.question_id = qs.question_id	
				join DIAGRAM_CONTAINER l on adc.Layer_id = l.Container_Id
				left join DIAGRAM_CONTAINER z on adc.Zone_Id = z.Container_Id
				join NEW_QUESTION_LEVELS nql on qs.New_Question_Set_Id = nql.New_Question_Set_Id 
				where l.visible = 1) f on ss.assessment_id = f.assessment_id							
			join NEW_QUESTION q on f.Question_Id = q.Question_Id 
			join vQUESTION_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id	
			join UNIVERSAL_SUB_CATEGORY_HEADINGS usch on usch.Heading_Pair_Id = h.Heading_Pair_Id		    
			join Answer_Components ac on f.Question_Id = ac.Question_Or_Requirement_Id and f.assessment_id = ac.assessment_id
			full join ASSESSMENTS a on a.Assessment_Id = ss.Assessment_Id
			join USERS u on a.AssessmentCreatorId = u.UserId
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where u.UserId = @User_Id and a.UseDiagram = 1


	insert into @AssessmentCompletedQuestions
	select
		AssessmentId = a.Assessment_Id,
		CompletedCount = COUNT(ans.Answer_Id)
		from ASSESSMENTS a 
			join ANSWER ans on ans.Assessment_Id = a.Assessment_Id
			join USERS u on a.AssessmentCreatorId = u.UserId
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where u.UserId = @User_Id and ans.Answer_Text != 'U' 
			and --This ensures the completed question counts are accurate even if users switch assessments types later on
			(ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestions)
			or
			ans.Question_Or_Requirement_Id in (select Mat_Question_Id from #AvailableMatQuestionsWithLevels)
			or
			ans.Question_Or_Requirement_Id in (select Question_Id from #AvailableQuestionBasedStandard)
			or
			ans.Question_Or_Requirement_Id in (select Requirement_Id from #AvailableRequirementBasedStandard)
			or
			ans.Question_Or_Requirement_Id in (select Question_Id from #AvailableDiagramQuestions))
			group by a.Assessment_Id


	--Place 0 in completed questions count for assessments that have no answers yet
	insert into @AssessmentCompletedQuestions
	select
		AssessmentId = Assessment_Id,
		CompletedCount = 0
		from ASSESSMENTS where Assessment_Id 
		not in (select AssessmentId from @AssessmentCompletedQuestions)
		and 
		AssessmentCreatorId = @User_Id
	

	--Maturity questions count (For maturity models with level selection) available to answer
	insert into @AssessmentTotalMaturityQuestionsCount
	select
		AssessmentId = Assessment_Id,
		TotalMaturityQuestionsCount = COUNT(DISTINCT(Mat_Question_Id))
		from #AvailableMatQuestionsWithLevels
		group by Assessment_Id


	--Total Maturity questions count (for maturity models without levels) available to answer
	insert into @AssessmentTotalMaturityQuestionsCount
	select
		AssessmentId = Assessment_Id,
		TotalMaturityQuestionsCount = COUNT(DISTINCT(Mat_Question_Id))
		from #AvailableMatQuestions
		group by Assessment_Id
	

	--Requirements based questions count
	insert into @AssessmentTotalStandardQuestionsCount
	select
		AssessmentId = Assessment_Id,
		TotalStandardQuestionsCount = COUNT(DISTINCT(Requirement_Id))
		from #AvailableRequirementBasedStandard
		group by Assessment_Id


	--Questions based standards questions count
	insert into @AssessmentTotalStandardQuestionsCount
	select
		AssessmentId = Assessment_Id,
		TotalStandardQuestionsCount = COUNT(DISTINCT(Question_Id))
		from #AvailableQuestionBasedStandard
		group by Assessment_Id
	

		--Total diagram questions count
	insert into @AssessmentTotalDiagramQuestionsCount
	select                  
		AssessmentId = a.Assessment_Id,
		TotalDiagramQuestionsCount = COUNT(ans.Answer_Id)
		from ANSWER ans
			join ASSESSMENTS a on a.Assessment_Id = ans.Assessment_Id
			join USERS u on a.AssessmentCreatorId = u.UserId
			join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id
			where u.UserId = @User_Id and a.UseDiagram = 1 and ans.Question_Type = 'Component'
			group by a.Assessment_Id
	
	select
		AssessmentId = acq.AssessmentId,
		CompletedCount = acq.CompletedCount,
		TotalMaturityQuestionsCount = atmq.TotalMaturityQuestionsCount,
		TotalStandardQuestionsCount = atsq.TotalStandardQuestionsCount,
		TotalDiagramQuestionsCount = atdq.TotalDiagramQuestionsCount
		from @AssessmentCompletedQuestions acq
			full join @AssessmentTotalMaturityQuestionsCount atmq on atmq.AssessmentId = acq.AssessmentId
			full join @AssessmentTotalStandardQuestionsCount atsq on atsq.AssessmentId = acq.AssessmentId
			full join @AssessmentTotalDiagramQuestionsCount atdq on atdq.AssessmentId = acq.AssessmentId
END	
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Altering [dbo].[usp_Assessments_For_User]'
GO

ALTER PROCEDURE [dbo].[usp_Assessments_For_User]
@User_Id int
AS
SET NOCOUNT ON;

-- Replaces view Assessments_For_User.  Gathering missing alt justification is
-- more straightforward using a procedure than a view.

-- build a table variable with ALT answers without justification
declare @ATM table(assessment_id INT)

insert into @ATM
select distinct assessment_id 
from Answer_Standards_InScope
where (isnull(alternate_justification, '') = '' and answer_text = 'A')

insert into @ATM
select distinct assessment_id 
from Answer_Maturity
where (isnull(alternate_justification, '') = '' and answer_text = 'A')

insert into @ATM
select distinct assessment_id 
from Answer_Components_InScope
where (isnull(alternate_justification, '') = '' and answer_text = 'A')

select 	
    AssessmentId = a.Assessment_Id,
	AssessmentName = Assessment_Name,
	AssessmentDate = Assessment_Date,
	AssessmentCreatedDate,	
	LastModifiedDate,
	MarkedForReview = isnull(mark_for_review,0),
	UseDiagram,
	UseStandard,
	UseMaturity,	
	workflow,
	SelectedMaturityModel = m.Model_Name,
	SelectedStandards = string_agg(s.Short_Name, ', '),
	case when a.assessment_id in (select assessment_id from @ATM) then CAST(1 AS BIT) else CAST(0 AS BIT) END as AltTextMissing,
	c.UserId
	from ASSESSMENTS a 
		join INFORMATION i on a.Assessment_Id = i.Id
		left join AVAILABLE_MATURITY_MODELS amm on amm.Assessment_Id = a.Assessment_Id
		left join MATURITY_MODELS m on m.Maturity_Model_Id = amm.model_id
		left join AVAILABLE_STANDARDS astd on astd.Assessment_Id = a.Assessment_Id
		left join SETS s on s.Set_Name = astd.Set_Name		
		join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id		
		left join (
			select distinct a.Assessment_Id, v.Mark_For_Review
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
			where v.Mark_For_Review = 1) b 
			
		on a.Assessment_Id = b.Assessment_Id
		where c.UserId = @User_Id
		group by a.Assessment_Id, Assessment_Name, Assessment_Date, AssessmentCreatedDate, 
					LastModifiedDate, mark_for_review, UseDiagram,
					UseStandard, UseMaturity, Workflow, Model_Name, c.UserId
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIS_CSI_BUDGET_BASES] on [dbo].[CIS_CSI_BUDGET_BASES]'
GO
ALTER TABLE [dbo].[CIS_CSI_BUDGET_BASES] ADD CONSTRAINT [PK_CIS_CSI_BUDGET_BASES] PRIMARY KEY CLUSTERED ([Budget_Basis])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIS_CSI_CUSTOMER_AMOUNTS] on [dbo].[CIS_CSI_CUSTOMER_COUNTS]'
GO
ALTER TABLE [dbo].[CIS_CSI_CUSTOMER_COUNTS] ADD CONSTRAINT [PK_CIS_CSI_CUSTOMER_AMOUNTS] PRIMARY KEY CLUSTERED ([Customer_Count])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIS_CSI_DEFINING_SYSTEMS] on [dbo].[CIS_CSI_DEFINING_SYSTEMS]'
GO
ALTER TABLE [dbo].[CIS_CSI_DEFINING_SYSTEMS] ADD CONSTRAINT [PK_CIS_CSI_DEFINING_SYSTEMS] PRIMARY KEY CLUSTERED ([Defining_System_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIS_CS_SITE_INFORMATION] on [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS] ADD CONSTRAINT [PK_CIS_CS_SITE_INFORMATION] PRIMARY KEY CLUSTERED ([Assessment_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIS_CSI_SERVICE_COMPOSITION] on [dbo].[CIS_CSI_SERVICE_COMPOSITION]'
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_COMPOSITION] ADD CONSTRAINT [PK_CIS_CSI_SERVICE_COMPOSITION] PRIMARY KEY CLUSTERED ([Assessment_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS] on [dbo].[CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS]'
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS] ADD CONSTRAINT [PK_CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS] PRIMARY KEY CLUSTERED ([Assessment_Id], [Defining_System_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIS_CS_DEMOGRAPHICS] on [dbo].[CIS_CSI_SERVICE_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_DEMOGRAPHICS] ADD CONSTRAINT [PK_CIS_CS_DEMOGRAPHICS] PRIMARY KEY CLUSTERED ([Assessment_Id])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIS_CSI_STAFF_AMOUNTS] on [dbo].[CIS_CSI_STAFF_COUNTS]'
GO
ALTER TABLE [dbo].[CIS_CSI_STAFF_COUNTS] ADD CONSTRAINT [PK_CIS_CSI_STAFF_AMOUNTS] PRIMARY KEY CLUSTERED ([Staff_Count])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating primary key [PK_CIS_CSI_USER_AMOUNTS] on [dbo].[CIS_CSI_USER_COUNTS]'
GO
ALTER TABLE [dbo].[CIS_CSI_USER_COUNTS] ADD CONSTRAINT [PK_CIS_CSI_USER_AMOUNTS] PRIMARY KEY CLUSTERED ([User_Count])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Creating index [IX_CIS_CSI_DEFINING_SYSTEMS] on [dbo].[CIS_CSI_DEFINING_SYSTEMS]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_CIS_CSI_DEFINING_SYSTEMS] ON [dbo].[CIS_CSI_DEFINING_SYSTEMS] ([Defining_System])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIS_CS_SITE_INFORMATION_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIS_CSI_ORGANIZATION_DEMOGRAPHICS_CIS_CSI_STAFF_COUNTS] FOREIGN KEY ([Cybersecurity_IT_ICS_Staff_Count]) REFERENCES [dbo].[CIS_CSI_STAFF_COUNTS] ([Staff_Count]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIS_CSI_ORGANIZATION_DEMOGRAPHICS_CIS_CSI_STAFF_COUNTS_2] FOREIGN KEY ([IT_ICS_Staff_Count]) REFERENCES [dbo].[CIS_CSI_STAFF_COUNTS] ([Staff_Count])
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[CIS_CSI_SERVICE_COMPOSITION]'
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_COMPOSITION] ADD CONSTRAINT [FK_CIS_CSI_SERVICE_COMPOSITION_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_COMPOSITION] ADD CONSTRAINT [FK_CIS_CSI_SERVICE_COMPOSITION_CIS_CSI_DEFINING_SYSTEMS] FOREIGN KEY ([Primary_Defining_System]) REFERENCES [dbo].[CIS_CSI_DEFINING_SYSTEMS] ([Defining_System_Id]) ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS]'
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS] ADD CONSTRAINT [FK_CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS_CIS_CSI_DEFINING_SYSTEMS] FOREIGN KEY ([Defining_System_Id]) REFERENCES [dbo].[CIS_CSI_DEFINING_SYSTEMS] ([Defining_System_Id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS] ADD CONSTRAINT [FK_CIS_CSI_SERVICE_COMPOSITION_SECONDARY_DEFINING_SYSTEMS_CIS_CSI_SERVICE_COMPOSITION] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[CIS_CSI_SERVICE_COMPOSITION] ([Assessment_Id]) ON DELETE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding foreign keys to [dbo].[CIS_CSI_SERVICE_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIS_CS_DEMOGRAPHICS_ASSESSMENTS] FOREIGN KEY ([Assessment_Id]) REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIS_CSI_SERVICE_DEMOGRAPHICS_CIS_CSI_BUDGET_BASES] FOREIGN KEY ([Budget_Basis]) REFERENCES [dbo].[CIS_CSI_BUDGET_BASES] ([Budget_Basis]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIS_CSI_SERVICE_DEMOGRAPHICS_CIS_CSI_CUSTOMER_COUNTS] FOREIGN KEY ([Customers_Count]) REFERENCES [dbo].[CIS_CSI_CUSTOMER_COUNTS] ([Customer_Count]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIS_CSI_SERVICE_DEMOGRAPHICS_CIS_CSI_STAFF_COUNTS] FOREIGN KEY ([IT_ICS_Staff_Count]) REFERENCES [dbo].[CIS_CSI_STAFF_COUNTS] ([Staff_Count]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIS_CSI_SERVICE_DEMOGRAPHICS_CIS_CSI_STAFF_COUNTS_2] FOREIGN KEY ([Cybersecurity_IT_ICS_Staff_Count]) REFERENCES [dbo].[CIS_CSI_STAFF_COUNTS] ([Staff_Count])
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_DEMOGRAPHICS] ADD CONSTRAINT [FK_CIS_CSI_SERVICE_DEMOGRAPHICS_CIS_CSI_USER_COUNTS] FOREIGN KEY ([Authorized_Non_Organizational_User_Count]) REFERENCES [dbo].[CIS_CSI_USER_COUNTS] ([User_Count]) ON UPDATE CASCADE
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[CIS_CSI_CUSTOMER_COUNTS]'
GO
ALTER TABLE [dbo].[CIS_CSI_CUSTOMER_COUNTS] ADD CONSTRAINT [DF_CIS_CSI_CUSTOMER_COUNTS_Sequence] DEFAULT ((0)) FOR [Sequence]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS] ADD CONSTRAINT [DF_CIS_CS_SITE_INFORMATION_Motivation_CRR] DEFAULT ((0)) FOR [Motivation_CRR]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS] ADD CONSTRAINT [DF_CIS_CS_SITE_INFORMATION_Motivation_RRAP] DEFAULT ((0)) FOR [Motivation_RRAP]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS] ADD CONSTRAINT [DF_CIS_CS_SITE_INFORMATION_Motivation_Organization_Request] DEFAULT ((0)) FOR [Motivation_Organization_Request]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS] ADD CONSTRAINT [DF_CIS_CS_SITE_INFORMATION_Motivation_Law_Enforcement_Request] DEFAULT ((0)) FOR [Motivation_Law_Enforcement_Request]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS] ADD CONSTRAINT [DF_CIS_CS_SITE_INFORMATION_Motivation_Direct_Threats] DEFAULT ((0)) FOR [Motivation_Direct_Threats]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS] ADD CONSTRAINT [DF_CIS_CS_SITE_INFORMATION_Motivation_Special_Event] DEFAULT ((0)) FOR [Motivation_Special_Event]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS] ADD CONSTRAINT [DF_CIS_CS_SITE_INFORMATION_Motivation_Other] DEFAULT ((0)) FOR [Motivation_Other]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS] ADD CONSTRAINT [DF_CIS_CS_SITE_INFORMATION_Completed_For_SLTT] DEFAULT ((0)) FOR [Completed_For_SLTT]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS] ADD CONSTRAINT [DF_CIS_CS_SITE_INFORMATION_Completed_For_Federal] DEFAULT ((0)) FOR [Completed_For_Federal]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
ALTER TABLE [dbo].[CIS_CSI_ORGANIZATION_DEMOGRAPHICS] ADD CONSTRAINT [DF_CIS_CS_SITE_INFORMATION_Completed_For_National_Special_Event] DEFAULT ((0)) FOR [Completed_For_National_Special_Event]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[CIS_CSI_SERVICE_DEMOGRAPHICS]'
GO
ALTER TABLE [dbo].[CIS_CSI_SERVICE_DEMOGRAPHICS] ADD CONSTRAINT [DF_CIS_CS_DEMOGRAPHICS_Multi_Site] DEFAULT ((0)) FOR [Multi_Site]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
PRINT N'Adding constraints to [dbo].[CIS_CSI_USER_COUNTS]'
GO
ALTER TABLE [dbo].[CIS_CSI_USER_COUNTS] ADD CONSTRAINT [DF_CIS_CSI_USER_COUNTS_Sequence] DEFAULT ((0)) FOR [Sequence]
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
