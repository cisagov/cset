/*
Run this script on:

(localdb)\INLLocalDB2022.NCUAWeb12400    -  This database will be modified

to synchronize it with:

(localdb)\INLLocalDB2022.NCUAWeb12401

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.10.9.22680 from Red Gate Software Ltd at 3/6/2025 3:43:43 PM

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

PRINT(N'Drop constraints from [dbo].[NEW_REQUIREMENT]')
ALTER TABLE [dbo].[NEW_REQUIREMENT] NOCHECK CONSTRAINT [FK_NEW_REQUIREMENT_NCSF_Category]
ALTER TABLE [dbo].[NEW_REQUIREMENT] NOCHECK CONSTRAINT [FK_NEW_REQUIREMENT_QUESTION_GROUP_HEADING]
ALTER TABLE [dbo].[NEW_REQUIREMENT] NOCHECK CONSTRAINT [FK_NEW_REQUIREMENT_SETS]
ALTER TABLE [dbo].[NEW_REQUIREMENT] NOCHECK CONSTRAINT [FK_NEW_REQUIREMENT_STANDARD_CATEGORY]

PRINT(N'Drop constraint FK_FINANCIAL_REQUIREMENTS_NEW_REQUIREMENT from [dbo].[FINANCIAL_REQUIREMENTS]')
ALTER TABLE [dbo].[FINANCIAL_REQUIREMENTS] NOCHECK CONSTRAINT [FK_FINANCIAL_REQUIREMENTS_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_NERC_RISK_RANKING_NEW_REQUIREMENT from [dbo].[NERC_RISK_RANKING]')
ALTER TABLE [dbo].[NERC_RISK_RANKING] NOCHECK CONSTRAINT [FK_NERC_RISK_RANKING_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_Parameter_Requirements_NEW_REQUIREMENT from [dbo].[PARAMETER_REQUIREMENTS]')
ALTER TABLE [dbo].[PARAMETER_REQUIREMENTS] NOCHECK CONSTRAINT [FK_Parameter_Requirements_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_LEVELS_NEW_REQUIREMENT from [dbo].[REQUIREMENT_LEVELS]')
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] NOCHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT from [dbo].[REQUIREMENT_QUESTIONS_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] NOCHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_REFERENCE_TEXT_NEW_REQUIREMENT from [dbo].[REQUIREMENT_REFERENCE_TEXT]')
ALTER TABLE [dbo].[REQUIREMENT_REFERENCE_TEXT] NOCHECK CONSTRAINT [FK_REQUIREMENT_REFERENCE_TEXT_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT from [dbo].[REQUIREMENT_REFERENCES]')
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] NOCHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT]

PRINT(N'Drop constraint FK_REQUIREMENT_SETS_NEW_REQUIREMENT from [dbo].[REQUIREMENT_SETS]')
ALTER TABLE [dbo].[REQUIREMENT_SETS] NOCHECK CONSTRAINT [FK_REQUIREMENT_SETS_NEW_REQUIREMENT]

PRINT(N'Drop constraints from [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Drop constraints from [dbo].[MATURITY_EXTRA]')
ALTER TABLE [dbo].[MATURITY_EXTRA] NOCHECK CONSTRAINT [fk_mat_questions]

PRINT(N'Drop constraints from [dbo].[ISE_ACTIONS]')
ALTER TABLE [dbo].[ISE_ACTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MAT_QUESTION_ID]

PRINT(N'Drop constraints from [dbo].[IRP]')
ALTER TABLE [dbo].[IRP] NOCHECK CONSTRAINT [FK_IRP_IRP_HEADER]

PRINT(N'Drop constraint FK__Assessmen__IRP_I__5EDF0F2E from [dbo].[ASSESSMENT_IRP]')
ALTER TABLE [dbo].[ASSESSMENT_IRP] NOCHECK CONSTRAINT [FK__Assessmen__IRP_I__5EDF0F2E]

PRINT(N'Drop constraint FK_ASSESSMENTS_GALLERY_ITEM from [dbo].[ASSESSMENTS]')
ALTER TABLE [dbo].[ASSESSMENTS] NOCHECK CONSTRAINT [FK_ASSESSMENTS_GALLERY_ITEM]

PRINT(N'Drop constraint FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM from [dbo].[GALLERY_GROUP_DETAILS]')
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] NOCHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]

PRINT(N'Delete row from [dbo].[MATURITY_REFERENCES]')
DELETE FROM [dbo].[MATURITY_REFERENCES] WHERE [Mat_Question_Id] = 7586 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 79' AND [Source] = 1

PRINT(N'Update rows in [dbo].[NEW_REQUIREMENT]')
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops, implements, and periodically reviews and updates:</p>
<ol>
  <li>A formal, documented, control system security policy that addresses:
    <ol type="a">
      <li>The purpose of the security program as it relates to protecting the organization''s personnel and assets.</li>
      <li>The scope of the security program as it applies to all organizational staff and third-party contractors.</li>
      <li>The roles, responsibilities, management commitment, and coordination among organizational entities of the security program to ensure compliance with the organization''s security policy and other regulatory commitments.</li>
    </ol>
  </li>
  <li>Formal, documented procedures to implement the security policy and associated requirements.</li>
</ol>
<p>A control system security policy considers controls from each family contained in this document.</p>' WHERE [Requirement_Id] = 4459
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>Baseline practices that organizations employ for organizational security include, but are not limited to:</p>
<ol>
  <li>Executive management accountability for the security program.</li>
  <li>Responsibility for control system security within the organization includes sufficient authority and an appropriate level of funding to implement the organization''s security policy.</li>
  <li>The organization''s security policies and procedures that provide clear direction, accountability, and oversight for the organization''s security team. The security team assigns roles and responsibilities in accordance with the organization''s policies and confirms that processes are in place to protect company assets and critical information.</li>
  <li>The organization''s contracts with external entities that address the organization''s security policies and procedures with business partners, third-party contractors, and outsourcing partners.</li>
  <li>The organization''s security policies and procedures that ensure coordination or integration with the organization''s physical security plan. Organization roles and responsibilities are established that address the overlap and synergy between physical and control system security risks.</li>
</ol>' WHERE [Requirement_Id] = 4462
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops, disseminates, and periodically reviews and updates:</p>
<ol>
  <li>A formal, documented, personnel security policy that addresses:
    <ol type="a">
      <li>The purpose of the security program as it relates to protecting the organization''s personnel and assets.</li>
      <li>The scope of the security program as it applies to all the organizational staff and third-party contractors.</li>
      <li>The roles, responsibilities, management commitment, and coordination among organizational entities of the security program to ensure compliance with the organization''s security policy and other regulatory commitments.</li>
    </ol>
  </li>
  <li>Formal, documented procedures to facilitate the implementation of the personnel security policy and associated personnel security controls.</li>
  <li>Formal procedures to review and document the list of approved personnel with access to control systems.</li>
</ol>' WHERE [Requirement_Id] = 4467
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization screens individuals requiring access to the control system before access is authorized.</p>
<p>Requirement Enhancement - The organization rescreens individuals with access to organizational control systems based on a defined list of conditions requiring rescreening and the frequency of such rescreening.</p>
' WHERE [Requirement_Id] = 4469
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>When an employee is terminated, the organization revokes logical and physical access to control systems and facilities and ensures all organization-owned property is returned and that organization-owned documents and data files relating to the control system that are in the employee''s possession are transferred to the new authorized owner within the organization. Complete execution of this control occurs within 24 hours for employees or contractors terminated for cause.</p>
<p>Requirement Enhancement - The organization implements automated processes to revoke access permissions that are initiated by the termination. Periodic reviews of physical and electronic access are conducted to validate terminated account access are removed.</p>
' WHERE [Requirement_Id] = 4471
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization reviews electronic and physical access permissions to control systems and facilities when individuals are reassigned or transferred to other positions within the organization and initiates appropriate actions. Complete execution of this control occurs within 7 days for employees or contractors who no longer need to access control system resources.</p>

<p>Requirement Enhancement - The organization periodically reviews existing authorized physical and electronic access permissions to ensure they are current.
This check is to provide validation that transferred entities have been added, changed, or removed correctly from necessary physical and electronic access.
</p>' WHERE [Requirement_Id] = 4473
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization provides employees and contractors with complete job descriptions and unambiguous and detailed expectations of conduct, duties, terms and conditions of employment, legal rights, and responsibilities.</p>
<p>Requirement Enhancement - Employees and contractors acknowledge understanding by signature.</p>' WHERE [Requirement_Id] = 4477
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops, implements, and periodically reviews and updates:</p>
<ol>
    <li>A formal, documented physical security policy that addresses:
        <ol type="a">
            <li>The purpose of the physical security program as it relates to protecting the organization''s personnel and assets.</li>
            <li>The scope of the physical security program as it applies to all the organizational staff and third-party contractors.</li>
            <li>The roles, responsibilities, management commitment, and coordination among organizational entities of the physical security program to ensure compliance with the organization''s security policy and other regulatory commitments.</li>
        </ol>
    </li>
    <li>Formal, documented procedures to facilitate the implementation of the physical and environmental protection policy and associated physical and environmental protection controls.</li>
</ol>
' WHERE [Requirement_Id] = 4479
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops and maintains lists of personnel with authorized access to facilities containing control systems (except for areas within facilities officially designated as publicly accessible) and issue appropriate authorization credentials (e.g., badges, identification cards, smart cards). Designated officials within the organization review and approve the access list and authorization credentials at least annually, removing from the access list personnel no longer requiring access.</p>

    <p>Requirement Enhancement 1 - The organization authorizes physical access to the facility where the control system resides based on position or role.</p>
    <p>Requirement Enhancement 2 - The organization requires two forms of identification to gain access to the facility where the control system resides.</p>
' WHERE [Requirement_Id] = 4480
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Enforces physical access authorizations for all physical access points (including designated entry/exit points) to the facility where the control system resides (excluding those areas within the facility officially designated as publicly accessible).</li>
  <li>Verifies individual access authorizations before granting access to the facility.</li>
  <li>Controls entry to facilities containing control systems using physical access devices and guards.</li>
  <li>Controls access to areas officially designated as publicly accessible in accordance with the organization''s assessment of risk.</li>
  <li>Secures keys, combinations, and other physical access devices.</li>
  <li>Inventories physical access devices on a periodic basis.</li>
  <li>Changes combinations and keys on an organization-defined frequency and when keys are lost, combinations are compromised, or individuals are transferred or terminated.</li>
  <li>Controls and verifies physical access to information system distribution and transmission lines of communications within the organizational facilities.</li>
  <li>Controls physical access to information system output devices (e.g., monitors, speakers, printers) to prevent unauthorized individuals from observing and obtaining information access.</li>
</ol>
<p>Requirement Enhancement 1 - The organization limits physical access to control system assets independent of the physical access security mechanisms for the facility.</p>
<p>Requirement Enhancement 2 - The organization performs security checks at physical boundaries for unauthorized removal of information or system components.</p>
<p>Requirement Enhancement 3 - The organization ensures that every physical access point to the facility where the system resides is guarded or alarmed and monitored 24 hours per day, 7 days per week.</p>
<p>Requirement Enhancement 4 - The organization employs lockable physical casings to protect internal components of the system from unauthorized physical access.</p>
<p>Requirement Enhancement 5 - The organization identifies and inspects information and communication lines for evidence of tampering.</p>' WHERE [Requirement_Id] = 4482
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
    <li>Monitors physical access to the control system to detect and respond to physical security incidents.</li>
    <li>Reviews physical access logs on an organization-defined frequency.</li>
    <li>Coordinates results of reviews and investigations with the organization''s incident response capability.</li>
</ol>
<p>Requirement Enhancement 1 - The organization monitors real-time physical intrusion alarms and surveillance equipment.</p>
    <p>Requirement Enhancement 2 - The organization implements automated mechanisms to recognize potential intrusions and initiates designated response actions.</p>
' WHERE [Requirement_Id] = 4485
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization controls physical access to the system by authenticating visitors before authorizing access to the facility where the system resides other than areas designated as publicly accessible.</p>
<p>Requirement Enhancement 1 - The organization escorts visitors and monitors visitor activity as required according to security policies and procedures.</p>
<p>Requirement Enhancement 2 - The organization requires two forms of identification for access to the facility.</p>
' WHERE [Requirement_Id] = 4488
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization maintains visitor access records to the control system facility (except for those areas within the facility officially designated as publicly accessible) that include:
    <ol>
      <li>Name and organization of the person visiting</li>
      <li>Signature of the visitor</li>
      <li>Form of identification</li>
      <li>Date of access</li>
      <li>Time of entry and departure</li>
      <li>Purpose of visit</li>
      <li>Name and organization of person visited</li>
    </ol>
  </p>' WHERE [Requirement_Id] = 4491
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization provides a short-term uninterruptible power supply to facilitate an orderly shutdown of noncritical control system components in the event of a primary power source loss.</p>
<p>Requirement Enhancement 1 - The organization provides a long-term alternate power supply for the system that is capable of maintaining minimally required operational capability in the event of an extended loss of the primary power source.</p>
<p>Requirement Enhancement 2 - The organization provides a long-term alternate power supply for the system that is self-contained and not reliant on external power generation.</p>
' WHERE [Requirement_Id] = 4496
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization implements and maintains fire suppression and detection devices/systems that can be activated in the event of a fire.</p>
<p>Requirement Enhancement 1 - The organization employs fire detection devices/systems that activate automatically and notify the organization and emergency responders in the event of a fire.</p>
<p>Requirement Enhancement 2 - The organization employs fire suppression devices/systems that provide automatic notification of any activation to the organization and emergency responders.</p>
<p>Requirement Enhancement 3 - The organization employs an automatic fire suppression capability in facilities that are not staffed continuously.</p>
' WHERE [Requirement_Id] = 4500
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization protects the control systems from damage resulting from water leakage by ensuring that master shutoff valves are accessible, working properly, and known to key personnel.</p>
<p>Requirement Enhancement - The organization implements automated mechanisms to close shutoff valves and provide notification to key personnel in the event of a water leak within facilities containing control systems.</p>
' WHERE [Requirement_Id] = 4503
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Establishes usage restrictions and implementation guidance for organization-controlled mobile devices.</li>
  <li>Authorizes connection of mobile devices to organizational control systems.</li>
  <li>Monitors for unauthorized connections of mobile devices to organizational control systems.</li>
  <li>Enforces requirements for the connection of mobile devices to organizational control systems.</li>
  <li>Disables control system functionality that provides the capability for automatic execution of code on removable media without user direction.</li>
  <li>Issues specially configured mobile devices to individuals traveling to locations that the organization deems to be of significant risk in accordance with organizational policies and procedures.</li>
  <li>Applies specified measures to mobile devices returning from locations that the organization deems to be of significant risk in accordance with organizational policies and procedures.</li>
</ol>
<p>Requirement Enhancement 1 - The organization restricts the use of writable, removable media in organizational control systems.</p>
<p>Requirement Enhancement 2 - The organization prohibits the use of personally owned, removable media in organizational control systems.</p>
<p>Requirement Enhancement 3 - The organization prohibits the use of removable media in organizational control systems when the media have no identifiable owner.</p>' WHERE [Requirement_Id] = 4508
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization implements asset location technologies to track and monitor the movements of personnel and vehicles within the organization''s controlled areas to ensure they stay in authorized areas, to identify personnel needing assistance, and to support emergency response.</p>
<p>Requirement Enhancement - Electronic monitoring mechanisms alert control system personnel when unauthorized access or an emergency occurs.</p>
' WHERE [Requirement_Id] = 4510
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization employs hardware (cages, locks, cases, etc.) to detect and deter unauthorized physical access to control system devices.</p>
<p>Requirement Enhancement - The organization ensures that the ability to respond appropriately in the event of an emergency is not hindered by using tamper-evident hardware.</p>
' WHERE [Requirement_Id] = 4517
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops, disseminates, and periodically reviews and updates:</p>
<ol>
  <li>A formal, documented, system and services acquisition policy that includes control system security considerations and that addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance.</li>
  <li>Formal, documented procedures to facilitate the implementation of the system and services acquisition policy and associated system and services acquisition controls.</li>
</ol>' WHERE [Requirement_Id] = 4519
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Includes a determination of control system security requirements for the system in mission/business case planning.</li>
  <li>Determines, documents, and allocates the resources required to protect the control system as part of its capital planning and investment control process.</li>
</ol>' WHERE [Requirement_Id] = 4520
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization includes the following requirements and specifications, explicitly or by reference, in control system acquisition contracts based on an assessment of risk and in accordance with applicable laws, directives, policies, regulations, and standards:</p>
<ol>
  <li>Security functional requirements/specifications.</li>
  <li>Security-related documentation requirements.</li>
  <li>Developmental and evaluation-related assurance requirements.</li>
</ol>
<p>Requirements Enhancement 1 - The organization requires in acquisition documents that vendors/contractors provide information describing the functional properties of the security controls employed within the control system.</p>
<p>Requirements Enhancement 2 - The organization requires in acquisition documents that vendors/contractors provide information describing the design and implementation details of the security controls employed within the control system (including functional interfaces among control components).</p>
<p>Requirements Enhancement 3 - The organization limits the acquisition of commercial technology products with security capabilities to products that have been evaluated and validated through a government-approved process.</p>' WHERE [Requirement_Id] = 4522
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Obtains, protects as required, and makes available to authorized personnel, administrator and user guidance for the control system that includes information on:
    <ol type="a">
      <li>configuring, installing, and operating the system and</li>
      <li>using the system''s security features, or</li>
    </ol>
  </li>
  <li>Documents attempts to obtain control system documentation when such documentation is either unavailable or nonexistent (e.g., because of the age of the system or lack of support from the vendor/contractor) and provides compensating security controls, if needed.</li>
</ol>
<p>Requirement Enhancement 1 - The organization obtains, if available from the vendor/contractor, information describing the functional properties of the security controls employed within the control system.</p>
<p>Requirement Enhancement 2 - The organization obtains, if available from the vendor/contractor, information describing the design and implementation details of the security controls employed within the control system (including functional interfaces among control components).</p>
<p>Requirement Enhancement 3 - The organization obtains, if available from the vendor/contractor, information that describes the security-relevant external interfaces to the control system.</p>' WHERE [Requirement_Id] = 4526
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Uses software and associated documentation in accordance with contract agreements and copyright laws.</li>
  <li>Employs tracking systems for software and associated documentation protected by quantity licenses to control copying and distribution.</li>
  <li>Controls and documents the use of publicly accessible peer-to-peer file sharing technology to ensure that this capability is not used for the unauthorized distribution, display, performance, or reproduction of copyrighted work.</li>
</ol>' WHERE [Requirement_Id] = 4529
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Requires that providers of external control system services employ security controls in accordance with applicable laws, directives, policies, regulations, standards, guidance, and established service-level agreements.</li>
  <li>Defines government oversight and user roles and responsibilities with regard to external control system services.</li>
  <li>Monitors security control compliance by external service providers.</li>
</ol>
' WHERE [Requirement_Id] = 4533
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops, disseminates, and periodically reviews and updates:</p>
<ol>
  <li>A formal, documented configuration management policy that addresses:
    <ol type="a">
      <li>The purpose of the configuration management policy as it relates to protecting the organization''s personnel and assets.</li>
      <li>The scope of the configuration management policy as it applies to all the organizational staff and third-party contractors.</li>
      <li>The roles, responsibilities, management accountability structure, and coordination among organizational entities contained in the configuration management policy to ensure compliance with the organization''s security policy and other regulatory commitments.</li>
    </ol>
  </li>
  <li>Formal, documented procedures to facilitate the implementation of the configuration management policy and associated configuration management controls.</li>
  <li>The personnel qualification levels required to make changes, the conditions under which changes are allowed, and what approvals are required for those changes.</li>
</ol>' WHERE [Requirement_Id] = 4544
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops, documents, and maintains a current baseline configuration of the control system and an inventory of the system''s constituent components.</p>
<p>Requirement Enhancement 1 - The organization reviews and updates the baseline configuration as an integral part of control system component installations.</p>
<p>Requirement Enhancement 2 - The organization employs automated mechanisms to maintain an up-to-date, complete, accurate, and readily available baseline configuration of the control system.</p>
<p>Requirement Enhancement 3 - The organization maintains a baseline configuration for development and test environments that is managed separately from the operational baseline configuration.</p>
<p>Requirement Enhancement 4 - The organization employs a deny-all, permit-by-exception authorization policy to identify software allowed on organizational control systems.</p>
' WHERE [Requirement_Id] = 4545
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Establishes mandatory configuration settings for products employed within the control system.</li>
  <li>Configures the security settings of control systems technology products to the most restrictive mode consistent with control system operational requirements.</li>
  <li>Documents the changed configuration settings.</li>
  <li>Identifies, documents, and approves exceptions from the mandatory configuration settings for individual components within the control system based on explicit operational requirements.</li>
  <li>Enforces the configuration settings in all components of the control system.</li>
  <li>Monitors and controls changes to the configuration settings in accordance with organizational policies and procedures.</li>
</ol>
<p>Requirement Enhancement 1 - The organization employs automated mechanisms to centrally manage, apply, and verify configuration settings.</p>
<p>Requirement Enhancement 2 - The organization employs automated mechanisms to respond to unauthorized changes to configuration settings.</p>
<p>Requirement Enhancement 3 - The organization incorporates detection of unauthorized, security-relevant configuration changes into the organization''s incident response capability to ensure that such detected events are tracked, monitored, corrected, and available for historical purposes.</p>

' WHERE [Requirement_Id] = 4553
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops, documents, and maintains an inventory of the components of the control system that:</p>
<ol>
  <li>Accurately reflects the current control system.</li>
  <li>Is consistent with the authorization boundary of the control system.</li>
  <li>Is at the level of granularity deemed necessary for tracking and reporting.</li>
  <li>Includes defined information deemed necessary to achieve effective property accountability.</li>
</ol>
<p>Requirement Enhancement 1 - The organization updates the inventory of control system components and programming as an integral part of component installation, replacement and system updates.</p>
<p>Requirement Enhancement 2 - The organization employs automated mechanisms to help maintain an up-to-date, complete, accurate, and readily available inventory of control system components, configuration files and set points, alarm settings and other required operational settings.</p>
<p>Requirement Enhancement 3 - The organization employs automated mechanisms to detect the addition of unauthorized components/devices/component settings into the control system.</p>
<p>Requirement Enhancement 4 - The organization disables network access by such components/devices or notifies designated organizational officials.</p>
<p>Requirement Enhancement 5 - The organization includes in property accountability information for control system components, the names of the individuals responsible for administering those components.</p>
' WHERE [Requirement_Id] = 4559
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization implements policy and procedures to address the addition, removal, and disposal of all control system equipment. All control system assets and information are documented, identified, and tracked so that the location and function are known.</p>
<p>Requirement Enhancement 1 - Specialized critical digital assets must require internal registration, configuration and usage plan, and secure storage before, during and after usage.</p>
<p>Requirement Enhancement 2 - Critical Digital Assets in security arenas, such as laptop and desktop computers, network gear, hard drives, removable electronic media (e.g., CD/DVD/Tape/USB/SD), must be destroyed on removal from operations, or inspected and undergo approved documented de-sanitization procedures (deep formatting or destruction) on being removed from service.</p>
' WHERE [Requirement_Id] = 4563
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization changes all factory default authentication credentials on control system components and applications upon installation. </p>
<p>Requirement Enhancement - Known legacy operational equipment needs compensatory access restrictions to protect against loss of authentication. In addition, these components need to be identified, tested, and documented to verify that proposed compensatory measures are effective.</p>
' WHERE [Requirement_Id] = 4565
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops, disseminates, and periodically reviews and updates:</p>
<ol>
  <li>A formal, documented, planning policy that addresses:
    <ol type="a">
      <li>The purpose of the strategic planning program as it relates to protecting the organization''s personnel and assets.</li>
      <li>The scope of the strategic planning program as it applies to all the organizational staff and third-party contractors.</li>
      <li>The roles, responsibilities, coordination among organizational entities, and management accountability structure of the strategic planning program to ensure compliance with the organization''s security policy and other regulatory commitments.</li>
    </ol>
  </li>
  <li>Formal, documented procedures to facilitate the implementation of the strategic planning policy and associated strategic planning controls.</li>
</ol>' WHERE [Requirement_Id] = 4569
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Develops a security plan for the system that:
    <ol type="a">
      <li>Aligns with the organization''s enterprise architecture.</li>
      <li>Explicitly defines the authorization boundary for the system.</li>
      <li>Describes relationships with or connections to other systems.</li>
      <li>Provides an overview of the security requirements for the system.</li>
      <li>Describes the security controls in place or planned for meeting those requirements.</li>
      <li>Specifies the authorizing official or authorizing official designated representative who reviews and approves the control system security plan prior to implementation.</li>
    </ol>
  </li>
  <li>Reviews the security plan for the system on an organization-defined frequency, at least annually.</li>
  <li>Revises the plan to address changes to the system/environment of operation or problems identified during plan implementation or security control assessments.</li>
</ol>
<p>Requirement Enhancement - Secure control system operations require more in-depth and specialized security plans, which limit data ports, physical access, specific data technology (Fiber), additional physical and electronic inspections and physical separation requirements.</p>
' WHERE [Requirement_Id] = 4570
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization establishes and makes readily available to all control system users a set of rules that describes their responsibilities and expected behavior with regard to control system usage. The organization obtains signed acknowledgment from users indicating that they have read, understand, and agree to abide by the rules of behavior before authorizing access to the control system.</p>
<p>Requirement Enhancement - The organization includes in the rules of behavior explicit restrictions on the use of social networking sites, posting information on commercial web sites, and sharing system account information.</p>
' WHERE [Requirement_Id] = 4580
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops, disseminates, and periodically reviews and updates:</p>
<ol>
  <li>A formal, documented system and communication protection policy that addresses:
    <ol type="a">
      <li>The purpose of the system and communication protection policy as it relates to protecting the organization''s personnel and assets.</li>
      <li>The scope of the system and communication protection policy as it applies to all the organizational staff and third-party contractors.</li>
      <li>The roles, responsibilities, coordination among organizational entities, and management accountability structure of the security program to ensure compliance with the organization''s system and communications protection policy and other regulatory commitments.</li>
    </ol>
  </li>
  <li>Formal, documented procedures to facilitate the implementation of the control system and communication protection policy and associated systems and communication protection controls.</li>
</ol>
' WHERE [Requirement_Id] = 4583
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The control system protects against or limits the effects of denial-of-service attacks based on an organization''s defined list of types of denial-of-service attacks.</p>
<p>Requirement Enhancement 1 - The control system restricts the ability of users to launch denial-of-service attacks against other control systems or networks.</p>
<p>Requirement Enhancement 2 - The control system manages excess capacity, bandwidth, or other redundancy to limit the effects of information flooding types of denial-of-service attacks.</p>
' WHERE [Requirement_Id] = 4589
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization defines the external boundaries of the control system. Procedural and policy security functions define the operational system boundary, the strength required of the boundary, and the respective barriers to unauthorized access and control of system assets and components. The control system monitors and manages communications at the operational system boundary and at key internal boundaries within the system.</p>
<p>Requirement Enhancement 1 - The organization physically allocates publicly accessible control system components to separate subnetworks with separate, physical network interfaces. Publicly accessible control system components include public web servers. Generally, no control system information should be publicly accessible.</p>
<p>Requirement Enhancement 2 - The organization prevents public access into the organization''s internal control system networks except as appropriately mediated.</p>
<p>Requirement Enhancement 3 - The organization limits the number of access points to the control system to allow for better monitoring of inbound and outbound network traffic.</p>
<p>Requirement Enhancement 4 - The organization implements a managed interface (boundary protection devices in an effective security architecture) with any external telecommunication service, implementing security measures appropriate to the required protection of the integrity and confidentiality of the information being transmitted.</p>
<p>Requirement Enhancement 5 - The control system denies network traffic by default and allows network traffic by exception (i.e., deny all, permit by exception).</p>
<p>Requirement Enhancement 6 - The organization prevents the unauthorized release of information outside the control system boundary or any unauthorized communication through the control system boundary when an operational failure occurs of the boundary protection mechanisms.</p>
<p>Requirement Enhancement 7 - The organization prevents the unauthorized release of information across managed interfaces.</p>
<p>Requirement Enhancement 8 - The control system checks incoming communications to ensure that the communications are coming from an authorized source and routed to an authorized destination.</p>
<p>Requirement Enhancement 9 - The control system at managed interfaces, denies network traffic and audits internal users (or malicious code) posing a threat to external systems.</p>
<p>Requirement Enhancement 10 - The control system prevents remote devices that have established connections with the system from communicating outside that communications path with resources on uncontrolled/unauthorized networks.</p>
<p>Requirement Enhancement 11 - The control system routes all internal communications traffic to the Internet through authenticated proxy servers within the managed interfaces of boundary protection devices.</p>
<p>Requirement Enhancement 12 - The organization selects an appropriate failure mode (e.g., fail open or fail close), depending on the critical needs of system availability.</p>
' WHERE [Requirement_Id] = 4592
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>When cryptography is required and employed within the control system, the organization establishes and manages cryptographic keys using automated mechanisms with supporting procedures or manual procedures.</p>
<p>Requirement Enhancement - The organization maintains availability of information in the event of the loss of cryptographic keys by users.</p>
' WHERE [Requirement_Id] = 4603
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops and implements a policy governing the use of cryptographic mechanisms for the protection of control system information. The organization ensures all cryptographic mechanisms comply with applicable laws, regulatory requirements, directives, policies, standards, and guidance.</p>
<p>Requirement Enhancement 1 - The organization protects cryptographic hardware from physical tampering and uncontrolled electronic connections.</p>
<p>Requirement Enhancement 2 - The organization selects cryptographic hardware with remote key management capabilities.</p>
' WHERE [Requirement_Id] = 4605
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The use of collaborative computing devices on the control system is strongly discouraged. If use is authorized and allowed by the organization, explicit indication of use is provided to users physically present at the devices.</p>
<p>Requirement Enhancement 1 - If collaborative computing devices are used on the control system, they are disconnected and powered down when not in use.</p>
<p>Requirement Enhancement 2 - The control system or supporting environment blocks both inbound and outbound traffic between instant messaging clients that are independently configured by end users and external service providers.</p>
<p>Requirement Enhancement 3 - The organization disables or removes collaborative computing devices from control systems in organization-defined secure work areas.</p>
' WHERE [Requirement_Id] = 4607
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The control system resource (i.e., authoritative DNS server) that provides name/address resolution service provides additional artifacts (e.g., digital signatures and cryptographic keys) along with the authoritative DNS resource records it returns in response to resolution queries.</p>
<p>Requirement Enhancement - The control system, when operating as part of a distributed, hierarchical namespace, provides the means to indicate the security status of child subspaces and (if the child supports secure resolution services) enable verification of a chain of trust among parent and child domains.</p>
' WHERE [Requirement_Id] = 4622
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops, disseminates, and periodically reviews and updates:</p>
<ol>
  <li>A formal, documented, control system information and document management policy that addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance.</li>
  <li>Formal, documented procedures to facilitate the implementation of the control system information and document management policy and associated system maintenance controls.</li>
</ol>
' WHERE [Requirement_Id] = 4644
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops, disseminates, and periodically reviews and updates:</p>
<ol>
  <li>A formal, documented, control system maintenance policy that addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance.</li>
  <li>Formal, documented procedures to facilitate the implementation of the control system maintenance policy and associated system maintenance controls.</li>
</ol>' WHERE [Requirement_Id] = 4659
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization reviews and follows security requirements for a control system before undertaking any unplanned maintenance activities of control system components (including field devices). Documentation includes the following:</p>
<ol>
  <li>The date and time of maintenance.</li>
  <li>The name of the individual(s) performing the maintenance.</li>
  <li>The name of the escort, if necessary.</li>
  <li>A description of the maintenance performed.</li>
  <li>A list of equipment removed or replaced (including identification numbers, if applicable).</li>
</ol>
<p>Requirement Enhancement - The organization documents the decision and justification should unplanned maintenance not be performed on a control system after the identification of a security vulnerability.</p>
' WHERE [Requirement_Id] = 4663
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Schedules, performs, documents, and reviews records of maintenance and repairs on system components in accordance with manufacturer or vendor specifications and/or organizational requirements.</li>
  <li>Explicitly approves the removal of the system or system components from organizational facilities for offsite maintenance or repairs.</li>
  <li>Sanitizes the equipment to remove all information from associated media prior to removal from organizational facilities for offsite maintenance or repairs.</li>
  <li>Checks all potentially impacted security controls to verify that the controls are still functioning properly following maintenance or repair actions.</li>
</ol>
<p>Requirement Enhancement 1 - The organization maintains maintenance records for the system that include (a) the date and time of maintenance; (b) name of the individual performing the maintenance; (c) name of escort, if necessary; (d) a description of the maintenance performed; and (e) a list of equipment removed or replaced (including identification numbers, if applicable).</p>
<p>Requirement Enhancement 2 - The organization employs automated mechanisms to schedule and document maintenance and repairs as required, producing up-to-date, accurate, complete, and available records of all maintenance and repair actions, needed, in process, and completed.</p>
' WHERE [Requirement_Id] = 4665
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization approves and monitors the use of system maintenance tools.</p>
<p>Requirement Enhancement 1 - The organization inspects all maintenance tools carried into a facility by maintenance personnel for obvious improper modifications.</p>
<p>Requirement Enhancement 2 - The organization checks all media containing diagnostic and test programs for malicious code before the media are used in the system.</p>
<p>Requirement Enhancement 3 - The organization prevents the unauthorized removal of maintenance equipment by one of the following:
  <ol type="a">
    <li>Verifying that no organizational information is contained on the equipment,</li>
    <li>Sanitizing or destroying the equipment,</li>
    <li>Retaining the equipment within the facility, or</li>
    <li>Obtaining an exemption from a designated organization official explicitly authorizing removal of the equipment from the facility.</li>
  </ol>
</p>
<p>Requirement Enhancement 4 - The organization employs automated mechanisms to restrict the use of maintenance tools to authorized personnel only.</p>
<p>Requirement Enhancement 5 - Maintenance tools are used with care on control system networks to ensure that control system operations will not be degraded by their use.</p>
' WHERE [Requirement_Id] = 4668
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Authorizes and monitors and controls remotely executed maintenance and diagnostic activities.</li>
  <li>Allows the use of remote maintenance and diagnostic tools only as consistent with organizational policy and documented in the security plan for the system.</li>
  <li>Maintains records for remote maintenance and diagnostic activities.</li>
  <li>Terminates all sessions and remote connections when remote maintenance is completed.</li>
  <li>Changes passwords following each remote maintenance session if password-based authentication is used to accomplish remote maintenance.</li>
</ol>
<p>Requirement Enhancement 1 - The organization audits remote maintenance and diagnostic sessions, and designated organizational personnel review the maintenance records of the remote sessions.</p>
<p>Requirement Enhancement 2 - The organization documents the installation and use of remote maintenance and diagnostic links.</p>
<p>Requirement Enhancement 3 - The organization:</p>
<ol type="a">
  <li>Requires that remote maintenance or diagnostic services be performed from a system that implements a level of security at least as high as that implemented on the system being serviced or</li>
  <li>Removes the component to be serviced from the system and prior to remote maintenance or diagnostic services, sanitizes the component (e.g., clearing of set points, embedded network addresses and embedded security validation information) before removal from organizational facilities. After the service is performed and the component is returned to the facility, the organization should check or reinstall the authorized firmware code as specified by the configuration management plan and reset all authorized embedded configuration settings. This should remove potentially malicious software that may have been added via "new" firmware. This should be done before reconnecting the component to the system.</li>
</ol>
<p>Requirement Enhancement 4 - The organization requires that remote maintenance sessions be protected by a strong authenticator tightly bound to the user.</p>
<p>Requirement Enhancement 5 - The organization requires that:</p>
<ol type="a">
  <li>Maintenance personnel notify the system administrator when remote maintenance is planned (i.e., date/time)</li>
  <li>A designated organizational official with specific security/system knowledge approves the remote maintenance.</li>
</ol>
<p>Requirement Enhancement 6 - The organization employs cryptographic mechanisms to protect the integrity and confidentiality of remote maintenance and diagnostic communications.</p>
<p>Requirement Enhancement 7 - The organization employs remote disconnect verification at the termination of remote maintenance and diagnostic sessions.</p>
' WHERE [Requirement_Id] = 4673
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops, disseminates, and periodically reviews and updates:</p>
<ol>
  <li>A formal, documented, security awareness and training policy that addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance.</li>
  <li>Formal, documented procedures to facilitate the implementation of the security awareness and training policy and associated security awareness and training controls.</li>
</ol>' WHERE [Requirement_Id] = 4678
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization provides basic security awareness training to all control system users (including managers, senior executives, and contractors) before authorizing access to the system, when required by system changes, and at least annually thereafter. The effectiveness of security awareness training, at the organization level, needs to be reviewed once a year at a minimum.</p>
<p>Requirement Enhancement 1 - All control system design and procedure changes need to be reviewed by the organization for inclusion in the organization security awareness training.</p>
<p>Requirement Enhancement 2 - The organization includes practical exercises in security awareness training that simulate actual cyberattacks.</p>
' WHERE [Requirement_Id] = 4679
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Defines and documents system security roles and responsibilities throughout the system development life cycle.</li>
  <li>Identifies individuals having system security roles and responsibilities.</li>
  <li>Provides security-related technical training:
    <ol>
      <li>before authorizing access to the system or performing assigned duties,</li>
      <li>when required by system changes, and</li>
      <li>on an organization-defined frequency, thereafter.</li>
    </ol>
  </li>
</ol>' WHERE [Requirement_Id] = 4681
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops, disseminates, and periodically reviews and updates:</p>
<ol>
  <li>A formal, documented, incident response policy that addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance.</li>
  <li>Formal, documented procedures to facilitate the implementation of the incident response policy and associated incident response controls.</li>
</ol>' WHERE [Requirement_Id] = 4685
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops and implements a continuity of operations plan dealing with the overall issue of maintaining or re-establishing production in case of an undesirable interruption for a control system. The plan addresses roles, responsibilities, assigned individuals with contact information, and activities associated with restoring system operations after a disruption or failure. Designated officials within the organization review and approve the continuity of operations plan.</p>
<p>Requirement Enhancement 1 - The continuity of operations plan delineates that at the time of the disruption to normal system operations, the organization executes its incident response policies and procedures to place the system in a safe configuration and initiates the necessary notifications to regulatory authorities.</p>
<p>Requirement Enhancement 2 - The organization initiates a root cause analysis for the event and submits any findings from the analysis to the organization''s corrective action program.</p>
<p>Requirement Enhancement 3 - The organization then resumes normal operation of the system in accordance with its policies and procedures.</p>' WHERE [Requirement_Id] = 4686
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Trains personnel in their incident response roles and responsibilities with respect to the system.</li>
  <li>Provides refresher training on an organization-defined frequency, at least annually.</li>
</ol>
<p>Requirement Enhancement 1 - The organization incorporates control system simulated events into continuity of operations training to facilitate effective response by personnel in crisis situations.</p>
<p>Requirement Enhancement 2 - The organization employs automated mechanisms to provide a thorough and realistic control system training environment.</p>' WHERE [Requirement_Id] = 4689
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Implements an incident handling capability for security incidents that includes preparation, detection and analysis, containment, eradication, and recovery.</li>
  <li>Coordinates incident handling activities with contingency planning activities.</li>
  <li>Incorporates lessons learned from ongoing incident handling activities into incident response procedures and implements the procedures accordingly.</li>
</ol>
<p>Requirement Enhancement - The organization employs automated mechanisms to administer and support the incident handling process.</p>' WHERE [Requirement_Id] = 4695
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization provides an incident response support resource that offers advice and assistance to users of the control system for the handling and reporting of security incidents.</p>
<p>Requirement Enhancements 1 - The organization employs automated mechanisms to increase the availability of incident response-related information and support.</p>
<p>Requirement Enhancements 2 - The organization:</p>
<ol type="a">
  <li>Establishes a direct, cooperative relationship between its incident response capability and external providers of information system protection capability.</li>
  <li>Identifies organizational incident response team members to the external providers.</li>
</ol>
' WHERE [Requirement_Id] = 4701
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Develops an incident response plan that
    <ol type="a">
      <li>Provides the organization with a roadmap for implementing its incident response capability</li>
      <li>Describes the structure and organization of the incident response capability</li>
      <li>Provides a high-level approach for how the incident response capability fits into the overall organization</li>
      <li>Meets the unique requirements of the organization with respect to mission, function, size, and structure</li>
      <li>Defines reportable incidents</li>
      <li>Provides metrics for measuring the incident response capability within the organization</li>
    </ol>
  </li>
  <li>Distributes copies of the incident response plan to identified active incident response personnel.</li>
  <li>Reviews the incident response plan on a periodic frequency for relevance, changes to configuration and processes, and the result of incident plan test exercises.</li>
  <li>Revises the incident response plan to address system/organizational/operational changes or problems encountered during plan implementation, execution, or testing.</li>
  <li>Communicates incident response plan changes to identified active incident response personnel.</li>
</ol>
<p>Requirement Enhancement 1 - The organization develops, tests, deploys, and fully documents an incident response investigation and analysis process.</p>
<p>Requirement Enhancement 2 - The program specifies roles and responsibilities with respect to local law enforcement and/or other critical stakeholders in an internal and shared incident response investigation and analysis program.</p>
' WHERE [Requirement_Id] = 4704
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Conducts backups of user-level information contained in the system on an organization-defined frequency.</li>
  <li>Conducts backups of system-level information (including system state information) contained in the system on an organization-defined frequency.</li>
  <li>Protects the confidentiality and integrity of backup information at the storage location.</li>
</ol>
<p>Requirement Enhancement 1 - The organization tests backup information periodically to verify media reliability and information integrity.</p>
<p>Requirement Enhancement 2 - The organization selectively uses backup information in the restoration of control system functions as part of contingency plan testing.</p>
<p>Requirement Enhancement 3 - The organization stores backup copies of the operating system and other critical control system software in a separate facility or in a fire-rated container that is not collocated with the operational software.</p>
' WHERE [Requirement_Id] = 4715
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization provides the capability to recover and reconstitute the system to a known secure state after a disruption, compromise, or failure.</p>
<p>Requirement Enhancement 1 - The organization implements transaction recovery for systems that are transaction-based (e.g., database management systems).</p>
<p>Requirement Enhancement 2 - The organization provides compensating security controls (including procedures or mechanisms) for the organization-defined circumstances that inhibit recovery to a known, secure state.</p>
<p>Requirement Enhancement 3 - The organization provides the capability to re-image system components in accordance with organization-defined restoration time periods from configuration-controlled and integrity-protected disk images representing a secure, operational state for the components.</p>
' WHERE [Requirement_Id] = 4718
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization sanitizes system digital and non-digital media, before disposal or release for reuse.</p>
<p>Requirement Enhancement 1 - The organization tracks, documents, and verifies media sanitization and disposal actions.</p>
<p>Requirement Enhancement 2 - The organization periodically tests sanitization equipment and procedures to verify correct performance.</p>
' WHERE [Requirement_Id] = 4723
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization ensures that only authorized users have access to information in printed form or on digital media, whether integral to or removed from the control system.</p>
<p>Requirement Enhancement - The organization employs automated mechanisms to ensure only authorized access to such storage areas and to audit access attempts and access granted.</p>
<p>Note: This control enhancement is primarily applicable to designated media storage areas within an organization where a significant volume of media is stored and is not intended to apply to every location where some media are stored.</p>
' WHERE [Requirement_Id] = 4724
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization sanitizes system digital and non-digital media, before disposal or release for reuse.</p>
<p>Requirement Enhancement 1 - The organization tracks, documents, and verifies media sanitization and disposal actions.</p>
<p>Requirement Enhancement 2 - The organization periodically tests sanitization equipment and procedures to verify correct performance.</p>
' WHERE [Requirement_Id] = 4733
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops, disseminates, and periodically reviews and updates:</p>
<ol>
  <li>Formal, documented, system and control integrity policy that addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance.</li>
  <li>Formal, documented procedures to facilitate the implementation of the system and information integrity policy and associated system and information integrity controls.</li>
</ol>
' WHERE [Requirement_Id] = 4735
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Identifies, reports, and corrects system flaws.</li>
  <li>Tests software updates related to flaw remediation for effectiveness and potential side effects on organizational systems before installation.</li>
  <li>Incorporates flaw remediation into the organizational configuration management process as an emergency change.</li>
</ol>
<p>Requirement Enhancement 1 - The organization centrally manages the flaw remediation process and installs updates automatically. Organizations consider the risk of employing automated flaw remediation processes on a control system.</p>
<p>Requirement Enhancement 2 - The organization employs automated mechanisms to determine periodically and on demand the state of system components with regard to flaw remediation.</p>
<p>Requirement Enhancement 3 - The organization measures the time between flaw identification and flaw remediation, comparing with organization-defined benchmarks.</p>
<p>Requirement Enhancement 4 - The organization employs automated patch management tools to facilitate flaw remediation to organization-defined system components.</p>
<p>Requirement Enhancement 5 - The use of automated flaw remediation processes must not degrade the operational performance of the control system.</p>
' WHERE [Requirement_Id] = 4736
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Employs malicious code protection mechanisms at system entry and exit points and at workstations, servers, or mobile computing devices on the network to detect and eradicate malicious code:
    <ol type="a">
      <li>transported by electronic mail, electronic mail attachments, web accesses, removable media, or other common means or</li>
      <li>inserted through the exploitation of system vulnerabilities.</li>
    </ol>
  </li>
  <li>Updates malicious code protection mechanisms (including signature definitions) whenever new releases are available in accordance with organizational configuration management policy and procedures.</li>
  <li>Configures malicious code protection mechanisms to:
    <ol type="a">
      <li>perform periodic scans of the system on an organization-defined frequency and real-time scans of files from external sources as the files are downloaded, opened, or executed and</li>
      <li>disinfect and quarantine infected files.</li>
    </ol>
  </li>
  <li>Considers using malicious code protection software products from multiple vendors as part of defense-in-depth.</li>
  <li>Addresses the receipt of false positives during malicious code detection and eradication and the resulting potential impact on the availability of the system.</li>
</ol>
<p>Requirement Enhancement 1 - The organization centrally manages malicious code protection mechanisms.</p>
<p>Requirement Enhancement 2 - The system automatically updates malicious code protection mechanisms (including signature definitions).</p>
<p>Requirement Enhancement 3 - The system prevents users from circumventing host-based malicious code protection capabilities.</p>
<p>Requirement Enhancement 4 - The system updates malicious code protection mechanisms only when directed by a privileged user.</p>
<p>Requirement Enhancement 5 - The organization does not allow users to introduce removable media into the system.</p>
<p>Requirement Enhancement 6 - The system implements malicious code protection mechanisms to identify data containing malicious code and responds accordingly (i.e., block, quarantine, send alert to administrator) when the system encounters data not explicitly allowed by the security policy.</p>
<p>Requirement Enhancement 7 - The use of mechanisms to centrally manage malicious code protection must not degrade the operational performance of the system.</p>
' WHERE [Requirement_Id] = 4740
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Monitors events on the system.</li>
  <li>Detects system attacks.</li>
  <li>Identifies unauthorized use of the system.</li>
  <li>Deploys monitoring devices (a) strategically within the system to collect organization-determined essential information and (b) at ad hoc locations within the system to track specific types of transactions of interest to the organization.</li>
  <li>Heightens the level of system monitoring activity whenever an indication of increased risk exists to organizational operations and assets, individuals, other organizations, or the nation based on law enforcement information, intelligence information, or other credible sources of information.</li>
  <li>Consults legal counsel with regard to system monitoring activities.</li>
</ol>
<p>Requirement Enhancement 1 - The organization interconnects and configures individual intrusion detection tools into a system-wide intrusion detection system using common protocols.</p>
<p>Requirement Enhancement 2 - In situations where the ICS cannot support the use of automated tools to support near real-time analysis of events, the organization employs non-automated mechanisms or procedures as compensating controls in accordance with the general tailoring guidance.</p>
<p>Requirement Enhancement 3 - The organization employs automated tools to support near real-time analysis of events.</p>
<p>Requirement Enhancement 4 - The organization employs automated tools to integrate intrusion detection tools into access control and flow control mechanisms for rapid response to attacks by enabling reconfiguration of these mechanisms in support of attack isolation and elimination.</p>
<p>Requirement Enhancement 5 - The control system monitors inbound and outbound communications for unusual or unauthorized activities or conditions. Unusual/unauthorized activities or conditions include the presence of malicious code, the unauthorized export of information, or signaling to an external control system.</p>
<p>Requirement Enhancement 6 - The control system provides a real-time alert when indications of compromise or potential compromise occur.</p>
<p>Requirement Enhancement 7 - The system prevents users from circumventing host-based intrusion detection and prevention capabilities.</p>
<p>Requirement Enhancement 8 - In situations where the ICS cannot prevent non-privileged users from circumventing intrusion detection and prevention capabilities, the organization employs appropriate compensating controls in accordance with the general tailoring guidance.</p>
<p>Requirement Enhancement 9 - The system notifies a defined list of incident response personnel of suspicious events and takes a defined list of least disruptive actions to terminate suspicious events.</p>
<p>Requirement Enhancement 10 - The organization protects information obtained from intrusion monitoring tools from unauthorized access, modification, and deletion.</p>
<p>Requirement Enhancement 11 - The organization tests/exercises intrusion monitoring tools on a defined time-period.</p>
<p>Requirement Enhancement 12 - The organization makes provisions so that encrypted traffic is visible to system monitoring tools.</p>
<p>Requirement Enhancement 13 - The system analyzes outbound communications traffic at the external boundary of the system and, as deemed necessary, at selected interior points within the system to discover anomalies.</p>
<p>Requirement Enhancement 14 - The use of monitoring tools and techniques must not adversely impact the operational performance of the control system.</p>
' WHERE [Requirement_Id] = 4743
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Receives system security alerts, advisories, and directives from designated external organizations on an ongoing basis.</li>
  <li>Generates internal security alerts, advisories, and directives as deemed necessary.</li>
  <li>Disseminates security alerts, advisories, and directives to an organization-defined list of personnel.</li>
  <li>Implements security directives in accordance with timeframes established by the directives, or notifies the issuing organization of the degree of noncompliance. Shutting down and restarting the ICS on the identification of an anomaly are not recommended because the event logs can be erased.</li>
</ol>
<p>Requirement Enhancement - The organization employs automated mechanisms to make security alert and advisory information available throughout the organization as needed.</p>
' WHERE [Requirement_Id] = 4746
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops, disseminates, and periodically reviews and updates:</p>
<ol>
  <li>A formal, documented, access control policy that addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance.</li>
  <li>Formal, documented procedures to facilitate the implementation of the access control policy and associated access controls.</li>
</ol>
<p>Requirement Enhancement 1 - Public access to ICS is not permitted.</p>
<p>Requirement Enhancement 2 - Business IT and general corporation access to the ICS is not permitted.</p>
' WHERE [Requirement_Id] = 4763
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops, disseminates, and periodically reviews and updates:</p>
<ol>
  <li>A formal, documented, identification and authentication policy that addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance.</li>
  <li>Formal, documented procedures to facilitate the implementation of the identification and authentication policy and associated identification and authentication controls.</li>
</ol>
' WHERE [Requirement_Id] = 4765
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization manages system accounts, including:</p>
<ol>
  <li>Identifying account types (i.e., individual, group, and system).</li>
  <li>Establishing conditions for group membership.</li>
  <li>Identifying authorized users of the system and specifying access rights and privileges.</li>
  <li>Requiring appropriate approvals for requests to establish accounts.</li>
  <li>Authorizing, establishing, activating, modifying, disabling, and removing accounts.</li>
  <li>Reviewing accounts on a defined frequency.</li>
  <li>Specifically authorizing and monitoring the use of guest/anonymous accounts.</li>
  <li>Notifying account managers when system users are terminated, transferred, or system usage or need-to-know/need-to-share changes.</li>
  <li>Granting access to the system based on a valid need-to-know or need-to-share that is determined by assigned official duties and satisfying all personnel security criteria and intended system usage.</li>
</ol>
<p>Requirement Enhancement 1 - The organization employs automated mechanisms to support the management of system accounts.</p>
<p>Requirement Enhancement 2 - The system automatically terminates temporary and emergency accounts after a defined time period for each type of account.</p>
<p>Requirement Enhancement 3 - The system automatically disables inactive accounts after a defined time period.</p>
<p>Requirement Enhancement 4 - The system automatically audits account creation, modification, disabling, and termination actions and notifies, as required, appropriate individuals.</p>
<p>Requirement Enhancement 5 - The organization reviews currently active system accounts on a defined frequency to verify that temporary accounts and accounts of terminated or transferred users have been deactivated in accordance with organizational policy.</p>
<p>Requirement Enhancement 6 - The organization prohibits the use of system account identifiers as the identifiers for user electronic mail accounts.</p>
' WHERE [Requirement_Id] = 4766
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization manages system identifiers for users and devices by:</p>
<ol>
  <li>Receiving authorization from a designated organizational official to assign a user or device identifier.</li>
  <li>Selecting an identifier that uniquely identifies an individual or device.</li>
  <li>Assigning the user identifier to the intended party or the device identifier to the intended device.</li>
  <li>Archiving previous user or device identifiers.</li>
</ol>
' WHERE [Requirement_Id] = 4768
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization manages system authenticators for users and devices by:</p>
<ol>
  <li>Verifying, as part of the initial authenticator distribution for a user authenticator, the identity of the individual receiving the authenticator.</li>
  <li>Establishing initial authenticator content for organization-defined authenticators.</li>
  <li>Ensuring that authenticators have sufficient strength of mechanism for their intended use.</li>
  <li>Establishing and implementing administrative procedures for initial authenticator distribution, for lost/compromised, or damaged authenticators, and for revoking authenticators.</li>
  <li>Changing default content of authenticators upon system installation.</li>
  <li>Establishing minimum and maximum lifetime restrictions and reuse conditions for authenticators (if appropriate).</li>
  <li>Changing or refreshing authenticators periodically, as appropriate for authenticator type.</li>
  <li>Protecting authenticator content from unauthorized disclosure and modification.</li>
  <li>Requiring users to take, and having devices implement, specific measures to safeguard authenticators.</li>
</ol>
<p>Requirement Enhancement 1 - The system, for PKI-based authentication:</p>
<ul>
  <li>Validates certificates by constructing a certification path with status information to an accepted trust anchor.</li>
  <li>Enforces authorized access to the corresponding private key.</li>
  <li>Maps the authenticated identity to the user account.</li>
</ul>
<p>Note: Status information for certification paths includes certificate revocation lists or online certificate status protocol responses.</p>
<p>Requirement Enhancement 2 - The organization requires that the registration process to receive a user authenticator be carried out in person before a designated registration authority with authorization by a designated organizational official (e.g., a supervisor).</p>
<p>Requirement Enhancement 3 - The organization employs automated tools to determine if authenticators are sufficiently strong to resist attacks intended to discover or otherwise compromise the authenticators.</p>
<p>Requirement Enhancement 4 - The organization requires unique authenticators be provided by vendors and manufacturers of system components.</p>
' WHERE [Requirement_Id] = 4769
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Reviews and analyzes system audit records on an organization-defined frequency for indications of inappropriate or unusual activity, and reports findings to designated organizational officials.</li>
  <li>Adjusts the level of audit review, analysis, and reporting within the system when a change in risk exists to organizational operations, organizational assets, individuals, other organizations, or the nation based on law enforcement information, intelligence information, or other credible sources of information.</li>
</ol>
<p>Requirement Enhancement 1 - The system employs automated mechanisms to integrate audit review, analysis, and reporting into organizational processes for investigation and response to suspicious activities.</p>
<p>Requirement Enhancement 2 - The organization analyzes and correlates audit records across different repositories to gain organization-wide situational awareness.</p>
<p>Requirement Enhancement 3 - The system employs automated mechanisms to centralize audit review and analysis of audit records from multiple components within the system.</p>
<p>Note: An example of an automated mechanism for centralized review and analysis is a Security Information Management product.</p>
<p>Requirement Enhancement 4 - The organization integrates analysis of audit records with analysis of performance and network monitoring information to enhance further the ability to identify inappropriate or unusual activity.</p>
' WHERE [Requirement_Id] = 4772
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The control system enforces assigned authorizations for controlling logical access to the system in accordance with applicable policy.</p>
<p>Requirement Enhancement 1 - The system enforces dual authorization, based on organizational policies and procedures for organization-defined privileged commands. Note: The organization does not employ dual authorization mechanisms when an immediate response is necessary to ensure public and environmental safety.</p>
<p>Requirement Enhancement 2 - The system enforces one or more organization-defined nondiscretionary access control policies over organization-defined set of users and resources where the policy rule set for each policy specifies:</p>
<ol type="a">
  <li>Access control information (i.e., attributes) employed by the policy rule set (e.g., position, nationality, age, project, time of day).</li>
  <li>Required relationships among the access control information to permit access. Note: Nondiscretionary access control policies that may be implemented by organizations include, for example, Attribute-Based Access Control, and Originator Controlled Access Control.</li>
</ol>
<p>Requirement Enhancement 3 - The system prevents access to organization-defined security-relevant information except during secure, non-operable system states. Note: Security relevant information is any information within the system that can potentially impact the operation of security functions in a manner that could result in failure to enforce the system security policy or maintain isolation of code and data. Secure, non-operable system states are states in which the system is not performing mission/business-related processing (e.g., the system is offline for maintenance, troubleshooting, bootup, shutdown).</p>
' WHERE [Requirement_Id] = 4774
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The system uniquely identifies and authenticates organizational users (or processes acting on behalf of organizational users).</p>
<p>Requirement Enhancement 1 - The system employs multifactor authentication for remote access and for access to privileged accounts.</p>
<p>Requirement Enhancement 2 - The system employs multifactor authentication for network access and for access to privileged accounts.</p>
<p>Requirement Enhancement 3 - The system employs multifactor authentication for local and network access.</p>
' WHERE [Requirement_Id] = 4780
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization identifies and documents specific user actions, if any, that can be performed on the system without identification or authentication.</p>
<p>Requirement Enhancement - The organization permits actions to be performed without identification and authentication only to the extent necessary to accomplish mission objectives.</p>
' WHERE [Requirement_Id] = 4784
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The control system employs authentication methods that meet the requirements of applicable laws, directives, policies, regulations, standards, and guidance for authentication to a cryptographic module.</p>
<p>Requirement Enhancement - Failure of cryptographic module authentication must not create a denial of service or adversely impact the operational performance of the control system.</p>
' WHERE [Requirement_Id] = 4789
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops and enforces policies and procedures for control system users concerning the generation and use of passwords. These policies stipulate rules of complexity, based on the criticality level of the systems to be accessed.</p>
<p>Requirement Enhancement - ICS deployment will require two-factor authentication or comparable compensating measures to ensure only approved authorized access is allowed.</p>
' WHERE [Requirement_Id] = 4793
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'The system:
<ol>
  <li>Displays an approved system use notification message or banner before granting access to the system that provides privacy and security notices consistent with applicable laws, directives, policies, regulations, standards, and guidance and states that
      (a) users are accessing a private or government system;
      (b) system usage may be monitored, recorded, and subject to audit;
      (c) unauthorized use of the system is prohibited and subject to criminal and civil penalties; and
      (d) use of the system indicates consent to monitoring and recording
  </li>
  <li>Retains the notification message or banner on the screen until users take explicit actions to log on to or further access, the system</li>
  <li>For publicly accessible systems,
      (a) displays the system use information, when appropriate, before granting further access;
      (b) ensures that any references to monitoring, recording, or auditing are consistent with privacy accommodations for such systems that generally prohibit those activities; and
      (c) includes in the notice given to public users of the system, a description of the authorized uses of the system.
  </li>
</ol>
' WHERE [Requirement_Id] = 4795
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The system:</p>
<ol>
  <li>Enforces a limit of an organization-defined number of consecutive invalid access attempts by a user during an organization-defined time period.</li>
  <li>Automatically locks the account/node for an organization-defined time period and delays the next login prompt according to an organization-defined delay algorithm when the maximum number of unsuccessful attempts is exceeded.</li>
</ol>
<p>Requirement Enhancement - The control system automatically locks the account/node until released by an administrator when the maximum number of unsuccessful attempts is exceeded.</p>
' WHERE [Requirement_Id] = 4799
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Documents allowed methods of remote access to the system.</li>
  <li>Establishes usage restrictions and implementation guidance for each allowed remote access method.</li>
  <li>Authorizes remote access to the system prior to connection.</li>
  <li>Enforces requirements for remote connections to the system.</li>
</ol>
' WHERE [Requirement_Id] = 4805
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization authorizes, monitors, and manages all methods of remote access to the control system.</p>
<p>Requirement Enhancement 1 - The organization employs automated mechanisms to facilitate the monitoring and control of remote access methods.</p>
<p>Requirement Enhancement 2 - The organization uses cryptography to protect the confidentiality and integrity of remote access sessions. Note: The encryption strength of mechanism is selected based on the FIPS 199 impact level of the information.</p>
<p>Requirement Enhancement 3 - The system routes all remote accesses through a limited number of managed access control points.</p>
<p>Requirement Enhancement 4 - The organization authorizes remote access for privileged commands and security-relevant information only for compelling operational needs and documents the rationale for such access in the security plan for the system.</p>
<p>Requirement Enhancement 5 - The system protects wireless access to the system using authentication and encryption. Note: Authentication applies to user, device, or both as necessary.</p>
<p>Requirement Enhancement 6 - The organization monitors for unauthorized remote connections to the system, including scanning for unauthorized wireless access points on an organization-defined frequency and takes appropriate action if an unauthorized connection is discovered. Note: Organizations proactively search for unauthorized remote connections including the conduct of thorough scans for unauthorized wireless access points. The scan is not necessarily limited to those areas within the facility containing the systems. Yet, the scan is conducted outside those areas only as needed to verify that unauthorized wireless access points are not connected to the system.</p>
<p>Requirement Enhancement 7 - The organization disables, when not intended for use, wireless networking capabilities internally embedded within system components prior to issue.</p>
<p>Requirement Enhancement 8 - The organization does not allow users to independently configure wireless networking capabilities.</p>
<p>Requirement Enhancement 9 - The organization ensures that users protect information about remote access mechanisms from unauthorized use and disclosure.</p>
<p>Requirement Enhancement 10 - The organization ensures that remote sessions for accessing an organization-defined list of security functions and security-relevant information employ additional security measures (organization defined security measures) and are audited.</p>
<p>Requirement Enhancement 11 - The organization disables peer-to-peer wireless networking capability within the system except for explicitly identified components in support of specific operational requirements.</p>
<p>Requirement Enhancement 12 - The organization disables Bluetooth wireless networking capability within the system except for explicitly identified components in support of specific operational requirements.</p>
' WHERE [Requirement_Id] = 4806
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Establishes usage restrictions and implementation guidance for organization-controlled mobile devices</li>
  <li>Authorizes connection of mobile devices to organizational systems</li>
  <li>Monitors for unauthorized connections of mobile devices to organizational systems</li>
  <li>Enforces requirements for the connection of mobile devices to organizational systems</li>
  <li>Disables system functionality that provides the capability for automatic execution of code on removable media without user direction</li>
  <li>Issues specially configured mobile devices to individuals traveling to locations that the organization deems to be of significant risk in accordance with organizational policies and procedures</li>
  <li>Applies specified measures to mobile devices returning from locations that the organization deems to be of significant risk in accordance with organizational policies and procedures.</li>
</ol>
' WHERE [Requirement_Id] = 4809
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Establishes use restrictions and implementation guidance for wireless technologies.</li>
  <li>Authorizes, monitors, and manages wireless access to the control system.</li>
</ol>
<p>Requirement Enhancement 1 - The organization uses authentication and encryption to protect wireless access to the control system. Any latency induced from the use of encryption must not degrade the operational performance of the control system.</p>
<p>Requirement Enhancement 2 - The organization scans for unauthorized wireless access points at a specified frequency and takes appropriate action if such access points are discovered. Organizations conduct a thorough scan for unauthorized wireless access points in facilities containing high-impact control systems. The scan is not limited to only those areas within the facility containing the high-impact control systems.</p>
' WHERE [Requirement_Id] = 4811
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization restricts the use of personally owned information copied to the control system or control system user workstation that is used for official organization business. This includes the processing, storage, or transmission of organization business and critical control system information. The terms and conditions need to address, at a minimum:</p>
<ol>
  <li>The types of applications that can be accessed from personally owned IT, either remotely or from within the organization control system</li>
  <li>The maximum security category of information that can be processed, stored, and transmitted</li>
  <li>How other users of the personally owned control system will be prevented from accessing organization information</li>
  <li>The use of VPN and firewall technologies</li>
  <li>The use of and protection against the vulnerabilities of wireless technologies</li>
  <li>The maintenance of adequate physical security mechanisms</li>
  <li>The use of virus and spyware protection software</li>
  <li>How often the security capabilities of installed software are to be updated (e.g., operating system and other software security patches, virus definitions, firewall version updates, malware definitions).</li>
</ol>
' WHERE [Requirement_Id] = 4813
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization establishes terms and conditions for authorized individuals to:</p>
<ol>
  <li>Access the system from an external system.</li>
  <li>Process, store, and transmit organization-controlled information using an external system.</li>
</ol>
<p>Requirement Enhancement 1 - The organization prohibits authorized individuals from using an external system to access the system or to process, store, or transmit organization-controlled information except in situations where the organization (a) can verify the implementation of required security controls on the external system as specified in the organization''s security policy and security plan or (b) has approved system connection or processing agreements with the organizational entity hosting the external system.</p>
<p>Requirement Enhancement 2 - The organization imposes restrictions on authorized individuals with regard to the use of organization-controlled removable media on external systems.</p>
' WHERE [Requirement_Id] = 4815
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Designates individuals authorized to post information onto an organizational information system that is publicly accessible.</li>
  <li>Trains authorized individuals to ensure that publicly accessible information does not contain nonpublic information.</li>
  <li>Reviews the proposed content of publicly accessible information for nonpublic information prior to posting onto the organizational information system.</li>
  <li>Reviews the content on the publicly accessible organizational information system for nonpublic information on a routine interval.</li>
  <li>Removes nonpublic information from publicly accessible information systems if discovered.</li>
</ol>
' WHERE [Requirement_Id] = 4819
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops, disseminates, and periodically reviews and updates:</p>
<ol>
  <li>A formal, documented, audit and accountability policy that addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance.</li>
  <li>Formal, documented procedures to facilitate the implementation of the audit and accountability policy and associated audit and accountability controls.</li>
</ol>
' WHERE [Requirement_Id] = 4820
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Determines, based on a risk assessment in conjunction with mission/business needs, which system-related events require auditing (e.g., an organization-defined list of auditable events and frequency of &lsqb;or situation requiring&rsqb; auditing for each identified auditable event).</li>
  <li>Coordinates the security audit function with other organizational entities requiring audit-related information to enhance mutual support and to help guide the selection of auditable events.</li>
  <li>Ensures that auditable events are adequate to support after-the-fact investigations of security incidents.</li>
  <li>Adjusts, as necessary, the events to be audited within the system based on current threat information and ongoing assessments of risk.</li>
</ol>
<p>Requirement Enhancement 1 - The organization reviews and updates the list of organization-defined auditable events on an organization-defined frequency.</p>
<p>Requirement Enhancement 2 - The organization includes execution of privileged functions in the list of events to be audited by the system.</p>
' WHERE [Requirement_Id] = 4821
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The system produces audit records that contain sufficient information to establish what events occurred, when the events occurred, where the events occurred, the sources of the events, and the outcomes of the events.</p>
<p>Requirement Enhancement 1 - The system provides the capability to include additional, more detailed information in the audit records for audit events identified by type, location, or subject.</p>
<p>Requirement Enhancement 2 - The system provides the capability to centrally manage the content of audit records generated by individual components throughout the system.</p>
' WHERE [Requirement_Id] = 4823
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The system:</p>
<ol>
  <li>Alerts designated organizational officials in the event of an audit processing failure.</li>
  <li>Takes the following additional actions: an organization-defined set of actions to be taken (e.g., shutdown system, overwrite oldest audit records, and stop generating audit records).</li>
</ol>
<p>Requirement Enhancement 1 - The system provides a warning when allocated audit record storage volume reaches an organization-defined percentage of maximum audit record storage capacity.</p>
<p>Requirement Enhancement 2 - The system provides a real-time alert when the following audit failure events occur: an organization-defined audit failure event requiring real-time alerts.</p>
<p>Requirement Enhancement 3 - The system enforces configurable traffic volume thresholds representing auditing capacity for network traffic and either rejects or delays network traffic above those thresholds.</p>
' WHERE [Requirement_Id] = 4827
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Reviews and analyzes system audit records on an organization-defined frequency for indications of inappropriate or unusual activity and reports findings to designated organizational officials.</li>
  <li>Adjusts the level of audit review, analysis, and reporting within the system when a change in risk exists to organizational operations, organizational assets, individuals, other organizations, or the nation based on law enforcement information, intelligence information, or other credible sources of information.</li>
</ol>
<p>Requirement Enhancement 1 - The system employs automated mechanisms to integrate audit review, analysis, and reporting into organizational processes for investigation and response to suspicious activities.</p>
<p>Requirement Enhancement 2 - The organization analyzes and correlates audit records across different repositories to gain organization-wide situational awareness.</p>
<p>Requirement Enhancement 3 - The system employs automated mechanisms to centralize audit review and analysis of audit records from multiple components within the system.</p>
<p>Note: An example of an automated mechanism for centralized review and analysis is a Security Information Management product.</p>
<p>Requirement Enhancement 4 - The organization integrates analysis of audit records with analysis of performance and network monitoring information to enhance further the ability to identify inappropriate or unusual activity.</p>' WHERE [Requirement_Id] = 4830
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The system uses internal system clocks to generate time stamps for audit records.</p>
<p>Requirement Enhancement - The system synchronizes internal system clocks on an organization-defined frequency.</p>
' WHERE [Requirement_Id] = 4835
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The control system protects audit information and audit tools from unauthorized access, modification, and deletion.</p>
<p>Requirement Enhancement - The system produces audit records on hardware-enforced, write-once media.</p>
' WHERE [Requirement_Id] = 4837
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization conducts audits at planned intervals to determine whether the security objectives, measures, processes, and procedures:</p>
<ol>
  <li>Conform to the requirements and relevant legislation or regulations.</li>
  <li>Conform to the identified information security requirements.</li>
  <li>Are effectively implemented and maintained.</li>
  <li>Perform as expected.</li>
  <li>Identify inappropriate activities.</li>
</ol>' WHERE [Requirement_Id] = 4840
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization''s audit program specifies auditor qualifications in accordance with the organization''s documented training program.</p>
<p>Requirement Enhancement - The organization assigns auditor and system administration functions to separate personnel.</p>
' WHERE [Requirement_Id] = 4841
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization under the audit program specifies strict rules and careful use of audit tools when auditing control system functions.</p>
<p>Requirement Enhancement - If automated cybersecurity scanning tools are used on business networks, extra care needs to be taken to ensure that they do not scan the control system network by mistake. Many installed devices do not have much processing power or sophisticated error-handling routines, and scans can overload the device and effectively create a denial-of-service interruption that could lead to equipment damage, production loss, or health, safety, and environmental incidents.</p>
' WHERE [Requirement_Id] = 4843
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The system:</p>
<ol>
  <li>Provides audit record generation capability for the auditable events.</li>
  <li>Provides audit record generation capability at the organization-defined system components.</li>
  <li>Allows authorized users to select which auditable events are to be audited by specific components of the system.</li>
  <li>Generates audit records for the selected list of auditable events.</li>
</ol>
<p>Requirement Enhancement - The system provides the capability to compile audit records from multiple components within the system into a system-wide (logical or physical) audit trail that is time-correlated to within an organization-defined level of tolerance for relationship between time stamps of individual records in the audit trail.</p>
<p>Note: This control does not require that audit records from every component that provides auditing capability within the system be included in the system-wide audit trail. The audit trail is time correlated if the time stamp in the individual audit records can be reliably related to the time stamp in other audit records to achieve a time ordering of the records within the organization-defined tolerance.</p>
<p>In situations where the ICS cannot support the use of automated mechanisms to generate audit records, the organization employs non-automated mechanisms or procedures as compensating controls.</p>
' WHERE [Requirement_Id] = 4846
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>Where legally required, the system provides the capability to:</p>
<ol>
  <li>Capture and record and log all content related to a user session</li>
  <li>Remotely view and hear all content related to an established user session in real time.</li>
</ol>
' WHERE [Requirement_Id] = 4849
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops, disseminates, and periodically reviews and updates:</p>
<ol>
  <li>A formal, documented, monitoring and reviewing control system security management policy that addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance.</li>
  <li>Formal, documented procedures to facilitate the implementation of the monitoring and reviewing control system security management policy and associated audit and accountability controls.</li>
</ol>
' WHERE [Requirement_Id] = 4850
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops, disseminates, and periodically reviews and updates:</p>
<ol>
  <li>A formal, documented risk assessment policy that addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance.</li>
  <li>Formal, documented procedures to facilitate the implementation of the risk assessment policy and associated risk assessment controls.</li>
</ol>
' WHERE [Requirement_Id] = 4857
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops, disseminates, and periodically reviews and updates:</p>
<ol>
  <li>Formal, documented, security assessment and certification and accreditation policies that address purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance.</li>
  <li>Formal, documented procedures to facilitate the implementation of the security assessment and certification and accreditation policies and associated assessment, certification, and accreditation controls.</li>
</ol>
' WHERE [Requirement_Id] = 4859
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Assesses the security controls in the system on an organization-defined frequency, at least annually, to determine the extent the controls are implemented correctly, operating as intended, and producing the desired outcome with respect to meeting the security requirements for the system.</li>
  <li>Produces a security assessment report that documents the results of the assessment.</li>
</ol>
<p>Requirement Enhancement 1 - The organization employs an independent assessor or assessment team to conduct an assessment of the security controls in the system.</p>
<p>Requirement Enhancement 2 - The organization includes as part of security control assessments, periodic, unannounced, in-depth monitoring, penetration testing, and red team exercises.</p>
' WHERE [Requirement_Id] = 4860
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Authorizes all connections from the system to other systems outside the authorization boundary through the use of system connection agreements.</li>
  <li>Documents the system connections and associated security requirements for each connection.</li>
  <li>Monitors the system connections on an ongoing basis verifying enforcement of documented security requirements.</li>
</ol>
' WHERE [Requirement_Id] = 4863
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Categorizes information and systems in accordance with applicable laws, management orders, directives, policies, regulations, standards, and guidance.</li>
  <li>Documents the security categorization results (including supporting rationale) in the system security plan for the information system.</li>
  <li>Ensures the security categorization decision is reviewed and approved by the authorizing official or authorizing official designated representative.</li>
</ol>
' WHERE [Requirement_Id] = 4867
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization develops, disseminates, and reviews/updates:</p>
<ol>
  <li>A formal documented risk assessment policy that addresses purpose, scope, roles, responsibilities, management commitment, coordination among organizational entities, and compliance</li>
  <li>Formal documented procedures to facilitate the implementation of the risk assessment policy and associated risk assessment controls.</li>
</ol>
' WHERE [Requirement_Id] = 4868
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Scans for vulnerabilities in the system on an organization-defined frequency and randomly in accordance with organization-defined process and when new vulnerabilities potentially affecting the system are identified and reported.</li>
  <li>Employs vulnerability scanning tools and techniques that promote interoperability among tools and automate parts of the vulnerability management process by using standards for:
    <ol type="a">
      <li>Enumerating platforms, software flaws, and improper configurations;</li>
      <li>Formatting and making transparent checklists and test procedures; and</li>
      <li>Measuring vulnerability impact.</li>
    </ol>
  </li>
  <li>Analyzes vulnerability scan reports and remediates legitimate vulnerabilities within a defined timeframe based on an assessment of risk.</li>
  <li>Shares information obtained from the vulnerability scanning process with designated personnel throughout the organization to help eliminate similar vulnerabilities in other systems.</li>
</ol>
<p>Requirement Enhancement 1 - The organization employs vulnerability scanning tools that include the capability to readily update the list of system vulnerabilities scanned.</p>
<p>Requirement Enhancement 2 - The organization updates the list of system vulnerabilities scanned on an organization-defined frequency or when new vulnerabilities are identified and reported.</p>
<p>Requirement Enhancement 3 - The organization employs vulnerability scanning procedures that can demonstrate the breadth and depth of coverage (i.e., system components scanned and vulnerabilities checked).</p>
<p>Requirement Enhancement 4 - The organization attempts to discern what information about the system is discoverable by adversaries.</p>
<p>Requirement Enhancement 5 - The organization performs security testing to determine the level of difficulty in circumventing the security controls of the system.</p>
<p>Requirement Enhancement 6 - The organization includes privileged access authorization to organization-defined system components for selected vulnerability scanning activities to facilitate more thorough scanning.</p>
<p>Requirement Enhancement 7 - The organization employs automated mechanisms to compare the results of vulnerability scans over time to determine trends in system vulnerabilities.</p>
<p>Requirement Enhancement 8 - The organization employs automated mechanisms on an organization-defined frequency to detect the presence of unauthorized software on organizational systems and notify designated organizational officials.</p>
' WHERE [Requirement_Id] = 4870
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Develops and disseminates an organization-wide security program plan that:
    <ol type="a">
      <li>Provides an overview of the requirements for the security program and a description of the security program management controls and common controls in place or planned for meeting those requirements.</li>
      <li>Provides sufficient information about the program management controls and common controls (including specification of parameters for any assignment and selection operations either explicitly or by reference) to enable an implementation that is unambiguously compliant with the intent of the plan and a determination of the risk to be incurred if the plan is implemented as intended.</li>
      <li>Includes roles, responsibilities, management commitment, coordination among organizational entities, and compliance.</li>
      <li>Is approved by a senior official with responsibility and accountability for the risk being incurred to organizational operations (including mission, functions, image, and reputation), organizational assets, individuals, other organizations, and the nation.</li>
    </ol>
  </li>
  <li>Reviews the organization-wide security program plan on an organization-defined frequency, at least annually.</li>
  <li>Revises the plan to address organizational changes and problems identified during plan implementation or security control assessments.</li>
</ol>
' WHERE [Requirement_Id] = 4875
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Ensures that all capital planning and investment requests include the resources needed to implement the security program and documents all exceptions to this requirement.</li>
  <li>Employs a business case to record the resources required.</li>
  <li>Ensures that security resources are available for expenditure as planned and approved.</li>
</ol>
' WHERE [Requirement_Id] = 4877
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Implements a process for ensuring that plans of action and milestones for the security program and the associated organizational systems are maintained.</li>
  <li>Documents the remedial security actions (from identification of needed action through assessment of implementation) to mitigate risk to organizational operations and assets, individuals, other organizations, and the nation.</li>
</ol>
' WHERE [Requirement_Id] = 4878
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Develops a comprehensive strategy to manage risk to organizational operations and assets, individuals, other organizations, and the nation associated with the operation and use of systems.</li>
  <li>Implements that strategy consistently across the organization.</li>
</ol>' WHERE [Requirement_Id] = 4883
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Manages (i.e., documents, tracks, and reports) the security state of organizational systems through security authorization processes.</li>
  <li>Fully integrates the security authorization processes into an organization-wide risk management strategy.</li>
</ol>' WHERE [Requirement_Id] = 4884
UPDATE [dbo].[NEW_REQUIREMENT] SET [Requirement_Text]=N'<p>The organization:</p>
<ol>
  <li>Defines mission/business processes with consideration for security and the resulting risk to organizational operations, organizational assets, individuals, other organizations, and the nation.</li>
  <li>Determines protection needs arising from the defined mission/business processes and revises the processes as necessary, until an achievable set of protection needs is obtained.</li>
</ol>' WHERE [Requirement_Id] = 4885
PRINT(N'Operation applied to 112 rows out of 112')

PRINT(N'Update rows in [dbo].[MATURITY_REFERENCES]')
UPDATE [dbo].[MATURITY_REFERENCES] SET [Sequence]=10 WHERE [Mat_Question_Id] = 7583 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 79' AND [Source] = 1
UPDATE [dbo].[MATURITY_REFERENCES] SET [Sequence]=10 WHERE [Mat_Question_Id] = 7585 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 79' AND [Source] = 1
UPDATE [dbo].[MATURITY_REFERENCES] SET [Sequence]=10 WHERE [Mat_Question_Id] = 7587 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 79' AND [Source] = 1
UPDATE [dbo].[MATURITY_REFERENCES] SET [Sequence]=10 WHERE [Mat_Question_Id] = 7640 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 79' AND [Source] = 1
UPDATE [dbo].[MATURITY_REFERENCES] SET [Sequence]=10 WHERE [Mat_Question_Id] = 7642 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 79' AND [Source] = 1
UPDATE [dbo].[MATURITY_REFERENCES] SET [Sequence]=10 WHERE [Mat_Question_Id] = 7643 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 79' AND [Source] = 1
UPDATE [dbo].[MATURITY_REFERENCES] SET [Sequence]=10 WHERE [Mat_Question_Id] = 7644 AND [Gen_File_Id] = 7071 AND [Section_Ref] = N'Baseline 79' AND [Source] = 1
PRINT(N'Operation applied to 7 rows out of 7')

PRINT(N'Update rows in [dbo].[MATURITY_EXTRA]')
UPDATE [dbo].[MATURITY_EXTRA] SET [SPRSValue]=5 WHERE [Maturity_Question_Id] = 5328
UPDATE [dbo].[MATURITY_EXTRA] SET [SPRSValue]=5 WHERE [Maturity_Question_Id] = 5329
UPDATE [dbo].[MATURITY_EXTRA] SET [SPRSValue]=0 WHERE [Maturity_Question_Id] = 5371
PRINT(N'Operation applied to 3 rows out of 3')

PRINT(N'Update rows in [dbo].[ISE_ACTIONS]')
UPDATE [dbo].[ISE_ACTIONS] SET [Regulatory_Citation]=N'12 C.F.R. § 704.16, 12 C.F.R. § 748.0 (b)(2), 12 C.F.R. § 748.0 (b)(3), 12 C.F.R. § 748.0 (b)(5), 12 C.F.R. § 748.1 (c)' WHERE [Action_Item_Id] = 314 AND [Mat_Question_Id] = 7603
UPDATE [dbo].[ISE_ACTIONS] SET [Regulatory_Citation]=N'12 C.F.R. § 704.16, 12 C.F.R. § 748.0 (b)(2), 12 C.F.R. § 748.0 (b)(3), 12 C.F.R. § 748.0 (b)(5), 12 C.F.R. § 748.1 (c)' WHERE [Action_Item_Id] = 315 AND [Mat_Question_Id] = 7604
UPDATE [dbo].[ISE_ACTIONS] SET [Regulatory_Citation]=N'12 C.F.R. § 704.16, 12 C.F.R. § 748.0 (b)(2), 12 C.F.R. § 748.0 (b)(3), 12 C.F.R. § 748.0 (b)(5), 12 C.F.R. § 748.1 (c)' WHERE [Action_Item_Id] = 316 AND [Mat_Question_Id] = 7605
UPDATE [dbo].[ISE_ACTIONS] SET [Regulatory_Citation]=N'12 C.F.R. § 704.16, 12 C.F.R. § 748.0 (b)(2), 12 C.F.R. § 748.0 (b)(3), 12 C.F.R. § 748.0 (b)(5), 12 C.F.R. § 748.1 (c)' WHERE [Action_Item_Id] = 317 AND [Mat_Question_Id] = 7606
UPDATE [dbo].[ISE_ACTIONS] SET [Regulatory_Citation]=N'12 C.F.R. § 704.16, 12 C.F.R. § 748.0 (b)(2), 12 C.F.R. § 748.0 (b)(3), 12 C.F.R. § 748.0 (b)(5), 12 C.F.R. § 748.1 (c)' WHERE [Action_Item_Id] = 370 AND [Mat_Question_Id] = 7670
UPDATE [dbo].[ISE_ACTIONS] SET [Regulatory_Citation]=N'12 C.F.R. § 704.16, 12 C.F.R. § 748.0 (b)(2), 12 C.F.R. § 748.0 (b)(3), 12 C.F.R. § 748.0 (b)(5), 12 C.F.R. § 748.1 (c)' WHERE [Action_Item_Id] = 371 AND [Mat_Question_Id] = 7671
UPDATE [dbo].[ISE_ACTIONS] SET [Regulatory_Citation]=N'12 C.F.R. § 704.16, 12 C.F.R. § 748.0 (b)(2), 12 C.F.R. § 748.0 (b)(3), 12 C.F.R. § 748.0 (b)(5), 12 C.F.R. § 748.1 (c)' WHERE [Action_Item_Id] = 372 AND [Mat_Question_Id] = 7672
UPDATE [dbo].[ISE_ACTIONS] SET [Regulatory_Citation]=N'12 C.F.R. § 704.16, 12 C.F.R. § 748.0 (b)(2), 12 C.F.R. § 748.0 (b)(3), 12 C.F.R. § 748.0 (b)(5), 12 C.F.R. § 748.1 (c)' WHERE [Action_Item_Id] = 373 AND [Mat_Question_Id] = 7673
UPDATE [dbo].[ISE_ACTIONS] SET [Regulatory_Citation]=N'12 C.F.R. § 704.16, 12 C.F.R. § 748.0 (b)(2), 12 C.F.R. § 748.0 (b)(3), 12 C.F.R. § 748.0 (b)(5), 12 C.F.R. § 748.1 (c)' WHERE [Action_Item_Id] = 532 AND [Mat_Question_Id] = 9921
UPDATE [dbo].[ISE_ACTIONS] SET [Regulatory_Citation]=N'12 C.F.R. § 704.16, 12 C.F.R. § 748.0 (b)(2), 12 C.F.R. § 748.0 (b)(3), 12 C.F.R. § 748.0 (b)(5), 12 C.F.R. § 748.1 (c)' WHERE [Action_Item_Id] = 537 AND [Mat_Question_Id] = 9925
PRINT(N'Operation applied to 10 rows out of 10')

PRINT(N'Update rows in [dbo].[IRP]')
UPDATE [dbo].[IRP] SET [Risk_4_Description]=N'> 6 IT Examiner Findings' WHERE [IRP_ID] = 47
UPDATE [dbo].[IRP] SET [Risk_4_Description]=N'Core conversion plan approved; The conversion is in process' WHERE [IRP_ID] = 48
UPDATE [dbo].[IRP] SET [Description]=N'Has the credit union conducted a cybersecurity assessment within the last 12 months (e.g. NCUA ACET Maturity Assessment, CISA Cyber Resilience Review, etc.)' WHERE [IRP_ID] = 52
PRINT(N'Operation applied to 3 rows out of 3')

PRINT(N'Update row in [dbo].[GLOBAL_PROPERTIES]')
UPDATE [dbo].[GLOBAL_PROPERTIES] SET [Property_Value]=N'True' WHERE [Property] = N'AgreedToLocalDbNotification'

PRINT(N'Update rows in [dbo].[GALLERY_ITEM]')
UPDATE [dbo].[GALLERY_ITEM] SET [Is_Visible]=1 WHERE [Gallery_Item_Guid] = 'b91a3f24-2f1b-4e2d-9c7f-168f2b5c8e4d'
UPDATE [dbo].[GALLERY_ITEM] SET [Is_Visible]=0 WHERE [Gallery_Item_Guid] = '588b16e5-ae9a-435e-a6e3-441a7578d64a'
PRINT(N'Operation applied to 2 rows out of 2')

PRINT(N'Add row to [dbo].[GLOBAL_PROPERTIES]')
INSERT INTO [dbo].[GLOBAL_PROPERTIES] ([Property], [Property_Value]) VALUES (N'IsCsetOnlineBeta', N'False')

PRINT(N'Add rows to [dbo].[MATURITY_REFERENCES]')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Source], [Page_Number], [Destination_String], [Sequence]) VALUES (7586, 7070, N'III, B, 3', 1, NULL, N'', 2)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Source], [Page_Number], [Destination_String], [Sequence]) VALUES (9921, 7082, N'(c)', 0, NULL, N'', NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Source], [Page_Number], [Destination_String], [Sequence]) VALUES (9925, 7082, N'(c)', 0, NULL, N'', NULL)
PRINT(N'Operation applied to 3 rows out of 3')

PRINT(N'Add constraints to [dbo].[NEW_REQUIREMENT]')
ALTER TABLE [dbo].[NEW_REQUIREMENT] CHECK CONSTRAINT [FK_NEW_REQUIREMENT_NCSF_Category]
ALTER TABLE [dbo].[NEW_REQUIREMENT] WITH CHECK CHECK CONSTRAINT [FK_NEW_REQUIREMENT_QUESTION_GROUP_HEADING]
ALTER TABLE [dbo].[NEW_REQUIREMENT] CHECK CONSTRAINT [FK_NEW_REQUIREMENT_STANDARD_CATEGORY]
ALTER TABLE [dbo].[FINANCIAL_REQUIREMENTS] WITH CHECK CHECK CONSTRAINT [FK_FINANCIAL_REQUIREMENTS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[NERC_RISK_RANKING] CHECK CONSTRAINT [FK_NERC_RISK_RANKING_NEW_REQUIREMENT]
ALTER TABLE [dbo].[PARAMETER_REQUIREMENTS] CHECK CONSTRAINT [FK_Parameter_Requirements_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_LEVELS] CHECK CONSTRAINT [FK_REQUIREMENT_LEVELS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_QUESTIONS_SETS] WITH CHECK CHECK CONSTRAINT [FK_REQUIREMENT_QUESTIONS_SETS_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_REFERENCE_TEXT] WITH CHECK CHECK CONSTRAINT [FK_REQUIREMENT_REFERENCE_TEXT_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] CHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_NEW_REQUIREMENT]
ALTER TABLE [dbo].[REQUIREMENT_SETS] CHECK CONSTRAINT [FK_REQUIREMENT_SETS_NEW_REQUIREMENT]

PRINT(N'Add constraints to [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_REFERENCES] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[MATURITY_EXTRA]')
ALTER TABLE [dbo].[MATURITY_EXTRA] WITH CHECK CHECK CONSTRAINT [fk_mat_questions]

PRINT(N'Add constraints to [dbo].[ISE_ACTIONS]')
ALTER TABLE [dbo].[ISE_ACTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MAT_QUESTION_ID]

PRINT(N'Add constraints to [dbo].[IRP]')
ALTER TABLE [dbo].[IRP] WITH CHECK CHECK CONSTRAINT [FK_IRP_IRP_HEADER]
ALTER TABLE [dbo].[ASSESSMENT_IRP] WITH CHECK CHECK CONSTRAINT [FK__Assessmen__IRP_I__5EDF0F2E]
ALTER TABLE [dbo].[ASSESSMENTS] WITH CHECK CHECK CONSTRAINT [FK_ASSESSMENTS_GALLERY_ITEM]
ALTER TABLE [dbo].[GALLERY_GROUP_DETAILS] WITH CHECK CHECK CONSTRAINT [FK_GALLERY_GROUP_DETAILS_GALLERY_ITEM]
COMMIT TRANSACTION
GO
