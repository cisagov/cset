/*
Run this script on:

(localdb)\MSSQLLocalDB.CSETWeb11100    -  This database will be modified

to synchronize it with:

(localdb)\MSSQLLocalDB.CSETWeb11200

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.7.8.21163 from Red Gate Software Ltd at 6/23/2022 7:39:33 AM

*/
		
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS, NOCOUNT ON
GO
SET DATEFORMAT YMD
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL Serializable
GO
BEGIN TRANSACTION

PRINT(N'Drop constraints from [dbo].[MATURITY_REFERENCE_TEXT]')
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]

PRINT(N'Drop constraints from [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_OPTIONS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTION_TYPES]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1 from [dbo].[MATURITY_ANSWER_OPTIONS]')
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] NOCHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1]

PRINT(N'Drop constraint FK_MATURITY_REFERENCES_MATURITY_QUESTIONS from [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS from [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]

PRINT(N'Drop constraints from [dbo].[REQUIREMENT_SOURCE_FILES]')
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] NOCHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] NOCHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT]

PRINT(N'Drop constraints from [dbo].[NEW_QUESTION_LEVELS]')
ALTER TABLE [dbo].[NEW_QUESTION_LEVELS] NOCHECK CONSTRAINT [FK_NEW_QUESTION_LEVELS_NEW_QUESTION_SETS]
ALTER TABLE [dbo].[NEW_QUESTION_LEVELS] NOCHECK CONSTRAINT [FK_NEW_QUESTION_LEVELS_UNIVERSAL_SAL_LEVEL]

PRINT(N'Drop constraints from [dbo].[NEW_QUESTION_SETS]')
ALTER TABLE [dbo].[NEW_QUESTION_SETS] NOCHECK CONSTRAINT [FK_NEW_QUESTION_SETS_NEW_QUESTION]
ALTER TABLE [dbo].[NEW_QUESTION_SETS] NOCHECK CONSTRAINT [FK_NEW_QUESTION_SETS_SETS]

PRINT(N'Drop constraints from [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_GROUPING_TYPES]
ALTER TABLE [dbo].[MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_MODELS]

PRINT(N'Drop constraint FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS from [dbo].[MATURITY_DOMAIN_REMARKS]')
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] NOCHECK CONSTRAINT [FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS]

