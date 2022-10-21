/*
Run this script on:

(localdb)\MSSQLLocalDB.CSETWeb12004    -  This database will be modified

to synchronize it with:

sql19dev1.CSETWeb

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.6.10.20102 from Red Gate Software Ltd at 10/19/2022 6:21:55 PM

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

PRINT(N'Drop constraint FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS from [dbo].[MATURITY_REFERENCE_TEXT]')
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_REFERENCES_MATURITY_QUESTIONS from [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS from [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]

PRINT(N'Drop constraints from [dbo].[GALLERY_ROWS]')
ALTER TABLE [dbo].[GALLERY_ROWS] NOCHECK CONSTRAINT [FK_GALLERY_ROWS_GALLERY_GROUP]
ALTER TABLE [dbo].[GALLERY_ROWS] NOCHECK CONSTRAINT [FK_GALLERY_ROWS_GALLERY_LAYOUT]

PRINT(N'Drop constraints from [dbo].[GALLERY_GROUP_DETAILS]')
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] NOCHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_GROUP]
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] NOCHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]

PRINT(N'Drop constraints from [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_GROUPING_TYPES]
ALTER TABLE [dbo].[MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_MODELS]

PRINT(N'Drop constraint FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS from [dbo].[MATURITY_DOMAIN_REMARKS]')
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] NOCHECK CONSTRAINT [FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS]

PRINT(N'Delete row from [dbo].[GALLERY_ROWS]')
DELETE FROM [dbo].[GALLERY_ROWS] WHERE [Layout_Name] = N'Florida' AND [Row_Index] = 0

PRINT(N'Delete row from [dbo].[GALLERY_LAYOUT]')
DELETE FROM [dbo].[GALLERY_LAYOUT] WHERE [Layout_Name] = N'Florida'

PRINT(N'Update rows in [dbo].[MATURITY_QUESTIONS]')
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]=N'<p><strong><span>Importance:</span></strong> Policies and procedures should be kept current to accurately reflect the organizational cybersecurity posture and strategy.</p>&#10;<p><strong><span>Question Intent:&#160;</span></strong>This question understands if policies and procedures are updated appropriately.</p>&#10;<p><strong><em><span>Criteria for Full Implementation Response</span></em></strong></p>&#10;<div>&#10;    <ul>&#10;        <li><span>All organizational policies and procedures are reviewed at the organization-defined</span><span>&#160;frequency.</span></li>&#10;    </ul>&#10;</div>&#10;<p><strong><em><span>Criteria for Partial Implementation Response</span></em></strong></p>&#10;<ul>&#10;    <li><span>Some organizational policies and procedures are reviewed at the organization-defined frequency</span></li>&#10;    <li><span>Or, organizational policies and procedures are reviewed, however on an infrequent basis.</span></li>&#10;    <li><span>(Otherwise, the answer is marked as No Implementation)</span></li>&#10;</ul>&#10;<p><strong><span>Possible Evidence</span></strong></p>&#10;<div>&#10;    <ul>&#10;        <li><span>Document revision or review history for policies and procedures,</span></li>&#10;    </ul>&#10;</div>&#10;<p><strong><span>Reference to standards/source assessments</span></strong></p>&#10;<ul class="decimal_type">&#10;    <li><span>IMCA: 4.2</span></li>&#10;    <li>NIST 800-53, Rev. 5: All -1 controls from all security control families. As all policies are covered by this question.</li>&#10;</ul>' WHERE [Mat_Question_Id] = 6325
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]=N'<p><strong><span>Importance:</span></strong> Write here why we&#8217;re asking this question.</p>&#10;<p><strong><span>Question Intent:&#160;</span></strong>Write here what the question is trying to ascertain.</p>&#10;<p><strong><em><span>Criteria for Full Implementation Response</span></em></strong></p>&#10;<div>&#10;    <ul>&#10;        <li>The organization conducts documented reviews of all planned incident management activities</li>&#10;    </ul>&#10;</div>&#10;<p><strong><em><span>Criteria for Partial Implementation Response</span></em></strong></p>&#10;<div>&#10;    <ul>&#10;        <li>The organization conducts ad hoc reviews of planned incident management activities or conducts documented reviews of some of the activities. (Otherwise, the answer is marked as No Implementation)</li>&#10;    </ul>&#10;</div>&#10;<p><strong><span>Possible Evidence</span></strong></p>&#10;<ul>&#10;    <li><span>Cybersecurity incident response plan</span></li>&#10;    <li><span>Risk management plan</span></li>&#10;</ul>&#10;<p><strong><span>Reference to standards/source assessments</span></strong></p>&#10;<ul class="decimal_type">&#10;    <li><span>CRR:&#160;</span><span>IM:MIL3.Q4</span></li>&#10;    <li>NIST 800-53, Rev. 5: PM-4, PM-9</li>&#10;</ul>' WHERE [Mat_Question_Id] = 6390
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Does the organization establish connections to the system on demand and terminate connections after completion of a request or a period of non-use?' WHERE [Mat_Question_Id] = 6580
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]=N'<p><strong><span>Importance:</span></strong> Situational awareness for threats is directly related to the critical assets of the organization as they support achievement of organizational objectives. Therefore, the organization objectives dictate the functional needs and requirements of any system. Without these requirements, improper procurement, implementation, or operation may result which would deliver insufficient security operations and raise risk exposure for the organization.</p>&#10;<p><strong><span>Question Intent:</span></strong> This question is trying to gain an understanding of how the organization collects and documents its requirements for proper continuous monitoring practices across the enterprise.</p>&#10;<p><span>Continuous monitoring may utilize tools that perform logging, alerting, and reporting.</span></p>&#10;<p><span>Alternative terms used could include &#8220;ConMon&#8221; or an abbreviation of &#8220;Continuous Monitoring&#8221;. See also &#8220;CSM&#8221; for &#8220;Continuous Security Monitoring&#8221;.</span></p>&#10;<p><strong><em><span>Criteria for Full Implementation Response</span></em></strong></p>&#10;<div>&#10;    <ul>&#10;        <li>The organization has a documented process for requirements exploration and documentation. This may be a process or system of collection for the entire security stack. Regardless, requirements should provide for continuous monitoring activities and practices. Similarly, the system should enable the workforce to acknowledge the adoption of solutions that meet those requirements.</li>&#10;    </ul>&#10;</div>&#10;<p><strong><em><span>Criteria for Partial Implementation Response</span></em></strong></p>&#10;<ul>&#10;    <li>A system may exist for requirements exploration, collection, and disposition. However, the execution of the process may be inadequate. Critical requirements may be missing. Requirements may exist in the system; however, they may never be addressed.</li>&#10;    <li>(Otherwise, the answer is marked as No Implementation)</li>&#10;</ul>&#10;<p><strong><span>Possible evidence</span></strong></p>&#10;<ul>&#10;    <li>Requirements collection utility to support a process</li>&#10;    <li>Documented requirements collection process and/or policy</li>&#10;    <li>Specific documented requirements that pertain to continuous monitoring</li>&#10;</ul>&#10;<p><strong><span>Reference to standards/source assessments</span></strong></p>&#10;<div>&#10;    <ul>&#10;        <li>Not applicable</li>&#10;    </ul>&#10;</div>' WHERE [Mat_Question_Id] = 6613
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]=N'<p><strong><span>Importance:</span></strong> Having alternate processing and storage capabilities allows an organization to sustain the critical service/HVA despite compromise, failure, or disruption.</p>&#10;<p><strong><span>Question Intent:&#160;</span></strong>To determine if the organization can sustain the critical service/HVA &#160;operations if the primary processing and storage capability &#160; is unavailable.</p>&#10;<ul>&#10;    <li><span>Plan for the transfer of mission critical business functions to alternate processing and/or storage sites with minimal or no loss of operational continuity. Sustain that continuity until the restoration of the mission critical business functions to primary processing and/or storage sites.</span></li>&#10;    <li><span>Organizations may choose to conduct contingency planning activities for alternate processing and storage sites as part of business continuity planning or business impact analyses. Primary processing and/or storage sites defined by organizations as part of contingency planning may change depending on the circumstances associated with the contingency</span></li>&#10;    <li><span>Alternate storage sites are geographically distinct from primary storage sites and maintain duplicate copies of information and data if the primary storage site is not available.</span></li>&#10;    <li><span>Similarly, alternate processing sites are geographically distinct from primary processing sites and provide processing capability if the primary processing site is not available.</span></li>&#10;    <li><span>Alternate processing and storage sites reflect the requirements in contingency plans so that organizations can maintain essential mission and business functions despite compromise, failure, or disruption in organizational systems</span></li>&#10;</ul>&#10;<p><strong><em><span>Criteria for Full Implementation Response</span></em></strong></p>&#10;<div>&#10;    <ul>&#10;        <li>The critical service/HVA essential functions are fully sustained if its primary processing and storage capabilities are unavailable.</li>&#10;    </ul>&#10;</div>&#10;<p><strong><em><span>Criteria for Partial Implementation Response</span></em></strong></p>&#10;<div>&#10;    <ul>&#10;        <li>The critical service/HVA essential functions are partially sustained if its primary processing and storage capabilities are unavailable.</li>&#10;    </ul>&#10;</div>&#10;<p><strong><span>Possible evidence</span></strong></p>&#10;<ul>&#10;    <li>Documentation detailing the implementation and configuration of alternate processing and storage capabilities</li>&#10;    <li>Contracts or agreements for the maintenance of a hot site, warm site, or cold site<strong>.</strong></li>&#10;</ul>&#10;<p><strong><span>Reference to standards/source assessments</span></strong></p>&#10;<div>&#10;    <ul>&#10;        <li>NIST 800-53, Rev. 5: <span>CP-2, CP-7</span></li>&#10;    </ul>&#10;</div>' WHERE [Mat_Question_Id] = 6734
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7633 WHERE [Mat_Question_Id] = 7634
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7633 WHERE [Mat_Question_Id] = 7635
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7633 WHERE [Mat_Question_Id] = 7636
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7633 WHERE [Mat_Question_Id] = 7637
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7633 WHERE [Mat_Question_Id] = 7638
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7633 WHERE [Mat_Question_Id] = 7711
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7633 WHERE [Mat_Question_Id] = 7712
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7633 WHERE [Mat_Question_Id] = 7713
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7633 WHERE [Mat_Question_Id] = 7714
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7633 WHERE [Mat_Question_Id] = 7715
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7633 WHERE [Mat_Question_Id] = 7716
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7633 WHERE [Mat_Question_Id] = 7717
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Parent_Question_Id]=7633 WHERE [Mat_Question_Id] = 7718
PRINT(N'Operation applied to 18 rows out of 18')

PRINT(N'Update row in [dbo].[MATURITY_GROUPINGS]')
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Title]=N'Suppliers and third-party partners of information systems, components, and services are identified, prioritized, and assessed using a cyber supply chain risk assessment process' WHERE [Grouping_Id] = 2424

PRINT(N'Update row in [dbo].[CSET_VERSION]')
UPDATE [dbo].[CSET_VERSION] SET [Version_Id]=12.0050, [Cset_Version]=N'12.0.0.5' WHERE [Id] = 1

PRINT(N'Add row to [dbo].[GALLERY_GROUP]')
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP] ON
INSERT INTO [dbo].[GALLERY_GROUP] ([Group_Id], [Group_Title]) VALUES (35, N'National Credit Union Administration (NCUA)')
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP] OFF

PRINT(N'Add row to [dbo].[GALLERY_LAYOUT]')
INSERT INTO [dbo].[GALLERY_LAYOUT] ([Layout_Name]) VALUES (N'CF')

PRINT(N'Add rows to [dbo].[GALLERY_GROUP_DETAILS]')
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP_DETAILS] ON
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Gallery_Item_Id], [Click_Count]) VALUES (1119, 35, 0, 28, 0)
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Gallery_Item_Id], [Click_Count]) VALUES (1120, 35, 1, 102, 0)
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Gallery_Item_Id], [Click_Count]) VALUES (1121, 35, 2, 54, 0)
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP_DETAILS] OFF
PRINT(N'Operation applied to 3 rows out of 3')

PRINT(N'Add rows to [dbo].[GALLERY_ROWS]')
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'CF', 0, 34)
INSERT INTO [dbo].[GALLERY_ROWS] ([Layout_Name], [Row_Index], [Group_Id]) VALUES (N'NCUA', 9, 10)
PRINT(N'Operation applied to 2 rows out of 2')

PRINT(N'Add constraints to [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_LEVELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_OPTIONS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTION_TYPES]
ALTER TABLE [dbo].[ISE_ACTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MAT_QUESTION_ID]
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1]
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[GALLERY_ROWS]')
ALTER TABLE [dbo].[GALLERY_ROWS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_ROWS_GALLERY_GROUP]
ALTER TABLE [dbo].[GALLERY_ROWS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_ROWS_GALLERY_LAYOUT]

PRINT(N'Add constraints to [dbo].[GALLERY_GROUP_DETAILS]')
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_GROUP]
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]

PRINT(N'Add constraints to [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_GROUPING_TYPES]
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS]
COMMIT TRANSACTION
GO
