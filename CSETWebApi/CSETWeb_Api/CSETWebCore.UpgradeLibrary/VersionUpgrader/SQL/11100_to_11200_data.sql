/*
Run this script on:

(localdb)\MSSQLLocalDB.CSETWeb11100    -  This database will be modified

to synchronize it with:

(localdb)\MSSQLLocalDB.CSETWeb11200

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.7.8.21163 from Red Gate Software Ltd at 6/15/2022 12:53:11 PM

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

PRINT(N'Drop constraints from [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]

PRINT(N'Drop constraints from [dbo].[MATURITY_REFERENCE_TEXT]')
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]

PRINT(N'Drop constraints from [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_OPTIONS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTION_TYPES]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_REFERENCES_MATURITY_QUESTIONS from [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Drop constraints from [dbo].[MATURITY_ANSWER_OPTIONS]')
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] NOCHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1]

PRINT(N'Drop constraint FK_ANSWER_MATURITY_ANSWER_OPTIONS1 from [dbo].[ANSWER]')
ALTER TABLE [dbo].[ANSWER] NOCHECK CONSTRAINT [FK_ANSWER_MATURITY_ANSWER_OPTIONS1]

PRINT(N'Drop constraint FK_ANALYTICS_MATURITY_GROUPINGS_MATURITY_MODELS from [dbo].[ANALYTICS_MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[ANALYTICS_MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_ANALYTICS_MATURITY_GROUPINGS_MATURITY_MODELS]

PRINT(N'Drop constraint FK__AVAILABLE__model__6F6A7CB2 from [dbo].[AVAILABLE_MATURITY_MODELS]')
ALTER TABLE [dbo].[AVAILABLE_MATURITY_MODELS] NOCHECK CONSTRAINT [FK__AVAILABLE__model__6F6A7CB2]

PRINT(N'Drop constraint FK_MATURITY_LEVELS_MATURITY_MODELS from [dbo].[MATURITY_LEVELS]')
ALTER TABLE [dbo].[MATURITY_LEVELS] NOCHECK CONSTRAINT [FK_MATURITY_LEVELS_MATURITY_MODELS]

PRINT(N'Drop constraint FK_MODES_SETS_MATURITY_MODELS_MATURITY_MODELS from [dbo].[MODES_SETS_MATURITY_MODELS]')
ALTER TABLE [dbo].[MODES_SETS_MATURITY_MODELS] NOCHECK CONSTRAINT [FK_MODES_SETS_MATURITY_MODELS_MATURITY_MODELS]

PRINT(N'Drop constraints from [dbo].[GEN_FILE]')
ALTER TABLE [dbo].[GEN_FILE] NOCHECK CONSTRAINT [FK_GEN_FILE_FILE_REF_KEYS]
ALTER TABLE [dbo].[GEN_FILE] NOCHECK CONSTRAINT [FK_GEN_FILE_FILE_TYPE]

PRINT(N'Drop constraint FILE_KEYWORDS_GEN_FILE_FK from [dbo].[FILE_KEYWORDS]')
ALTER TABLE [dbo].[FILE_KEYWORDS] NOCHECK CONSTRAINT [FILE_KEYWORDS_GEN_FILE_FK]

PRINT(N'Drop constraint FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE from [dbo].[GEN_FILE_LIB_PATH_CORL]')
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] NOCHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE]

PRINT(N'Drop constraint FK_MATURITY_REFERENCES_GEN_FILE from [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]

PRINT(N'Drop constraint FK_REQUIREMENT_REFERENCES_GEN_FILE from [dbo].[REQUIREMENT_REFERENCES]')
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] NOCHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_GEN_FILE]

PRINT(N'Drop constraint FK_REQUIREMENT_SOURCE_FILES_GEN_FILE from [dbo].[REQUIREMENT_SOURCE_FILES]')
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] NOCHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_GEN_FILE]

PRINT(N'Drop constraint FK_SET_FILES_GEN_FILE from [dbo].[SET_FILES]')
ALTER TABLE [dbo].[SET_FILES] NOCHECK CONSTRAINT [FK_SET_FILES_GEN_FILE]

PRINT(N'Delete rows from [dbo].[MATURITY_REFERENCE_TEXT]')
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 5915 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 5931 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 5947 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 6018 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 6019 AND [Sequence] = 1
DELETE FROM [dbo].[MATURITY_REFERENCE_TEXT] WHERE [Mat_Question_Id] = 6028 AND [Sequence] = 1
PRINT(N'Operation applied to 6 rows out of 6')

PRINT(N'Update rows in [dbo].[MATURITY_QUESTIONS]')
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<div>Management of cybersecurity is considered a primary function when it is over 51% of the&#160;<span>work you do. This question aims to determine whether there is a single person or single group&#160; specifically in charge of all cybersecurity versus multiple entities managing different aspects of cybersecurity.</div>' WHERE [Mat_Question_Id] = 5913
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]='1.3 Is there a third-party contract arrangement for primary cyber management and/or operational functions for this Critical Service?' WHERE [Mat_Question_Id] = 5915
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<p>Programmable electronic devices and communication networks, including hardware,software and data. Data and cabling are considered to exist within the framework of the cyber asset and there are not separate cyber assets. </p>
<ul>
<li>Network -- Information Service(s) implemented with a collection of interconnected components. Such components may include routers, hubs, cabling, telecommunications controllers, key distribution centers, and technical control devices.</li>
<li>Application -- Application is digital application software program hosted by an information Service that functions and is operated by means of a computer, with the purpose of supporting functions needed by an asset owner.</li>
<li>Individuals - The key IT and security professionals within the organization. This would include: administrators, users, and third party contractors of the Critical Services.</li>
</ul>
<p>If yes, on what basis does the organization review, for the purpose of updating its inventory?<p>
<p>For purposes of this evaluation, the review of inventory is the verification and validation of the cyber assets (networks, Services, applications, connections, and individuals). This process
can be either manual (checking that the assets are physically there) or automated (computer system has inventory).</p>' WHERE [Mat_Question_Id] = 5919
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]='5.4 What measures does the organization employ to manage the configuration of this Critical Service? (Check all that apply.)', [Supplemental_Info]='<div>&#183; Identifies all hardware and disables all unnecessary elements (firmware): Are hardware&#160;<span>systems hardened to deny-all and allow-by-exception?</span></div><div>&#183; Identifies all software and disables all unnecessary elements: Are software systems&#160;<span>hardened to deny-all and allow-by-exception?</span></div><div>&#183; Identifies all services and disables all unnecessary elements (software-as-a-service): Are&#160;<span>service systems hardened to deny-all and allow-by-exception?</span></div><div>&#183; Identifies all operationally sensitive information: Does the organization know where all&#160;<span>sensitive information is located, for instance, on specific computer disks, databases, within&#160;</span><span>specific network segments, etc.?</span></div><div>&#183; Identifies security vulnerabilities: Uses methods such as: risk assessment, vulnerability&#160;<span>scanning, and penetration testing</span></div><div>&#183; Mitigates security vulnerabilities by implementing compensating security controls (e.g.,&#160;<span>patch, work-around, offline): Have the known weaknesses been addressed by protective&#160;</span><span>measures?</span></div><div>&#183; Strictly defines standardized service configurations: Are most or all systems configured&#160;<span>using the same or very similar method? For example, all Windows servers receive the same&#160;</span><span>Active Directory Group Policy configuration.</span></div><div><span><div>&#183; Identifies and addresses non-compliant configurations: Are exceptions&#160;<span>(systems with non-standard configurations, with special permissions, etc.)&#160;</span><span>clearly indicated and protected or monitored with special attention?</span></div><div>&#183; Defines network communication devices and means: Are the methods for&#160;<span>communicating over networks clearly identified and understood?</span></div><div>&#183; Defines portable media and access management: Are special procedures&#160;<span>defined for the use of portable media and the protection of the information that&#160;</span><span>can be transferred to portable media? For instance, since USB drives can&#160;</span><span>introduce malware, automated malware scanning should be required.</span></div></span></div>' WHERE [Mat_Question_Id] = 5931
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]='6.6 If the organization has Critical Services systems that are not or cannot be updated with respect to critical vulnerabilities, approximately what percentage of these systems have compensating security controls in place?' WHERE [Mat_Question_Id] = 5939
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]='8.2 Is there a Cybersecurity Plan covering this Critical Service?', [Sequence]=5 WHERE [Mat_Question_Id] = 5947
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<div>The question refers to whether your organization conducts exercises to determine best mitigation,&#160;<span>response, or replacement methodology in case of Critical Services failure or loss.</span></div>' WHERE [Mat_Question_Id] = 5950
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<div>&#183; Within your organization: A single person may fill several of the positions. The point of the question is&#160;<span>identifying whether the organization has formal positions with respect to cybersecurity of the&#160;</span><span>organization. One person within the organization may hold several of these roles.</span></div><div>&#183; Within the Critical Services environment: A single person may fill several of the positions. The point of the&#160;<span>question is to identify whether the organization has formal positions with respect to cybersecurity of&#160;</span><span>the Critical Services. These positions are more narrowly and specifically focused on the Critical Services.</span></div>' WHERE [Mat_Question_Id] = 5963
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='Each path has a business requirement for accessing or leaving the Critical Services.' WHERE [Mat_Question_Id] = 5985
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='Does the Critical Services benefit from access control device(s) that restrict incoming and/or outgoing connections between the Critical Services and the Internet? (Check all that apply): Does the Critical Services benefit from access control devices?' WHERE [Mat_Question_Id] = 5986
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='Operationally sensitive - HIPPA, PII, network diagrams, Critical Services inventories, etc.' WHERE [Mat_Question_Id] = 6004
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<div>Review of Critical Services policies, cybersecurity training, roles and responsibilities, acceptable use,&#160;<span>password policies.</span></div>' WHERE [Mat_Question_Id] = 6008
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]='24.1 Once the Critical Service is lost (without considering any redundant or alternative mode), what percentage of normal business functions are lost or degraded?' WHERE [Mat_Question_Id] = 6018
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]='24.2 Once the Critical Service is lost (without considering any redundant or alternative mode), within what time period will the business be severely impacted?' WHERE [Mat_Question_Id] = 6019
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=9 WHERE [Mat_Question_Id] = 6024
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=4 WHERE [Mat_Question_Id] = 6054
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<div>A single person may fill several of the positions. The point of the&#160;<span>question is to identify whether the organization has formal positions with respect to cybersecurity of&#160;</span><span>the Critical Services. These positions are more narrowly and specifically focused on the Critical Services.</span></div>' WHERE [Mat_Question_Id] = 6057
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<ul><li>Critical Services benefits from access control device(s) that restrict incoming connections to critical systems: Firewalls, Gateways, Level3 Switches, etc.</li>
<li>Critical Services benefits from access control device(s) that restrict outgoing connections from critical systems: Firewalls, Gateways, Level3 Switches, etc.</li></ul>' WHERE [Mat_Question_Id] = 6065
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]='Does the Critical Service benefit from access control device(s) that restrict incoming and/or outgoing connections between the Critical Service and a non-critical system that is connected to the Internet? (Check all that apply.)' WHERE [Mat_Question_Id] = 6066
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=3 WHERE [Mat_Question_Id] = 6072
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=4 WHERE [Mat_Question_Id] = 6073
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=5 WHERE [Mat_Question_Id] = 6074
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=6 WHERE [Mat_Question_Id] = 6114
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Mat_Question_Type]='text', [Parent_Option_Id]=825 WHERE [Mat_Question_Id] = 6128
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]='Is it sector-based (e.g., Industry ISACs)?' WHERE [Mat_Question_Id] = 6129
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Mat_Question_Type]='text', [Parent_Option_Id]=1917 WHERE [Mat_Question_Id] = 6130
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=4 WHERE [Mat_Question_Id] = 6182
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=5, [Mat_Question_Type]='min-hr-day' WHERE [Mat_Question_Id] = 6183
PRINT(N'Operation applied to 28 rows out of 28')

PRINT(N'Update row in [dbo].[MATURITY_MODELS]')
UPDATE [dbo].[MATURITY_MODELS] SET [Model_Name]='CIS' WHERE [Maturity_Model_Id] = 8

PRINT(N'Add row to [dbo].[GEN_FILE]')
SET IDENTITY_INSERT [dbo].[GEN_FILE] ON
IF NOT EXISTS (SELECT 1 FROM [dbo].[GEN_FILE] WHERE [Gen_File_Id] = 6086)
BEGIN
	INSERT INTO [dbo].[GEN_FILE] ([Gen_File_Id], [File_Type_Id], [File_Name], [Title], [Name], [File_Size], [Doc_Num], [Comments], [Description], [Short_Name], [Publish_Date], [Doc_Version], [Summary], [Source_Type], [Data], [Is_Uploaded]) VALUES (6086, 31, 'NIST.SP.800-53Ar5.pdf', 'NIST SP 800-53A R5: Assessing Security and Privacy Controls in Information Systems and Organizations', 'NIST Special Publication 800-53A Revision 5', 7469808, 'NONE', NULL, 'Assessing Security and Privacy Controls in Information Systems and Organizations', 'NIST SP 800-53A r5', NULL, NULL, 'Assessing Security and Privacy Controls in Information Systems and Organizations', NULL, NULL, 0)
END
SET IDENTITY_INSERT [dbo].[GEN_FILE] OFF

PRINT(N'Add row to [dbo].[MATURITY_MODELS]')
SET IDENTITY_INSERT [dbo].[MATURITY_MODELS] ON
INSERT INTO [dbo].[MATURITY_MODELS] ([Maturity_Model_Id], [Model_Name], [Questions_Alias], [Answer_Options], [Analytics_Rollup_Level], [Model_Description], [Model_Title]) VALUES (10, 'ISE', 'Statements', 'Y,N,NA,A', 3, NULL, NULL)
SET IDENTITY_INSERT [dbo].[MATURITY_MODELS] OFF

PRINT(N'Add rows to [dbo].[MATURITY_ANSWER_OPTIONS]')
SET IDENTITY_INSERT [dbo].[MATURITY_ANSWER_OPTIONS] ON
INSERT INTO [dbo].[MATURITY_ANSWER_OPTIONS] ([Mat_Option_Id], [Option_Text], [Mat_Question_Id], [Answer_Sequence], [ElementId], [Weight], [Mat_Option_Type], [Parent_Option_Id], [Has_Answer_Text], [Formula], [Threshold], [RiFormula], [ThreatType]) VALUES (1916, 'No', 6129, 1, 1676, 100.00, 'radio', NULL, 0, 'R(o1676)*O(o1676)*100', NULL, NULL, 1)
INSERT INTO [dbo].[MATURITY_ANSWER_OPTIONS] ([Mat_Option_Id], [Option_Text], [Mat_Question_Id], [Answer_Sequence], [ElementId], [Weight], [Mat_Option_Type], [Parent_Option_Id], [Has_Answer_Text], [Formula], [Threshold], [RiFormula], [ThreatType]) VALUES (1917, 'Yes', 6129, 2, 1677, 98.00, 'radio', NULL, 0, 'R(o1677)*O(o1677)*100', NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[MATURITY_ANSWER_OPTIONS] OFF
PRINT(N'Operation applied to 2 rows out of 2')

PRINT(N'Add rows to [dbo].[MATURITY_SOURCE_FILES]')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5049, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5050, 6086, '', NULL, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5051, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5052, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5053, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5054, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5055, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5056, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5057, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5058, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5059, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5060, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5061, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5062, 6086, 'SC-7', NULL, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5063, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5064, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5065, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5066, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5067, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5068, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5069, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5070, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5071, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5072, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5073, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5074, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5075, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5076, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5077, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5078, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5079, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5080, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5081, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5082, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5083, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5084, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5085, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5086, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5087, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5088, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5089, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5090, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5091, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5092, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5093, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5094, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5095, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5096, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5097, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5098, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5099, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5100, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5101, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5102, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5103, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5104, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5105, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5106, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5107, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5109, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5110, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5111, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5112, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5113, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5114, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5115, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5116, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5117, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5118, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5119, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5120, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5121, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5122, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5123, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5124, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5126, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5127, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5128, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5129, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5130, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5131, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5132, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5133, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5134, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5135, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5136, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5137, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5138, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5139, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5140, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5141, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5142, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5143, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5144, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5145, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5146, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5147, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5148, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5149, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5150, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5151, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5152, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5153, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5154, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5155, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5156, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5157, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5158, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5159, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5160, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5161, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5162, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5163, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5164, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5165, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5166, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5167, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5168, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5169, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5170, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5171, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5172, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5173, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5174, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5175, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5176, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5177, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5178, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5179, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5180, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5181, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5182, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5183, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5184, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5185, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5186, 6086, '', NULL, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5187, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5188, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5189, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5190, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5191, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5192, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5193, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5194, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5195, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5196, 6086, 'SC-7', NULL, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5197, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5198, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5199, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5200, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5201, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5202, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5203, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5204, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5205, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5206, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5207, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5208, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5209, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5210, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5211, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5212, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5213, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5214, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5215, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5216, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5217, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5218, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5219, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5220, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5221, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5222, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5223, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5224, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5225, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5226, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5227, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5228, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5229, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5230, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5231, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5232, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5233, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5234, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5235, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5236, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5237, 6086, 'IR-1', NULL, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5238, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5239, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5240, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5241, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5242, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5243, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5244, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5245, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5246, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5247, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5248, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5249, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5250, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5251, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5252, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5253, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5254, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5255, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5256, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5257, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5258, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5259, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5260, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5261, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5262, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5263, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5264, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5265, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5266, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5267, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5268, 6086, '', 0, '')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (5269, 6086, '', 0, '')
PRINT(N'Operation applied to 219 rows out of 219')

PRINT(N'Add constraints to [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[MATURITY_REFERENCE_TEXT]')
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_OPTIONS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTION_TYPES]
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[MATURITY_ANSWER_OPTIONS]')
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1]
ALTER TABLE [dbo].[ANSWER] WITH CHECK CHECK CONSTRAINT [FK_ANSWER_MATURITY_ANSWER_OPTIONS1]
ALTER TABLE [dbo].[ANALYTICS_MATURITY_GROUPINGS] WITH CHECK CHECK CONSTRAINT [FK_ANALYTICS_MATURITY_GROUPINGS_MATURITY_MODELS]
ALTER TABLE [dbo].[AVAILABLE_MATURITY_MODELS] WITH CHECK CHECK CONSTRAINT [FK__AVAILABLE__model__6F6A7CB2]
ALTER TABLE [dbo].[MATURITY_LEVELS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_LEVELS_MATURITY_MODELS]
ALTER TABLE [dbo].[MODES_SETS_MATURITY_MODELS] WITH CHECK CHECK CONSTRAINT [FK_MODES_SETS_MATURITY_MODELS_MATURITY_MODELS]

PRINT(N'Add constraints to [dbo].[GEN_FILE]')
ALTER TABLE [dbo].[GEN_FILE] WITH CHECK CHECK CONSTRAINT [FK_GEN_FILE_FILE_REF_KEYS]
ALTER TABLE [dbo].[GEN_FILE] WITH CHECK CHECK CONSTRAINT [FK_GEN_FILE_FILE_TYPE]
ALTER TABLE [dbo].[FILE_KEYWORDS] CHECK CONSTRAINT [FILE_KEYWORDS_GEN_FILE_FK]
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] CHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] CHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] CHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[SET_FILES] WITH CHECK CHECK CONSTRAINT [FK_SET_FILES_GEN_FILE]
COMMIT TRANSACTION
GO
