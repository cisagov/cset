/*
Run this script on:

        (localdb)\INLLocalDb2022.CSETWeb12027    -  This database will be modified

to synchronize it with:

        (localdb)\INLLocalDb2022.CSETWeb12028

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.10.9.22680 from Red Gate Software Ltd at 8/24/2023 4:06:17 PM

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
PRINT N'Creating [dbo].[usp_getCSETQuestionsForCRRM]'
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/15/2023
-- Description:	gets the general questions regardless of maturity,new_question,or new_requirement
-- =============================================
CREATE PROCEDURE [dbo].[usp_getCSETQuestionsForCRRM]
	-- Add the parameters for the stored procedure here
	@setname varchar(100)		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select Type='q',  q.question_id as Id,Simple_Question as question,r.Supplemental_Info as Info,h.Question_Group_Heading as Heading,h.Universal_Sub_Category as SubHeading,Set_Name as SetName 
	from NEW_QUESTION q 
	join REQUIREMENT_QUESTIONS_SETS s on q.Question_Id=s.Question_Id
	join NEW_REQUIREMENT r on s.Requirement_Id=r.Requirement_Id
	join vQUESTION_HEADINGS h on q.Heading_Pair_Id=h.Heading_Pair_Id
	where s.Set_Name = @setname
	union
	select Type='r',  r.Requirement_Id as Id, r.Requirement_Text as question,r.Supplemental_Info as Info,r.Standard_Category as Heading,r.Standard_Sub_Category as SubHeading,s.Set_Name as setname
	from REQUIREMENT_QUESTIONS_SETS s
	join NEW_REQUIREMENT r on s.Requirement_Id=r.Requirement_Id
	where s.Set_Name = @setname
	union
	select Type='m', mat_question_id as Id ,Question_Text as queestion,Supplemental_Info as Info,g.Title as Heading, Question_Title as SubHeading, m.Model_Name as setname
	from MATURITY_QUESTIONS q 
	join MATURITY_GROUPINGS g on q.Grouping_Id=g.Grouping_Id
	join MATURITY_MODELS m on q.Maturity_Model_Id=m.Maturity_Model_Id and g.Maturity_Model_Id=m.Maturity_Model_Id
	where m.Model_Name = @setname
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
