/*
Run this script on:

(localdb)\MSSQLLocalDB.CSETWeb    -  This database will be modified

to synchronize it with:

(localdb)\v11.0.NCUAWeb10314

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.5.22.19589 from Red Gate Software Ltd at 11/8/2021 12:22:21 PM

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

PRINT(N'Drop constraints from [dbo].[SETS]')
ALTER TABLE [dbo].[SETS] NOCHECK CONSTRAINT [FK_SETS_Sets_Category]

PRINT(N'Drop constraint FK_AVAILABLE_STANDARDS_SETS from [dbo].[AVAILABLE_STANDARDS]')
ALTER TABLE [dbo].[AVAILABLE_STANDARDS] NOCHECK CONSTRAINT [FK_AVAILABLE_STANDARDS_SETS]

PRINT(N'Drop constraint FK_CUSTOM_STANDARD_BASE_STANDARD_SETS from [dbo].[CUSTOM_STANDARD_BASE_STANDARD]')
ALTER TABLE [dbo].[CUSTOM_STANDARD_BASE_STANDARD] NOCHECK CONSTRAINT [FK_CUSTOM_STANDARD_BASE_STANDARD_SETS]

PRINT(N'Drop constraint FK_CUSTOM_STANDARD_BASE_STANDARD_SETS1 from [dbo].[CUSTOM_STANDARD_BASE_STANDARD]')
ALTER TABLE [dbo].[CUSTOM_STANDARD_BASE_STANDARD] NOCHECK CONSTRAINT [FK_CUSTOM_STANDARD_BASE_STANDARD_SETS1]

PRINT(N'Drop constraint FK_NEW_QUESTION_SETS_SETS from [dbo].[NEW_QUESTION_SETS]')
ALTER TABLE [dbo].[NEW_QUESTION_SETS] NOCHECK CONSTRAINT [FK_NEW_QUESTION_SETS_SETS]

PRINT(N'Drop constraint FK_REPORT_STANDARDS_SELECTION_SETS from [dbo].[REPORT_STANDARDS_SELECTION]')
ALTER TABLE [dbo].[REPORT_STANDARDS_SELECTION] NOCHECK CONSTRAINT [FK_REPORT_STANDARDS_SELECTION_SETS]

PRINT(N'Drop constraint FK_REQUIREMENT_QUESTIONS_SETS_SETS from [dbo].[REQUIREMENT_QUESTIONS_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] NOCHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_SETS]

PRINT(N'Drop constraint FK_QUESTION_SETS_SETS from [dbo].[REQUIREMENT_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_SETS] NOCHECK CONSTRAINT [FK_QUESTION_SETS_SETS]

PRINT(N'Drop constraint FK_SECTOR_STANDARD_RECOMMENDATIONS_SETS from [dbo].[SECTOR_STANDARD_RECOMMENDATIONS]')
ALTER TABLE [dbo].[SECTOR_STANDARD_RECOMMENDATIONS] NOCHECK CONSTRAINT [FK_SECTOR_STANDARD_RECOMMENDATIONS_SETS]

PRINT(N'Drop constraint FK_SET_FILES_SETS from [dbo].[SET_FILES]')
ALTER TABLE [dbo].[SET_FILES] NOCHECK CONSTRAINT [FK_SET_FILES_SETS]

PRINT(N'Drop constraint FK_STANDARD_CATEGORY_SEQUENCE_SETS from [dbo].[STANDARD_CATEGORY_SEQUENCE]')
ALTER TABLE [dbo].[STANDARD_CATEGORY_SEQUENCE] NOCHECK CONSTRAINT [FK_STANDARD_CATEGORY_SEQUENCE_SETS]

PRINT(N'Drop constraint FK_Standard_Source_File_SETS from [dbo].[STANDARD_SOURCE_FILE]')
ALTER TABLE [dbo].[STANDARD_SOURCE_FILE] NOCHECK CONSTRAINT [FK_Standard_Source_File_SETS]

PRINT(N'Drop constraint FK_UNIVERSAL_SUB_CATEGORY_HEADINGS_SETS from [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS]')
ALTER TABLE [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] NOCHECK CONSTRAINT [FK_UNIVERSAL_SUB_CATEGORY_HEADINGS_SETS]

PRINT(N'Drop constraints from [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]

PRINT(N'Drop constraint FK_MATURITY_REFERENCES_MATURITY_QUESTIONS from [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS from [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]

PRINT(N'Update rows in [dbo].[MATURITY_REFERENCE_TEXT]')
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]='<div><b>CERT-RMM Reference</b></div><div><b>[CTRL:SG1.SP1] </b>Define and document control objectives that result from management&#160;<span>directives and guidelines. Affinity analysis of directives and guidelines may be useful in&#160;</span><span>identifying categories of control objectives.</span></div><div><br></div><div>These are examples of control objectives:</div><div><ul><li>prevent unauthorized use of purchase orders</li><li>ensure adequate supplies of materials</li><li>establish an enterprise architecture for information technology</li><li>develop and communicate policies regarding standards of ethical behavior</li><li>identify and assess risks that may cause material misstatements of financial records</li><li>educate and train staff</li><li>manage external entity relationships</li><li>establish a compliance program</li></ul></div><div><b>Additional References:</b></div><div><ul><li>FIPS Publication 199 Standards for Security Categorization of Federal Information and Information Systems Page 2</li><li>NIST CSF References: ID.GV-3, PR.AC, PR.DS, PR.IP, PR.MA, PR.PT</li></ul></div>' WHERE [Mat_Question_Id] = 1830 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]='<div><span><b>CERT-RMM Reference</b></span></div><div><span><b>[CTRL:SG1.SP1]&#160;</b></span>Define and document control objectives that result from management&#160;<span>directives and guidelines. Affinity analysis of directives and guidelines may be useful in&#160;</span><span>identifying categories of control objectives.</span></div><div><br></div><div>These are examples of control objectives:</div><div><ul><li>prevent unauthorized use of purchase orders</li><li>ensure adequate supplies of materials</li><li>establish an enterprise architecture for information technology</li><li>develop and communicate policies regarding standards of ethical behavior</li><li>identify and assess risks that may cause material misstatements of financial records</li><li>educate and train staff</li><li>manage external entity relationships</li><li>establish a compliance program</li></ul></div><div><span><b>Additional References:</b></span></div><div><ul><li>FIPS Publication 199 Standards for Security Categorization of Federal Information and Information Systems Page 2</li><li>NIST CSF References: ID.GV-3, PR.AC, PR.DS, PR.IP, PR.MA, PR.PT</li></ul></div>' WHERE [Mat_Question_Id] = 3184 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]='<div><b>CERT-RMM Reference</b></div><div><b>[CTRL:SG1.SP1] </b>The intent of prioritization is to determine the control objectives that&#160;<span>most need attention because of their potential to affect operational resilience. Assigning&#160;</span><span>a relative priority to each control objective or category aids in determining the level of&#160;</span><span>resources to apply when defining, analyzing, assessing, and addressing gaps in controls&#160;</span><span>(refer to CTRL:SG2, SG3, and SG4). Management directives and guidelines can be used to&#160;</span><span>establish criteria for prioritizing control objectives.</span></div><div><br></div><div><b>Additional References:</b></div><div><ul><li>Special Publication 800-39 &#34;Managing Information Security Risk Organization, Mission, and Information System View&#34; Page 14-15 Managing for Enterprise Security Page 15</li><li>NIST CSF References: ID.GV-3, PR.AC, PR.DS, PR.IP, PR.MA, PR.PT</li></ul></div>' WHERE [Mat_Question_Id] = 3188 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]='<div><b>CERT-RMM Reference</b></div><div><b>[CTRL:SG2.SP1] </b>Establish service-level and asset-level controls to satisfy control objectives.&#160;<span>These can be a combination of controls that already exist, controls that need updated, and&#160;</span><span>new controls that need to be implemented.</span></div><div><b>[KIM:SG4.SP1]</b>Consider applying cryptographic controls. Cryptographic controls are&#160;<span>applied to information assets to ensure confidentiality and prevent accidental disclosure.</span></div><div><b>[KIM:SG4.SP2] </b>Develop and implement access controls to satisfy confidentiality and&#160;<span>integrity requirements. Manage access to controls on an on-going basis to ensure&#160;</span><span>continued satisfaction of those requirements.</span></div><div><br></div><div><b>Additional References:</b></div><div><ul><li>NIST SP 800-53 Rev. 4 SC-8: Implement mechanisms (e.g. encryption and/or randomized communication patterns) to achieve confidentiality and integrity protection of data-in-transit.</li><li>NIST CSF References: PR.DS-2</li></ul></div>' WHERE [Mat_Question_Id] = 3192 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]='<div><b>CERT-RMM Reference</b></div><div><b>[ID:SG1.SP1] </b>An identity documents the existence of a person, object, or entity that&#160;<span>requires access to organizational assets, such as information, technology, and facilities, to&#160;</span><span>fulfill its role in executing services. An entity may be both internal and external to the&#160;</span><span>organization. Because the organizational environment is constantly changing, identity&#160;</span><span>registration is an ongoing organizational activity that requires continuous processes. To&#160;</span><span>properly manage organizational identities, the organization must have processes to&#160;</span><span>establish identities, deprovision identities, and manage changes to those identities.&#160;</span><span>Identities must be described in sufficient detail so that their attributes, including their&#160;</span><span>roles and responsibilities, are clear and can be used as the basis for determining the&#160;</span><span>appropriateness of assigning access privileges and restrictions. Once established, an&#160;</span><span>identity is the basis for assigning roles and access privileges in the organization.</span></div><div><b><br></b></div><div><b>Additional References:</b></div><div><ul><li>NIST SP 800-53 Rev. 4 AC-1, AC-2, AC-3, AC-16, AC-19, AC-24, IA-1, IA-2, IA-4, IA-5, IA-8, PE-2, PS-3</li><li>NIST SP 800-63 - Digital Identity Guidelines</li><li>NIST SP 800-63A - Enrollment and Identity Proofing</li><ul><li><span>Requiring multiple forms of identification, such as documentary evidence or a combination of documents and biometrics, reduces the likelihood of individuals using fraudulent identification to establish an identity. When a subject is identity proofed, the expected outcomes are: resolve a claimed identity to a single, unique identity; validate that all supplied evidence is correct and genuine; validate that the claimed identity exists in the real world; verify that the claimed identity is associated with the real person supplying the identity evidence.</span></li></ul><li><span>NIST CSF References: PR.AC-6</span><br></li></ul></div>' WHERE [Mat_Question_Id] = 3469 AND [Sequence] = 1
PRINT(N'Operation applied to 5 rows out of 5')

PRINT(N'Update row in [dbo].[SETS]')
UPDATE [dbo].[SETS] SET [Is_Custom]=0 WHERE [Set_Name] = 'C800_53_R5_V2'

PRINT(N'Update rows in [dbo].[MATURITY_QUESTIONS]')
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='' WHERE [Mat_Question_Id] = 1830
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<div><b>RKW&#160;</b></div><div><b>Question Intent:&#160;</b></div><div>To determine if control objectives for the critical service have been established.</div><div><br></div><div>Control objectives are important because controls are designed to meet those objectives.</div><div><ul><li>Control objectives provide a set of high-level requirements for the protection and sustainment of a critical service and associated assets.</li><li>Sources for identifying control objectives may be found in governance documents, policy documents, etc.</li></ul></div><div><br></div><div><br></div><div>&#10;<table border="1" cellpadding="0" cellspacing="0">&#10;    <tbody>&#10;        <tr>&#10;            <td valign="top">&#10;                <p><strong>Asset&#160;Type</strong></p>&#10;            </td>&#10;            <td valign="top">&#10;                <p><strong>Control Objective Example</strong></p>&#10;            </td>&#10;        </tr>&#10;        <tr>&#10;            <td valign="top">&#10;                <p><strong>People</strong></p>&#10;            </td>&#10;            <td valign="top">&#10;                <ul>&#10;                    <li>Ensure all employees are trustworthy and reliable prior to hiring them.</li>&#10;                    <li>All outside support personnel are identified.</li>&#10;                </ul>&#10;            </td>&#10;        </tr>&#10;        <tr>&#10;            <td valign="top">&#10;                <p><strong>Information</strong></p>&#10;            </td>&#10;            <td valign="top">&#10;                <ul>&#10;                    <li>Ensure the confidentiality and integrity of customer&#8217;s payment information.</li>&#10;                    <li>Information assets are disposed of according to policy.</li>&#10;                </ul>&#10;            </td>&#10;        </tr>&#10;        <tr>&#10;            <td valign="top">&#10;                <p><strong>Technology</strong></p>&#10;            </td>&#10;            <td valign="top">&#10;                <ul>&#10;                    <li>Ensure the databases that support one or more critical services remain available.</li>&#10;                    <li>Network integrity is protected.</li>&#10;                </ul>&#10;            </td>&#10;        </tr>&#10;        <tr>&#10;            <td valign="top">&#10;                <p><strong>Facilities</strong></p>&#10;            </td>&#10;            <td valign="top">&#10;                <ul>&#10;                    <li>Ensure environmental systems are maintained at an appropriate level to support datacenter equipment.</li>&#10;                    <li>Physical access to assets is managed and protected.</li>&#10;                </ul>&#10;            </td>&#10;        </tr>&#10;    </tbody>&#10;</table>&#10;&#10;&#10;&#10;<b>Criteria for &#8220;Yes&#8221; Response:</b></div><div><b><br></b></div><div><ul><li>Control objectives are established for all assets (people, information, technology, and facilities).</li><li>And; all control objectives are documented.</li></ul></div><div><b>Criteria for &#8220;Incomplete&#8221; Response:</b></div><div><b><br></b></div><div><ul><li>Control objectives are established for some assets.</li></ul></div>' WHERE [Mat_Question_Id] = 3184
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<div><span><b>RKW&#160;</b></span></div><div><span><b>Question Intent:&#160;</b></span></div><div>To determine if control objectives for the critical service have been established.</div><div><br></div><div>Control objectives are important because controls are designed to meet those objectives.</div><div><ul><li>Control objectives provide a set of high-level requirements for the protection and sustainment of a critical service and associated assets.</li><li>Sources for identifying control objectives may be found in governance documents, policy documents, etc.</li></ul></div><div><br></div><div><br></div><div><table border="1" cellpadding="0" cellspacing="0"><tbody><tr><td valign="top"><p><span><b>Asset&#160;Type</b></span></p></td><td valign="top"><p><span><b>Control Objective Example</b></span></p></td></tr><tr><td valign="top"><p><span><b>People</b></span></p></td><td valign="top"><ul><li>Ensure all employees are trustworthy and reliable prior to hiring them.</li><li>All outside support personnel are identified.</li></ul></td></tr><tr><td valign="top"><p>I<b>nformation</b></p></td><td valign="top"><ul><li>Ensure the confidentiality and integrity of customer&#8217;s payment information.</li><li>Information assets are disposed of according to policy.</li></ul></td></tr><tr><td valign="top"><p><span><b>Technology</b></span></p></td><td valign="top"><ul><li>Ensure the databases that support one or more critical services remain available.</li><li>Network integrity is protected.</li></ul></td></tr><tr><td valign="top"><p><span><b>Facilities</b></span></p></td><td valign="top"><ul><li>Ensure environmental systems are maintained at an appropriate level to support datacenter equipment.</li><li>Physical access to assets is managed and protected.</li></ul></td></tr></tbody></table><span><b>Criteria for &#8220;Yes&#8221; Response:</b></span></div><div><span><br></span></div><div><ul><li>Control objectives are established for all assets (people, information, technology, and facilities).</li><li>And; all control objectives are documented.</li></ul></div><div><span><b>Criteria for &#8220;Incomplete&#8221; Response:</b></span></div><div><span><br></span></div><div><ul><li>Control objectives are established for some assets.</li></ul></div>' WHERE [Mat_Question_Id] = 3185
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<div><span><b>RKW&#160;</b></span></div><div><span><b>Question Intent:&#160;</b></span></div><div>To determine if control objectives for the critical service have been established.</div><div><br></div><div>Control objectives are important because controls are designed to meet those objectives.</div><div><ul><li>Control objectives provide a set of high-level requirements for the protection and sustainment of a critical service and associated assets.</li><li>Sources for identifying control objectives may be found in governance documents, policy documents, etc.</li></ul></div><div><br></div><div><br></div><div><table border="1" cellpadding="0" cellspacing="0"><tbody><tr><td valign="top"><p><span><b>Asset&#160;Type</b></span></p></td><td valign="top"><p><span><b>Control Objective Example</b></span></p></td></tr><tr><td valign="top"><p><span><b>People</b></span></p></td><td valign="top"><ul><li>Ensure all employees are trustworthy and reliable prior to hiring them.</li><li>All outside support personnel are identified.</li></ul></td></tr><tr><td valign="top"><p>I<b>nformation</b></p></td><td valign="top"><ul><li>Ensure the confidentiality and integrity of customer&#8217;s payment information.</li><li>Information assets are disposed of according to policy.</li></ul></td></tr><tr><td valign="top"><p><span><b>Technology</b></span></p></td><td valign="top"><ul><li>Ensure the databases that support one or more critical services remain available.</li><li>Network integrity is protected.</li></ul></td></tr><tr><td valign="top"><p><span><b>Facilities</b></span></p></td><td valign="top"><ul><li>Ensure environmental systems are maintained at an appropriate level to support datacenter equipment.</li><li>Physical access to assets is managed and protected.</li></ul></td></tr></tbody></table><span><b>Criteria for &#8220;Yes&#8221; Response:</b></span></div><div><span><br></span></div><div><ul><li>Control objectives are established for all assets (people, information, technology, and facilities).</li><li>And; all control objectives are documented.</li></ul></div><div><span><b>Criteria for &#8220;Incomplete&#8221; Response:</b></span></div><div><span><br></span></div><div><ul><li>Control objectives are established for some assets.</li></ul></div>' WHERE [Mat_Question_Id] = 3186
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Supplemental_Info]='<div><span><b>RKW&#160;</b></span></div><div><span><b>Question Intent:&#160;</b></span></div><div>To determine if control objectives for the critical service have been established.</div><div><br></div><div>Control objectives are important because controls are designed to meet those objectives.</div><div><ul><li>Control objectives provide a set of high-level requirements for the protection and sustainment of a critical service and associated assets.</li><li>Sources for identifying control objectives may be found in governance documents, policy documents, etc.</li></ul></div><div><br></div><div><br></div><div><table border="1" cellpadding="0" cellspacing="0"><tbody><tr><td valign="top"><p><span><b>Asset&#160;Type</b></span></p></td><td valign="top"><p><span><b>Control Objective Example</b></span></p></td></tr><tr><td valign="top"><p><span><b>People</b></span></p></td><td valign="top"><ul><li>Ensure all employees are trustworthy and reliable prior to hiring them.</li><li>All outside support personnel are identified.</li></ul></td></tr><tr><td valign="top"><p>I<b>nformation</b></p></td><td valign="top"><ul><li>Ensure the confidentiality and integrity of customer&#8217;s payment information.</li><li>Information assets are disposed of according to policy.</li></ul></td></tr><tr><td valign="top"><p><span><b>Technology</b></span></p></td><td valign="top"><ul><li>Ensure the databases that support one or more critical services remain available.</li><li>Network integrity is protected.</li></ul></td></tr><tr><td valign="top"><p><span><b>Facilities</b></span></p></td><td valign="top"><ul><li>Ensure environmental systems are maintained at an appropriate level to support datacenter equipment.</li><li>Physical access to assets is managed and protected.</li></ul></td></tr></tbody></table><span><b>Criteria for &#8220;Yes&#8221; Response:</b></span></div><div><span><br></span></div><div><ul><li>Control objectives are established for all assets (people, information, technology, and facilities).</li><li>And; all control objectives are documented.</li></ul></div><div><span><b>Criteria for &#8220;Incomplete&#8221; Response:</b></span></div><div><span><br></span></div><div><ul><li>Control objectives are established for some assets.</li></ul></div>' WHERE [Mat_Question_Id] = 3187
PRINT(N'Operation applied to 5 rows out of 5')

PRINT(N'Add constraints to [dbo].[MATURITY_REFERENCE_TEXT]')
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[SETS]')
ALTER TABLE [dbo].[SETS] WITH CHECK CHECK CONSTRAINT [FK_SETS_Sets_Category]
ALTER TABLE [dbo].[AVAILABLE_STANDARDS] WITH CHECK CHECK CONSTRAINT [FK_AVAILABLE_STANDARDS_SETS]
ALTER TABLE [dbo].[CUSTOM_STANDARD_BASE_STANDARD] CHECK CONSTRAINT [FK_CUSTOM_STANDARD_BASE_STANDARD_SETS]
ALTER TABLE [dbo].[CUSTOM_STANDARD_BASE_STANDARD] CHECK CONSTRAINT [FK_CUSTOM_STANDARD_BASE_STANDARD_SETS1]
ALTER TABLE [dbo].[NEW_QUESTION_SETS] CHECK CONSTRAINT [FK_NEW_QUESTION_SETS_SETS]
ALTER TABLE [dbo].[REPORT_STANDARDS_SELECTION] WITH CHECK CHECK CONSTRAINT [FK_REPORT_STANDARDS_SELECTION_SETS]
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] WITH CHECK CHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_SETS]
ALTER TABLE [dbo].[REQUIREMENT_SETS] CHECK CONSTRAINT [FK_QUESTION_SETS_SETS]
ALTER TABLE [dbo].[SECTOR_STANDARD_RECOMMENDATIONS] CHECK CONSTRAINT [FK_SECTOR_STANDARD_RECOMMENDATIONS_SETS]
ALTER TABLE [dbo].[SET_FILES] WITH CHECK CHECK CONSTRAINT [FK_SET_FILES_SETS]
ALTER TABLE [dbo].[STANDARD_CATEGORY_SEQUENCE] CHECK CONSTRAINT [FK_STANDARD_CATEGORY_SEQUENCE_SETS]
ALTER TABLE [dbo].[STANDARD_SOURCE_FILE] CHECK CONSTRAINT [FK_Standard_Source_File_SETS]
ALTER TABLE [dbo].[UNIVERSAL_SUB_CATEGORY_HEADINGS] WITH CHECK CHECK CONSTRAINT [FK_UNIVERSAL_SUB_CATEGORY_HEADINGS_SETS]

PRINT(N'Add constraints to [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]
COMMIT TRANSACTION
GO
