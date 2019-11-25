-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[ASSESSMENT_DIAGRAM_COMPONENT_DELETE_Trigger]
   ON  [dbo].[ASSESSMENT_DIAGRAM_COMPONENTS]
   For DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	 DELETE dbo.answer FROM deleted
		WHERE answer.Assessment_Id = deleted.Assessment_Id and answer.Component_Guid = deleted.Component_Guid

END