PRINT(N'Drop constraints from [dbo].[ANALYTICS_MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[ANALYTICS_MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_ANALYTICS_MATURITY_GROUPINGS_MATURITY_MODELS]

PRINT(N'Delete rows from [dbo].[MATURITY_REFERENCE_TEXT]')
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 6023 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 6071 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 6078 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 6088 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 6094 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 6095 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 6100 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 6101 AND [Sequence] = 1
PRINT(N'Operation applied to 8 rows out of 8')

PRINT(N'Delete rows from [dbo].[ANALYTICS_MATURITY_GROUPINGS]')
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 5917 AND [Question_Group] = 'Cybersecurity Leadership'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 5918 AND [Question_Group] = 'Cybersecurity Leadership'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 5932 AND [Question_Group] = 'Change Management'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 5933 AND [Question_Group] = 'Change Management'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 5940 AND [Question_Group] = 'Lifecycle Tracking'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 5941 AND [Question_Group] = 'Lifecycle Tracking'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 5944 AND [Question_Group] = 'Assessment and Evaluations'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 5945 AND [Question_Group] = 'Assessment and Evaluations'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 5948 AND [Question_Group] = 'Cybersecurity Plan'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 5949 AND [Question_Group] = 'Cybersecurity Plan'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 5951 AND [Question_Group] = 'Cybersecurity Exercises'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 5952 AND [Question_Group] = 'Cybersecurity Exercises'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 5966 AND [Question_Group] = 'Personnel'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 5967 AND [Question_Group] = 'Personnel'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 5972 AND [Question_Group] = 'Cybersecurity Training'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 5973 AND [Question_Group] = 'Cybersecurity Training'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 5983 AND [Question_Group] = 'Authentication and Authorization Controls'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 5984 AND [Question_Group] = 'Authentication and Authorization Controls'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 6006 AND [Question_Group] = 'Information Protection'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 6007 AND [Question_Group] = 'Information Protection'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 6009 AND [Question_Group] = 'User Training'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 6010 AND [Question_Group] = 'User Training'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 6012 AND [Question_Group] = 'Defense Sophistication and Compensating Controls'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 6013 AND [Question_Group] = 'Defense Sophistication and Compensating Controls'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 6016 AND [Question_Group] = 'Incident Response Measures'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 6017 AND [Question_Group] = 'Incident Response Measures'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 6026 AND [Question_Group] = 'Alternate Site and Disaster Recovery'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 6027 AND [Question_Group] = 'Alternate Site and Disaster Recovery'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 6029 AND [Question_Group] = 'Dependencies - Data at Rest'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 6030 AND [Question_Group] = 'Dependencies - Data at Rest'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 6032 AND [Question_Group] = 'Dependencies - Data in Motion'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 6033 AND [Question_Group] = 'Dependencies - Data in Motion'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 6035 AND [Question_Group] = 'Dependencies - Data in Process'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 6036 AND [Question_Group] = 'Dependencies - Data in Process'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 6038 AND [Question_Group] = 'Dependencies - End Point Systems'
DELETE FROM [dbo].[ANALYTICS_MATURITY_GROUPINGS] WHERE [Maturity_Model_Id] = 8 AND [Maturity_Question_Id] = 6039 AND [Question_Group] = 'Dependencies - End Point Systems'
PRINT(N'Operation applied to 36 rows out of 36')

PRINT(N'Update rows in [dbo].[MATURITY_QUESTIONS]')
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<div>Critical System outage or loss impact will depend on the severity of an outage. If your&#160;<span>whole site is lost, the impact will be moving to alternative location, if a mail server is lost, the&#160;</span><span>impact may be minimal due to other means of communications.</span></div>' WHERE [Mat_Question_Id] = 6018
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<div>If the outage of the Critical Service occurs, how quickly are you likely to see the impact on&#160;<span>your operations?</span></div>' WHERE [Mat_Question_Id] = 6019
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<div>Your alternate site is typically tested by means of a scenario based activity such as a&#160;<span>simulated Critical System outage or loss, requiring operations to change locations. The&#160;</span><span>test may also be a simple function check performed by information technology personnel.</span></div>' WHERE [Mat_Question_Id] = 6023
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<div>If the servers or the HMI are destroyed how long will it take before the Critical Service is a<span>ffected? As a note, this should NOT be the effect on the business service, but on the&#160;</span>Critical Service<span>. For example, a police records system may be instantly effected by the loss of&#160;</span><span>its servers (I.E. 0 Minutes), but that there may be another method to continue business.</span></div>' WHERE [Mat_Question_Id] = 6071
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=2 WHERE [Mat_Question_Id] = 6075
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=4 WHERE [Mat_Question_Id] = 6076
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=5 WHERE [Mat_Question_Id] = 6077
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<div>If the external communication lines are destroyed how long will it take before the Critical Service&#160;<span>is affected? As a note, this should NOT be the effect on the business service, but on the&#160;</span>Critical Service<span>. For example, a police records system may be instantly effected by the loss of its&#160;</span><span>ability to communicate remotely (I.E. 0 Minutes), but that there may be another method to continue&#160;</span><span>business.</span></div>', [Sequence]=9 WHERE [Mat_Question_Id] = 6078
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=7 WHERE [Mat_Question_Id] = 6079
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=8 WHERE [Mat_Question_Id] = 6080
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=10 WHERE [Mat_Question_Id] = 6081
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=11 WHERE [Mat_Question_Id] = 6082
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=12 WHERE [Mat_Question_Id] = 6083
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=3 WHERE [Mat_Question_Id] = 6084
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=6 WHERE [Mat_Question_Id] = 6085
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=15 WHERE [Mat_Question_Id] = 6087
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<div>If the internal communication lines are destroyed how long will it take before the cCritical Service<span>&#160;is affected? As a note, this should NOT be the effect on the business service, but on the&#160;</span>Critical Service<span>. For example, a police records system may be instantly effected by the loss&#160;</span><span>of its ability to communicate remotely (I.E. 0 Minutes), but that there may be another method to&#160;</span><span>continue business.</span></div>' WHERE [Mat_Question_Id] = 6088
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=17 WHERE [Mat_Question_Id] = 6089
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=18 WHERE [Mat_Question_Id] = 6090
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=19 WHERE [Mat_Question_Id] = 6091
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=20 WHERE [Mat_Question_Id] = 6092
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<div>If the mainframe, server farm or cloud provider are destroyed how long will it take before the Critical Service<span>&#160;is affected? As a note, this should NOT be the effect on the business service, but on&#160;</span><span>the&#160;</span>Critical Service<span>. For example, a police records system may be instantly affected by the loss&#160;</span><span>of its mainframe (I.E. 0 Minutes), but that there may be another method to continue business.</span></div>' WHERE [Mat_Question_Id] = 6094
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<div>If the mainframe, server farm or cloud provider are destroyed how much of an impact will it have on&#160;<span>the&#160;</span>Critical Service<span>? As a note, this should NOT be the effect on the business service, but on&#160;</span><span>the&#160;</span><span>Critical Service</span><span>. As a second note, you should not take into account any redundancy or&#160;</span><span>alternative modes that may have been identified in the Alternate Site Section. For example, a police&#160;</span><span>records system may have complete dependence on a mainframe (I.E. 100% loss), but that there may&#160;</span><span>be another method to continue business (such as paper and pen method or a radio method).</span></div>' WHERE [Mat_Question_Id] = 6095
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=6 WHERE [Mat_Question_Id] = 6097
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<div>If the desktop or PLCs are destroyed how long will it take before the Critical Service&#160;is affected?&#160;<span>As a note, this should NOT be the effect on the business service, but on the&#160;</span>Critical Service<span>.&#160;</span><span>For example, a police records system may be instantly effected by the loss of its laptops in the&#160;</span><span>vehicles (I.E. 0 Minutes), but that there may be another method to continue business. An ICS&#160;</span><span>example: A water system may shut down in 5 minutes if the PLCs stop functioning.</span></div>' WHERE [Mat_Question_Id] = 6100
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<div>If the desktop or PLCs are destroyed how much of an impact will it have on the Critical Service?&#160;<span>As a note, this should NOT be the effect on the business service, but on the&#160;</span>Critical Service<span>. As&#160;</span><span>a second note, you should not take into account any redundancy or alternative modes that may have&#160;</span><span>been identified in the Alternate Site Section. For example, a police records system may have&#160;</span><span>complete dependence on the laptops in its vehicles (I.E. 100% loss), but that there may be another&#160;</span><span>method to continue business (such as a paper and pen method or a radio method). A water ICS&#160;</span><span>system may cease to report information back if the PLCs are destroyed (100%), even though the&#160;</span><span>water system may still pump water.</span></div>' WHERE [Mat_Question_Id] = 6101
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=4 WHERE [Mat_Question_Id] = 6102
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=5 WHERE [Mat_Question_Id] = 6103
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=6 WHERE [Mat_Question_Id] = 6104
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=14 WHERE [Mat_Question_Id] = 6184
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=5 WHERE [Mat_Question_Id] = 6185
PRINT(N'Operation applied to 31 rows out of 31')

PRINT(N'Update rows in [dbo].[REQUIREMENT_SOURCE_FILES]')
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=22, [Destination_String]='22 XYZ -132 718 1.0' WHERE [Requirement_Id] = 16844 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.1.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=22, [Destination_String]='22 XYZ -132 718 1.0' WHERE [Requirement_Id] = 16845 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.1.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=23, [Destination_String]='23 XYZ -132 719 1.0' WHERE [Requirement_Id] = 16846 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.1.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=23, [Destination_String]='23 XYZ -132 719 1.0' WHERE [Requirement_Id] = 16847 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.1.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=24, [Destination_String]='24 XYZ -132 730 1.0' WHERE [Requirement_Id] = 16848 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.1.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=24, [Destination_String]='24 XYZ -132 730 1.0' WHERE [Requirement_Id] = 16849 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.1.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=24, [Destination_String]='24 XYZ -132 730 1.0' WHERE [Requirement_Id] = 16850 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.1.7'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=24, [Destination_String]='24 XYZ -132 730 1.0' WHERE [Requirement_Id] = 16851 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.1.8'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=25, [Destination_String]='25 XYZ -132 678 1.0' WHERE [Requirement_Id] = 16852 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.1.9'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=25, [Destination_String]='25 XYZ -132 678 1.0' WHERE [Requirement_Id] = 16853 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.1.10'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=25, [Destination_String]='25 XYZ -132 678 1.0' WHERE [Requirement_Id] = 16854 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.1.11'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=25, [Destination_String]='25 XYZ -132 678 1.0' WHERE [Requirement_Id] = 16855 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.1.12'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Destination_String]='26 XYZ -132 658 1.0' WHERE [Requirement_Id] = 16856 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.1.13'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Destination_String]='26 XYZ -132 658 1.0' WHERE [Requirement_Id] = 16857 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.1.14'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Destination_String]='26 XYZ -132 658 1.0' WHERE [Requirement_Id] = 16858 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.1.15'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=26, [Destination_String]='26 XYZ -132 658 1.0' WHERE [Requirement_Id] = 16859 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.1.16'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=26, [Destination_String]='26 XYZ -132 658 1.0' WHERE [Requirement_Id] = 16860 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.1.17'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Destination_String]='27 XYZ -132 732 1.0' WHERE [Requirement_Id] = 16861 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.1.18'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Destination_String]='27 XYZ -132 732 1.0' WHERE [Requirement_Id] = 16862 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.1.19'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Destination_String]='27 XYZ -132 732 1.0' WHERE [Requirement_Id] = 16863 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.1.20'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=28, [Destination_String]='28 XYZ -132 617 1.0' WHERE [Requirement_Id] = 16864 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.1.21'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=28, [Destination_String]='28 XYZ -132 617 1.0' WHERE [Requirement_Id] = 16865 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.1.22'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=28, [Destination_String]='28 XYZ -132 586 1.0' WHERE [Requirement_Id] = 16866 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.2.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=29, [Destination_String]='29 XYZ -132 723 1.0' WHERE [Requirement_Id] = 16867 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.2.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=29, [Destination_String]='29 XYZ -132 723 1.0' WHERE [Requirement_Id] = 16868 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.2.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=29, [Destination_String]='29 XYZ -132 723 1.0' WHERE [Requirement_Id] = 16869 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.3.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=30, [Destination_String]='30 XYZ -132 702 1.0' WHERE [Requirement_Id] = 16870 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.3.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=30, [Destination_String]='30 XYZ -132 702 1.0' WHERE [Requirement_Id] = 16871 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.3.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=31, [Destination_String]='31 XYZ -132 682 1.0' WHERE [Requirement_Id] = 16872 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.3.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=31, [Destination_String]='31 XYZ -132 682 1.0' WHERE [Requirement_Id] = 16873 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.3.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=31, [Destination_String]='31 XYZ -132 682 1.0' WHERE [Requirement_Id] = 16874 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.3.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=31, [Destination_String]='31 XYZ -132 682 1.0' WHERE [Requirement_Id] = 16875 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.3.7'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=32, [Destination_String]='32 XYZ -132 787 1.0' WHERE [Requirement_Id] = 16876 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.3.8'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=32, [Destination_String]='32 XYZ -132 787 1.0' WHERE [Requirement_Id] = 16877 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.3.9'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=32, [Destination_String]='32 XYZ -132 787 1.0' WHERE [Requirement_Id] = 16878 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.4.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=33, [Destination_String]='33 XYZ -132 736 1.0' WHERE [Requirement_Id] = 16879 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.4.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=33, [Destination_String]='33 XYZ -132 736 1.0' WHERE [Requirement_Id] = 16880 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.4.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=33, [Destination_String]='33 XYZ -132 736 1.0' WHERE [Requirement_Id] = 16881 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.4.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=34, [Destination_String]='34 XYZ -132 653 1.0' WHERE [Requirement_Id] = 16882 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.4.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=34, [Destination_String]='34 XYZ -132 653 1.0' WHERE [Requirement_Id] = 16883 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.4.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=34, [Destination_String]='34 XYZ -132 653 1.0' WHERE [Requirement_Id] = 16884 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.4.7'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=35, [Destination_String]='35 XYZ -132 664 1.0' WHERE [Requirement_Id] = 16885 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.4.8'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=35, [Destination_String]='35 XYZ -132 664 1.0' WHERE [Requirement_Id] = 16886 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.4.9'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=35, [Destination_String]='35 XYZ -132 664 1.0' WHERE [Requirement_Id] = 16887 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.5.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=36, [Destination_String]='36 XYZ -132 801 1.0' WHERE [Requirement_Id] = 16888 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.5.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=36, [Destination_String]='36 XYZ -132 801 1.0' WHERE [Requirement_Id] = 16889 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.5.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=37, [Destination_String]='37 XYZ -132 717 1.0' WHERE [Requirement_Id] = 16890 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.5.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=37, [Destination_String]='37 XYZ -132 717 1.0' WHERE [Requirement_Id] = 16891 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.5.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=37, [Destination_String]='37 XYZ -132 717 1.0' WHERE [Requirement_Id] = 16892 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.5.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=37, [Destination_String]='37 XYZ -132 717 1.0' WHERE [Requirement_Id] = 16893 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.5.7'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=37, [Destination_String]='37 XYZ -132 717 1.0' WHERE [Requirement_Id] = 16894 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.5.8'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=37, [Destination_String]='37 XYZ -132 717 1.0' WHERE [Requirement_Id] = 16895 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.5.9'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=37, [Destination_String]='37 XYZ -132 717 1.0' WHERE [Requirement_Id] = 16896 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.5.10'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=38, [Destination_String]='38 XYZ -132 697 1.0' WHERE [Requirement_Id] = 16897 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.5.11'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=38, [Destination_String]='38 XYZ -132 697 1.0' WHERE [Requirement_Id] = 16898 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.6.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=38, [Destination_String]='38 XYZ -132 697 1.0' WHERE [Requirement_Id] = 16899 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.6.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=39, [Destination_String]='39 XYZ -132 677 1.0' WHERE [Requirement_Id] = 16900 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.6.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=39, [Destination_String]='39 XYZ -132 677 1.0' WHERE [Requirement_Id] = 16901 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.7.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=39, [Destination_String]='39 XYZ -132 677 1.0' WHERE [Requirement_Id] = 16902 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.7.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=40, [Destination_String]='40 XYZ -132 657 1.0' WHERE [Requirement_Id] = 16903 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.7.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=40, [Destination_String]='40 XYZ -132 657 1.0' WHERE [Requirement_Id] = 16904 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.7.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=40, [Destination_String]='40 XYZ -132 657 1.0' WHERE [Requirement_Id] = 16905 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.7.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=40, [Destination_String]='40 XYZ -132 657 1.0' WHERE [Requirement_Id] = 16906 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.7.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=41, [Destination_String]='41 XYZ -132 730 1.0' WHERE [Requirement_Id] = 16907 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.8.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=41, [Destination_String]='41 XYZ -132 730 1.0' WHERE [Requirement_Id] = 16908 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.8.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=41, [Destination_String]='41 XYZ -132 730 1.0' WHERE [Requirement_Id] = 16909 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.8.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=42, [Destination_String]='42 XYZ -132 742 1.0' WHERE [Requirement_Id] = 16910 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.8.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=42, [Destination_String]='42 XYZ -132 742 1.0' WHERE [Requirement_Id] = 16911 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.8.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=42, [Destination_String]='42 XYZ -132 742 1.0' WHERE [Requirement_Id] = 16912 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.8.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=42, [Destination_String]='42 XYZ -132 742 1.0' WHERE [Requirement_Id] = 16913 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.8.7'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=43, [Destination_String]='43 XYZ -132 753 1.0' WHERE [Requirement_Id] = 16914 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.8.8'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=43, [Destination_String]='43 XYZ -132 753 1.0' WHERE [Requirement_Id] = 16915 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.8.9'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=43, [Destination_String]='43 XYZ -132 533 1.0' WHERE [Requirement_Id] = 16916 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.9.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=43, [Destination_String]='43 XYZ -132 533 1.0' WHERE [Requirement_Id] = 16917 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.9.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=44, [Destination_String]='44 XYZ -132 670 1.0' WHERE [Requirement_Id] = 16918 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.10.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=44, [Destination_String]='44 XYZ -132 670 1.0' WHERE [Requirement_Id] = 16919 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.10.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=44, [Destination_String]='44 XYZ -132 670 1.0' WHERE [Requirement_Id] = 16920 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.10.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=44, [Destination_String]='44 XYZ -132 670 1.0' WHERE [Requirement_Id] = 16921 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.10.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=45, [Destination_String]='45 XYZ -132 712 1.0' WHERE [Requirement_Id] = 16922 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.10.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=45, [Destination_String]='45 XYZ -132 712 1.0' WHERE [Requirement_Id] = 16923 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.10.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=45, [Destination_String]='45 XYZ -132 712 1.0' WHERE [Requirement_Id] = 16924 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.11.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=45, [Destination_String]='45 XYZ -132 712 1.0' WHERE [Requirement_Id] = 16925 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.11.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=46, [Destination_String]='46 XYZ -132 692 1.0' WHERE [Requirement_Id] = 16926 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.11.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=46, [Destination_String]='46 XYZ -132 692 1.0' WHERE [Requirement_Id] = 16927 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.12.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=47, [Destination_String]='47 XYZ -132 703 1.0' WHERE [Requirement_Id] = 16928 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.12.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=47, [Destination_String]='47 XYZ -132 703 1.0' WHERE [Requirement_Id] = 16929 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.12.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=48, [Destination_String]='48 XYZ -132 651 1.0' WHERE [Requirement_Id] = 16930 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.13.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=48, [Destination_String]='48 XYZ -132 651 1.0' WHERE [Requirement_Id] = 16931 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.13.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=49, [Destination_String]='49 XYZ -132 631 1.0' WHERE [Requirement_Id] = 16932 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.13.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=49, [Destination_String]='49 XYZ -132 631 1.0' WHERE [Requirement_Id] = 16933 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.13.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=49, [Destination_String]='49 XYZ -132 631 1.0' WHERE [Requirement_Id] = 16934 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.13.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=50, [Destination_String]='50 XYZ -132 736 1.0' WHERE [Requirement_Id] = 16935 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.13.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=50, [Destination_String]='50 XYZ -132 736 1.0' WHERE [Requirement_Id] = 16936 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.13.7'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=50, [Destination_String]='50 XYZ -132 736 1.0' WHERE [Requirement_Id] = 16937 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.13.8'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=50, [Destination_String]='50 XYZ -132 736 1.0' WHERE [Requirement_Id] = 16938 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.13.9'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=51, [Destination_String]='51 XYZ -132 716 1.0' WHERE [Requirement_Id] = 16939 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.13.10'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=51, [Destination_String]='51 XYZ -132 716 1.0' WHERE [Requirement_Id] = 16940 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.13.11'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=51, [Destination_String]='51 XYZ -132 716 1.0' WHERE [Requirement_Id] = 16941 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.13.12'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=51, [Destination_String]='51 XYZ -132 716 1.0' WHERE [Requirement_Id] = 16942 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.13.13'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=52, [Destination_String]='52 XYZ -132 759 1.0' WHERE [Requirement_Id] = 16943 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.13.14'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=52, [Destination_String]='52 XYZ -132 759 1.0' WHERE [Requirement_Id] = 16944 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.13.15'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=52, [Destination_String]='52 XYZ -132 759 1.0' WHERE [Requirement_Id] = 16945 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.13.16'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=52, [Destination_String]='52 XYZ -132 665 1.0' WHERE [Requirement_Id] = 16946 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.14.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=53, [Destination_String]='53 XYZ -132 708 1.0' WHERE [Requirement_Id] = 16947 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.14.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=53, [Destination_String]='53 XYZ -132 708 1.0' WHERE [Requirement_Id] = 16948 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.14.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=53, [Destination_String]='53 XYZ -132 708 1.0' WHERE [Requirement_Id] = 16949 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.14.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=54, [Destination_String]='54 XYZ -132 656 1.0' WHERE [Requirement_Id] = 16950 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.14.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=54, [Destination_String]='54 XYZ -132 656 1.0' WHERE [Requirement_Id] = 16951 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.14.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=55, [Destination_String]='55 XYZ -132 824 1.0' WHERE [Requirement_Id] = 16952 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.14.7'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=40, [Destination_String]='40 XYZ -132 657 1.0' WHERE [Requirement_Id] = 26483 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.7.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=47, [Destination_String]='47 XYZ -132 703 1.0' WHERE [Requirement_Id] = 28163 AND [Gen_File_Id] = 3970 AND [Section_Ref] = '3.12.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=21, [Destination_String]='21 Fit' WHERE [Requirement_Id] = 31193 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '1.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=21, [Destination_String]='21 Fit' WHERE [Requirement_Id] = 31194 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '1.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=21, [Destination_String]='21 Fit' WHERE [Requirement_Id] = 31195 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '1.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=21, [Destination_String]='21 Fit' WHERE [Requirement_Id] = 31196 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '1.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=21, [Destination_String]='21 Fit' WHERE [Requirement_Id] = 31197 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '1.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=23, [Destination_String]='23 Fit' WHERE [Requirement_Id] = 31198 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '2.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=23, [Destination_String]='23 Fit' WHERE [Requirement_Id] = 31199 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '2.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=24, [Destination_String]='24 Fit' WHERE [Requirement_Id] = 31200 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '2.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=24, [Destination_String]='24 Fit' WHERE [Requirement_Id] = 31201 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '2.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=24, [Destination_String]='24 Fit' WHERE [Requirement_Id] = 31202 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '2.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=24, [Destination_String]='24 Fit' WHERE [Requirement_Id] = 31203 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '2.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=24, [Destination_String]='24 Fit' WHERE [Requirement_Id] = 31204 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '2.7'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=26, [Destination_String]='26 Fit' WHERE [Requirement_Id] = 31205 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '3.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=26, [Destination_String]='26 Fit' WHERE [Requirement_Id] = 31206 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '3.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=26, [Destination_String]='26 Fit' WHERE [Requirement_Id] = 31207 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '3.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=27, [Destination_String]='27 Fit' WHERE [Requirement_Id] = 31208 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '3.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=27, [Destination_String]='27 Fit' WHERE [Requirement_Id] = 31209 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '3.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=27, [Destination_String]='27 Fit' WHERE [Requirement_Id] = 31210 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '3.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=27, [Destination_String]='27 Fit' WHERE [Requirement_Id] = 31211 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '3.7'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=27, [Destination_String]='27 Fit' WHERE [Requirement_Id] = 31212 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '3.8'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=27, [Destination_String]='27 Fit' WHERE [Requirement_Id] = 31213 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '3.9'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=27, [Destination_String]='27 Fit' WHERE [Requirement_Id] = 31214 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '3.10'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=27, [Destination_String]='27 Fit' WHERE [Requirement_Id] = 31215 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '3.11'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=27, [Destination_String]='27 Fit' WHERE [Requirement_Id] = 31216 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '3.12'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=27, [Destination_String]='27 Fit' WHERE [Requirement_Id] = 31217 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '3.13'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=27, [Destination_String]='27 Fit' WHERE [Requirement_Id] = 31218 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '3.14'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=30, [Destination_String]='30 Fit' WHERE [Requirement_Id] = 31219 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '4.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=30, [Destination_String]='30 Fit' WHERE [Requirement_Id] = 31220 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '4.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=30, [Destination_String]='30 Fit' WHERE [Requirement_Id] = 31221 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '4.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=30, [Destination_String]='30 Fit' WHERE [Requirement_Id] = 31222 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '4.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=30, [Destination_String]='30 Fit' WHERE [Requirement_Id] = 31223 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '4.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=30, [Destination_String]='30 Fit' WHERE [Requirement_Id] = 31224 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '4.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=30, [Destination_String]='30 Fit' WHERE [Requirement_Id] = 31225 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '4.7'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=30, [Destination_String]='30 Fit' WHERE [Requirement_Id] = 31226 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '4.8'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=30, [Destination_String]='30 Fit' WHERE [Requirement_Id] = 31227 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '4.9'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=30, [Destination_String]='30 Fit' WHERE [Requirement_Id] = 31228 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '4.10'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=30, [Destination_String]='30 Fit' WHERE [Requirement_Id] = 31229 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '4.11'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=30, [Destination_String]='30 Fit' WHERE [Requirement_Id] = 31230 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '4.12'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=32, [Destination_String]='32 Fit' WHERE [Requirement_Id] = 31231 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '5.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=32, [Destination_String]='32 Fit' WHERE [Requirement_Id] = 31232 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '5.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=33, [Destination_String]='33 Fit' WHERE [Requirement_Id] = 31233 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '5.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=33, [Destination_String]='33 Fit' WHERE [Requirement_Id] = 31234 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '5.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=33, [Destination_String]='33 Fit' WHERE [Requirement_Id] = 31235 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '5.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=33, [Destination_String]='33 Fit' WHERE [Requirement_Id] = 31236 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '5.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=35, [Destination_String]='35 Fit' WHERE [Requirement_Id] = 31237 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '6.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=35, [Destination_String]='35 Fit' WHERE [Requirement_Id] = 31238 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '6.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=35, [Destination_String]='35 Fit' WHERE [Requirement_Id] = 31239 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '6.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=36, [Destination_String]='36 Fit' WHERE [Requirement_Id] = 31240 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '6.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=36, [Destination_String]='36 Fit' WHERE [Requirement_Id] = 31241 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '6.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=36, [Destination_String]='36 Fit' WHERE [Requirement_Id] = 31242 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '6.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=36, [Destination_String]='36 Fit' WHERE [Requirement_Id] = 31243 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '6.7'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=36, [Destination_String]='36 Fit' WHERE [Requirement_Id] = 31244 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '6.8'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=39, [Destination_String]='39 Fit' WHERE [Requirement_Id] = 31245 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '7.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=39, [Destination_String]='39 Fit' WHERE [Requirement_Id] = 31246 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '7.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=39, [Destination_String]='39 Fit' WHERE [Requirement_Id] = 31247 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '7.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=39, [Destination_String]='39 Fit' WHERE [Requirement_Id] = 31248 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '7.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=39, [Destination_String]='39 Fit' WHERE [Requirement_Id] = 31249 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '7.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=39, [Destination_String]='39 Fit' WHERE [Requirement_Id] = 31250 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '7.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=39, [Destination_String]='39 Fit' WHERE [Requirement_Id] = 31251 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '7.7'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=21, [Destination_String]='21 Fit' WHERE [Requirement_Id] = 31252 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '1.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=41, [Destination_String]='41 Fit' WHERE [Requirement_Id] = 31252 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '8.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=21, [Destination_String]='21 Fit' WHERE [Requirement_Id] = 31253 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '1.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=41, [Destination_String]='41 Fit' WHERE [Requirement_Id] = 31253 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '8.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=21, [Destination_String]='21 Fit' WHERE [Requirement_Id] = 31254 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '1.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=41, [Destination_String]='41 Fit' WHERE [Requirement_Id] = 31254 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '8.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=21, [Destination_String]='21 Fit' WHERE [Requirement_Id] = 31255 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '1.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=41, [Destination_String]='41 Fit' WHERE [Requirement_Id] = 31255 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '8.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=21, [Destination_String]='21 Fit' WHERE [Requirement_Id] = 31256 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '1.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=41, [Destination_String]='41 Fit' WHERE [Requirement_Id] = 31256 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '8.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=21, [Destination_String]='21 Fit' WHERE [Requirement_Id] = 31257 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '1.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=41, [Destination_String]='41 Fit' WHERE [Requirement_Id] = 31257 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '8.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=21, [Destination_String]='21 Fit' WHERE [Requirement_Id] = 31258 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '1.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=41, [Destination_String]='41 Fit' WHERE [Requirement_Id] = 31258 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '8.7'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=21, [Destination_String]='21 Fit' WHERE [Requirement_Id] = 31259 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '1.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=41, [Destination_String]='41 Fit' WHERE [Requirement_Id] = 31259 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '8.8'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=21, [Destination_String]='21 Fit' WHERE [Requirement_Id] = 31260 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '1.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=41, [Destination_String]='41 Fit' WHERE [Requirement_Id] = 31260 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '8.9'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=21, [Destination_String]='21 Fit' WHERE [Requirement_Id] = 31261 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '1.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=41, [Destination_String]='41 Fit' WHERE [Requirement_Id] = 31261 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '8.10'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=21, [Destination_String]='21 Fit' WHERE [Requirement_Id] = 31262 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '1.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=41, [Destination_String]='41 Fit' WHERE [Requirement_Id] = 31262 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '8.11'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=21, [Destination_String]='21 Fit' WHERE [Requirement_Id] = 31263 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '1.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=41, [Destination_String]='41 Fit' WHERE [Requirement_Id] = 31263 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '8.12'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=43, [Destination_String]='43 Fit' WHERE [Requirement_Id] = 31264 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '9.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=43, [Destination_String]='43 Fit' WHERE [Requirement_Id] = 31265 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '9.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=43, [Destination_String]='43 Fit' WHERE [Requirement_Id] = 31266 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '9.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=43, [Destination_String]='43 Fit' WHERE [Requirement_Id] = 31267 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '9.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=44, [Destination_String]='44 Fit' WHERE [Requirement_Id] = 31268 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '9.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=44, [Destination_String]='44 Fit' WHERE [Requirement_Id] = 31269 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '9.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=44, [Destination_String]='44 Fit' WHERE [Requirement_Id] = 31270 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '9.7'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=46, [Destination_String]='46 Fit' WHERE [Requirement_Id] = 31271 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '10.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=46, [Destination_String]='46 Fit' WHERE [Requirement_Id] = 31272 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '10.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=46, [Destination_String]='46 Fit' WHERE [Requirement_Id] = 31273 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '10.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=46, [Destination_String]='46 Fit' WHERE [Requirement_Id] = 31274 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '10.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=46, [Destination_String]='46 Fit' WHERE [Requirement_Id] = 31275 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '10.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=46, [Destination_String]='46 Fit' WHERE [Requirement_Id] = 31276 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '10.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=46, [Destination_String]='46 Fit' WHERE [Requirement_Id] = 31277 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '10.7'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=48, [Destination_String]='48 Fit' WHERE [Requirement_Id] = 31278 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '11.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=48, [Destination_String]='48 Fit' WHERE [Requirement_Id] = 31279 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '11.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=48, [Destination_String]='48 Fit' WHERE [Requirement_Id] = 31280 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '11.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=48, [Destination_String]='48 Fit' WHERE [Requirement_Id] = 31281 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '11.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=48, [Destination_String]='48 Fit' WHERE [Requirement_Id] = 31282 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '11.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=50, [Destination_String]='50 Fit' WHERE [Requirement_Id] = 31283 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '12.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=50, [Destination_String]='50 Fit' WHERE [Requirement_Id] = 31284 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '12.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=50, [Destination_String]='50 Fit' WHERE [Requirement_Id] = 31285 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '12.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=50, [Destination_String]='50 Fit' WHERE [Requirement_Id] = 31286 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '12.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=50, [Destination_String]='50 Fit' WHERE [Requirement_Id] = 31287 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '12.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=50, [Destination_String]='50 Fit' WHERE [Requirement_Id] = 31288 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '12.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=50, [Destination_String]='50 Fit' WHERE [Requirement_Id] = 31289 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '12.7'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=50, [Destination_String]='50 Fit' WHERE [Requirement_Id] = 31290 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '12.8'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=52, [Destination_String]='52 Fit' WHERE [Requirement_Id] = 31291 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '13.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=52, [Destination_String]='52 Fit' WHERE [Requirement_Id] = 31292 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '13.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=52, [Destination_String]='52 Fit' WHERE [Requirement_Id] = 31293 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '13.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=52, [Destination_String]='52 Fit' WHERE [Requirement_Id] = 31294 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '13.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=53, [Destination_String]='53 Fit' WHERE [Requirement_Id] = 31295 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '13.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=53, [Destination_String]='53 Fit' WHERE [Requirement_Id] = 31296 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '13.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=53, [Destination_String]='53 Fit' WHERE [Requirement_Id] = 31297 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '13.7'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=53, [Destination_String]='53 Fit' WHERE [Requirement_Id] = 31298 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '13.8'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=53, [Destination_String]='53 Fit' WHERE [Requirement_Id] = 31299 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '13.9'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=53, [Destination_String]='53 Fit' WHERE [Requirement_Id] = 31300 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '13.10'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=53, [Destination_String]='53 Fit' WHERE [Requirement_Id] = 31301 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '13.11'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=55, [Destination_String]='55 Fit' WHERE [Requirement_Id] = 31302 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '14.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=55, [Destination_String]='55 Fit' WHERE [Requirement_Id] = 31303 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '14.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=55, [Destination_String]='55 Fit' WHERE [Requirement_Id] = 31304 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '14.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=55, [Destination_String]='55 Fit' WHERE [Requirement_Id] = 31305 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '14.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=56, [Destination_String]='56 Fit' WHERE [Requirement_Id] = 31306 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '14.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=56, [Destination_String]='56 Fit' WHERE [Requirement_Id] = 31307 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '14.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=56, [Destination_String]='56 Fit' WHERE [Requirement_Id] = 31308 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '14.7'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=56, [Destination_String]='56 Fit' WHERE [Requirement_Id] = 31309 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '14.8'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=56, [Destination_String]='56 Fit' WHERE [Requirement_Id] = 31310 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '14.9'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=58, [Destination_String]='58 Fit' WHERE [Requirement_Id] = 31311 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '15.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=58, [Destination_String]='58 Fit' WHERE [Requirement_Id] = 31312 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '15.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=58, [Destination_String]='58 Fit' WHERE [Requirement_Id] = 31313 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '15.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=59, [Destination_String]='59 Fit' WHERE [Requirement_Id] = 31314 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '15.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=59, [Destination_String]='59 Fit' WHERE [Requirement_Id] = 31315 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '15.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=59, [Destination_String]='59 Fit' WHERE [Requirement_Id] = 31316 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '15.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=59, [Destination_String]='59 Fit' WHERE [Requirement_Id] = 31317 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '15.7'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=63, [Destination_String]='63 Fit' WHERE [Requirement_Id] = 31318 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '16.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=63, [Destination_String]='63 Fit' WHERE [Requirement_Id] = 31319 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '16.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=63, [Destination_String]='63 Fit' WHERE [Requirement_Id] = 31320 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '16.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=63, [Destination_String]='63 Fit' WHERE [Requirement_Id] = 31321 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '16.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=63, [Destination_String]='63 Fit' WHERE [Requirement_Id] = 31322 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '16.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=63, [Destination_String]='63 Fit' WHERE [Requirement_Id] = 31323 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '16.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=63, [Destination_String]='63 Fit' WHERE [Requirement_Id] = 31324 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '16.7'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=63, [Destination_String]='63 Fit' WHERE [Requirement_Id] = 31325 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '16.8'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=64, [Destination_String]='64 Fit' WHERE [Requirement_Id] = 31326 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '16.9'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=64, [Destination_String]='64 Fit' WHERE [Requirement_Id] = 31327 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '16.10'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=64, [Destination_String]='64 Fit' WHERE [Requirement_Id] = 31328 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '16.11'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=64, [Destination_String]='64 Fit' WHERE [Requirement_Id] = 31329 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '16.12'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=64, [Destination_String]='64 Fit' WHERE [Requirement_Id] = 31330 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '16.13'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=64, [Destination_String]='64 Fit' WHERE [Requirement_Id] = 31331 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '16.14'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=66, [Destination_String]='66 Fit' WHERE [Requirement_Id] = 31332 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '17.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=66, [Destination_String]='66 Fit' WHERE [Requirement_Id] = 31333 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '17.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=66, [Destination_String]='66 Fit' WHERE [Requirement_Id] = 31334 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '17.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=67, [Destination_String]='67 Fit' WHERE [Requirement_Id] = 31335 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '17.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=67, [Destination_String]='67 Fit' WHERE [Requirement_Id] = 31336 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '17.5'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=67, [Destination_String]='67 Fit' WHERE [Requirement_Id] = 31337 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '17.6'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=67, [Destination_String]='67 Fit' WHERE [Requirement_Id] = 31338 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '17.7'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=67, [Destination_String]='67 Fit' WHERE [Requirement_Id] = 31339 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '17.8'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=67, [Destination_String]='67 Fit' WHERE [Requirement_Id] = 31340 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '17.9'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=70, [Destination_String]='70 Fit' WHERE [Requirement_Id] = 31341 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '18.1'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=70, [Destination_String]='70 Fit' WHERE [Requirement_Id] = 31342 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '18.2'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=70, [Destination_String]='70 Fit' WHERE [Requirement_Id] = 31343 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '18.3'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=70, [Destination_String]='70 Fit' WHERE [Requirement_Id] = 31344 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '18.4'
UPDATE [dbo].[REQUIREMENT_SOURCE_FILES] SET [Page_Number]=70, [Destination_String]='70 Fit' WHERE [Requirement_Id] = 31345 AND [Gen_File_Id] = 6087 AND [Section_Ref] = '18.5'
PRINT(N'Operation applied to 276 rows out of 276')

