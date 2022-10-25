/*
Run this script on:

(localdb)\MSSQLLocalDB.CSETWeb12004    -  This database will be modified

to synchronize it with:

sql19dev1.CSETWeb

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.6.10.20102 from Red Gate Software Ltd at 10/19/2022 10:25:02 AM

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
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_LEVELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_OPTIONS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTION_TYPES]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_QUESTIONS_MAT_QUESTION_ID from [dbo].[ISE_ACTIONS]')
ALTER TABLE [dbo].[ISE_ACTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MAT_QUESTION_ID]

PRINT(N'Drop constraint FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1 from [dbo].[MATURITY_ANSWER_OPTIONS]')
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] NOCHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1]

PRINT(N'Drop constraint FK_MATURITY_REFERENCES_MATURITY_QUESTIONS from [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Drop constraints from [dbo].[GALLERY_ROWS]')
ALTER TABLE [dbo].[GALLERY_ROWS] NOCHECK CONSTRAINT [FK_GALLERY_ROWS_GALLERY_GROUP]
ALTER TABLE [dbo].[GALLERY_ROWS] NOCHECK CONSTRAINT [FK_GALLERY_ROWS_GALLERY_LAYOUT]

PRINT(N'Drop constraint FK_ExtendedDemographicAnswer_ExtendedSector from [dbo].[DEMOGRAPHIC_ANSWERS]')
ALTER TABLE [dbo].[DEMOGRAPHIC_ANSWERS] NOCHECK CONSTRAINT [FK_ExtendedDemographicAnswer_ExtendedSector]

PRINT(N'Drop constraint FK_ExtendedSubSector_ExtendedSector from [dbo].[EXT_SUB_SECTOR]')
ALTER TABLE [dbo].[EXT_SUB_SECTOR] NOCHECK CONSTRAINT [FK_ExtendedSubSector_ExtendedSector]

PRINT(N'Delete row from [dbo].[GALLERY_ROWS]')
DELETE FROM [dbo].[GALLERY_ROWS] WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 9

PRINT(N'Update rows in [dbo].[MATURITY_REFERENCE_TEXT]')
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<b><font size="3">ISE Reference</font></b><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a><br></div>' WHERE [Mat_Question_Id] = 7568 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<span><font size="3"><b>ISE Reference</b></font></span><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div>' WHERE [Mat_Question_Id] = 7577 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<span><font size="3"><b>ISE Reference</b></font></span><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div>' WHERE [Mat_Question_Id] = 7582 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<span><font size="3"><b>ISE Reference</b></font></span><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div>' WHERE [Mat_Question_Id] = 7588 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-704/section-704.16" target="_blank">12 C.F.R&#160;&#167; 704.16, Contracts/written agreements</a>, <font size="3"><b><br></b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(3)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(3)</a><br></div><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(5)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(5)</a><br></div></div><div><br></div><div><font size="3"><b>Resources</b></font></div><div><a href="https://www.ncua.gov/regulation-supervision/letters-credit-unions-other-guidance/evaluating-third-party-relationships-0" target="_blank">SL No. 07-01 / October 2007</a><br></div>' WHERE [Mat_Question_Id] = 7602 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-749/section-749.0#p-749" target="_blank">12 C.F.R&#160;&#167; 749</a></div>' WHERE [Mat_Question_Id] = 7607 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div>' WHERE [Mat_Question_Id] = 7619 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div>' WHERE [Mat_Question_Id] = 7628 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div>' WHERE [Mat_Question_Id] = 7633 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div>' WHERE [Mat_Question_Id] = 7645 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div>' WHERE [Mat_Question_Id] = 7652 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div>' WHERE [Mat_Question_Id] = 7655 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(3)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(3)</a><br></div>' WHERE [Mat_Question_Id] = 7661 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-704/section-704.16" target="_blank">12 C.F.R&#160;&#167; 704.16, Contracts/written agreements</a>,<font size="3"><span><br></span></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(3)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(3)</a><br></div><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(5)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(5)</a></div></div><div><br></div><div><div><font size="3"><span><b>Resources</b></span></font></div><div><a href="https://www.ncua.gov/regulation-supervision/letters-credit-unions-other-guidance/evaluating-third-party-relationships-0" target="_blank"><font size="3">SL No. 07-01 / October 2007</font></a></div></div>' WHERE [Mat_Question_Id] = 7669 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-749/section-749.0" target="_blank">12 C.F.R&#160;&#167; 749</a></div>' WHERE [Mat_Question_Id] = 7674 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div>' WHERE [Mat_Question_Id] = 7679 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div>' WHERE [Mat_Question_Id] = 7683 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div>' WHERE [Mat_Question_Id] = 7687 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div>' WHERE [Mat_Question_Id] = 7691 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div>' WHERE [Mat_Question_Id] = 7694 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div>' WHERE [Mat_Question_Id] = 7699 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div>' WHERE [Mat_Question_Id] = 7891 AND [Sequence] = 1
PRINT(N'Operation applied to 22 rows out of 22')

PRINT(N'Update rows in [dbo].[MATURITY_QUESTIONS]')
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7568 WHERE [Mat_Question_Id] = 7569
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7568 WHERE [Mat_Question_Id] = 7570
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7568 WHERE [Mat_Question_Id] = 7571
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7568 WHERE [Mat_Question_Id] = 7572
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7568 WHERE [Mat_Question_Id] = 7573
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7568 WHERE [Mat_Question_Id] = 7574
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7568 WHERE [Mat_Question_Id] = 7575
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7568 WHERE [Mat_Question_Id] = 7576
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7577 WHERE [Mat_Question_Id] = 7578
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7577 WHERE [Mat_Question_Id] = 7579
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7577 WHERE [Mat_Question_Id] = 7580
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7577 WHERE [Mat_Question_Id] = 7581
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7582 WHERE [Mat_Question_Id] = 7583
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7582 WHERE [Mat_Question_Id] = 7584
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7582 WHERE [Mat_Question_Id] = 7585
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7582 WHERE [Mat_Question_Id] = 7586
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7582 WHERE [Mat_Question_Id] = 7587
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7588 WHERE [Mat_Question_Id] = 7589
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7588 WHERE [Mat_Question_Id] = 7590
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7588 WHERE [Mat_Question_Id] = 7591
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7588 WHERE [Mat_Question_Id] = 7592
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7588 WHERE [Mat_Question_Id] = 7593
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]=N'<p class="MsoNormal">Each institution should have a&#10;risk-based response program to address incidents of unauthorized access to&#10;customer information under Interagency Guidance on Response Programs for&#10;Unauthorized Access to Customer Information and Customer Notice. The incident&#10;response program should be appropriate to its size and complexity.&#160; At a minimum, a credit union''s response&#10;program should contain: </p>&#10;&#10;<p class="MsoNormal"><span>&#183;<span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#10;</span></span>Procedures for assessing the nature and scope of&#10;an incident and identifying what member information systems and types of member&#10;information have been accessed or misused.</p>&#10;&#10;<p class="MsoNormal"><span>&#183;<span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#10;</span></span>Procedures for taking appropriate steps to&#10;contain and control the incident to prevent further unauthorized access to or&#10;use of member information. These should list which personnel is responsible for&#10;taking these steps.</p>&#10;&#10;<p class="MsoNormal"><span>&#183;<span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#10;</span></span>Provisions for preparation, detection,&#10;containment, eradication, remediation, and follow-up.&#160; Each phase of the incident handling should&#10;list steps or procedures to follow.</p>&#10;&#10;<p class="MsoNormal"><span>&#183;<span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#10;</span></span>Procedures for notifying <span>law enforcement, insurers, regulators, other incident response vendors,&#10;and members including any appropriate regulatory timeframes, as well as who&#10;you&#8217;ll notify (for example which law enforcement agencies), when to file a&#10;Suspicious Activity Report (SAR) if applicable.</span></p>&#10;&#10;<p class="MsoNormal"><a><span>&#183;<span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#10;</span></span>Procedures for handling a third-party service&#10;provider incident and the related notification responsibility.</a> The response&#10;program should designate an incident response team and include roles and&#10;responsibilities for team members.&#160; The&#10;program should include standards for timely notification to members and outline&#10;components of the member notice. </p>&#10;&#10;<p class="MsoNormal">Member notice components:</p>&#10;&#10;<p class="MsoListParagraphCxSpFirst"><span>&#183;<span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#10;</span></span>Description of incident</p>&#10;&#10;<p class="MsoListParagraphCxSpMiddle"><span>&#183;<span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#10;</span></span>Type of member information compromised</p>&#10;&#10;<p class="MsoListParagraphCxSpMiddle"><span>&#183;<span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#10;</span></span>How the credit union will prevent further&#10;unauthorized access</p>&#10;&#10;<p class="MsoListParagraphCxSpMiddle"><span>&#183;<span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#10;</span></span>Informational phone number</p>&#10;&#10;<p class="MsoListParagraphCxSpMiddle"><span>&#183;<span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#10;</span></span>Reminder to members to remain vigilant over next&#10;12-24 months</p>&#10;&#10;<p class="MsoListParagraphCxSpMiddle"><span>&#183;<span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#10;</span></span>Promptly report ID theft to CU</p>&#10;&#10;<p class="MsoListParagraphCxSpLast"><span>&#183;<span>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#10;</span></span>Delivered in a manner member can be expected to&#10;receive</p>&#10;&#10;<p class="MsoNormal"><br></p>' WHERE [Mat_Question_Id] = 7594
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7594 WHERE [Mat_Question_Id] = 7595
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7594 WHERE [Mat_Question_Id] = 7596
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7594 WHERE [Mat_Question_Id] = 7597
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7594 WHERE [Mat_Question_Id] = 7598
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7594 WHERE [Mat_Question_Id] = 7599
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7594 WHERE [Mat_Question_Id] = 7600
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7594 WHERE [Mat_Question_Id] = 7601
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7602 WHERE [Mat_Question_Id] = 7603
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7602 WHERE [Mat_Question_Id] = 7604
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7602 WHERE [Mat_Question_Id] = 7605
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7602 WHERE [Mat_Question_Id] = 7606
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7607 WHERE [Mat_Question_Id] = 7608
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7607 WHERE [Mat_Question_Id] = 7609
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7607 WHERE [Mat_Question_Id] = 7610
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7607 WHERE [Mat_Question_Id] = 7611
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7612 WHERE [Mat_Question_Id] = 7613
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7612 WHERE [Mat_Question_Id] = 7614
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7612 WHERE [Mat_Question_Id] = 7615
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7612 WHERE [Mat_Question_Id] = 7616
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7612 WHERE [Mat_Question_Id] = 7617
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7612 WHERE [Mat_Question_Id] = 7618
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7619 WHERE [Mat_Question_Id] = 7620
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7619 WHERE [Mat_Question_Id] = 7621
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7619 WHERE [Mat_Question_Id] = 7622
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7619 WHERE [Mat_Question_Id] = 7623
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7619 WHERE [Mat_Question_Id] = 7624
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7619 WHERE [Mat_Question_Id] = 7625
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7619 WHERE [Mat_Question_Id] = 7626
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7619 WHERE [Mat_Question_Id] = 7627
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7628 WHERE [Mat_Question_Id] = 7629
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7628 WHERE [Mat_Question_Id] = 7630
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7628 WHERE [Mat_Question_Id] = 7631
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7628 WHERE [Mat_Question_Id] = 7632
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7639 WHERE [Mat_Question_Id] = 7640
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7639 WHERE [Mat_Question_Id] = 7641
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7639 WHERE [Mat_Question_Id] = 7642
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7639 WHERE [Mat_Question_Id] = 7643
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7639 WHERE [Mat_Question_Id] = 7644
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7645 WHERE [Mat_Question_Id] = 7646
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7645 WHERE [Mat_Question_Id] = 7647
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7645 WHERE [Mat_Question_Id] = 7648
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7645 WHERE [Mat_Question_Id] = 7649
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7645 WHERE [Mat_Question_Id] = 7650
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7645 WHERE [Mat_Question_Id] = 7651
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7652 WHERE [Mat_Question_Id] = 7653
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7652 WHERE [Mat_Question_Id] = 7654
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7655 WHERE [Mat_Question_Id] = 7656
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7655 WHERE [Mat_Question_Id] = 7657
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7655 WHERE [Mat_Question_Id] = 7658
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7655 WHERE [Mat_Question_Id] = 7659
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7655 WHERE [Mat_Question_Id] = 7660
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7661 WHERE [Mat_Question_Id] = 7662
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7661 WHERE [Mat_Question_Id] = 7663
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7661 WHERE [Mat_Question_Id] = 7664
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7661 WHERE [Mat_Question_Id] = 7665
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7661 WHERE [Mat_Question_Id] = 7666
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7661 WHERE [Mat_Question_Id] = 7667
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7661 WHERE [Mat_Question_Id] = 7668
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7669 WHERE [Mat_Question_Id] = 7670
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7669 WHERE [Mat_Question_Id] = 7671
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7669 WHERE [Mat_Question_Id] = 7672
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7669 WHERE [Mat_Question_Id] = 7673
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7674 WHERE [Mat_Question_Id] = 7675
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7674 WHERE [Mat_Question_Id] = 7676
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7674 WHERE [Mat_Question_Id] = 7677
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7674 WHERE [Mat_Question_Id] = 7678
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7679 WHERE [Mat_Question_Id] = 7680
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7679 WHERE [Mat_Question_Id] = 7681
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7679 WHERE [Mat_Question_Id] = 7682
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7683 WHERE [Mat_Question_Id] = 7684
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7683 WHERE [Mat_Question_Id] = 7685
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7683 WHERE [Mat_Question_Id] = 7686
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7687 WHERE [Mat_Question_Id] = 7688
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7687 WHERE [Mat_Question_Id] = 7689
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7687 WHERE [Mat_Question_Id] = 7690
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7691 WHERE [Mat_Question_Id] = 7692
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7691 WHERE [Mat_Question_Id] = 7693
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7694 WHERE [Mat_Question_Id] = 7695
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7694 WHERE [Mat_Question_Id] = 7696
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7694 WHERE [Mat_Question_Id] = 7697
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7694 WHERE [Mat_Question_Id] = 7698
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7699 WHERE [Mat_Question_Id] = 7700
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7699 WHERE [Mat_Question_Id] = 7701
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7619 WHERE [Mat_Question_Id] = 7702
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7619 WHERE [Mat_Question_Id] = 7703
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7619 WHERE [Mat_Question_Id] = 7704
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7619 WHERE [Mat_Question_Id] = 7705
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7619 WHERE [Mat_Question_Id] = 7706
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7628 WHERE [Mat_Question_Id] = 7707
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7628 WHERE [Mat_Question_Id] = 7708
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7628 WHERE [Mat_Question_Id] = 7709
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7628 WHERE [Mat_Question_Id] = 7710
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7639 WHERE [Mat_Question_Id] = 7719
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7639 WHERE [Mat_Question_Id] = 7720
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7639 WHERE [Mat_Question_Id] = 7721
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7639 WHERE [Mat_Question_Id] = 7722
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7639 WHERE [Mat_Question_Id] = 7723
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7639 WHERE [Mat_Question_Id] = 7724
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7639 WHERE [Mat_Question_Id] = 7725
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7639 WHERE [Mat_Question_Id] = 7726
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7639 WHERE [Mat_Question_Id] = 7727
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7639 WHERE [Mat_Question_Id] = 7728
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7639 WHERE [Mat_Question_Id] = 7729
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7639 WHERE [Mat_Question_Id] = 7730
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7645 WHERE [Mat_Question_Id] = 7731
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7645 WHERE [Mat_Question_Id] = 7732
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7645 WHERE [Mat_Question_Id] = 7733
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7645 WHERE [Mat_Question_Id] = 7734
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7645 WHERE [Mat_Question_Id] = 7735
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7645 WHERE [Mat_Question_Id] = 7736
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7652 WHERE [Mat_Question_Id] = 7737
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7652 WHERE [Mat_Question_Id] = 7738
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7652 WHERE [Mat_Question_Id] = 7739
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7655 WHERE [Mat_Question_Id] = 7740
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7655 WHERE [Mat_Question_Id] = 7741
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7655 WHERE [Mat_Question_Id] = 7742
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7655 WHERE [Mat_Question_Id] = 7743
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7655 WHERE [Mat_Question_Id] = 7744
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7655 WHERE [Mat_Question_Id] = 7745
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7655 WHERE [Mat_Question_Id] = 7746
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7661 WHERE [Mat_Question_Id] = 7747
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7661 WHERE [Mat_Question_Id] = 7748
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7661 WHERE [Mat_Question_Id] = 7749
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7661 WHERE [Mat_Question_Id] = 7750
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7661 WHERE [Mat_Question_Id] = 7751
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7661 WHERE [Mat_Question_Id] = 7752
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7661 WHERE [Mat_Question_Id] = 7753
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7661 WHERE [Mat_Question_Id] = 7754
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7661 WHERE [Mat_Question_Id] = 7755
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7661 WHERE [Mat_Question_Id] = 7756
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7669 WHERE [Mat_Question_Id] = 7757
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7669 WHERE [Mat_Question_Id] = 7758
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7669 WHERE [Mat_Question_Id] = 7759
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7669 WHERE [Mat_Question_Id] = 7760
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7669 WHERE [Mat_Question_Id] = 7761
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7669 WHERE [Mat_Question_Id] = 7762
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7669 WHERE [Mat_Question_Id] = 7763
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7669 WHERE [Mat_Question_Id] = 7764
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7669 WHERE [Mat_Question_Id] = 7765
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7669 WHERE [Mat_Question_Id] = 7766
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7669 WHERE [Mat_Question_Id] = 7767
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7669 WHERE [Mat_Question_Id] = 7768
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7669 WHERE [Mat_Question_Id] = 7769
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7669 WHERE [Mat_Question_Id] = 7770
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7669 WHERE [Mat_Question_Id] = 7771
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7669 WHERE [Mat_Question_Id] = 7772
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7669 WHERE [Mat_Question_Id] = 7773
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7674 WHERE [Mat_Question_Id] = 7774
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7674 WHERE [Mat_Question_Id] = 7775
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7674 WHERE [Mat_Question_Id] = 7776
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7674 WHERE [Mat_Question_Id] = 7777
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7674 WHERE [Mat_Question_Id] = 7778
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7674 WHERE [Mat_Question_Id] = 7779
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7674 WHERE [Mat_Question_Id] = 7780
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7674 WHERE [Mat_Question_Id] = 7781
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7674 WHERE [Mat_Question_Id] = 7782
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7674 WHERE [Mat_Question_Id] = 7783
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7674 WHERE [Mat_Question_Id] = 7784
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7679 WHERE [Mat_Question_Id] = 7785
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7679 WHERE [Mat_Question_Id] = 7786
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7679 WHERE [Mat_Question_Id] = 7787
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7679 WHERE [Mat_Question_Id] = 7788
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7679 WHERE [Mat_Question_Id] = 7789
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7679 WHERE [Mat_Question_Id] = 7790
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7679 WHERE [Mat_Question_Id] = 7791
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7679 WHERE [Mat_Question_Id] = 7792
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7679 WHERE [Mat_Question_Id] = 7793
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7679 WHERE [Mat_Question_Id] = 7794
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7679 WHERE [Mat_Question_Id] = 7795
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7683 WHERE [Mat_Question_Id] = 7796
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7683 WHERE [Mat_Question_Id] = 7797
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7683 WHERE [Mat_Question_Id] = 7798
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7683 WHERE [Mat_Question_Id] = 7799
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7683 WHERE [Mat_Question_Id] = 7800
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7683 WHERE [Mat_Question_Id] = 7801
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7683 WHERE [Mat_Question_Id] = 7802
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7683 WHERE [Mat_Question_Id] = 7803
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7683 WHERE [Mat_Question_Id] = 7804
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7683 WHERE [Mat_Question_Id] = 7805
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7683 WHERE [Mat_Question_Id] = 7806
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7683 WHERE [Mat_Question_Id] = 7807
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7687 WHERE [Mat_Question_Id] = 7808
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7687 WHERE [Mat_Question_Id] = 7809
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7687 WHERE [Mat_Question_Id] = 7810
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7687 WHERE [Mat_Question_Id] = 7811
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7687 WHERE [Mat_Question_Id] = 7812
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7687 WHERE [Mat_Question_Id] = 7813
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7687 WHERE [Mat_Question_Id] = 7814
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7687 WHERE [Mat_Question_Id] = 7815
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7687 WHERE [Mat_Question_Id] = 7816
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7687 WHERE [Mat_Question_Id] = 7817
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7687 WHERE [Mat_Question_Id] = 7818
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7687 WHERE [Mat_Question_Id] = 7819
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7687 WHERE [Mat_Question_Id] = 7820
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7687 WHERE [Mat_Question_Id] = 7821
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7687 WHERE [Mat_Question_Id] = 7822
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7687 WHERE [Mat_Question_Id] = 7823
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7687 WHERE [Mat_Question_Id] = 7824
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7687 WHERE [Mat_Question_Id] = 7825
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7687 WHERE [Mat_Question_Id] = 7826
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7691 WHERE [Mat_Question_Id] = 7827
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7691 WHERE [Mat_Question_Id] = 7828
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7691 WHERE [Mat_Question_Id] = 7829
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7691 WHERE [Mat_Question_Id] = 7830
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7691 WHERE [Mat_Question_Id] = 7831
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7691 WHERE [Mat_Question_Id] = 7832
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7691 WHERE [Mat_Question_Id] = 7833
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7691 WHERE [Mat_Question_Id] = 7834
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7694 WHERE [Mat_Question_Id] = 7835
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7694 WHERE [Mat_Question_Id] = 7836
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7694 WHERE [Mat_Question_Id] = 7837
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7694 WHERE [Mat_Question_Id] = 7838
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7694 WHERE [Mat_Question_Id] = 7839
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7694 WHERE [Mat_Question_Id] = 7840
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7694 WHERE [Mat_Question_Id] = 7841
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7694 WHERE [Mat_Question_Id] = 7842
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7699 WHERE [Mat_Question_Id] = 7843
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7699 WHERE [Mat_Question_Id] = 7844
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7699 WHERE [Mat_Question_Id] = 7845
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7699 WHERE [Mat_Question_Id] = 7846
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7699 WHERE [Mat_Question_Id] = 7847
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7699 WHERE [Mat_Question_Id] = 7848
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7699 WHERE [Mat_Question_Id] = 7849
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7699 WHERE [Mat_Question_Id] = 7850
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7699 WHERE [Mat_Question_Id] = 7851
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7699 WHERE [Mat_Question_Id] = 7852
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7853
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=2, [Parent_Question_Id]=7853 WHERE [Mat_Question_Id] = 7854
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=3, [Parent_Question_Id]=7853 WHERE [Mat_Question_Id] = 7855
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=4, [Parent_Question_Id]=7853 WHERE [Mat_Question_Id] = 7856
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=5, [Parent_Question_Id]=7853 WHERE [Mat_Question_Id] = 7857
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=6, [Parent_Question_Id]=7853 WHERE [Mat_Question_Id] = 7858
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=7, [Parent_Question_Id]=7853 WHERE [Mat_Question_Id] = 7859
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=8, [Parent_Question_Id]=7853 WHERE [Mat_Question_Id] = 7860
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=9, [Parent_Question_Id]=7853 WHERE [Mat_Question_Id] = 7861
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=10, [Parent_Question_Id]=7853 WHERE [Mat_Question_Id] = 7862
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=11, [Parent_Question_Id]=7853 WHERE [Mat_Question_Id] = 7863
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=12, [Parent_Question_Id]=7853 WHERE [Mat_Question_Id] = 7864
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=13, [Parent_Question_Id]=7853 WHERE [Mat_Question_Id] = 7865
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=14, [Parent_Question_Id]=7853 WHERE [Mat_Question_Id] = 7866
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=15, [Parent_Question_Id]=7853 WHERE [Mat_Question_Id] = 7867
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=16, [Parent_Question_Id]=7853 WHERE [Mat_Question_Id] = 7868
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7869
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=2, [Parent_Question_Id]=7869 WHERE [Mat_Question_Id] = 7870
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=3, [Parent_Question_Id]=7869 WHERE [Mat_Question_Id] = 7871
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=4, [Parent_Question_Id]=7869 WHERE [Mat_Question_Id] = 7872
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=5, [Parent_Question_Id]=7869 WHERE [Mat_Question_Id] = 7873
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=6, [Parent_Question_Id]=7869 WHERE [Mat_Question_Id] = 7874
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7875
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=2, [Parent_Question_Id]=7875 WHERE [Mat_Question_Id] = 7876
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=3, [Parent_Question_Id]=7875 WHERE [Mat_Question_Id] = 7877
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=4, [Parent_Question_Id]=7875 WHERE [Mat_Question_Id] = 7878
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=5, [Parent_Question_Id]=7875 WHERE [Mat_Question_Id] = 7879
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=6, [Parent_Question_Id]=7875 WHERE [Mat_Question_Id] = 7880
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=7, [Parent_Question_Id]=7875 WHERE [Mat_Question_Id] = 7881
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=8, [Parent_Question_Id]=7875 WHERE [Mat_Question_Id] = 7882
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=9, [Parent_Question_Id]=7875 WHERE [Mat_Question_Id] = 7883
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=10, [Parent_Question_Id]=7875 WHERE [Mat_Question_Id] = 7884
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=11, [Parent_Question_Id]=7875 WHERE [Mat_Question_Id] = 7885
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=12, [Parent_Question_Id]=7875 WHERE [Mat_Question_Id] = 7886
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=13, [Parent_Question_Id]=7875 WHERE [Mat_Question_Id] = 7887
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=14, [Parent_Question_Id]=7875 WHERE [Mat_Question_Id] = 7888
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=15, [Parent_Question_Id]=7875 WHERE [Mat_Question_Id] = 7889
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=16, [Parent_Question_Id]=7875 WHERE [Mat_Question_Id] = 7890
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7891 WHERE [Mat_Question_Id] = 7892
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7891 WHERE [Mat_Question_Id] = 7893
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7891 WHERE [Mat_Question_Id] = 7894
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7891 WHERE [Mat_Question_Id] = 7895
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7891 WHERE [Mat_Question_Id] = 7896
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7891 WHERE [Mat_Question_Id] = 7897
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7891 WHERE [Mat_Question_Id] = 7898
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7891 WHERE [Mat_Question_Id] = 7899
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7891 WHERE [Mat_Question_Id] = 7900
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7891 WHERE [Mat_Question_Id] = 7901
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7902
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=2, [Parent_Question_Id]=7902 WHERE [Mat_Question_Id] = 7903
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=3, [Parent_Question_Id]=7902 WHERE [Mat_Question_Id] = 7904
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=4, [Parent_Question_Id]=7902 WHERE [Mat_Question_Id] = 7905
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=5, [Parent_Question_Id]=7902 WHERE [Mat_Question_Id] = 7906
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=6, [Parent_Question_Id]=7902 WHERE [Mat_Question_Id] = 7907
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=7, [Parent_Question_Id]=7902 WHERE [Mat_Question_Id] = 7908
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=8, [Parent_Question_Id]=7902 WHERE [Mat_Question_Id] = 7909
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=9, [Parent_Question_Id]=7902 WHERE [Mat_Question_Id] = 7910
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=10, [Parent_Question_Id]=7902 WHERE [Mat_Question_Id] = 7911
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7912
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=2, [Parent_Question_Id]=7912 WHERE [Mat_Question_Id] = 7913
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=3, [Parent_Question_Id]=7912 WHERE [Mat_Question_Id] = 7914
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=4, [Parent_Question_Id]=7912 WHERE [Mat_Question_Id] = 7915
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=5, [Parent_Question_Id]=7912 WHERE [Mat_Question_Id] = 7916
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=6, [Parent_Question_Id]=7912 WHERE [Mat_Question_Id] = 7917
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=7, [Parent_Question_Id]=7912 WHERE [Mat_Question_Id] = 7918
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=1 WHERE [Mat_Question_Id] = 7919
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=2, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7920
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=3, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7921
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=4, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7922
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=5, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7923
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=6, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7924
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=7, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7925
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=8, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7926
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=9, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7927
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=10, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7928
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=11, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7929
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=12, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7930
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=13, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7931
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=14, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7932
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=15, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7933
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=16, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7934
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=17, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7935
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=18, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7936
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=19, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7937
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=20, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7938
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=21, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7939
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=22, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7940
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=23, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7941
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=24, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7942
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=25, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7943
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=26, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7944
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=27, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7945
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Sequence]=28, [Parent_Question_Id]=7919 WHERE [Mat_Question_Id] = 7946
PRINT(N'Operation applied to 342 rows out of 342')

PRINT(N'Update rows in [dbo].[GALLERY_ROWS]')
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=10 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 0
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=2 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 1
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=3 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 2
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=4 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 3
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=5 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 4
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=6 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 5
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=7 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 6
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=8 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 7
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=9 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 8
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=11 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 10
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=12 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 11
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=13 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 12
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=14 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 13
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=15 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 14
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=16 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 15
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=17 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 16
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=18 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 17
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=19 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 18
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=20 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 19
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=21 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 20
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=22 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 21
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=23 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 22
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=24 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 23
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=25 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 24
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=26 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 25
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=27 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 26
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=28 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 27
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=29 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 28
UPDATE [dbo].[GALLERY_ROWS] SET [Group_Id]=30 WHERE [Layout_Name] = N'NCUA' AND [Row_Index] = 29
PRINT(N'Operation applied to 29 rows out of 29')

PRINT(N'Update rows in [dbo].[EXT_SECTOR]')
UPDATE [dbo].[EXT_SECTOR] SET [SectorHelp]=N'The Communications Sector has evolved from predominantly a provider of voice services into a diverse, competitive, and interconnected industry using terrestrial, satellite, and wireless transmission systems. The transmission of these services has become interconnected; satellite, wireless, and wireline providers depend on each other to carry and terminate their traffic and companies routinely share facilities and technology to ensure interoperability. the private sector, as owners and operators of the majority of communications infrastructure, is the primary entity responsible for protecting sector infrastructure and assets. Working with the federal government, the private sector is able to predict, anticipate, and respond to sector outages and understand how they might affect the ability of the national leadership to communicate during times of crisis, impact the operations of other sectors, and affect response and recovery efforts. ' WHERE [SectorId] = 3
UPDATE [dbo].[EXT_SECTOR] SET [SectorHelp]=N'<p>The Critical Manufacturing Sector identified several industries to serve as the core of the sector:</p>
<ul>
<li><strong>Primary Metals Manufacturing</strong>
<ul>
<li>Iron and Steel Mills and Ferro Alloy Manufacturing</li>
<li>Alumina and Aluminum Production and Processing</li>
<li>Nonferrous Metal Production and Processing</li>
</ul>
</li>

<li><strong>Machinery Manufacturing</strong>
<ul>
<li>Engine and Turbine Manufacturing</li>
<li>Power Transmission Equipment Manufacturing</li>
<li>Earth Moving, Mining, Agricultural, and Construction Equipment Manufacturing</li>
</ul>
</li>

<li><strong>Electrical Equipment, Appliance, and Component Manufacturing</strong>
<ul>
<li>Electric Motor Manufacturing</li>
<li>Transformer Manufacturing</li>
<li>Generator Manufacturing</li>
</ul>
</li>

<li><strong>Transportation Equipment Manufacturing</strong>
<ul>
<li>Vehicles and Commercial Ships Manufacturing</li>
<li>Aerospace Products and Parts Manufacturing</li>
<li>Locomotives, Railroad and Transit Cars, and Rail Track Equipment Manufacturing</li>
</ul>
</li>
</ul>' WHERE [SectorId] = 4
UPDATE [dbo].[EXT_SECTOR] SET [SectorHelp]=N'The Dams Sector delivers critical water retention and control services in the United States, including hydroelectric power generation, municipal and industrial water supplies, agricultural irrigation, sediment and flood control, river navigation for inland bulk shipping, industrial waste management, and recreation. ' WHERE [SectorId] = 5
UPDATE [dbo].[EXT_SECTOR] SET [SectorHelp]=N'The Defense Industrial Base Sector is the worldwide industrial complex that enables research and development, as well as design, production, delivery, and maintenance of military weapons systems, subsystems, and components or parts, to meet U.S. military requirements. The Defense Industrial Base partnership consists of Department of Defense components, more than 100,000 Defense Industrial Base companies and their subcontractors who perform under contract to the Department of Defense, companies providing incidental materials and services to the Department of Defense, and government-owned/contractor-operated and government-owned/government-operated facilities. Defense Industrial Base companies include domestic and foreign entities, with production assets located in many countries. The sector provides products and services that are essential to mobilize, deploy, and sustain military operations. ' WHERE [SectorId] = 6
UPDATE [dbo].[EXT_SECTOR] SET [SectorHelp]=N'<p>The mission of the Emergency Services Sector is to save lives, protect property and the environment, assist communities impacted by disasters, and aid recovery during emergencies.</p>
<p>Five distinct disciplines compose the ESS, encompassing a wide range of emergency response functions and roles:</p>
<ul>
<li>Law Enforcement</li>
<li>Fire and Rescue Services</li>
<li>Emergency Medical Services</li>
<li>Emergency Management</li>
<li>Public Works</li>
</ul>
<p>The ESS also provides specialized emergency services through individual personnel and teams. These specialized capabilities may be found in one or more various disciplines, depending on the jurisdiction:</p>
<ul>
<li>Tactical Teams (i.e., SWAT)</li>
<li>Hazardous Devices Team/Public Safety Bomb Disposal</li>
<li>Public Safety Dive Teams/Maritime Units</li>
<li>Canine Units</li>
<li>Aviation Units (i.e., police and medevac helicopters)</li>
<li>Hazardous Materials (i.e., HAZMAT)</li>
<li>Search and Rescue Teams</li>
<li>Public Safety Answering Points (i.e., 9-1-1 call centers)</li>
<li>Fusion Centers</li>
<li>Private Security Guard Forces</li>
<li>National Guard Civil Support</li>
</ul>' WHERE [SectorId] = 7
UPDATE [dbo].[EXT_SECTOR] SET [SectorHelp]=N'The energy infrastructure is divided into three interrelated segments: electricity, oil, and natural gas. The U.S. electricity segment contains more than 6,413 power plants (this includes 3,273 traditional electric utilities and 1,738 nonutility power producers) with approximately 1,075 gigawatts of installed generation. Approximately 48 percent of electricity is produced by combusting coal (primarily transported by rail), 20 percent in nuclear power plants, and 22 percent by combusting natural gas. The remaining generation is provided by hydroelectric plants (6 percent), oil (1 percent), and renewable sources (solar, wind, and geothermal) (3 percent). ' WHERE [SectorId] = 8
UPDATE [dbo].[EXT_SECTOR] SET [SectorHelp]=N'The Financial Services Sector includes thousands of depository institutions, providers of investment products, insurance companies, other credit and financing organizations, and the providers of the critical financial utilities and services that support these functions. Financial institutions vary widely in size and presence, ranging from some of the world’s largest global companies with thousands of employees and many billions of dollars in assets, to community banks and credit unions with a small number of employees serving individual communities. Whether an individual savings account, financial derivatives, credit extended to a large organization, or investments made to a foreign country, these products allow customers to:
<ol>
<li>Deposit funds and make payments to other parties</li>
<li>Provide credit and liquidity to customers</li>
<li>Invest funds for both long and short periods</li>
<li>Transfer financial risks between customers</li>
</ol>' WHERE [SectorId] = 9
UPDATE [dbo].[EXT_SECTOR] SET [SectorHelp]=N'The Food and Agriculture Sector is almost entirely under private ownership and is composed of an estimated 2.1 million farms, 935,000 restaurants, and more than 200,000 registered food manufacturing, processing, and storage facilities.' WHERE [SectorId] = 10
UPDATE [dbo].[EXT_SECTOR] SET [SectorHelp]=N'<p>The Government Facilities Sector includes a wide variety of buildings, located in the United States and overseas, that are owned or leased by federal, state, local, and tribal governments. Many government facilities are open to the public for business activities, commercial transactions, or recreational activities while others that are not open to the public contain highly sensitive information, materials, processes, and equipment. These facilities include general-use office buildings and special-use military installations, embassies, courthouses, national laboratories, and structures that may house critical equipment, systems, networks, and functions. The Education Facilities Subsector covers pre-kindergarten through 12th grade schools, institutions of higher education, and business and trade schools. The subsector includes facilities that are owned by both government and private sector entities.</p>
<p>The National Monuments and Icons Subsector encompasses a diverse array of assets, networks, systems, and functions located throughout the United States. Many National Monuments and Icons assets are listed in either the National Register of Historic Places or the List of National Historic Landmarks. The Election Infrastructure Subsector covers a wide range of physical and electronic assets such as storage facilities, polling places, and centralized vote tabulations’ locations used to support the election process, and information and communications technology to include voter registration databases, voting machines, and other systems to manage the election process and report and display results on behalf of state and local governments.</p>' WHERE [SectorId] = 11
UPDATE [dbo].[EXT_SECTOR] SET [SectorHelp]=N'The Healthcare and Public Health Sector protects all sectors of the economy from hazards such as terrorism, infectious disease outbreaks, and natural disasters. Because the vast majority of the sector''s assets are privately owned and operated, collaboration and information sharing between the public and private sectors is essential to increasing resilience of the nation''s Healthcare and Public Health critical infrastructure. Operating in all U.S. states, territories, and tribal areas, the sector plays a significant role in response and recovery across all other sectors in the event of a natural or manmade disaster.' WHERE [SectorId] = 12
UPDATE [dbo].[EXT_SECTOR] SET [SectorHelp]=N'The Information Technology Sector distributed functions produce and provide hardware, software, and information technology systems and services, and—in collaboration with the Communications Sector—the Internet. Information Technology Sector functions are operated by a combination of entities—often owners and operators and their respective associations—that maintain and reconstitute the network, including the Internet.' WHERE [SectorId] = 13
UPDATE [dbo].[EXT_SECTOR] SET [SectorHelp]=N'<p>The Nuclear Reactors, Materials, and Waste Sector includes:</p>
<p>Active and Decommissioning Power Reactors in 30 states that generate nearly 20 percent of the nation’s electricity. </p>
<p>Research and Test Reactors located at universities and national labs. These reactors produce medical and industrial isotopes used to treat cancer and perform radiographic services, as well as to conduct academic research across multiple fields, including chemistry, physics, and material science.</p>
<p>Active Nuclear Fuel Cycle Facilities that are responsible for the production and reprocessing of nuclear reactor fuel. </p>
<p>More than 20,000 licensed users of radioactive sources. These radioactive sources are used for medical diagnostics and treatment in hospitals, depth measurements at oil and gas drilling sites, sterilization at food production facilities, research in academic institutions, and examining packages and cargo at security checkpoints.</p>
<p>Over 3 million yearly shipments of radioactive materials. Special security measures are taken when radioactive materials are shipped to ensure the safety of the transportation workers, and to prevent theft or sabotage of the radioactive material itself.</p>' WHERE [SectorId] = 14
UPDATE [dbo].[EXT_SECTOR] SET [SectorHelp]=N'<p>The Transportation Systems Sector consists of seven key subsectors, or modes:</p>
<p>Aviation includes aircraft, air traffic control systems, and airports, heliports, and landing strips. In addition, the aviation mode includes commercial and recreational aircraft (manned and unmanned) and a wide variety of support services, such as aircraft repair stations, fueling facilities, navigation aids, and flight schools.</p>
<p>Highway and Motor Carrier encompasses more than 4 million miles of roadway, more than 600,000 bridges, and more than 350 tunnels. Vehicles include trucks, including those carrying hazardous materials; other commercial vehicles, including commercial motorcoaches and school buses; vehicle and driver licensing systems; traffic management systems; and cyber systems used for operational management.</p>
<p>Maritime Transportation System consists of waterways, and intermodal landside connections that allow the various modes of transportation to move people and goods to, from, and on the water. </p>
<p>Mass Transit and Passenger Rail includes terminals, operational systems, and supporting infrastructure for passenger services by transit buses, trolleybuses, monorail, heavy rail—also known as subways or metros—light rail, passenger rail, and vanpool/rideshare. </p>
<p>Pipeline Systems consist of more than 2.5 million miles of pipelines spanning the country and carrying nearly all of the nation''s natural gas and about 65 percent of hazardous liquids, as well as various chemicals. Above-ground assets, such as compressor stations and pumping stations, are also included.</p>
<p>Freight Rail consists of seven major carriers, hundreds of smaller railroads, over 138,000 miles of active railroad, over 1.33 million freight cars, and approximately 20,000 locomotives.</p> 
<p>Postal and Shipping moves about 720 million letters and packages each day and includes large integrated carriers, regional and local courier services, mail services, mail management firms, and chartered and delivery services.</p>' WHERE [SectorId] = 15
UPDATE [dbo].[EXT_SECTOR] SET [SectorHelp]=N'Safe drinking water is a prerequisite for protecting public health and all human activity. Properly treated wastewater is vital for preventing disease and protecting the environment. There are approximately 153,000 public drinking water systems and more than 16,000 publicly owned wastewater treatment systems in the United States. More than 80 percent of the U.S. population receives their potable water from these drinking water systems, and about 75 percent of the U.S. population has its sanitary sewerage treated by these wastewater systems.' WHERE [SectorId] = 16
PRINT(N'Operation applied to 14 rows out of 14')

PRINT(N'Add row to [dbo].[GALLERY_ROWS]')
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'NCUA', 30, 31)

PRINT(N'Add rows to [dbo].[MATURITY_REFERENCE_TEXT]')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (7594, 1, N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(3)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(3)</a></div>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (7612, 1, N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div><div><br></div><div><font size="3"><b>Resources</b><br></font><a href="https://www.cisa.gov/uscert/ncas/current-activity/2018/03/27/Creating-and-Managing-Strong-Passwords" target="_blank">CISA NCCIC/US-CERT, Creating and Managing Strong Passwords</a><font size="3"><br></font></div>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (7639, 1, N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (7853, 1, N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (7869, 1, N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (7875, 1, N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (7902, 1, N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (7912, 1, N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-748/section-748.0#p-748.0(b)(2)" target="_blank">12 C.F.R&#160;&#167; 748.0 (b)(2)</a></div>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (7919, 1, N'<font size="3"><b>ISE Reference</b></font><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-701" target="_blank">12 C.F.R&#160;&#167; 701</a></div><div><a href="https://www.ecfr.gov/current/title-12/chapter-VII/subchapter-A/part-741" target="_blank">12 C.F.R&#160;&#167; 741</a><br></div>')
PRINT(N'Operation applied to 9 rows out of 9')

PRINT(N'Add rows to [dbo].[MATURITY_SOURCE_FILES]')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7568, 3866, N'ID.GV-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7568, 3943, N'II.C.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7568, 6088, N'page 2', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7577, 3944, N'I.B', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7582, 3866, N'ID.RA-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7582, 3866, N'ID.RA-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7582, 3866, N'ID.RA-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7582, 3943, N'II.A', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7582, 6092, N'Page 4', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7582, 6092, N'VI', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7582, 6093, N'2.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7582, 6106, N'Page 4', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7588, 3866, N'PR.AT-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7588, 3943, N'II.C.7(e)', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7588, 6087, N'14.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7588, 6087, N'14.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7588, 6087, N'14.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7588, 6087, N'14.6', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7588, 6092, N'V.', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7588, 6106, N'Page 10', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7594, 3866, N'PR.IP-10', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7594, 3866, N'PR.IP-9', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7594, 6087, N'17.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7594, 6087, N'17.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7594, 6087, N'17.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7594, 6090, N'Page 1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7594, 6092, N'Page 9', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7602, 3866, N'ID.SC-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7602, 3866, N'ID.SC-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7602, 3944, N'III.C.8', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7602, 3946, N'II.C.20', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7602, 6087, N'15.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7602, 6087, N'15.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7607, 3866, N'PR.IP-10', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7607, 3866, N'PR.IP-9', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7607, 3940, N'Page 3', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7607, 6087, N'11.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7607, 6088, N'Page 2', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7612, 6092, N'IV.', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7612, 6093, N'3.2, page 16', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7612, 6093, N'3.2, page 20, Patch your operating systems and applications', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7612, 6093, N'3.2, page 20, Set up web and email filters', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7612, 6093, N'3.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7619, 3866, N'ID.GV-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7619, 3943, N'II.C.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7619, 6088, N'page 2', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7628, 3944, N'I.B', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7633, 3866, N'ID.AM-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7633, 3866, N'ID-AM-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7633, 3945, N'III.B.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7633, 6087, N'1.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7639, 3866, N'ID.RA-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7639, 3866, N'ID.RA-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7639, 3866, N'ID.RA-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7639, 3943, N'II.A', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7639, 6092, N'page 4', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7639, 6092, N'VI.', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7639, 6093, N'2.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7639, 6106, N'page 4', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7645, 3866, N'DE.CM-8', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7645, 3949, N'page 1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7645, 6087, N'18.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7645, 6087, N'18.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7645, 6092, N'VI.', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7652, 3866, N'RS.MI-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7652, 3943, N'page 4', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7652, 3949, N'page 2', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7652, 3949, N'page 5', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7655, 3866, N'PR.AT-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7655, 3943, N'II.C.7(e)', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7655, 6087, N'14.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7655, 6087, N'14.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7655, 6087, N'14.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7655, 6087, N'14.6', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7655, 6092, N'V.', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7655, 6106, N'page 10', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7661, 3866, N'PR.IP-10', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7661, 3866, N'PR.IP-9', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7661, 6087, N'17.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7661, 6087, N'17.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7661, 6087, N'17.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7661, 6090, N'Page 1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7661, 6092, N'Page 9', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7669, 3866, N'ID.SC-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7669, 3866, N'ID.SC-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7669, 3944, N'III.C.8', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7669, 3946, N'II.C.20', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7669, 6087, N'15.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7669, 6087, N'15.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7674, 3866, N'PR.IP-10', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7674, 3866, N'PR.IP-9', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7674, 3940, N'I', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7674, 6087, N'11.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7674, 6095, N'page 2', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7679, 3866, N'PR.IP-12', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7679, 6087, N'7.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7679, 6087, N'7.7', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7679, 6099, N'page 2', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7683, 3866, N'DE.CM-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7683, 6087, N'10.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7683, 6087, N'10.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7683, 6087, N'10.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7683, 6087, N'10.6', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7687, 3866, N'PR.AC-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7687, 3866, N'PR.AC-7', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7687, 4999, N'4.3.1 Authenticators', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7687, 6087, N'5.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7687, 6087, N'5.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7687, 6106, N'page 11', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7691, 3866, N'DE.CM-7', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7691, 3866, N'PR.PT-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7691, 3945, N'V.B.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7691, 6087, N'12.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7694, 3866, N'PR.DS-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7694, 6087, N'9.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7694, 6087, N'9.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7694, 6087, N'9.6', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7694, 6087, N'9.7', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7699, 3943, N'II.C.7', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7699, 6087, N'4.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7699, 6087, N'6.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7699, 6087, N'6.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7853, 3866, N'PR.PT-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7853, 6087, N'13', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7853, 6101, N'NCUA Risk Alert', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7869, 6087, N'8', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7875, 3866, N'PR.PT-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7875, 6087, N'3', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7902, 3941, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (7902, 6087, N'16', NULL, N'')
PRINT(N'Operation applied to 130 rows out of 130')

PRINT(N'Add constraints to [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[MATURITY_REFERENCE_TEXT]')
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_LEVELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_OPTIONS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTION_TYPES]
ALTER TABLE [dbo].[ISE_ACTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MAT_QUESTION_ID]
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1]
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[GALLERY_ROWS]')
ALTER TABLE [dbo].[GALLERY_ROWS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_ROWS_GALLERY_GROUP]
ALTER TABLE [dbo].[GALLERY_ROWS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_ROWS_GALLERY_LAYOUT]
ALTER TABLE [dbo].[DEMOGRAPHIC_ANSWERS] WITH CHECK CHECK CONSTRAINT [FK_ExtendedDemographicAnswer_ExtendedSector]
ALTER TABLE [dbo].[EXT_SUB_SECTOR] WITH CHECK CHECK CONSTRAINT [FK_ExtendedSubSector_ExtendedSector]
COMMIT TRANSACTION
GO
