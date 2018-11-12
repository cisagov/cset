USE [CSETWeb]
GO
/****** Object:  StoredProcedure [dbo].[CheckHeading]    Script Date: 6/28/2018 8:21:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CheckHeading]
	-- Add the parameters for the stored procedure here
	@Heading varchar(250)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if not exists (SELECT * from Question_Headings where Question_Group_Heading = @heading)
		insert QUESTION_HEADINGS values(@Heading);
END
GO