PRINT(N'Update rows in [dbo].[MATURITY_GROUPINGS]')
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Description]='The purpose of this question set is to find the basis of authentication and authorization controls used on the Critical Service&#160;within the evaluated organization. Common practices such as administrator privileges, user privileges, and password management are assessed.', [Sequence]=1 WHERE [Grouping_Id] = 2316
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Sequence]=2 WHERE [Grouping_Id] = 2317
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Sequence]=3 WHERE [Grouping_Id] = 2318
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Sequence]=4 WHERE [Grouping_Id] = 2319
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Sequence]=5 WHERE [Grouping_Id] = 2320
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Sequence]=6 WHERE [Grouping_Id] = 2321
PRINT(N'Operation applied to 6 rows out of 6')

PRINT(N'Add rows to [dbo].[NEW_QUESTION_LEVELS]')
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54549, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54550, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54551, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54552, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54553, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54554, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54555, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54556, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54557, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54558, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54559, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54560, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54561, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54562, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54563, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54564, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54565, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54566, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54567, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54568, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54569, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54570, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54571, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54572, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54573, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54574, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54575, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54576, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54577, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54578, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54579, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54580, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54581, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54582, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54583, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54584, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54585, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54586, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54587, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54588, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54589, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54590, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54591, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54592, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54593, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54594, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54595, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54596, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54597, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54598, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54599, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54600, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54601, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54602, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54603, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54604, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54605, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54606, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54607, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54608, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54609, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54610, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54611, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54612, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54613, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54614, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54615, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54616, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54617, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54618, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54619, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54620, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54621, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54622, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54623, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54624, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54625, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54626, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54627, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54628, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54629, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54630, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54631, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54632, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54633, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54634, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54635, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54636, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54637, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54638, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54639, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54640, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54641, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54642, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54643, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54644, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54645, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54646, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54647, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54648, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54649, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54650, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54651, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54652, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54653, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54654, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54655, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54656, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54657, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54658, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54659, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54660, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54661, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54662, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54663, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54664, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54665, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54666, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54667, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54668, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54669, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54670, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54671, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54672, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54673, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54674, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54675, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54676, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54677, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54678, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54679, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54680, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54681, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54682, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54683, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54684, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54685, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54686, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54687, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54688, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54689, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54690, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54691, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54692, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54693, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54694, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54695, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54696, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54697, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54698, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54699, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54700, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54701, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54702, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54703, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54704, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54705, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54706, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54707, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54708, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54709, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54710, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54711, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54712, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54713, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54714, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54715, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54716, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54717, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54718, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54719, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54720, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54721, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54722, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54723, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54724, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54725, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54726, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54727, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54728, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54729, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54730, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54731, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54732, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54733, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54734, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54735, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54736, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54737, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54738, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54739, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54740, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54741, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54742, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54743, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54744, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54745, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54746, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54747, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54748, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54749, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54750, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54751, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54752, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54753, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54754, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54755, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54756, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54757, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54758, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54759, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54760, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54761, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54762, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54763, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54764, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54765, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54766, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54767, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54768, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54769, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54770, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54771, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54772, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54773, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54774, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54775, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54776, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54777, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54778, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54779, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54780, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54781, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54782, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54783, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54784, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54785, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54786, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54787, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54788, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54789, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54790, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54791, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54792, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54793, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54794, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54795, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54796, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54797, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54798, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54799, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54800, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54801, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54802, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54803, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54804, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54805, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54806, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54807, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54808, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54809, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54810, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54811, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54812, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54813, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54814, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54815, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54816, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54817, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54818, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54819, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54820, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54821, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54822, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54823, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54824, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54825, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54826, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54827, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54828, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54829, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54830, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54831, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54832, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54833, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54834, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54835, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54836, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54837, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54838, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54839, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54840, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('H', 54841, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54548, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54549, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54550, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54551, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54552, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54553, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54554, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54555, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54556, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54557, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54558, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54559, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54560, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54561, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54562, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54563, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54564, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54565, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54566, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54567, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54568, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54569, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54570, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54571, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54572, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54573, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54574, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54575, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54576, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54577, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54578, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54579, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54580, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54581, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54582, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54583, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54584, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54585, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54586, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54587, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54588, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54589, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54590, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54591, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54592, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54593, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54594, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54595, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54596, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54597, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54598, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54599, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54600, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54601, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54602, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54603, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54604, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54605, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54606, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54607, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54608, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54609, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54610, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54611, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54612, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54613, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54614, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54615, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54616, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54617, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54618, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54619, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54620, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54621, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54622, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54623, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54624, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54625, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54626, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54627, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54628, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54629, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54630, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54631, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54632, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54633, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54634, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54635, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54636, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54637, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54638, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54639, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54640, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54641, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54642, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54643, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54644, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54645, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54646, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54647, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54648, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54649, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54650, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54651, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54652, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54653, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54654, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54655, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54656, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54657, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54658, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54659, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54660, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54661, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54662, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54663, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54664, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54665, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54666, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54667, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54668, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54669, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54670, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54671, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54672, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54673, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54674, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54675, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54676, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54677, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54678, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54679, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54680, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54681, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54682, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54683, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54684, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54685, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54686, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54687, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54688, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54689, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54690, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54691, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54692, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54693, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54694, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54695, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54696, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54697, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54698, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54699, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54700, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54701, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54702, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54703, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54704, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54705, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54706, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54707, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54708, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54709, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54710, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54711, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54712, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54713, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54714, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54715, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54716, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54717, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54718, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54719, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54720, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54721, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54722, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54723, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54724, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54725, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54726, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54727, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54728, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54729, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54730, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54731, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54732, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54733, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54734, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54735, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54736, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54737, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54738, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54739, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54740, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54741, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54742, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54743, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54744, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54745, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54746, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54747, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54748, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54749, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54750, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54751, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54752, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54753, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54754, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54755, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54756, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54757, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54758, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54759, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54760, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54761, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54762, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54763, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54764, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54765, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54766, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54767, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54768, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54769, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54770, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54771, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54772, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54773, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54774, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54775, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54776, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54777, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54778, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54779, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54780, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54781, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54782, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54783, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54784, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54785, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54786, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54787, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54788, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54789, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54790, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54791, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54792, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54793, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54794, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54795, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54796, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54797, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54798, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54799, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54800, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54801, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54802, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54803, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54804, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54805, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54806, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54807, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54808, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54809, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54810, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54811, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54812, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54813, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54814, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54815, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54816, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54817, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54818, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54819, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54820, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54821, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54822, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54823, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54824, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54825, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54826, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54827, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54828, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54829, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54830, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54831, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54832, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54833, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54834, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54835, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54836, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54837, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54838, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54839, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54840, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('L', 54841, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54549, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54550, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54551, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54552, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54553, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54554, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54555, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54556, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54557, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54558, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54559, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54560, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54561, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54562, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54563, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54564, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54565, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54566, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54567, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54568, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54569, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54570, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54571, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54572, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54573, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54574, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54575, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54576, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54577, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54578, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54579, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54580, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54581, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54582, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54583, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54584, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54585, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54586, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54587, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54588, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54589, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54590, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54591, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54592, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54593, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54594, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54595, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54596, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54597, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54598, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54599, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54600, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54601, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54602, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54603, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54604, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54605, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54606, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54607, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54608, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54609, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54610, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54611, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54612, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54613, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54614, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54615, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54616, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54617, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54618, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54619, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54620, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54621, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54622, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54623, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54624, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54625, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54626, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54627, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54628, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54629, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54630, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54631, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54632, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54633, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54634, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54635, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54636, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54637, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54638, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54639, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54640, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54641, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54642, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54643, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54644, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54645, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54646, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54647, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54648, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54649, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54650, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54651, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54652, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54653, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54654, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54655, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54656, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54657, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54658, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54659, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54660, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54661, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54662, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54663, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54664, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54665, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54666, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54667, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54668, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54669, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54670, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54671, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54672, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54673, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54674, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54675, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54676, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54677, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54678, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54679, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54680, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54681, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54682, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54683, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54684, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54685, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54686, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54687, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54688, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54689, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54690, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54691, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54692, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54693, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54694, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54695, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54696, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54697, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54698, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54699, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54700, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54701, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54702, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54703, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54704, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54705, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54706, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54707, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54708, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54709, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54710, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54711, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54712, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54713, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54714, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54715, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54716, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54717, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54718, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54719, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54720, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54721, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54722, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54723, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54724, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54725, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54726, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54727, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54728, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54729, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54730, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54731, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54732, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54733, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54734, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54735, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54736, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54737, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54738, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54739, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54740, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54741, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54742, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54743, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54744, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54745, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54746, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54747, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54748, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54749, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54750, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54751, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54752, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54753, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54754, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54755, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54756, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54757, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54758, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54759, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54760, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54761, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54762, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54763, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54764, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54765, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54766, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54767, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54768, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54769, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54770, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54771, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54772, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54773, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54774, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54775, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54776, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54777, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54778, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54779, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54780, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54781, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54782, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54783, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54784, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54785, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54786, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54787, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54788, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54789, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54790, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54791, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54792, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54793, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54794, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54795, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54796, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54797, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54798, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54799, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54800, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54801, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54802, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54803, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54804, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54805, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54806, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54807, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54808, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54809, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54810, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54811, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54812, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54813, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54814, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54815, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54816, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54817, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54818, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54819, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54820, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54821, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54822, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54823, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54824, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54825, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54826, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54827, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54828, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54829, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54830, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54831, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54832, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54833, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54834, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54835, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54836, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54837, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54838, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54839, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54840, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('M', 54841, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54549, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54550, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54551, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54552, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54553, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54554, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54555, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54556, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54557, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54558, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54559, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54560, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54561, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54562, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54563, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54564, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54565, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54566, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54567, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54568, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54569, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54570, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54571, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54572, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54573, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54574, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54575, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54576, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54577, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54578, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54579, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54580, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54581, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54582, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54583, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54584, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54585, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54586, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54587, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54588, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54589, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54590, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54591, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54592, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54593, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54594, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54595, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54596, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54597, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54598, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54599, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54600, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54601, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54602, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54603, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54604, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54605, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54606, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54607, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54608, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54609, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54610, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54611, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54612, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54613, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54614, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54615, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54616, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54617, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54618, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54619, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54620, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54621, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54622, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54623, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54624, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54625, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54626, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54627, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54628, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54629, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54630, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54631, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54632, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54633, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54634, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54635, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54636, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54637, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54638, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54639, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54640, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54641, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54642, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54643, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54644, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54645, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54646, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54647, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54648, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54649, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54650, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54651, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54652, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54653, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54654, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54655, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54656, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54657, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54658, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54659, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54660, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54661, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54662, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54663, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54664, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54665, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54666, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54667, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54668, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54669, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54670, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54671, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54672, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54673, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54674, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54675, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54676, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54677, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54678, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54679, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54680, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54681, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54682, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54683, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54684, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54685, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54686, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54687, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54688, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54689, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54690, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54691, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54692, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54693, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54694, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54695, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54696, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54697, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54698, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54699, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54700, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54701, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54702, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54703, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54704, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54705, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54706, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54707, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54708, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54709, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54710, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54711, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54712, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54713, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54714, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54715, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54716, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54717, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54718, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54719, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54720, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54721, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54722, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54723, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54724, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54725, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54726, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54727, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54728, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54729, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54730, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54731, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54732, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54733, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54734, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54735, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54736, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54737, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54738, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54739, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54740, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54741, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54742, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54743, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54744, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54745, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54746, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54747, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54748, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54749, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54750, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54751, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54752, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54753, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54754, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54755, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54756, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54757, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54758, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54759, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54760, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54761, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54762, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54763, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54764, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54765, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54766, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54767, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54768, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54769, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54770, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54771, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54772, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54773, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54774, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54775, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54776, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54777, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54778, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54779, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54780, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54781, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54782, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54783, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54784, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54785, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54786, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54787, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54788, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54789, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54790, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54791, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54792, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54793, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54794, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54795, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54796, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54797, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54798, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54799, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54800, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54801, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54802, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54803, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54804, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54805, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54806, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54807, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54808, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54809, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54810, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54811, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54812, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54813, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54814, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54815, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54816, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54817, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54818, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54819, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54820, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54821, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54822, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54823, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54824, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54825, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54826, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54827, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54828, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54829, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54830, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54831, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54832, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54833, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54834, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54835, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54836, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54837, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54838, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54839, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54840, NULL)
INSERT INTO [dbo].[NEW_QUESTION_LEVELS] ([Universal_Sal_Level], [New_Question_Set_Id], [IgnoreMe]) VALUES ('VH', 54841, NULL)
PRINT(N'Operation applied to 1173 rows out of 1173')

PRINT(N'Add rows to [dbo].[NEW_QUESTION_SETS]')
SET IDENTITY_INSERT [dbo].[NEW_QUESTION_SETS] ON
DELETE FROM NEW_QUESTION_SETS WHERE Question_Id >= 1000000 AND Set_Name = N'CSC_V8'
DELETE FROM NEW_QUESTION WHERE Question_Id >= 1000000 AND (Std_Ref = N'CSC_V8' OR Std_Ref = N'SET.20220316.141623')
DELETE FROM NEW_REQUIREMENT WHERE Original_Set_Name = N'SET.20220304.160252' OR Original_Set_Name = N'SET.20220316.141623' OR Original_Set_Name = N'SET.20220317.134357' OR Original_Set_Name = N'SET.20220323.151606' OR Original_Set_Name = N'SET.20220414.113656'

INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53329, N'CSC_V8', 17401)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53330, N'CSC_V8', 17402)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53333, N'CSC_V8', 17403)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53335, N'CSC_V8', 17404)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53336, N'CSC_V8', 17405)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53337, N'CSC_V8', 17406)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53338, N'CSC_V8', 17407)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53339, N'CSC_V8', 17408)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53340, N'CSC_V8', 17409)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53341, N'CSC_V8', 17410)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53342, N'CSC_V8', 17411)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53343, N'CSC_V8', 17412)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53344, N'CSC_V8', 17413)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53345, N'CSC_V8', 17414)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53346, N'CSC_V8', 17415)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53347, N'CSC_V8', 17416)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53348, N'CSC_V8', 17417)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53349, N'CSC_V8', 17418)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53350, N'CSC_V8', 17419)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53351, N'CSC_V8', 17420)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53352, N'CSC_V8', 17421)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53353, N'CSC_V8', 17422)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53354, N'CSC_V8', 17423)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53355, N'CSC_V8', 17424)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53356, N'CSC_V8', 17425)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53357, N'CSC_V8', 17426)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53358, N'CSC_V8', 17427)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53359, N'CSC_V8', 17428)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53360, N'CSC_V8', 17429)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53361, N'CSC_V8', 17430)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53362, N'CSC_V8', 17431)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53363, N'CSC_V8', 17432)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53364, N'CSC_V8', 17433)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53365, N'CSC_V8', 17434)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53366, N'CSC_V8', 17435)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53367, N'CSC_V8', 17436)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53368, N'CSC_V8', 17437)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53369, N'CSC_V8', 17438)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53370, N'CSC_V8', 17439)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53371, N'CSC_V8', 17440)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53372, N'CSC_V8', 17441)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53373, N'CSC_V8', 17442)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53374, N'CSC_V8', 17443)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53379, N'CSC_V8', 17444)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53380, N'CSC_V8', 17445)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53383, N'CSC_V8', 17446)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53386, N'CSC_V8', 17447)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53387, N'CSC_V8', 17448)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53388, N'CSC_V8', 17449)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53391, N'CSC_V8', 17450)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53392, N'CSC_V8', 17451)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53393, N'CSC_V8', 17452)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53394, N'CSC_V8', 17453)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53395, N'CSC_V8', 17454)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53398, N'CSC_V8', 17455)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53399, N'CSC_V8', 17456)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53400, N'CSC_V8', 17457)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53401, N'CSC_V8', 17458)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53402, N'CSC_V8', 17459)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53404, N'CSC_V8', 17460)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53405, N'CSC_V8', 17461)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53406, N'CSC_V8', 17462)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53407, N'CSC_V8', 17463)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53408, N'CSC_V8', 17464)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53409, N'CSC_V8', 17465)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53414, N'CSC_V8', 17466)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53416, N'CSC_V8', 17467)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53418, N'CSC_V8', 17468)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53419, N'CSC_V8', 17469)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53421, N'CSC_V8', 17470)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53422, N'CSC_V8', 17471)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53423, N'CSC_V8', 17472)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53424, N'CSC_V8', 17473)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53427, N'CSC_V8', 17474)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53428, N'CSC_V8', 17475)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53429, N'CSC_V8', 17476)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53430, N'CSC_V8', 17477)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53431, N'CSC_V8', 17478)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53432, N'CSC_V8', 17479)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53433, N'CSC_V8', 17480)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53434, N'CSC_V8', 17481)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53435, N'CSC_V8', 17482)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53437, N'CSC_V8', 17483)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53438, N'CSC_V8', 17484)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53443, N'CSC_V8', 17485)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53445, N'CSC_V8', 17486)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53450, N'CSC_V8', 17487)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53451, N'CSC_V8', 17488)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53452, N'CSC_V8', 17489)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53453, N'CSC_V8', 17490)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53454, N'CSC_V8', 17491)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53456, N'CSC_V8', 17492)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53457, N'CSC_V8', 17493)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53458, N'CSC_V8', 17494)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53459, N'CSC_V8', 17495)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53460, N'CSC_V8', 17496)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53461, N'CSC_V8', 17497)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53462, N'CSC_V8', 17498)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53463, N'CSC_V8', 17499)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53464, N'CSC_V8', 17500)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53465, N'CSC_V8', 17501)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53466, N'CSC_V8', 17502)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53467, N'CSC_V8', 17503)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53469, N'CSC_V8', 17504)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53473, N'CSC_V8', 17505)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53474, N'CSC_V8', 17506)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53475, N'CSC_V8', 17507)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53476, N'CSC_V8', 17508)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53477, N'CSC_V8', 17509)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53481, N'CSC_V8', 17510)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53486, N'CSC_V8', 17511)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53487, N'CSC_V8', 17512)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53488, N'CSC_V8', 17513)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53489, N'CSC_V8', 17514)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53490, N'CSC_V8', 17515)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53491, N'CSC_V8', 17516)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53492, N'CSC_V8', 17517)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53494, N'CSC_V8', 17518)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53495, N'CSC_V8', 17519)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53496, N'CSC_V8', 17520)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53497, N'CSC_V8', 17521)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53498, N'CSC_V8', 17522)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53499, N'CSC_V8', 17523)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53500, N'CSC_V8', 17524)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53501, N'CSC_V8', 17525)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53503, N'CSC_V8', 17526)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53504, N'CSC_V8', 17527)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53505, N'CSC_V8', 17528)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53506, N'CSC_V8', 17529)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53508, N'CSC_V8', 17530)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53509, N'CSC_V8', 17531)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53510, N'CSC_V8', 17532)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53512, N'CSC_V8', 17533)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53513, N'CSC_V8', 17534)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53514, N'CSC_V8', 17535)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53515, N'CSC_V8', 17536)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53516, N'CSC_V8', 17537)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53517, N'CSC_V8', 17538)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53521, N'CSC_V8', 17539)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53522, N'CSC_V8', 17540)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53525, N'CSC_V8', 17541)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53526, N'CSC_V8', 17542)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53527, N'CSC_V8', 17543)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53528, N'CSC_V8', 17544)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53530, N'CSC_V8', 17545)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53532, N'CSC_V8', 17546)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53533, N'CSC_V8', 17547)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53534, N'CSC_V8', 17548)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53536, N'CSC_V8', 17549)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53537, N'CSC_V8', 17550)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53538, N'CSC_V8', 17551)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53539, N'CSC_V8', 17552)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53542, N'CSC_V8', 17553)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53543, N'CSC_V8', 17554)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (53544, N'CSC_V8', 17555)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (54544, N'CSC_V8', 17556)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (54545, N'CSC_V8', 17557)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (54546, N'CSC_V8', 17558)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (54547, N'CSC_V8', 17559)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56875, N'Course_401', 17635)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56876, N'Course_401', 17636)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56877, N'Course_401', 17637)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56878, N'Course_401', 17638)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56879, N'Course_401', 17639)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56880, N'Course_401', 17640)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56881, N'Course_401', 17641)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56882, N'Course_401', 17642)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56883, N'Course_401', 17643)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56884, N'Course_401', 17644)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56885, N'Course_401', 17645)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56886, N'Course_401', 17646)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56887, N'Course_401', 17647)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56888, N'Course_401', 17648)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56889, N'Course_401', 17649)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56890, N'Course_401', 17650)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56891, N'Course_401', 17651)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56892, N'Course_401', 17652)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56893, N'Course_401', 17653)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56894, N'Course_401', 17654)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56895, N'Course_401', 17655)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56896, N'Course_401', 17656)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56897, N'Course_401', 17657)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56898, N'Course_401', 17658)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56899, N'Course_401', 17659)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56900, N'Course_401', 17660)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56901, N'Course_401', 17661)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56902, N'Course_401', 17662)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56903, N'Course_401', 17663)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56904, N'Course_401', 17664)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56905, N'Course_401', 17665)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56906, N'Course_401', 17666)
INSERT INTO [dbo].[NEW_QUESTION_SETS] ([New_Question_Set_Id], [Set_Name], [Question_Id]) VALUES (56907, N'Course_401', 17667)
SET IDENTITY_INSERT [dbo].[NEW_QUESTION_SETS] OFF
PRINT(N'Operation applied to 192 rows out of 192')

