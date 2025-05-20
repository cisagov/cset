/*
Run this script on:

(localdb)\INLLocalDB2022.CSETWeb12402    -  This database will be modified

to synchronize it with:

(localdb)\INLLocalDB2022.CSETWeb12403

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.10.9.22680 from Red Gate Software Ltd at 4/10/2025 2:46:11 PM

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

PRINT(N'Drop constraints from [dbo].[REQUIREMENT_REFERENCES]')
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] NOCHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] NOCHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT]

PRINT(N'Drop constraints from [dbo].[GEN_FILE_LIB_PATH_CORL]')
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] NOCHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE]
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] NOCHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_REF_LIBRARY_PATH]

PRINT(N'Drop constraints from [dbo].[REQUIREMENT_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_SETS] NOCHECK CONSTRAINT [FK_QUESTION_SETS_SETS]
ALTER TABLE [dbo].[REQUIREMENT_SETS] NOCHECK CONSTRAINT [FK_REQUIREMENT_SETS_NEW_REQUIREMENT]

PRINT(N'Drop constraints from [dbo].[REQUIREMENT_LEVELS]')
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] NOCHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] NOCHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_REQUIREMENT_LEVEL_TYPE]
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] NOCHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_STANDARD_SPECIFIC_LEVEL]

PRINT(N'Drop constraints from [dbo].[PARAMETER_REQUIREMENTS]')
ALTER TABLE [dbo].[PARAMETER_REQUIREMENTS] NOCHECK CONSTRAINT [FK_Parameter_Requirements_NEW_REQUIREMENT]
ALTER TABLE [dbo].[PARAMETER_REQUIREMENTS] NOCHECK CONSTRAINT [FK_Parameter_Requirements_Parameters]

PRINT(N'Drop constraints from [dbo].[GEN_FILE]')
ALTER TABLE [dbo].[GEN_FILE] NOCHECK CONSTRAINT [FK_GEN_FILE_FILE_REF_KEYS]
ALTER TABLE [dbo].[GEN_FILE] NOCHECK CONSTRAINT [FK_GEN_FILE_FILE_TYPE]

PRINT(N'Drop constraint FILE_KEYWORDS_GEN_FILE_FK from [dbo].[FILE_KEYWORDS]')
ALTER TABLE [dbo].[FILE_KEYWORDS] NOCHECK CONSTRAINT [FILE_KEYWORDS_GEN_FILE_FK]

PRINT(N'Drop constraint FK_MATURITY_REFERENCES_GEN_FILE from [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]

PRINT(N'Drop constraint FK_SET_FILES_GEN_FILE from [dbo].[SET_FILES]')
ALTER TABLE [dbo].[SET_FILES] NOCHECK CONSTRAINT [FK_SET_FILES_GEN_FILE]

PRINT(N'Drop constraints from [dbo].[GALLERY_GROUP_DETAILS]')
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] NOCHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_GROUP]
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] NOCHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]

PRINT(N'Drop constraint FK_ASSESSMENT_PARAMETERS_PARAMETERS from [dbo].[PARAMETER_ASSESSMENT]')
ALTER TABLE [dbo].[PARAMETER_ASSESSMENT] NOCHECK CONSTRAINT [FK_ASSESSMENT_PARAMETERS_PARAMETERS]

PRINT(N'Drop constraint FK_PARAMETER_VALUES_PARAMETERS from [dbo].[PARAMETER_VALUES]')
ALTER TABLE [dbo].[PARAMETER_VALUES] NOCHECK CONSTRAINT [FK_PARAMETER_VALUES_PARAMETERS]

PRINT(N'Drop constraints from [dbo].[NEW_REQUIREMENT]')
ALTER TABLE [dbo].[NEW_REQUIREMENT] NOCHECK CONSTRAINT [FK_NEW_REQUIREMENT_NCSF_Category]
ALTER TABLE [dbo].[NEW_REQUIREMENT] NOCHECK CONSTRAINT [FK_NEW_REQUIREMENT_QUESTION_GROUP_HEADING]
ALTER TABLE [dbo].[NEW_REQUIREMENT] NOCHECK CONSTRAINT [FK_NEW_REQUIREMENT_SETS]
ALTER TABLE [dbo].[NEW_REQUIREMENT] NOCHECK CONSTRAINT [FK_NEW_REQUIREMENT_STANDARD_CATEGORY]

PRINT(N'Drop constraint FK_FINANCIAL_REQUIREMENTS_NEW_REQUIREMENT from [dbo].[FINANCIAL_REQUIREMENTS]')
ALTER TABLE [dbo].[FINANCIAL_REQUIREMENTS] NOCHECK CONSTRAINT [FK_FINANCIAL_REQUIREMENTS_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_NERC_RISK_RANKING_NEW_REQUIREMENT from [dbo].[NERC_RISK_RANKING]')
ALTER TABLE [dbo].[NERC_RISK_RANKING] NOCHECK CONSTRAINT [FK_NERC_RISK_RANKING_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT from [dbo].[REQUIREMENT_QUESTIONS_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] NOCHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_REFERENCE_TEXT_NEW_REQUIREMENT from [dbo].[REQUIREMENT_REFERENCE_TEXT]')
ALTER TABLE [dbo].[REQUIREMENT_REFERENCE_TEXT] NOCHECK CONSTRAINT [FK_REQUIREMENT_REFERENCE_TEXT_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_ASSESSMENTS_GALLERY_ITEM from [dbo].[ASSESSMENTS]')
ALTER TABLE [dbo].[ASSESSMENTS] NOCHECK CONSTRAINT [FK_ASSESSMENTS_GALLERY_ITEM]

PRINT(N'Drop constraint FK_Standard_Source_File_FILE_REF_KEYS from [dbo].[STANDARD_SOURCE_FILE]')
ALTER TABLE [dbo].[STANDARD_SOURCE_FILE] NOCHECK CONSTRAINT [FK_Standard_Source_File_FILE_REF_KEYS]

PRINT(N'Update rows in [dbo].[NEW_REQUIREMENT]')
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'[Licensee/Applicant]''s reviewing official grants unescorted access authorization to those individuals who have access, extensive knowledge, or administrative control of CDAs or communication systems that can adversely impact CDAs or safety, security, and emergency preparedness functions before they gain access to those systems, in accordance with Title 10 of the Code of Federal Regulations (10 CFR) 73.56, "Personnel Access Authorization Requirements for Nuclear Power Plants."' WHERE [Requirement_Id] = 1309
UPDATE [dbo].[NEW_REQUIREMENT] SET [Original_Set_Name]=N'Cor_7' WHERE [Requirement_Id] = 7439
UPDATE [dbo].[NEW_REQUIREMENT] SET [Original_Set_Name]=N'Cor_7' WHERE [Requirement_Id] = 7506
UPDATE [dbo].[NEW_REQUIREMENT] SET [Original_Set_Name]=N'Cor_7' WHERE [Requirement_Id] = 7662
UPDATE [dbo].[NEW_REQUIREMENT] SET [Original_Set_Name]=N'Cor_7' WHERE [Requirement_Id] = 7857
UPDATE [dbo].[NEW_REQUIREMENT] SET [Original_Set_Name]=N'Cor_7' WHERE [Requirement_Id] = 10944
UPDATE [dbo].[NEW_REQUIREMENT] SET [Original_Set_Name]=N'Cor_7' WHERE [Requirement_Id] = 11115
UPDATE [dbo].[NEW_REQUIREMENT] SET [Original_Set_Name]=N'Cor_7' WHERE [Requirement_Id] = 11143
UPDATE [dbo].[NEW_REQUIREMENT] SET [Original_Set_Name]=N'NCSF_V2' WHERE [Requirement_Id] = 36409
UPDATE [dbo].[NEW_REQUIREMENT] SET [Original_Set_Name]=N'NCSF_V2' WHERE [Requirement_Id] = 36417
UPDATE [dbo].[NEW_REQUIREMENT] SET [Original_Set_Name]=N'NCSF_V2' WHERE [Requirement_Id] = 36419
UPDATE [dbo].[NEW_REQUIREMENT] SET [Original_Set_Name]=N'NCSF_V2' WHERE [Requirement_Id] = 36429
UPDATE [dbo].[NEW_REQUIREMENT] SET [Original_Set_Name]=N'NCSF_V2' WHERE [Requirement_Id] = 36439
UPDATE [dbo].[NEW_REQUIREMENT] SET [Original_Set_Name]=N'NCSF_V2' WHERE [Requirement_Id] = 36442
UPDATE [dbo].[NEW_REQUIREMENT] SET [Original_Set_Name]=N'NCSF_V2' WHERE [Requirement_Id] = 36444
UPDATE [dbo].[NEW_REQUIREMENT] SET [Original_Set_Name]=N'NCSF_V2' WHERE [Requirement_Id] = 36445
UPDATE [dbo].[NEW_REQUIREMENT] SET [Original_Set_Name]=N'NCSF_V2' WHERE [Requirement_Id] = 36479
UPDATE [dbo].[NEW_REQUIREMENT] SET [Original_Set_Name]=N'NCSF_V2' WHERE [Requirement_Id] = 36484
UPDATE [dbo].[NEW_REQUIREMENT] SET [Original_Set_Name]=N'NCSF_V2' WHERE [Requirement_Id] = 36487
UPDATE [dbo].[NEW_REQUIREMENT] SET [Original_Set_Name]=N'NCSF_V2' WHERE [Requirement_Id] = 36491
UPDATE [dbo].[NEW_REQUIREMENT] SET [Original_Set_Name]=N'NCSF_V2' WHERE [Requirement_Id] = 36494
UPDATE [dbo].[NEW_REQUIREMENT] SET [Original_Set_Name]=N'NCSF_V2' WHERE [Requirement_Id] = 36497
UPDATE [dbo].[NEW_REQUIREMENT] SET [Original_Set_Name]=N'NCSF_V2' WHERE [Requirement_Id] = 36503
PRINT(N'Operation applied to 23 rows out of 23')

PRINT(N'Add row to [dbo].[FILE_REF_KEYS]')
INSERT INTO [dbo].[FILE_REF_KEYS] ([Doc_Num]) VALUES (N'SP800-161R1Upd1')

PRINT(N'Add row to [dbo].[GALLERY_ITEM]')
INSERT INTO [dbo].[GALLERY_ITEM] ([Gallery_Item_Guid], [Icon_File_Name_Small], [Icon_File_Name_Large], [Configuration_Setup], [Description], [Configuration_Setup_Client], [Title], [Is_Visible], [CreationDate]) VALUES ('3ec1234b-7fde-4b85-a2a8-7ffb888438fd', N'nist-sp-800-161.png', N'nist-sp-800-161.png', N'{"Sets":["NIST800_161_R1"],"SALLevel":"Low","QuestionMode":"Questions"}', N'This publication provides guidance to federal agencies on identifying, assessing, and mitigating ICT supply chain risks at all levels of their organizations. The publication integrates ICT supply chain risk management (SCRM) into federal agency risk management activities by applying a multitiered, SCRM-specific approach, including guidance on assessing supply chain risk and applying mitigation activities.', NULL, N'NIST SP 800-161 Rev. 1 - Cybersecurity Supply Chain Risk Management Practices for Systems and Organizations', 0, '2025-04-03 13:09:18.547')

PRINT(N'Add rows to [dbo].[NEW_REQUIREMENT]')
SET IDENTITY_INSERT [dbo].[NEW_REQUIREMENT] ON
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3900, N'AC-1', N'<ol type="a">
    <li>Develop, document, and disseminate to [Assignment: organization-defined personnel or roles]:
        <ol>
            <li>[Selection (one or more): Organization-level; Mission/business process-level; System-level] access control policy that:
                <ol type="a">
                    <li>Addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and</li>
                    <li>Is consistent with applicable laws, executive orders, directives, regulations, policies, standards, and guidelines; and</li>
                </ol>
            </li>
            <li>Procedures to facilitate the implementation of the access control policy and the associated access controls;</li>
        </ol>
    </li>
    <li>Designate an [Assignment: organization-defined official] to manage the development, documentation, and dissemination of the access control policy and procedures; and</li>
    <li>Review and update the current access control:
        <ol>
            <li>Policy [Assignment: organization-defined frequency] and following [Assignment: organization-defined events]; and</li>
            <li>Procedures [Assignment: organization-defined frequency] and following [Assignment: organization-defined events].</li>
        </ol>
    </li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises should specify and include in agreements (e.g., contracting language) access control policies for their suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers that have access control policies. These should include both physical and logical access to the supply chain and the information system. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. 
<br><br>Level(s): 1, 2, 3', N'Access Control', N'Access Control Policy and Procedures', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3901, N'AC-2', N'<ol type="a">
    <li>Define and document the types of accounts allowed and specifically prohibited for use within the system;</li>
    <li>Assign account managers;</li>
    <li>Require [Assignment: organization-defined prerequisites and criteria] for group and role membership;</li>
    <li>Specify:
        <ol>
            <li>Authorized users of the system;</li>
            <li>Group and role membership; and</li>
            <li>Access authorizations (i.e., privileges) and [Assignment: organization-defined attributes (as required)] for each account;</li>
        </ol>
    </li>
    <li>Require approvals by [Assignment: organization-defined personnel or roles] for requests to create accounts;</li>
    <li>Create, enable, modify, disable, and remove accounts in accordance with [Assignment: organization-defined policy, procedures, prerequisites, and criteria];</li>
    <li>Monitor the use of accounts;</li>
    <li>Notify account managers and [Assignment: organization-defined personnel or roles] within:
        <ol>
            <li>[Assignment: organization-defined time period] when accounts are no longer required;</li>
            <li>[Assignment: organization-defined time period] when users are terminated or transferred; and</li>
            <li>[Assignment: organization-defined time period] when system usage or need-to-know changes for an individual;</li>
        </ol>
    </li>
    <li>Authorize access to the system based on:
        <ol>
            <li>A valid access authorization;</li>
            <li>Intended system usage; and</li>
            <li>[Assignment: organization-defined attributes (as required)];</li>
        </ol>
    </li>
    <li>Review accounts for compliance with account management requirements [Assignment: organization-defined frequency];</li>
    <li>Establish and implement a process for changing shared or group account authenticators (if deployed) when individuals are removed from the group; and</li>
    <li>Align account management processes with personnel termination and transfer processes.</li>
</ol>', N'Supplemental C-SCRM Guidance: Use of this control helps establish traceability of actions and actors in the supply chain. This control also helps ensure access authorizations of actors in the supply chain are appropriate on a continuous basis. The enterprise may choose to define a set of roles and associate a level of authorization to ensure proper implementation. Enterprises must utilize unique accounts for contractor personnel and ensure that accounts for contractor personnel do not exceed the period of performance of the contract. Privileged accounts should only be established for appropriately vetted contractor personnel. Enterprises should also have processes in place to establish and manage temporary or emergency accounts for contractor personnel that require access to a mission-critical or mission-enabling system during a continuity or emergency event. For example, during a pandemic event, existing contractor personnel who are not able to work due to illness may need to be temporarily backfilled by new contractor staff. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant subtier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.
<br><br>Level(s): 2, 3', N'Access Control', N'Account Management', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3902, N'AC-3', N'Enforce approved authorizations for logical access to information and system resources
in accordance with applicable access control policies.', N'Supplemental C-SCRM Guidance: Ensure that the information systems and the supply chain have appropriate access enforcement mechanisms in place. This includes both physical and logical access enforcement mechanisms, which likely work in coordination for supply chain needs. Enterprises should ensure that a defined consequence framework is in place to address access control violations. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.
<br><br>Level(s): 2, 3', N'Access Control', N'Access Enforcement', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3903, N'AC-3(8)', N'Enforce the revocation of access authorizations resulting from changes to the security
attributes of subjects and objects based on [Assignment: organization-defined rules governing the timing of revocations of access authorizations].', N'Supplemental C-SCRM Guidance: Prompt revocation is critical to ensure that suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers who no longer require access or who abuse or violate their access privilege are not able to access an enterprise’s system. Enterprises should include in their agreements a requirement for contractors and sub-tier contractors to immediately return access credentials (e.g., tokens, PIV or CAC cards, etc.) to the enterprise. Enterprises must also have processes in place to promptly process the revocation of access authorizations. For example, in a “badge flipping” situation, a contract is transferred from one system integrator enterprise to another with the same personnel supporting the contract. In that situation, the enterprise should disable the existing accounts, retire the old credentials, establish new accounts, and issue completely new credentials.
<br><br>Level(s): 2, 3', N'Access Control', N'Access Enforcement', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3904, N'AC-3(9)', N'<p>Release information outside of the system only if:</p>
<ol type="a">
<li>The receiving [Assignment: organization-defined system or system component] provides [Assignment: organization-defined controls]; and</li>
<li>[Assignment: organization-defined controls] are used to validate the appropriateness of the information designated for release.</li>
</ol>', N'Supplemental C-SCRM Guidance: Information about the supply chain should be controlled for release between the enterprise and third parties. Information may be exchanged between the enterprise and its suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers. The controlled release of enterprise information protects against risks associated with disclosure.
<br><br>Level(s): 2, 3', N'Access Control', N'Access Enforcement', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3905, N'AC-4', N'Enforce approved authorizations for controlling the flow of information within the
system and between connected systems based on [Assignment: organization-defined information flow control policies].', N'Supplemental C- SCRM Guidance: Supply chain information may traverse a large supply chain to a broad set of stakeholders, including the enterprise and its various federal stakeholders, suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers. Specifying the requirements and how information flow is enforced should ensure that only the required information is communicated to various participants in the supply chain. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.
<br><br>Level(s): 2, 3', N'Access Control', N'Information Flow Enforcement', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3906, N'AC-4(6)', N'Enforce information flow control based on [Assignment: organization-defined metadata].', N'Supplemental C-SCRM Guidance: The metadata relevant to C-SCRM is extensive and includes activities within the SDLC. For example, information about systems and system components, acquisition details, and delivery is considered metadata and may require appropriate protections. Enterprises should identify what metadata is directly relevant to their supply chain security and ensure that information flow enforcement is implemented in order to protect applicable metadata.
<br><br>Level(s): 2, 3', N'Access Control', N'Information Flow Enforcement', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3907, N'AC-4(17)', N'Uniquely identify and authenticate source and destination points by [Selection (one or more): organization; system; application; service; individual] for information transfer.', N'Supplemental C-SCRM Guidance: Within the C-SCRM context, enterprises should specify various source and destination points for information about the supply chain and information that flows through the supply chain. This is so that enterprises have visibility of information flow within the supply chain.
<br><br>Level(s): 2, 3', N'Access Control', N'Information Flow Enforcement', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3908, N'AC-4(19)', N'When transferring information between different security domains, implement
[Assignment: organization-defined security or privacy policy filters] on metadata.', N'Supplemental C-SCRM Guidance: For C-SCRM, the validation of data and the relationship to its metadata are critical. Much of the data transmitted through the supply chain is validated with the verification of the associated metadata that is bound to it. Ensure that proper filtering and inspection is put in place for validation before allowing payloads into the supply chain.
<br><br>Level(s): 2, 3', N'Access Control', N'Information Flow Enforcement', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3909, N'AC-4(21)', N'Separate information flows logically or physically using [Assignment: organization-defined mechanisms and/or techniques] to accomplish [Assignment: organization-defined required separations by types of information].', N'Supplemental C-SCRM Guidance: The enterprise should ensure the separation of the information system and supply chain information flow. Various mechanisms can be implemented, such as encryption methods (e.g., digital signing). Addressing information flow between the enterprise and its suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers may be challenging, especially when leveraging public networks.
<br><br>Level(s): 3', N'Access Control', N'Information Flow Enforcement', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3910, N'AC-5', N'<ol type="a">
    <li>Identify and document [Assignment: organization-defined duties of individuals requiring separation]; and</li>
    <li>Define system access authorizations to support separation of duties.</li>
</ol>', N'Supplemental C-SCRM Guidance: The enterprise should ensure that an appropriate separation of duties is established for decisions that require the acquisition of both information system and supply chain components. The separation of duties helps to ensure that adequate protections are in place for components entering the enterprise’s supply chain, such as denying developers the privilege to promote code that they wrote from development to production environments. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant subtier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s
Cybersecurity.
<br><br>Level(s): 2, 3', N'Access Control', N'Separation of Duties', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3911, N'AC-6(6)', N'Prohibit privileged access to the system by non-organizational users.', N'Supplemental C-SCRM Guidance: Enterprises should ensure that protections are in place to prevent non-enterprise users from having privileged access to enterprise supply chain and related supply chain information. When enterprise users include independent consultants, suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers, relevant access requirements may need to use least privilege mechanisms to precisely define what information and/or components are accessible, for what duration, at what frequency, using what access methods, and by whom. Understanding what components are critical and non-critical can aid in understanding the level of detail that may need to be defined regarding least privilege access for non-enterprise users.
<br><br>Level(s): 2, 3', N'Access Control', N'Least Privilege', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3912, N'AC-17', N'<ol type="a">
    <li>Establish and document usage restrictions, configuration/connection requirements, and implementation guidance for each type of remote access allowed; and</li>
    <li>Authorize each type of remote access to the system prior to allowing such connections.</li>
</ol>', N'Supplemental C-SCRM Guidance: Ever more frequently, supply chains are accessed remotely. Whether for the purpose of development, maintenance, or the operation of information systems, enterprises should implement secure remote access mechanisms and allow remote access only to vetted personnel. Remote access to an enterprise’s supply chain (including distributed software development environments) should be limited to the enterprise or contractor personnel and only if and as required to perform their tasks. Remote access requirements – such using a secure remote access solution, employing multi-factor authentication, limiting access to specified business hours, limit access to specific assets (not networks) based on role and from specified geographic locations – must be properly defined in agreements. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.
<br><br>Level(s): 2, 3', N'Access Control', N'Remote Access', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3913, N'AC-17(6)', N'Protect information about remote access mechanisms from unauthorized use and
disclosure.', N'Supplemental C-SCRM Guidance: Enterprises should ensure that detailed requirements are properly defined and that access to information regarding the information system and supply chain is protected from unauthorized use and disclosure. Since supply chain data and metadata disclosure or access can have significant implications for an enterprise’s mission processes, appropriate measures must be taken to vet both the supply chain and personnel processes to ensure that adequate protections are implemented. Ensure that remote access to such information is included in requirements.
<br><br>Level(s): 2, 3', N'Access Control', N'Remote Access', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3914, N'AC-18', N'<ol type="a">
<li>Establish configuration requirements, connection requirements, and implementation guidance for each type of wireless access; and</li>
<li>Authorize each type of wireless access to the system prior to allowing such connections.</li>
</ol>', N'Supplemental C-SCRM Guidance: An enterprise’s supply chain may include wireless infrastructure that supports supply chain logistics (e.g., radio-frequency identification device [RFID] support, software call home features). Supply chain systems/components traverse the supply chain as they are moved from one location to another, whether within the enterprise’s own environment or during delivery from system integrators or suppliers. Ensuring that appropriate and secure access mechanisms are in place within this supply chain enables the protection of the information systems and components, as well as logistics technologies and metadata used during shipping (e.g., within tracking sensors). The enterprise should explicitly define appropriate wireless access control mechanisms for the supply chain in policy and implement appropriate mechanisms.
<br><br>Level(s): 1, 2, 3', N'Access Control', N'Wireless Access', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3915, N'AC-19', N'<ol type="a">
    <li>Establish configuration requirements, connection requirements, and implementation guidance for organization-controlled mobile devices, to include when such devices are outside of controlled areas; and</li>
    <li>Authorize the connection of mobile devices to organizational systems.</li>
</ol>', N'Supplemental C-SCRM Guidance: The use of mobile devices (e.g., laptops, tablets, e-readers, smartphones, smartwatches) has become common in the supply chain. They are used in direct support of an enterprise’s operations, as well as tracking, supply chain logistics, data as information systems, and components that traverse enterprise or systems integrator supply chains. Ensure that access control mechanisms are clearly defined and implemented where relevant when managing enterprise supply chain components. An example of such an implementation includes access control mechanisms implemented for use with remote handheld units in RFID for tracking components that traverse the supply chain. Access control mechanisms should also be implemented on any associated data and metadata tied to the devices.
<br><br>Level(s): 2, 3', N'Access Control', N'Access Control for Mobile Devices', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3916, N'AC-20', N'<ol type="a">
    <li>[Selection (one or more): Establish [Assignment: organization-defined terms and conditions]; Identify [Assignment: organization-defined controls asserted to be implemented on external systems]], consistent with the trust relationships established with other organizations owning, operating, and/or maintaining external systems, allowing authorized individuals to:
        <ol>
            <li>Access the system from external systems; and</li>
            <li>Process, store, or transmit organization-controlled information using external systems; or</li>
        </ol>
    </li>
    <li>Prohibit the use of [Assignment: organizationally-defined types of external systems].</li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises’ external information systems include those of suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers. Unlike in an acquirer’s internal enterprise where direct and continuous monitoring is possible, in the external supplier relationship, information may be shared on an as-needed basis and should be articulated in an agreement. Access to the supply chain from such external information systems should be monitored and audited. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant subtier contractors.
<br><br>Level(s): 1, 2, 3', N'Access Control', N'Use of External Systems', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3917, N'AC-20(1)', N'<p>Permit authorized individuals to use an external system to access the system or to process, store, or transmit organization-controlled information only after:</p>
<ol type="a">
    <li>Verification of the implementation of controls on the external system as specified in the organization''s security and privacy policies and security and privacy plans; or</li>
    <li>Retention of approved system connection or processing agreements with the organizational entity hosting the external system.</li>
</ol>', N'Supplemental C-SCRM Guidance: This enhancement helps limit exposure of the supply chain to the systems of suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers.
<br><br>Level(s): 2, 3', N'Access Control', N'Use of External Systems', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3918, N'AC-20(3)', N'Restrict the use of non-organizationally owned systems or system components to process,
store, or transmit organizational information using [Assignment: organization-defined restrictions].', N'Supplemental C-SCRM Guidance: Devices that do not belong to the enterprise (e.g., bring your own device [BYOD] policies) increase the enterprise’s exposure to cybersecurity risks throughout the supply chain. This includes devices used by suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers. Enterprises should review the use of non-enterprise devices by non-enterprise personnel and make a risk-based decision as to whether it will allow the use of such devices or furnish devices. Enterprises should furnish devices to those non-enterprise personnel who present unacceptable levels of risk.
<br><br>Level(s): 2, 3', N'Access Control', N'Use of External Systems', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3919, N'AC-21', N'<ol type="a">
    <li>Enable authorized users to determine whether access authorizations assigned to a sharing partner match the information''s access and use restrictions for [Assignment: organization-defined information sharing circumstances where user discretion is required]; and</li>
    <li>Employ [Assignment: organization-defined automated mechanisms or manual processes] to assist users in making information sharing and collaboration decisions.</li>
</ol>', N'Supplemental C-SCRM Guidance: Sharing information within the supply chain can help manage cybersecurity risks throughout the supply chain. This information may include vulnerabilities, threats, the criticality of systems and components, or delivery information. This information sharing should be carefully managed to ensure that the information is only accessible to authorized individuals within the enterprise’s supply chain. Enterprises should clearly define boundaries for information sharing with respect to temporal, informational, contractual, security, access, system, and other requirements. Enterprises should monitor and review for unintentional or intentional information sharing within its supply chain activities, including information sharing with suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers. 
<br><br>Level(s): 1, 2', N'Access Control', N'Information Sharing', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3920, N'AC-22', N'<ol type="a">
    <li>Designate individuals authorized to make information publicly accessible;</li>
    <li>Train authorized individuals to ensure that publicly accessible information does not contain nonpublic information;</li>
    <li>Review the proposed content of information prior to posting onto the publicly accessible system to ensure that nonpublic information is not included; and</li>
    <li>Review the content on the publicly accessible system for nonpublic information [Assignment: organization-defined frequency] and remove such information, if discovered.</li>
</ol>', N'Supplemental C-SCRM Guidance: Within the C-SCRM context, publicly accessible content may include Requests for Information, Requests for Proposal, or information about delivery of systems and components. This information should be reviewed to ensure that only appropriate content is released for public consumption, whether alone or with other information. 
<br><br>Level(s): 2, 3', N'Access Control', N'Publicly Accessible Content', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3921, N'AC-23', N'Employ [Assignment: organization-defined data mining prevention and detection techniques] for [Assignment: organization-defined data storage objects] to detect and protect against unauthorized data mining.', N'Supplemental C-SCRM Guidance: Enterprises should require their prime contractors to implement this control as part of their insider threat activities and flow down this requirement to relevant sub-tier contractors. 
<br><br>Level(s): 2, 3', N'Access Control', N'Data Mining Protection', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3922, N'AC-24', N'[Selection: Establish procedures; Implement mechanisms] to ensure [Assignment: organization-defined access control decisions] are applied to each access request prior to access enforcement.', N'Supplemental C-SCRM Guidance: Enterprises should assign access control decisions to support authorized access to the supply chain. Ensure that if a system integrator or external service provider is used, there is consistency in access control decision requirements and how the requirements are implemented. This may require defining such requirements in service-level agreements, in many cases as part of the upfront relationship established between the enterprise and system integrator or the enterprise and external service provider. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. 
<br><br>Level(s): 1, 2, 3', N'Access Control', N'Access Control Decisions', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 4, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3923, N'AT-1', N'<ol type="a">
    <li>Develop, document, and disseminate to [Assignment: organization-defined personnel or roles]:
        <ol>
            <li>[Selection (one or more): Organization-level; Mission/business process-level; System-level] awareness and training policy that:
                <ol type="a">
                    <li>Addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and</li>
                    <li>Is consistent with applicable laws, executive orders, directives, regulations, policies, standards, and guidelines; and</li>
                </ol>
            </li>
            <li>Procedures to facilitate the implementation of the awareness and training policy and the associated awareness and training controls;</li>
        </ol>
    </li>
    <li>Designate an [Assignment: organization-defined official] to manage the development, documentation, and dissemination of the awareness and training policy and procedures; and</li>
    <li>Review and update the current awareness and training:
        <ol>
            <li>Policy [Assignment: organization-defined frequency] and following [Assignment: organization-defined events]; and</li>
            <li>Procedures [Assignment: organization-defined frequency] and following [Assignment: organization-defined events].</li>
        </ol>
    </li>
</ol>', N'<p>Supplemental C-SCRM Guidance: Enterprises should designate a specific official to manage the development, documentation, and dissemination of the training policy and procedures, including C-SCRM and role-based specific training for those with supply ch', N'Awareness and Training', N'Awareness and Training Policy and Procedures', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 63, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3924, N'AT-2(1)', N'Provide practical exercises in literacy training that simulate events and incidents.', N'Supplemental C-SCRM Guidance: Enterprises should provide practical exercises in literacy training that simulate supply chain cybersecurity events and incidents. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-level contractors.', N'Awareness and Training', N'Literacy Training and Awareness', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 63, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3925, N'AT-2(2)', N'Provide literacy training on recognizing and reporting potential indicators of insider threat.', N'Supplemental C-SCRM Guidance: Enterprises should provide literacy training on recognizing and reporting potential indicators of insider threat within the supply chain. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors.', N'Awareness and Training', N'Literacy Training and Awareness', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 63, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3926, N'AT-2(3)', N'Provide literacy training on recognizing and reporting potential and actual instances of
social engineering and social mining.', N'Supplemental C-SCRM Guidance: Enterprises should provide literacy training on recognizing and reporting potential and actual instances of supply chain-related social engineering and social mining. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-level contractors.', N'Awareness and Training', N'Literacy Training and Awareness', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 63, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3927, N'AT-2(4)', N'Provide literacy training on recognizing suspicious communications and anomalous
behavior in organizational systems using [Assignment: organization-defined indicators of malicious code].', N'Supplemental C-SCRM Guidance: Provide literacy training on recognizing suspicious communications or anomalous behavior in enterprise supply chain systems. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-level contractors.', N'Awareness and Training', N'Literacy Training and Awareness', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 63, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3928, N'AT-2(5)', N'Provide literacy training on the advanced persistent threat.', N'Supplemental C-SCRM Guidance: Provide literacy training on recognizing suspicious communications on an advanced persistent threat (APT) in the enterprise’s supply chain. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-level contractors.', N'Awareness and Training', N'Literacy Training and Awareness', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 63, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3929, N'AT-2(6)', N'<ol type="a">
    <li>Provide literacy training on the cyber threat environment; and</li>
    <li>Reflect current cyber threat information in system operations.</li>
</ol>', N'Supplemental C-SCRM Guidance: Provide literacy training on cyber threats specific to the enterprise’s supply chain environment. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-level contractors.', N'Awareness and Training', N'Literacy Training and Awareness', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 63, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3930, N'AT-3', N'<ol type="a">
    <li>Provide role-based security and privacy training to personnel with the following roles and responsibilities: [Assignment: organization-defined roles and responsibilities]:
        <ol>
            <li>Before authorizing access to the system, information, or performing assigned duties, and [Assignment: organization-defined frequency] thereafter; and</li>
            <li>When required by system changes;</li>
        </ol>
    </li>
    <li>Update role-based training content [Assignment: organization-defined frequency] and following [Assignment: organization-defined events]; and</li>
    <li>Incorporate lessons learned from internal or external security incidents or breaches into role-based training.</li>
</ol>', N'Supplemental C-SCRM Guidance: Addressing cyber supply chain risks throughout the acquisition process is essential to performing C-SCRM effectively. Personnel who are part of the acquisition workforce require training on what C-SCRM requirements, clauses, and evaluation factors are necessary to include when conducting procurement and how to incorporate C-SCRM into each acquisition phase. Similar enhanced training requirements should be tailored for personnel responsible for conducting threat assessments. Responding to threats and identified risks requires training in counterintelligence awareness and reporting. Enterprises should ensure that developers receive training on secure development practices as well as the use of vulnerability scanning tools. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.', N'Awareness and Training', N'Role-Based Training', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 63, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3931, N'AT-3(2)', N'Provide [Assignment: organization-defined personnel or roles] with initial and
[Assignment: organization-defined frequency] training in the employment and operation
of physical security controls.', N'Supplemental C-SCRM Guidance: C-SCRM is impacted by a number of physical security mechanisms and procedures within the supply chain, such as manufacturing, shipping, receiving, physical access to facilities, inventory management, and warehousing. Enterprise and system integrator personnel who provide development and operational support to the enterprise should receive training on how to handle these physical security mechanisms and on the associated cybersecurity risks throughout the supply chain. 
<br><br>Level(s): 2', N'Awareness and Training', N'Role-Based Training', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 63, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3932, N'AT-4', N'<ol type="a">
    <li>Document and monitor information security and privacy training activities, including security and privacy awareness training and specific role-based security and privacy training; and</li>
    <li>Retain individual training records for [Assignment: organization-defined time period].</li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises should maintain documentation for CSCRM-specific training, especially with regard to key personnel in acquisitions and counterintelligence.
<br><br>Level(s): 2', N'Awareness and Training', N'Training Records', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 63, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3933, N'AU-1', N'<ol type="a">
    <li>Develop, document, and disseminate to [Assignment: organization-defined personnel or roles]:
        <ol>
            <li>[Selection (one or more): Organization-level; Mission/business process-level; System-level] audit and accountability policy that:
                <ol type="a">
                    <li>Addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and</li>
                    <li>Is consistent with applicable laws, executive orders, directives, regulations, policies, standards, and guidelines; and</li>
                </ol>
            </li>
            <li>Procedures to facilitate the implementation of the audit and accountability policy and the associated audit and accountability controls;</li>
        </ol>
    </li>
    <li>Designate an [Assignment: organization-defined official] to manage the development, documentation, and dissemination of the audit and accountability policy and procedures; and</li>
    <li>Review and update the current audit and accountability:
        <ol>
            <li>Policy [Assignment: organization-defined frequency] and following [Assignment: organization-defined events]; and</li>
            <li>Procedures [Assignment: organization-defined frequency] and following [Assignment: organization-defined events].</li>
        </ol>
    </li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises must designate a specific official to manage the development, documentation, and dissemination of the audit and accountability policy and procedures to include auditing of the supply chain information systems and network. The audit and accountability policy and procedures should appropriately address tracking activities and their availability for other various supply chain activities, such as configuration management. Suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers activities should not be included in such a policy unless those functions are performed within the acquirer’s supply chain information systems and network. Audit and accountability policy procedures should appropriately address supplier audits as a way to examine the quality of a particular supplier and the risk they present to the enterprise and the enterprise’s supply chain. 
<br><br>Level(s): 1, 2, 3', N'Audit and Accountability', N'Audit and Accountability Policy and Procedures', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 6, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3934, N'AU-2', N'<ol type="a">
    <li>Identify the types of events that the system is capable of logging in support of the audit function: [Assignment: organization-defined event types that the system is capable of logging];</li>
    <li>Coordinate the event logging function with other organizational entities requiring audit-related information to guide and inform the selection criteria for events to be logged;</li>
    <li>Specify the following event types for logging within the system: [Assignment: organization-defined event types (subset of the event types defined in AU-2a.) along with the frequency of (or situation requiring) logging for each identified event type];</li>
    <li>Provide a rationale for why the event types selected for logging are deemed to be adequate to support after-the-fact investigations of incidents; and</li>
    <li>Review and update the event types selected for logging [Assignment: organization-defined frequency].</li>
</ol>', N'Supplemental C-SCRM Guidance: An observable occurrence within the information system or supply chain network should be identified as a supply chain auditable event based on the enterprise’s SDLC context and requirements. Auditable events may include software/hardware changes, failed attempts to access supply chain information systems, or the movement of source code. Information on such events should be captured by appropriate audit mechanisms and be traceable and verifiable. Information captured may include the type of event, date/time, length, and the frequency of occurrence. Among other things, auditing may help detect misuse of the supply chain information systems or network caused by insider threats. Logs are a key resource when identifying operational trends and long-term problems. As such, enterprises should incorporate reviewing logs at the contract renewal point for vendors to determine whether there is a systemic problem. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.
<br><br>Level(s): 1, 2, 3', N'Audit and Accountability', N'Event Logging', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 6, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3935, N'AU-3', N'<p>Ensure that audit records contain information that establishes the following:</p>
<ol type="a">
    <li>What type of event occurred;</li>
    <li>When the event occurred;</li>
    <li>Where the event occurred;</li>
    <li>Source of the event;</li>
    <li>Outcome of the event; and</li>
    <li>Identity of any individuals, subjects, or objects/entities associated with the event.</li>
</ol>', N'Supplemental C-SCRM Guidance: The audit records of a supply chain event should be securely handled and maintained in a manner that conforms to record retention requirements and preserves the integrity of the findings and the confidentiality of the record information and its sources as appropriate. In certain instances, such records may be used in administrative or legal proceedings. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity. 
<br><br>Level(s): 1, 2, 3', N'Audit and Accountability', N'Content of Audit Records', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 6, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3936, N'AU-6', N'<ol type="a">
    <li>Review and analyze system audit records [Assignment: organization-defined frequency] for indications of [Assignment: organization-defined inappropriate or unusual activity] and the potential impact of the inappropriate or unusual activity;</li>
    <li>Report findings to [Assignment: organization-defined personnel or roles]; and</li>
    <li>Adjust the level of audit record review, analysis, and reporting within the system when there is a change in risk based on law enforcement information, intelligence information, or other credible sources of information.</li>
</ol>', N'Supplemental C-SCRM Guidance: The enterprise should ensure that both supply chain and information security auditable events are appropriately filtered and correlated for analysis and reporting. For example, if new maintenance or a patch upgrade is recognized to have an invalid digital signature, the identification of the patch arrival qualifies as a supply chain auditable event, while an invalid signature is an information security auditable event. The combination of these two events may provide information valuable to C-SCRM. The enterprise should adjust the level of audit record review based on the risk changes (e.g., active threat intel, risk profile) on a specific vendor. Contracts should explicitly address how audit findings will be reported and adjudicated. 
<br><br>Level(s): 2, 3', N'Audit and Accountability', N'Audit Record Review, Analysis, and Reporting', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 6, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3937, N'AU-6(9)', N'Correlate information from nontechnical sources with audit record information to enhance
organization-wide situational awareness.', N'Supplemental C-SCRM Guidance: In a C-SCRM context, non-technical sources include changes to the enterprise’s security or operational policy, changes to the procurement or contracting processes, and notifications from suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers regarding plans to update, enhance, patch, or retire/dispose of a system/component. 
<br><br>Level(s): 3', N'Audit and Accountability', N'Audit Record Review, Analysis, and Reporting', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 6, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3938, N'AU-10', N'Provide irrefutable evidence that an individual (or process acting on behalf of an individual) has performed [Assignment: organization-defined actions to be covered by non-repudiation].', N'Supplemental C-SCRM Guidance: Enterprises should implement non-repudiation techniques to protect the originality and integrity of both information systems and the supply chain network. Examples of what may require non-repudiation include supply chain metadata that describes the components, supply chain communication, and delivery acceptance information. For information systems, examples may include patch or maintenance upgrades for software as well as component replacements in a large hardware system. Verifying that such components originate from the OEM is part of non-repudiation. 
<br><br>Level(s): 3', N'Audit and Accountability', N'Non-Repudiation', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 6, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3939, N'AU-10(1)', N'<ol type="a">
    <li>Bind the identity of the information producer with the information to [Assignment: organization-defined strength of binding]; and</li>
    <li>Provide the means for authorized individuals to determine the identity of the producer of the information.</li>
</ol>', N'Supplemental C-SCRM Guidance: This enhancement helps traceability in the supply chain and facilitates the accuracy of provenance.
<br><br>Level(s): 2', N'Audit and Accountability', N'Non-Repudiation', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 6, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3940, N'AU-10(2)', N'<ol type="a">
    <li>Validate the binding of the information producer identity to the information at [Assignment: organization-defined frequency]; and</li>
    <li>Perform [Assignment: organization-defined actions] in the event of a validation error.</li>
</ol>', N'Supplemental C-SCRM Guidance: This enhancement validates the relationship of provenance and a component within the supply chain. Therefore, it ensures integrity of provenance. 
<br><br>Level(s): 2, 3', N'Audit and Accountability', N'Non-Repudiation', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 6, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3941, N'AU-10(3)', N'Maintain reviewer or releaser credentials within the established chain of custody for
information reviewed or released.', N'Supplemental C-SCRM Guidance: Chain of custody is fundamental to provenance and traceability in the supply chain. It also helps the verification of system and component integrity. 
<br><br>Level(s): 2, 3', N'Audit and Accountability', N'Non-Repudiation', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 6, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3942, N'AU-12', N'<ol type="a">
    <li>Provide audit record generation capability for the event types the system is capable of auditing as defined in AU-2a on [Assignment: organization-defined system components];</li>
    <li>Allow [Assignment: organization-defined personnel or roles] to select the event types that are to be logged by specific components of the system; and</li>
    <li>Generate audit records for the event types defined in AU-2c that include the audit record content defined in AU-3.</li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises should ensure that audit record generation mechanisms are in place to capture all relevant supply chain auditable events. Examples of such events include component version updates, component approvals from acceptance testing results, logistics data-capturing inventory, or transportation information. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity. Level(s): 2, 3', N'Audit and Accountability', N'Audit Record Generation', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 6, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3943, N'AU-13', N'<ol type="a">
    <li>Monitor [Assignment: organization-defined open-source information and/or information sites] [Assignment: organization-defined frequency] for evidence of unauthorized disclosure of organizational information; and</li>
    <li>If an information disclosure is discovered:
        <ol>
            <li>Notify [Assignment: organization-defined personnel or roles]; and</li>
            <li>Take the following additional actions: [Assignment: organization-defined additional actions].</li>
        </ol>
    </li>
</ol>', N'Supplemental C-SCRM Guidance: Within the C-SCRM context, information disclosure may occur via multiple avenues, including open source information. For example, supplier-provided errata may reveal information about an enterprise’s system that increases the risk to that system. Enterprises should ensure that monitoring is in place for contractor systems to detect the unauthorized disclosure of any data and that contract language includes a requirement that the vendor will notify the enterprise, in accordance with enterprise-defined time frames and as soon as possible in the event of any potential or actual unauthorized disclosure. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant subtier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity. 
<br><br>Level(s): 2, 3', N'Audit and Accountability', N'Monitoring for Information Disclosure', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 6, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3944, N'AU-14', N'<ol type="a">
    <li>Provide and implement the capability for [Assignment: organization-defined users or roles] to [Selection (one or more): record; view; hear; log] the content of a user session under [Assignment: organization-defined circumstances]; and</li>
    <li>Develop, integrate, and use session auditing activities in consultation with legal counsel and in accordance with applicable laws, executive orders, directives, regulations, policies, standards, and guidelines.</li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises should include non-federal contract employees in session audits to identify security risks in the supply chain. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity. 
<br><br>Level(s): 2, 3', N'Audit and Accountability', N'Session Audit', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 6, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3945, N'AU-16', N'Employ [Assignment: organization-defined methods] for coordinating [Assignment: organization-defined audit information] among external organizations when audit information is transmitted across organizational boundaries.', N'Supplemental C-SCRM Guidance: In a C-SCRM context, this control includes the enterprise’s use of system integrator or external service provider infrastructure. Enterprises should add language to contracts on coordinating audit information requirements and information exchange agreements with vendors. 
<br><br>Level(s): 2, 3', N'Audit and Accountability', N'Cross-Organizational Audit Logging', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 6, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3946, N'AU-16(2)', N'Provide cross-organizational audit information to [Assignment: organization-defined organizations] based on [Assignment: organization-defined cross-organizational sharing agreements].', N'Supplemental C-SCRM Guidance: Whether managing a distributed audit environment or an audit data-sharing environment between enterprises and its system integrators or external services providers, enterprises should establish a set of requirements for the process of sharing audit information. In the case of the system integrator and external service provider and the enterprise, a service-level agreement of the type of audit data required versus what can be provided must be agreed to in advance to ensure that the enterprise obtains the relevant audit information needed to ensure that appropriate protections are in place to meet its mission operation protection needs. Ensure that coverage of both the information systems and supply chain network are addressed for the collection and sharing of audit information. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-level contractors.
<br><br>Level(s): 2, 3', N'Audit and Accountability', N'Cross-Organizational Audit Logging', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 6, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3947, N'CA-1', N'<ol type="a">
    <li>Develop, document, and disseminate to [Assignment: organization-defined personnel or roles]:
        <ol>
            <li>[Selection (one or more): Organization-level; Mission/business process-level; System-level] assessment, authorization, and monitoring policy that:
                <ol type="a">
                    <li>Addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and</li>
                    <li>Is consistent with applicable laws, executive orders, directives, regulations, policies, standards, and guidelines; and</li>
                </ol>
            </li>
            <li>Procedures to facilitate the implementation of the assessment, authorization, and monitoring policy and the associated assessment, authorization, and monitoring controls;</li>
        </ol>
    </li>
    <li>Designate an [Assignment: organization-defined official] to manage the development, documentation, and dissemination of the assessment, authorization, and monitoring policy and procedures; and</li>
    <li>Review and update the current assessment, authorization, and monitoring:
        <ol>
            <li>Policy [Assignment: organization-defined frequency] and following [Assignment: organization-defined events]; and</li>
            <li>Procedures [Assignment: organization-defined frequency] and following [Assignment: organization-defined events].</li>
        </ol>
    </li>
</ol>', N'Supplemental C- SCRM Guidance: Integrate the development and implementation of assessment and authorization policies and procedures for supply chain cybersecurity into the control assessment and authorization policy and related C-SCRM Strategy/Implementation Plan(s), policies, and system-level plans. To address cybersecurity risks throughout the supply chain, enterprises should develop a C-SCRM policy (or, if required, integrate into existing policies) to direct C-SCRM activities for control assessment and authorization. The C-SCRM policy should define C-SCRM roles and responsibilities within the enterprise for conducting control assessment and authorization, any dependencies among those roles, and the interaction among the roles. Enterprise-wide security and privacy risks should be assessed on an ongoing basis and include supply chain risk assessment results.
<br><br>Level(s): 1, 2, 3', N'Security Assessment and Authorization', N'Assessment, Authorization, and Monitoring Policy and Procedures', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 71, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3948, N'CA-2', N'<ol type="a">
    <li>Select the appropriate assessor or assessment team for the type of assessment to be conducted;</li>
    <li>Develop a control assessment plan that describes the scope of the assessment including:
        <ol>
            <li>Controls and control enhancements under assessment;</li>
            <li>Assessment procedures to be used to determine control effectiveness; and</li>
            <li>Assessment environment, assessment team, and assessment roles and responsibilities;</li>
        </ol>
    </li>
    <li>Ensure the control assessment plan is reviewed and approved by the authorizing official or designated representative prior to conducting the assessment;</li>
    <li>Assess the controls in the system and its environment of operation [Assignment: organization-defined frequency] to determine the extent to which the controls are implemented correctly, operating as intended, and producing the desired outcome with respect to meeting established security and privacy requirements;</li>
    <li>Produce a control assessment report that documents the results of the assessment; and</li>
    <li>Provide the results of the control assessment to [Assignment: organization-defined individuals or roles].</li>
</ol>', N'Supplemental C-SCRM Guidance: Ensure that the control assessment plan incorporates relevant C-SCRM controls and control enhancements. The control assessment should cover the assessment of both information systems and the supply chain and ensure that an enterprise-relevant baseline set of controls and control enhancements are identified and used for the assessment. Control assessments can include information from supplier audits, reviews, and supply chain-related information. Enterprises should develop a strategy for collecting information, including a strategy for engaging with providers on supply chain risk assessments. Such collaboration helps enterprises leverage information from providers, reduce redundancy, identify potential courses of action for risk responses, and reduce the burden on providers. C-SCRM personnel should review the control assessment. 
<br><br>Level(s): 2, 3', N'Security Assessment and Authorization', N'Control Assessments', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 71, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3949, N'CA-2(2)', N'Include as part of control assessments, [Assignment: organization-defined frequency],
[Selection: announced; unannounced], [Selection (one or more): in-depth monitoring; security instrumentation; automated security test cases; vulnerability scanning; malicious user testing; insider threat assessment; performance and load testing; data leakage or data loss assessment; [Assignment: organization-defined other forms of assessment]].', N'', N'Security Assessment and Authorization', N'Control Assessments', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 71, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3950, N'CA-2(3)', N'Leverage the results of control assessments performed by [Assignment: organization-defined external organization] on [Assignment: organization-defined system] when the
assessment meets [Assignment: organization-defined requirements].', N'Supplemental C-SCRM Guidance: Enterprises should use a variety of assessment techniques and methodologies, such as continuous monitoring, insider threat assessment, and malicious user assessment. These assessment mechanisms are context-specific and require the enterprise to understand its supply chain and to define the required set of measures for assessing and verifying that appropriate protections have been implemented. 
<br><br>Level(s): 3', N'Security Assessment and Authorization', N'Control Assessments', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 71, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3951, N'CA-3', N'<ol type="a">
    <li>Approve and manage the exchange of information between the system and other systems using [Selection (one or more): interconnection security agreements; information exchange security agreements; memoranda of understanding or agreement; service level agreements; user agreements; nondisclosure agreements; [Assignment: organization-defined type of agreement]];</li>
    <li>Document, as part of each exchange agreement, the interface characteristics, security and privacy requirements, controls, and responsibilities for each system, and the impact level of the information communicated; and</li>
    <li>Review and update the agreements [Assignment: organization-defined frequency].</li>
</ol>', N'<p>Supplemental C-SCRM Guidance: The exchange of information or data between the system and other systems requires scrutiny from a supply chain perspective. This includes understanding the interface characteristics and connections of those components/syst', N'Security Assessment and Authorization', N'Information Exchange', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 71, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3952, N'CA-5', N'<ol type="a">
    <li>Develop a plan of action and milestones for the system to document the planned remediation actions of the organization to correct weaknesses or deficiencies noted during the assessment of the controls and to reduce or eliminate known vulnerabilities in the system; and</li>
    <li>Update existing plan of action and milestones [Assignment: organization-defined frequency] based on the findings from control assessments, independent audits or reviews, and continuous monitoring activities.</li>
</ol>', N'Supplemental C-SCRM Guidance: For a system-level plan of actions and milestones (POA&Ms), enterprises need to ensure that a separate POA&M exists for C-SCRM and includes both information systems and the supply chain. The C-SCRM POA&M should include tasks to be accomplished with a recommendation for completion before or after system authorization, the resources required to accomplish the tasks, milestones established to meet the tasks, and the scheduled completion dates for the milestones and tasks. The enterprise should include relevant weaknesses, the impact of weaknesses on information systems or the supply chain, any remediation to address weaknesses, and any continuous monitoring activities in its C-SCRM POA&M. The C-SCRM POA&M should be included as part of the authorization package. 
<br><br>Level(s): 2, 3', N'Security Assessment and Authorization', N'Plan of Action and Milestones', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 71, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3953, N'CA-6', N'<ol type="a">
    <li>Assign a senior official as the authorizing official for the system;</li>
    <li>Assign a senior official as the authorizing official for common controls available for inheritance by organizational systems;</li>
    <li>Ensure that the authorizing official for the system, before commencing operations:
        <ol>
            <li>Accepts the use of common controls inherited by the system; and</li>
            <li>Authorizes the system to operate;</li>
        </ol>
    </li>
    <li>Ensure that the authorizing official for common controls authorizes the use of those controls for inheritance by organizational systems;</li>
    <li>Update the authorizations [Assignment: organization-defined frequency].</li>
</ol>', N'Supplemental C-SCRM Guidance: Authorizing officials should include C-SCRM in authorization decisions. To accomplish this, supply chain risks and compensating controls documented in C-SCRM Plans or system security plans and the C-SCRM POA&M should be included in the authorization package as part of the decision-making process. Risks should be determined and associated compensating controls selected based on the output of criticality, threat, and vulnerability analyses. Authorizing officials may use the guidance in Section 2 of this document as well as NIST IR 8179 to guide the assessment process. 
<br><br>Level(s): 1, 2, 3', N'Security Assessment and Authorization', N'Authorization', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 71, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3954, N'CA-7(3)', N'Employ trend analyses to determine if control implementations, the frequency of
continuous monitoring activities, and the types of activities used in the continuous
monitoring process need to be modified based on empirical data.', N'Supplemental C-SCRM Guidance: The information gathered during continuous monitoring/trend analyses serves as input into C-SCRM decisions, including criticality analysis, vulnerability and threat analysis, and risk assessments. It also provides information that can be used in incident response and potentially identify a supply chain cybersecurity compromise, including an insider threat. 
<br><br>Level(s): 3', N'Security Assessment and Authorization', N'Continuous Monitoring', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 71, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3955, N'CM-1', N'<ol type="a">
    <li>Develop, document, and disseminate to [Assignment: organization-defined personnel or roles]:
        <ol>
            <li>[Selection (one or more): Organization-level; Mission/business process-level; System-level] configuration management policy that:
                <ol type="a">
                    <li>Addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and</li>
                    <li>Is consistent with applicable laws, executive orders, directives, regulations, policies, standards, and guidelines; and</li>
                </ol>
            </li>
            <li>Procedures to facilitate the implementation of the configuration management policy and the associated configuration management controls;</li>
        </ol>
    </li>
    <li>Designate an [Assignment: organization-defined official] to manage the development, documentation, and dissemination of the configuration management policy and procedures; and</li>
    <li>Review and update the current configuration management:
        <ol>
            <li>Policy [Assignment: organization-defined frequency] and following [Assignment: organization-defined events]; and</li>
            <li>Procedures [Assignment: organization-defined frequency] and following [Assignment: organization-defined events].</li>
        </ol>
    </li>
</ol>', N'Supplemental C-SCRM Guidance: Configuration management impacts nearly every aspect of the supply chain. Configuration management is critical to the enterprise’s ability to establish the provenance of components, including tracking and tracing them through the SDLC and the supply chain. A properly defined and implemented configuration management capability provides greater assurance throughout the SDLC and the supply chain that components are authentic and have not been inappropriately modified. When defining a configuration management policy and procedures, enterprises should address the full SDLC, including procedures for introducing and removing components to and from the enterprise’s information system boundary. A configuration management policy should incorporate configuration items, data retention for configuration items and corresponding metadata, and tracking of the configuration item and its metadata. The enterprise should coordinate with suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers regarding the configuration management policy.
<br><br>Level(s): 1, 2, 3', N'Configuration Management', N'Configuration Management Policy and Procedures', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3956, N'CM-2', N'<ol type="a">
    <li>Develop, document, and maintain under configuration control, a current baseline configuration of the system; and</li>
    <li>Review and update the baseline configuration of the system:
        <ol>
            <li>[Assignment: organization-defined frequency];</li>
            <li>When required due to [Assignment: organization-defined circumstances]; and</li>
            <li>When system components are installed or upgraded.</li>
        </ol>
    </li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises should establish a baseline configuration of both the information system and the development environment, including documenting, formally reviewing, and securing the agreement of stakeholders. The purpose of the baseline is to provide a starting point for tracking changes to components, code, and/or settings throughout the SDLC. Regular reviews and updates of baseline configurations (i.e., re-baselining) are critical for traceability and provenance. The baseline configuration must take into consideration the enterprise’s operational environment and any relevant supplier, developer, system integrator, external system service provider, and other ICT/OT-related service provider involvement with the organization’s information systems and networks. If the system integrator, for example, uses the existing organization’s infrastructure, appropriate measures should be taken to establish a baseline that reflects an appropriate set of agreed-upon criteria for access and operation. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.
<br><br>Level(s): 2, 3', N'Configuration Management', N'Baseline Configuration', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3957, N'CM-2(6)', N'Maintain a baseline configuration for system development and test environments that is
managed separately from the operational baseline configuration.', N'Supplemental C-SCRM Guidance: The enterprise should maintain or require the maintenance of a baseline configuration of applicable suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers’ development, test (and staging, if applicable) environments, and any configuration of interfaces.
<br><br>Level(s): 2, 3', N'Configuration Management', N'Baseline Configuration', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3958, N'CM-3', N'<ol type="a">
    <li>Determine and document the types of changes to the system that are configuration-controlled;</li>
    <li>Review proposed configuration-controlled changes to the system and approve or disapprove such changes with explicit consideration for security and privacy impact analyses;</li>
    <li>Document configuration change decisions associated with the system;</li>
    <li>Implement approved configuration-controlled changes to the system;</li>
    <li>Retain records of configuration-controlled changes to the system for [Assignment: organization-defined time period];</li>
    <li>Monitor and review activities associated with configuration-controlled changes to the system; and</li>
    <li>Coordinate and provide oversight for configuration change control activities through [Assignment: organization-defined configuration change control element] that convenes [Selection (one or more): [Assignment: organization-defined frequency]; when [Assignment: organization-defined configuration change conditions]].</li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises should determine, implement, monitor, and audit configuration settings and change controls within the information systems and networks and throughout the SDLC. This control supports traceability for C-SCRM. The below NIST SP 800-53, Rev. 5 control enhancements – CM-3 (1), (2), (4), and (8) – are mechanisms that can be used for C-SCRM to collect and manage change control data. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.
<br><br>Level(s): 2, 3', N'Configuration Management', N'Configuration Change Control', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3959, N'CM-3(1)', N'<p>Use [Assignment: organization-defined automated mechanisms] to:</p>
<ol type="a">
    <li>Document proposed changes to the system;</li>
    <li>Notify [Assignment: organization-defined approval authorities] of proposed changes to the system and request change approval;</li>
    <li>Highlight proposed changes to the system that have not been approved or disapproved within [Assignment: organization-defined time period];</li>
    <li>Prohibit changes to the system until designated approvals are received;</li>
    <li>Document all changes to the system; and</li>
    <li>Notify [Assignment: organization-defined personnel] when approved changes to the system are completed.</li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises should define a set of system changes that are critical to the protection of the information system and the underlying or interoperating systems and networks. These changes may be defined based on a criticality analysis (including components, processes, and functions) and where vulnerabilities exist that are not yet remediated (e.g., due to resource constraints). The change control process should also monitor for changes that may affect an existing security control to ensure that this control continues to function as required.
<br><br>Level(s): 2, 3', N'Configuration Management', N'Configuration Change Control', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3960, N'CM-3(2)', N'Test, validate, and document changes to the system before finalizing the implementation
of the changes.', N'Supplemental C-SCRM Guidance: Test, validate, and document changes to the system before finalizing implementation of the changes. 
<br><br>Level(s): 2, 3', N'Configuration Management', N'Configuration Change Control', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3961, N'CM-3(4)', N'Require [Assignment: organization-defined security and privacy representatives] to be
members of the [Assignment: organization-defined configuration change control element].', N'Supplemental C-SCRM Guidance: Require enterprise security and privacy representatives to be members of the configuration change control function.
<br><br>Level(s): 2, 3', N'Configuration Management', N'Configuration Change Control', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3962, N'CM-3(8)', N'Prevent or restrict changes to the configuration of the system under the following
circumstances: [Assignment: organization-defined circumstances].', N'Supplemental C-SCRM Guidance: Prevent or restrict changes to the configuration of the system under enterprise-defined circumstances. 
<br><br>Level(s): 2, 3', N'Configuration Management', N'Configuration Change Control', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3963, N'CM-4', N'Analyze changes to the system to determine potential security and privacy impacts
prior to change implementation.', N'Supplemental C-SCRM Guidance: Enterprises should take changes to the information system and underlying or interoperable systems and networks under consideration to determine whether the impact of these changes affects existing security controls and warrants additional or different protection to maintain an acceptable level of cybersecurity risk throughout the supply chain. Ensure that stakeholders, such as system engineers and system security engineers, are included in the impact analysis activities to provide their perspectives for C-SCRM. NIST SP 800-53, Rev. 5 control enhancement CM4 (1) is a mechanism that can be used to protect the information system from vulnerabilities that may be introduced through the test environment. 
<br><br>Level(s): 3', N'Configuration Management', N'Impact Analyses', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3964, N'CM-4(1)', N'Analyze changes to the system in a separate test environment before implementation in
an operational environment, looking for security and privacy impacts due to flaws,
weaknesses, incompatibility, or intentional malice.', N'Analyze changes to the system in a separate test environment before implementing them into an operational environment, and look for security and privacy impacts due to flaws, weaknesses, incompatibility, or intentional malice.

<br><br>Level(s): 3

Related Control(s): SA-11, SC-7', N'Configuration Management', N'Impact Analyses', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3965, N'CM-5', N'Define, document, approve, and enforce physical and logical access restrictions
associated with changes to the system.', N'Supplemental C-SCRM Guidance: Enterprises should ensure that requirements regarding physical and logical access restrictions for changes to the information systems and networks are defined and included in the enterprise’s implementation of access restrictions. Examples include access restriction for changes to centrally managed processes for software component updates and the deployment of updates or patches. 
<br><br>Level(s): 2, 3', N'Configuration Management', N'Access Restrictions for Change', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3966, N'CM-5(1)', N'<ol type="a">
    <li>Enforce access restrictions using [Assignment: organization-defined automated mechanisms]; and</li>
    <li>Automatically generate audit records of the enforcement actions.</li>
</ol>', N'', N'Configuration Management', N'Access Restrictions for Change', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3967, N'CM-5(6)', N'Limit privileges to change software resident within software libraries.', N'Supplemental C-SCRM Guidance: Enterprises should note that software libraries may be considered configuration items, access to which should be managed and controlled.
<br><br>Level(s): 3', N'Configuration Management', N'Access Restrictions for Change', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3968, N'CM-6', N'<ol type="a">
    <li>Establish and document configuration settings for components employed within the system that reflect the most restrictive mode consistent with operational requirements using [Assignment: organization-defined common secure configurations];</li>
    <li>Implement the configuration settings;</li>
    <li>Identify, document, and approve any deviations from established configuration settings for [Assignment: organization-defined system components] based on [Assignment: organization-defined operational requirements]; and</li>
    <li>Monitor and control changes to the configuration settings in accordance with organizational policies and procedures.</li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises should oversee the function of modifying configuration settings for their information systems and networks and throughout the SDLC. Methods of oversight include periodic verification, reporting, and review. Resulting information may be shared with various parties that have access to, are connected to, or engage in the creation of the enterprise’s information systems and networks on a need-to-know basis. Changes should be tested and approved before they are implemented. Configuration settings should be monitored and audited to alert designated enterprise personnel when a change has occurred. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity. 
<br><br>Level(s): 2, 3', N'Configuration Management', N'Configuration Settings', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3969, N'CM-6(1)', N'Manage, apply, and verify configuration settings for [Assignment: organization-defined system components] using [Assignment: organization-defined automated mechanisms].', N'Supplemental C-SCRM Guidance: The enterprise should, when feasible, employ automated mechanisms to manage, apply, and verify configuration settings. 
<br><br>Level(s): 3', N'Configuration Management', N'Configuration Settings', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3970, N'CM-6(2)', N'Take the following actions in response to unauthorized changes to [Assignment: organization-defined configuration settings]: [Assignment: organization-defined actions].', N'Supplemental C-SCRM Guidance: The enterprise should ensure that designated security or IT personnel are alerted to unauthorized changes to configuration settings. When suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers are responsible for such unauthorized changes, this qualifies as a C-SCRM incident that should be recorded and tracked to monitor trends. For a more comprehensive view, a specific, predefined set of C-SCRM stakeholders should assess the impact of unauthorized changes in the supply chain. When impact is assessed, relevant stakeholders should help define and implement appropriate mitigation strategies to ensure a comprehensive resolution. 
<br><br>Level(s): 3', N'Configuration Management', N'Configuration Settings', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3971, N'CM-7', N'<ol type="a">
    <li>Configure the system to provide only [Assignment: organization-defined mission essential capabilities]; and</li>
    <li>Prohibit or restrict the use of the following functions, ports, protocols, software, and/or services: [Assignment: organization-defined prohibited or restricted functions, system ports, protocols, software, and/or services].</li>
</ol>', N'Supplemental C-SCRM Guidance: Least functionality reduces the attack surface. Enterprises should select components that allow the flexibility to specify and implement least functionality. Enterprises should ensure least functionality in their information systems and networks and throughout the SDLC. NIST SP 800-53, Rev. 5 control enhancement CM-7 (9) mechanism can be used to protect information systems and networks from vulnerabilities that may be introduced by the use of unauthorized hardware being connected to enterprise systems. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant subtier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.
<br><br>Level(s): 3', N'Configuration Management', N'Least Functionality', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3972, N'CM-7(1)', N'<ol type="a">
    <li>Review the system [Assignment: organization-defined frequency] to identify unnecessary and/or nonsecure functions, ports, protocols, software, and services; and</li>
    <li>Disable or remove [Assignment: organization-defined functions, ports, protocols, software, and services within the system deemed to be unnecessary and/or nonsecure].</li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors.
<br><br>Level(s): 2, 3', N'Configuration Management', N'Least Functionality', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3973, N'CM-7(4)', N'<ol type="a">
    <li>Identify [Assignment: organization-defined software programs not authorized to execute on the system];</li>
    <li>Employ an allow-all, deny-by-exception policy to prohibit the execution of unauthorized software programs on the system; and</li>
    <li>Review and update the list of unauthorized software programs [Assignment: organization-defined frequency].</li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises should define requirements and deploy appropriate processes to specify and detect software that is not allowed. This can be aided by defining a requirement to, at a minimum, not use disreputable or unauthorized software. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. 
<br><br>Level(s): 2, 3', N'Configuration Management', N'Least Functionality', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3974, N'CM-7(5)', N'<ol type="a">
    <li>Identify [Assignment: organization-defined software programs authorized to execute on the system];</li>
    <li>Employ a deny-all, permit-by-exception policy to allow the execution of authorized software programs on the system; and</li>
    <li>Review and update the list of authorized software programs [Assignment: organization-defined frequency].</li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises should define requirements and deploy appropriate processes to specify allowable software. This can be aided by defining a requirement to use only reputable software. This can also include requirements for alerts when new software and updates to software are introduced into the enterprise’s environment. An example of such requirements is to allow open source software only if the code is available for an enterprise’s evaluation and determined to be acceptable for use. 
<br><br>Level(s): 3', N'Configuration Management', N'Least Functionality', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3975, N'CM-7(6)', N'Require that the following user-installed software execute in a confined physical or virtual
machine environment with limited privileges: [Assignment: organization-defined user-installed software].', N'Supplemental C-SCRM Guidance: The enterprise should ensure that code authentication mechanisms such as digital signatures are implemented when executing code to assure the integrity of software, firmware, and information on the information systems and networks. 
<br><br>Level(s): 2, 3', N'Configuration Management', N'Least Functionality', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3976, N'CM-7(7)', N'<p>Allow execution of binary or machine-executable code only in confined physical or virtual machine environments and with the explicit approval of [Assignment: organization-defined personnel or roles] when such code is:</p>
<ol type="a">
    <li>Obtained from sources with limited or no warranty; and/or</li>
    <li>Without the provision of source code.</li>
</ol>', N'Supplemental C-SCRM Guidance: The enterprise should obtain binary or machine-executable code directly from the OEM/developer or other acceptable, verified source. 
<br><br>Level(s): 3', N'Configuration Management', N'Least Functionality', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3977, N'CM-7(8)', N'<ol type="a">
    <li>Prohibit the use of binary or machine-executable code from sources with limited or no warranty or without the provision of source code; and</li>
    <li>Allow exceptions only for compelling mission or operational requirements and with the approval of the authorizing official.</li>
</ol>', N'Supplemental C-SCRM Guidance: When exceptions are made to use software products without accompanying source code and with limited or no warranty because of compelling mission or operational requirements, approval by the authorizing official should be contingent upon the enterprise explicitly incorporating cybersecurity supply chain risk assessments as part of a broader assessment of such software products, as well as the implementation of compensating controls to address any identified and assessed risks. 
<br><br>Level(s): 2, 3', N'Configuration Management', N'Least Functionality', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3978, N'CM-7(9)', N'<ol type="a">
    <li>Identify [Assignment: organization-defined hardware components authorized for system use];</li>
    <li>Prohibit the use or connection of unauthorized hardware components;</li>
    <li>Review and update the list of authorized hardware components [Assignment: organization-defined frequency].</li>
</ol>', N'Enterprises should define requirements and deploy appropriate processes to specify and detect hardware that is not allowed. This can be aided by defining a requirement to, at a minimum, not use disreputable or unauthorized hardware. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. 
<br><br>Level(s): 2, 3', N'Configuration Management', N'Least Functionality', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3979, N'CM-8', N'<ol type="a">
    <li>Develop and document an inventory of system components that:
        <ol>
            <li>Accurately reflects the system;</li>
            <li>Includes all components within the system;</li>
            <li>Does not include duplicate accounting of components or components assigned to any other system;</li>
            <li>Is at the level of granularity deemed necessary for tracking and reporting; and</li>
            <li>Includes the following information to achieve system component accountability: [Assignment: organization-defined information deemed necessary to achieve effective system component accountability]; and</li>
        </ol>
    </li>
    <li>Review and update the system component inventory [Assignment: organization-defined frequency].</li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises should ensure that critical component assets within the information systems and networks are included in the asset inventory. The inventory must also include information for critical component accountability. Inventory information includes, for example, hardware inventory specifications, software license information, software version numbers, component owners, and – for networked components or devices – machine names and network addresses. Inventory specifications may include the manufacturer, device type, model, serial number, and physical location. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Enterprises should specify the requirements and how information flow is enforced to ensure that only the required information – and no more – is communicated to the various participants in the supply chain. If information is subsetted downstream, there should be information about who created the subset information. Enterprises should consider producing SBOMs for applicable and appropriate classes of software, including purchased software, open source software, and in-house software. Departments and agencies should refer to Appendix F for additional guidance on SBOMs in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity. 
<br><br>Level(s): 2, 3', N'Configuration Management', N'System Component Inventory', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3980, N'CM-8(1)', N'Update the inventory of system components as part of component installations, removals,
and system updates.', N'Supplemental C-SCRM Guidance: When installing, updating, or removing an information system, information system component, or network component, the enterprise needs to update the inventory to ensure traceability for tracking critical components. In addition, the information system’s configuration needs to be updated to ensure an accurate inventory of supply chain protections and then re-baselined accordingly.
<br><br>Level(s): 3', N'Configuration Management', N'System Component Inventory', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3981, N'CM-8(2)', N'Maintain the currency, completeness, accuracy, and availability of the inventory of system
components using [Assignment: organization-defined automated mechanisms].', N'Supplemental C-SCRM Guidance: The enterprise should implement automated maintenance mechanisms to ensure that changes to component inventory for the information systems and networks are monitored for installation, update, and removal. When automated maintenance is performed with a predefined frequency and with the automated collation of relevant inventory information about each defined component, the enterprise should ensure that updates are available to relevant stakeholders for evaluation. Predefined frequencies for data collection should be less predictable in order to reduce the risk of an insider threat bypassing security mechanisms. 
<br><br>Level(s): 3', N'Configuration Management', N'System Component Inventory', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3982, N'CM-8(4)', N'Include in the system component inventory information, a means for identifying by
[Selection (one or more): name; position; role], individuals responsible and accountable for
administering those components.', N'Supplemental C-SCRM Guidance: The enterprise should ensure that accountability information is collected for information system and network components. The system/component inventory information should identify those individuals who originate an acquisition as well as intended end users, including any associated personnel who may administer or use the system/components.
<br><br>Level(s): 3', N'Configuration Management', N'System Component Inventory', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3983, N'CM-8(6)', N'Include assessed component configurations and any approved deviations to current
deployed configurations in the system component inventory.', N'Supplemental C-SCRM Guidance: Assessed configurations and approved deviations must be documented and tracked. Any changes to the baseline configurations of information systems and networks require a review by relevant stakeholders to ensure that the changes do not result in increased exposure to cybersecurity risks throughout the supply chain.
<br><br>Level(s): 3', N'Configuration Management', N'System Component Inventory', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3984, N'CM-8(7)', N'Provide a centralized repository for the inventory of system components.', N'Supplemental C-SCRM Guidance: Enterprises may choose to implement centralized inventories that include components from all enterprise information systems, networks, and their components. Centralized repositories of inventories provide opportunities for efficiencies in accounting for information systems, networks, and their components. Such repositories may also help enterprises rapidly identify the location and responsible individuals of components that have been compromised, breached, or are otherwise in need of mitigation actions. The enterprise should ensure that centralized inventories include the supply chain-specific information required for proper component accountability (e.g., supply chain relevance and information system, network, or component owner).
<br><br>Level(s): 3', N'Configuration Management', N'System Component Inventory', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3985, N'CM-8(8)', N'Support the tracking of system components by geographic location using [Assignment: organization-defined automated mechanisms].', N'Supplemental C-SCRM Guidance: When employing automated mechanisms for tracking information system components by physical location, the enterprise should incorporate information system, network, and component tracking needs to ensure accurate inventory.
<br><br>Level(s): 2, 3', N'Configuration Management', N'System Component Inventory', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3986, N'CM-8(9)', N'<ol type="a">
    <li>Assign system components to a system; and</li>
    <li>Receive an acknowledgement from [Assignment: organization-defined personnel or roles] of this assignment.</li>
</ol>', N'Supplemental C-SCRM Guidance: When assigning components to systems, the enterprise should ensure that the information systems and networks with all relevant components are inventoried, marked, and properly assigned. This facilitates quick inventory of all components relevant to information systems and networks and enables tracking of components that are considered critical and require differentiating treatment as part of the information system and network protection activities. 
<br><br>Level(s): 3', N'Configuration Management', N'System Component Inventory', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3987, N'CM-9', N'<p>Develop, document, and implement a configuration management plan for the system that:</p>
<ol type="a">
    <li>Addresses roles, responsibilities, and configuration management processes and procedures;</li>
    <li>Establishes a process for identifying configuration items throughout the system development life cycle and for managing the configuration of the configuration items;</li>
    <li>Defines the configuration items for the system and places the configuration items under configuration management;</li>
    <li>Is reviewed and approved by [Assignment: organization-defined personnel or roles]; and</li>
    <li>Protects the configuration management plan from unauthorized disclosure and modification.</li>
</ol>', N'', N'Configuration Management', N'Configuration Management Plan', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3988, N'CM-9(1)', N'Assign responsibility for developing the configuration management process to
organizational personnel that are not directly involved in system development.', N'Supplemental C-SCRM Guidance: Enterprises should ensure that all relevant roles are defined to address configuration management activities for information systems and networks. Enterprises should ensure that requirements and capabilities for configuration management are appropriately addressed or included in the following supply chain activities: requirements definition, development, testing, market research and analysis, procurement solicitations and contracts, component installation or removal, system integration, operations, and maintenance.
<br><br>Level(s): 2, 3', N'Configuration Management', N'Configuration Management Plan', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3989, N'CM-10', N'<ol type="a">
    <li>Use software and associated documentation in accordance with contract agreements and copyright laws;</li>
    <li>Track the use of software and associated documentation protected by quantity licenses to control copying and distribution; and</li>
    <li>Control and document the use of peer-to-peer file sharing technology to ensure that this capability is not used for the unauthorized distribution, display, performance, or reproduction of copyrighted work.</li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises should ensure that licenses for software used within their information systems and networks are documented, tracked, and maintained. Tracking mechanisms should provide for the ability to trace users and the use of licenses to access control information and processes. As an example, when an employee is terminated, a “named user” license should be revoked, and the license documentation should be updated to reflect this change. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity. 
<br><br>Level(s): 2, 3', N'Configuration Management', N'Software Usage Restrictions', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3990, N'CM-10(1)', N'Establish the following restrictions on the use of open-source software: [Assignment: organization-defined restrictions].', N'<p>Supplemental C-SCRM Guidance: When considering software, enterprises should review all options and corresponding risks, including open source or commercially licensed components. When using open source software (OSS), the enterprise should understand a', N'Configuration Management', N'Software Usage Restrictions', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3991, N'CM-11', N'<ol type="a">
    <li>Establish [Assignment: organization-defined policies] governing the installation of software by users;</li>
    <li>Enforce software installation policies through the following methods: [Assignment: organization-defined methods]; and</li>
    <li>Monitor policy compliance [Assignment: organization-defined frequency].</li>
</ol>', N'Supplemental C-SCRM Guidance: This control extends to the enterprise information system and network users who are not employed by the enterprise. These users may be suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers.
<br><br>Level(s): 2, 3', N'Configuration Management', N'User-Installed Software', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3992, N'CM-12', N'<ol type="a">
    <li>Identify and document the location of [Assignment: organization-defined information] and the specific system components on which the information is processed and stored;</li>
    <li>Identify and document the users who have access to the system and system components where the information is processed and stored; and</li>
    <li>Document changes to the location (i.e., system or system components) where the information is processed and stored.</li>
</ol>', N'Supplemental C-SCRM Guidance: Information that resides in different physical locations may be subject to different cybersecurity risks throughout the supply chain, depending on the specific location of the information. Components that originate or operate from different physical locations may also be subject to different supply chain risks, depending on the specific location of origination or operations. Enterprises should manage these risks through limiting access control and specifying allowable or disallowable geographic locations for backup/recovery, patching/upgrades, and information transfer/sharing. NIST SP 800-53, Rev. 5 control enhancement CM-12 (1) is a mechanism that can be used to enable automated location of components.
<br><br>Level(s): 2, 3', N'Configuration Management', N'Information Location', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3993, N'CM-12(1)', N'Use automated tools to identify [Assignment: organization-defined information by information type] on [Assignment: organization-defined system components] to ensure
controls are in place to protect organizational information and individual privacy.', N'Use automated tools to identify enterprise-defined information on enterprise-defined system components to ensure that controls are in place to protect enterprise information and individual privacy.
<br><br>Level(s): 2, 3', N'Configuration Management', N'Information Location', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3994, N'CM-13', N'Develop and document a map of system data actions.', N'Supplemental C-SCRM Guidance: In addition to personally identifiable information, understanding and documenting a map of system data actions for sensitive or classified information is necessary. Data action mapping should also be conducted to map Internet of Things (IoT) devices, embedded or stand-alone IoT systems, or IoT system of system data actions. Understanding what classified or IoT information is being processed, its sensitivity and/or effect on a physical thing or physical environment, how the sensitive or IoT information is being processed (e.g., if the data action is visible to an individual or is processed in another part of the system), and by whom provides a number of contextual factors that are important for assessing the degree of risk. Data maps can be illustrated in different ways, and the level of detail may vary based on the mission and business needs of the enterprise. The data map may be an overlay of any system design artifact that the enterprise is using. The development of this map may necessitate coordination between program and security personnel regarding the covered data actions and the components that are identified as part of the system.
<br><br>Level(s): 2, 3', N'Configuration Management', N'Data Action Mapping', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3995, N'CM-14', N'Prevent the installation of [Assignment: organization-defined software and firmware components] without verification that the component has been digitally signed using a certificate that is recognized and approved by the organization.', N'Supplemental C-SCRM Guidance: Enterprises should verify that the acquired hardware and software components are genuine and valid by using digitally signed components from trustworthy certificate authorities. Verifying components before allowing installation helps enterprises reduce cybersecurity risks throughout the supply chain.
<br><br>Level(s): 3', N'Configuration Management', N'Signed Components', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 10, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3996, N'CP-1', N'<ol type="a">
    <li>Develop, document, and disseminate to [Assignment: organization-defined personnel or roles]:
        <ol>
            <li>[Selection (one or more): Organization-level; Mission/business process-level; System-level] contingency planning policy that:
                <ol type="a">
                    <li>Addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and</li>
                    <li>Is consistent with applicable laws, executive orders, directives, regulations, policies, standards, and guidelines; and</li>
                </ol>
            </li>
            <li>Procedures to facilitate the implementation of the contingency planning policy and the associated contingency planning controls;</li>
        </ol>
    </li>
    <li>Designate an [Assignment: organization-defined official] to manage the development, documentation, and dissemination of the contingency planning policy and procedures; and</li>
    <li>Review and update the current contingency planning:
        <ol>
            <li>Policy [Assignment: organization-defined frequency] and following [Assignment: organization-defined events]; and</li>
            <li>Procedures [Assignment: organization-defined frequency] and following [Assignment: organization-defined events].</li>
        </ol>
    </li>
</ol>', N'<p>Supplemental C-SCRM Guidance: Enterprises should integrate C-SCRM into the contingency planning policy and related SCRM Strategy/Implementation Plan, policies, and SCRM Plan. The policy should cover information systems and the supply chain network and,', N'Contingency Planning', N'Contingency Planning Policy and Procedures', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 64, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3997, N'CP-2', N'<ol type="a">
    <li>Develop a contingency plan for the system that:
        <ol>
            <li>Identifies essential mission and business functions and associated contingency requirements;</li>
            <li>Provides recovery objectives, restoration priorities, and metrics;</li>
            <li>Addresses contingency roles, responsibilities, assigned individuals with contact information;</li>
            <li>Addresses maintaining essential mission and business functions despite a system disruption, compromise, or failure;</li>
            <li>Addresses eventual, full system restoration without deterioration of the controls originally planned and implemented;</li>
            <li>Addresses the sharing of contingency information; and</li>
            <li>Is reviewed and approved by [Assignment: organization-defined personnel or roles];</li>
        </ol>
    </li>
    <li>Distribute copies of the contingency plan to [Assignment: organization-defined key contingency personnel (identified by name and/or by role) and organizational elements];</li>
    <li>Coordinate contingency planning activities with incident handling activities;</li>
    <li>Review the contingency plan for the system [Assignment: organization-defined frequency];</li>
    <li>Update the contingency plan to address changes to the organization, system, or environment of operation and problems encountered during contingency plan implementation, execution, or testing;</li>
    <li>Communicate contingency plan changes to [Assignment: organization-defined key contingency personnel (identified by name and/or by role) and organizational elements];</li>
    <li>Incorporate lessons learned from contingency plan testing, training, or actual contingency activities into contingency testing and training; and</li>
    <li>Protect the contingency plan from unauthorized disclosure and modification.</li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises should define and implement a contingency plan for the supply chain information systems and network to ensure that preparations are in place to mitigate the loss or degradation of data or operations. Contingencies should be put in place for the supply chain, network, information systems (especially critical components), and processes to ensure protection against compromise and provide appropriate failover and timely recovery to an acceptable state of operations. 
<br><br>Level(s): 2, 3', N'Contingency Planning', N'Contingency Plan', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 64, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3998, N'CP-2(1)', N'Coordinate contingency plan development with organizational elements responsible for
related plans.', N'Supplemental C-SCRM Guidance: Coordinate contingency plan development for supply chain risks with enterprise elements responsible for related plans.
<br><br>Level(s): 2, 3', N'Contingency Planning', N'Contingency Plan', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 64, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (3999, N'CP-2(2)', N'Conduct capacity planning so that necessary capacity for information processing,
telecommunications, and environmental support exists during contingency operations.', N'Supplemental C-SCRM Guidance: This enhancement helps the availability of the supply chain network or information system components.
<br><br>Level(s): 2, 3', N'Contingency Planning', N'Contingency Plan', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 64, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4000, N'CP-2(7)', N'Coordinate the contingency plan with the contingency plans of external service providers
to ensure that contingency requirements can be satisfied.', N'Supplemental C-SCRM Guidance: Enterprises should ensure that the supply chain network, information systems, and components provided by an external service provider have appropriate failover (to include personnel, equipment, and network resources) to reduce or prevent service interruption or ensure timely recovery. Enterprises should ensure that contingency planning requirements are defined as part of the service-level agreement. The agreement may have specific terms that address critical components and functionality support in case of denial-of-service attacks to ensure the continuity of operations. Enterprises should coordinate with external service providers to identify service providers’ existing contingency plan practices and build on them as required by the enterprise’s mission and business needs. Such coordination will aid in cost reduction and efficient implementation. Enterprises should require their prime contractors who provide a mission- and business-critical or -enabling service or product to implement this control and flow down this requirement to relevant sub-tier contractors.
<br><br>Level(s): 3', N'Contingency Planning', N'Contingency Plan', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 64, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4001, N'CP-2(8)', N'Identify critical system assets supporting [Selection: all; essential] mission and business
functions.', N'Supplemental C-SCRM Guidance: Ensure that critical assets (including hardware, software, and personnel) are identified and that appropriate contingency planning requirements are defined and applied to ensure the continuity of operations. A key step in this process is to complete a criticality analysis on components, functions, and processes to identify all critical assets. See Section 2 and NIST IR 8179 for additional guidance on criticality analyses. 
<br><br>Level(s): 3', N'Contingency Planning', N'Contingency Plan', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 64, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4002, N'CP-3', N'<ol type="a">
    <li>Provide contingency training to system users consistent with assigned roles and responsibilities:
        <ol>
            <li>Within [Assignment: organization-defined time period] of assuming a contingency role or responsibility;</li>
            <li>When required by system changes; and</li>
            <li>[Assignment: organization-defined frequency] thereafter; and</li>
        </ol>
    </li>
    <li>Review and update contingency training content [Assignment: organization-defined frequency] and following [Assignment: organization-defined events].</li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises should ensure that critical suppliers are included in contingency training. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity. 
<br><br>Level(s): 2, 3', N'Contingency Planning', N'Contingency Training', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 64, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4003, N'CP-3(1)', N'Incorporate simulated events into contingency training to facilitate effective response by
personnel in crisis situations.', N'Supplemental C-SCRM Guidance: Enterprises should ensure that suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers who have roles and responsibilities in providing critical services are included in contingency training exercises. 
<br><br>Level(s): 3', N'Contingency Planning', N'Contingency Training', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 64, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4004, N'CP-4', N'<ol type="a">
    <li>Test the contingency plan for the system [Assignment: organization-defined frequency] using the following tests to determine the effectiveness of the plan and the readiness to execute the plan: [Assignment: organization-defined tests].</li>
    <li>Review the contingency plan test results; and</li>
    <li>Initiate corrective actions, if needed.</li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises should ensure that critical suppliers are included in contingency testing. The enterprise – in coordination with the service provider(s) – should test continuity/resiliency capabilities, such as failover from a primary production site to a back-up site. This testing may occur separately from a training exercise or be performed during the exercise. Enterprises should reference their C-SCRM threat assessment output to develop scenarios to test how well the enterprise is able to withstand and/or recover from a C-SCRM threat event. 
<br><br>Level(s): 2, 3', N'Contingency Planning', N'Contingency Plan Testing', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 64, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4005, N'CP-6', N'<ol type="a">
    <li>Establish an alternate storage site, including necessary agreements to permit the storage and retrieval of system backup information; and</li>
    <li>Ensure that the alternate storage site provides controls equivalent to that of the primary site.</li>
</ol>', N'Supplemental C-SCRM Guidance: When managed by suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers, alternative storage sites are considered within an enterprise’s supply chain network. Enterprises should apply appropriate cybersecurity supply chain controls to those storage sites. 
<br><br>Level(s): 2, 3', N'Contingency Planning', N'Alternate Storage Site', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 64, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4006, N'CP-6(1)', N'Identify an alternate storage site that is sufficiently separated from the primary storage
site to reduce susceptibility to the same threats.', N'Supplemental C-SCRM Guidance: This enhancement helps the resiliency of the supply chain network, information systems, and information system components. 
<br><br>Level(s): 2, 3', N'Contingency Planning', N'Alternate Storage Site', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 64, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4007, N'CP-7', N'<ol type="a">
    <li>Establish an alternate processing site, including necessary agreements to permit the transfer and resumption of [Assignment: organization-defined system operations] for essential mission and business functions within [Assignment: organization-defined time period consistent with recovery time and recovery point objectives] when the primary processing capabilities are unavailable;</li>
    <li>Make available at the alternate processing site, the equipment and supplies required to transfer and resume operations or put contracts in place to support delivery to the site within the organization-defined time period for transfer and resumption; and</li>
    <li>Provide controls at the alternate processing site that are equivalent to those at the primary site.</li>
</ol>', N'Supplemental C-SCRM Guidance: When managed by suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers, alternative storage sites are considered within an enterprise’s supply chain. Enterprises should apply appropriate supply chain cybersecurity controls to those processing sites. 
<br><br>Level(s): 2, 3', N'Contingency Planning', N'Alternate Processing Site', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 64, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4008, N'CP-8', N'Establish alternate telecommunications services, including necessary agreements to
permit the resumption of [Assignment: organization-defined system operations] for essential mission and business functions within [Assignment: organization-defined time period] when the primary telecommunications capabilities are unavailable at either the primary or alternate processing or storage sites.', N'Supplemental C-SCRM Guidance: Enterprises should incorporate alternative telecommunication service providers for their supply chain to support critical information systems. 
<br><br>Level(s): 2, 3', N'Contingency Planning', N'Telecommunications Services', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 64, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4009, N'CP-8(3)', N'Obtain alternate telecommunications services from providers that are separated from
primary service providers to reduce susceptibility to the same threats.', N'Supplemental C-SCRM Guidance: The separation of primary and alternative providers supports cybersecurity resilience of the supply chain. 
<br><br>Level(s): 2, 3', N'Contingency Planning', N'Telecommunications Services', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 64, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4010, N'CP-8(4)', N'<ol type="a">
    <li>Require primary and alternate telecommunications service providers to have contingency plans;</li>
    <li>Review provider contingency plans to ensure that the plans meet organizational contingency requirements; and</li>
    <li>Obtain evidence of contingency testing and training by providers [Assignment: organization-defined frequency].</li>
</ol>', N'Supplemental C-SCRM Guidance: For C-SCRM, suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers, contingency plans should provide separation in infrastructure, service, process, and personnel, where appropriate. 
<br><br>Level(s): 2, 3', N'Contingency Planning', N'Telecommunications Services', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 64, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4011, N'CP-11', N'Provide the capability to employ [Assignment: organization-defined alternative communications protocols] in support of maintaining continuity of operations.', N'Supplemental C-SCRM Guidance: Enterprises should ensure that critical suppliers are included in contingency plans, training, and testing as part of incorporating alternative communications protocol capabilities to establish supply chain resilience. 
<br><br>Level(s): 2, 3', N'Contingency Planning', N'Alternate Communications Protocols', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 64, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4012, N'IA-1', N'<ol type="a">
    <li>Develop, document, and disseminate to [Assignment: organization-defined personnel or roles]:
        <ol>
            <li>[Selection (one or more): Organization-level; Mission/business process-level; System-level] identification and authentication policy that:
                <ol type="a">
                    <li>Addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and</li>
                    <li>Is consistent with applicable laws, executive orders, directives, regulations, policies, standards, and guidelines; and</li>
                </ol>
            </li>
            <li>Procedures to facilitate the implementation of the identification and authentication policy and the associated identification and authentication controls;</li>
        </ol>
    </li>
    <li>Designate an [Assignment: organization-defined official] to manage the development, documentation, and dissemination of the identification and authentication policy and procedures; and</li>
    <li>Review and update the current identification and authentication:
        <ol>
            <li>Policy [Assignment: organization-defined frequency] and following [Assignment: organization-defined events]; and</li>
            <li>Procedures [Assignment: organization-defined frequency] and following [Assignment: organization-defined events].</li>
        </ol>
    </li>
</ol>', N'Supplemental C-SCRM Guidance: The enterprise should – at enterprise-defined intervals – review, enhance, and update their identity and access management policies and procedures to ensure that critical roles and processes within the supply chain network are defined and that the enterprise’s critical systems, components, and processes are identified for traceability. This should include the identity of critical components that may not have been considered under identification and authentication in the past. Note that providing identification for all items within the supply chain would be cost-prohibitive, and discretion should be used. The enterprise should update related CSCRM Strategy/Implementation Plan(s), Policies, and C-SCRM Plans. 
<br><br>Level(s): 1, 2, 3', N'Identification And Authentication', N'Identification and Authentication Policy and Procedures', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 65, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4013, N'IA-2', N'Uniquely identify and authenticate organizational users and associate that unique
identification with processes acting on behalf of those users.', N'Supplemental C-SCRM Guidance: Enterprises should ensure that identification and requirements are defined and applied for enterprise users accessing an ICT/OT system or supply chain network. An enterprise user may include employees, individuals deemed to have the equivalent status of employees (e.g., contractors, guest researchers, etc.), and system integrators fulfilling contractor roles. Criteria such as “duration in role” can aid in defining which identification and authentication mechanisms are used. The enterprise may choose to define a set of roles and associate a level of authorization to ensure proper implementation. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.
<br><br>Level(s): 1, 2, 3', N'Identification And Authentication', N'Identification and Authentication (Organizational Users)', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 65, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4014, N'IA-3', N'Uniquely identify and authenticate [Assignment: organization-defined devices and/or types of devices] before establishing a [Selection (one or more): local; remote; network]
connection.', N'Supplemental C-SCRM Guidance: Enterprises should implement capabilities to distinctly and positively identify devices and software within their supply chain and, once identified, verify that the identity is authentic. Devices that require unique device-to-device identification and authentication should be defined by type, device, or a combination of type and device. Software that requires authentication should be identified through a software identification tag (SWID) that enables verification of the software package and authentication of the enterprise releasing the software package. 
<br><br>Level(s): 1, 2, 3', N'Identification And Authentication', N'Device Identification and Authentication', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 65, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4015, N'IA-4', N'<p>Manage system identifiers by:</p>
<ol type="a">
    <li>Receiving authorization from [Assignment: organization-defined personnel or roles] to assign an individual, group, role, service, or device identifier;</li>
    <li>Selecting an identifier that identifies an individual, group, role, service, or device;</li>
    <li>Assigning the identifier to the intended individual, group, role, service, or device; and</li>
    <li>Preventing reuse of identifiers for [Assignment: organization-defined time period].</li>
</ol>', N'<p>Supplemental C-SCRM Guidance: Identifiers allow for greater discoverability and traceability. Within the enterprise’s supply chain, identifiers should be assigned to systems, individuals, documentation, devices, and components. In some cases, identifie', N'Identification And Authentication', N'Identifier Management', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 65, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4016, N'IA-4(6)', N'Coordinate with the following external organizations for cross-organization management
of identifiers: [Assignment: organization-defined external organizations].', N'Supplemental C-SCRM Guidance: This enhancement helps the traceability and provenance of elements within the supply chain through the coordination of identifier management among the enterprise and its suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers. This includes information systems and components as well as individuals engaged in supply chain activities.
<br><br>Level(s): 1, 2, 3', N'Identification And Authentication', N'Identifier Management', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 65, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4017, N'IA-5', N'<p>Manage system authenticators by:</p>
<ol type="a">
    <li>Verifying, as part of the initial authenticator distribution, the identity of the individual, group, role, service, or device receiving the authenticator;</li>
    <li>Establishing initial authenticator content for any authenticators issued by the organization;</li>
    <li>Ensuring that authenticators have sufficient strength of mechanism for their intended use;</li>
    <li>Establishing and implementing administrative procedures for initial authenticator distribution, for lost or compromised or damaged authenticators, and for revoking authenticators;</li>
    <li>Changing default authenticators prior to first use;</li>
    <li>Changing or refreshing authenticators [Assignment: organization-defined time period by authenticator type] or when [Assignment: organization-defined events] occur;</li>
    <li>Protecting authenticator content from unauthorized disclosure and modification;</li>
    <li>Requiring individuals to take, and having devices implement, specific controls to protect authenticators; and</li>
    <li>Changing authenticators for group or role accounts when membership to those accounts changes.</li>
</ol>', N'Supplemental C-SCRM Guidance: This control facilitates traceability and non-repudiation throughout the supply chain. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.
<br><br>Level(s): 2, 3', N'Identification And Authentication', N'Authenticator Management', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 65, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4018, N'IA-5(5)', N'Require developers and installers of system components to provide unique authenticators
or change default authenticators prior to delivery and installation.', N'Supplemental C-SCRM Guidance: This enhancement verifies the chain of custody within the enterprise’s supply chain. Level(s): 3', N'Identification And Authentication', N'Authenticator Management', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 65, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4019, N'IA-5(9)', N'Use the following external organizations to federate credentials: [Assignment: organization-defined external organizations].', N'Supplemental C-SCRM Guidance: This enhancement facilitates provenance and chain of custody within the enterprise’s supply chain. 
<br><br>Level(s): 3', N'Identification And Authentication', N'Authenticator Management', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 65, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4020, N'IA-8', N'Uniquely identify and authenticate non-organizational users or processes acting on
behalf of non-organizational users.', N'Supplemental C-SCRM Guidance: Suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers have the potential to engage the enterprise’s supply chain for service delivery (e.g., development/integration services, product support, etc.). Enterprises should manage the establishment, auditing, use, and revocation of identification credentials and the authentication of non-enterprise users within the supply chain. Enterprises should also ensure promptness in performing identification and authentication activities, especially in the case of revocation management, to help mitigate exposure to cybersecurity risks throughout the supply chain such as those that arise due to insider threats. 
<br><br>Level(s): 2, 3', N'Identification And Authentication', N'Identification and Authentication (Non-Organizational Users)', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 65, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4021, N'IA-9', N'Uniquely identify and authenticate [Assignment: organization-defined system services and applications] before establishing communications with devices, users, or other services or applications.', N'Supplemental C-SCRM Guidance: Enterprises should ensure that identification and authentication are defined and managed for access to services (e.g., web applications using digital certificates, services or applications that query a database as opposed to labor services) throughout the supply chain. Enterprises should ensure that they know what services are being procured and from whom. Services procured should be listed on a validated list of services for the enterprise or have compensating controls in place. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity. 
<br><br>Level(s): 2, 3', N'Identification And Authentication', N'Service Identification and Authentication', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 65, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4022, N'IR-1', N'<ol type="a">
    <li>Develop, document, and disseminate to [Assignment: organization-defined personnel or roles]:
        <ol>
            <li>[Selection (one or more): Organization-level; Mission/business process-level; System-level] incident response policy that:
                <ol type="a">
                    <li>Addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and</li>
                    <li>Is consistent with applicable laws, executive orders, directives, regulations, policies, standards, and guidelines; and</li>
                </ol>
            </li>
            <li>Procedures to facilitate the implementation of the incident response policy and the associated incident response controls;</li>
        </ol>
    </li>
    <li>Designate an [Assignment: organization-defined official] to manage the development, documentation, and dissemination of the incident response policy and procedures; and</li>
    <li>Review and update the current incident response:
        <ol>
            <li>Policy [Assignment: organization-defined frequency] and following [Assignment: organization-defined events]; and</li>
            <li>Procedures [Assignment: organization-defined frequency] and following [Assignment: organization-defined events].</li>
        </ol>
    </li>
</ol>', N'<p>Supplemental C-SCRM Guidance: Enterprises should integrate C-SCRM into incident response policy and procedures, and related C-SCRM Strategy/Implementation Plans and Policies. The policy and procedures must provide direction for how to address supply ch', N'Incident Response', N'Incident Response Policy and Procedures', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 17, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4023, N'IR-2', N'<ol type="a">
    <li>Provide incident response training to system users consistent with assigned roles and responsibilities:
        <ol>
            <li>Within [Assignment: organization-defined time period] of assuming an incident response role or responsibility or acquiring system access;</li>
            <li>When required by system changes; and</li>
            <li>[Assignment: organization-defined frequency] thereafter; and</li>
        </ol>
    </li>
    <li>Review and update incident response training content [Assignment: organization-defined frequency] and following [Assignment: organization-defined events].</li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises should ensure that critical suppliers are included in incident response training. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant subtier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.
<br><br>Level(s): 2, 3', N'Incident Response', N'Incident Response Training', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 17, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4024, N'IR-3', N'Test the effectiveness of the incident response capability for the system [Assignment: organization-defined frequency] using the following tests: [Assignment: organization-defined tests].', N'Supplemental C-SCRM Guidance: Enterprises should ensure that critical suppliers are included in and/or provided with incident response testing.
<br><br>Level(s): 2, 3', N'Incident Response', N'Incident Response Testing', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 17, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4025, N'IR-4(6)', N'Implement an incident handling capability for incidents involving insider threats.', N'Supplemental C-SCRM Guidance: This enhancement helps limit exposure of the C-SCRM information systems, networks, and processes to insider threats. Enterprises should ensure that insider threat incident handling capabilities account for the potential of insider threats associated with suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers’ personnel with access to ICT/OT systems within the authorization boundary.
<br><br>Level(s): 1, 2, 3', N'Incident Response', N'Incident Handling', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 17, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4026, N'IR-4(7)', N'Coordinate an incident handling capability for insider threats that includes the following
organizational entities [Assignment: organization-defined entities].', N'Supplemental C-SCRM Guidance: This enhancement helps limit the exposure of C-SCRM information systems, networks, and processes to insider threats. Enterprises should ensure that insider threat coordination includes suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers.
<br><br>Level(s): 1, 2, 3', N'Incident Response', N'Incident Handling', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 17, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4027, N'IR-4(10)', N'Coordinate incident handling activities involving supply chain events with other
organizations involved in the supply chain.', N'Supplemental C-SCRM Guidance: A number of enterprises may be involved in managing incidents and responses for supply chain security. After initially processing the incident and deciding on a course of action (in some cases, the action may be “no action”), the enterprise may need to coordinate with their suppliers, developers, system integrators, external system service providers, other ICT/OT-related service providers, and any relevant interagency bodies to facilitate communications, incident response, root cause, and corrective actions. Enterprises should securely share information through a coordinated set of personnel in key roles to allow for a more comprehensive incident handling approach. Selecting suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers with mature capabilities for supporting supply chain cybersecurity incident handling is important for reducing exposure to cybersecurity risks throughout the supply chain. If transparency for incident handling is limited due to the nature of the relationship, define a set of acceptable criteria in the agreement (e.g., contract). A review (and potential revision) of the agreement is recommended, based on the lessons learned from previous incidents. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. 
<br><br>Level(s): 2', N'Incident Response', N'Incident Handling', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 17, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4028, N'IR-4(11)', N'Establish and maintain an integrated incident response team that can be deployed to any
location identified by the organization in [Assignment: organization-defined time period].', N'Supplemental C-SCRM Guidance: An enterprise should include a forensics team and/or capability as part of an integrated incident response team for supply chain incidents. Where relevant and practical, integrated incident response teams should also include necessary geographical representation as well as suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers.
<br><br>Level(s): 3', N'Incident Response', N'Incident Handling', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 17, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4029, N'IR-5', N'Track and document incidents.', N'Supplemental C-SCRM Guidance: Enterprises should ensure that agreements with suppliers include requirements to track and document incidents, response decisions, and activities.
<br><br>Level(s): 2, 3', N'Incident Response', N'Incident Monitoring', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 17, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4030, N'IR-6(3)', N'Provide incident information to the provider of the product or service and other
organizations involved in the supply chain or supply chain governance for systems or
system components related to the incident.', N'Supplemental C-SCRM Guidance: Communications of security incident information from the enterprise to suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers and vice versa require protection. The enterprise should ensure that information is reviewed and approved for sending based on its agreements with suppliers and any relevant interagency bodies. Any escalation of or exception from this reporting should be clearly defined in the agreement. The enterprise should ensure that incident reporting data is adequately protected for transmission and received by approved individuals only. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. 
<br><br>Level(s): 3', N'Incident Response', N'Incident Reporting', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 17, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4031, N'IR-7(2)', N'<ol type="a">
    <li>Establish a direct, cooperative relationship between its incident response capability and external providers of system protection capability; and</li>
    <li>Identify organizational incident response team members to the external providers.</li>
</ol>', N'', N'Incident Response', N'Incident Response Assistance', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 17, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4032, N'IR-8', N'<ol type="a">
    <li>Develop an incident response plan that:
        <ol>
            <li>Provides the organization with a roadmap for implementing its incident response capability;</li>
            <li>Describes the structure and organization of the incident response capability;</li>
            <li>Provides a high-level approach for how the incident response capability fits into the overall organization;</li>
            <li>Meets the unique requirements of the organization, which relate to mission, size, structure, and functions;</li>
            <li>Defines reportable incidents;</li>
            <li>Provides metrics for measuring the incident response capability within the organization;</li>
            <li>Defines the resources and management support needed to effectively maintain and mature an incident response capability;</li>
            <li>Addresses the sharing of incident information;</li>
            <li>Is reviewed and approved by [Assignment: organization-defined personnel or roles] [Assignment: organization-defined frequency]; and</li>
            <li>Explicitly designates responsibility for incident response to [Assignment: organization-defined entities, personnel, or roles].</li>
        </ol>
    </li>
    <li>Distribute copies of the incident response plan to [Assignment: organization-defined incident response personnel (identified by name and/or by role) and organizational elements];</li>
    <li>Update the incident response plan to address system and organizational changes or problems encountered during plan implementation, execution, or testing;</li>
    <li>Communicate incident response plan changes to [Assignment: organization-defined incident response personnel (identified by name and/or by role) and organizational elements]; and</li>
    <li>Protect the incident response plan from unauthorized disclosure and modification.</li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises should coordinate, develop, and implement an incident response plan that includes information-sharing responsibilities with critical suppliers and, in a federal context, interagency partners and the FASC. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors.

Related Control(s): IR-10

<br><br>Level(s): 2, 3', N'Incident Response', N'Incident Response Plan', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 17, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4033, N'IR-9', N'<p>Respond to information spills by:</p>
<ol type="a">
    <li>Assigning [Assignment: organization-defined personnel or roles] with responsibility for responding to information spills;</li>
    <li>Identifying the specific information involved in the system contamination;</li>
    <li>Alerting [Assignment: organization-defined personnel or roles] of the information spill using a method of communication not associated with the spill;</li>
    <li>Isolating the contaminated system or system component;</li>
    <li>Eradicating the information from the contaminated system or component;</li>
    <li>Identifying other systems or system components that may have been subsequently contaminated; and</li>
    <li>Performing the following additional actions: [Assignment: organization-defined actions].</li>
</ol>', N'Supplemental C-SCRM Guidance: The supply chain is vulnerable to information spillage. The enterprise should include supply chain-related information spills in its information spillage response plan. This may require coordination with suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers. The details of how this coordination is to be conducted should be included in the agreement (e.g., contract). Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. 

<br><br>Level(s): 3

<br><br>Related Controls: SA-4', N'Incident Response', N'Information Spillage Response', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 17, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4034, N'MA-1', N'<ol type="a">
    <li>Develop, document, and disseminate to [Assignment: organization-defined personnel or roles]:
        <ol>
            <li>[Selection (one or more): Organization-level; Mission/business process-level; System-level] maintenance policy that:
                <ol type="a">
                    <li>Addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and</li>
                    <li>Is consistent with applicable laws, executive orders, directives, regulations, policies, standards, and guidelines; and</li>
                </ol>
            </li>
            <li>Procedures to facilitate the implementation of the maintenance policy and the associated maintenance controls;</li>
        </ol>
    </li>
    <li>Designate an [Assignment: organization-defined official] to manage the development, documentation, and dissemination of the maintenance policy and procedures; and</li>
    <li>Review and update the current maintenance:
        <ol>
            <li>Policy [Assignment: organization-defined frequency] and following [Assignment: organization-defined events]; and</li>
            <li>Procedures [Assignment: organization-defined frequency] and following [Assignment: organization-defined events].</li>
        </ol>
    </li>
</ol>', N'<p>Supplemental C-SCRM Guidance: Enterprises should ensure that C-SCRM is included in maintenance policies and procedures and any related SCRM Strategy/Implementation Plan, SCRM Policies, and SCRM Plan(s) for all enterprise information systems and network', N'Maintenance', N'Maintenance Policy and Procedures', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 22, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4035, N'MA-2(2)', N'<ol type="a">
<li>Schedule, conduct, and document maintenance, repair, and replacement actions for the system using [Assignment: organization-defined automated mechanisms]; and</li>
<li>Produce up-to date, accurate, and complete records of all maintenance, repair, and replacement actions requested, scheduled, in process, and completed.</li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises should ensure that all automated maintenance activities for supply chain systems and networks are controlled and managed according to the maintenance policy. Examples of automated maintenance activities can include COTS product patch updates, call home features with failure notification feedback, etc. Managing these activities may require establishing staging processes with appropriate supporting mechanisms to provide vetting or filtering as appropriate. Staging processes may be especially important for critical systems and components. 
<br><br>Level(s): 3', N'Maintenance', N'Controlled Maintenance', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 22, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4036, N'MA-3', N'<ol type="a">
    <li>Approve, control, and monitor the use of system maintenance tools; and</li>
    <li>Review previously approved system maintenance tools [Assignment: organization-defined frequency].</li>
</ol>', N'Supplemental C-SCRM Guidance: Maintenance tools are considered part of the supply chain. They also have a supply chain of their own. C-SCRM should be integrated when the enterprise acquires or upgrades a maintenance tool (e.g., an update to the development environment or testing tool), including during the selection, ordering, storage, and integration of the maintenance tool. The enterprise should perform continuous review and approval of maintenance tools, including those maintenance tools in use by external service providers. The enterprise should also integrate C-SCRM when evaluating replacement parts for maintenance tools. This control may be performed at both Level 2 and Level 3, depending on how an agency handles the acquisition, operations, and oversight of maintenance tools.
<br><br>Level(s): 2, 3', N'Maintenance', N'Maintenance Tools', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 22, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4037, N'MA-3(1)', N'Inspect the maintenance tools used by maintenance personnel for improper or
unauthorized modifications.', N'Supplemental C-SCRM Guidance: The enterprise should deploy acceptance testing to verify that the maintenance tools of the ICT/OT supply chain infrastructure are as expected. Maintenance tools should be authorized with appropriate paperwork, verified as claimed through initial verification, and tested for vulnerabilities, appropriate security configurations, and stated functionality.
<br><br>Level(s): 3', N'Maintenance', N'Maintenance Tools', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 22, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4038, N'MA-3(2)', N'Check media containing diagnostic and test programs for malicious code before the media
are used in the system.', N'Supplemental C-SCRM Guidance: The enterprise should verify that the media containing diagnostic and test programs that suppliers use on the enterprise’s information systems operates as expected and provides only required functions. The use of media from maintenance tools should be consistent with the enterprise’s policies and procedures and pre-approved. Enterprises should also ensure that the functionality does not exceed that which was agreed upon.
<br><br>Level(s): 3', N'Maintenance', N'Maintenance Tools', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 22, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4039, N'MA-3(3)', N'<p>Prevent the removal of maintenance equipment containing organizational information by:</p>
<ol type="a">
    <li>Verifying that there is no organizational information contained on the equipment;</li>
    <li>Sanitizing or destroying the equipment;</li>
    <li>Retaining the equipment within the facility; or</li>
    <li>Obtaining an exemption from [Assignment: organization-defined personnel or roles] explicitly authorizing removal of the equipment from the facility.</li>
</ol>', N'Supplemental C-SCRM Guidance: The unauthorized removal of systems and network maintenance tools from the supply chain may introduce supply chain risks, such as unauthorized modification, replacement with counterfeit, or malware insertion while the tool is outside of the enterprise’s control. Systems and network maintenance tools can include an integrated development environment (IDE), testing, or vulnerability scanning. For C-SCRM, it is important that enterprises should explicitly authorize, track, and audit any removal of maintenance tools. Once systems and network tools are allowed access to an enterprise/information system, they should remain the property/asset of the system owner and tracked if removed and used elsewhere in the enterprise. ICT maintenance tools either currently in use or in storage should not be allowed to leave the enterprise’s premises until they are properly vetted for removal (i.e., maintenance tool removal should not exceed in scope what was authorized for removal and should be completed in accordance with the enterprise’s established policies and procedures).
<br><br>Level(s): 3', N'Maintenance', N'Maintenance Tools', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 22, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4040, N'MA-4', N'<ol type="a">
    <li>Approve and monitor nonlocal maintenance and diagnostic activities;</li>
    <li>Allow the use of nonlocal maintenance and diagnostic tools only as consistent with organizational policy and documented in the security plan for the system;</li>
    <li>Employ strong authentication in the establishment of nonlocal maintenance and diagnostic sessions;</li>
    <li>Maintain records for nonlocal maintenance and diagnostic activities; and</li>
    <li>Terminate session and network connections when nonlocal maintenance is completed.</li>
</ol>', N'Supplemental C-SCRM Guidance: Nonlocal maintenance may be provided by contractor personnel. Appropriate protections should be in place to manage associated risks. Controls applied to internal maintenance personnel are applied to any suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers performing a similar maintenance role and enforced through contractual agreements with their external service providers.
<br><br>Level(s): 2, 3', N'Maintenance', N'Nonlocal Maintenance', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 22, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4041, N'MA-4(3)', N'<ol type="a">
<li>Require that nonlocal maintenance and diagnostic services be performed from a system that implements a security capability comparable to the capability implemented on the system being serviced; or</li>
<li>Remove the component to be serviced from the system prior to nonlocal maintenance or diagnostic services; sanitize the component (for organizational information); and after the service is performed, inspect and sanitize the component (for potentially malicious software) before reconnecting the component to the system.</li>
</ol>', N'<p>Supplemental C-SCRM Guidance: Should suppliers, developers, system integrators, external system service providers, or other ICT/OT-related service providers perform any nonlocal maintenance or diagnostic services on systems or system components, the en', N'Maintenance', N'Nonlocal Maintenance', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 22, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4042, N'MA-5', N'<ol type="a">
    <li>Establish a process for maintenance personnel authorization and maintain a list of authorized maintenance organizations or personnel;</li>
    <li>Verify that non-escorted personnel performing maintenance on the system possess the required access authorizations; and</li>
    <li>Designate organizational personnel with required access authorizations and technical competence to supervise the maintenance activities of personnel who do not possess the required access authorizations.</li>
</ol>', N'Supplemental C-SCRM Guidance: Maintenance personnel may be employed by suppliers, developers, system integrators, external system service providers, or other ICT/OT-related service providers. As such, appropriate protections should be in place to manage associated risks. The same controls applied to internal maintenance personnel should be applied to any contractor personnel who performs a similar maintenance role and enforced through contractual agreements with their external service providers.
<br><br>Level(s): 2, 3', N'Maintenance', N'Maintenance Personnel', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 22, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4043, N'MA-5(4)', N'<p>Ensure that:</p>
<ol type="a">
    <li>Foreign nationals with appropriate security clearances are used to conduct maintenance and diagnostic activities on classified systems only when the systems are jointly owned and operated by the United States and foreign allied governments, or owned and operated solely by foreign allied governments; and</li>
    <li>Approvals, consents, and detailed operational conditions regarding the use of foreign nationals to conduct maintenance and diagnostic activities on classified systems are fully documented within Memoranda of Agreements.</li>
</ol>', N'Supplemental C-SCRM Guidance: The vetting of foreign nationals with access to critical non-national security systems/services must take C-SCRM into account and be extended to all relevant contractor personnel. Enterprises should specify in agreements any restrictions or vetting requirements that pertain to foreign nationals and flow the requirements down to relevant subcontractors.
<br><br>Level(s): 2, 3', N'Maintenance', N'Maintenance Personnel', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 22, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4044, N'MA-6', N'Obtain maintenance support and/or spare parts for [Assignment: organization-defined system components] within [Assignment: organization-defined time period] of failure.', N'Supplemental C-SCRM Guidance: The enterprise should purchase spare parts, replacement parts, or alternative sources through original equipment manufacturers (OEMs), authorized distributors, or authorized resellers and ensure appropriate lead times. If OEMs are not available, it is preferred to acquire from authorized distributors. If an OEM or an authorized distributor is not available, then it is preferred to acquire from an authorized reseller. Enterprises should obtain verification on whether the distributor or reseller is authorized. Where possible, enterprises should use an authorized distributor/dealer approved list. If the only alternative is to purchase from a non-authorized distributor or secondary market, a risk assessment should be performed, including revisiting the criticality and threat analysis to identify additional risk mitigations to be used. For example, the enterprise should check the supply source for a history of counterfeits, inappropriate practices, or a criminal record. See Sec. 2 for criticality and threat analysis details. The enterprise should maintain a bench stock of critical OEM parts, if feasible, when the acquisition of such parts may not be accomplished within needed timeframes.
<br><br>Level(s): 3', N'Maintenance', N'Timely Maintenance', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 22, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4045, N'MA-7', N'Restrict or prohibit field maintenance on [Assignment: organization-defined systems or system components] to [Assignment: organization-defined trusted maintenance facilities].', N'Supplemental C-SCRM Guidance: Enterprises should use vetted or assessed facilities when additional rigor and quality control checks are needed, if at all practical or possible. Vetted or assessed facilities should be on an approved list and have additional controls in place. 

Related Control(s): MA-2, MA-4, MA-5

<br><br>Level(s): 3', N'Maintenance', N'Field Maintenance', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 22, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4046, N'MA-8', N'The enterprise monitors the status of systems and components and communicates out-of-bounds and out-of-spec performance to suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers. The enterprise should also report this information to the Government-Industry Data Exchange Program (GIDEP).', N'Supplemental C-SCRM Guidance: Tracking the failure rates of components provides useful information to the acquirer to help plan for contingencies, alternative sources of supply, and replacements. Failure rates are also useful for monitoring the quality and reliability of systems and components. This information provides useful feedback to suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers for corrective action and continuous improvement. In Level 2, agencies should track and communicate the failure rates to suppliers (OEM and/or an authorized distributor). The failure rates and the issues that can indicate failures, including root causes, should be identified by an enterprise’s technical personnel (e.g., developers, administrators, or maintenance engineers) in Level 3 and communicated to Level 2. These individuals are able to verify the problem and identify technical alternatives.

Related Control(s): IR-4(10)

<br><br>Level(s): 3', N'Maintenance', N'Maintenance Monitoring and Information Sharing', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 22, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4047, N'MP-1', N'<ol type="a">
    <li>Develop, document, and disseminate to [Assignment: organization-defined personnel or roles]:
        <ol>
            <li>[Selection (one or more): Organization-level; Mission/business process-level; System-level] media protection policy that:
                <ol type="a">
                    <li>Addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and</li>
                    <li>Is consistent with applicable laws, executive orders, directives, regulations, policies, standards, and guidelines; and</li>
                </ol>
            </li>
            <li>Procedures to facilitate the implementation of the media protection policy and the associated media protection controls;</li>
        </ol>
    </li>
    <li>Designate an [Assignment: organization-defined official] to manage the development, documentation, and dissemination of the media protection policy and procedures; and</li>
    <li>Review and update the current media protection:
        <ol>
            <li>Policy [Assignment: organization-defined frequency] and following [Assignment: organization-defined events]; and</li>
            <li>Procedures [Assignment: organization-defined frequency] and following [Assignment: organization-defined events].</li>
        </ol>
    </li>
</ol>', N'Supplemental C-SCRM Guidance: Various documents and information on a variety of physical and electronic media are disseminated throughout the supply chain. This information may contain a variety of sensitive information and intellectual property from suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers and should be appropriately protected. Media protection policies and procedures should also address supply chain concerns, including media in the enterprise’s supply chain and throughout the SDLC.
<br><br>Level(s): 1, 2', N'Media Protection', N'Media Protection Policy and Procedures', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 66, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4048, N'MP-4', N'<ol type="a">
    <li>Physically control and securely store [Assignment: organization-defined types of digital and/or non-digital media] within [Assignment: organization-defined controlled areas]; and</li>
    <li>Protect system media types defined in MP-4a until the media are destroyed or sanitized using approved equipment, techniques, and procedures.</li>
</ol>', N'Supplemental C-SCRM Guidance: Media storage controls should include C-SCRM activities. Enterprises should specify and include in agreements (e.g., contracting language) media storage requirements (e.g., encryption) for their suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers. The enterprise should require its prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors.
<br><br>Level(s): 1, 2', N'Media Protection', N'Media Storage', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 66, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4049, N'MP-5', N'<ol type="a">
    <li>Protect and control [Assignment: organization-defined types of system media] during transport outside of controlled areas using [Assignment: organization-defined controls];</li>
    <li>Maintain accountability for system media during transport outside of controlled areas;</li>
    <li>Document activities associated with the transport of system media; and</li>
    <li>Restrict the activities associated with the transport of system media to authorized personnel.</li>
</ol>', N'Supplemental C-SCRM Guidance: The enterprise should incorporate C-SCRM activities when media is transported by enterprise or non-enterprise personnel. Some of the techniques to protect media during transport and storage include cryptographic techniques and approved custodian services.
<br><br>Level(s): 1, 2', N'Media Protection', N'Media Transport', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 66, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4050, N'MP-6', N'<ol type="a">
    <li>Sanitize [Assignment: organization-defined system media] prior to disposal, release out of organizational control, or release for reuse using [Assignment: organization-defined sanitization techniques and procedures]; and</li>
    <li>Employ sanitization mechanisms with the strength and integrity commensurate with the security category or classification of the information.</li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises should specify and include in agreements (e.g., contracting language) media sanitization policies for their suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers. Media is used throughout the SDLC. Media traversing or residing in the supply chain may originate anywhere, including from suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers. It can be new, refurbished, or reused. Media sanitization is critical to ensuring that information is removed before the media is used, reused, or discarded. For media that contains privacy or other sensitive information (e.g., CUI), the enterprise should require its prime contractors to implement this control and flow down this requirement to relevant subtier contractors.

<br><br>Level(s): 2, 3

<br><br>Related Controls: MP-6(1), MP-6(2), MP-6(3), MP-6(7), MP-6(8)', N'Media Protection', N'Media Sanitization', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 66, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4051, N'PE-1', N'<ol type="a">
    <li>Develop, document, and disseminate to [Assignment: organization-defined personnel or roles]:
        <ol>
            <li>[Selection (one or more): Organization-level; Mission/business process-level; System-level] physical and environmental protection policy that:
                <ol type="a">
                    <li>Addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and</li>
                    <li>Is consistent with applicable laws, executive orders, directives, regulations, policies, standards, and guidelines; and</li>
                </ol>
            </li>
            <li>Procedures to facilitate the implementation of the physical and environmental protection policy and the associated physical and environmental protection controls;</li>
        </ol>
    </li>
    <li>Designate an [Assignment: organization-defined official] to manage the development, documentation, and dissemination of the physical and environmental protection policy and procedures; and</li>
    <li>Review and update the current physical and environmental protection:
        <ol>
            <li>Policy [Assignment: organization-defined frequency] and following [Assignment: organization-defined events]; and</li>
            <li>Procedures [Assignment: organization-defined frequency] and following [Assignment: organization-defined events].</li>
        </ol>
    </li>
</ol>', N'Supplemental C-SCRM Guidance: The enterprise should integrate C-SCRM practices and requirements into their own physical and environmental protection policy and procedures. The degree of protection should be commensurate with the degree of integration. The physical and environmental protection policy should ensure that the physical interfaces of the supply chain have adequate protection and audit for such protection.
<br><br>Level(s): 1, 2, 3', N'Physical and Environmental Protection', N'Physical and Environmental Protection Policy and Procedures', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 68, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4052, N'PE-2', N'<ol type="a">
    <li>Develop, approve, and maintain a list of individuals with authorized access to the facility where the system resides;</li>
    <li>Issue authorization credentials for facility access;</li>
    <li>Review the access list detailing authorized facility access by individuals [Assignment: organization-defined frequency]; and</li>
    <li>Remove individuals from the facility access list when access is no longer required.</li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises should ensure that only authorized individuals with a need for physical access have access to information, systems, or data centers (e.g., sensitive or classified). Such authorizations should specify what the individual is permitted or not permitted to do with regard to their physical access (e.g., view, alter/configure, insert something, connect something, remove, etc.). Agreements should address physical access authorization requirements, and the enterprise should require its prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Authorization for non-federal employees should follow an approved protocol, which includes documentation of the authorization and specifies any prerequisites or constraints that pertain to such authorization (e.g., individual must be escorted by a federal employee, individual must be badged, individual is permitted physical access during normal business hours, etc.).
<br><br>Level(s): 2, 3', N'Physical and Environmental Protection', N'Physical Access Authorizations', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 68, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4053, N'PE-2(1)', N'Authorize physical access to the facility where the system resides based on position or
role.', N'Supplemental C-SCRM Guidance: Role-based authorizations for physical access should include federal (e.g., agency/department employees) and non-federal employees (e.g., suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers). When role-based authorization is used, the type and level of access allowed for that role or position must be pre-established and documented.
<br><br>Level(s): 2, 3', N'Physical and Environmental Protection', N'Physical Access Authorizations', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 68, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4054, N'PE-3', N'<ol type="a">
    <li>
        Enforce physical access authorizations at [Assignment: organization-defined entry and exit points to the facility where the system resides] by:
        <ol>
            <li>Verifying individual access authorizations before granting access to the facility; and</li>
            <li>Controlling ingress and egress to the facility using [Selection (one or more): [Assignment: organization-defined physical access control systems or devices]; guards];</li>
        </ol>
    </li>
    <li>Maintain physical access audit logs for [Assignment: organization-defined entry or exit points];</li>
    <li>Control access to areas within the facility designated as publicly accessible by implementing the following controls: [Assignment: organization-defined physical access controls];</li>
    <li>Escort visitors and control visitor activity [Assignment: organization-defined circumstances requiring visitor escorts and control of visitor activity];</li>
    <li>Secure keys, combinations, and other physical access devices;</li>
    <li>Inventory [Assignment: organization-defined physical access devices] every [Assignment: organization-defined frequency]; and</li>
    <li>Change combinations and keys [Assignment: organization-defined frequency] and/or when keys are lost, combinations are compromised, or when individuals possessing the keys or combinations are transferred or terminated.</li>
</ol>', N'Supplemental C-SCRM Guidance: Physical access control should include individuals and enterprises engaged in the enterprise’s supply chain. A vetting process based on enterprise-defined requirements and policy should be in place prior to granting access to the supply chain infrastructure and any relevant elements. Access establishment, maintenance, and revocation processes should meet enterprise access control policy rigor. The speed of revocation for suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers who need access to physical facilities and data centers – either enterprise-owned or external service provider-owned – should be managed in accordance with the activities performed in their contracts. Prompt revocation is critical when either individual or enterprise need no longer exists.
<br><br>Level(s): 2, 3', N'Physical and Environmental Protection', N'Physical Access Control', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 68, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4055, N'PE-3(1)', N'Enforce physical access authorizations to the system in addition to the physical access
controls for the facility at [Assignment: organization-defined physical spaces containing one or more components of the system].', N'Supplemental C-SCRM Guidance: Physical access controls should be extended to contractor personnel. Any contractor resources that provide services support with physical access to the supply chain infrastructure and any relevant elements should adhere to access controls. Policies and procedures should be consistent with those applied to employee personnel with similar levels of physical access.
<br><br>Level(s): 2, 3', N'Physical and Environmental Protection', N'Physical Access Control', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 68, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4056, N'PE-3(2)', N'Perform security checks [Assignment: organization-defined frequency] at the physical
perimeter of the facility or system for exfiltration of information or removal of system
components.', N'Supplemental C-SCRM Guidance: When determining the extent, frequency, and/or randomness of security checks of facilities, enterprises should account for exfiltration risks that result from covert listening devices. Such devices may include wiretaps, roving bugs, cell site simulators, and other eavesdropping technologies that can transfer sensitive information out of the enterprise.
<br><br>Level(s): 2, 3', N'Physical and Environmental Protection', N'Physical Access Control', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 68, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4057, N'PE-3(5)', N'Employ [Assignment: organization-defined anti-tamper technologies] to [Selection (one or more): detect; prevent] physical tampering or alteration of [Assignment: organization-defined hardware components] within the system.', N'Supplemental C-SCRM Guidance: Tamper protection is critical for reducing cybersecurity risk in products. The enterprise should implement validated tamper protection techniques within the supply chain. For critical products, the enterprise should require and assess whether and to what extent a supplier has implemented tamper protection mechanisms. The assessment may also include whether and how such mechanisms are required and applied by the supplier’s upstream supply chain entities.
<br><br>Level(s): 2, 3', N'Physical and Environmental Protection', N'Physical Access Control', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 68, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4058, N'PE-6', N'<ol type="a">
    <li>Monitor physical access to the facility where the system resides to detect and respond to physical security incidents;</li>
    <li>Review physical access logs [Assignment: organization-defined frequency] and upon occurrence of [Assignment: organization-defined events or potential indications of events]; and</li>
    <li>Coordinate results of reviews and investigations with the organizational incident response capability.</li>
</ol>', N'Supplemental C-SCRM Guidance: Individuals who physically access the enterprise or external service provider’s facilities, data centers, information, or physical asset(s) – including via the supply chain – may be employed by the enterprise’s employees, on-site or remotely located contractors, visitors, other third parties (e.g., maintenance personnel under contract with the contractor enterprise), or an individual affiliated with an enterprise in the upstream supply chain. The enterprise should monitor these individuals’ activities to reduce cybersecurity risks throughout the supply chain or require monitoring in agreements.
<br><br>Level(s): 1, 2, 3', N'Physical and Environmental Protection', N'Monitoring Physical Access', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 68, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4059, N'PE-16', N'<ol type="a">
    <li>Authorize and control [Assignment: organization-defined types of system components] entering and exiting the facility; and</li>
    <li>Maintain records of the system components.</li>
</ol>', N'Supplemental C-SCRM Guidance: This control enhancement reduces cybersecurity risks that arise during the physical delivery and removal of hardware components from the enterprise’s information systems or supply chain. This includes transportation security, the validation of delivered components, and the verification of sanitization procedures. Risk-based considerations include component mission criticality as well as the development, operational, or maintenance environment (e.g., classified integration and test laboratory).
<br><br>Level(s): 3', N'Physical and Environmental Protection', N'Delivery and Removal', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 68, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4060, N'PE-17', N'<ol type="a">
    <li>Determine and document the [Assignment: organization-defined alternate work sites] allowed for use by employees;</li>
    <li>Employ the following controls at alternate work sites: [Assignment: organization-defined controls];</li>
    <li>Assess the effectiveness of controls at alternate work sites; and</li>
    <li>Provide a means for employees to communicate with information security and privacy personnel in case of incidents.</li>
</ol>', N'Supplemental C-SCRM Guidance: The enterprise should incorporate protections to guard against cybersecurity risks associated with enterprise employees or contractor personnel within or accessing the supply chain infrastructure using alternative work sites. This can include third-party personnel who may also work from alternative worksites.
<br><br>Level(s): 3', N'Physical and Environmental Protection', N'Alternate Work Site', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 68, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4061, N'PE-18', N'Position system components within the facility to minimize potential damage from
[Assignment: organization-defined physical and environmental hazards] and to minimize the opportunity for unauthorized access.', N'Supplemental C-SCRM Guidance: Physical and environmental hazards or disruptions have an impact on the availability of products that are or will be acquired and physically transported to the enterprise’s locations. For example, enterprises should incorporate the manufacturing, warehousing, or the distribution location of information system components that are critical for agency operations when planning for alternative suppliers for these components.

<br><br>Level(s): 1, 2, 3

<br><br>Related Controls: CP-6, CP-7', N'Physical and Environmental Protection', N'Location of System Components', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 68, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4062, N'PE-20', N'Employ [Assignment: organization-defined asset location technologies] to track and
monitor the location and movement of [Assignment: organization-defined assets] within
[Assignment: organization-defined controlled areas].', N'<p>Supplemental C-SCRM Guidance: The enterprise should, whenever possible and practical, use asset location technologies to track systems and components transported between entities across the supply chain, between protected areas, or in storage awaiting', N'Physical and Environmental Protection', N'Asset Monitoring and Tracking', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 68, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4063, N'PE-23', N'<ol type="a">
    <li>Plan the location or site of the facility where the system resides considering physical and environmental hazards; and</li>
    <li>For existing facilities, consider the physical and environmental hazards in the organizational risk management strategy.</li>
</ol>', N'Supplemental C-SCRM Guidance: Enterprises should incorporate the facility location (e.g., data centers) when assessing risks associated with suppliers. Factors may include geographic location (e.g., Continental United States [CONUS], Outside the Continental United States [OCONUS]), physical protections in place at one or more of the relevant facilities, local management and control of such facilities, environmental hazard potential (e.g., located in a high-risk seismic zone), and alternative facility locations. Enterprises should also assess whether the location of a manufacturing or distribution center could be influenced by geopolitical, economic, or other factors. For critical vendors or products, enterprises should specifically address any requirements or restrictions concerning the facility locations of the vendors (or their upstream supply chain providers) in contracts and flow down this requirement to relevant sub-level contractors. 

<br><br>Level(s): 2, 3

<br><br>Related Controls: SA-9(8)', N'Physical and Environmental Protection', N'Facility Location', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 68, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4064, N'PL-1', N'<ol type="a">
<li>Develop, document, and disseminate to [Assignment: organization-defined personnel or roles]:
<ol>
<li>[Selection (one or more): Organization-level; Mission/business process-level; System-level] planning policy that:
<ol type="a">
<li>Addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and</li>
<li>Is consistent with applicable laws, executive orders, directives, regulations, policies, standards, and guidelines; and</li>
</ol>
</li>
<li>Procedures to facilitate the implementation of the planning policy and the associated planning controls;</li>
</ol>
</li>
<li>Designate an [Assignment: organization-defined official] to manage the development, documentation, and dissemination of the planning policy and procedures; and</li>
<li>Review and update the current planning:
<ol>
<li>Policy [Assignment: organization-defined frequency] and following [Assignment: organization-defined events]; and</li>
<li>Procedures [Assignment: organization-defined frequency] and following [Assignment: organization-defined events].</li>
</ol>
</li>
</ol>', N'Supplemental C-SCRM Guidance: The security planning policy and procedures should integrate C-SCRM. This includes creating, disseminating, and updating the security policy, operational policy, and procedures for C-SCRM to shape acquisition or development requirements and the follow-on implementation, operations, and maintenance of systems, system interfaces, and network connections. The C-SCRM policy and procedures provide inputs into and take guidance from the C-SCRM Strategy and Implementation Plan at Level 1 and the System Security Plan and C-SCRM plan at Level 3. In Level 3, ensure that the full SDLC is covered from the C-SCRM perspective.

<br><br>Level(s): 2

<br><br>Related Controls: PL-2, PM-30', N'Planning', N'Planning Policy and Procedures', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 34, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4065, N'PL-2', N'<ol type="a">
    <li>
        Develop security and privacy plans for the system that:
        <ol>
            <li>Are consistent with the organization’s enterprise architecture;</li>
            <li>Explicitly define the constituent system components;</li>
            <li>Describe the operational context of the system in terms of mission and business processes;</li>
            <li>Identify the individuals that fulfill system roles and responsibilities;</li>
            <li>Identify the information types processed, stored, and transmitted by the system;</li>
            <li>Provide the security categorization of the system, including supporting rationale;</li>
            <li>Describe any specific threats to the system that are of concern to the organization;</li>
            <li>Provide the results of a privacy risk assessment for systems processing personally identifiable information;</li>
            <li>Describe the operational environment for the system and any dependencies on or connections to other systems or system components;</li>
            <li>Provide an overview of the security and privacy requirements for the system;</li>
            <li>Identify any relevant control baselines or overlays, if applicable;</li>
            <li>Describe the controls in place or planned for meeting the security and privacy requirements, including a rationale for any tailoring decisions;</li>
            <li>Include risk determinations for security and privacy architecture and design decisions;</li>
            <li>Include security- and privacy-related activities affecting the system that require planning and coordination with [Assignment: organization-defined individuals or groups]; and</li>
            <li>Are reviewed and approved by the authorizing official or designated representative prior to plan implementation.</li>
        </ol>
    </li>
    <li>Distribute copies of the plans and communicate subsequent changes to the plans to [Assignment: organization-defined personnel or roles];</li>
    <li>Review the plans [Assignment: organization-defined frequency];</li>
    <li>Update the plans to address changes to the system and environment of operation or problems identified during plan implementation or control assessments; and</li>
    <li>Protect the plans from unauthorized disclosure and modification.</li>
</ol>', N'Supplemental C-SCRM Guidance: The system security plan (SSP) should integrate CSCRM. The enterprise may choose to develop a stand-alone C-SCRM plan for an individual system or integrate SCRM controls into their SSP. The system security plan and/or system-level C-SCRM plan provide inputs into and take guidance from the CSCRM Strategy and Implementation Plan at Level 1 and the C-SCRM policy at Level 1 and Level 2. In addition to internal coordination, the enterprise should coordinate with suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers to develop and maintain their SSPs. For example, building and operating a system requires a significant coordination and collaboration between the enterprise and system integrator personnel. Such coordination and collaboration should be addressed in the system security plan or stand-alone C-SCRM plan. These plans should also consider that suppliers or external service providers may not be able to customize to the acquirer’s requirements. It is recommended that suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers also develop C-SCRM plans for non-federal (i.e., contractor) systems that are processing federal agency information and flow down this requirement to relevant sub-level contractors. Section 2, Appendix C, and Appendix D provide guidance on C-SCRM strategies, policies, and plans. Controls in this publication (NIST SP 800-161, Rev. 1) should be used for the C-SCRM portion of the SSP.

<br><br>Level(s): 3

<br><br>Related Controls: PM-30', N'Planning', N'System Security and Privacy Plans', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 34, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4066, N'PL-4', N'<ol type="a">
    <li>Establish and provide to individuals requiring access to the system, the rules that describe their responsibilities and expected behavior for information and system usage, security, and privacy;</li>
    <li>Receive a documented acknowledgment from such individuals, indicating that they have read, understand, and agree to abide by the rules of behavior, before authorizing access to information and the system;</li>
    <li>Review and update the rules of behavior [Assignment: organization-defined frequency]; and</li>
    <li>Require individuals who have acknowledged a previous version of the rules of behavior to read and re-acknowledge [Selection (one or more): [Assignment: organization-defined frequency]; when the rules are revised or updated].</li>
</ol>', N'Supplemental C-SCRM Guidance: The rules of behavior apply to contractor personnel and internal agency personnel. Contractor enterprises are responsible for ensuring that their employees follow applicable rules of behavior. Individual contractors should not be granted access to agency systems or data until they have acknowledged and demonstrated compliance with this control. Failure to meet this control can result in the removal of access for such individuals.
<br><br>Level(s): 2, 3', N'Planning', N'Rules of Behavior', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 34, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4067, N'PL-7', N'<ol type="a">
    <li>Develop a Concept of Operations (CONOPS) for the system describing how the organization intends to operate the system from the perspective of information security and privacy; and</li>
    <li>Review and update the CONOPS [Assignment: organization-defined frequency].</li>
</ol>', N'Supplemental C-SCRM Guidance: The concept of operations (CONOPS) should describe how the enterprise intends to operate the system from the perspective of C-SCRM. It should integrate C-SCRM and be managed and updated throughout the applicable system’s SDLC to address cybersecurity risks throughout the supply chain. 
<br><br>Level(s): 3', N'Planning', N'Concept of Operations', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 34, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4068, N'PL-8', N'<ol type="a">
    <li>
        Develop security and privacy architectures for the system that:
        <ol>
            <li>Describe the requirements and approach to be taken for protecting the confidentiality, integrity, and availability of organizational information;</li>
            <li>Describe the requirements and approach to be taken for processing personally identifiable information to minimize privacy risk to individuals;</li>
            <li>Describe how the architectures are integrated into and support the enterprise architecture; and</li>
            <li>Describe any assumptions about, and dependencies on, external systems and services;</li>
        </ol>
    </li>
    <li>Review and update the architectures [Assignment: organization-defined frequency] to reflect changes in the enterprise architecture; and</li>
    <li>Reflect planned architecture changes in security and privacy plans, Concept of Operations (CONOPS), criticality analysis, organizational procedures, and procurements and acquisitions.</li>
</ol>', N'Supplemental C-SCRM Guidance: Security and privacy architecture defines and directs the implementation of security and privacy-protection methods, mechanisms, and capabilities to the underlying systems and networks, as well as the information system that is being created. Security architecture is fundamental to C-SCRM because it helps to ensure that security is built-in throughout the SDLC. Enterprises should consider implementing zero-trust architectures and should ensure that the security architecture is well understood by system developers/engineers and system security engineers. This control applies to both federal agency and non-federal agency employees.
<br><br>Level(s): 2, 3', N'Planning', N'Security and Privacy Architectures', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 34, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4069, N'PL-8(2)', N'Require that [Assignment: organization-defined controls] allocated to [Assignment: organization-defined locations and architectural layers] are obtained from different
suppliers.', N'<p>Supplemental C-SCRM Guidance: Supplier diversity provides options for addressing information security and supply chain concerns. The enterprise should incorporate this control as it relates to suppliers, developers, system integrators, external system', N'Planning', N'Security and Privacy Architectures', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 34, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4070, N'PL-9', N'Centrally manage [Assignment: organization-defined controls and related processes].', N'Supplemental C-SCRM Guidance: C-SCRM controls are managed centrally at Level 1 through the C-SCRM Strategy and Implementation Plan and at Level 1 and Level 2 through the C-SCRM Policy. The C-SCRM PMO described in Section 2 centrally manages C-SCRM controls at Level 1 and Level. At Level 3, C-SCRM controls are managed on an information system basis though the SSP and/or C-SCRM Plan.
<br><br>Level(s): 1, 2', N'Planning', N'Central Management', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 34, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4071, N'PL-10', N'Select a control baseline for the system.', N'Supplemental C-SCRM Guidance: Enterprises should include C-SCRM controls in their control baselines. Enterprises should identify and select C-SCRM controls based on the C-SCRM requirements identified within each of the levels. A C-SCRM PMO may assist in identifying C-SCRM control baselines that meet common C-SCRM requirements for different groups, communities of interest, or the enterprise as a whole.
<br><br>Level(s): 1, 2', N'Planning', N'Baseline Selection', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 34, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4072, N'PM-2', N'Appoint a senior agency information security officer with the mission and resources to
coordinate, develop, implement, and maintain an organization-wide information security
program.', N'Supplemental C-SCRM Guidance: The senior information security officer (e.g., CISO) and senior agency official responsible for acquisition (e.g., Chief Acquisition Officer [CAO] or Senior Procurement Executive [SPE]) have key responsibilities for C-SCRM and the overall cross-enterprise coordination and collaboration with other applicable senior personnel within the enterprise, such as the CIO, the head of facilities/physical security, and the risk executive (function). This coordination should occur regardless of the specific department and agency enterprise structure and specific titles of relevant senior personnel. The coordination could be executed by the C-SCRM PMO or another similar function. Section 2 provides more guidance on C-SCRM roles and responsibilities.
<br><br>Level(s): 1, 2', N'Program Management', N'Information Security Program Leadership Role', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4073, N'PM-3', N'<ol type="a">
    <li>Include the resources needed to implement the information security and privacy programs in capital planning and investment requests and document all exceptions to this requirement;</li>
    <li>Prepare documentation required for addressing information security and privacy programs in capital planning and investment requests in accordance with applicable laws, executive orders, directives, policies, regulations, standards; and</li>
    <li>Make available for expenditure, the planned information security and privacy resources.</li>
</ol>', N'Supplemental C-SCRM Guidance: An enterprise’s C-SCRM program requires dedicated, sustained funding and human resources to successfully implement agency C-SCRM requirements. Section 3 of this document provides guidance on dedicated funding for CSCRM programs. The enterprise should also integrate C-SCRM requirements into major IT investments to ensure that funding is appropriately allocated through the capital planning and investment request process. For example, should an RFID infrastructure be required to enhance C-SCRM to secure and improve the inventory or logistics management efficiency of the enterprise’s supply chain, appropriate IT investments would likely be required to ensure successful planning and implementation. Other examples include any investment into the development or test environment for critical components. In such cases, funding and resources are needed to acquire and maintain appropriate information systems, networks, and components to meet specific C-SCRM requirements that support the mission.
<br><br>Level(s): 1, 2', N'Program Management', N'Information Security and Privacy Resources', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4074, N'PM-4', N'<ol type="a">
    <li>
        Implement a process to ensure that plans of action and milestones for the information security, privacy, and supply chain risk management programs and associated organizational systems:
        <ol>
            <li>Are developed and maintained;</li>
            <li>Document the remedial information security, privacy, and supply chain risk management actions to adequately respond to risk to organizational operations and assets, individuals, other organizations, and the Nation; and</li>
            <li>Are reported in accordance with established reporting requirements.</li>
        </ol>
    </li>
    <li>Review plans of action and milestones for consistency with the organizational risk management strategy and organization-wide priorities for risk response actions.</li>
</ol>', N'Supplemental C-SCRM Guidance: C-SCRM items should be included in the POA&M at all levels. Organizations should develop POA&Ms based on C-SCRM assessment reports. POA&M should be used by organizations to describe planned actions to correct the deficiencies in C-SCRM controls identified during assessment and the continuous monitoring of progress against those actions. 

<br><br>Level(s): 2, 3

<br><br>Related Controls: CA-5, PM-30', N'Program Management', N'Plan of Action and Milestones Process', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4075, N'PM-5', N'Develop and update [Assignment: organization-defined frequency] an inventory of
organizational systems.', N'Supplemental C-SCRM Guidance: Having a current system inventory is foundational for C-SCRM. Not having a system inventory may lead to the enterprise’s inability to identify system and supplier criticality, which would result in an inability to conduct C-SCRM activities. To ensure that all applicable suppliers are identified and categorized for criticality, enterprises should include relevant supplier information in the system inventory and maintain its currency and accuracy. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant subtier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.
<br><br>Level(s): 2, 3', N'Program Management', N'System Inventory', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4076, N'PM-6', N'Develop, monitor, and report on the results of information security and privacy
measures of performance.', N'Supplemental C-SCRM Guidance: Enterprises should use measures of performance to track the implementation, efficiency, effectiveness, and impact of C-SCRM activities. The C-SCRM PMO is responsible for creating C-SCRM measures of performance in collaboration with other applicable stakeholders to include identifying the appropriate audience and decision makers and providing guidance on data collection, analysis, and reporting.
<br><br>Level(s): 1, 2', N'Program Management', N'Measures of Performance', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4077, N'PM-7', N'Develop and maintain an enterprise architecture with consideration for information
security, privacy, and the resulting risk to organizational operations and assets, individuals, other organizations, and the Nation.', N'Supplemental C-SCRM Guidance: C-SCRM should be integrated when designing and maintaining enterprise architecture. 
<br><br>Level(s): 1, 2', N'Program Management', N'Enterprise Architecture', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4078, N'PM-8', N'Address information security and privacy issues in the development, documentation,
and updating of a critical infrastructure and key resources protection plan.', N'Supplemental C-SCRM Guidance: C-SCRM should be integrated when developing and maintaining critical infrastructure plan.
<br><br>Level(s): 1', N'Program Management', N'Critical Infrastructure Plan', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4079, N'PM-9', N'<ol type="a">
    <li>
        Develop a comprehensive strategy to manage:
        <ol>
            <li>Security risk to organizational operations and assets, individuals, other organizations, and the Nation associated with the operation and use of organizational systems; and</li>
            <li>Privacy risk to individuals resulting from the authorized processing of personally identifiable information;</li>
        </ol>
    </li>
    <li>Implement the risk management strategy consistently across the organization; and</li>
    <li>Review and update the risk management strategy [Assignment: organization-defined frequency] or as required, to address organizational changes.</li>
</ol>', N'Supplemental C-SCRM Guidance: The risk management strategy should address cybersecurity risks throughout the supply chain. Section 2, Appendix C, and Appendix D of this document provide guidance on integrating C-SCRM into the risk management strategy.
<br><br>Level(s): 1', N'Program Management', N'Risk Management Strategy', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4080, N'PM-10', N'<ol type="a">
    <li>Manage the security and privacy state of organizational systems and the environments in which those systems operate through authorization processes;</li>
    <li>Designate individuals to fulfill specific roles and responsibilities within the organizational risk management process; and</li>
    <li>Integrate the authorization processes into an organization-wide risk management program.</li>
</ol>', N'Supplemental C-SCRM Guidance: C-SCRM should be integrated when designing and implementing authorization processes.
<br><br>Level(s): 1, 2', N'Program Management', N'Authorization Process', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4081, N'PM-11', N'<ol type="a">
    <li>Define organizational mission and business processes with consideration for information security and privacy and the resulting risk to organizational operations, organizational assets, individuals, other organizations, and the Nation; and</li>
    <li>Determine information protection and personally identifiable information processing needs arising from the defined mission and business processes; and</li>
    <li>Review and revise the mission and business processes [Assignment: organization-defined frequency].</li>
</ol>', N'Supplemental C-SCRM Guidance: The enterprise’s mission and business processes should address cybersecurity risks throughout the supply chain. When addressing mission and business process definitions, the enterprise should ensure that C-SCRM activities are incorporated into the support processes for achieving mission success. For example, a system supporting a critical mission function that has been designed and implemented for easy removal and replacement should a component fail may require the use of somewhat unreliable hardware components. A C-SCRM activity may need to be defined to ensure that the supplier makes component spare parts readily available if a replacement is needed.
<br><br>Level(s): 1, 2, 3', N'Program Management', N'Mission and Business Process Definition', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4082, N'PM-12', N'Implement an insider threat program that includes a cross-discipline insider threat
incident handling team.', N'Supplemental C-SCRM Guidance: An insider threat program should include C-SCRM and be tailored for both federal and non-federal agency individuals who have access to agency systems and networks. This control applies to contractors and subcontractors and should be implemented throughout the SDLC.
<br><br>Level(s): 1, 2, 3', N'Program Management', N'Insider Threat Program', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4083, N'PM-13', N'Establish a security and privacy workforce development and improvement program.', N'Supplemental C-SCRM Guidance: Security and privacy workforce development and improvement should ensure that relevant C-SCRM topics are integrated into the content and initiatives produced by the program. Section 2 provides information on C-SCRM roles and responsibilities. NIST SP 800-161 can be used as a source of topics and activities to include in the security and privacy workforce program.
<br><br>Level(s): 1, 2', N'Program Management', N'Security and Privacy Workforce', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4084, N'PM-14', N'<ol type="a">
    <li>
        Implement a process for ensuring that organizational plans for conducting security and privacy testing, training, and monitoring activities associated with organizational systems:
        <ol>
            <li>Are developed and maintained; and</li>
            <li>Continue to be executed; and</li>
        </ol>
    </li>
    <li>Review testing, training, and monitoring plans for consistency with the organizational risk management strategy and organization-wide priorities for risk response actions.</li>
</ol>', N'Supplemental C-SCRM Guidance: The enterprise should implement a process to ensure that organizational plans for conducting supply chain risk testing, training, and monitoring activities associated with organizational systems are maintained. The CSCRM PMO can provide guidance and support on how to integrate C-SCRM into testing, training, and monitoring plans.
<br><br>Level(s): 1, 2', N'Program Management', N'Testing, Training, and Monitoring', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4085, N'PM-15', N'<p>Establish and institutionalize contact with selected groups and associations within the security and privacy communities:</p>
<ol type="a">
    <li>To facilitate ongoing security and privacy education and training for organizational personnel;</li>
    <li>To maintain currency with recommended security and privacy practices, techniques, and technologies; and</li>
    <li>To share current security and privacy information, including threats, vulnerabilities, and incidents.</li>
</ol>', N'Supplemental C-SCRM Guidance: Contact with security and privacy groups and associations should include C-SCRM practitioners and those with C-SCRM responsibilities. Acquisition, legal, critical infrastructure, and supply chain groups and associations should be incorporated. The C-SCRM PMO can help identify agency personnel who could benefit from participation, specific groups to participate in, and relevant topics.
<br><br>Level(s): 1, 2', N'Program Management', N'Security and Privacy Groups and Associations', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4086, N'PM-16', N'Implement a threat awareness program that includes a cross-organization information-sharing capability for threat intelligence.', N'Supplemental C-SCRM Guidance: A threat awareness program should include threats that emanate from the supply chain. When addressing supply chain threat awareness, knowledge should be shared between stakeholders within the boundaries of the enterprise’s information sharing policy. The C-SCRM PMO can help identify C-SCRM stakeholders to include in threat information sharing, as well as potential sources of information for supply chain threats.
<br><br>Level(s): 1, 2', N'Program Management', N'Threat Awareness Program', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4087, N'PM-17', N'<ol type="a">
    <li>Establish policy and procedures to ensure that requirements for the protection of controlled unclassified information that is processed, stored or transmitted on external systems, are implemented in accordance with applicable laws, executive orders, directives, policies, regulations, and standards; and</li>
    <li>Review and update the policy and procedures [Assignment: organization-defined frequency].</li>
</ol>', N'Supplemental C-SCRM Guidance: The policy and procedures for controlled unclassified information (CUI) on external systems should include protecting relevant supply chain information. Conversely, it should include protecting agency information that resides in external systems because such external systems are part of the agency supply chain.
<br><br>Level(s): 2', N'Program Management', N'Protecting Controlled Unclassified Information on External Systems', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4088, N'PM-18', N'<ol type="a">
    <li>
        Develop and disseminate an organization-wide privacy program plan that provides an overview of the agency’s privacy program, and:
        <ol>
            <li>Includes a description of the structure of the privacy program and the resources dedicated to the privacy program;</li>
            <li>Provides an overview of the requirements for the privacy program and a description of the privacy program management controls and common controls in place or planned for meeting those requirements;</li>
            <li>Includes the role of the senior agency official for privacy and the identification and assignment of roles of other privacy officials and staff and their responsibilities;</li>
            <li>Describes management commitment, compliance, and the strategic goals and objectives of the privacy program;</li>
            <li>Reflects coordination among organizational entities responsible for the different aspects of privacy; and</li>
            <li>Is approved by a senior official with responsibility and accountability for the privacy risk being incurred to organizational operations (including mission, functions, image, and reputation), organizational assets, individuals, other organizations, and the Nation; and</li>
        </ol>
    </li>
    <li>Update the plan [Assignment: organization-defined frequency] and to address changes in federal privacy laws and policy and organizational changes and problems identified during plan implementation or privacy control assessments.</li>
</ol>', N'Supplemental C-SCRM Guidance: The privacy program plan should include C-SCRM. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors.
<br><br>Level(s): 1, 2', N'Program Management', N'Privacy Program Plan', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4089, N'PM-19', N'Appoint a senior agency official for privacy with the authority, mission, accountability,
and resources to coordinate, develop, and implement, applicable privacy requirements and
manage privacy risks through the organization-wide privacy program.', N'Supplemental C-SCRM Guidance: The privacy program leadership role should be included as a stakeholder in applicable C-SCRM initiatives and activities.
<br><br>Level(s): 1', N'Program Management', N'Privacy Program Leadership Role', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4090, N'PM-20', N'<p>Maintain a central resource webpage on the organization’s principal public website that serves as a central source of information about the organization’s privacy program and that:</p>
<ol type="a">
    <li>Ensures that the public has access to information about organizational privacy activities and can communicate with its senior agency official for privacy;</li>
    <li>Ensures that organizational privacy practices and reports are publicly available; and</li>
    <li>Employs publicly facing email addresses and/or phone lines to enable the public to provide feedback and/or direct questions to privacy offices regarding privacy practices.</li>
</ol>', N'Supplemental C-SCRM Guidance: The dissemination of privacy program information should be protected from cybersecurity risks throughout the supply chain.
<br><br>Level(s): 1, 2', N'Program Management', N'Dissemination of Privacy Program Information', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4091, N'PM-21', N'<ol type="a">
    <li>
        Develop and maintain an accurate accounting of disclosures of personally identifiable information, including:
        <ol>
            <li>Date, nature, and purpose of each disclosure; and</li>
            <li>Name and address, or other contact information of the individual or organization to which the disclosure was made;</li>
        </ol>
    </li>
    <li>Retain the accounting of disclosures for the length of the time the personally identifiable information is maintained or five years after the disclosure is made, whichever is longer; and</li>
    <li>Make the accounting of disclosures available to the individual to whom the personally identifiable information relates upon request.</li>
</ol>', N'Supplemental C-SCRM Guidance: An accounting of disclosures should be protected from cybersecurity risks throughout the supply chain.
<br><br>Level(s): 1, 2', N'Program Management', N'Accounting of Disclosures', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4092, N'PM-22', N'<p>Develop and document organization-wide policies and procedures for:</p>
<ol type="a">
    <li>Reviewing for the accuracy, relevance, timeliness, and completeness of personally identifiable information across the information life cycle;</li>
    <li>Correcting or deleting inaccurate or outdated personally identifiable information;</li>
    <li>Disseminating notice of corrected or deleted personally identifiable information to individuals or other appropriate entities; and</li>
    <li>Appeals of adverse decisions on correction or deletion requests.</li>
</ol>', N'Supplemental C-SCRM Guidance: Personally identifiable information (PII) quality management should take into account and manage cybersecurity risks related to PII throughout the supply chain.
<br><br>Level(s): 1, 2', N'Program Management', N'Personally Identifiable Information Quality Management', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4093, N'PM-23', N'Establish a Data Governance Body consisting of [Assignment: organization-defined roles] with [Assignment: organization-defined responsibilities].', N'Supplemental C-SCRM Guidance: Data governance body is a stakeholder in C-SCRM and should be included in cross-agency collaboration and information sharing of C-SCRM activities and initiatives (e.g., by participating in inter-agency bodies, such as the FASC).
<br><br>Level(s): 1', N'Program Management', N'Data Governance Body', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4094, N'PM-25', N'<ol type="a">
    <li>Develop, document, and implement policies and procedures that address the use of personally identifiable information for internal testing, training, and research;</li>
    <li>Limit or minimize the amount of personally identifiable information used for internal testing, training, and research purposes;</li>
    <li>Authorize the use of personally identifiable information when such information is required for internal testing, training, and research; and</li>
    <li>Review and update policies and procedures [Assignment: organization-defined frequency].</li>
</ol>', N'Supplemental C-SCRM Guidance: Supply chain-related cybersecurity risks to personally identifiable information should be addressed by the minimization policies and procedures described in this control.
<br><br>Level(s): 2', N'Program Management', N'Minimization of Personally Identifiable Information Used in Testing, Training, and Research', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4095, N'PM-26', N'<p>Implement a process for receiving and responding to complaints, concerns, or questions from individuals about the organizational security and privacy practices that includes:</p>
<ol type="a">
    <li>Mechanisms that are easy to use and readily accessible by the public;</li>
    <li>All information necessary for successfully filing complaints;</li>
    <li>Tracking mechanisms to ensure all complaints received are reviewed and addressed within [Assignment: organization-defined time period];</li>
    <li>Acknowledgement of receipt of complaints, concerns, or questions from individuals within [Assignment: organization-defined time period]; and</li>
    <li>Response to complaints, concerns, or questions from individuals within [Assignment: organization-defined time period].</li>
</ol>', N'Supplemental C-SCRM Guidance: Complaint management process and mechanisms should be protected from cybersecurity risks throughout the supply chain. Enterprises should also integrate C-SCRM security and privacy controls when fielding complaints from vendors or the general public (e.g., departments and agencies fielding inquiries related to exclusions and removals).
<br><br>Level(s): 2, 3', N'Program Management', N'Complaint Management', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4096, N'PM-27', N'<ol type="a">
    <li>
        Develop [Assignment: organization-defined privacy reports] and disseminate to:
        <ol>
            <li>[Assignment: organization-defined oversight bodies] to demonstrate accountability with statutory, regulatory, and policy privacy mandates; and</li>
            <li>[Assignment: organization-defined officials] and other personnel with responsibility for monitoring privacy program compliance; and</li>
        </ol>
    </li>
    <li>Review and update privacy reports [Assignment: organization-defined frequency].</li>
</ol>', N'Supplemental C-SCRM Guidance: Privacy reporting process and mechanisms should be protected from cybersecurity risks throughout the supply chain.
<br><br>Level(s): 2, 3', N'Program Management', N'Privacy Reporting', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4097, N'PM-28', N'<ol type="a">
    <li>
        Identify and document:
        <ol>
            <li>Assumptions affecting risk assessments, risk responses, and risk monitoring;</li>
            <li>Constraints affecting risk assessments, risk responses, and risk monitoring;</li>
            <li>Priorities and trade-offs considered by the organization for managing risk; and</li>
            <li>Organizational risk tolerance;</li>
        </ol>
    </li>
    <li>Distribute the results of risk framing activities to [Assignment: organization-defined personnel]; and</li>
    <li>Review and update risk framing considerations [Assignment: organization-defined frequency].</li>
</ol>', N'Supplemental C-SCRM Guidance: C-SCRM should be included in risk framing. Section 2 and Appendix C provide detailed guidance on integrating C-SCRM into risk framing.
<br><br>Level(s): 1', N'Program Management', N'Risk Framing', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4098, N'PM-29', N'<ol type="a">
    <li>Appoint a Senior Accountable Official for Risk Management to align organizational information security and privacy management processes with strategic, operational, and budgetary planning processes; and</li>
    <li>Establish a Risk Executive (function) to view and analyze risk from an organization-wide perspective and ensure management of risk is consistent across the organization.</li>
</ol>', N'Supplemental C-SCRM Guidance: Risk management program leadership roles should include C-SCRM responsibilities and be included in C-SCRM collaboration across the enterprise. Section 2 and Appendix C provide detailed guidance for C-SCRM roles and responsibilities.
<br><br>Level(s): 1', N'Program Management', N'Risk Management Program Leadership Roles', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4099, N'PM-30', N'<ol type="a">
    <li>Develop an organization-wide strategy for managing supply chain risks associated with the development, acquisition, maintenance, and disposal of systems, system components, and system services;</li>
    <li>Implement the supply chain risk management strategy consistently across the organization; and</li>
    <li>Review and update the supply chain risk management strategy on [Assignment: organization-defined frequency] or as required, to address organizational changes.</li>
</ol>', N'Supplemental C-SCRM Guidance: The Supply Chain Risk Management Strategy (also known as C-SCRM Strategy) should be complemented with a C-SCRM Implementation Plan that lays out detailed initiatives and activities for the enterprise with timelines and responsible parties. This implementation plan can be a POA&M or be included in a POA&M. Based on the C-SCRM Strategy and Implementation Plan at Level 1, the enterprise should select and document common C- SCRM controls that should address the enterprise, program, and system-specific needs. These controls should be iteratively integrated into the C-SCRM Policy at Level 1 and Level 2, as well as the C-SCRM plan (or SSP if required) at Level 3. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. See Section 2 and Appendix C for further guidance on risk management.

<br><br>Level(s): 1, 2

<br><br>Related Controls: PL-2', N'Program Management', N'Supply Chain Risk Management Strategy', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4100, N'PM-31', N'<p>Develop an organization-wide continuous monitoring strategy and implement continuous monitoring programs that include:</p>
<ol type="a">
    <li>Establishing the following organization-wide metrics to be monitored: [Assignment: organization-defined metrics];</li>
    <li>Establishing [Assignment: organization-defined frequencies] for monitoring and [Assignment: organization-defined frequencies] for assessment of control effectiveness;</li>
    <li>Ongoing monitoring of organizationally-defined metrics in accordance with the continuous monitoring strategy;</li>
    <li>Correlation and analysis of information generated by control assessments and monitoring;</li>
    <li>Response actions to address results of the analysis of control assessment and monitoring information; and</li>
    <li>Reporting the security and privacy status of organizational systems to [Assignment: organization-defined personnel or roles] [Assignment: organization-defined frequency].</li>
</ol>', N'Supplemental C-SCRM Guidance: The continuous monitoring strategy and program should integrate C-SCRM controls at Levels 1, 2, and 3 in accordance with the Supply Chain Risk Management Strategy.

<br><br>Level(s): 1, 2, 3

<br><br>Related Controls: PM-30', N'Program Management', N'Continuous Monitoring Strategy', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4101, N'PM-32', N'Analyze [Assignment: organization-defined systems or systems components] supporting
mission essential services or functions to ensure that the information resources are being used consistent with their intended purpose.', N'Supplemental C-SCRM Guidance: Extending systems assigned to support specific mission or business functions beyond their initial purpose subjects those systems to unintentional risks, including cybersecurity risks throughout the supply chain. The application of this control should include the explicit incorporation of cybersecurity supply chain exposures. 
<br><br>Level(s): 2, 3', N'Program Management', N'Purposing', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 69, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4102, N'PS-1', N'<ol type="a">
    <li>
        Develop, document, and disseminate to [Assignment: organization-defined personnel or roles]:
        <ol>
            <li>
                [Selection (one or more): Organization-level; Mission/business process-level; System-level] personnel security policy that:
                <ol type="a">
                    <li>Addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and</li>
                    <li>Is consistent with applicable laws, executive orders, directives, regulations, policies, standards, and guidelines; and</li>
                </ol>
            </li>
            <li>Procedures to facilitate the implementation of the personnel security policy and the associated personnel security controls;</li>
        </ol>
    </li>
    <li>Designate an [Assignment: organization-defined official] to manage the development, documentation, and dissemination of the personnel security policy and procedures; and</li>
    <li>
        Review and update the current personnel security:
        <ol>
            <li>Policy [Assignment: organization-defined frequency] and following [Assignment: organization-defined events]; and</li>
            <li>Procedures [Assignment: organization-defined frequency] and following [Assignment: organization-defined events].</li>
        </ol>
    </li>
</ol>', N'<p>Supplemental C-SCRM Guidance: At each level, the personnel security policy and procedures and the related C-SCRM Strategy/Implementation Plan, C-SCRM Policies, and C-SCRM Plan(s) need to define the roles for the personnel who are engaged in the acquisi', N'Personnel Security', N'Personnel Security Policy and Procedures', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 67, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4103, N'PS-3', N'<ol type="a">
    <li>Screen individuals prior to authorizing access to the system; and</li>
    <li>Rescreen individuals in accordance with [Assignment: organization-defined conditions requiring rescreening and, where rescreening is so indicated, the frequency of rescreening].</li>
</ol>', N'Supplemental C-SCRM Guidance: To mitigate insider threat risk, personnel screening policies and procedures should be extended to any contractor personnel with authorized access to information systems, system components, or information system services. Continuous monitoring activities should be commensurate with the contractor’s level of access to sensitive, classified, or regulated information and should be consistent with broader enterprise policies. Screening requirements should be incorporated into agreements and flow down to sub-tier contractors.
<br><br>Level(s): 2, 3', N'Personnel Security', N'Personnel Screening', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 67, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4104, N'PS-6', N'<ol type="a">
    <li>Develop and document access agreements for organizational systems;</li>
    <li>Review and update the access agreements [Assignment: organization-defined frequency]; and</li>
    <li>
        Verify that individuals requiring access to organizational information and systems:
        <ol>
            <li>Sign appropriate access agreements prior to being granted access; and</li>
            <li>Re-sign access agreements to maintain access to organizational systems when access agreements have been updated or [Assignment: organization-defined frequency].</li>
        </ol>
    </li>
</ol>', N'<p>Supplemental C-SCRM Guidance: The enterprise should define and document access agreements for all contractors or other external personnel who may need to access the enterprise’s data, systems, or network, whether physically or logically. Access agreeme', N'Personnel Security', N'Access Agreements', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 67, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4105, N'PS-7', N'<ol type="a">
    <li>Establish personnel security requirements, including security roles and responsibilities for external providers;</li>
    <li>Require external providers to comply with personnel security policies and procedures established by the organization;</li>
    <li>Document personnel security requirements;</li>
    <li>Require external providers to notify [Assignment: organization-defined personnel or roles] of any personnel transfers or terminations of external personnel who possess organizational credentials and/or badges, or who have system privileges within [Assignment: organization-defined time period]; and</li>
    <li>Monitor provider compliance with personnel security requirements.</li>
</ol>', N'Supplemental C-SCRM Guidance: Third-party personnel who have access to the enterprise’s information systems and networks must meet the same personnel security requirements as enterprise personnel. Examples of such third-party personnel can include the system integrator, developer, supplier, external service provider used for delivery, contractors or service providers who are using the ICT/OT systems, or supplier maintenance personnel brought in to address component technical issues not solvable by the enterprise or system integrator.
<br><br>Level(s): 2', N'Personnel Security', N'External Personnel Security', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 67, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4106, N'PT-1', N'<ol type="a">
    <li>
        Develop, document, and disseminate to [Assignment: organization-defined personnel or roles]:
        <ol>
            <li>
                [Selection (one or more): Organization-level; Mission/business process-level; System-level] personally identifiable information processing and transparency policy that:
                <ol type="a">
                    <li>Addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and</li>
                    <li>Is consistent with applicable laws, executive orders, directives, regulations, policies, standards, and guidelines; and</li>
                </ol>
            </li>
            <li>Procedures to facilitate the implementation of the personally identifiable information processing and transparency policy and the associated personally identifiable information processing and transparency controls;</li>
        </ol>
    </li>
    <li>Designate an [Assignment: organization-defined official] to manage the development, documentation, and dissemination of the personally identifiable information processing and transparency policy and procedures; and</li>
    <li>
        Review and update the current personally identifiable information processing and transparency:
        <ol>
            <li>Policy [Assignment: organization-defined frequency] and following [Assignment: organization-defined events]; and</li>
            <li>Procedures [Assignment: organization-defined frequency] and following [Assignment: organization-defined events].</li>
        </ol>
    </li>
</ol>', N'<p>Supplemental C-SCRM Guidance: Enterprises should ensure that supply chain concerns are included in PII processing and transparency policies and procedures, as well as the related C-SCRM Strategy/Implementation Plan, C-SCRM Policies, and C-SCRM Plan. Th', N'Personally Identifiable Information Processing and Transparency', N'Personally Identifiable Information Processing and Transparency Policy and Procedures', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 1086, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4107, N'RA-1', N'<ol type="a">
    <li>
        Develop, document, and disseminate to [Assignment: organization-defined personnel or roles]:
        <ol>
            <li>
                [Selection (one or more): Organization-level; Mission/business process-level; System-level] risk assessment policy that:
                <ol type="a">
                    <li>Addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and</li>
                    <li>Is consistent with applicable laws, executive orders, directives, regulations, policies, standards, and guidelines; and</li>
                </ol>
            </li>
            <li>Procedures to facilitate the implementation of the risk assessment policy and the associated risk assessment controls;</li>
        </ol>
    </li>
    <li>Designate an [Assignment: organization-defined official] to manage the development, documentation, and dissemination of the risk assessment policy and procedures; and</li>
    <li>
        Review and update the current risk assessment:
        <ol>
            <li>Policy [Assignment: organization-defined frequency] and following [Assignment: organization-defined events]; and</li>
            <li>Procedures [Assignment: organization-defined frequency] and following [Assignment: organization-defined events].</li>
        </ol>
    </li>
</ol>', N'Supplemental C-SCRM Guidance: Risk assessments should be performed at the enterprise, mission/program, and operational levels. The system-level risk assessment should include both the supply chain infrastructure (e.g., development and testing environments and delivery systems) and the information system/components traversing the supply chain. System-level risk assessments significantly intersect with the SDLC and should complement the enterprise’s broader RMF activities, which take part during the SDLC. A criticality analysis will ensure that mission-critical functions and components are given higher priority due to their impact on the mission, if compromised. The policy should include supply chain-relevant cybersecurity roles that are applicable to performing and coordinating risk assessments across the enterprise (see Section 2 for the listing and description of roles). Applicable roles within suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers should be defined.

<br><br>Level(s): 1, 2, 3', N'Risk Assessment', N'Risk Assessment Policy and Procedures', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 70, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4108, N'RA-2', N'<ol type="a">
    <li>Categorize the system and information it processes, stores, and transmits;</li>
    <li>Document the security categorization results, including supporting rationale, in the security plan for the system; and</li>
    <li>Verify that the authorizing official or authorizing official designated representative reviews and approves the security categorization decision.</li>
</ol>', N'Supplemental C-SCRM Guidance: Security categorization is critical to C-SCRM at Levels 1, 2, and 3. In addition to [FIPS199] categorization, security categorization for C-SCRM should be based on the criticality analysis that is performed as part of the SDLC. See Section 2 and [IR8179] for a detailed description of criticality analysis.

<br><br>Level(s): 1, 2, 3

<br><br>Related Controls: RA-9', N'Risk Assessment', N'Security Categorization', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 70, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4109, N'RA-3', N'<ol type="a">
    <li>
        Conduct a risk assessment, including:
        <ol>
            <li>Identifying threats to and vulnerabilities in the system;</li>
            <li>Determining the likelihood and magnitude of harm from unauthorized access, use, disclosure, disruption, modification, or destruction of the system, the information it processes, stores, or transmits, and any related information; and</li>
            <li>Determining the likelihood and impact of adverse effects on individuals arising from the processing of personally identifiable information;</li>
        </ol>
    </li>
    <li>Integrate risk assessment results and risk management decisions from the organization and mission or business process perspectives with system-level risk assessments;</li>
    <li>Document risk assessment results in [Selection: security and privacy plans; risk assessment report; [Assignment: organization-defined document]];</li>
    <li>Review risk assessment results [Assignment: organization-defined frequency];</li>
    <li>Disseminate risk assessment results to [Assignment: organization-defined personnel or roles]; and</li>
    <li>Update the risk assessment [Assignment: organization-defined frequency] or when there are significant changes to the system, its environment of operation, or other conditions that may impact the security or privacy state of the system.</li>
</ol>', N'Supplemental C-SCRM Guidance: Risk assessments completed across the enterprise should include context from supply chain risk assessment results. Holistic consideration of supply chain risks in conjunction with other enterprise risks is a critical success factor of the organizations effort to manage risk to organizational operations and assets, individuals, other organizations, and the Nation.
<br><br>Level(s): 1, 2, 3', N'Risk Assessment', N'Risk Assessment', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 70, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4110, N'RA-3(1)', N'<ol type="a">
    <li>Assess supply chain risks associated with [Assignment: organization-defined systems, system components, and system services]; and</li>
    <li>Update the supply chain risk assessment [Assignment: organization-defined frequency], when there are significant changes to the relevant supply chain, or when changes to the system, environments of operation, or other conditions may necessitate a change in the supply chain.</li>
</ol>', N'Supplemental C-SCRM Guidance: Supply Chain Risk Assessments are a critical activity that focuses on assessing cybersecurity risks that arise from suppliers, their supply chains, their products, and their services. Supply Chain Risk assessments should include an analysis of criticality, threats, vulnerabilities, likelihood, and impact, as described in detail in Appendix G. The data to be reviewed and collected includes C-SCRM-specific roles, processes, and the results of system/component and services acquisitions, implementation, and integration. Supply Chain Risk assessments should be performed at Levels 1, 2, and 3. Risk assessments at higher levels should consist primarily of a synthesis of various risk assessments performed at lower levels and used for understanding the overall impact with the level (e.g., at the enterprise or mission/function levels). Supply Chain Risk assessments should complement and inform risk assessments, which are performed as ongoing activities throughout the SDLC, and processes should be appropriately aligned with or integrated into ERM processes and governance. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors.
<br><br>Level(s): 1, 2, 3', N'Risk Assessment', N'Risk Assessment', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 70, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4111, N'RA-5', N'<ol type="a">
    <li>
        Monitor and scan for vulnerabilities in the system and hosted applications [Assignment: organization-defined frequency and/or randomly in accordance with organization-defined process] and when new vulnerabilities potentially affecting the system are identified and reported;
    </li>
    <li>
        Employ vulnerability monitoring tools and techniques that facilitate interoperability among tools and automate parts of the vulnerability management process by using standards for:
        <ol>
            <li>Enumerating platforms, software flaws, and improper configurations;</li>
            <li>Formatting checklists and test procedures; and</li>
            <li>Measuring vulnerability impact;</li>
        </ol>
    </li>
    <li>Analyze vulnerability scan reports and results from vulnerability monitoring;</li>
    <li>Remediate legitimate vulnerabilities [Assignment: organization-defined response times] in accordance with an organizational assessment of risk;</li>
    <li>Share information obtained from the vulnerability monitoring process and control assessments with [Assignment: organization-defined personnel or roles] to help eliminate similar vulnerabilities in other systems; and</li>
    <li>Employ vulnerability monitoring tools that include the capability to readily update the vulnerabilities to be scanned.</li>
</ol>', N'<p>Supplemental C-SCRM Guidance: Vulnerability monitoring should cover suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers in the enterprise’s supply chain. This includes employing data', N'Risk Assessment', N'Vulnerability Monitoring and Scanning', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 70, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4112, N'RA-5(3)', N'Define the breadth and depth of vulnerability scanning coverage.', N'Supplemental C-SCRM Guidance: Enterprises that monitor the supply chain for vulnerabilities should express the breadth of monitoring based on the criticality and/or risk profile of the supplier or product/component and the depth of monitoring based on the level of the supply chain at which the monitoring takes place (e.g., sub-supplier). Where possible, a component inventory (e.g., hardware, software) may aid enterprises in capturing the breadth and depth of the products/components within their supply chain that may need to be monitored and scanned for vulnerabilities.
<br><br>Level(s): 2, 3', N'Risk Assessment', N'Vulnerability Monitoring and Scanning', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 70, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4113, N'RA-5(6)', N'Compare the results of multiple vulnerability scans using [Assignment: organization-defined automated mechanisms].', N'Supplemental C-SCRM Guidance: Enterprises should track trends in vulnerabilities to components within the supply chain over time. This information may help enterprises develop procurement strategies that reduce risk exposure density within the supply chain.
<br><br>Level(s): 2, 3', N'Risk Assessment', N'Vulnerability Monitoring and Scanning', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 70, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4114, N'RA-7', N'Respond to findings from security and privacy assessments, monitoring, and audits in
accordance with organizational risk tolerance.', N'Supplemental C-SCRM Guidance: Enterprises should integrate capabilities to respond to cybersecurity risks throughout the supply chain into the enterprise’s overall response posture, ensuring that these responses are aligned to and fall within the boundaries of the enterprise’s tolerance for risk. Risk response should include consideration of risk response identification, evaluation of alternatives, and risk response decision activities.
<br><br>Level(s): 1, 2, 3', N'Risk Assessment', N'Risk Response', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 70, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4115, N'RA-9', N'Identify critical system components and functions by performing a criticality analysis for
[Assignment: organization-defined systems, system components, or system services] at
[Assignment: organization-defined decision points in the system development life cycle].', N'Supplemental C-SCRM Guidance: Enterprises should complete a criticality analysis as a prerequisite input to assessments of cybersecurity supply chain risk management activities. First, enterprises should complete a criticality analysis as part of the Frame step of the C-SCRM Risk Management Process. Then, findings generated in the Assess step activities (e.g., criticality analysis, threat analysis, vulnerability analysis, and mitigation strategies) update and tailor the criticality analysis. A symbiotic relationship exists between the criticality analysis and other Assess step activities in that they inform and enhance one another. For a high-quality criticality analysis, enterprises should employ it iteratively throughout the SLDC and concurrently across the three levels. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Departments and agencies should also refer to Appendix F to supplement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.
<br><br>Level(s): 1, 2, 3', N'Risk Assessment', N'Criticality Analysis', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 70, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4116, N'RA-10', N'<ol type="a">
    <li>
        Establish and maintain a cyber threat hunting capability to:
        <ol>
            <li>Search for indicators of compromise in organizational systems; and</li>
            <li>Detect, track, and disrupt threats that evade existing controls;</li>
        </ol>
    </li>
    <li>Employ the threat hunting capability [Assignment: organization-defined frequency].</li>
</ol>', N'Supplemental C-SCRM Guidance: The C-SCRM threat hunting activities should supplement the enterprise’s internal threat hunting activities. As a critical part of the cybersecurity supply chain risk management process, enterprises should actively monitor for threats to their supply chain. This requires a collaborative effort between CSCRM and other cyber defense-oriented functions within the enterprise. Threat hunting capabilities may also be provided via a shared services enterprise, especially when an enterprise lacks the resources to perform threat hunting activities themselves. Typical activities include information sharing with peer enterprises and actively consuming threat intelligence sources (e.g., like those available from Information Assurance and Analysis Centers [ISAC[ and Information Assurance and Analysis Organizations [ISAO]). These activities can help identify and flag indicators of increased cybersecurity risks throughout the supply chain that may be of concern, such as cyber incidents, mergers and acquisitions, and Foreign Ownership, Control, or Influence (FOCI). Supply chain threat intelligence should seek out threats to the enterprise’s suppliers, as well as information systems, system components, and the raw inputs that they provide. The intelligence gathered enables enterprises to proactively identify and respond to threats emanating from the supply chain.
<br><br>Level(s): 1, 2, 3', N'Risk Assessment', N'Threat Hunting', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 70, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4117, N'SA-1', N'<ol type="a">
    <li>
        Develop, document, and disseminate to [Assignment: organization-defined personnel or roles]:
        <ol>
            <li>
                [Selection (one or more): Organization-level; Mission/business process-level; System-level] system and services acquisition policy that:
                <ol type="a">
                    <li>Addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and</li>
                    <li>Is consistent with applicable laws, executive orders, directives, regulations, policies, standards, and guidelines; and</li>
                </ol>
            </li>
            <li>Procedures to facilitate the implementation of the system and services acquisition policy and the associated system and services acquisition controls;</li>
        </ol>
    </li>
    <li>Designate an [Assignment: organization-defined official] to manage the development, documentation, and dissemination of the system and services acquisition policy and procedures; and</li>
    <li>
        Review and update the current system and services acquisition:
        <ol>
            <li>Policy [Assignment: organization-defined frequency] and following [Assignment: organization-defined events]; and</li>
            <li>Procedures [Assignment: organization-defined frequency] and following [Assignment: organization-defined events].</li>
        </ol>
    </li>
</ol>', N'<p>Supplemental C-SCRM Guidance: The system and services acquisition policy and procedures should address C-SCRM throughout the acquisition management life cycle process, to include purchases made via charge cards. C-SCRM procurement actions and the resul', N'System and Services Acquisition', N'System and Services Acquisition Policy and Procedures', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4118, N'SA-2', N'<ol type="a">
    <li>Determine the high-level information security and privacy requirements for the system or system service in mission and business process planning;</li>
    <li>Determine, document, and allocate the resources required to protect the system or system service as part of the organizational capital planning and investment control process; and</li>
    <li>Establish a discrete line item for information security and privacy in organizational programming and budgeting documentation.</li>
</ol>', N'Supplemental C-SCRM Guidance: The enterprise should incorporate C-SCRM requirements when determining and establishing the allocation of resources.
<br><br>Level(s): 1, 2', N'System and Services Acquisition', N'Allocation of Resources', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4119, N'SA-3', N'<ol type="a">
    <li>Acquire, develop, and manage the system using [Assignment: organization-defined system development life cycle] that incorporates information security and privacy considerations;</li>
    <li>Define and document information security and privacy roles and responsibilities throughout the system development life cycle;</li>
    <li>Identify individuals having information security and privacy roles and responsibilities; and</li>
    <li>Integrate the organizational information security and privacy risk management process into system development life cycle activities.</li>
</ol>', N'Supplemental C-SCRM Guidance: There is a strong relationship between the SDLC and CSCRM activities. The enterprise should ensure that C-SCRM activities are integrated into the SDLC for both the enterprise and for applicable suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers. In addition to traditional SDLC activities, such as requirements and design, the SDLC includes activities such as inventory management, acquisition and procurement, and the logical delivery of systems and components. See Section 2 and Appendix C for further guidance on SDLC. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.
<br><br>Level(s): 1, 2, 3', N'System and Services Acquisition', N'System Development Life Cycle', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4120, N'SA-4', N'<p>Include the following requirements, descriptions, and criteria, explicitly or by reference, using [Selection (one or more): standardized contract language; [Assignment: organization-defined contract language]] in the acquisition contract for the system, system component, or system service:</p>
<ol type="a">
    <li>Security and privacy functional requirements;</li>
    <li>Strength of mechanism requirements;</li>
    <li>Security and privacy assurance requirements;</li>
    <li>Controls needed to satisfy the security and privacy requirements;</li>
    <li>Security and privacy documentation requirements;</li>
    <li>Requirements for protecting security and privacy documentation;</li>
    <li>Description of the system development environment and environment in which the system is intended to operate;</li>
    <li>Allocation of responsibility or identification of parties responsible for information security, privacy, and supply chain risk management; and</li>
    <li>Acceptance criteria.</li>
</ol>', N'<p>Supplemental C-SCRM Guidance: Enterprises are to include C-SCRM requirements, descriptions, and criteria in applicable contractual agreements.</p>

<ol>
  <li>Enterprises are to establish baseline and tailorable C-SCRM requirements to apply and incorpo', N'System and Services Acquisition', N'Acquisition Process', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4121, N'SA-4(5)', N'<p>Require the developer of the system, system component, or system service to:</p>
<ol type="a">
    <li>Deliver the system, component, or service with [Assignment: organization-defined security configurations] implemented; and</li>
    <li>Use the configurations as the default for any subsequent system, component, or service reinstallation or upgrade.</li>
</ol>', N'Supplemental C-SCRM Guidance: If an enterprise needs to purchase components, they need to ensure that the product specifications are “fit for purpose” and meet the enterprise’s requirements, whether purchasing directly from the OEM, channel partners, or a secondary market. 
<br><br>Level(s): 3', N'System and Services Acquisition', N'Acquisition Process', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4122, N'SA-4(7)', N'<ol type="a">
    <li>Limit the use of commercially provided information assurance and information assurance-enabled information technology products to those products that have been successfully evaluated against a National Information Assurance partnership (NIAP)-approved Protection Profile for a specific technology type, if such a profile exists; and</li>
    <li>Require, if no NIAP-approved Protection Profile exists for a specific technology type but a commercially provided information technology product relies on cryptographic functionality to enforce its security policy, that the cryptographic module is FIPS-validated or NSA-approved.</li>
</ol>', N'Supplemental C-SCRM Guidance: This control enhancement requires that the enterprise build, procure, and/or use U.S. Government protection profile-certified information assurance (IA) components when possible. NIAP certification can be achieved for OTS (COTS and GOTS).
<br><br>Level(s): 2, 3', N'System and Services Acquisition', N'Acquisition Process', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4123, N'SA-4(8)', N'Require the developer of the system, system component, or system service to produce a
plan for continuous monitoring of control effectiveness that is consistent with the
continuous monitoring program of the organization.', N'Supplemental C-SCRM Guidance: This control enhancement is relevant to CSCRM and plans for continuous monitoring of control effectiveness and should therefore be extended to suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers.
<br><br>Level(s): 2, 3', N'System and Services Acquisition', N'Acquisition Process', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4124, N'SA-5', N'<ol type="a">
    <li>
        Obtain or develop administrator documentation for the system, system component, or system service that describes:
        <ol>
            <li>Secure configuration, installation, and operation of the system, component, or service;</li>
            <li>Effective use and maintenance of security and privacy functions and mechanisms; and</li>
            <li>Known vulnerabilities regarding configuration and use of administrative or privileged functions;</li>
        </ol>
    </li>
    <li>
        Obtain or develop user documentation for the system, system component, or system service that describes:
        <ol>
            <li>User-accessible security and privacy functions and mechanisms and how to effectively use those functions and mechanisms;</li>
            <li>Methods for user interaction, which enables individuals to use the system, component, or service in a more secure manner and protect individual privacy; and</li>
            <li>User responsibilities in maintaining the security of the system, component, or service and privacy of individuals;</li>
        </ol>
    </li>
    <li>Document attempts to obtain system, system component, or system service documentation when such documentation is either unavailable or nonexistent and take [Assignment: organization-defined actions] in response; and</li>
    <li>Distribute documentation to [Assignment: organization-defined personnel or roles].</li>
</ol>', N'Supplemental C-SCRM Guidance: Information system documentation should include relevant C-SCRM concerns (e.g., C-SCRM plan). Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028 on Improving the Nation''s Cybersecurity.
<br><br>Level(s): 3', N'System and Services Acquisition', N'System Documentation', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4125, N'SA-8', N'Apply the following systems security and privacy engineering principles in the
specification, design, development, implementation, and modification of the system and system components: [Assignment: organization-defined systems security and privacy engineering principles].', N'<p>Supplemental C-SCRM Guidance: The following security engineering techniques are helpful for managing cybersecurity risks throughout the supply chain.</p>

<ol type="a">
  <li>Anticipate the maximum possible ways that the ICT/OT product or service can b', N'System and Services Acquisition', N'Security and Privacy Engineering Principles', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4126, N'SA-9(1)', N'<ol type="a">
    <li>Conduct an organizational assessment of risk prior to the acquisition or outsourcing of information security services; and</li>
    <li>Verify that the acquisition or outsourcing of dedicated information security services is approved by [Assignment: organization-defined personnel or roles].</li>
</ol>', N'Supplemental C-SCRM Guidance: See Appendices C and D. Departments and agencies should refer to Appendix E to implement guidance in accordance with FASCSA and Appendix F to implement guidance in accordance with Executive Order 14028 on Improving the Nation''s Cybersecurity.
<br><br>Level(s): 2, 3', N'System and Services Acquisition', N'External System Services', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4127, N'SA-9(3)', N'Establish, document, and maintain trust relationships with external service providers
based on the following requirements, properties, factors, or conditions: [Assignment: organization-defined security and privacy requirements, properties, factors, or conditions defining acceptable trust relationships].', N'<p>Supplemental C-SCRM Guidance: Relationships with providers should meet the following supply chain security requirements:</p>

<ol type="a">
  <li>The requirements definition is complete and reviewed for accuracy and completeness, including the assignme', N'System and Services Acquisition', N'External System Services', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4128, N'SA-9(4)', N'Take the following actions to verify that the interests of [Assignment: organization-defined external service providers] are consistent with and reflect organizational interests:
[Assignment: organization-defined actions].', N'Supplemental C-SCRM Guidance: In the context of this enhancement, “providers” may include suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers.
<br><br>Level(s): 3', N'System and Services Acquisition', N'External System Services', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4129, N'SA-9(5)', N'Restrict the location of [Selection (one or more): information processing; information or data; system services] to [Assignment: organization-defined locations] based on
[Assignment: organization-defined requirements or conditions].', N'Supplemental C-SCRM Guidance: The location may be under the control of the suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers. Enterprises should assess C-SCRM risks associated with a given geographic location and apply an appropriate risk response, which may include defining locations that are or are not acceptable and ensuring that appropriate protections are in place to address associated CSCRM risk.
<br><br>Level(s): 3', N'System and Services Acquisition', N'External System Services', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4130, N'SA-10', N'<p>Require the developer of the system, system component, or system service to:</p>
<ol type="a">
    <li>Perform configuration management during system, component, or service [Selection (one or more): design; development; implementation; operation; disposal];</li>
    <li>Document, manage, and control the integrity of changes to [Assignment: organization-defined configuration items under configuration management];</li>
    <li>Implement only organization-approved changes to the system, component, or service;</li>
    <li>Document approved changes to the system, component, or service and the potential security and privacy impacts of such changes; and</li>
    <li>Track security flaws and flaw resolution within the system, component, or service and report findings to [Assignment: organization-defined personnel].</li>
</ol>', N'Supplemental C-SCRM Guidance: Developer configuration management is critical for reducing cybersecurity risks throughout the supply chain. By conducting configuration management activities, developers reduce the occurrence and likelihood of flaws while increasing accountability and ownership for the changes. Developer configuration management should be performed both by developers internal to federal agencies and integrators or external service providers. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.

<br><br>Level(s): 2, 3

<br><br>Related Controls: SA-10 (1), (2), (3), (4), (5), and (6)', N'System and Services Acquisition', N'Developer Configuration Management', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4131, N'SA-11', N'<p>Require the developer of the system, system component, or system service, at all post-design stages of the system development life cycle, to:</p>
<ol type="a">
    <li>Develop and implement a plan for ongoing security and privacy control assessments;</li>
    <li>Perform [Selection (one or more): unit; integration; system; regression] testing/evaluation [Assignment: organization-defined frequency] at [Assignment: organization-defined depth and coverage];</li>
    <li>Produce evidence of the execution of the assessment plan and the results of the testing and evaluation;</li>
    <li>Implement a verifiable flaw remediation process; and</li>
    <li>Correct flaws identified during testing and evaluation.</li>
</ol>', N'Supplemental C-SCRM Guidance: Depending on the origins of components, this control may be implemented differently. For OTS (off-the-shelf) components, the acquirer should conduct research (e.g., via publicly available resources) or request proof to determine whether the supplier (OEM) has performed such testing as part of their quality or security processes. When the acquirer has control over the application and development processes, they should require this testing as part of the SDLC. In addition to the specific types of testing activities described in the enhancements, examples of CSCRM-relevant testing include testing for counterfeits, verifying the origins of components, examining configuration settings prior to integration, and testing interfaces. These types of tests may require significant resources and should be prioritized based on criticality, threat, and vulnerability analyses (described in Section 2 and Appendix C), as well as the effectiveness of testing techniques. Enterprises may also require third-party testing as part of developer security testing. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.

<br><br>Level(s): 1, 2, 3

<br><br>Related Controls: SA-11 (1), (2), (3), (4), (5), (6), (7), (8), and (9)', N'System and Services Acquisition', N'Developer Testing and Evaluation', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4132, N'SA-15', N'<ol type="a">
    <li>
        Require the developer of the system, system component, or system service to follow a documented development process that:
        <ol>
            <li>Explicitly addresses security and privacy requirements;</li>
            <li>Identifies the standards and tools used in the development process;</li>
            <li>Documents the specific tool options and tool configurations used in the development process; and</li>
            <li>Documents, manages, and ensures the integrity of changes to the process and/or tools used in development; and</li>
        </ol>
    </li>
    <li>Review the development process, standards, tools, tool options, and tool configurations [Assignment: organization-defined frequency] to determine if the process, standards, tools, tool options and tool configurations selected and employed can satisfy the following security and privacy requirements: [Assignment: organization-defined security and privacy requirements].</li>
</ol>', N'Supplemental C-SCRM Guidance: Providing documented and formalized development processes to guide internal and system integrator developers is critical to the enterprise’s efforts to effectively mitigate cybersecurity risks throughout the supply chain. The enterprise should apply national and international standards and best practices when implementing this control. Using existing standards promotes consistency of implementation, reliable and defendable processes, and interoperability. The enterprise’s development, maintenance, test, and deployment environments should all be covered by this control. The tools included in this control can be manual or automated. The use of automated tools aids thoroughness, efficiency, and the scale of analysis that helps address cybersecurity risks that arise in relation to the development process throughout the supply chain. Additionally, the output of such activities and tools provides useful inputs for C-SCRM processes, as described in Section 2 and Appendix C. This control has applicability to the internal enterprise’s processes, information systems, and networks as well as applicable system integrators’ processes, systems, and networks. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity. 

<br><br>Level(s): 2, 3

<br><br>Related Controls: SA-15 enhancements (1), (2), (5), (6), and (7)', N'System and Services Acquisition', N'Development Process, Standards, and Tools', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4133, N'SA-15(3)', N'<p>Require the developer of the system, system component, or system service to perform a criticality analysis:</p>
<ol type="a">
    <li>At the following decision points in the system development life cycle: [Assignment: organization-defined decision points in the system development life cycle]; and</li>
    <li>At the following level of rigor: [Assignment: organization-defined breadth and depth of criticality analysis].</li>
</ol>', N'Supplemental C-SCRM Guidance: This enhancement identifies critical components within the information system, which will help determine the specific C-SCRM activities to be implemented for critical components. See CSCRM Criticality Analysis described in Appendix C for additional context.
<br><br>Level(s): 2, 3', N'System and Services Acquisition', N'Development Process, Standards, and Tools', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4134, N'SA-15(8)', N'Require the developer of the system, system component, or system service to use threat
modeling and vulnerability analyses from similar systems, components, or services to
inform the current development process.', N'Supplemental C-SCRM Guidance: This enhancement encourages developers to reuse the threat and vulnerability information produced by prior development efforts and lessons learned from using the tools to inform ongoing development efforts. Doing so will help determine the C-SCRM activities described in Section 2 and Appendix C.
<br><br>Level(s): 3', N'System and Services Acquisition', N'Development Process, Standards, and Tools', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4135, N'SA-16', N'Require the developer of the system, system component, or system service to provide
the following training on the correct use and operation of the implemented security and privacy functions, controls, and/or mechanisms: [Assignment: organization-defined training].', N'Supplemental C-SCRM Guidance: Developer-provided training for external and internal developers is critical to C-SCRM. It addresses training the individuals responsible for federal systems and networks to include applicable development environments. Developer-provided training in this control also applies to the individuals who select system and network components. Developer-provided training should include C-SCRM material to ensure that 1) developers are aware of potential threats and vulnerabilities when developing, testing, and maintaining hardware and software, and 2) the individuals responsible for selecting system and network components incorporate CSCRM when choosing such components. Developer training should also cover training for secure coding and the use of tools to find vulnerabilities in software. Refer to Appendix F for additional guidance on security for critical software.

<br><br>Level(s): 2, 3

<br><br>Related Controls: AT-3', N'System and Services Acquisition', N'Developer-Provided Training', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4136, N'SA-17', N'<p>Require the developer of the system, system component, or system service to produce a design specification and security and privacy architecture that:</p>
<ol type="a">
    <li>Is consistent with the organization’s security and privacy architecture that is an integral part of the organization’s enterprise architecture;</li>
    <li>Accurately and completely describes the required security and privacy functionality, and the allocation of controls among physical and logical components; and</li>
    <li>Expresses how individual security and privacy functions, mechanisms, and services work together to provide required security and privacy capabilities and a unified approach to protection.</li>
</ol>', N'Supplemental C-SCRM Guidance: This control facilitates the use of C-SCRM information to influence system architecture, design, and component selection decisions, including security functions. Examples include identifying components that compose system architecture and design or selecting specific components to ensure availability through multiple supplier or component selections. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028 on Improving the Nation''s Cybersecurity.

<br><br>Level(s): 2, 3

<br><br>Related Controls: SA-17 (1) and (2)', N'System and Services Acquisition', N'Developer Security and Privacy Architecture and Design', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4137, N'SA-20', N'Reimplement or custom develop the following critical system components:
[Assignment: organization-defined critical system components].', N'Supplemental C-SCRM Guidance: The enterprise may decide, based on their assessments of cybersecurity risks throughout the supply chain, that they require customized development of certain critical components. This control provides additional guidance on this activity. Enterprises should work with suppliers and partners to ensure that critical components are identified. Organizations should ensure that they have a continued ability to maintain custom-developed critical software components. For example, having the source code, build scripts, and tests for a software component could enable an organization to have someone else maintain it if necessary.
<br><br>Level(s): 2, 3', N'System and Services Acquisition', N'Customized Developent of Critical Components', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4138, N'SA-21', N'<p>Require that the developer of [Assignment: organization-defined system, system component, or system service]:</p>
<ol type="a">
    <li>Has appropriate access authorizations as determined by assigned [Assignment: organization-defined official government duties]; and</li>
    <li>Satisfies the following additional personnel screening criteria: [Assignment: organization-defined additional personnel screening criteria].</li>
</ol>', N'Supplemental C-SCRM Guidance: The enterprise should implement screening processes for their internal developers. For system integrators who may be providing key developers that address critical components, the enterprise should ensure that appropriate processes for developer screening have been used. The screening of developers should be included as a contractual requirement and be a flow-down requirement to relevant sub-level subcontractors who provide development services or who have access to the development environment.
<br><br>Level(s): 2, 3', N'System and Services Acquisition', N'Developer Screening', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4139, N'SA-22', N'<ol type="a">
    <li>Replace system components when support for the components is no longer available from the developer, vendor, or manufacturer; or</li>
    <li>Provide the following options for alternative sources for continued support for unsupported components [Selection (one or more): in-house support; [Assignment: organization-defined support from external providers]].</li>
</ol>', N'<p>Supplemental C-SCRM Guidance: Acquiring products directly from qualified original equipment manufacturers (OEMs) or their authorized distributors and resellers reduces cybersecurity risks in the supply chain. In the case of unsupported system component', N'System and Services Acquisition', N'Unsupported System Components', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 48, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4140, N'SC-1', N'<ol type="a">
    <li>
        Develop, document, and disseminate to [Assignment: organization-defined personnel or roles]:
        <ol>
            <li>
                [Selection (one or more): Organization-level; Mission/business process-level; System-level] system and communications protection policy that:
                <ol type="a">
                    <li>Addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and</li>
                    <li>Is consistent with applicable laws, executive orders, directives, regulations, policies, standards, and guidelines; and</li>
                </ol>
            </li>
            <li>Procedures to facilitate the implementation of the system and communications protection policy and the associated system and communications protection controls;</li>
        </ol>
    </li>
    <li>Designate an [Assignment: organization-defined official] to manage the development, documentation, and dissemination of the system and communications protection policy and procedures; and</li>
    <li>
        Review and update the current system and communications protection:
        <ol>
            <li>Policy [Assignment: organization-defined frequency] and following [Assignment: organization-defined events]; and</li>
            <li>Procedures [Assignment: organization-defined frequency] and following [Assignment: organization-defined events].</li>
        </ol>
    </li>
</ol>', N'Supplemental C-SCRM Guidance: System and communications protection policies and procedures should address cybersecurity risks throughout the supply chain in relation to the enterprise’s processes, systems, and networks. Enterprise-level and program-specific policies help establish and clarify these requirements, and corresponding procedures provide instructions for meeting these requirements. Policies and procedures should include the coordination of communications among and across multiple enterprise entities within the enterprise, as well as the communications methods, external connections, and processes used between the enterprise and its suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers.
<br><br>Level(s): 1, 2, 3', N'System and Communications Protection', N'System and Communications Protection Policy and Procedures', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 72, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4141, N'SC-4', N'Prevent unauthorized and unintended information transfer via shared system
resources.', N'Supplemental C-SCRM Guidance: The enterprise may share information system resources with system suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers. Protecting information in shared resources in support of various supply chain activities is challenging when outsourcing key operations. Enterprises may either share too much and increase their risk or share too little and make it difficult for suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers to be efficient in their service delivery. The enterprise should work with developers to define a structure or process for information sharing, including the data shared, the method of sharing, and to whom (the specific roles) the information is provided. Appropriate privacy, dissemination, handling, and clearance requirements should be accounted for in the information-sharing process.
<br><br>Level(s): 2, 3', N'System and Communications Protection', N'Information in Shared System Resources', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 72, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4142, N'SC-5(2)', N'Manage capacity, bandwidth, or other redundancy to limit the effects of information
flooding denial-of-service attacks.', N'Supplemental C-SCRM Guidance: The enterprise should include requirements for excess capacity, bandwidth, and redundancy into agreements with suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers.
<br><br>Level(s): 2', N'System and Communications Protection', N'Denial-of-Service Protection', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 72, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4143, N'SC-7', N'<ol type="a">
    <li>Monitor and control communications at the external managed interfaces to the system and at key internal managed interfaces within the system;</li>
    <li>Implement subnetworks for publicly accessible system components that are [Selection: physically; logically] separated from internal organizational networks; and</li>
    <li>Connect to external networks or systems only through managed interfaces consisting of boundary protection devices arranged in accordance with an organizational security and privacy architecture.</li>
</ol>', N'Supplemental C-SCRM Guidance: The enterprise should implement appropriate monitoring mechanisms and processes at the boundaries between the agency systems and suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers’ systems. Provisions for boundary protections should be incorporated into agreements with suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers. There may be multiple interfaces throughout the enterprise, supplier systems and networks, and the SDLC. Appropriate vulnerability, threat, and risk assessments should be performed to ensure proper boundary protections for supply chain components and supply chain information flow. The vulnerability, threat, and risk assessments can aid in scoping boundary protection to a relevant set of criteria and help manage associated costs. For contracts with external service providers, enterprises should ensure that the provider satisfies boundary control requirements pertinent to environments and networks within their span of control. Further detail is provided in Section 2 and Appendix C. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.
<br><br>Level(s): 2', N'System and Communications Protection', N'Boundary Protection', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 72, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4144, N'SC-7(13)', N'Isolate [Assignment: organization-defined information security tools, mechanisms, and support components] from other internal system components by implementing physically
separate subnetworks with managed interfaces to other components of the system.', N'Supplemental C-SCRM Guidance: The enterprise should provide separation and isolation of development, test, and security assessment tools and operational environments and relevant monitoring tools within the enterprise’s information systems and networks. This control applies the entity responsible for creating software and hardware, to include federal agencies and prime contractors. As such, this controls applies to the federal agency and applicable supplier information systems and networks. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. If a compromise or information leakage happens in any one environment, the other environments should still be protected through the separation and isolation mechanisms or techniques.

<br><br>Level(s): 3

<br><br>Related Controls: SR-3(3)', N'System and Communications Protection', N'Boundary Protection', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 72, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4145, N'SC-7(14)', N'Protect against unauthorized physical connections at [Assignment: organization-defined managed interfaces].', N'Supplemental C-SCRM Guidance: This control is relevant to C-SCRM as it applies to external service providers.

<br><br>Level(s): 2,3

<br><br>Related Controls: SR-3(3)', N'System and Communications Protection', N'Boundary Protection', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 72, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4146, N'SC-7(19)', N'Block inbound and outbound communications traffic between [Assignment: organization-defined communication clients] that are independently configured by end users and
external service providers.', N'Supplemental C-SCRM Guidance: This control is relevant to C-SCRM as it applies to external service providers.
<br><br>Level(s): 3', N'System and Communications Protection', N'Boundary Protection', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 72, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4147, N'SC-8', N'Protect the [Selection (one or more): confidentiality; integrity] of transmitted
information.', N'Supplemental C-SCRM Guidance: The requirements for transmission confidentiality and integrity should be integrated into agreements with suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers. Acquirers, suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers may repurpose existing security mechanisms (e.g., authentication, authorization, or encryption) to achieve enterprise confidentiality and integrity requirements. The degree of protection should be based on the sensitivity of information to be transmitted and the relationship between the enterprise and the suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.
<br><br>Level(s): 2, 3', N'System and Communications Protection', N'Transmission Confidentiality and Integrity', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 72, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4148, N'SC-18', N'<ol type="a">
    <li>Define acceptable and unacceptable mobile code and mobile code technologies; and</li>
    <li>Authorize, monitor, and control the use of mobile code within the system.</li>
</ol>', N'Supplemental C-SCRM Guidance: The enterprise should use this control in various applications of mobile code within their information systems and networks. Examples include acquisition processes such as the electronic transmission of supply chain information (e.g., email), the receipt of software components, logistics information management in RFID, or transport sensors infrastructure.
<br><br>Level(s): 3', N'System and Communications Protection', N'Mobile Code', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 72, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4149, N'SC-18(2)', N'Verify that the acquisition, development, and use of mobile code to be deployed in the
system meets [Assignment: organization-defined mobile code requirements].', N'', N'System and Communications Protection', N'Mobile Code', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 72, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4150, N'SC-27', N'Include within organizational systems the following platform independent applications:
[Assignment: organization-defined platform-independent applications].', N'Supplemental C-SCRM Guidance: The use of trustworthy platform-independent applications is essential to C-SCRM. The enhanced portability of platform-independent applications enables enterprises to switch external service providers more readily in the event that one becomes compromised, thereby reducing vendor-dependent cybersecurity risks. This is especially relevant for critical applications on which multiple systems may rely.
<br><br>Level(s): 2, 3', N'System and Communications Protection', N'Platform-Independent Applications', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 72, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4151, N'SC-28', N'Protect the [Selection (one or more): confidentiality; integrity] of the following
information at rest: [Assignment: organization-defined information at rest].', N'Supplemental C-SCRM Guidance: The enterprise should include provisions for the protection of information at rest into their agreements with suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers. The enterprise should also ensure that they provide appropriate protections within the information systems and networks for data at rest for the suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers information, such as source code, testing data, blueprints, and intellectual property information. This control should be applied throughout the SDLC, including during requirements, development, manufacturing, test, inventory management, maintenance, and disposal. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant subtier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.

<br><br>Level(s): 2, 3

<br><br>Related Controls: SR-3(3)', N'System and Communications Protection', N'Protection of Information at Rest', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 72, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4152, N'SC-29', N'Employ a diverse set of information technologies for the following system components
in the implementation of the system: [Assignment: organization-defined system components].', N'Supplemental C-SCRM Guidance: Heterogeneity techniques include the use of different operating systems, virtualization techniques, and multiple sources of supply. Multiple sources of supply can improve component availability and reduce the impact of a supply chain cybersecurity compromise. In case of a supply chain cybersecurity compromise, an alternative source of supply will allow the enterprises to more rapidly switch to an alternative system/component that may not be affected by the compromise. Additionally, heterogeneous components decrease the attack surface by limiting the impact to the subset of the infrastructure that is using vulnerable components.
<br><br>Level(s): 2, 3', N'System and Communications Protection', N'Heterogeneity', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 72, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4153, N'SC-30', N'Employ the following concealment and misdirection techniques for [Assignment: organization-defined systems] at [Assignment: organization-defined time periods] to confuse and mislead adversaries: [Assignment: organization-defined concealment and misdirection techniques].', N'Supplemental C-SCRM Guidance: Concealment and misdirection techniques for C-SCRM include the establishment of random resupply times, the concealment of location, randomly changing the fake location used, and randomly changing or shifting information storage into alternative servers or storage mechanisms.
<br><br>Level(s): 2, 3', N'System and Communications Protection', N'Concealment and Misdirection', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 72, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4154, N'SC-30(2)', N'Employ [Assignment: organization-defined techniques] to introduce randomness into
organizational operations and assets.', N'Supplemental C-SCRM Guidance: Supply chain processes are necessarily structured with predictable, measurable, and repeatable processes for the purpose of efficiency and cost reduction. This opens up the opportunity for potential breach. In order to protect against compromise, the enterprise should employ techniques to introduce randomness into enterprise operations and assets in the enterprise’s systems or networks (e.g., randomly switching among several delivery enterprises or routes, or changing the time and date of receiving supplier software updates if previously predictably scheduled). 
<br><br>Level(s): 2, 3', N'System and Communications Protection', N'Concealment and Misdirection', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 72, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4155, N'SC-30(3)', N'Change the location of [Assignment: organization-defined processing and/or storage]
[Selection: [Assignment: organization-defined time frequency]; at random time intervals]].', N'Supplemental C-SCRM Guidance: Changes in processing or storage locations can be used to protect downloads, deliveries, or associated supply chain metadata. The enterprise may leverage such techniques within their information systems and networks to create uncertainty about the activities targeted by adversaries. Establishing a few process changes and randomizing their use – whether it is for receiving, acceptance testing, storage, or other supply chain activities – can aid in reducing the likelihood of a supply chain event.
<br><br>Level(s): 2, 3', N'System and Communications Protection', N'Concealment and Misdirection', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 72, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4156, N'SC-30(4)', N'Employ realistic, but misleading information in [Assignment: organization-defined system components] about its security state or posture.', N'Supplemental C-SCRM Guidance: The enterprise can convey misleading information as part of concealment and misdirection efforts to protect the information system being developed and the enterprise’s systems and networks. Examples of such efforts in security include honeynets or virtualized environments. Implementations can be leveraged to convey misleading information. These may be considered advanced techniques that require experienced resources to effectively implement them. If an enterprise decides to use honeypots, it should be done in concert with legal counsel or following the enterprise’s policies.
<br><br>Level(s): 2, 3', N'System and Communications Protection', N'Concealment and Misdirection', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 72, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4157, N'SC-30(5)', N'Employ the following techniques to hide or conceal [Assignment: organization-defined system components]: [Assignment: organization-defined techniques].', N'Supplemental C-SCRM Guidance: The enterprise may employ various concealment and misdirection techniques to protect information about the information system being developed and the enterprise’s information systems and networks. For example, the delivery of critical components to a central or trustworthy third-party depot can be used to conceal or misdirect any information regarding the component’s use or the enterprise using the component. Separating components from their associated information into differing physical and electronic delivery channels and obfuscating the information through various techniques can be used to conceal information and reduce the opportunity for a potential loss of confidentiality of the component or its use, condition, or other attributes.
<br><br>Level(s): 2, 3', N'System and Communications Protection', N'Concealment and Misdirection', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 72, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4158, N'SC-36', N'Distribute the following processing and storage components across multiple [Selection: physical locations; logical domains]: [Assignment: organization-defined processing and storage components].', N'Supplemental C-SCRM Guidance: Processing and storage can be distributed both across the enterprise’s systems and networks and across the SDLC. The enterprise should ensure that these techniques are applied in both contexts. Development, manufacturing, configuration management, test, maintenance, and operations can use distributed processing and storage. This control applies to the entity responsible for processing and storage functions or related infrastructure, to include federal agencies and contractors. As such, this control applies to the federal agency and applicable supplier information systems and networks. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant subtier contractors.

<br><br>Level(s): 2, 3

<br><br>Related Controls: SR-3(3)', N'System and Communications Protection', N'Distributed Processing and Storage', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 72, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4159, N'SC-37(1)', N'Employ [Assignment: organization-defined controls] to ensure that only [Assignment: organization-defined individuals or systems] receive the following information, system
components, or devices: [Assignment: organization-defined information, system components, or devices].', N'Supplemental C-SCRM Guidance: The enterprise should employ security safeguards to ensure that only specific individuals or information systems receive the information about the information system or its development environment and processes. For example, proper credentialing and authorization documents should be requested and verified prior to the release of critical components, such as custom chips, custom software, or information during delivery.
<br><br>Level(s): 2, 3', N'System and Communications Protection', N'Out-of-Band Channels', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 72, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4160, N'SC-38', N'Employ the following operations security controls to protect key organizational
information throughout the system development life cycle: [Assignment: organization-defined operations security controls].', N'Supplemental C-SCRM Guidance: The enterprise should ensure that appropriate supply chain threat and vulnerability information is obtained from and provided to the applicable operational security processes.

<br><br>Level(s): 2, 3 

Related Control(s): SR-7', N'System and Communications Protection', N'Operations Security', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 72, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4161, N'SC-47', N'Establish [Assignment: organization-defined alternate communications paths] for
system operations organizational command and control.', N'Supplemental C-SCRM Guidance: If necessary and appropriate, suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers should be included in the alternative communication paths described in this control.
<br><br>Level(s): 1, 2, 3', N'System and Communications Protection', N'Alternate Communications Path', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 72, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4162, N'SI-1', N'<ol type="a">
    <li>
        Develop, document, and disseminate to [Assignment: organization-defined personnel or roles]:
        <ol>
            <li>
                [Selection (one or more): Organization-level; Mission/business process-level; System-level] system and information integrity policy that:
                <ol type="a">
                    <li>Addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and</li>
                    <li>Is consistent with applicable laws, executive orders, directives, regulations, policies, standards, and guidelines; and</li>
                </ol>
            </li>
            <li>Procedures to facilitate the implementation of the system and information integrity policy and the associated system and information integrity controls;</li>
        </ol>
    </li>
    <li>Designate an [Assignment: organization-defined official] to manage the development, documentation, and dissemination of the system and information integrity policy and procedures; and</li>
    <li>
        Review and update the current system and information integrity:
        <ol>
            <li>Policy [Assignment: organization-defined frequency] and following [Assignment: organization-defined events]; and</li>
            <li>Procedures [Assignment: organization-defined frequency] and following [Assignment: organization-defined events].</li>
        </ol>
    </li>
</ol>', N'Supplemental C-SCRM Guidance: The enterprise should include C-SCRM in system and information integrity policy and procedures, including ensuring that program-specific requirements for employing various integrity verification tools and techniques are clearly defined. System and information integrity for information systems, components, and the underlying information systems and networks is critical for managing cybersecurity risks throughout the supply chain. The insertion of malicious code and counterfeits are two primary examples of cybersecurity risks throughout the supply chain, both of which can be at least partially addressed by deploying system and information integrity controls.

<br><br>Level(s): 1, 2, 3

<br><br>Related Controls: SR-1, 9, 10, 11', N'System And Information Integrity', N'System and Information Integrity Policy and Procedures', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 73, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4163, N'SI-2', N'<ol type="a">
    <li>Identify, report, and correct system flaws;</li>
    <li>Test software and firmware updates related to flaw remediation for effectiveness and potential side effects before installation;</li>
    <li>Install security-relevant software and firmware updates within [Assignment: organization-defined time period] of the release of the updates; and</li>
    <li>Incorporate flaw remediation into the organizational configuration management process.</li>
</ol>', N'Supplemental C-SCRM Guidance: The output of flaw remediation activities provides useful input into the ICT/OT SCRM processes described in Section 2 and Appendix C. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors.
<br><br>Level(s): 2, 3', N'System And Information Integrity', N'Flaw Remediation', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 73, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4164, N'SI-2(5)', N'Install [Assignment: organization-defined security-relevant software and firmware updates] automatically to [Assignment: organization-defined system components].', N'Supplemental C-SCRM Guidance: The enterprise should specify the various software assets within its information systems and networks that require automated updates (both indirect and direct). This specification of assets should be defined from criticality analysis results, which provide information on critical and non-critical functions and components (see Section 2 and Appendix C). A centralized patch management process may be employed for evaluating and managing updates prior to deployment. Those software assets that require direct updates from a supplier should only accept updates that originate directly from the OEM unless specifically deployed by the acquirer, such as with a centralized patch management process. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity. Level(s): 2', N'System And Information Integrity', N'Flaw Remediation', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 73, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4165, N'SI-3', N'<ol type="a">
    <li>Implement [Selection (one or more): signature based; non-signature based] malicious code protection mechanisms at system entry and exit points to detect and eradicate malicious code;</li>
    <li>Automatically update malicious code protection mechanisms as new releases are available in accordance with organizational configuration management policy and procedures;</li>
    <li>
        Configure malicious code protection mechanisms to:
        <ol>
            <li>Perform periodic scans of the system [Assignment: organization-defined frequency] and real-time scans of files from external sources at [Selection (one or more): endpoint; network entry and exit points] as the files are downloaded, opened, or executed in accordance with organizational policy; and</li>
            <li>[Selection (one or more): block malicious code; quarantine malicious code; take [Assignment: organization-defined action]]; and send alert to [Assignment: organization-defined personnel or roles] in response to malicious code detection; and</li>
        </ol>
    </li>
    <li>Address the receipt of false positives during malicious code detection and eradication and the resulting potential impact on the availability of the system.</li>
</ol>', N'Supplemental C-SCRM Guidance: Because the majority of code operated in federal systems is not developed by the Federal Government, malicious code threats often originate from the supply chain. This controls applies to the federal agency and contractors with code-related responsibilities (e.g., developing code, installing patches, performing system upgrades, etc.), as well as applicable contractor information systems and networks. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.

<br><br>Level(s): 2, 3 

<br><br>Related Controls: SA-11; SI-7(15); SI-3(4), (6), (8), and (10); SR-3(3)', N'System And Information Integrity', N'Malicious Code Protection', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 73, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4166, N'SI-4', N'<ol type="a">
    <li>
        Monitor the system to detect:
        <ol>
            <li>Attacks and indicators of potential attacks in accordance with the following monitoring objectives: [Assignment: organization-defined monitoring objectives]; and</li>
            <li>Unauthorized local, network, and remote connections;</li>
        </ol>
    </li>
    <li>Identify unauthorized use of the system through the following techniques and methods: [Assignment: organization-defined techniques and methods];</li>
    <li>
        Invoke internal monitoring capabilities or deploy monitoring devices:
        <ol>
            <li>Strategically within the system to collect organization-determined essential information; and</li>
            <li>At ad hoc locations within the system to track specific types of transactions of interest to the organization;</li>
        </ol>
    </li>
    <li>Analyze detected events and anomalies;</li>
    <li>Adjust the level of system monitoring activity when there is a change in risk to organizational operations and assets, individuals, other organizations, or the Nation;</li>
    <li>Obtain legal opinion regarding system monitoring activities; and</li>
    <li>Provide [Assignment: organization-defined system monitoring information] to [Assignment: organization-defined personnel or roles] [Selection (one or more): as needed; [Assignment: organization-defined frequency]].</li>
</ol>', N'Supplemental C-SCRM Guidance: This control includes monitoring vulnerabilities that result from past supply chain cybersecurity compromises, such as malicious code implanted during software development and set to activate after deployment. System monitoring is frequently performed by external service providers. Service-level agreements with these providers should be structured to appropriately reflect this control. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.
<br><br>Level(s): 1, 2, 3', N'System And Information Integrity', N'System Monitoring', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 73, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4167, N'SI-4(17)', N'Correlate information from monitoring physical, cyber, and supply chain activities to
achieve integrated, organization-wide situational awareness.', N'Supplemental C-SCRM Guidance: System monitoring information may be correlated with that of suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers, if appropriate. The results of correlating monitoring information may point to supply chain cybersecurity vulnerabilities that require mitigation or compromises.
<br><br>Level(s): 2, 3', N'System And Information Integrity', N'System Monitoring', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 73, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4168, N'SI-4(19)', N'Implement [Assignment: organization-defined additional monitoring] of individuals who
have been identified by [Assignment: organization-defined sources] as posing an increased
level of risk.', N'Supplemental C-SCRM Guidance: Persons identified as being of higher risk may include enterprise employees, contractors, and other third parties (e.g., volunteers, visitors) who may have the need or ability to access to an enterprise’s system, network, or system environment. The enterprise may implement enhanced oversight of these higher-risk individuals in accordance with policies, procedures, and — if relevant — terms of an agreement and in coordination with appropriate officials.
<br><br>Level(s): 2, 3', N'System And Information Integrity', N'System Monitoring', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 73, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4169, N'SI-5', N'<ol type="a">
    <li>Receive system security alerts, advisories, and directives from [Assignment: organization-defined external organizations] on an ongoing basis;</li>
    <li>Generate internal security alerts, advisories, and directives as deemed necessary;</li>
    <li>Disseminate security alerts, advisories, and directives to: [Selection (one or more): [Assignment: organization-defined personnel or roles]; [Assignment: organization-defined elements within the organization]; [Assignment: organization-defined external organizations]]; and</li>
    <li>Implement security directives in accordance with established time frames, or notify the issuing organization of the degree of noncompliance.</li>
</ol>', N'Supplemental C-SCRM Guidance: The enterprise should evaluate security alerts, advisories, and directives for cybersecurity supply chain impacts and follow up if needed. US-CERT, FASC, and other authoritative entities generate security alerts and advisories that are applicable to C-SCRM. Additional laws and regulations will impact who and how additional advisories are provided. Enterprises should ensure that their information-sharing protocols and processes include sharing alerts, advisories, and directives with relevant parties with whom they have an agreement to deliver products or perform services. Enterprises should provide direction or guidance as to what actions are to be taken in response to sharing such an alert, advisory, or directive. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.
<br><br>Level(s): 1, 2, 3', N'System And Information Integrity', N'Security Alerts, Advisories, and Directives', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 73, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4170, N'SI-7', N'<ol type="a">
    <li>Employ integrity verification tools to detect unauthorized changes to the following software, firmware, and information: [Assignment: organization-defined software, firmware, and information]; and</li>
    <li>Take the following actions when unauthorized changes to the software, firmware, and information are detected: [Assignment: organization-defined actions].</li>
</ol>', N'Supplemental C-SCRM Guidance: This control applies to the federal agency and applicable supplier products, applications, information systems, and networks. The integrity of all applicable systems and networks should be systematically tested and verified to ensure that it remains as required so that the systems/components traversing through the supply chain are not impacted by unanticipated changes. The integrity of systems and components should also be tested and verified. Applicable verification tools include digital signature or checksum verification; acceptance testing for physical components; confining software to limited privilege environments, such as sandboxes; code execution in contained environments prior to use; and ensuring that if only binary or machine-executable code is available, it is obtained directly from the OEM or a verified supplier or distributer. Mechanisms for this control are discussed in detail in [NIST SP 800-53, Rev. 5]. This control applies to federal agencies and applicable supplier information systems and networks. When purchasing an ICT/OT product, an enterprise should perform due diligence to understand what a supplier’s integrity assurance practices are. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.

<br><br>Level(s): 2, 3

<br><br>Related Controls: SR-3(3)', N'System And Information Integrity', N'Software, Firmware, and Information Integrity', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 73, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4171, N'SI-7(15)', N'Implement cryptographic mechanisms to authenticate the following software or firmware
components prior to installation: [Assignment: organization-defined software or firmware components].', N'', N'System And Information Integrity', N'Software, Firmware, and Information Integrity', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 73, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4172, N'SI-12', N'Manage and retain information within the system and information output from the
system in accordance with applicable laws, executive orders, directives, regulations, policies, standards, guidelines and operational requirements.', N'Supplemental C-SCRM Guidance: C-SCRM should be included in information management and retention requirements, especially when the sensitive and proprietary information of a system integrator, supplier, or external service provider is concerned. 
<br><br>Level(s): 3', N'System And Information Integrity', N'Information Management and Retention', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 73, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4173, N'SI-20', N'Embed data or capabilities in the following systems or system components to
determine if organizational data has been exfiltrated or improperly removed from the
organization: [Assignment: organization-defined systems or system components].', N'Supplemental C-SCRM Guidance: Suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers may have access to the sensitive information of a federal agency. In this instance, enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors.

<br><br>Level(s): 2, 3

<br><br>Related Controls: SR-9', N'System And Information Integrity', N'Tainting', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 73, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4174, N'SR-1', N'<ol type="a">
    <li>
        Develop, document, and disseminate to [Assignment: organization-defined personnel or roles]:
        <ol>
            <li>
                [Selection (one or more): Organization-level; Mission/business process-level; System-level] supply chain risk management policy that:
                <ol type="a">
                    <li>Addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance; and</li>
                    <li>Is consistent with applicable laws, executive orders, directives, regulations, policies, standards, and guidelines; and</li>
                </ol>
            </li>
            <li>Procedures to facilitate the implementation of the supply chain risk management policy and the associated supply chain risk management controls;</li>
        </ol>
    </li>
    <li>Designate an [Assignment: organization-defined official] to manage the development, documentation, and dissemination of the supply chain risk management policy and procedures; and</li>
    <li>
        Review and update the current supply chain risk management:
        <ol>
            <li>Policy [Assignment: organization-defined frequency] and following [Assignment: organization-defined events]; and</li>
            <li>Procedures [Assignment: organization-defined frequency] and following [Assignment: organization-defined events].</li>
        </ol>
    </li>
</ol>', N'Supplemental C-SCRM Guidance: C-SCRM policies are developed at Level 1 for the overall enterprise and at Level 2 for specific missions and functions. C-SCRM policies can be implemented at Levels 1, 2, and 3, depending on the level of depth and detail. CSCRM procedures are developed at Level 2 for specific missions and functions and at Level 3 for specific systems. Enterprise functions including but not limited to information security, legal, risk management, and acquisition should review and concur on the development of C-SCRM policies and procedures or provide guidance to system owners for developing system-specific C-SCRM procedures.
<br><br>Level(s): 1, 2, 3', N'Supply Chain Risk Management', N'Supply Chain Risk Management Policy and Procedures', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 1087, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4175, N'SR-2', N'<ol type="a">
    <li>
        Develop a plan for managing supply chain risks associated with the research and development, design, manufacturing, acquisition, delivery, integration, operations and maintenance, and disposal of the following systems, system components or system services: [Assignment: organization-defined systems, system components, or system services];
    </li>
    <li>Review and update the supply chain risk management plan [Assignment: organization-defined frequency] or as required, to address threat, organizational or environmental changes; and</li>
    <li>Protect the supply chain risk management plan from unauthorized disclosure and modification.</li>
</ol>', N'Supplemental C-SCRM Guidance: C-SCRM plans describe implementations, requirements, constraints, and implications at the system level. C-SCRM plans are influenced by the enterprise’s other risk assessment activities and may inherit and tailor common control baselines defined at Level 1 and Level 2. C-SCRM plans defined at Level 3 work in collaboration with the enterprise’s C-SCRM Strategy and Policies (Level 1 and Level 2) and the C-SCRM Implementation Plan (Level 1 and Level 2) to provide a systematic and holistic approach for cybersecurity supply chain risk management across the enterprise. C-SCRM plans should be developed as a standalone document and only integrated into existing system security plans if enterprise constraints require it. 

<br><br>Level(s): 3

<br><br>Related Controls: PL-2', N'Supply Chain Risk Management', N'Supply Chain Risk Management Plan', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 1087, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4176, N'SR-3', N'<ol type="a">
    <li>
        Establish a process or processes to identify and address weaknesses or deficiencies in the supply chain elements and processes of [Assignment: organization-defined system or system component] in coordination with [Assignment: organization-defined supply chain personnel];
    </li>
    <li>
        Employ the following controls to protect against supply chain risks to the system, system component, or system service and to limit the harm or consequences from supply chain-related events: [Assignment: organization-defined supply chain controls]; and
    </li>
    <li>
        Document the selected and implemented supply chain processes and controls in [Selection: security and privacy plans; supply chain risk management plan; [Assignment: organization-defined document]].
    </li>
</ol>', N'Supplemental C-SCRM Guidance: Section 2 and Appendix C of this document provide detailed guidance on implementing this control. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028 on Improving the Nation''s Cybersecurity.
<br><br>Level(s): 1, 2, 3', N'Supply Chain Risk Management', N'Supply Chain Controls and Processes', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 1087, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4177, N'SR-3(1)', N'Employ a diverse set of sources for the following system components and services:
[Assignment: organization-defined system components and services].', N'Supplemental C-SCRM Guidance: Enterprises should diversify their supply base, especially for critical ICT/OT products and services. As a part of this exercise, the enterprise should attempt to identify single points of failure and risk among primes and lower-level entities in the supply chain. See Section 2, Appendix C, and RA-9 for guidance on conducting criticality analysis. 

<br><br>Level(s): 2, 3

<br><br>Related Controls: RA-9', N'Supply Chain Risk Management', N'Supply Chain Controls and Processes', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 1087, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4178, N'SR-3(3)', N'Ensure that the controls included in the contracts of prime contractors are also included in
the contracts of subcontractors.', N'Supplemental C-SCRM Guidance: Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors throughout the SDLC. The use of the acquisition process provides an important vehicle to protect the supply chain. As part of procurement requirements, enterprises should include the need for suppliers to flow down controls to subcontractors throughout the SDLC. As part of market research and analysis activities, enterprises should conduct robust due diligence research on potential suppliers or products, as well as their upstream dependencies (e.g., fourth- and fifth-party suppliers), which can help enterprises avoid single points of failure within their supply chains. The results of this research can be helpful in shaping the sourcing approach and refining requirements. An evaluation of the cybersecurity risks that arise from a supplier, product, or service should be completed prior to the contract award decision to ensure that the holistic risk profile is well-understood and serves as a weighted factor in award decisions. During the period of performance, suppliers should be monitored for conformance to the defined controls and requirements, as well as changes in risk conditions. See Section 3 for guidance on the Role of C-SCRM in the Acquisition Process.
<br><br>Level(s): 2, 3', N'Supply Chain Risk Management', N'Supply Chain Controls and Processes', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 1087, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4179, N'SR-4', N'Document, monitor, and maintain valid provenance of the following systems, system
components, and associated data: [Assignment: organization-defined systems, system components, and associated data].', N'Supplemental C-SCRM Guidance: Provenance should be documented for systems, system components, and associated data throughout the SDLC. Enterprises should consider producing SBOMs for applicable and appropriate classes of software, including purchased software, open source software, and in-house software. SBOMs should be produced using only NTIA-supported SBOM formats that can satisfy [NTIA SBOM] EO 14028 NTIA minimum SBOM elements. Enterprises producing SBOMs should use [NTIA SBOM] minimum SBOM elements as framing for the inclusion of primary components. SBOMs should be digitally signed using a verifiable and trusted key. SBOMs can play a critical role in enabling organizations to maintain provenance. However, as SBOMs mature, organizations should ensure they do not deprioritize existing C-SCRM capabilities (e.g., vulnerability management practices, vendor risk assessments) under the mistaken assumption that SBOM replaces these activities. SBOMs and the improved transparency that they are meant to provide for organizations are a complementary, not substitutive, capability. Organizations that are unable to appropriately ingest, analyze, and act on the data that SBOMs provide likely will not improve their overall C-SCRM posture. Federal agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028 on Improving the Nation''s Cybersecurity.
<br><br>Level(s): 2, 3', N'Supply Chain Risk Management', N'Provenance', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 1087, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4180, N'SR-5', N'Employ the following acquisition strategies, contract tools, and procurement methods
to protect against, identify, and mitigate supply chain risks: [Assignment: organization-defined acquisition strategies, contract tools, and procurement methods].', N'Supplemental C-SCRM Guidance: Section 3 and SA controls provide additional guidance on acquisition strategies, tools, and methods. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028 on Improving the Nation''s Cybersecurity.

<br><br>Level(s): 1, 2, 3

<br><br>Related Controls: SA Control Family', N'Supply Chain Risk Management', N'Acquisition Strategies, Tools, and Methods', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 1087, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4181, N'SR-6', N'Assess and review the supply chain-related risks associated with suppliers or
contractors and the system, system component, or system service they provide [Assignment: organization-defined frequency].', N'Supplemental C-SCRM Guidance: In general, an enterprise should consider any information pertinent to the security, integrity, resilience, quality, trustworthiness, or authenticity of the supplier or their provided services or products. Enterprises should consider applying this information against a consistent set of core baseline factors and assessment criteria to facilitate equitable comparison (between suppliers and over time). Depending on the specific context and purpose for which the assessment is being conducting, the enterprise may select additional factors. The quality of information (e.g., its relevance, completeness, accuracy, etc.) relied upon for an assessment is also an important consideration. Reference sources for assessment information should also be documented. The C-SCRM PMO can help define requirements, methods, and tools for the enterprise’s supplier assessments. Departments and agencies should refer to Appendix E for further guidance concerning baseline risk factors and the documentation of assessments and Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity. 
<br><br>Level(s): 2, 3', N'Supply Chain Risk Management', N'Supplier Assessments and Reviews', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 1087, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4182, N'SR-7', N'Employ the following Operations Security (OPSEC) controls to protect supply chain-related information for the system, system component, or system service: [Assignment: organization-defined Operations Security (OPSEC) controls].', N'Supplemental C-SCRM Guidance: The C-SCRM PMO can help determine OPSEC controls that apply to specific missions and functions. OPSEC controls are particularly important when there is specific concern about an adversarial threat from or to the enterprise’s supply chain or an element within the supply chain, or when the nature of the enterprise’s mission or business operations, its information, and/or its service/product offerings make it a more attractive target for an adversarial threat.
<br><br>Level(s): 2, 3', N'Supply Chain Risk Management', N'Supply Chain Operations Security', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 1087, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4183, N'SR-8', N'Establish agreements and procedures with entities involved in the supply chain for the
system, system component, or system service for the [Selection (one or more): notification of supply chain compromises; results of assessments or audits; [Assignment: organization-defined information]].', N'Supplemental C-SCRM Guidance: At minimum, enterprises should require their suppliers to establish notification agreements with entities within their supply chain that have a role or responsibility related to that critical service or product. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.

<br><br>Level(s): 2, 3

<br><br>Related Controls: RA-9', N'Supply Chain Risk Management', N'Notification Agreements', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 1087, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4184, N'SR-9', N'Implement a tamper protection program for the system, system component, or system
service.', N'Supplemental C-SCRM Guidance: Enterprises should apply tamper resistance and detection control to critical components, at a minimum. Criticality analysis can help determine which components are critical. See Section 2, Appendix C, and RA-9 for guidance on conducting criticality analysis. The C-SCRM PMO can help identify critical components, especially those that are used by multiple missions, functions, and systems within an enterprise. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.

<br><br>Level(s): 2, 3

<br><br>Related Controls: RA-9', N'Supply Chain Risk Management', N'Tamper Resistance and Detection', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 1087, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4185, N'SR-10', N'Inspect the following systems or system components [Selection (one or more): at random; at [Assignment: organization-defined frequency], upon [Assignment: organization-defined indications of need for inspection]] to detect tampering: [Assignment: organization-defined systems or system components].', N'Supplemental C-SCRM Guidance: Enterprises should inspect critical systems and components, at a minimum, for assurance that tamper resistance controls are in place and to examine whether there is evidence of tampering. Products or components should be inspected prior to use and periodically thereafter. Inspection requirements should also be included in contracts with suppliers, developers, system integrators, external system service providers, and other ICT/OT-related service providers. Enterprises should require their prime contractors to implement this control and flow down this requirement to relevant sub-tier contractors and flow down to subcontractors, when relevant. Criticality analysis can help determine which systems and components are critical and should, therefore, be subjected to inspection. See Section 2, Appendix C, and RA-9 for guidance on conducting criticality analysis. The C-SCRM PMO can help identify critical systems and components, especially those that are used by multiple missions, functions, and systems (for components) within an enterprise.

<br><br>Level(s): 2, 3

<br><br>Related Controls: RA-9', N'Supply Chain Risk Management', N'Inspection of Systems or Components', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 1087, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4186, N'SR-11', N'<ol type="a">
    <li>Develop and implement anti-counterfeit policy and procedures that include the means to detect and prevent counterfeit components from entering the system; and</li>
    <li>Report counterfeit system components to [Selection (one or more): source of counterfeit component; [Assignment: organization-defined external reporting organizations]; [Assignment: organization-defined personnel or roles]].</li>
</ol>', N'Supplemental C-SCRM Guidance: The development of anti-counterfeit policies and procedures requires input from and coordination with acquisition, information technology, IT security, legal, and the C-SCRM PMO. The policy and procedures should address regulatory compliance requirements, contract requirements or clauses, and counterfeit reporting processes to enterprises, such as GIDEP and/or other appropriate enterprises. Where applicable and appropriate, the policy should also address the development and use of a qualified bidders list (QBL) and/or qualified manufacturers list (QML). This helps prevent counterfeits through the use of authorized suppliers, wherever possible, and their integration into the organization’s supply chain [CISA SCRM WG3]. Departments and agencies should refer to Appendix F to implement this guidance in accordance with Executive Order 14028, Improving the Nation’s Cybersecurity.

<br><br>Level(s): 1, 2, 3', N'Supply Chain Risk Management', N'Component Authenticity', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 1087, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4187, N'SR-11(1)', N'Train [Assignment: organization-defined personnel or roles] to detect counterfeit system
components (including hardware, software, and firmware).', N'Supplemental C-SCRM Guidance: The C-SCRM PMO can assist in identifying resources that can provide anti-counterfeit training and/or may be able to conduct such training for the enterprise. The C-SCRM PMO can also assist in identifying which personnel should receive the training.
<br><br>Level(s): 2, 3', N'Supply Chain Risk Management', N'Component Authenticity', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 1087, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4188, N'SR-11(2)', N'Maintain configuration control over the following system components awaiting service or
repair and serviced or repaired components awaiting return to service: [Assignment: organization-defined system components].', N'Supplemental C-SCRM Guidance: Information technology, IT security, or the CSCRM PMO should be responsible for establishing and implementing configuration control processes for component service and repair, to include – if applicable – integrating component service and repair into the overall enterprise configuration control processes. Component authenticity should be addressed in contracts when procuring component servicing and repair support.
<br><br>Level(s): 2, 3', N'Supply Chain Risk Management', N'Component Authenticity', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 1087, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4189, N'SR-11(3)', N'Scan for counterfeit system components [Assignment: organization-defined frequency].', N'Supplemental C-SCRM Guidance: Enterprises should conduct anti-counterfeit scanning for critical components, at a minimum. Criticality analysis can help determine which components are critical and should be subjected to this scanning. See Section 2, Appendix C, and RA-9 for guidance on conducting criticality analysis. The C-SCRM PMO can help identify critical components, especially those used by multiple missions, functions, and systems within an enterprise.

<br><br>Level(s): 2, 3

<br><br>Related Controls: RA-9', N'Supply Chain Risk Management', N'Component Authenticity', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 1087, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4190, N'SR-12', N'Dispose of [Assignment: organization-defined data, documentation, tools, or system components] using the following techniques and methods: [Assignment: organization-defined techniques and methods].', N'Supplemental C-SCRM Guidance: IT security – in coordination with the C-SCRM PMO – can help establish appropriate component disposal policies, procedures, mechanisms, and techniques.
<br><br>Level(s): 2, 3', N'Supply Chain Risk Management', N'Component Disposal', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 1087, NULL, NULL)
INSERT INTO [dbo].[NEW_REQUIREMENT] ([Requirement_Id], [Requirement_Title], [Requirement_Text], [Supplemental_Info], [Standard_Category], [Standard_Sub_Category], [Weight], [Implementation_Recommendations], [Original_Set_Name], [NCSF_Cat_Id], [NCSF_Number], [Ranking], [Question_Group_Heading_Id], [ExaminationApproach], [Old_Id_For_Copy]) VALUES (4191, N'SR-13', N'<ol type="a">   <li>Develop, document, and maintain an inventory of suppliers that:     <ol>       <li>Accurately and minimally reflects the organization''s tier one suppliers that may present a cybersecurity risk in the supply chain [Assignment: organization-defined parameters for determining tier one supply chain];</li>       <li>Is at the level of granularity deemed necessary for assessing criticality and supply chain risk, tracking, and reporting;</li>       <li>Documents the following information for each tier one supplier (e.g., prime contractor):         <ol type="i">           <li>Unique identify for procurement instrument (i.e., contract, task, or delivery order);</li>           <li>Description of the supplied products and/or services;</li>           <li>Program, project, and/or system that uses the supplier''s products and/or services; and</li>           <li>Assigned criticality level that aligns to the criticality of the program, project, and/or system (or component of system).</li>         </ol>       </li>     </ol>   </li>   <li>Review and update the supplier inventory [Assignment: enterprise-defined frequency].</li> </ol>', N'Supplemental C-SCRM Guidance: Enterprises rely on numerous suppliers to execute their missions and functions. Many suppliers provide products and services in support of multiple missions, functions, programs, projects, and systems. Some suppliers are more critical than others, based on the criticality of missions, functions, programs, projects, systems that their products and services support, and the enterprise’s level of dependency on the supplier. Enterprises should use criticality analysis to help determine which products and services are critical to determine the criticality of suppliers to be documented in the supplier inventory. See Section 2, Appendix C, and RA-9 for guidance on conducting criticality analysis.

<br><br>Level(s): 2, 3

<br><br>Related Controls: RA-9', N'Supply Chain Risk Management', N'Supplier Inventory', NULL, NULL, N'NIST800_161_R1', NULL, NULL, NULL, 1087, NULL, NULL)
SET IDENTITY_INSERT [dbo].[NEW_REQUIREMENT] OFF
PRINT(N'Operation applied to 292 rows out of 292')

PRINT(N'Add rows to [dbo].[PARAMETERS]')
SET IDENTITY_INSERT [dbo].[PARAMETERS] ON
INSERT INTO [dbo].[PARAMETERS] ([Parameter_ID], [Parameter_Name]) VALUES (2564, N'[Assignment: organization-defined parameters for determining tier one supply chain]')
INSERT INTO [dbo].[PARAMETERS] ([Parameter_ID], [Parameter_Name]) VALUES (2565, N'[Assignment: enterprise-defined frequency]')
SET IDENTITY_INSERT [dbo].[PARAMETERS] OFF
PRINT(N'Operation applied to 2 rows out of 2')

PRINT(N'Add row to [dbo].[GALLERY_GROUP_DETAILS]')
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP_DETAILS] ON
INSERT INTO [dbo].[GALLERY_GROUP_DETAILS] ([Group_Detail_Id], [Group_Id], [Column_Index], [Click_Count], [Gallery_Item_Guid]) VALUES (7255, 6, 3, 0, '3ec1234b-7fde-4b85-a2a8-7ffb888438fd')
SET IDENTITY_INSERT [dbo].[GALLERY_GROUP_DETAILS] OFF

PRINT(N'Add row to [dbo].[GEN_FILE]')
SET IDENTITY_INSERT [dbo].[GEN_FILE] ON
INSERT INTO [dbo].[GEN_FILE] ([Gen_File_Id], [File_Type_Id], [File_Name], [Title], [Name], [File_Size], [Doc_Num], [Comments], [Description], [Short_Name], [Publish_Date], [Doc_Version], [Summary], [Source_Type], [Data], [Is_Uploaded]) VALUES (3747, 31, N'NIST.SP.800-161r1-upd1.pdf', N'NIST SP 800-161 R1 Upd1: Cybersecurity Supply Chain Risk Management Practices for Systems and Organizations', N'NIST SP800-161 R1 Upd1', NULL, N'SP800-161R1Upd1', NULL, N'The purpose of this publication is to provide guidance to federal agencies on identifying, assessing, selecting, and implementing risk management processes and mitigating controls throughout their organizations to help manage ICT supply chain risks.', N'SP 800-161 R1 Upd1', '2022-05-01 00:00:00.000', NULL, N'Federal agencies are concerned about the risks associated with information and communications technology (ICT) products and services that may contain potentially malicious functionality, are counterfeit, or are vulnerable due to poor manufacturing and development practices within the ICT supply chain. These risks are associated with the federal agencies’ decreased visibility into, understanding of, and control over how the technology that they acquire is developed, integrated and deployed, as well as the processes, procedures, and practices used to assure the integrity, security, resilience, and quality of the products and services. This publication provides guidance to federal agencies on identifying, assessing, and mitigating ICT supply chain risks at all levels of their organizations. The publication integrates ICT supply chain risk management (SCRM) into federal agency risk management activities by applying a multitiered, SCRM-specific approach, including guidance on assessing supply chain risk and applying mitigation activities.', NULL, NULL, 0)
SET IDENTITY_INSERT [dbo].[GEN_FILE] OFF

PRINT(N'Add rows to [dbo].[PARAMETER_REQUIREMENTS]')
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3900, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3900, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3900, 3543, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3900, 3625, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3900, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3901, 706, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3901, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3901, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3901, 3545, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3901, 3546, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3901, 3547, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3903, 858, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3904, 2715, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3904, 3553, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3905, 929, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3906, 936, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3907, 3603, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3908, 3599, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3909, 1101, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3909, 1102, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3910, 3607, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3916, 3621, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3916, 3622, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3918, 1133, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3919, 824, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3919, 1112, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3920, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3921, 1113, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3921, 1114, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3922, 927, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3922, 3623, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3923, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3923, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3923, 3543, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3923, 3625, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3923, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3927, 942, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3930, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3930, 2734, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3930, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3931, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3931, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3932, 706, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3933, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3933, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3933, 3543, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3933, 3625, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3933, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3934, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3934, 3892, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3934, 3893, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3936, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3936, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3936, 1116, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3938, 877, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3939, 878, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3940, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3940, 800, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3942, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3942, 2736, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3943, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3943, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3943, 3895, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3943, 3903, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3944, 1129, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3944, 3904, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3944, 3905, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3945, 946, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3945, 947, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3946, 944, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3946, 945, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3947, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3947, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3947, 3543, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3947, 3625, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3947, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3948, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3948, 881, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3949, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3949, 753, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3949, 3906, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3950, 985, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3950, 1121, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3950, 2746, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3951, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3951, 3907, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3952, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3953, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3955, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3955, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3955, 3543, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3955, 3625, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3955, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3956, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3956, 1129, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3958, 706, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3958, 1302, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3958, 3909, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3959, 706, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3959, 780, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3959, 3548, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3959, 3910, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3961, 1302, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3961, 3911, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3962, 1129, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3966, 3548, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3968, 969, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3968, 2736, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3968, 2752, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3969, 2736, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3969, 3548, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3970, 718, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3970, 800, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3971, 3912, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3971, 3913, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3972, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3972, 3914, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3973, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3973, 2754, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3974, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3974, 2755, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3975, 1083, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3976, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3978, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3978, 3916, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3979, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3979, 2756, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3981, 3548, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3982, 762, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3985, 3548, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3986, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3987, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3990, 1133, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3991, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3991, 933, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3991, 946, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3992, 1053, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3993, 2736, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3993, 2759, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3995, 968, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3996, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3996, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3996, 3543, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3996, 3625, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3996, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3997, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3997, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (3997, 1134, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4001, 3918, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4002, 706, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4002, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4002, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4004, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4004, 988, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4007, 886, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4007, 2760, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4008, 706, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4008, 2760, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4010, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4011, 1135, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4012, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4012, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4012, 3543, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4012, 3625, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4012, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4014, 978, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4014, 3921, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4015, 706, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4015, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4016, 982, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4017, 772, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4017, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4019, 982, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4021, 2768, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4022, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4022, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4022, 3543, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4022, 3625, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4022, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4023, 706, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4023, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4023, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4024, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4024, 988, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4026, 3929, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4028, 706, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4032, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4032, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4032, 1144, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4032, 2774, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4033, 800, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4033, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4034, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4034, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4034, 3543, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4034, 3625, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4034, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4035, 3548, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4036, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4039, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4044, 706, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4044, 2736, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4045, 2747, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4045, 3933, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4047, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4047, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4047, 3543, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4047, 3625, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4047, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4048, 781, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4048, 1146, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4049, 2776, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4049, 3553, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4050, 1147, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4050, 2777, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4051, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4051, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4051, 3543, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4051, 3625, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4051, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4052, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4054, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4054, 1012, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4054, 2781, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4054, 2782, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4054, 3937, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4054, 3938, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4054, 3939, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4055, 2783, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4056, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4057, 890, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4057, 891, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4057, 3940, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4058, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4058, 1152, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4059, 2790, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4060, 2791, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4060, 3553, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4061, 1158, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4062, 781, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4062, 1159, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4062, 1160, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4064, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4064, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4064, 3543, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4064, 3625, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4064, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4065, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4065, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4065, 1161, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4066, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4066, 3948, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4067, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4068, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4069, 1019, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4069, 3553, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4070, 3949, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4075, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4079, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4081, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4087, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4088, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4093, 2716, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4093, 3951, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4094, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4095, 706, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4096, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4096, 2798, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4096, 3952, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4096, 3953, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4097, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4097, 780, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4099, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4100, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4100, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4100, 1123, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4100, 1124, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4101, 3954, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4102, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4102, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4102, 3543, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4102, 3625, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4102, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4103, 2799, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4104, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4105, 706, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4105, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4106, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4106, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4106, 3543, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4106, 3625, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4106, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4107, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4107, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4107, 3543, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4107, 3625, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4107, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4109, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4109, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4109, 2802, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4110, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4110, 2803, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4111, 786, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4111, 787, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4111, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4113, 3548, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4115, 1175, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4115, 2805, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4116, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4117, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4117, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4117, 3543, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4117, 3625, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4117, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4119, 1165, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4120, 3969, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4121, 1239, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4124, 800, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4124, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4125, 3975, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4126, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4127, 2810, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4128, 800, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4128, 894, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4129, 896, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4129, 1025, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4129, 2811, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4130, 780, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4130, 1027, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4130, 2812, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4131, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4131, 1029, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4131, 1170, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4132, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4132, 2824, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4133, 1175, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4133, 3981, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4135, 1183, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4137, 2775, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4138, 1038, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4138, 1039, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4138, 3986, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4139, 1094, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4140, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4140, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4140, 3543, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4140, 3625, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4140, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4143, 1189, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4144, 909, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4145, 910, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4146, 911, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4147, 1043, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4149, 798, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4150, 1196, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4151, 1043, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4151, 1197, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4152, 2736, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4153, 1198, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4153, 1266, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4153, 2728, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4154, 1056, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4155, 1054, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4155, 1055, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4156, 2736, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4157, 1056, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4157, 2736, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4158, 2835, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4158, 4012, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4159, 2836, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4159, 2837, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4159, 3553, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4160, 4014, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4161, 5042, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4162, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4162, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4162, 3543, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4162, 3625, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4162, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4163, 706, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4164, 1069, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4164, 2736, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4165, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4165, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4165, 2842, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4165, 5070, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4165, 5071, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4166, 725, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4166, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4166, 1036, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4166, 1214, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4166, 2844, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4168, 1076, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4168, 1077, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4169, 982, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4169, 1223, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4170, 800, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4170, 1224, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4171, 1084, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4173, 2747, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4174, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4174, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4174, 3543, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4174, 3625, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4174, 3626, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4175, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4175, 2805, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4176, 2715, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4176, 2816, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4176, 2822, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4176, 5185, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4177, 2854, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4179, 2823, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4180, 2817, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4181, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4182, 5201, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4183, 2819, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4185, 1034, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4185, 2747, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4186, 1035, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4187, 846, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4188, 2736, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4189, 712, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4190, 1036, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4190, 5209, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4191, 2564, NULL)
INSERT INTO [dbo].[PARAMETER_REQUIREMENTS] ([Requirement_Id], [Parameter_Id], [ID]) VALUES (4191, 2565, NULL)
PRINT(N'Operation applied to 427 rows out of 427')

PRINT(N'Add rows to [dbo].[REQUIREMENT_LEVELS]')
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3900, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3900, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3900, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3900, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3901, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3901, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3901, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3901, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3902, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3902, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3902, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3902, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3903, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3903, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3903, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3903, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3904, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3904, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3904, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3904, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3905, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3905, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3905, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3905, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3906, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3906, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3906, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3906, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3907, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3907, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3907, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3907, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3908, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3908, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3908, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3908, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3909, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3909, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3909, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3909, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3910, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3910, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3910, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3910, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3911, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3911, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3911, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3911, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3912, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3912, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3912, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3912, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3913, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3913, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3913, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3913, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3914, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3914, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3914, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3914, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3915, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3915, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3915, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3915, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3916, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3916, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3916, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3916, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3917, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3917, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3917, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3917, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3918, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3918, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3918, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3918, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3919, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3919, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3919, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3919, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3920, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3920, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3920, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3920, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3921, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3921, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3921, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3921, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3922, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3922, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3922, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3922, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3923, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3923, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3923, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3923, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3924, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3924, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3924, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3924, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3925, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3925, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3925, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3925, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3926, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3926, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3926, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3926, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3927, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3927, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3927, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3927, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3928, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3928, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3928, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3928, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3929, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3929, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3929, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3929, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3930, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3930, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3930, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3930, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3931, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3931, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3931, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3931, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3932, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3932, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3932, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3932, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3933, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3933, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3933, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3933, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3934, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3934, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3934, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3934, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3935, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3935, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3935, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3935, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3936, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3936, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3936, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3936, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3937, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3937, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3937, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3937, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3938, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3938, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3938, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3938, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3939, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3939, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3939, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3939, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3940, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3940, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3940, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3940, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3941, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3941, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3941, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3941, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3942, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3942, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3942, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3942, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3943, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3943, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3943, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3943, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3944, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3944, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3944, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3944, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3945, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3945, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3945, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3945, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3946, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3946, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3946, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3946, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3947, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3947, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3947, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3947, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3948, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3948, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3948, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3948, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3949, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3949, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3949, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3949, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3950, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3950, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3950, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3950, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3951, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3951, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3951, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3951, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3952, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3952, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3952, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3952, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3953, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3953, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3953, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3953, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3954, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3954, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3954, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3954, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3955, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3955, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3955, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3955, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3956, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3956, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3956, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3956, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3957, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3957, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3957, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3957, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3958, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3958, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3958, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3958, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3959, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3959, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3959, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3959, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3960, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3960, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3960, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3960, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3961, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3961, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3961, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3961, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3962, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3962, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3962, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3962, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3963, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3963, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3963, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3963, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3964, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3964, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3964, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3964, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3965, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3965, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3965, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3965, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3966, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3966, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3966, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3966, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3967, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3967, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3967, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3967, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3968, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3968, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3968, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3968, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3969, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3969, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3969, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3969, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3970, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3970, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3970, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3970, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3971, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3971, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3971, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3971, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3972, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3972, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3972, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3972, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3973, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3973, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3973, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3973, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3974, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3974, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3974, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3974, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3975, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3975, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3975, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3975, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3976, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3976, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3976, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3976, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3977, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3977, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3977, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3977, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3978, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3978, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3978, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3978, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3979, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3979, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3979, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3979, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3980, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3980, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3980, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3980, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3981, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3981, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3981, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3981, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3982, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3982, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3982, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3982, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3983, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3983, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3983, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3983, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3984, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3984, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3984, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3984, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3985, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3985, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3985, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3985, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3986, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3986, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3986, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3986, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3987, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3987, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3987, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3987, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3988, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3988, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3988, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3988, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3989, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3989, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3989, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3989, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3990, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3990, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3990, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3990, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3991, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3991, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3991, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3991, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3992, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3992, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3992, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3992, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3993, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3993, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3993, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3993, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3994, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3994, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3994, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3994, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3995, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3995, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3995, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3995, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3996, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3996, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3996, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3996, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3997, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3997, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3997, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3997, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3998, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3998, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3998, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3998, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3999, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3999, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3999, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (3999, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4000, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4000, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4000, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4000, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4001, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4001, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4001, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4001, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4002, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4002, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4002, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4002, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4003, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4003, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4003, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4003, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4004, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4004, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4004, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4004, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4005, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4005, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4005, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4005, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4006, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4006, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4006, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4006, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4007, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4007, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4007, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4007, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4008, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4008, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4008, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4008, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4009, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4009, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4009, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4009, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4010, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4010, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4010, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4010, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4011, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4011, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4011, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4011, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4012, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4012, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4012, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4012, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4013, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4013, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4013, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4013, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4014, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4014, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4014, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4014, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4015, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4015, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4015, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4015, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4016, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4016, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4016, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4016, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4017, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4017, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4017, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4017, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4018, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4018, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4018, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4018, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4019, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4019, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4019, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4019, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4020, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4020, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4020, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4020, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4021, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4021, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4021, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4021, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4022, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4022, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4022, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4022, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4023, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4023, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4023, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4023, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4024, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4024, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4024, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4024, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4025, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4025, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4025, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4025, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4026, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4026, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4026, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4026, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4027, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4027, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4027, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4027, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4028, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4028, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4028, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4028, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4029, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4029, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4029, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4029, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4030, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4030, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4030, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4030, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4031, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4031, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4031, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4031, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4032, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4032, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4032, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4032, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4033, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4033, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4033, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4033, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4034, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4034, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4034, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4034, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4035, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4035, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4035, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4035, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4036, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4036, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4036, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4036, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4037, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4037, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4037, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4037, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4038, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4038, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4038, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4038, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4039, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4039, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4039, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4039, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4040, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4040, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4040, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4040, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4041, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4041, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4041, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4041, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4042, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4042, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4042, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4042, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4043, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4043, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4043, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4043, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4044, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4044, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4044, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4044, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4045, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4045, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4045, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4045, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4046, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4046, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4046, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4046, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4047, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4047, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4047, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4047, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4048, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4048, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4048, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4048, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4049, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4049, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4049, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4049, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4050, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4050, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4050, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4050, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4051, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4051, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4051, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4051, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4052, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4052, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4052, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4052, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4053, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4053, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4053, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4053, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4054, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4054, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4054, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4054, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4055, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4055, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4055, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4055, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4056, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4056, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4056, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4056, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4057, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4057, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4057, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4057, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4058, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4058, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4058, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4058, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4059, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4059, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4059, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4059, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4060, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4060, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4060, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4060, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4061, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4061, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4061, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4061, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4062, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4062, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4062, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4062, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4063, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4063, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4063, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4063, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4064, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4064, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4064, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4064, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4065, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4065, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4065, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4065, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4066, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4066, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4066, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4066, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4067, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4067, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4067, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4067, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4068, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4068, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4068, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4068, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4069, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4069, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4069, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4069, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4070, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4070, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4070, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4070, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4071, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4071, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4071, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4071, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4072, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4072, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4072, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4072, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4073, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4073, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4073, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4073, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4074, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4074, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4074, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4074, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4075, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4075, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4075, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4075, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4076, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4076, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4076, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4076, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4077, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4077, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4077, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4077, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4078, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4078, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4078, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4078, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4079, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4079, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4079, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4079, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4080, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4080, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4080, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4080, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4081, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4081, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4081, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4081, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4082, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4082, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4082, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4082, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4083, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4083, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4083, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4083, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4084, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4084, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4084, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4084, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4085, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4085, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4085, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4085, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4086, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4086, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4086, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4086, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4087, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4087, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4087, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4087, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4088, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4088, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4088, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4088, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4089, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4089, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4089, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4089, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4090, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4090, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4090, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4090, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4091, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4091, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4091, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4091, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4092, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4092, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4092, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4092, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4093, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4093, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4093, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4093, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4094, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4094, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4094, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4094, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4095, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4095, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4095, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4095, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4096, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4096, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4096, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4096, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4097, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4097, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4097, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4097, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4098, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4098, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4098, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4098, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4099, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4099, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4099, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4099, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4100, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4100, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4100, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4100, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4101, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4101, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4101, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4101, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4102, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4102, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4102, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4102, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4103, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4103, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4103, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4103, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4104, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4104, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4104, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4104, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4105, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4105, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4105, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4105, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4106, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4106, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4106, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4106, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4107, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4107, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4107, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4107, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4108, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4108, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4108, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4108, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4109, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4109, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4109, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4109, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4110, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4110, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4110, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4110, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4111, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4111, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4111, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4111, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4112, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4112, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4112, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4112, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4113, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4113, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4113, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4113, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4114, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4114, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4114, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4114, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4115, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4115, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4115, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4115, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4116, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4116, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4116, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4116, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4117, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4117, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4117, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4117, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4118, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4118, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4118, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4118, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4119, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4119, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4119, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4119, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4120, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4120, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4120, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4120, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4121, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4121, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4121, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4121, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4122, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4122, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4122, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4122, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4123, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4123, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4123, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4123, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4124, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4124, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4124, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4124, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4125, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4125, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4125, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4125, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4126, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4126, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4126, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4126, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4127, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4127, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4127, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4127, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4128, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4128, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4128, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4128, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4129, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4129, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4129, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4129, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4130, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4130, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4130, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4130, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4131, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4131, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4131, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4131, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4132, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4132, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4132, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4132, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4133, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4133, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4133, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4133, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4134, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4134, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4134, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4134, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4135, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4135, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4135, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4135, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4136, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4136, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4136, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4136, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4137, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4137, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4137, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4137, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4138, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4138, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4138, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4138, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4139, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4139, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4139, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4139, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4140, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4140, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4140, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4140, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4141, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4141, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4141, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4141, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4142, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4142, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4142, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4142, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4143, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4143, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4143, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4143, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4144, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4144, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4144, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4144, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4145, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4145, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4145, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4145, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4146, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4146, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4146, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4146, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4147, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4147, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4147, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4147, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4148, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4148, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4148, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4148, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4149, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4149, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4149, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4149, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4150, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4150, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4150, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4150, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4151, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4151, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4151, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4151, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4152, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4152, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4152, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4152, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4153, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4153, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4153, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4153, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4154, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4154, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4154, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4154, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4155, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4155, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4155, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4155, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4156, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4156, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4156, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4156, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4157, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4157, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4157, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4157, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4158, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4158, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4158, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4158, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4159, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4159, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4159, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4159, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4160, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4160, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4160, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4160, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4161, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4161, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4161, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4161, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4162, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4162, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4162, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4162, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4163, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4163, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4163, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4163, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4164, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4164, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4164, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4164, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4165, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4165, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4165, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4165, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4166, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4166, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4166, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4166, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4167, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4167, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4167, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4167, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4168, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4168, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4168, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4168, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4169, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4169, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4169, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4169, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4170, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4170, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4170, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4170, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4171, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4171, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4171, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4171, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4172, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4172, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4172, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4172, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4173, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4173, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4173, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4173, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4174, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4174, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4174, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4174, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4175, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4175, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4175, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4175, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4176, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4176, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4176, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4176, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4177, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4177, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4177, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4177, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4178, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4178, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4178, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4178, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4179, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4179, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4179, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4179, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4180, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4180, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4180, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4180, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4181, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4181, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4181, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4181, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4182, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4182, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4182, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4182, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4183, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4183, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4183, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4183, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4184, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4184, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4184, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4184, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4185, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4185, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4185, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4185, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4186, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4186, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4186, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4186, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4187, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4187, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4187, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4187, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4188, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4188, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4188, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4188, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4189, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4189, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4189, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4189, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4190, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4190, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4190, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4190, N'VH', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4191, N'H', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4191, N'L', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4191, N'M', N'NST', NULL)
INSERT INTO [dbo].[REQUIREMENT_LEVELS] ([Requirement_Id], [Standard_Level], [Level_Type], [Id]) VALUES (4191, N'VH', N'NST', NULL)
PRINT(N'Operation applied to 1168 rows out of 1168')

PRINT(N'Add rows to [dbo].[REQUIREMENT_SETS]')
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3900, N'NIST800_161_R1', 0)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3901, N'NIST800_161_R1', 1)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3902, N'NIST800_161_R1', 2)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3903, N'NIST800_161_R1', 3)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3904, N'NIST800_161_R1', 4)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3905, N'NIST800_161_R1', 5)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3906, N'NIST800_161_R1', 6)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3907, N'NIST800_161_R1', 7)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3908, N'NIST800_161_R1', 8)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3909, N'NIST800_161_R1', 9)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3910, N'NIST800_161_R1', 10)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3911, N'NIST800_161_R1', 11)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3912, N'NIST800_161_R1', 12)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3913, N'NIST800_161_R1', 13)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3914, N'NIST800_161_R1', 14)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3915, N'NIST800_161_R1', 15)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3916, N'NIST800_161_R1', 16)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3917, N'NIST800_161_R1', 17)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3918, N'NIST800_161_R1', 18)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3919, N'NIST800_161_R1', 19)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3920, N'NIST800_161_R1', 20)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3921, N'NIST800_161_R1', 21)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3922, N'NIST800_161_R1', 22)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3923, N'NIST800_161_R1', 23)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3924, N'NIST800_161_R1', 24)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3925, N'NIST800_161_R1', 25)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3926, N'NIST800_161_R1', 26)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3927, N'NIST800_161_R1', 27)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3928, N'NIST800_161_R1', 28)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3929, N'NIST800_161_R1', 29)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3930, N'NIST800_161_R1', 30)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3931, N'NIST800_161_R1', 31)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3932, N'NIST800_161_R1', 32)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3933, N'NIST800_161_R1', 33)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3934, N'NIST800_161_R1', 34)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3935, N'NIST800_161_R1', 35)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3936, N'NIST800_161_R1', 36)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3937, N'NIST800_161_R1', 37)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3938, N'NIST800_161_R1', 38)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3939, N'NIST800_161_R1', 39)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3940, N'NIST800_161_R1', 40)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3941, N'NIST800_161_R1', 41)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3942, N'NIST800_161_R1', 42)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3943, N'NIST800_161_R1', 43)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3944, N'NIST800_161_R1', 44)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3945, N'NIST800_161_R1', 45)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3946, N'NIST800_161_R1', 46)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3947, N'NIST800_161_R1', 47)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3948, N'NIST800_161_R1', 48)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3949, N'NIST800_161_R1', 49)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3950, N'NIST800_161_R1', 50)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3951, N'NIST800_161_R1', 51)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3952, N'NIST800_161_R1', 52)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3953, N'NIST800_161_R1', 53)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3954, N'NIST800_161_R1', 54)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3955, N'NIST800_161_R1', 55)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3956, N'NIST800_161_R1', 56)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3957, N'NIST800_161_R1', 57)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3958, N'NIST800_161_R1', 58)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3959, N'NIST800_161_R1', 59)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3960, N'NIST800_161_R1', 60)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3961, N'NIST800_161_R1', 61)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3962, N'NIST800_161_R1', 62)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3963, N'NIST800_161_R1', 63)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3964, N'NIST800_161_R1', 64)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3965, N'NIST800_161_R1', 65)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3966, N'NIST800_161_R1', 66)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3967, N'NIST800_161_R1', 67)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3968, N'NIST800_161_R1', 68)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3969, N'NIST800_161_R1', 69)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3970, N'NIST800_161_R1', 70)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3971, N'NIST800_161_R1', 71)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3972, N'NIST800_161_R1', 72)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3973, N'NIST800_161_R1', 73)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3974, N'NIST800_161_R1', 74)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3975, N'NIST800_161_R1', 75)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3976, N'NIST800_161_R1', 76)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3977, N'NIST800_161_R1', 77)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3978, N'NIST800_161_R1', 78)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3979, N'NIST800_161_R1', 79)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3980, N'NIST800_161_R1', 80)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3981, N'NIST800_161_R1', 81)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3982, N'NIST800_161_R1', 82)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3983, N'NIST800_161_R1', 83)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3984, N'NIST800_161_R1', 84)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3985, N'NIST800_161_R1', 85)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3986, N'NIST800_161_R1', 86)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3987, N'NIST800_161_R1', 87)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3988, N'NIST800_161_R1', 88)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3989, N'NIST800_161_R1', 89)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3990, N'NIST800_161_R1', 90)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3991, N'NIST800_161_R1', 91)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3992, N'NIST800_161_R1', 92)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3993, N'NIST800_161_R1', 93)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3994, N'NIST800_161_R1', 94)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3995, N'NIST800_161_R1', 95)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3996, N'NIST800_161_R1', 96)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3997, N'NIST800_161_R1', 97)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3998, N'NIST800_161_R1', 98)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (3999, N'NIST800_161_R1', 99)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4000, N'NIST800_161_R1', 100)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4001, N'NIST800_161_R1', 101)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4002, N'NIST800_161_R1', 102)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4003, N'NIST800_161_R1', 103)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4004, N'NIST800_161_R1', 104)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4005, N'NIST800_161_R1', 105)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4006, N'NIST800_161_R1', 106)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4007, N'NIST800_161_R1', 107)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4008, N'NIST800_161_R1', 108)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4009, N'NIST800_161_R1', 109)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4010, N'NIST800_161_R1', 110)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4011, N'NIST800_161_R1', 111)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4012, N'NIST800_161_R1', 112)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4013, N'NIST800_161_R1', 113)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4014, N'NIST800_161_R1', 114)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4015, N'NIST800_161_R1', 115)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4016, N'NIST800_161_R1', 116)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4017, N'NIST800_161_R1', 117)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4018, N'NIST800_161_R1', 118)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4019, N'NIST800_161_R1', 119)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4020, N'NIST800_161_R1', 120)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4021, N'NIST800_161_R1', 121)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4022, N'NIST800_161_R1', 122)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4023, N'NIST800_161_R1', 123)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4024, N'NIST800_161_R1', 124)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4025, N'NIST800_161_R1', 125)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4026, N'NIST800_161_R1', 126)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4027, N'NIST800_161_R1', 127)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4028, N'NIST800_161_R1', 128)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4029, N'NIST800_161_R1', 129)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4030, N'NIST800_161_R1', 130)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4031, N'NIST800_161_R1', 131)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4032, N'NIST800_161_R1', 132)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4033, N'NIST800_161_R1', 133)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4034, N'NIST800_161_R1', 134)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4035, N'NIST800_161_R1', 135)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4036, N'NIST800_161_R1', 136)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4037, N'NIST800_161_R1', 137)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4038, N'NIST800_161_R1', 138)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4039, N'NIST800_161_R1', 139)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4040, N'NIST800_161_R1', 140)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4041, N'NIST800_161_R1', 141)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4042, N'NIST800_161_R1', 142)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4043, N'NIST800_161_R1', 143)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4044, N'NIST800_161_R1', 144)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4045, N'NIST800_161_R1', 145)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4046, N'NIST800_161_R1', 146)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4047, N'NIST800_161_R1', 147)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4048, N'NIST800_161_R1', 148)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4049, N'NIST800_161_R1', 149)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4050, N'NIST800_161_R1', 150)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4051, N'NIST800_161_R1', 151)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4052, N'NIST800_161_R1', 152)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4053, N'NIST800_161_R1', 153)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4054, N'NIST800_161_R1', 154)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4055, N'NIST800_161_R1', 155)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4056, N'NIST800_161_R1', 156)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4057, N'NIST800_161_R1', 157)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4058, N'NIST800_161_R1', 158)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4059, N'NIST800_161_R1', 159)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4060, N'NIST800_161_R1', 160)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4061, N'NIST800_161_R1', 161)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4062, N'NIST800_161_R1', 162)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4063, N'NIST800_161_R1', 163)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4064, N'NIST800_161_R1', 164)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4065, N'NIST800_161_R1', 165)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4066, N'NIST800_161_R1', 166)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4067, N'NIST800_161_R1', 167)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4068, N'NIST800_161_R1', 168)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4069, N'NIST800_161_R1', 169)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4070, N'NIST800_161_R1', 170)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4071, N'NIST800_161_R1', 171)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4072, N'NIST800_161_R1', 172)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4073, N'NIST800_161_R1', 173)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4074, N'NIST800_161_R1', 174)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4075, N'NIST800_161_R1', 175)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4076, N'NIST800_161_R1', 176)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4077, N'NIST800_161_R1', 177)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4078, N'NIST800_161_R1', 178)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4079, N'NIST800_161_R1', 179)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4080, N'NIST800_161_R1', 180)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4081, N'NIST800_161_R1', 181)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4082, N'NIST800_161_R1', 182)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4083, N'NIST800_161_R1', 183)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4084, N'NIST800_161_R1', 184)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4085, N'NIST800_161_R1', 185)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4086, N'NIST800_161_R1', 186)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4087, N'NIST800_161_R1', 187)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4088, N'NIST800_161_R1', 188)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4089, N'NIST800_161_R1', 189)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4090, N'NIST800_161_R1', 190)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4091, N'NIST800_161_R1', 191)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4092, N'NIST800_161_R1', 192)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4093, N'NIST800_161_R1', 193)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4094, N'NIST800_161_R1', 194)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4095, N'NIST800_161_R1', 195)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4096, N'NIST800_161_R1', 196)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4097, N'NIST800_161_R1', 197)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4098, N'NIST800_161_R1', 198)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4099, N'NIST800_161_R1', 199)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4100, N'NIST800_161_R1', 200)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4101, N'NIST800_161_R1', 201)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4102, N'NIST800_161_R1', 202)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4103, N'NIST800_161_R1', 203)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4104, N'NIST800_161_R1', 204)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4105, N'NIST800_161_R1', 205)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4106, N'NIST800_161_R1', 206)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4107, N'NIST800_161_R1', 207)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4108, N'NIST800_161_R1', 208)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4109, N'NIST800_161_R1', 209)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4110, N'NIST800_161_R1', 210)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4111, N'NIST800_161_R1', 211)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4112, N'NIST800_161_R1', 212)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4113, N'NIST800_161_R1', 213)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4114, N'NIST800_161_R1', 214)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4115, N'NIST800_161_R1', 215)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4116, N'NIST800_161_R1', 216)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4117, N'NIST800_161_R1', 217)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4118, N'NIST800_161_R1', 218)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4119, N'NIST800_161_R1', 219)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4120, N'NIST800_161_R1', 220)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4121, N'NIST800_161_R1', 221)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4122, N'NIST800_161_R1', 222)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4123, N'NIST800_161_R1', 223)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4124, N'NIST800_161_R1', 224)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4125, N'NIST800_161_R1', 225)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4126, N'NIST800_161_R1', 226)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4127, N'NIST800_161_R1', 227)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4128, N'NIST800_161_R1', 228)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4129, N'NIST800_161_R1', 229)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4130, N'NIST800_161_R1', 230)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4131, N'NIST800_161_R1', 231)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4132, N'NIST800_161_R1', 232)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4133, N'NIST800_161_R1', 233)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4134, N'NIST800_161_R1', 234)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4135, N'NIST800_161_R1', 235)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4136, N'NIST800_161_R1', 236)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4137, N'NIST800_161_R1', 237)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4138, N'NIST800_161_R1', 238)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4139, N'NIST800_161_R1', 239)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4140, N'NIST800_161_R1', 240)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4141, N'NIST800_161_R1', 241)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4142, N'NIST800_161_R1', 242)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4143, N'NIST800_161_R1', 243)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4144, N'NIST800_161_R1', 244)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4145, N'NIST800_161_R1', 245)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4146, N'NIST800_161_R1', 246)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4147, N'NIST800_161_R1', 247)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4148, N'NIST800_161_R1', 248)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4149, N'NIST800_161_R1', 249)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4150, N'NIST800_161_R1', 250)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4151, N'NIST800_161_R1', 251)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4152, N'NIST800_161_R1', 252)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4153, N'NIST800_161_R1', 253)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4154, N'NIST800_161_R1', 254)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4155, N'NIST800_161_R1', 255)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4156, N'NIST800_161_R1', 256)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4157, N'NIST800_161_R1', 257)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4158, N'NIST800_161_R1', 258)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4159, N'NIST800_161_R1', 259)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4160, N'NIST800_161_R1', 260)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4161, N'NIST800_161_R1', 261)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4162, N'NIST800_161_R1', 262)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4163, N'NIST800_161_R1', 263)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4164, N'NIST800_161_R1', 264)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4165, N'NIST800_161_R1', 265)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4166, N'NIST800_161_R1', 266)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4167, N'NIST800_161_R1', 267)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4168, N'NIST800_161_R1', 268)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4169, N'NIST800_161_R1', 269)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4170, N'NIST800_161_R1', 270)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4171, N'NIST800_161_R1', 271)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4172, N'NIST800_161_R1', 272)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4173, N'NIST800_161_R1', 273)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4174, N'NIST800_161_R1', 274)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4175, N'NIST800_161_R1', 275)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4176, N'NIST800_161_R1', 276)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4177, N'NIST800_161_R1', 277)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4178, N'NIST800_161_R1', 278)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4179, N'NIST800_161_R1', 279)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4180, N'NIST800_161_R1', 280)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4181, N'NIST800_161_R1', 281)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4182, N'NIST800_161_R1', 282)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4183, N'NIST800_161_R1', 283)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4184, N'NIST800_161_R1', 284)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4185, N'NIST800_161_R1', 285)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4186, N'NIST800_161_R1', 286)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4187, N'NIST800_161_R1', 287)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4188, N'NIST800_161_R1', 288)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4189, N'NIST800_161_R1', 289)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4190, N'NIST800_161_R1', 290)
INSERT INTO [dbo].[REQUIREMENT_SETS] ([Requirement_Id], [Set_Name], [Requirement_Sequence]) VALUES (4191, N'NIST800_161_R1', 291)
PRINT(N'Operation applied to 292 rows out of 292')

PRINT(N'Add rows to [dbo].[GEN_FILE_LIB_PATH_CORL]')
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3747, 375)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3747, 422)
INSERT INTO [dbo].[GEN_FILE_LIB_PATH_CORL] ([Gen_File_Id], [Lib_Path_Id]) VALUES (3747, 569)
PRINT(N'Operation applied to 3 rows out of 3')

PRINT(N'Add rows to [dbo].[REQUIREMENT_REFERENCES]')
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3900, 3747, 1, N'AC-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3900, 3968, 0, N'AC-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3901, 3747, 1, N'AC-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3901, 3968, 0, N'AC-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3902, 3747, 1, N'AC-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3902, 3968, 0, N'AC-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3903, 3747, 1, N'AC-3(8)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3903, 3968, 0, N'AC-3(8)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3904, 3747, 1, N'AC-3(9)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3904, 3968, 0, N'AC-3(9)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3905, 3747, 1, N'AC-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3905, 3968, 0, N'AC-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3906, 3747, 1, N'AC-4(6)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3906, 3968, 0, N'AC-4(6)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3907, 3747, 1, N'AC-4(17)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3907, 3968, 0, N'AC-4(17)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3908, 3747, 1, N'AC-4(19)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3908, 3968, 0, N'AC-4(19)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3909, 3747, 1, N'AC-4(21)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3909, 3968, 0, N'AC-4(21)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3910, 3747, 1, N'AC-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3910, 3968, 0, N'AC-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3911, 3747, 1, N'AC-6(6)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3911, 3968, 0, N'AC-6(6)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3912, 3747, 1, N'AC-17', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3912, 3968, 0, N'AC-17', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3913, 3747, 1, N'AC-17(6)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3913, 3968, 0, N'AC-17(6)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3914, 3747, 1, N'AC-18', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3914, 3968, 0, N'AC-18', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3915, 3747, 1, N'AC-19', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3915, 3968, 0, N'AC-19', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3916, 3747, 1, N'AC-20', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3916, 3968, 0, N'AC-20', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3917, 3747, 1, N'AC-20(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3917, 3968, 0, N'AC-20(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3918, 3747, 1, N'AC-20(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3918, 3968, 0, N'AC-20(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3919, 3747, 1, N'AC-21', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3919, 3968, 0, N'AC-21', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3920, 3747, 1, N'AC-22', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3920, 3968, 0, N'AC-22', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3921, 3747, 1, N'AC-23', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3921, 3968, 0, N'AC-23', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3922, 3747, 1, N'AC-24', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3922, 3968, 0, N'AC-24', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3923, 3747, 1, N'AT-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3923, 3968, 0, N'AT-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3924, 3747, 1, N'AT-2(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3924, 3968, 0, N'AT-2(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3925, 3747, 1, N'AT-2(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3925, 3968, 0, N'AT-2(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3926, 3747, 1, N'AT-2(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3926, 3968, 0, N'AT-2(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3927, 3747, 1, N'AT-2(4)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3927, 3968, 0, N'AT-2(4)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3928, 3747, 1, N'AT-2(5)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3928, 3968, 0, N'AT-2(5)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3929, 3747, 1, N'AT-2(6)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3929, 3968, 0, N'AT-2(6)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3930, 3747, 1, N'AT-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3930, 3968, 0, N'AT-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3931, 3747, 1, N'AT-3(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3931, 3968, 0, N'AT-3(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3932, 3747, 1, N'AT-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3932, 3968, 0, N'AT-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3933, 3747, 1, N'AU-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3933, 3968, 0, N'AU-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3934, 3747, 1, N'AU-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3934, 3968, 0, N'AU-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3935, 3747, 1, N'AU-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3935, 3968, 0, N'AU-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3936, 3747, 1, N'AU-6', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3936, 3968, 0, N'AU-6', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3937, 3747, 1, N'AU-6(9)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3937, 3968, 0, N'AU-6(9)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3938, 3747, 1, N'AU-10', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3938, 3968, 0, N'AU-10', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3939, 3747, 1, N'AU-10(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3939, 3968, 0, N'AU-10(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3940, 3747, 1, N'AU-10(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3940, 3968, 0, N'AU-10(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3941, 3747, 1, N'AU-10(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3941, 3968, 0, N'AU-10(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3942, 3747, 1, N'AU-12', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3942, 3968, 0, N'AU-12', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3943, 3747, 1, N'AU-13', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3943, 3968, 0, N'AU-13', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3944, 3747, 1, N'AU-14', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3944, 3968, 0, N'AU-14', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3945, 3747, 1, N'AU-16', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3945, 3968, 0, N'AU-16', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3946, 3747, 1, N'AU-16(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3946, 3968, 0, N'AU-16(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3947, 3747, 1, N'CA-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3947, 3968, 0, N'CA-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3948, 3747, 1, N'CA-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3948, 3968, 0, N'CA-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3949, 3747, 1, N'CA-2(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3949, 3968, 0, N'CA-2(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3950, 3747, 1, N'CA-2(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3950, 3968, 0, N'CA-2(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3951, 3747, 1, N'CA-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3951, 3968, 0, N'CA-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3952, 3747, 1, N'CA-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3952, 3968, 0, N'CA-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3953, 3747, 1, N'CA-6', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3953, 3968, 0, N'CA-6', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3954, 3747, 1, N'CA-7(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3954, 3968, 0, N'CA-7(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3955, 3747, 1, N'CM-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3955, 3968, 0, N'CM-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3956, 3747, 1, N'CM-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3956, 3968, 0, N'CM-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3957, 3747, 1, N'CM-2(6)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3957, 3968, 0, N'CM-2(6)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3958, 3747, 1, N'CM-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3958, 3968, 0, N'CM-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3959, 3747, 1, N'CM-3(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3959, 3968, 0, N'CM-3(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3960, 3747, 1, N'CM-3(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3960, 3968, 0, N'CM-3(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3961, 3747, 1, N'CM-3(4)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3961, 3968, 0, N'CM-3(4)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3962, 3747, 1, N'CM-3(8)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3962, 3968, 0, N'CM-3(8)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3963, 3747, 1, N'CM-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3963, 3968, 0, N'CM-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3964, 3747, 1, N'CM-4(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3964, 3968, 0, N'CM-4(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3965, 3747, 1, N'CM-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3965, 3968, 0, N'CM-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3966, 3747, 1, N'CM-5(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3966, 3968, 0, N'CM-5(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3967, 3747, 1, N'CM-5(6)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3967, 3968, 0, N'CM-5(6)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3968, 3747, 1, N'CM-6', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3968, 3968, 0, N'CM-6', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3969, 3747, 1, N'CM-6(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3969, 3968, 0, N'CM-6(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3970, 3747, 1, N'CM-6(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3970, 3968, 0, N'CM-6(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3971, 3747, 1, N'CM-7', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3971, 3968, 0, N'CM-7', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3972, 3747, 1, N'CM-7(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3972, 3968, 0, N'CM-7(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3973, 3747, 1, N'CM-7(4)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3973, 3968, 0, N'CM-7(4)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3974, 3747, 1, N'CM-7(5)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3974, 3968, 0, N'CM-7(5)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3975, 3747, 1, N'CM-7(6)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3975, 3968, 0, N'CM-7(6)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3976, 3747, 1, N'CM-7(7)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3976, 3968, 0, N'CM-7(7)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3977, 3747, 1, N'CM-7(8)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3977, 3968, 0, N'CM-7(8)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3978, 3747, 1, N'CM-7(9)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3978, 3968, 0, N'CM-7(9)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3979, 3747, 1, N'CM-8', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3979, 3968, 0, N'CM-8', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3980, 3747, 1, N'CM-8(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3980, 3968, 0, N'CM-8(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3981, 3747, 1, N'CM-8(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3981, 3968, 0, N'CM-8(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3982, 3747, 1, N'CM-8(4)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3982, 3968, 0, N'CM-8(4)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3983, 3747, 1, N'CM-8(6)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3983, 3968, 0, N'CM-8(6)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3984, 3747, 1, N'CM-8(7)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3984, 3968, 0, N'CM-8(7)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3985, 3747, 1, N'CM-8(8)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3985, 3968, 0, N'CM-8(8)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3986, 3747, 1, N'CM-8(9)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3986, 3968, 0, N'CM-8(9)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3987, 3747, 1, N'CM-9', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3987, 3968, 0, N'CM-9', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3988, 3747, 1, N'CM-9(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3988, 3968, 0, N'CM-9(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3989, 3747, 1, N'CM-10', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3989, 3968, 0, N'CM-10', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3990, 3747, 1, N'CM-10(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3990, 3968, 0, N'CM-10(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3991, 3747, 1, N'CM-11', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3991, 3968, 0, N'CM-11', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3992, 3747, 1, N'CM-12', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3992, 3968, 0, N'CM-12', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3993, 3747, 1, N'CM-12(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3993, 3968, 0, N'CM-12(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3994, 3747, 1, N'CM-13', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3994, 3968, 0, N'CM-13', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3995, 3747, 1, N'CM-14', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3995, 3968, 0, N'CM-14', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3996, 3747, 1, N'CP-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3996, 3968, 0, N'CP-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3997, 3747, 1, N'CP-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3997, 3968, 0, N'CP-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3998, 3747, 1, N'CP-2(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3998, 3968, 0, N'CP-2(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3999, 3747, 1, N'CP-2(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (3999, 3968, 0, N'CP-2(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4000, 3747, 1, N'CP-2(7)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4000, 3968, 0, N'CP-2(7)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4001, 3747, 1, N'CP-2(8)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4001, 3968, 0, N'CP-2(8)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4002, 3747, 1, N'CP-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4002, 3968, 0, N'CP-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4003, 3747, 1, N'CP-3(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4003, 3968, 0, N'CP-3(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4004, 3747, 1, N'CP-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4004, 3968, 0, N'CP-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4005, 3747, 1, N'CP-6', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4005, 3968, 0, N'CP-6', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4006, 3747, 1, N'CP-6(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4006, 3968, 0, N'CP-6(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4007, 3747, 1, N'CP-7', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4007, 3968, 0, N'CP-7', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4008, 3747, 1, N'CP-8', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4008, 3968, 0, N'CP-8', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4009, 3747, 1, N'CP-8(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4009, 3968, 0, N'CP-8(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4010, 3747, 1, N'CP-8(4)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4010, 3968, 0, N'CP-8(4)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4011, 3747, 1, N'CP-11', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4011, 3968, 0, N'CP-11', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4012, 3747, 1, N'IA-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4012, 3968, 0, N'IA-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4013, 3747, 1, N'IA-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4013, 3968, 0, N'IA-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4014, 3747, 1, N'IA-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4014, 3968, 0, N'IA-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4015, 3747, 1, N'IA-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4015, 3968, 0, N'IA-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4016, 3747, 1, N'IA-4(6)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4016, 3968, 0, N'IA-4(6)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4017, 3747, 1, N'IA-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4017, 3968, 0, N'IA-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4018, 3747, 1, N'IA-5(5)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4018, 3968, 0, N'IA-5(5)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4019, 3747, 1, N'IA-5(9)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4019, 3968, 0, N'IA-5(9)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4020, 3747, 1, N'IA-8', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4020, 3968, 0, N'IA-8', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4021, 3747, 1, N'IA-9', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4021, 3968, 0, N'IA-9', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4022, 3747, 1, N'IR-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4022, 3968, 0, N'IR-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4023, 3747, 1, N'IR-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4023, 3968, 0, N'IR-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4024, 3747, 1, N'IR-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4024, 3968, 0, N'IR-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4025, 3747, 1, N'IR-4(6)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4025, 3968, 0, N'IR-4(6)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4026, 3747, 1, N'IR-4(7)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4026, 3968, 0, N'IR-4(7)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4027, 3747, 1, N'IR-4(10)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4027, 3968, 0, N'IR-4(10)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4028, 3747, 1, N'IR-4(11)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4028, 3968, 0, N'IR-4(11)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4029, 3747, 1, N'IR-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4029, 3968, 0, N'IR-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4030, 3747, 1, N'IR-6(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4030, 3968, 0, N'IR-6(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4031, 3747, 1, N'IR-7(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4031, 3968, 0, N'IR-7(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4032, 3747, 1, N'IR-8', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4032, 3968, 0, N'IR-8', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4033, 3747, 1, N'IR-9', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4033, 3968, 0, N'IR-9', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4034, 3747, 1, N'MA-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4034, 3968, 0, N'MA-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4035, 3747, 1, N'MA-2(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4035, 3968, 0, N'MA-2(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4036, 3747, 1, N'MA-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4036, 3968, 0, N'MA-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4037, 3747, 1, N'MA-3(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4037, 3968, 0, N'MA-3(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4038, 3747, 1, N'MA-3(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4038, 3968, 0, N'MA-3(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4039, 3747, 1, N'MA-3(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4039, 3968, 0, N'MA-3(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4040, 3747, 1, N'MA-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4040, 3968, 0, N'MA-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4041, 3747, 1, N'MA-4(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4041, 3968, 0, N'MA-4(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4042, 3747, 1, N'MA-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4042, 3968, 0, N'MA-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4043, 3747, 1, N'MA-5(4)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4043, 3968, 0, N'MA-5(4)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4044, 3747, 1, N'MA-6', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4044, 3968, 0, N'MA-6', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4045, 3747, 1, N'MA-7', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4045, 3968, 0, N'MA-7', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4046, 3747, 1, N'MA-8', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4046, 3968, 0, N'MA-8', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4047, 3747, 1, N'MP-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4047, 3968, 0, N'MP-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4048, 3747, 1, N'MP-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4048, 3968, 0, N'MP-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4049, 3747, 1, N'MP-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4049, 3968, 0, N'MP-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4050, 3747, 1, N'MP-6', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4050, 3968, 0, N'MP-6', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4051, 3747, 1, N'PE-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4051, 3968, 0, N'PE-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4052, 3747, 1, N'PE-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4052, 3968, 0, N'PE-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4053, 3747, 1, N'PE-2(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4053, 3968, 0, N'PE-2(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4054, 3747, 1, N'PE-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4054, 3968, 0, N'PE-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4055, 3747, 1, N'PE-3(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4055, 3968, 0, N'PE-3(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4056, 3747, 1, N'PE-3(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4056, 3968, 0, N'PE-3(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4057, 3747, 1, N'PE-3(5)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4057, 3968, 0, N'PE-3(5)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4058, 3747, 1, N'PE-6', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4058, 3968, 0, N'PE-6', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4059, 3747, 1, N'PE-16', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4059, 3968, 0, N'PE-16', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4060, 3747, 1, N'PE-17', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4060, 3968, 0, N'PE-17', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4061, 3747, 1, N'PE-18', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4061, 3968, 0, N'PE-18', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4062, 3747, 1, N'PE-20', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4062, 3968, 0, N'PE-20', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4063, 3747, 1, N'PE-23', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4063, 3968, 0, N'PE-23', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4064, 3747, 1, N'PL-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4064, 3968, 0, N'PL-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4065, 3747, 1, N'PL-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4065, 3968, 0, N'PL-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4066, 3747, 1, N'PL-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4066, 3968, 0, N'PL-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4067, 3747, 1, N'PL-7', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4067, 3968, 0, N'PL-7', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4068, 3747, 1, N'PL-8', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4068, 3968, 0, N'PL-8', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4069, 3747, 1, N'PL-8(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4069, 3968, 0, N'PL-8(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4070, 3747, 1, N'PL-9', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4070, 3968, 0, N'PL-9', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4071, 3747, 1, N'PL-10', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4071, 3968, 0, N'PL-10', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4072, 3747, 1, N'PM-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4072, 3968, 0, N'PM-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4073, 3747, 1, N'PM-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4073, 3968, 0, N'PM-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4074, 3747, 1, N'PM-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4074, 3968, 0, N'PM-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4075, 3747, 1, N'PM-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4075, 3968, 0, N'PM-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4076, 3747, 1, N'PM-6', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4076, 3968, 0, N'PM-6', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4077, 3747, 1, N'PM-7', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4077, 3968, 0, N'PM-7', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4078, 3747, 1, N'PM-8', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4078, 3968, 0, N'PM-8', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4079, 3747, 1, N'PM-9', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4079, 3968, 0, N'PM-9', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4080, 3747, 1, N'PM-10', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4080, 3968, 0, N'PM-10', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4081, 3747, 1, N'PM-11', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4081, 3968, 0, N'PM-11', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4082, 3747, 1, N'PM-12', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4082, 3968, 0, N'PM-12', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4083, 3747, 1, N'PM-13', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4083, 3968, 0, N'PM-13', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4084, 3747, 1, N'PM-14', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4084, 3968, 0, N'PM-14', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4085, 3747, 1, N'PM-15', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4085, 3968, 0, N'PM-15', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4086, 3747, 1, N'PM-16', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4086, 3968, 0, N'PM-16', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4087, 3747, 1, N'PM-17', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4087, 3968, 0, N'PM-17', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4088, 3747, 1, N'PM-18', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4088, 3968, 0, N'PM-18', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4089, 3747, 1, N'PM-19', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4089, 3968, 0, N'PM-19', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4090, 3747, 1, N'PM-20', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4090, 3968, 0, N'PM-20', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4091, 3747, 1, N'PM-21', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4091, 3968, 0, N'PM-21', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4092, 3747, 1, N'PM-22', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4092, 3968, 0, N'PM-22', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4093, 3747, 1, N'PM-23', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4093, 3968, 0, N'PM-23', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4094, 3747, 1, N'PM-25', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4094, 3968, 0, N'PM-25', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4095, 3747, 1, N'PM-26', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4095, 3968, 0, N'PM-26', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4096, 3747, 1, N'PM-27', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4096, 3968, 0, N'PM-27', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4097, 3747, 1, N'PM-28', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4097, 3968, 0, N'PM-28', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4098, 3747, 1, N'PM-29', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4098, 3968, 0, N'PM-29', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4099, 3747, 1, N'PM-30', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4099, 3968, 0, N'PM-30', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4100, 3747, 1, N'PM-31', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4100, 3968, 0, N'PM-31', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4101, 3747, 1, N'PM-32', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4101, 3968, 0, N'PM-32', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4102, 3747, 1, N'PS-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4102, 3968, 0, N'PS-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4103, 3747, 1, N'PS-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4103, 3968, 0, N'PS-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4104, 3747, 1, N'PS-6', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4104, 3968, 0, N'PS-6', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4105, 3747, 1, N'PS-7', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4105, 3968, 0, N'PS-7', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4106, 3747, 1, N'PT-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4106, 3968, 0, N'PT-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4107, 3747, 1, N'RA-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4107, 3968, 0, N'RA-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4108, 3747, 1, N'RA-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4108, 3968, 0, N'RA-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4109, 3747, 1, N'RA-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4109, 3968, 0, N'RA-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4110, 3747, 1, N'RA-3(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4110, 3968, 0, N'RA-3(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4111, 3747, 1, N'RA-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4111, 3968, 0, N'RA-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4112, 3747, 1, N'RA-5(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4112, 3968, 0, N'RA-5(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4113, 3747, 1, N'RA-5(6)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4113, 3968, 0, N'RA-5(6)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4114, 3747, 1, N'RA-7', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4114, 3968, 0, N'RA-7', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4115, 3747, 1, N'RA-9', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4115, 3968, 0, N'RA-9', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4116, 3747, 1, N'RA-10', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4116, 3968, 0, N'RA-10', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4117, 3747, 1, N'SA-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4117, 3968, 0, N'SA-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4118, 3747, 1, N'SA-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4118, 3968, 0, N'SA-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4119, 3747, 1, N'SA-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4119, 3968, 0, N'SA-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4120, 3747, 1, N'SA-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4120, 3968, 0, N'SA-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4121, 3747, 1, N'SA-4(5)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4121, 3968, 0, N'SA-4(5)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4122, 3747, 1, N'SA-4(7)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4122, 3968, 0, N'SA-4(7)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4123, 3747, 1, N'SA-4(8)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4123, 3968, 0, N'SA-4(8)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4124, 3747, 1, N'SA-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4124, 3968, 0, N'SA-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4125, 3747, 1, N'SA-8', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4125, 3968, 0, N'SA-8', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4126, 3747, 1, N'SA-9(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4126, 3968, 0, N'SA-9(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4127, 3747, 1, N'SA-9(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4127, 3968, 0, N'SA-9(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4128, 3747, 1, N'SA-9(4)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4128, 3968, 0, N'SA-9(4)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4129, 3747, 1, N'SA-9(5)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4129, 3968, 0, N'SA-9(5)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4130, 3747, 1, N'SA-10', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4130, 3968, 0, N'SA-10', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4131, 3747, 1, N'SA-11', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4131, 3968, 0, N'SA-11', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4132, 3747, 1, N'SA-15', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4132, 3968, 0, N'SA-15', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4133, 3747, 1, N'SA-15(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4133, 3968, 0, N'SA-15(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4134, 3747, 1, N'SA-15(8)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4134, 3968, 0, N'SA-15(8)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4135, 3747, 1, N'SA-16', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4135, 3968, 0, N'SA-16', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4136, 3747, 1, N'SA-17', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4136, 3968, 0, N'SA-17', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4137, 3747, 1, N'SA-20', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4137, 3968, 0, N'SA-20', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4138, 3747, 1, N'SA-21', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4138, 3968, 0, N'SA-21', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4139, 3747, 1, N'SA-22', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4139, 3968, 0, N'SA-22', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4140, 3747, 1, N'SC-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4140, 3968, 0, N'SC-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4141, 3747, 1, N'SC-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4141, 3968, 0, N'SC-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4142, 3747, 1, N'SC-5(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4142, 3968, 0, N'SC-5(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4143, 3747, 1, N'SC-7', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4143, 3968, 0, N'SC-7', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4144, 3747, 1, N'SC-7(13)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4144, 3968, 0, N'SC-7(13)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4145, 3747, 1, N'SC-7(14)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4145, 3968, 0, N'SC-7(14)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4146, 3747, 1, N'SC-7(19)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4146, 3968, 0, N'SC-7(19)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4147, 3747, 1, N'SC-8', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4147, 3968, 0, N'SC-8', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4148, 3747, 1, N'SC-18', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4148, 3968, 0, N'SC-18', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4149, 3747, 1, N'SC-18(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4149, 3968, 0, N'SC-18(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4150, 3747, 1, N'SC-27', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4150, 3968, 0, N'SC-27', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4151, 3747, 1, N'SC-28', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4151, 3968, 0, N'SC-28', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4152, 3747, 1, N'SC-29', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4152, 3968, 0, N'SC-29', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4153, 3747, 1, N'SC-30', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4153, 3968, 0, N'SC-30', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4154, 3747, 1, N'SC-30(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4154, 3968, 0, N'SC-30(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4155, 3747, 1, N'SC-30(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4155, 3968, 0, N'SC-30(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4156, 3747, 1, N'SC-30(4)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4156, 3968, 0, N'SC-30(4)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4157, 3747, 1, N'SC-30(5)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4157, 3968, 0, N'SC-30(5)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4158, 3747, 1, N'SC-36', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4158, 3968, 0, N'SC-36', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4159, 3747, 1, N'SC-37(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4159, 3968, 0, N'SC-37(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4160, 3747, 1, N'SC-38', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4160, 3968, 0, N'SC-38', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4161, 3747, 1, N'SC-47', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4161, 3968, 0, N'SC-47', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4162, 3747, 1, N'SI-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4162, 3968, 0, N'SI-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4163, 3747, 1, N'SI-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4163, 3968, 0, N'SI-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4164, 3747, 1, N'SI-2(5)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4164, 3968, 0, N'SI-2(5)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4165, 3747, 1, N'SI-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4165, 3968, 0, N'SI-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4166, 3747, 1, N'SI-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4166, 3968, 0, N'SI-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4167, 3747, 1, N'SI-4(17)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4167, 3968, 0, N'SI-4(17)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4168, 3747, 1, N'SI-4(19)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4168, 3968, 0, N'SI-4(19)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4169, 3747, 1, N'SI-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4169, 3968, 0, N'SI-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4170, 3747, 1, N'SI-7', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4170, 3968, 0, N'SI-7', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4171, 3747, 1, N'SI-7(15)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4171, 3968, 0, N'SI-7(15)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4172, 3747, 1, N'SI-12', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4172, 3968, 0, N'SI-12', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4173, 3747, 1, N'SI-20', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4173, 3968, 0, N'SI-20', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4174, 3747, 1, N'SR-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4174, 3968, 0, N'SR-1', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4175, 3747, 1, N'SR-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4175, 3968, 0, N'SR-2', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4176, 3747, 1, N'SR-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4176, 3968, 0, N'SR-3', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4177, 3747, 1, N'SR-3(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4177, 3968, 0, N'SR-3(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4178, 3747, 1, N'SR-3(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4178, 3968, 0, N'SR-3(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4179, 3747, 1, N'SR-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4179, 3968, 0, N'SR-4', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4180, 3747, 1, N'SR-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4180, 3968, 0, N'SR-5', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4181, 3747, 1, N'SR-6', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4181, 3968, 0, N'SR-6', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4182, 3747, 1, N'SR-7', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4182, 3968, 0, N'SR-7', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4183, 3747, 1, N'SR-8', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4183, 3968, 0, N'SR-8', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4184, 3747, 1, N'SR-9', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4184, 3968, 0, N'SR-9', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4185, 3747, 1, N'SR-10', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4185, 3968, 0, N'SR-10', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4186, 3747, 1, N'SR-11', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4186, 3968, 0, N'SR-11', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4187, 3747, 1, N'SR-11(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4187, 3968, 0, N'SR-11(1)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4188, 3747, 1, N'SR-11(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4188, 3968, 0, N'SR-11(2)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4189, 3747, 1, N'SR-11(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4189, 3968, 0, N'SR-11(3)', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4190, 3747, 1, N'SR-12', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4190, 3968, 0, N'SR-12', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4191, 3747, 1, N'SR-13', NULL, NULL, NULL)
INSERT INTO [dbo].[REQUIREMENT_REFERENCES] ([Requirement_Id], [Gen_File_Id], [Source], [Section_Ref], [Page_Number], [Destination_String], [Sequence]) VALUES (4191, 3968, 0, N'SR-13', NULL, NULL, NULL)
PRINT(N'Operation applied to 584 rows out of 584')

PRINT(N'Add constraints to [dbo].[REQUIREMENT_REFERENCES]')
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] CHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] CHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT]

PRINT(N'Add constraints to [dbo].[GEN_FILE_LIB_PATH_CORL]')
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] CHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE]
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] CHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_REF_LIBRARY_PATH]

PRINT(N'Add constraints to [dbo].[REQUIREMENT_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_SETS] CHECK CONSTRAINT [FK_QUESTION_SETS_SETS]
ALTER TABLE [dbo].[REQUIREMENT_SETS] CHECK CONSTRAINT [FK_REQUIREMENT_SETS_NEW_REQUIREMENT]

PRINT(N'Add constraints to [dbo].[REQUIREMENT_LEVELS]')
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] CHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] WITH CHECK CHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_REQUIREMENT_LEVEL_TYPE]
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] CHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_STANDARD_SPECIFIC_LEVEL]

PRINT(N'Add constraints to [dbo].[PARAMETER_REQUIREMENTS]')
ALTER TABLE [dbo].[PARAMETER_REQUIREMENTS] CHECK CONSTRAINT [FK_Parameter_Requirements_NEW_REQUIREMENT]
ALTER TABLE [dbo].[PARAMETER_REQUIREMENTS] WITH CHECK CHECK CONSTRAINT [FK_Parameter_Requirements_Parameters]

PRINT(N'Add constraints to [dbo].[GEN_FILE]')
ALTER TABLE [dbo].[GEN_FILE] WITH CHECK CHECK CONSTRAINT [FK_GEN_FILE_FILE_REF_KEYS]
ALTER TABLE [dbo].[GEN_FILE] WITH CHECK CHECK CONSTRAINT [FK_GEN_FILE_FILE_TYPE]
ALTER TABLE [dbo].[FILE_KEYWORDS] CHECK CONSTRAINT [FILE_KEYWORDS_GEN_FILE_FK]
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[SET_FILES] WITH CHECK CHECK CONSTRAINT [FK_SET_FILES_GEN_FILE]

PRINT(N'Add constraints to [dbo].[GALLERY_GROUP_DETAILS]')
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_GROUP]
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]
ALTER TABLE [dbo].[PARAMETER_ASSESSMENT] WITH CHECK CHECK CONSTRAINT [FK_ASSESSMENT_PARAMETERS_PARAMETERS]
ALTER TABLE [dbo].[PARAMETER_VALUES] WITH CHECK CHECK CONSTRAINT [FK_PARAMETER_VALUES_PARAMETERS]

PRINT(N'Add constraints to [dbo].[NEW_REQUIREMENT]')
ALTER TABLE [dbo].[NEW_REQUIREMENT] CHECK CONSTRAINT [FK_NEW_REQUIREMENT_NCSF_Category]
ALTER TABLE [dbo].[NEW_REQUIREMENT] WITH CHECK CHECK CONSTRAINT [FK_NEW_REQUIREMENT_QUESTION_GROUP_HEADING]
ALTER TABLE [dbo].[NEW_REQUIREMENT] CHECK CONSTRAINT [FK_NEW_REQUIREMENT_STANDARD_CATEGORY]
ALTER TABLE [dbo].[FINANCIAL_REQUIREMENTS] WITH CHECK CHECK CONSTRAINT [FK_FINANCIAL_REQUIREMENTS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[NERC_RISK_RANKING] CHECK CONSTRAINT [FK_NERC_RISK_RANKING_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] WITH CHECK CHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_REFERENCE_TEXT] WITH CHECK CHECK CONSTRAINT [FK_REQUIREMENT_REFERENCE_TEXT_NEW_REQUIREMENT]
ALTER TABLE [dbo].[ASSESSMENTS] WITH CHECK CHECK CONSTRAINT [FK_ASSESSMENTS_GALLERY_ITEM]
ALTER TABLE [dbo].[STANDARD_SOURCE_FILE] CHECK CONSTRAINT [FK_Standard_Source_File_FILE_REF_KEYS]
COMMIT TRANSACTION
GO
