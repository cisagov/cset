USE [CSETWeb]
GO
/****** Object:  StoredProcedure [dbo].[clean_em_out]    Script Date: 6/28/2018 8:21:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[clean_em_out]
	-- Add the parameters for the stored procedure here	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --clean out everything but components
    DELETE dbo.NEW_QUESTION_LEVELS WHERE Set_Name != 'Components'
	Delete dbo.NEW_QUESTION_SETS WHERE set_name != 'Components'
	DELETE dbo.NEW_QUESTION_USER_NUMBERS
	

END
GO