PRINT(N'Add rows to [dbo].[MATURITY_REFERENCE_TEXT]')
IF NOT EXISTS (SELECT 1 FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE Mat_Question_Id = 6018)
BEGIN
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (6018, 1, NULL)
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE Mat_Question_Id = 6019)
BEGIN
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (6019, 1, NULL)
END
PRINT(N'Operation applied to 2 rows out of 2')

PRINT(N'Add constraints to [dbo].[MATURITY_REFERENCE_TEXT]')
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_OPTIONS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTION_TYPES]
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1]
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[REQUIREMENT_SOURCE_FILES]')
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] CHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] CHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_NEW_REQUIREMENT]

PRINT(N'Add constraints to [dbo].[NEW_QUESTION_LEVELS]')

PRINT(N'Add constraints to [dbo].[NEW_QUESTION_SETS]')
ALTER TABLE [dbo].[NEW_QUESTION_SETS] CHECK CONSTRAINT [FK_NEW_QUESTION_SETS_NEW_QUESTION]
ALTER TABLE [dbo].[NEW_QUESTION_SETS] CHECK CONSTRAINT [FK_NEW_QUESTION_SETS_SETS]

PRINT(N'Add constraints to [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_GROUPING_TYPES]
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS]

PRINT(N'Add constraints to [dbo].[ANALYTICS_MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[ANALYTICS_MATURITY_GROUPINGS] WITH CHECK CHECK CONSTRAINT [FK_ANALYTICS_MATURITY_GROUPINGS_MATURITY_MODELS]

PRINT(N'Drop constraints from [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_OPTIONS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTION_TYPES]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1 from [dbo].[MATURITY_ANSWER_OPTIONS]')
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] NOCHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1]

