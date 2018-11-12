USE [CSETWeb]
GO
/****** Object:  StoredProcedure [dbo].[final_data_moves]    Script Date: 6/28/2018 8:21:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[final_data_moves]	
AS
BEGIN
	
	SET NOCOUNT ON;

    insert NEW_QUESTION_SETS (Set_Name,Question_Id)
	SELECT distinct 'Standards',QUESTION_id FROM NEW_QUESTION_sets where Set_Name !='Components';
	
	update QUESTION_REQUIREMENT_SUPPLEMENTAL set Default_Standard_Level = 0 where default_standard_level is null;
END
GO
