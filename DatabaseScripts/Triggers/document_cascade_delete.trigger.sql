CREATE TRIGGER [dbo].[document_cascade_delete]
ON [dbo].[ASSESSMENTS]
FOR DELETE
AS

	DELETE FROM DOCUMENT_FILE
	WHERE  Assessment_Id IN (  SELECT Assessment_Id
	                        FROM deleted )