PRINT(N'Drop constraint FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS from [dbo].[MATURITY_REFERENCE_TEXT]')
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_REFERENCES_MATURITY_QUESTIONS from [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS from [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]

PRINT(N'Update rows in [dbo].[MATURITY_QUESTIONS]')
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<p>Programmable electronic devices and communication networks, including hardware, software and data. Data and cabling are considered to exist within the framework of the cyber asset and there are not separate cyber assets. </p>  <ul>  <li>Network -- Information Service(s) implemented with a collection of interconnected components. Such components may include routers, hubs, cabling, telecommunications controllers, key distribution centers, and technical control devices.</li>  <li>Application -- Application is digital application software program hosted by an information Service that functions and is operated by means of a computer, with the purpose of supporting functions needed by an asset owner.</li>  <li>Individuals - The key IT and security professionals within the organization. This would include: administrators, users, and third party contractors of the Critical Services.</li>  </ul>  <p>If yes, on what basis does the organization review, for the purpose of updating its inventory?<p>  <p>For purposes of this evaluation, the review of inventory is the verification and validation of the cyber assets (networks, Services, applications, connections, and individuals). This process  can be either manual (checking that the assets are physically there) or automated (computer system has inventory).</p>' WHERE [Mat_Question_Id] = 5919
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<div>&#183; Additional layers of authentication: e.g., sequential (username/password then RSA)</div><div>&#183; Account lock-out: (after a defined number of failures)</div><div>&#183; Unique forms of authentication: multiple-factor authentication such as a generated token, RSA&#160;<span>key fob, Smart card, or USB/hasp key</span></div>' WHERE [Mat_Question_Id] = 5979
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<div>If the internal communication lines are destroyed how long will it take before the Critical Service<span>&#160;is affected? As a note, this should NOT be the effect on the business service, but on the&#160;</span>Critical Service<span>. For example, a police records system may be instantly effected by the loss&#160;</span><span>of its ability to communicate remotely (I.E. 0 Minutes), but that there may be another method to&#160;</span><span>continue business.</span></div>' WHERE [Mat_Question_Id] = 6088
PRINT(N'Operation applied to 3 rows out of 3')

PRINT(N'Add constraints to [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_OPTIONS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTION_TYPES]
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1]
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]


PRINT(N'Drop constraints from [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_GROUPING_TYPES]
ALTER TABLE [dbo].[MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_MODELS]

PRINT(N'Drop constraint FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS from [dbo].[MATURITY_DOMAIN_REMARKS]')
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] NOCHECK CONSTRAINT [FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS]

PRINT(N'Drop constraint FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS from [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]

PRINT(N'Update row in [dbo].[MATURITY_GROUPINGS]')
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Description]='For this survey, an identified documented Critical Service asset security architecture should include all Critical Service cyber assets. The purpose of these questions are to additional assets into the architecture document and how frequently it is reviewed and updated. A documented system architecture could include the following: routers, switches, computers, servers, firewalls, VPNs, remote desktops, virtual machines, networks, etc. For the purpose of this survey, system configuration monitoring tools examples are: IBM Tivoli, IBM BigFix, Apache Subversion, & Perforce.' WHERE [Grouping_Id] = 2329

PRINT(N'Add constraints to [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_GROUPING_TYPES]
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]

COMMIT TRANSACTION
GO
