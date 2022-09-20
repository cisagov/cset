CREATE VIEW [dbo].[ExcelExport]
AS
SELECT dbo.INFORMATION.Assessment_Name, dbo.INFORMATION.Facility_Name, dbo.INFORMATION.City_Or_Site_Name, dbo.INFORMATION.State_Province_Or_Region, dbo.INFORMATION.Executive_Summary, 
                  dbo.ASSESSMENTS.Assessment_Id, dbo.ASSESSMENTS.AssessmentCreatedDate, dbo.ASSESSMENTS.AssessmentCreatorId, dbo.ASSESSMENTS.LastModifiedDate, dbo.ASSESSMENTS.Alias, dbo.ASSESSMENTS.Assessment_GUID, 
                  dbo.ASSESSMENTS.Assessment_Date, dbo.ASSESSMENTS.CreditUnionName, dbo.ASSESSMENTS.Charter, dbo.ASSESSMENTS.Assets, dbo.INFORMATION.Assessment_Description, dbo.USERS.PrimaryEmail, dbo.USERS.UserId, 
                  dbo.USERS.PasswordResetRequired, dbo.USERS.FirstName, dbo.USERS.LastName
FROM     dbo.ASSESSMENTS INNER JOIN
                  dbo.INFORMATION ON dbo.ASSESSMENTS.Assessment_Id = dbo.INFORMATION.Id INNER JOIN
                  dbo.USERS ON dbo.ASSESSMENTS.AssessmentCreatorId = dbo.USERS.UserId
