CREATE VIEW dbo.vParameters
AS
SELECT        p.Parameter_ID, p.Parameter_Name, ISNULL(a.Parameter_Value_Assessment, p.Parameter_Name) AS Default_Value, a.Assessment_ID
FROM            dbo.PARAMETERS AS p LEFT OUTER JOIN
                         dbo.PARAMETER_ASSESSMENT AS a ON p.Parameter_ID = a.Parameter_ID
