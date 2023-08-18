/*
Run this script on:

(localdb)\INLLocalDb2022.CSETWeb12025TestUpgrade    -  This database will be modified

to synchronize it with:

(localdb)\INLLocalDb2022.CSETWeb12026

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.10.9.22680 from Red Gate Software Ltd at 8/15/2023 7:37:02 AM

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

PRINT(N'Disable DML triggers on [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] DISABLE TRIGGER [trg_update_maturity_groupings]

PRINT(N'Drop constraints from [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]

PRINT(N'Drop constraints from [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

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

PRINT(N'Drop constraint FK__HYDRO_DAT__Mat_Q__38652BE2 from [dbo].[HYDRO_DATA]')
ALTER TABLE [dbo].[HYDRO_DATA] NOCHECK CONSTRAINT [FK__HYDRO_DAT__Mat_Q__38652BE2]

PRINT(N'Drop constraint FK__ISE_ACTIO__Mat_Q__7F2CAE86 from [dbo].[ISE_ACTIONS]')
ALTER TABLE [dbo].[ISE_ACTIONS] NOCHECK CONSTRAINT [FK__ISE_ACTIO__Mat_Q__7F2CAE86]

PRINT(N'Drop constraint FK_MATURITY_QUESTIONS_MAT_QUESTION_ID from [dbo].[ISE_ACTIONS]')
ALTER TABLE [dbo].[ISE_ACTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MAT_QUESTION_ID]

PRINT(N'Drop constraint FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1 from [dbo].[MATURITY_ANSWER_OPTIONS]')
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] NOCHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1]

PRINT(N'Drop constraint FK_MATURITY_QUESTION_PROPS_MATURITY_QUESTIONS from [dbo].[MATURITY_QUESTION_PROPS]')
ALTER TABLE [dbo].[MATURITY_QUESTION_PROPS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTION_PROPS_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_TTP_MAT_QUESTION_MATURITY_QUESTIONS from [dbo].[TTP_MAT_QUESTION]')
ALTER TABLE [dbo].[TTP_MAT_QUESTION] NOCHECK CONSTRAINT [FK_TTP_MAT_QUESTION_MATURITY_QUESTIONS]

PRINT(N'Drop constraints from [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_GROUPING_TYPES]
ALTER TABLE [dbo].[MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_MODELS]

PRINT(N'Drop constraint FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS from [dbo].[MATURITY_DOMAIN_REMARKS]')
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] NOCHECK CONSTRAINT [FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS]

PRINT(N'Update rows in [dbo].[MATURITY_REFERENCE_TEXT]')
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font color="#000000"><span>Identify the organization''s high-value services, associated assets, and activities. A fundamental risk management principle is to focus on those activities that protect and sustain services and assets that most directly affect the organization''s ability to achieve its mission. This information should be made available to the Incident Management Function to support the prioritization of its detection and&#160;</span></font><span>response efforts.</span></p>' WHERE [Mat_Question_Id] = 1291 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font size="2">Prioritize and document the list of high-value services that must be provided if a disruption occurs.&#160;</font><font size="2">Consideration of the consequences of the loss of high-value organizational services is typically part of&#160;</font><span>a business impact analysis. In addition, the consequences of risks to high-value services are identified&#160;</span><span>and analyzed in risk assessment activities. The organization must consider this information when&#160;</span><span>prioritizing high-value services. This information should be made available to the Incident Management&#160;</span><span>Function to support the prioritization of its detection and response efforts.</span></p>' WHERE [Mat_Question_Id] = 1292 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font size="2">Identify and inventory high-value assets (technology, information, people, and facilities). An&#160;</font><span>organization must be able to identify its high-value assets, document them, and establish their value in&#160;</span><span>order to develop strategies for protecting and sustaining assets commensurate with their value to&#160;</span><span>services.</span></p><p class="p3"><font size="2"><br></font></p><p class="p3"><font size="2">Consider the following attributes for each asset:</font></p><p class="p2"></p><ul><li><font size="2">protection and sustainment requirements</font></li><li><font size="2">owners and custodians</font></li><li><font size="2">physical Locations</font></li><li><font size="2">organizational communications and data flows</font></li><li><font size="2">critical service(s) supported</font></li><li><font size="2">configuration standards</font></li><li><font size="2">baseline of network operations associated</font></li><li><font size="2">baseline of expected data flows</font></li></ul><p></p>' WHERE [Mat_Question_Id] = 1293 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font size="2">Organizational mission-critical systems and data should be identified, and an up-to-date inventory&#160;</font><span>should be provided to event detection, and incident handling and response personnel to support their&#160;</span><span>detection and response efforts.</span></p>' WHERE [Mat_Question_Id] = 1294 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font size="3">Security monitoring is an important function that enables an organization to detect suspicious activity&#160;across its enterprise. Suspicious activity includes unauthorized, security-relevant changes to&#160;organizational systems and networks.&#160;This capability ensures that the organization can:</font></p><p class="p2"></p><ul><li><font size="3">monitor networks and systems</font></li><li><font size="3">analyze or monitor the output of the security monitoring activities to detect possible intrusions</font></li><li><font size="3">notify stakeholders of suspicious behavior</font></li><li><font size="3">provide guidance and recommendations on tool selection, installation, and configuration;&#160;analysis and monitoring techniques and methodologies; and network monitoring strategies</font></li></ul><p></p><p class="p2"><font size="3">Technologies involved in security monitoring and analysis can include IDSs, IPSs, ADSs, AVSs,&#160;<span>netflow analysis tools, NFAT, host-based monitoring, and other similar tools.</span></font></p><p class="p2"><font size="3">Personnel monitor a variety of data (e.g., host logs, firewall logs, netflows) and use intrusion detection&#160;and prevention software to monitor network behavior, looking for indications of suspicious activity.&#160;Personnel performing proactive detect capabilities may be located in various areas of an organization&#160;such as an IT group, telecommunications group, security group, or CSIRT. In some organizations, the&#160;IT or network operations staff perform this capability and communicate any suspicious activity, or&#160;relevant incident or vulnerability information to an established incident handling and response team.</font></p>' WHERE [Mat_Question_Id] = 1295 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font size="3">Assets (people, information, technology, and facility) that support the organization''s critical services&#160;<span>should be monitored to include the observation of events occurring within the systems, or their&#160;</span><span>boundaries, to meet the monitoring objectives established. A comprehensive information system&#160;</span><span>monitoring capability can be achieved through a variety of tools and techniques (e.g., intrusion&#160;</span><span>detection systems, intrusion prevention systems, malicious code protection software, scanning tools,&#160;</span><span>audit record monitoring software, network monitoring software, log correlation and alerts). The&#160;</span><span>granularity of monitoring information collected should be based on organizational monitoring objectives&#160;</span><span>and the capability of information systems to support such objectives. Information system monitoring is&#160;</span><span>a foundational part of incident response.</span></font></p><p class="p2"><font size="3">The organization may need to assign priority to monitoring requirements due to resource constraints;&#160;<span>as such, the organization''s critical services may be higher priority.</span></font></p>' WHERE [Mat_Question_Id] = 1296 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font size="3">Proactive detection requires actions by the designated staff to identify suspicious activity. The data are&#160;<span>analyzed, and any unusual or suspicious event information is communicated to the appropriate&#160;</span><span>individuals for handling.</span></font></p><p class="p2"><font size="3">Personnel performing proactive detect capabilities communicate any suspicious activity or relevant&#160;<span>incident or vulnerability information to an established incident handling and response team. In such&#160;</span><span>cases, it is important to have established procedures for communicating this information. Personnel&#160;</span><span>performing the monitoring must have criteria to help them determine what type of alerts or suspicious&#160;</span><span>activity should be escalated.</span></font></p>' WHERE [Mat_Question_Id] = 1297 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font size="3">Define the methods of event detection and reporting. Define the criteria and responsibilities for&#160;<span>reporting events, and distribute throughout the organization as appropriate.</span></font></p><p class="p2"><font size="3">Examples of methods of detection:</font></p><p class="p3"></p><ul><li><font size="3">monitoring of technical infrastructure, including network architecture and network traffic</font></li><li><font size="3">reporting of problems or issues to the organization''s helpdesk</font></li><li><font size="3">observation of organizational managers and users of IT services</font></li><li><font size="3">reporting of environmental and geographical events through media such as television, radio,&#160;<span>and the Internet</span></font></li><li><font size="3">reporting from legal or law enforcement staff</font></li><li><font size="3">observation of a breakdown in processes or productivity of assets</font></li><li><font size="3">external notification from other entities such as CERT</font></li><li><font size="3">notification of results of audits or assessments</font></li></ul><p></p>' WHERE [Mat_Question_Id] = 1298 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font size="3">Develop and implement an incident management knowledge base that allows for the entry of event&#160;<span>reports (and the tracking of declared incidents) through all phases of their life cycle. Guidelines and&#160;</span><span>standards for the consistent documentation of events should be developed and communicated to all&#160;</span><span>those involved in the reporting and logging processes.</span></font></p>' WHERE [Mat_Question_Id] = 1299 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font size="2">The organization should identify the most effective methods for event detection and provide a process&#160;<span>for reporting events and incidents so that they can be triaged, analyzed, and addressed. This should&#160;</span><span>include the types of events and incidents (potential and declared) to report, and the methods.</span></font></p><p class="p2"></p><ul><li><font size="2">Require personnel to report suspected security incidents to the organization''s incident&#160;<span>response capability within a time period specified by the organization.</span></font></li><li><font size="2">Require partners, suppliers, and others to report suspected or verified security incidents&#160;<span>within a time period specified in applicable contracts, SLAs, and other relevant documents.</span></font></li><li><font size="2">Report security incident information to the appropriate authorities.</font></li></ul><p></p><p class="p2"><font size="2">These activities address incident reporting requirements in an organization. Ensure that the types of&#160;<span>security incidents reported, the content and timeliness of the reports, and the reporting authorities&#160;</span><span>designated, all reflect applicable laws, directives, regulations, policies, standards, and guidance.</span></font></p>' WHERE [Mat_Question_Id] = 1300 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font size="3">Assign a category to events from the organization''s standard category definitions during the triage&#160;process to assist with prioritization and correlation, and to develop proper responses.</font></p>' WHERE [Mat_Question_Id] = 1301 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font size="3">Perform correlation analysis on event reports to determine if there is affinity between two or more&#160;<span>events.</span></font></p>' WHERE [Mat_Question_Id] = 1302 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font size="3">Identify the tools, techniques, and methods that the organization will use to perform event correlation.&#160;<span>Pre-approving tools, techniques, and methods ensures consistency and cost-effectiveness, as well as&#160;</span><span>validity of results. This list should include both procedural and automated methods.</span></font></p><p class="p2"><font size="3">Perform correlation analysis on detected or reported events to determine if there is affinity between two&#160;<span>or more events. Ensure that the Incident Management Function has access to the schedule of&#160;</span><span>activities that may trigger false positive alerts, to deconflict detected events as known (benign) activity.&#160;</span><span>Evidence of a single incident may be captured in several logs. Correlating events among multiple&#160;</span><span>indication sources can be invaluable in validating whether a particular incident occurred, as well as&#160;</span><span>rapidly consolidating the pieces of data. Develop specific correlative metadata and ensure that the&#160;</span><span>event logs capture (and parse or align) this data, to be correlated by either technology or by manual&#160;</span><span>process(es) such as IP addresses, ports, protocols, services, timestamps, or other indicators of&#160;</span><span>compromise that could be common between multiple log sources.</span></font></p>' WHERE [Mat_Question_Id] = 1303 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font size="3">Prioritize events. Events may be prioritized based on event knowledge, system affected, potential&#160;<span>impact, the results of categorization and correlation analysis, incident declaration criteria and&#160;</span><span>experience with past-declared incidents. Events and incidents can be categorized in a variety of ways,&#160;</span><span>such as by the attack vector or method used (e.g., probe, scan, unpatched vulnerability, password&#160;</span><span>cracking, social engineering, or phishing attack); by the impact (e.g., denial of service, compromised&#160;</span><span>account, data leakage); by the scope (e.g., number of systems affected); by the success or failure of&#160;</span><span>the attack; or other factors.</span></font></p>' WHERE [Mat_Question_Id] = 1304 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font size="3">The organization should have a documented process for logging events as they are identified and for&#160;<span>tracking them through the incident life cycle. Logging and tracking ensure that the event is properly&#160;</span><span>progressing through the incident life cycle and that, most importantly, is closed when an appropriate&#160;</span><span>response and post-incident review have been completed. Logging and tracking facilitate event triage&#160;</span><span>and analysis activities; provide the ability to quickly obtain a status of the event and the organization''s&#160;</span><span>disposition; provide the basis for conversion from event to incident declaration; and may be useful in&#160;</span><span>post-incident review processes when trending and root-cause analysis are performed.</span></font></p>' WHERE [Mat_Question_Id] = 1305 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font size="3">Periodically review the event and incident management tracking system for events that have not been&#160;<span>closed or that do not have a disposition. Events that have not been closed or that do not have a&#160;</span><span>disposition should be reprioritized and analyzed for resolution.</span></font></p><p class="p3"><font size="3">Possible dispositions for events include:</font></p><p class="p2"></p><ul><li><font size="3">closed</font></li><li><font size="3">referred for further analysis</font></li><li><font size="3">referred to organizational unit or line of business for disposition</font></li><li><font size="3">declared an incident and referred to incident handling and response process</font></li></ul><p></p>' WHERE [Mat_Question_Id] = 1306 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font size="3">Ensure that processes are put in place to monitor compliance and identify corrective measures to&#160;<span>increase future compliance. These corrective measures may take the form of formal reminders to&#160;</span><span>individuals, establishment of corrective plans to improve performance, or administrative actions taken,&#160;</span><span>as appropriate.</span></font></p><p class="p2"><font size="3">Provide training to the assigned staff on the appropriate roles and responsibilities based on the&#160;<span>detailed job descriptions in the incident management plan, including event detection and handling. In&#160;</span><span>addition to job performance, the job descriptions and training should identify areas where noncompliance&#160;</span><span>yields specific consequences for the organization, and what role(s) take accountability for&#160;</span><span>various types of failures at each step of incident response.</span></font></p>' WHERE [Mat_Question_Id] = 1307 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font size="3">Incident escalation procedures should consider the extent of the incident and the appropriate&#160;<span>stakeholders. Incidents that the organization has declared and that require an organizational response&#160;</span><span>must be escalated to those stakeholders who can implement, manage, and bring to closure an&#160;</span><span>appropriate and timely solution. Typically, these stakeholders are internal to the organization but could&#160;</span><span>be external, such as contractors or other suppliers. The organization must establish processes to&#160;</span><span>ensure that incidents are referred to the appropriate stakeholders because failure to do so will impede&#160;</span><span>the organization''s response and may increase the level to which the organization is impacted.</span></font></p>' WHERE [Mat_Question_Id] = 1316 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font size="3">Identify relevant rules, laws, regulations, and policies for which forensic evidence should be collected&#160;<span>to address events and incidents. Evidence should be collected according to procedures that meet all&#160;</span><span>applicable laws and regulations that have been developed from previous discussions with legal staff&#160;</span><span>and appropriate law enforcement agencies so that any evidence can be admissible in court.</span></font></p>' WHERE [Mat_Question_Id] = 1324 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font size="3">Post-incident reviews are a part of the incident closure process. Establish criteria to determine the&#160;<span>extent of the review required for incident closure. Some examples of criteria could include:</span></font></p><p class="p3"></p><ul><li><font size="3">severity of damage</font></li><li><font size="3">assets involved</font></li><li><font size="3">duration of incident</font></li><li><font size="3">processes not followed</font></li><li><font size="3">visibility to public or stakeholders</font></li><li><font size="3">legal or regulatory requirements</font></li></ul><p></p><p class="p3"><font size="3">It is important to develop these criteria with the stakeholders to ensure that post-incident reviews occur<span>on all appropriate incidents, and do not consume unnecessary resources on those that do not meet the&#160;</span><span>established thresholds</span></font></p>' WHERE [Mat_Question_Id] = 1327 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1">This practice ensures that the results and findings of the post-incident analysis meetings or reviews of&#160;<span>&#8220;significant&#8221; incidents are generated, documented, and reported. The organization defines the meaning&#160;</span><span>of &#8220;significant.&#8221; The purpose of the reviews is to identify issues encountered and lessons learned, to&#160;</span><span>propose areas for improvement, and to act on the findings and recommendations. Post-incident&#160;</span><span>analysis of the handling of an incident may often reveal a missing step or procedural inaccuracy,&#160;</span><span>providing impetus for change. This report should detail the organization''s recommendations for&#160;</span><span>improvement in administrative, technical, and physical controls, as well as in event and incident&#160;</span><span>management processes.</span></p>' WHERE [Mat_Question_Id] = 1331 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font size="3">Guidance helps ensure regular and consistent testing of the incident detection, handling, and response&#160;<span>processes. Periodic testing should be conducted to ensure that these activities are effective and&#160;</span><span>complete, and that personnel understand their roles and responsibilities. A comprehensive,&#160;</span><span>organization-wide schedule for testing should be established based on factors such as risk, potential&#160;</span><span>consequences to the organization, and other organizationally-derived factors.</span></font></p>' WHERE [Mat_Question_Id] = 1333 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font size="3">Maintain a change history with rationale for performing the changes. Change management is a&#160;<span>continuous process and, therefore, requires that the organization effectively assign responsibility and&#160;</span><span>accountability for it. The organization must monitor the change management process to ensure that it&#160;</span><span>is being performed as expected.</span></font></p>' WHERE [Mat_Question_Id] = 1338 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><font size="3">Periodically test the organization''s backup and storage procedures and guidelines to ensure continued&#160;<span>validity as operational conditions change. Stored information assets should be tested periodically to&#160;</span><span>ensure that they are complete, accurate, and current, and can be used for restorative purposes when&#160;</span><span>necessary.</span></font></p>' WHERE [Mat_Question_Id] = 1359 AND [Sequence] = 1
PRINT(N'Operation applied to 24 rows out of 24')

PRINT(N'Update rows in [dbo].[MATURITY_QUESTIONS]')
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'EH:G1.Q1', [Question_Text]=N'Are the Organization’s Critical Services identified?', [Supplemental_Info]=N'<div><b>Question Intent</b>: To determine if <b>critical services are identified.</b></div><div><b><br></b></div><div><ul><li>A <b>service is a set of activities</b> that the organization carries out in the performance of a duty or in the production of a product.</li><li><b>Services</b> can be <b>externally or internally focused</b>. Examples include:</li><ul><li><span>a customer-facing website, such as an online payment system</span></li><li><span>human resources transactions</span></li></ul><li>Ideally, the organization will focus on activities to protect and sustain the identified services and assets that most directly affect the organization''s ability to achieve its mission.</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization has <b>identified all critical services.</b></li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization has identified <b>some critical </b>services.</li></ul></div>' WHERE [Mat_Question_Id] = 1291
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'EH:G1.Q2', [Question_Text]=N'Are organizational services prioritized, in order to focus event detection and incident response efforts on high-priority systems and assets?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine <b>if the organization prioritizes services.</b></div><div><b><br></b></div><div><ul><li>The organization should conduct analysis of each identified service (e.g., a business impact analysis) to determine the impact on the organization of the loss or disruption of each service.</li><li>The results of this analysis should then be used to prioritize the organizational services. This prioritization will allow the organization to focus protection and sustainment efforts (e.g., event detection and incident response) on those services with the most impact to the organization.</li></ul></div><div><b>Typical work products</b>:</div><div><ul><li>results of risk assessment and business impact analyses</li><li>prioritized list of organizational services, activities, and associated assets</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization has <b>prioritized all critical services </b>(identified in G1:Q1).</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization has prioritized some critical services.</li></ul></div>' WHERE [Mat_Question_Id] = 1292
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'EH:G1.Q3', [Question_Text]=N'Are the high-value assets (technology, information, people, and facilities) that directly support the organization’s critical services inventoried?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if the <b>assets that support the organization''s critical services are inventoried.</b></div><div><b><br></b></div><div><ul><li>The organization should<b> inventory the assets </b>(people, information, technology, and facilities) <b>required for the delivery of its critical services</b>.</li><li>Inventories of assets may <b>exist in multiple forms or physical locations.</b></li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization <b>inventories all assets (technology, information, people and facilities) for all services designated as critical by the organization.</b></li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization inventories <b>some</b> assets for all services designated as critical or the organization inventories all assets for some of the services designated as critical.</li></ul></div>' WHERE [Mat_Question_Id] = 1293
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'EH:G1.Q4', [Question_Text]=N'Do event detection and incident handling and response personnel have access to an organizational asset inventory?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To ensure that a more efficient response and remediation can be performed,<b> incident management personnel</b> should have access to the organizational asset inventory.</div><div><br></div><div><ul><li>The organization should provide all appropriate event and incident handling and response personnel access to the organization''s inventory of assets that support the organization''s services that are designated &#8220;critical.&#8221; This is necessary to support the event and incident handling and response activities.</li><li>Appropriate personnel are those who are involved in performing event and incident detection, handling and response duties, and others that may have a need to know.</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>All appropriate incident handling and response personnel have access to the organization''s asset inventory.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>Some of the appropriate incident handling and response personnel have access to the organization''s asset inventory.</li></ul></div>' WHERE [Mat_Question_Id] = 1294
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'EH:G1.Q5', [Question_Text]=N'Has the organization implemented security monitoring activities?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if <b>the organization has implemented security monitoring activities</b>, because these activities are an important aspect of event and incident detection.</div><div><br></div><div>Security monitoring is an important function that allows an organization to detect suspicious activity and other events throughout the enterprise. Suspicious activity also includes unauthorized, security-relevant changes to the organization''s systems and networks. Security monitoring activities should be based on a strategy to ensure continuous and complete monitoring of organizational networks and systems.</div><div><br></div><div><b>Typical work products</b>:</div><div><ul><li>Samples of logs, alerts, and reports generated by security monitoring tools</li><li>Network diagrams showing placement of monitoring tools on constituent networks</li><li>Intrusion Detection System (IDS), Intrusion Prevention System (IPS), Active Directory Services (ADS), or Anti-Virus System (AVS) configuration files that specify the anomalous events that trigger an alarm</li><li>Documentation of actions for responding to alerts and reports generated by security monitoring tools</li><li>Observations of actual monitoring activities including devices, software, and/or outputs</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>Security monitoring activities have been implemented to detect suspicious activity and other security-related events.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>Security monitoring is in development and partially implemented.</li></ul></div>' WHERE [Mat_Question_Id] = 1295
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'EH:G1.Q6', [Question_Text]=N'Are the assets (people, information, technology, and facilities) supporting those critical services monitored by the organization''s security monitoring activities?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if <b>assets are being monitored</b> by the organization''s security monitoring activities that can provide early warnings about malicious activity and other types of security events.&#160;</div><div><br></div><div>Security monitoring is an important proactive capability that allows an organization to detect suspicious activity and other types of events throughout the enterprise. Suspicious activity also includes unauthorized, security-relevant changes to the organization''s systems and networks. Such monitoring can:</div><div><ul><li>provide early warnings about malicious threats or activity in the organization''s infrastructure</li><li>allow response actions to be initiated in a timely manner</li><li>help contain the damage and impact to the organization</li></ul></div><div><b>Technologies involved in network monitoring and analysis include</b>:</div><div><ul><li>IDS, IPS, anomaly detection systems (ADS)</li><li>antivirus detection systems</li><li>netflow analysis tools</li><li>network forensics analysis tools</li></ul></div><div>Incident management personnel might assist organizations with monitoring tool selection, configuration, and installation, and analysis of output for detection of possible intrusions.</div><div><br></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>Security monitoring activities are performed for all assets that support any service designated as critical.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>Security monitoring activities are performed for some assets that support any service designated as critical.</li></ul></div>' WHERE [Mat_Question_Id] = 1296
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'EH:G1.Q7', [Question_Text]=N'Are events from those security monitoring activities reported to the Incident Management Function?', [Supplemental_Info]=N'<div><b>An event is one or more occurrences that affect assets</b>, and has the potential to <b>disrupt the critical service.</b><br></div><div><b><br></b></div><div><b>Question Intent:</b> To ensure that, in all situations, any <b>suspicious activity or other security-related events</b> obtained through the organization''s security monitoring activities <b>are reported</b> to the appropriate incident handling and response personnel.</div><div><br></div><div>Network security monitoring is an important proactive capability that allows an organization to detect suspicious activity throughout the enterprise. Suspicious activity also includes unauthorized, security-relevant changes to the organization''s systems and networks. Events collected from security monitoring activities should be reported to the appropriate event and incident handling and response personnel.</div><div><br></div><div>If an external party performs detection activities for the organization, any suspicious activity or other security-related&#160;<span>events obtained through the external party''s security monitoring activities should be reported to the appropriate&#160;</span><span>incident handling and response personnel.</span></div><div><br></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>All security events obtained from the security monitoring activities are reported to the appropriate event and incident handling and response personnel.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>Some security events are reported to the appropriate event and incident handling and response personnel.</li></ul></div>' WHERE [Mat_Question_Id] = 1297
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'EH:G2.Q1', [Question_Text]=N'Are events detected and reported?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if <b>events are detected and reported.</b></div><div><b><br></b></div><div><ul><li>An <b>event is one or more occurrences that affect assets</b>, and has the potential to <b>disrupt the critical service.</b></li><li><b>Events should be captured and analyzed</b> to determine if the event will become (or has become) an incident that requires action.</li></ul></div><div><b>Examples of event detection and reporting include</b>:</div><div><ul><li>monitoring of the technical infrastructure, including information, network traffic, servers, control systems, etc.</li><li>service desk ticketing and reporting</li><li>monitoring of personnel</li><li>reporting from law enforcement or legal staff</li><li>observation of breakdowns in processes or productivity of assets</li><li>external notification from other entities, such as US-CERT</li><li>results of audits or assessments</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>Events are detected and reported for all assets.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>Events are detected and reported for some assets.</li></ul></div>' WHERE [Mat_Question_Id] = 1298
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'EH:G2.Q2', [Question_Text]=N'Is event data logged in an incident knowledgebase or similar mechanism?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if <b>event data is logged in an incident knowledgebase </b>or similar mechanism.</div><div><br></div><div><ul><li><b>Logging and tracking event data in an incident knowledgebase or similar mechanism</b>:</li><ul><li><b>facilitates event triage and analysis </b>activities</li><li>provides the <b>ability to obtain a status and disposition</b> of the event</li></ul></ul><div><br></div><ul><li><b>An incident knowledgebase should contain basic event (and incident) information, such as</b>:</li><ul><li><span>a unique identifier</span></li><li><span>a brief description of the event</span></li><li><span>an event category (e.g., denial of service, virus intrusion, physical access violation)</span></li><li><span>the assets, services, and organizational units that are affected by the event</span></li><li><span>a brief description of how the event was identified and reported, by whom, and other relevant details (e.g., application system, network segment, operating system)</span></li><li><span>the individuals or teams to whom the event (or incident) was assigned</span></li><li><span>relevant dates</span></li><li><span>the actions taken and the resolution of the event</span></li></ul></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization <b>logs all event data</b> relevant to the organization in an incident knowledgebase or similar mechanism.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization logs relevant data on <b>some</b> events.</li></ul></div>' WHERE [Mat_Question_Id] = 1299
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'EH:G2.Q3', [Question_Text]=N'Does guidance exist that defines the types of events and incidents that should be reported (by users or partners)?' WHERE [Mat_Question_Id] = 1300
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'EH:G3.Q1', [Question_Text]=N'Are events categorized?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if <b>events are categorized.</b></div><div><b><br></b></div><div><ul><li>Event categories can help the organization understand and communicate the severity and potential impact that the event will have on the organization.</li><li>Events may be categorized by:</li><ul><li><b>type</b> (e.g., security, safety, unauthorized access, user issue, denial of service, virus intrusion, physical access violation)</li><li><b>severity </b>(e.g., critical, high, medium, low)</li><li>other categorization labels (e.g., internal, external, physical, technical)</li></ul></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization categorizes all events.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization categorizes some events.</li></ul></div>' WHERE [Mat_Question_Id] = 1301
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'EH:G3.Q2', [Question_Text]=N'Are events analyzed to determine if they are related to other events?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if <b>events are analyzed for any potential relationship to other events because</b> correlation may indicate that larger issues, problems, or incidents exist.</div><div><br></div><div>Event correlation can identify where activity is more widespread than originally thought, and identify any relationships among malicious attacks, compromises, and exploited vulnerabilities. Often events are reported individually; correlation enables analysts to recognize that a particular malware may have affected multiple systems on their organizational infrastructure instead of just one.</div><div><br></div><div>Manual processes may be used to perform an examination of event logs in a routine manner to look for relationships between events (e.g., events related to the same IP address or time stamp, etc.). The organization may also have automated systems (such as a SIEM) that perform the initial correlation of all events.</div><div><b><i><br></i></b></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization analyzes all events to determine if they are related to other events and or incidents.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization analyzes some events.</li></ul></div>' WHERE [Mat_Question_Id] = 1302
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'EH:G3.Q3', [Question_Text]=N'Is there a standard set of tools and/or methods in use to perform event correlation?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if a <b>standard set of tools and/or methods are in use for</b> event correlation during all phases of the incident management life cycle.</div><div><br></div><div>Event correlation can identify where activity is more widespread than originally thought, and identify any relationships among malicious attacks, compromises, and exploited vulnerabilities. Often events are reported individually; correlation enables analysts to recognize that a particular malware may have affected multiple systems on their organizational infrastructure instead of just one.</div><div><ul><li><b>Pre-approving</b> tools, techniques, and methods <b>ensures consistency</b>, as well as <b>validity, of results</b>.</li><li>The tools and methods can be both <b>procedural (scheduled log review) and automated (SIEM-based)</b>.</li><li>The tools and methods should <b>cover all asset types</b>.</li></ul></div><div><b>Examples of event correlation data sources are</b>:</div><div><ul><li>a known/expected activity database</li><li>metadata-tagged logs or data sources within an organization, such as IP addresses, ports, protocols, timestamps, etc.</li><li>domain names, IP addresses (source and target), hostnames, ports, protocols, and services</li><li>vulnerability scans</li><li>exercises</li><li>penetration testing</li><li>system configuration changes</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization has a <b>standard set of tools and/or methods</b> that are used in event correlation.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>A <b>standard set of tools and/or methods to perform event correlation is in development.</b></li></ul></div>' WHERE [Mat_Question_Id] = 1303
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'EH:G3.Q4', [Question_Text]=N'Are events prioritized?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine<b> if events are prioritized.</b></div><div><b><br></b></div><div><ul><li>Prioritization determines the order in which events should be addressed.</li><li>Events may be <b>prioritized based on</b>:</li><ul><li>the results of categorization and correlation analysis (severity, type, etc.)</li><li>experience with past events and incidents</li><li>potential impact to the organization</li></ul></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization prioritizes all events.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization prioritizes some events.</li></ul></div>' WHERE [Mat_Question_Id] = 1304
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'EH:G3.Q5', [Question_Text]=N'Is the status of events tracked?', [Supplemental_Info]=N'<div>Question Intent: To determine if the status of events is tracked.</div><div><br></div><div><ul><li>The <b>status</b> of events should be <b>checked regularly</b> to ensure that the events are moving through the organization''s established incident handling life cycle.</li><li><b>The status of events should be recorded in an incident knowledge base. Possible status types for events include:</b></li><ul><li>closed</li><li>referred for further analysis</li><li>referred to an organizational unit or line of business for disposition</li><li>declared as an incident</li></ul></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization<b> tracks the status of all events.</b></li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization tracks the status of <b>some</b> events.</li></ul></div>' WHERE [Mat_Question_Id] = 1305
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'EH:G3.Q6', [Question_Text]=N'Are events managed and tracked to resolution?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if <b>events are managed and tracked to resolution.</b></div><div><b><br></b></div><div><ul><li><b>Periodically </b>(as defined by the organization) <b>review</b> the incident knowledge base for events that have not been closed or that do not have a disposition.</li><li>Events that have not been closed or<b> that do not have a disposition should be reprioritized, analyzed, and tracked to resolution.</b></li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization <b>manages and tracks all events to resolution.</b></li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization manages and tracks <b>some</b> events to a resolution.</li></ul></div>' WHERE [Mat_Question_Id] = 1306
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'EH:G3.Q7', [Question_Text]=N'Are staff held accountable for performing event management on assets that support the organization''s critical services?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To ensure that event and incident handling and response personnel are held accountable for performing their event handling and response duties.</div><div><br></div><div>Managers are ultimately responsible for ensuring that incident response activities are performed properly. The immediate level of managers responsible for the process should review the event handling and response activities, status, and results, and identify issues. The reviews are intended to provide the immediate level of managers with appropriate information about those activities.</div><div><br></div><div><b>The reviews can be</b>:</div><div><ul><li>periodic (for example, planned as part of a regular audit of the organization''s event handling capability or of an employee''s performance). The frequency to be defined by the organization.</li><li>event-driven (if needed, between periodic reviews).</li></ul></div><div>Those assigned the responsibility for event detection and reporting should understand their tasks and have committed to performing them. Managers should initiate corrective measures to address all identified issues.</div><div><br></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization periodically (as defined by the organization) <b>evaluates event handling and response activities and holds staff accountable for performing their duties.</b></li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization has not established a review frequency for evaluating the event handling and response activities and staff performance of their duties.</li><li>Or, only some staff are evaluated and held accountable.</li><li>Or, only some of the event handling and response duties are evaluated.</li></ul></div>' WHERE [Mat_Question_Id] = 1307
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'IR:G1.Q1', [Question_Text]=N'Are incidents declared in accordance with a documented process?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if <b>incidents are declared</b> based on a documented process.</div><div><br></div><div><ul><li><b>Incident declaration defines when</b> the organization has established that <b>an incident has occurred, is occurring, or is imminent.</b></li><li>Incident <b>declaration may occur</b> based <b>on a specific event</b> or when <b>multiple events</b> are occurring to ensure that the organization makes a distinction between events and incidents (and the respective processes and differences in its handling).</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization <b>declares all incidents</b> based on a documented process.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization declares <b>some</b> incidents.</li><li>Or, the organization declares incidents but not in accordance with a documented process.</li></ul></div>' WHERE [Mat_Question_Id] = 1308
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'IR:G1.Q2', [Question_Text]=N'Have criteria for the declaration of an incident been established?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if <b>criteria for the consistent declaration of incidents are established.</b></div><div><b><br></b></div><div><ul><li>Declaration criteria guide the organization in determining when to declare an incident (particularly if incident declaration is not immediately apparent).</li></ul></div><div><b>Examples of incident declaration criteria:</b></div><div><ul><li>The event is (or is not) isolated.</li><li>The event surpasses one or more predefined thresholds of impact.</li><li>A past occurrence of the event resulted in an incident declaration.</li><li>The impact of the event is imminent or immediate.</li><li>The organization is experiencing negative effects from the event.</li><li>The life or safety of people is at risk.</li><li>The integrity and operability of a facility is at risk.</li><li>The integrity and operability of a high-value service or system is at risk.</li><li>The event constitutes fraud or theft.</li><li>There were impacts, such as damage to the organization''s reputation.</li><li>There is a potential legal infraction.</li><li>The event is security-related.</li><li>There was a successful violation of policy.</li><li>The source of attack was from a specified list.</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization has a <b>documented list of criteria</b> for the declaration of incidents.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>A documented list of criteria is in <b>development and partially documented.</b></li></ul></div>' WHERE [Mat_Question_Id] = 1309
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'IR:G1.Q3', [Question_Text]=N'Is there a process to prioritize and transfer incidents to the appropriate queue, group, or personnel after formal incident declaration?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if there is a process that prioritizes <b>incidents and guides the transfer to the appropriate queue, group, or personnel for input and/or resolution.</b></div><div><b><br></b></div><div><ul><li>Prioritization may be tied to the organization''s:</li><ul><li>risk appetite</li><li>impact to the organization</li><li>other organizationally-defined prioritization criteria</li></ul><li><b>Incidents</b> that the organization has declared <b>should be assigned to the appropriate queue, group, or personnel</b> who can manage and resolve the incident.</li><li><b>The queue, group, or personnel can be internal</b> to the organization (such as a standing incident response team or an incident-specific team) <b>or external,</b> in the form of contractors or other suppliers.</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization has a process to <b>prioritize all incidents and provides guidance on</b> how to transfer incidents <b>to the proper queue, group, or personnel</b> for input and resolution.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization has a process but does not include one of the following: a process to prioritize all incidents, or guidance on how to transfer them to the proper queue, group, or personnel for input and resolution.</li><li>Or, a process is in development and partially documented.</li></ul></div>' WHERE [Mat_Question_Id] = 1310
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'IR:G2.Q1', [Question_Text]=N'Are incidents analyzed to determine a response?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if <b>incidents are analyzed to determine a response.</b></div><div><b><br></b></div><div><ul><li><b>Incident analysis</b> should focus on <b>properly defining the underlying problem, condition, or issue.</b></li><li>Incident analysis should help the organization <b>prepare the most appropriate and timely response</b> to the incident.</li><li>Incident analysis should <b>determine</b> whether the incident has second-order <b>ramifications (e.g., legal, regulatory, reputation).</b></li></ul></div><div><b>Examples of incident analysis activities:</b></div><div><ul><li>interviews with those who reported the underlying event(s) and were affected by it</li><li>interviews of specific knowledge experts</li><li>review of relevant logs and audit trails of network and physical activity</li><li>consultation of vulnerability and incident databases (US-CERT Vulnerability Notes Database / MITRE''s Common Vulnerabilities and Exposures List)</li><li>consultation with law enforcement, legal, audit, product vendors, and emergency management</li><li>timeline development</li><li>malware analysis</li><li>system forensics captures / imaging</li></ul></div><div><b>Typical work products:</b></div><div><ul><li>incident analysis report</li><li>reports from analysis tools and techniques</li><li>updated incident knowledgebase</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization <b>analyzes all incidents </b>to determine a response.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization analyzes <b>some</b> incidents to determine a response.</li></ul></div>' WHERE [Mat_Question_Id] = 1311
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'IR:G2.Q2', [Question_Text]=N'Are incidents analyzed to determine if they are related to other incidents or events?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if<b> incidents are analyzed for their relationship to other incidents or events</b> because correlation may indicate that larger issues, problems, or incidents exist.</div><div><br></div><div><ul><li>Incident correlation can identify where activity is more widespread than originally thought, and identify any relationships among malicious attacks, compromises, and exploited vulnerabilities. Often incidents are declared individually; correlation enables analysts to recognize that the underlying cause of the incident may have affected more systems in the infrastructure than identified in the single incident.</li><li>The organization needs to have a task in the process, either automated or manual, to perform correlation analysis of the incident.</li><li>Manual processes may be used to perform an examination of incident records in a routine manner to look for relationships (e.g., events or incidents related to the same IP address or time stamp, etc.). The organization may also have automated systems that perform the correlation of incidents.</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization <b>analyzes all incidents</b> to determine if they are related to other incidents or events.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization<b> analyzes some incidents.</b></li></ul></div>' WHERE [Mat_Question_Id] = 1312
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'IR:G2.Q3', [Question_Text]=N'Is there a standard set of tools and/or methods in use to perform incident correlation?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if a <b>standard set of tools and/or methods are in use for</b> incident correlation&#160;<span>during all phases of the incident management life cycle.</span></div><div><br></div><div>Incident correlation can identify where activity is more widespread than originally thought, and identify any relationships among malicious attacks, compromises, and exploited vulnerabilities, or deconflicting with nonmalicious activity. Often incidents are declared individually; correlation enables analysts to recognize that the underlying cause of the incident may have affected more systems in the infrastructure than identified in the single incident.</div><div><ul><li><b>Pre-approving </b>tools, techniques, and methods <b>ensures consistency</b>, as well as <b>validity, of results.</b></li><li>The tools and methods can be both <b>procedural (such as log review) and automated.</b></li><li>The tools and methods should <b>cover all asset types.</b></li></ul></div><div><b>Examples of incident correlation data sources are</b>:</div><div><ul><li>metadata-tagged logs or data sources within an organization, such as IP addresses, ports, protocols,</li><li>timestamps, etc.</li><li>domain names, IP addresses (source and target), hostnames, ports, protocols, and services</li><li>vulnerability scans</li><li>exercises</li><li>penetration testing</li><li>system configuration changes</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization has a <b>standard set of tools and/or methods</b> that are used in incident correlation.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>A <b>standard set of tools and/or methods</b> to perform incident correlation is in development.</li></ul></div><div><br></div>' WHERE [Mat_Question_Id] = 1313
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'IR:G2.Q4', [Question_Text]=N'Is the impact to the organization''s services assessed in the course of incident analysis?', [Supplemental_Info]=N'<div><b>Question Intent:</b> The intent is to determine if incident analysis includes assessing the impact of the incident on the organization.</div><div><br></div><div><ul><li>The purpose of impact analysis is to determine the breadth and severity of an incident to facilitate additional steps in the incident response process.</li><li>Without information about how an incident has affected an organization, incident responders cannot accurately plan containment, remediation, or eradication efforts.</li><li>Incident management personnel may use the results of impact analysis to further prioritize incidents and related events during and after the triage process.</li></ul></div><div><b>Typical work products or examples</b>:</div><div><ul><li>Records of incident analyses containing impact assessments</li><li>Standardized forms or categories for recording and assessing impact</li></ul></div><div><b><i>Criteria for a &#34;Yes&#34; response:</i></b></div><div><ul><li>The impact on the organization is assessed for all incidents.</li></ul></div><div><b><i>Criteria for an &#34;Incomplete&#34; response:</i></b></div><div><ul><li>The impact on the organization is assessed for some incidents.</li></ul></div>' WHERE [Mat_Question_Id] = 1314
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'IR:G2.Q5', [Question_Text]=N'Is analysis performed to determine the root causes of incidents?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if the organization <b>employs commonly available techniques to preform root cause analysis</b> as a means of ensuring the appropriate response, and potentially preventing future incidents of a similar type and impact.</div><div><br></div><div><b>Root cause analysis may require the results or information from other types of analyses, such as</b>:</div><div><ul><li>system analysis</li><li>network analysis</li><li>malware analysis</li><li>vulnerability analysis</li><li>retrospective/lateral analysis (what else did the attacker do?)</li><li>trend analysis</li><li>threat vector analysis</li></ul></div><div><b>Typical work products include</b>:</div><div><ul><li>a list, catalog, or taxonomy of possible causes or threat vectors</li><li>a timeline of the incident and relevant events leading to it</li><li>a root cause analysis report</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization <b>analyzes all incidents to determine the root cause.</b></li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization analyzes <b>some</b> incidents to determine the root cause.</li></ul></div>' WHERE [Mat_Question_Id] = 1315
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'IR:G3.Q1', [Question_Text]=N'Are incidents escalated to internal and external stakeholders for input and resolution?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if the Incident Management Function leverages the appropriate stakeholders to solicit input and assist with incident resolution.</div><div><br></div><div><ul><li><b>Incidents</b> that the organization has declared <b>should be escalated to stakeholders</b> who can help manage and resolve the incident.</li><li><b>Stakeholders can be internal</b> to the organization (such as a permanent incident response team, an incident-specific team, IT Operations or, in some cases, additional business resources) <b>or external </b>(such as third-party contractors or other suppliers).</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization <b>escalates all incidents to the proper stakeholders</b> for input and resolution.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization escalates some incidents to the proper stakeholders for input and resolution.</li></ul></div>' WHERE [Mat_Question_Id] = 1316
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'IR:G3.Q2', [Question_Text]=N'Does guidance exist that includes the categories of incidents to report, along with the required information, timeframes, and contact mechanisms for internal and external stakeholders?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To identify if guidance exists that describes what (categories of incidents to report, and required information), when (timeframes), and how (contact mechanisms) they will be provided to external and internal stakeholders.</div><div><br></div><div><ul><li>Accessible and well-documented guidance of this information ensures that the data shared is accurate, timely, and complete.</li><li>Special consideration should be made for insider threat-related incidents, because they often require unique handling in an organization due to the sensitivity and legalities involved.</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization has documented guidance that describes categories of incidents to report, required information, timeframes, and contact mechanisms for internal and external stakeholders.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The guidance is in development or partially documented.</li></ul></div>', [Sequence]=2, [Grouping_Id]=213 WHERE [Mat_Question_Id] = 1317
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'IR:G3.Q3', [Question_Text]=N'Does the guidance include operational and information security requirements?', [Supplemental_Info]=N'<div><b>Question intent:</b> To determine if the guidance contains operational and information security requirements. It is essential to protect sensitive information that could further damage the organization if exposed.</div><div><br></div><div>For each stakeholder who is notified or leveraged for response to the incident, there may be specific security requirements that must be met to communicate details about the incident. These requirements may include:</div><div><ul><li>specific encrypted communications (that the recipients have a capability to decrypt)</li><li>omission of certain information that is not appropriate to be shared with certain individuals or organizations</li><li>specific marking/classification schema that may be different than those of the internal organization</li></ul></div><div><b><i>Criteria for &#34;Yes&#34; response:</i></b></div><div><ul><li>There is documented guidance that includes operational and information security requirements for each stakeholder.</li></ul></div><div><b><i>Criteria for &#34;Incomplete&#34; response:</i></b></div><div><ul><li>The guidance is in development and partially documented.</li></ul></div>', [Sequence]=3 WHERE [Mat_Question_Id] = 1318
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'IR:G3.Q4', [Question_Text]=N'Are responses to declared incidents developed and implemented according to pre-defined procedures?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if <b>responses to declared incidents are developed and implemented according to pre-defined procedures.</b></div><div><b><br></b></div><div><ul><li>The organization''s <b>response to an incident</b> should be described in <b>pre-defined incident response procedures.</b></li><li>Pre-defined procedures<b> describe the actions the organization takes to prevent or contain the impact</b> of an incident.</li><li><b>Incident response may be </b>as <b>simple</b> as notifying users to avoid opening a specific type of email message <b>or</b> as <b>complicated</b> as having to implement service continuity plans.</li></ul></div><div><b>The specific actions detailed in the pre-defined procedures may include:</b></div><div><ul><li>identification of potential impact plan of action (including the allocation of resources)</li><li>containment of damages (i.e., taking hardware or systems offline or locking down a facility)</li><li>collection of evidence (including logs and audit trails)</li><li>interviews of relevant staff</li><li>communication to stakeholders</li><li>development and implementation of corrective actions and controls</li><li>implementation of continuity and restoration plans, or other emergency actions</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization <b>uses predefined procedures to develop and implement a response</b> to <b>all</b> declared incidents.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization uses predefined procedures to develop and implement a response to <b>some</b> declared incidents.</li><li>Or; pre-defined procedures for responding to declared incidents are <b>in development and partially documented.</b></li></ul></div>', [Sequence]=4 WHERE [Mat_Question_Id] = 1319
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'IR:G3.Q5', [Question_Text]=N'Are incident status and response communicated to affected parties (including public relations staff and external media outlets)?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if <b>incident status and response are communicated</b> to affected parties.</div><div><br></div><div><ul><li>Incident status and response should be communicated in a controlled and regular manner to internal and external stakeholders.</li><li>Incident status and response should be <b>managed throughout the incident lifecycle.</b></li><li>There is coordination with these groups to share information and response actions on intrusions, attacks, and suspicious activities.</li><li>Depending on the organizational structure or model used for their incident response team, this coordination may be led by a centralized response team or across distributed response teams.</li></ul></div><div><b>The incident communication process should include:</b></div><div><ul><li>the stakeholders with whom communication about incidents are required</li><li>the level of communication appropriate to various stakeholders</li><li>special controls of communication (i.e., encryption or secured communications) that are appropriate for some stakeholders</li><li>the frequency and timing of communication</li></ul></div><div><b>Examples of stakeholders who may need to be included in incident communication:</b></div><div><ul><li>internal staff who have incident handling and management responsibilities</li><li>asset owners and service owners</li><li>information technology staff</li><li>business continuity staff</li><li>affected customers or suppliers</li><li>local, state, and federal emergency management staff</li><li>support functions, such as legal, audit, and human resources</li><li>law enforcement staff (including federal agencies)</li><li>regulatory and governing agencies</li><li>local utilities (power, gas, telecommunications, water, etc.)</li><li>&#160;CIO, CISO, and/or head of information security</li><li>&#160;local information security officer</li><li>other incident response teams within the organization</li><li>external incident response teams (if appropriate)</li><li>public affairs (for incidents that may generate publicity)</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization communicates incident status and response to all affected parties.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization communicates incident status and response to some affected parties.</li></ul></div>', [Sequence]=5 WHERE [Mat_Question_Id] = 1320
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'IR:G3.Q6', [Question_Text]=N'Are alerts and warnings applicable to ongoing incidents communicated to the internal and external stakeholders as necessary?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To ensure that the incident management organization provide alerts, notifications, and warnings to promote awareness of relevant/active incidents for internal and external stakeholders.</div><div><br></div><div>For circumstances where stakeholder or user awareness or actions are necessary to help contain or remediate the incident, or prevent more widespread impact, it is essential to communicate these details effectively during the incident response process.</div><div><br></div><div>Incident management personnel work to provide such notifications and warnings to promote awareness of threats and malicious activity, and to help support organizational response actions. Depending on the mission of the incident management function, alerts and warnings may be shared with other relevant stakeholders and external parties.</div><div><br></div><div>Notifications, reports, and warnings should be distributed in a manner commensurate with the sensitivity of the information related to the activity. Sensitive information should be handled only through appropriate mechanisms.</div><div><br></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization communicates <b>alerts, notifications, and warnings</b> for all ongoing incidents.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization communicates <b>alerts, notifications, and warnings</b> for some incidents.</li></ul></div>', [Sequence]=6 WHERE [Mat_Question_Id] = 1321
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'IR:G3.Q7', [Question_Text]=N'Are incidents managed and tracked to resolution?', [Supplemental_Info]=N'<div><b>&#160;Question Intent: </b>To determine if <b>incidents are tracked and managed to resolution.</b></div><div><b><br></b></div><div><ul><li>The organization should have a <b>process for the formal closure of incidents</b> that results in formally logging a status of &#8220;closed&#8221; in the incident knowledge base.</li><li>The <b>status of incidents</b> in the incident knowledge base should be reviewed regularly to determine if open incidents should be closed or need additional action.</li></ul></div><div><b>Typical work products:</b></div><div><ul><li>criteria for incident closure</li><li>incident closure reports</li><li>updated incident knowledgebase</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization <b>tracks and manages all incidents to resolution.</b></li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization tracks and manages <b>some</b> incidents to resolution.</li></ul></div>', [Sequence]=7 WHERE [Mat_Question_Id] = 1322
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'IR:G4.Q1', [Question_Text]=N'Have requirements (rules, laws, regulations, policies, etc.) for identifying event and incident evidence for forensic purposes been identified?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if requirements <b>for identifying event and incident evidence</b> for forensic purposes<b> have been identified</b>.</div><div><br></div><div><ul><li>Collecting, retaining, and analyzing event and incident information in a way that is acceptable in a court of Law is essential in order to prosecute criminal activities.</li><li>If proper methods are not used, organizations may not be able to prosecute due to insufficient, corrupted, or inconclusive data.</li><li>An event may become an organizational incident that has the potential to be a violation of local, state, or federal rules, laws, and regulations.</li></ul></div><div>This is often not known early in the investigation of an event, therefore the organization should <b>ensure that it has identified the requirements that dictate what event and incident evidence is handled forensically.</b></div><div><b><br></b></div><div><b>The requirements may come from</b>:</div><div><ul><li>Securities and Exchange Commission regulatory requirements</li><li>state privacy laws</li><li>Food and Drug Administration regulatory requirements</li><li>chain of custody requirements</li><li>other sector-specific regulatory bodies</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization has identified and documented relevant requirements for identifying event evidence for forensic purposes.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>Requirements for identifying event evidence are in development and partially documented.</li></ul></div>' WHERE [Mat_Question_Id] = 1323
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'IR:G4.Q2', [Question_Text]=N'Have criteria been defined for when forensic analysis should be conducted on events and incidents?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if the organization has documented criteria defining when forensic analysis is to be performed on events and incidents.</div><div><br></div><div><ul><li>Fulfillment of the forensic requirements may be resource-intensive, therefore criteria are established to filter which events/incidents will have forensic analysis performed.</li><li>This is often not known early in the investigation of an event, therefore the organization should <b>ensure that it has identified the criteria that describe the event and incident evidence to be handled forensically.</b></li></ul></div><div><b>Examples of criteria</b>:</div><div><ul><li>perceived threat vector or actor</li><li>perceived malicious activity</li><li>perceived insider threat activity</li><li>potential criminal activity</li><li>activities with potential for legal implications</li><li>regulatory requirements</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization has <b>identified and documented criteria</b> for when forensic analysis should be conducted.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>Criteria for performing forensic analysis are <b>in development, or partially documented.</b></li></ul></div>', [Sequence]=2, [Grouping_Id]=214 WHERE [Mat_Question_Id] = 1324
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'IR:G4.Q3', [Question_Text]=N'Is there a documented process to ensure event and incident evidence is handled and retained in accordance with the organization''s legal or regulatory obligations, or in accordance with the needs of law enforcement or other incident responders?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if the organization has <b>documented a process to ensure that event and incident evidence is handled as required</b> by law or other obligations.</div><div><br></div><div><ul><li>Based on applicable requirements, the organization should develop a process that uses standards and guidelines for the collection, documentation, and preservation of event and incident evidence.</li><li>Staff should be trained on the organizational process for proper identification and handling of evidence to ensure that the evidence is not altered and its integrity is maintained.</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>There is a <b>documented process</b> to ensure that event and incident evidence is handled as required by law or other obligations.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>A process is <b>in development and partially documented.</b></li></ul></div>', [Sequence]=3, [Grouping_Id]=214 WHERE [Mat_Question_Id] = 1325
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'IR:G4.Q4', [Question_Text]=N'Are forensic analysis results and reports provided to the appropriate stakeholders?', [Supplemental_Info]=N'<div><b>&#160;Question Intent: </b>To determine if the organization provides the results of forensic analysis to the appropriate stakeholders.</div><div><br></div><div><ul><li>Based on applicable requirements, the organization should <b>develop a forensic analysis reporting process.</b></li><li>The <b>process should describe the stakeholders</b> to whom the results of the forensic analysis must be communicated and the means of communication.</li><li>Forensic analysis may be performed for law enforcement purposes, or for detailed incident analysis to determine root cause or other information about what occurred.</li><li>Additional sensitivities may need to be taken into consideration, because the results of forensic analysis during an incident may contain personal or organizationally sensitive data not typically encountered in incident response.</li><li><b>Staff should be trained</b> on the organizational process for reporting the results of forensic analysis, to ensure that the appropriate stakeholder(s) receive the results.</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>Forensic analysis results and reports are provided to all the appropriate stakeholders.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>Forensic analysis results and reports are provided to some of the appropriate stakeholders.</li></ul></div>', [Sequence]=4 WHERE [Mat_Question_Id] = 1326
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PI:G1.Q1', [Question_Text]=N'Do criteria exist for identifying incidents that require a postincident review?', [Supplemental_Info]=N'<div><b>Question Intent</b>: To determine if there are documented criteria that determines which<b> incidents require a post incident review.</b></div><div><b><br></b></div><div><ul><li>This practice ensures that post-incident analysis meetings or reviews are held after significant incidents. The organization will use the criteria to help define &#8220;significant.&#8221;</li><li>The intent of these reviews is to identify any issues encountered or lessons learned, to propose areas for improvement, and to act on any findings or recommendations.</li></ul></div><div><b>Examples of documented criteria</b>:</div><div><ul><li>departure from standard procedures</li><li>incidents of significant impact</li><li>incidents with unknown root cause</li><li>incidents of potential criminal activity</li><li>incidents of potential insider threat</li><li>incidents required by regulation to be reviewed</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization <b>uses documented criteria to evaluate all incidents</b> for post-incident review.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The criteria for post-incident review <b>is in development and partially documented.</b></li><li>Or, the <b>criteria exist</b>, but are used for only <b>some</b> incidents.</li></ul></div>' WHERE [Mat_Question_Id] = 1327
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PI:G1.Q2', [Question_Text]=N'Is a post-incident review performed?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if the organization performs a post-incident review for incidents that require (meet the organization''s selection criteria) a review for the purpose of ensuring lessons learned are identified.</div><div><br></div><div><ul><li>Post-incident analysis meetings or reviews should be held after significant incidents. The organization will need to define what &#8220;significant&#8221; means. The intent of these reviews is to identify any issues encountered or lessons learned, to propose areas for improvement, and to act on any findings or recommendations.</li><li>Lessons-learned meetings or reviews can be extremely helpful in improving security measures and the incident handling process itself. A lessons-learned meeting or review should be held after a major incident with all involved parties.</li></ul></div><div><b>Questions to be answered in the meeting may include</b>:</div><div><ul><li>Exactly what happened, and at what times?</li><li>How well did staff and management perform in dealing with the incident? Were the documented procedures followed? Were they adequate?</li><li>What information was needed sooner?</li><li>Were any steps or actions taken that might have hindered the recovery?</li><li>What would the staff and management do differently the next time a similar incident occurs?</li><li>How could information sharing with other organizations have been improved?</li><li>What corrective actions can prevent similar incidents in the future?</li><li>What precursors or indicators should be watched for in the future to detect similar incidents?</li><li>What additional tools or resources are needed to detect, analyze, and mitigate future incidents?</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div>The organization performs post-incident reviews <b>for all incidents</b> that require (meet the organization''s selection criteria) a review.</div><div><br></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div>The organization performs post-incident reviews <b>for some incidents</b> that require (meet the organization''s selection criteria) a review.</div>' WHERE [Mat_Question_Id] = 1328
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PI:G1.Q3', [Question_Text]=N'Are lessons learned from post incident review and analysis used to improve organizational asset protection and sustainment strategies?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if <b>lessons learned are used to improve the organization''s asset protection and sustainment strategies.</b></div><div><b><br></b></div><div><ul><li>Lessons learned from post-incident review should help determine the validity and effectiveness of the organization''s current strategies for protecting and sustaining assets.</li><li>Lessons learned can be extremely helpful in improving an organizations protection and sustainment strategies and the incident handling process itself.</li><li>A lessons-learned meeting or review should be held after a major incident with all stakeholders.</li><li>Lessons-learned data can be incorporated into the organization''s risk management process, ultimately leading to the selection and implementation of additional controls and improvements to the organization''s protection and sustainment strategies.</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization<b> uses lessons learned from all incidents that required post-incident review</b>, to improve asset protection and sustainment strategies.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization uses lessons learned <b>from some incidents</b> that required post-incident review, to improve asset protection and sustainment strategies.</li><li>Or, the organization uses some lessons learned to improve asset protection and sustainment strategies.</li></ul></div>' WHERE [Mat_Question_Id] = 1329
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PI:G1.Q4', [Question_Text]=N'Are improvements to the event and incident detection, handling or response process identified as a result of post-incident review and analysis?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if the results of post-incident reviews are used to identify improvements to the incident detection, handling, or response process.</div><div><br></div><div><ul><li>Updating incident response policies and procedures is another important part of the lessons learned process.</li><li>Post-incident review of the way an incident was handled will often reveal a missing step, inaccuracy, or inefficiencies in a procedure, providing impetus for change.</li><li>Because of the changing nature of information technology and changes in personnel, the incident response team should review all related documentation and procedures for handling incidents at designated intervals.</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization <b>uses lessons learned from all incidents that required post-incident review</b>, to improve the event and incident detection, handling or response process.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization uses lessons learned from <b>some</b> incidents that required post-incident review, to improve the event and incident detection, handling or response process.</li></ul></div>' WHERE [Mat_Question_Id] = 1330
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PI:G1.Q5', [Question_Text]=N'Are post-incident analysis reports generated and archived?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if the organization generates post-incident analysis reports and stores them in a controlled manner.</div><div><br></div><div><ul><li>It is important to document all lessons learned, the major points of agreement, and action items, and to communicate them to parties who could not attend the meeting.</li><li>Lessons learned should be documented according to the organization''s required format and needs to meet any regulatory reporting requirements.</li><li>The report provides a reference that can be used to assist in handling similar incidents.</li><li>Reports from these meetings or reviews are good material for training new team members by showing them how more experienced team members respond to incidents.</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>Post-incident analysis reports are <b>documented and archived for all incidents</b> that require a post-incident review.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>Post-incident analysis reports are <b>documented and archived for some incidents</b> that require a post-incident review.</li></ul></div>' WHERE [Mat_Question_Id] = 1331
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PI:G2.Q1', [Question_Text]=N'Have standards for testing the incident detection, handling, and response process been implemented?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if <b>standards for testing incident detection, handling, and response process have been developed and implemented.</b></div><div><b><br></b></div><div><ul><li>Test standards <b>ensure that test processes are consistent, effective, and meet the organization''s requirements.</b></li><li>Testing should be <b>conducted in a controlled environment.</b></li><li>Testing is <b>often the only opportunity</b> for an organization to know whether the plans meet their stated objectives.</li><li>The testing program and standards should be enforced to<b> ensure consistency</b> and the ability to interpret results at the organizational level.</li></ul></div><div><b>Standards for incident detection, handling, and response process can include:</b></div><div><ul><li>types of tests or operational exercises (e.g., walkthroughs, tabletops, functional involving penetration testing or red teaming, etc.)</li><li>required test plan components and templates</li><li>example and required incident handling and response scenarios</li><li>standard questions to be used in all test scenarios</li><li>instructions for participating in an exercise</li><li>standards for documenting lessons learned</li><li>testing frequency</li><li>quality assurance standards</li><li>involvement and commitment of stakeholders</li><li>reporting standards</li><li>measurement standards</li><li>test plan maintenance</li></ul><span><b>Typical work products include:</b></span><br><ul><li>Documented test standards</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>There are <b>documented standards</b> for testing the incident detection, handling, and response processes.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>Standards for testing the incident detection, handling, and response processes are <b>in development and partially documented.</b></li></ul></div>' WHERE [Mat_Question_Id] = 1332
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PI:G2.Q2', [Question_Text]=N'Does documented guidance exist that requires periodic testing of the incident detection, handling, and response activities?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if the organization has documented guidance requiring the periodic testing of the incident detection, handling, and response activities.</div><div><br></div><div><ul><li>Documented guidance can take the form of guidelines, policies, or standards.</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>There is <b>documented guidance</b> that requires the periodic testing of incident detection, handling, and response activities.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>Documented guidance that requires periodic testing is <b><i>in development and partially documented.</i></b></li></ul></div>' WHERE [Mat_Question_Id] = 1333
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PI:G2.Q3', [Question_Text]=N'Has a schedule for testing the incident detection, handling, and response process been established?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if a <b>schedule for testing the incident detection, handling, and response process is established and documented.</b></div><div><b><br></b></div><div><ul><li>The test <b>schedule should meet the requirements</b> set by the organization.</li><li>Periodic testing and evaluation of the effectiveness of incident detection, handling, and response process, procedures, and practices should be performed with a frequency informed by the organization''s risk process.</li></ul></div><div><b>Typical work products include:</b></div><div><ul><li>documented test schedule</li><li>distribution and coordination list of relevant stakeholders</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>There is a <b>documented schedule</b> for testing the incident detection, handling and response process, procedures and activities.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The schedule for testing the incident detection, handling and response processes is <b>in development and partially documented.</b></li></ul></div>' WHERE [Mat_Question_Id] = 1334
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PI:G2.Q4', [Question_Text]=N'Is the incident detection, handling, and response process tested?', [Supplemental_Info]=N'<div><b>Question Intent</b>: To determine if the organization''s <b>incident detection, handling, and response processes are tested.</b></div><div><b><br></b></div><div><ul><li>The tests should <b>establish the viability, accuracy, and completeness </b>of the incident detection, handling and response processes, procedures, and activities. For example:</li><ul><li>Perform triage.</li><li>Respond to events and incidents in a timely manner.</li><li>Notify correct people.</li><li>Protect data during transmission.</li><li>Meet SLAs.</li></ul><li>The tests results should provide information about the organization''s level of preparedness.</li><li>The tests should be performed under conditions established by the organization, and the results of the test should be recorded and documented.</li></ul></div><div><b>Typical work products include:</b></div><div><ul><li>documented test results</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li><b>All</b> Incident detection, handling, and response processes, procedures and activities are tested.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li><b>Some</b> incident detection, handling, and response processes, procedures, and activities are tested.</li></ul></div>' WHERE [Mat_Question_Id] = 1335
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PI:G2.Q5', [Question_Text]=N'Are all relevant elements of the organization involved in testing the incident detection, handling, and response processes?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if all relevant elements of the organization are involved in testing the incident detection, handling and response process, procedures and activities.</div><div><br></div><div><ul><li>All relevant stakeholders, both internal and external, should be identified and involved in testing the incident detection, handling, and response processes, procedures and activities.</li><li>The level of involvement and commitment of stakeholders in the testing of the plan should be established.</li><li>Methods of communicating with all relevant stakeholders should be established.</li><li>All relevant stakeholders should understand and accept their roles and responsibilities.</li></ul></div><div><b>Typical work products include</b>:</div><div><ul><li>Documented Incident detection, handling, and response processes, procedures, and activities that include relevant stakeholders.</li><li>Documented Incident detection, handling, and response test plans that include relevant stakeholders.</li><li>Documented test report that show all relevant participating stakeholders.</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li><b>All relevant elements (stakeholders) of the organization</b> are involved in testing the Incident detection, handling, and response processes, procedures and activities.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li><b>Some</b> relevant elements (stakeholders) of the organization are involved in testing.</li></ul></div>' WHERE [Mat_Question_Id] = 1336
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PI:G2.Q6', [Question_Text]=N'Are test results compared with test objectives to identify needed improvements to the incident detection, handling, and response processes?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if <b>test results are compared to test objectives to identify improvements</b> to incident detection, handling, and response processes.</div><div><br></div><div><ul><li>The objective of incident detection, handling, and response process testing is to <b>ensure that processes, procedures, and activities, work as intended.</b></li><li><b>Testing identifies improvements</b> to the incident detection, handling, and response processes, as well as improvements to the test plans.</li><li>The evaluation of test results involves comparing the documented test results against the established test objectives.</li><li>Areas where objectives could not be met are recorded, and strategies are developed to review and revise the incident detection, handling and response processes, procedures and activities.</li><li><b>Improvements to the testing process</b> and plans should also be identified, documented, and incorporated into future tests.</li></ul></div><div><b>Improvement areas may include</b>:</div><div><ul><li>lack of sufficient resources</li><li>lack of appropriate resources</li><li>training gaps for plan staff and stakeholders</li><li>plan conflicts (if multiple plans are tested simultaneously)</li><li>the test objectives or test procedures</li><li>the incident detection, handling, and response processes</li></ul></div><div><b>Typical work products include:</b></div><div><ul><li>documented test results</li><li>list of improvements to incident detection, handling, and response processes</li><li>list of improvements to incident detection, handling, and response processes test plans</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li><b>Test results for all i</b>ncident detection, handling, and response process tests <b>are compared with test objectives</b> to identify needed improvements.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>Test results for <b>some</b> incident detection, handling, and response process tests are compared with test objectives to identify needed improvements.</li></ul></div>' WHERE [Mat_Question_Id] = 1337
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'OC:G1.Q1', [Question_Text]=N'Does the organization have a change management process that is used to manage modifications to assets?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if a <b>change management</b> process is <b>used to manage asset modifications.</b></div><div><b><br></b></div><div><ul><li>Change management is a continuous process of controlling and approving changes to assets that support organizational services.</li></ul></div><div><b>This process addresses the</b></div><div><ul><li>addition of new assets</li><li>changes to the asset, including ownership, custodianship, and location</li><li>elimination of assets</li></ul></div><div><b>Typical work products</b></div><div><ul><li>change requests</li><li>change implementation plan</li><li>backout plan</li><li>change and configuration management board meeting minutes</li><li>change approvals</li><li>change tracking and status</li><li>change documentation, including test results</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>A <b>change management process is used</b> to control changes to <b>all</b> assets that support the organizational services.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>A change management process is used to control changes to <b>some</b> assets.</li></ul></div>' WHERE [Mat_Question_Id] = 1338
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'OC:G1.Q2', [Question_Text]=N'Are event and incident handling personnel notified of upcoming changes to organizational assets?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if <b>event and incident handling personnel are notified</b> when <b>there</b> are <b>changes</b> to organizational assets.</div><div><br></div><div><ul><li>The organization should establish communication channels to ensure that event and incident handling personnel are aware of changes, maintenance, and outages to organizational assets.</li></ul></div><div><b>Typical work products</b></div><div><ul><li>examples of notification methods</li><ul><li>email message</li><li>internal webpage</li><li>text message</li><li>voice message</li></ul><li>schedule of upcoming changes</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li><b>Event and incident handling personnel are notified</b> of <b>all</b> changes to organizational assets.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>Event and incident handling personnel are notified of <b>some</b> changes to organizational assets.</li></ul></div>' WHERE [Mat_Question_Id] = 1339
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'OC:G2.Q1', [Question_Text]=N'Does the organization use a repository for recording information about vulnerabilities and their resolutions?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if a <b>repository for recording information about vulnerabilities and their resolution (if known) is used.</b></div><div><b><br></b></div><div><ul><li>A vulnerability repository should be used as <b>the central source of vulnerability lifecycle information.</b></li><li>A vulnerability repository <b>supports analysis, disposition, trending, root cause analysis, and vulnerability management.</b></li></ul></div><div><b>Typical work products:</b></div><div><ul><li>The vulnerability repository can take the form of any of the following:</li><ul><li>database</li><li>document</li><li>worksheet</li><li>list</li><li>archive</li></ul></ul></div><div><b>Information that should be recorded includes:</b></div><div><ul><li>a unique identifier</li><li>a description of the vulnerability</li><li>the date(s) of the information entered into the repository</li><li>references to the source(s) of the vulnerability</li><li>the priority of the vulnerability (high, medium, low)</li><li>categorization and disposition of the vulnerability</li><li>individuals or teams assigned to analyze and remediate the vulnerability</li><li>a log of actions taken to reduce or eliminate the vulnerability</li><li>resolution of the vulnerability</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response</i></b></div><div><ul><li>The organization <b>uses</b> a repository to <b>record all vulnerability and resolution information </b>for<b> all assets.</b></li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization uses a repository to <b>record some</b> vulnerability and resolution information.</li><li>Or; the organization uses a repository to <b>record all </b>vulnerability and resolution information for <b>some</b> assets.</li></ul></div>' WHERE [Mat_Question_Id] = 1340
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'OC:G2.Q2', [Question_Text]=N'Do event and incident handling personnel have access to an upto- date vulnerability management repository?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if the incident handling personnel have access to an up-to-date <b>vulnerability management repository.</b></div><div><b><br></b></div><div><ul><li>A vulnerability repository supports the incident handling and response team''s analysis efforts.</li><li>The information in the repository needs to be up-to-date.</li></ul></div><div><b>Typical work products:</b></div><div><ul><li>access list showing that incident handling personnel have access to the vulnerability management repository</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The vulnerability management repository is accessible to <b>all</b> appropriate incident handling personnel.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The vulnerability management repository is accessible to <b>some</b> of the appropriate incident handling personnel.</li></ul></div>' WHERE [Mat_Question_Id] = 1341
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'OC:G2.Q3', [Question_Text]=N'Are the event and incident handling personnel notified when unmitigated vulnerabilities exist, or where compensating controls may need to be monitored?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if the <b>event and incident handling personnel </b>have been notified of existing, unmitigated vulnerabilities or of compensating controls that need to be monitored.</div><div><br></div><div><ul><li>Event and incident handling personnel should be notified and aware of all known,<b> unmitigated vulnerabilities</b>, to enable them to be <b>aware</b> of potential <b>attack vectors.</b></li><li>Event and incident handling personnel should be <b>notified</b> and aware of <b>compensating controls</b> that may need <b>to be monitored.</b></li></ul></div><div><b>Typical work products:</b></div><div><ul><li>examples of notification methods of unmitigated vulnerabilities or compensating controls may include the following:</li><ul><li>email message</li><li>internal webpage</li><li>vulnerability analysis report</li><li>text message</li><li>voice message</li></ul></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>Event and incident handling personnel are notified of <b>all</b> unmitigated vulnerabilities and of <b>all</b> compensating controls that may need to be monitored.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>Event and incident handling personnel are notified of <b>some</b> unmitigated vulnerabilities.</li><li>Or, event and incident handling personnel are notified of <b>some</b> compensating controls that may need to be monitored.</li></ul></div>' WHERE [Mat_Question_Id] = 1342
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'OC:G3.Q1', [Question_Text]=N'Is the Incident Management Function properly integrated with all organizational service continuity plans?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if Incident Management Function is <b>aware of and integrated into</b> all of the organization''s <b>service continuity plans.</b></div><div><b><br></b></div><div><ul><li>The Incident Management Function should be considered during the development, maintenance, and testing of the organization''s service continuity plans.</li><li>The Incident Management Function should be specifically <b>integrated as a stakeholder</b> in the organization''s service continuity plans.</li></ul></div><div><b>Typical work products:</b></div><div><ul><li>service continuity plans</li><li>after action reviews of service continuity execution or testing</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The Incident Management Function is integrated into <b>all</b> organizational service continuity plans.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The Incident Management Function is integrated into <b>some</b> organizational service continuity plans.</li></ul></div>' WHERE [Mat_Question_Id] = 1343
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'OC:G3.Q2', [Question_Text]=N'Are the organization’s service continuity plans periodically reviewed and updated to ensure proper inclusion of the Incident Management function?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if the service continuity plans are periodically <b>reviewed and updated</b> to ensure that the <b>Incident Management Function is integrated into the plans.</b></div><div><b><br></b></div><div><ul><li>Service continuity plans should be <b>periodically reviewed and updated</b> at an interval that the organization determines to be appropriate.</li><li>The Incident Management Function should be included in the review and update of any service continuity plan, to ensure that the Incident Management Function''s perspective, input, and agreement are maintained.</li></ul></div><div><b>Typical work products:</b></div><div><ul><li>service continuity plan with a <b>recent</b> (according to any defined <b>period</b> for review) <b>date</b> or <b>change history</b></li><li>record of any <b>updates</b> to the service continuity plans that were <b>proposed by the Incident Management Function</b></li><li>service continuity review processes or instructions that include actions that are required by the Incident Management Function</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li><b>All</b> service continuity plans are periodically reviewed and updated to include the Incident Management Function.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li><b>Some</b> service continuity plans are periodically reviewed and updated to include the Incident Management Function.</li></ul></div>' WHERE [Mat_Question_Id] = 1344
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'OC:G4.Q1', [Question_Text]=N'Has the organization implemented a threat monitoring capability?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if the organization has<b> implemented</b> a threat monitoring capability.</div><div><br></div><div><ul><li><b>Effective threat monitoring requires people, procedures</b>, and <b>technology</b> that need to be deployed and managed to meet monitoring requirements.</li><li><b>Procedures ensure the timeliness, consistency, and accuracy</b> of threat information and the <b>distribution</b> of this information to relevant stakeholders.</li><li><b>Roles and responsibilities</b> have been <b>defined and assigned.</b></li></ul></div><div><b>Procedures may address:</b></div><div><ul><li>source identification</li><li>monitoring frequency</li><li>threat identification</li><li>threat validation and analysis</li><li>threat communication</li></ul></div><div><b>Typical work products:</b></div><div><ul><li>threat monitoring procedures</li><li>threat reports</li><li>list of threat intelligence sources (vendors, industry groups, others)</li><li>third-party notifications (vendors, law enforcement, etc.)</li><li>threat database</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization has <b>implemented</b> a threat monitoring capability with documented procedures, assigned roles and responsibilities, and appropriate methods and technology.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The threat monitoring capability is<b> in development.</b></li></ul></div>' WHERE [Mat_Question_Id] = 1345
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'OC:G4.Q2', [Question_Text]=N'Is relevant threat information communicated to the Incident Management Function?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if <b>threat information is communicated to</b> all identified <b>internal</b> <b>and</b> <b>external incident management personnel</b>. The intent of communicating threat information is to assist incident handling and response personnel to perform their duties.</div><div><br></div><div><ul><li>Threat information must be <b>communicated according to established procedures.</b></li><li>Communication requirements may dictate that various communications methods and channels should be considered and identified.</li></ul></div><div><b>Typical work products:</b></div><div><ul><li>threat communications to the incident handling team</li><li>threat communication standards and guidelines</li><li>standardized report templates</li><li>communication escalation protocols</li><li>list of incident management personnel and contact information</li><li>stakeholder communication requirements</li><li>documented methods and channels</li><li>tools and techniques for communication</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>Threat information is <b>communicated to all </b>identified <b>incident handling and response personnel.</b></li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>Threat information is communicated to <b>some</b> of the identified incident management personnel.</li></ul></div>' WHERE [Mat_Question_Id] = 1346
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PS:G1.Q1', [Question_Text]=N'Are the assets that directly support the Incident Management Function inventoried?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if the <b>assets that support the Incident Management Function are inventoried.</b></div><div><b><br></b></div><div><ul><li>The organization should <b>inventory the assets </b>(people, information, technology, and facilities) <b>required for the delivery of the incident management activities to the organization.</b></li><li>Inventories of assets may <b>exist in multiple forms or physical locations.</b></li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization <b>inventories all assets</b> that support the Incident Management Function.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization inventories <b>some</b> assets.</li></ul></div>' WHERE [Mat_Question_Id] = 1347
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PS:G1.Q2', [Question_Text]=N'Do Incident Management Function asset descriptions include protection and sustainment requirements?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if the Incident Management Function''s asset descriptions include protection and sustainment requirements.</div><div><br></div><div><ul><li>Protecting and sustaining the assets that support the Incident Management Function ensure that the incident handling and response activities will be delivered to the organization even in times of stress.</li><li>Including protection and sustainment requirements in asset descriptions provides a common source for communicating and updating those requirements.</li><li>The confidentiality, integrity, and availability requirements of the Incident Management Function are used to derive the collective protection and sustainment requirements of associated assets.</li><li>Activities that implement protection and sustainment requirements often appear as processes, procedures, policies, controls, and plans.</li></ul><div><br></div><ul><li><b>Protection requirements describe how an asset''s exposure to sources of disruption and to the exploitation of vulnerabilities must be minimized. Examples include:</b></li><ul><li>People - Ensure that all employees are skilled in their role to protect against accidental disruption.</li><li>Information - All information assets will be disposed of according to policy to prevent unintentional disclosure.</li><li>Technology - All network boundaries should be protected; use approved methods and tools to deny unauthorized access.</li><li>Facilities - Physical access to all Incident Management Function-related information and technology assets must be limited to approved personnel to protect against accidental and malicious disruption.</li></ul></ul><div><br></div><ul><li><b>Sustainment requirements describe how assets must be kept operating when faced with disruptive events. Examples include:</b></li><ul><li>People - All critical personnel shall have a designated backup who can fulfill their service continuity role.</li><li>Information - No more than 4 hours of the Incident Management Function data can be lost to ensure the continuity of the service.</li><li>Technology - The technology assets required for the delivery of the Incident Management Function must be operational within 48 hours to ensure the continuity of the service.</li><li>Facilities - The backup facility must meet the service continuity requirements of the Incident Management Function.</li></ul></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The protection and sustainment requirements are documented in asset descriptions for all assets supporting the Incident Management Function.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The protection and sustainment requirements are documented in asset descriptions for <b>some</b> assets.</li></ul></div>' WHERE [Mat_Question_Id] = 1348
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PS:G1.Q3', [Question_Text]=N'Are controls established to protect and sustain the Incident Management Function at a level equal to or greater than those established for the organization''s other critical assets?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if administrative, technical, and physical controls are designed and implemented for the Incident Management Function at a level equal to or greater than the organization''s other critical assets.</div><div><br></div><div>Controls that are implemented to protect and sustain the Incident Management Function should, at a minimum, meet requirements established for the organization''s other critical assets. Controls are then designed to meet those requirements and deployed to protect those assets needed to deliver the Incident Management Function activities.</div><div><br></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization has <b>implemented controls</b> to protect and sustain all the Incident Management Function''s assets at a level equal to or greater than the organization''s other critical assets.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>Controls have been implemented for <b>some</b> of the Incident Management Function''s assets.</li><li>Or; controls have been implemented <b>but are not at a level equal to or greater than</b> the controls established for the organization''s other critical assets</li></ul></div>' WHERE [Mat_Question_Id] = 1349
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PS:G1.Q4', [Question_Text]=N'Is a change management process used to manage modifications to assets (technology, information, and facilities) that directly support the Incident Management Function?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if a <b>change management</b> process is <b>used to manage modifications to assets </b>that directly support the Incident Management Function.</div><div><br></div><div><ul><li>Change management is a <b>continuous process</b> of controlling and approving changes to assets.</li><li>A process exists for determining, documenting, submitting, and authorizing changes to the infrastructure that supports incident management. This process can exist as an independent process that supports only the Incident Management Function or can be incorporated as part of the larger organizational change management processes.</li></ul></div><div><b>This process addresses:</b></div><div><ul><li>addition of new assets</li><li>changes to the asset''s configuration, ownership, custodianship, and location</li><li>elimination of assets</li></ul></div><div><b>Typical work products:</b></div><div><ul><li>change requests</li><li>update of configuration baselines</li><li>change implementation plan</li><li>backout plan</li><li>change and configuration management board meeting minutes</li><li>change approvals</li><li>change tracking and status</li><li>change documentation, including test results</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>A <b>change management process is used</b> to control changes to <b>all</b> assets that support the Incident Management Function.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>A change management process is used to control changes to <b>some</b> assets.</li></ul></div>' WHERE [Mat_Question_Id] = 1350
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PS:G1.Q5', [Question_Text]=N'Do documented procedures exist for defining tool requirements, and for acquiring, developing, deploying, and maintaining tools (e.g.5. Do documented procedures exist for defining tool requirements, and for acquiring, developing, deploying, and maintaining tools (e.g., a System Development Life Cycle)?' WHERE [Mat_Question_Id] = 1351
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PS:G1.Q6', [Question_Text]=N'Are service continuity plans developed and documented for assets required for the delivery of the Incident Management Function activities?' WHERE [Mat_Question_Id] = 1352
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PS:G1.Q7', [Question_Text]=N'Are physical protection measures established and managed for assets that directly support the Incident Management Function?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To ensure physical measures are implemented to protect the Incident Management Function''s technology, facilities, information, and people assets.</div><div><br></div><div><ul><li>The term &#8220;measures&#8221; includes the relevant policies, standards, controls, and regulations for securing the facilities and space where incident management systems and personnel reside.</li><li>These measures should comply with relevant standards, guidelines, or organizational policies.</li></ul><div><b>Typical work products include</b>:</div></div><div><ul><li>policies, standards, controls, regulations, or similar artifacts that ensure physical protection of incident management function assets</li><li>audit results indicating that the physical protection measures are being properly followed</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization has the physical protection measures in place <b>for all assets that support the incident management function.</b></li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization has the physical protection measures in place for <b>some</b> assets.</li></ul></div>' WHERE [Mat_Question_Id] = 1353
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PS:G1.Q8', [Question_Text]=N'Are Incident Management Function systems and networks monitored by the organization''s security monitoring activities?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To ensure the organization is performing security monitoring activities for the systems and networks that support the Incident Management Function.</div><div><br></div><div>Documented processes should exist that direct the security monitoring of incident management function''s systems and networks.</div><div><br></div><div><b>These processes should include</b>:</div><div><ul><li>methods for detecting events, incidents, anomalous activity, intrusion attempts, and other potential threats.</li><li>Identification of critical incident management systems, components, and assets</li></ul></div><div>Due to the sensitivity/criticality of the event and incident information, security monitoring should be performed at a level equal to or greater than the organization''s other critical systems and networks.</div><div><br></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization performs security monitoring <b>on all of the Incident Management Function''s systems and networks.</b></li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization performs security monitoring on <b>some</b> of the Incident Management Function''s systems and networks.</li></ul></div>' WHERE [Mat_Question_Id] = 1354
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PS:G1.Q9', [Question_Text]=N'Are event detection and incident response activities performed on the assets that directly support the Incident Management Function?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To ensure that event and incident detection and response activities are performed for the assets that support the Incident Management Function.</div><div><br></div><div><ul><li>Information collected by incident management personnel and stored on incident management systems and applications, such as incident tracking systems, data analytics engines, or stakeholder contact lists, can contain sensitive information.</li><li>If the incident management system is not maintained and is disrupted, it will affect the organization''s ability to respond to incidents.</li><li>It is critical that such information be sustained with the same rigor applied to other key organizational data and assets.</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>Event detection and incident response activities are performed for <b>all</b> assets that directly support the Incident Management Function.</li></ul></div><div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>Event detection and incident response activities are performed for <b>some</b> assets that directly support the Incident Management Function.</li></ul></div></div>' WHERE [Mat_Question_Id] = 1355
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PS:G1.Q10', [Question_Text]=N'Is vulnerability management performed on the assets that directly support the Incident Management Function?' WHERE [Mat_Question_Id] = 1356
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PS:G2.Q1', [Question_Text]=N'Do guidelines exist for the secure collection, handling, transmission, storage, retention, and destruction of event and incident data?', [Supplemental_Info]=N'<div><b>&#160;Question Intent: </b>To determine if <b>guidelines exist for properly handling, transmitting, storing, and disposing of event and incident information assets.</b></div><div><b><br></b></div><div><ul><li>Properly handling, transmitting, storing, and disposing of event and incident information is necessary to ensure that there are no unauthorized disclosures.</li><li>Guidelines should consider:</li><ul><li>confidentiality requirements</li><li>sensitivity categorization</li><li>applicable rules, laws, and regulations</li><li>data retention requirements</li><li>document markings policy</li></ul></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>There are <b>documented guidelines</b> for properly handling, transmitting, storing, and disposing of event and incident information.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>Guidelines are <b>under development and partially documented.</b></li></ul></div>' WHERE [Mat_Question_Id] = 1357
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PS:G2.Q2', [Question_Text]=N'Are event and incident information assets backed up and retained?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine<b> if event and incident information assets are backed up and retained.</b></div><div><b><br></b></div><div><b>Event and incident information assets should be backed up and retained to meet the protection and sustainment requirements </b>of the Incident Management Function.</div><div><br></div><div><b>The protection and sustainment requirements for the information assets that support the Incident Management Function should be used to establish</b>:</div><div><ul><li>frequency of backup and storage</li><li>retention period</li><li>acceptable backup and retention media</li><li>authorized storage locations and methods</li><li>encryption and other protection requirements for data at rest or data in transit, as applicable</li><li>accessing information backups</li><li>physical access controls of backups</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li><b>All event and incident information assets</b> that support the Incident Management Function <b>are backed up and retained.</b></li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li><b>Some</b> event and incident information assets are backed up and retained.</li></ul></div>' WHERE [Mat_Question_Id] = 1358
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PS:G2.Q3', [Question_Text]=N'Are backup, storage, and restoration procedures for event and incident information assets tested?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if <b>backup and storage procedures</b> for event and incident information assets <b>are tested.</b></div><div><b><br></b></div><div><ul><li>Backup and storage of information assets should <b>meet the protection and sustainment requirements</b> of the Incident Management Function.</li><li><b>Testing</b> of backup and storage procedures is done to <b>ensure that those requirements are being met.</b></li><li>Periodic testing of the Incident Management Function''s backup and storage procedures <b>ensures continued validity as operational conditions change.</b></li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>Backup and storage procedures are <b>tested for all event and incident information assets</b> that support the Incident Management Function.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>Backup and storage procedures are tested for <b>some</b> event and incident information assets.</li></ul></div>' WHERE [Mat_Question_Id] = 1359
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PS:G2.Q4', [Question_Text]=N'Are integrity requirements used to determine which staff members are authorized to modify event and incident information?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if <b>integrity requirements of event and incident information assets</b> are used to <b>determine which staff members are authorized to modify</b> those assets.</div><div><br></div><div><ul><li><b>Integrity requirements address qualifications to ensure the information is</b>:</li><ul><li>complete and intact</li><li>accurate and valid</li><li>authorized and official</li></ul><li>Integrity requirements are a specific form of protection requirement.</li><li>Controlling which staff members are authorized to modify information assets helps ensure the continued integrity of those assets. Role-based access is a method of defining and implementing this form of integrity re-equipment.</li><li>A fundamental way of controlling modifications to information assets is to limit access to those assets, both:</li><ul><li>electronically (by controlling access to networks, servers, application systems, and databases and files); and</li><li>physically (by limiting access to file rooms, work areas, computer rooms, and facilities)</li></ul></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The <b>integrity requirements</b> for <b>all</b> event and incident information assets are used to <b>determine which staff members</b> are authorized to modify those assets.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The integrity requirements for <b>some</b> event and incident information assets are used to determine which <b>staff members</b> are authorized to modify those assets.</li></ul></div>' WHERE [Mat_Question_Id] = 1360
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PR:G1.Q1', [Question_Text]=N'Does the organization have an incident management plan for detecting and triaging events, and for handling and responding to incidents?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if the organization has a <b>documented plan for detecting and triaging events, and handling and responding to incidents.</b></div><div><b><br></b></div><div><ul><li>The organization''s plan for managing incidents should <b>address the identification, analysis, and response</b> to an incident.</li><li>An<b> event is one or more occurrences that affect organizational assets</b>, and has the potential to disrupt operations.</li><li>An <b>incident significantly impacts</b> the organization, and r<b>equires response actions</b> to prevent or limit impact on the organization.</li><li>An <b>incident may result from an event or a series of events that requires a response</b> that is beyond standard operating procedures for managing events.</li></ul></div><div><b>The organization must plan for how it will:</b></div><div><ul><li>identify events and incidents</li><li>analyze these events and incidents, and determine an appropriate response</li><li>develop declaration criteria</li><li>respond to incidents</li><li>communicate incident information to stakeholders (including external dependencies)</li><li>staff the plan to meet plan objectives</li><li>structure the incident management staff (including roles and responsibilities)</li><li>train staff to identify, analyze, and respond to incidents</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>There is a <b>documented plan</b> for detecting and triaging events and, handling and responding to incidents.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>A plan is<b> in development and partially documented.</b></li></ul></div>' WHERE [Mat_Question_Id] = 1361
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PR:G1.Q2', [Question_Text]=N'Is the incident management plan reviewed and updated according to a pre-planned schedule?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if the<b> incident management plan is periodically reviewed and updated at an interval to be defined by the organization.</b></div><div><b><br></b></div><div><ul><li>The <b>knowledge gained through managing incidents</b> can be used by the organization to <b>improve the plan.</b></li><li>The plan review should <b>include all relevant stakeholders</b> to ensure proper coordination of requirements.</li><li>The date of the most recent review (even if no changes are necessary) should be annotated in the plan.</li><li>Details on how the plan is to be reviewed (periodicity, stakeholders, approving authority, etc.) should be documented in the plan or other governance documentation for the organization.</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization <b>periodically reviews and updates the incident management plan.&#160;</b></li></ul><span><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></span><br></div><div><ul><li>The organization <b>has reviewed and updated the plan</b>, but h<b>as not established a frequency</b> for the review.</li></ul></div>' WHERE [Mat_Question_Id] = 1362
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PR:G1.Q3', [Question_Text]=N'Have staff been assigned to the roles and responsibilities detailed in the incident management plan?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if <b>staff have been assigned to the roles and responsibilities</b> detailed in the incident management plan.</div><div><br></div><div><ul><li>The organization should <b>establish a list of skilled staff and alternates</b> to fill each role and responsibility defined in the incident management plan.</li><li>The organization should <b>assign staff</b> to each role and responsibility defined in the plan.</li><li>The organization should be careful when assigning multiple roles to a single staff member, because it can cause severe capacity issues and put delivery of the incident handling and response activities at risk.</li></ul></div><div><b>Example Work Products:</b></div><div><ul><li>Incident Management Function roster</li><li>Contact list for roles outside the Incident Management Function</li><li>Position Descriptions for each role</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li><b>Staff</b> have been <b>assigned to all defined roles and responsibilities </b>in the incident management plan.&#160;</li></ul><span><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></span><br></div><div><ul><li>Staff have been assigned to <b>some</b> defined roles and responsibilities.</li></ul></div>' WHERE [Mat_Question_Id] = 1363
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PR:G1.Q4', [Question_Text]=N'Are employees held accountable for executing the roles and responsibilities detailed in the incident management plan?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if employees are held accountable for executing the <b>roles and responsibilities</b> defined in the incident management plan.</div><div><br></div><div><ul><li>The organization should <b>define the roles and responsibilities</b> required to achieve the plan''s objectives.</li><li>Job descriptions are a means<b> to ensure that incident management staff understand </b>their <b>roles</b> and are <b>aware</b> of their <b>responsibilities</b>.</li><li>Employee reviews should include assessment of their performance of incident management roles and responsibilities.</li><li><b>Specific remediation actions should be taken when employees do not perform their roles and responsibilities properly.</b></li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>All employees are held accountable for executing their roles and responsibilities.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>Some employees are held <b>accountable</b> for executing their roles and responsibilities.</li><li>Or, employees are sometimes held accountable for executing their roles and responsibilities.</li></ul></div>' WHERE [Mat_Question_Id] = 1364
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PR:G1.Q5', [Question_Text]=N'Has senior leadership been made aware of their roles as outlined in the incident management plan?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if senior leadership understands their roles and responsibilities outlined in the incident management plan.</div><div><br></div><div><ul><li>The organization should <b>define the roles and responsibilities</b> of senior leadership in the incident management plan.</li><li>Senior leadership should formally <b>approve and endorse</b> the incident management plan.</li><li>Senior leadership should also be trained in their roles and responsibilities.</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li><b>All senior leadership </b>have <b>been made aware and understand their </b>roles in the incident management plan.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li><b>Some</b>&#160;senior leadership <b>have been made aware and understand their</b> roles in the incident management plan.</li></ul></div>' WHERE [Mat_Question_Id] = 1365
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PR:G1.Q6', [Question_Text]=N'Have all relevant elements of the organization been involved in creating the incident management plan?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine that all relevant parts of the organization are involved in creating, reviewing, and revising the incident management plan to ensure that the plan addresses all parts of the organization.</div><div><br></div><div><ul><li>Incident management plan content covers all organizational components and sub-components required for effective incident response (industrial control system managers, elections system owners, other components or sub-components of the organization needed for the response, etc.).</li><li>Organizational stakeholders support and endorse the plan.</li><li>All stakeholders should take part in:</li><ul><li>creating and endorsing the plan,</li><li>periodically reviewing the plan, and,</li><li>revising the incident management plan.</li></ul><li>As organizational changes occur, the plan is adjusted, and stakeholders are added or removed from the plan.</li><li>The plan identifies the elements of the organization and appropriate stakeholders for coordination.</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li><b>All relevant elements</b> of the organization are involved in the creation of and in revisions to the incident management plan.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li><b>Some</b> relevant elements of the organization are involved in the creation of and in revisions to the incident management plan.</li></ul></div>' WHERE [Mat_Question_Id] = 1366
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PR:G1.Q7', [Question_Text]=N'Is a documented workflow in use to ensure the continuity of incident management operations, and the tracking and sharing of data?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To ensure that the continuity of incident handling and response activities and the tracking and sharing of data occur consistently and as intended by following a documented workflow.</div><div><br></div><div>Incident handling continuity problems arise because teams must deal with many problems, large amounts of data, multiple sources of data, and changing events during long periods of time. This practice focuses on the processes and mechanisms that should be in place to ensure that incident management personnel address incidents in a consistent and uniform manner.</div><div><br></div><div><b>A documented workflow ensures that incident management personnel have a well-maintained, complete picture of incident response activity across multiple teams, shifts, and days of effort. In addition, a documented workflow should address:</b></div><div><ul><li>documentation of information related to an incident throughout the incident''s lifecycle (this includes analysis, response, and follow-up activities)</li><li>the availability of information to the team</li><li>the transition of incidents from one staff member to another</li><li>the display of the status of each incident</li><li>the providing of storage and correlation of incident and vulnerability data and related artifacts</li><li>access by all relevant members of the team to information about any incident or vulnerability being handled</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization has a <b>documented workflow for all </b>of its incident management operations.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>A workflow<b> is in development and partially documented.</b></li></ul></div>' WHERE [Mat_Question_Id] = 1367
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PR:G2.Q1', [Question_Text]=N'Has a documented communication plan for incident management activities been established?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine that a communication plan has been established and documented for use during incident management activities to assist with quick and effective response.</div><div><br></div><div>The communication plan for incident management activities may be incorporated into the organization''s larger communication plan, and should be readily available to the incident handling and response personnel and appropriate stakeholders.</div><div><br></div><div><b>The incident management communication plan should include</b>:</div><div><ul><li>the individuals, groups, and designated POCs to be contacted (both internal and external)</li><li>criteria for contacting and communicating with stakeholders</li><li>the process and mechanism for contacting each POC, including required secure mechanisms</li><li>the timeframe(s) for contacting (possibly guided by contracts, SLAs, or other regulatory guidance)</li><li>information that specifically should NOT be communicated externally</li><li>the approving authorities for external communication messages, where applicable</li><li>guidance that describes the handling of media questions and calls related to incidents and vulnerabilities</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization has a <b>documented communication plan</b> for incident management activities.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The communication plan is in development and partially documented.</li></ul></div>' WHERE [Mat_Question_Id] = 1368
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PR:G2.Q2', [Question_Text]=N'Has the incident management communication plan been disseminated to internal and external stakeholders?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine that the communication plan for incident management activities has been disseminated to internal and external stakeholders for situational awareness.</div><div><br></div><div><b>Typical work products</b>:</div><div><ul><li>a list of stakeholders for dissemination</li><li>record of recent distribution</li><li>a record of receipt by stakeholders</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization has <b>disseminated</b> its incident management communications plan to <b>all</b> internal and external stakeholders.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization has disseminated its incident management communications plan to <b>some</b> internal and external stakeholders.</li></ul></div>' WHERE [Mat_Question_Id] = 1369
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PR:G3.Q1', [Question_Text]=N'Are there documented information exchange interfaces in use with all internal and external stakeholders?' WHERE [Mat_Question_Id] = 1370
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PR:G3.Q2', [Question_Text]=N'For each information exchange interface, are the roles and responsibilities documented for all parties (internal to the organization, and external stakeholders)?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if the individual roles and responsibilities for all parties are defined and documented for each information exchange interface.</div><div><br></div><div><ul><li>The intent of this capability is to ensure that activities of the incident handling and response personnel and all internal and external stakeholders are described and understood by all participants, and that the roles and responsibilities are defined to accomplish those activities.</li><li>The interface documentation should include the process and POCs for resolving conflicts or issues.</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization has documented the roles and responsibilities for all internal and external stakeholders for each information exchange interface.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization has documented some of the roles and responsibilities for the internal and external stakeholders for each information exchange interface.</li><li>Or, the organization has documented the roles and responsibilities for some information exchanges interfaces.</li></ul></div>' WHERE [Mat_Question_Id] = 1371
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PR:G4.Q1', [Question_Text]=N'Are dependencies on external relatio+nships that are critical to the Incident Management Function identified?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if external dependencies that are critical to the Incident Management Function are identified and documented.</div><div><br></div><div><b>An external dependency exists when an external entity (contractor, customer, service provider, etc.) has</b>:</div><div><ul><li>access to</li><li>control of</li><li>ownership in</li><li>possession of</li><li>responsibility for</li><li>or, other defined obligations related to the organization''s incident management capability and its associated assets.</li></ul></div><div><b>Examples of services provided to the Incident Management Function from external entities can include:</b></div><div><ul><li>outsourced activities that support the operation or maintenance of the Incident Management Function''s assets</li><li>security operations, IT service delivery and operations management, or services that directly affect incident handling and response activities</li><li>backup and recovery of data, provision of backup facilities for operations and processing, and provision of support technology, or similar services</li><li>infrastructure, such as power and dark fiber</li><li>telecommunications (telephony and data)</li><li>public services, such as fire and police support, emergency medical services, and emergency management services</li><li>technology and information assets, such as application software and databases</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization has documented all external dependencies that are critical to the operation of the Incident Management Function.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization has documented some of the external dependencies.</li></ul></div>' WHERE [Mat_Question_Id] = 1372
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PR:G4.Q2', [Question_Text]=N'Are formal agreements, plans, and processes in place for coordinating service delivery between the Incident Management Function and its external dependencies?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if the formal agreements are in place for coordinating service between the Incident Management Function and its external dependencies.</div><div><br></div><div>Types of agreements may include:</div><div><ul><li>contracts</li><li>service level agreements</li><li>memoranda of agreement</li><li>purchase orders</li><li>licensing agreements</li></ul></div><div>The agreement should:</div><div><ul><li>be enforceable by the organization</li><li><span>coordinate service delivery</span></li><li>include detailed and complete requirements that the external entity must meet</li><li>include required performance standards and/or work products</li><li>be updated to reflect changes in requirements over the life of the relationship</li></ul></div><div><b>Example requirements can include:</b></div><div><ul><li>performance standards</li><li>communication standards for status information and reporting information</li><li>security, confidentiality, and privacy requirements</li><li>disclosure obligations for security breaches</li><li>business resumption and contingency plans</li><li>staff performance or prescreening</li><li>controls</li><li>regulatory, legal, and compliance obligations</li></ul></div><div><b>Typical work products include:</b></div><div><ul><li>agreements with external entities</li><li>service level agreements</li><li>requirements traceability matrix</li><li>requirements specification</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>Formal agreements are in place for <b>all</b> external dependencies to coordinate services with the Incident Management Function.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>Formal agreements are in place with <b>some</b> external dependencies.</li></ul></div>' WHERE [Mat_Question_Id] = 1373
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PR:G4.Q3', [Question_Text]=N'Do the formal agreements between the Incident Management Function and its external dependencies require external dependencies to meet the security standards of the organization?', [Supplemental_Info]=N'<div><b>Question Intent: </b>To determine if the requirement to meet the <b>organization''s security standards is included in formal agreements</b> with the external entities that support the Incident Management Function.</div><div><br></div><div>Formal agreements will form the <b>basis for monitoring the performance</b> of the external entity.<b> Including the organization''s security standards </b>in the formal agreements ensures that the external dependencies understand that they are expected to meet those standards.</div><div><br></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization requires that <b>all</b> formal agreements between the Incident Management Function and its external dependencies mandate that those dependencies must meet the organization''s security standards.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li><b>Some</b> formal agreements between the Incident Management Function and its external dependencies mandate that those dependencies must meet the organization''s security standards.</li></ul></div>' WHERE [Mat_Question_Id] = 1374
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PR:G4.Q4', [Question_Text]=N'Has responsibility been assigned for monitoring the performance of external dependencies that support the Incident Management Function?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if <b>responsibility</b> for monitoring the performance of external entities that support the Incident Management Function is <b>assigned</b> to ensure that monitoring is performed on a timely and consistent basis.</div><div><br></div><div><b>Some key characteristics are:</b></div><div><ul><li>The organization should<b> assign responsibility</b> for monitoring each <b>external entity.</b></li><li>Responsibility is typically <b>assigned</b> to the <b>owner of the relationship</b> with the external entity.</li><li>The responsible staff should <b>establish procedures</b> that determine the <b>frequency, protocol, and responsibility for monitoring</b> a particular external entity.</li><li>These procedures should be <b>consistent with the terms of the agreement </b>in place with the external entity.</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The <b>responsibility for monitoring</b> the performance of <b>each</b> external entity that supports the Incident Management Function has been assigned.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The <b>responsibility for monitoring</b> the performance of <b>some</b> external entities has been assigned.</li></ul></div>' WHERE [Mat_Question_Id] = 1375
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PR:G5.Q1', [Question_Text]=N'Do Knowledge, Skill, and Ability (KSA) requirements exist for incident handling and response roles?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if the <b>Knowledge, Skill, and Ability requirements</b> necessary to fulfill specific roles that support the Incident Management Function <b>have been identified.</b></div><div><b><br></b></div><div><b>Baseline competencies represent the staffing and skill set needs</b>, not necessarily the organization''s current staff and skills.</div><div><br></div><div><b>Sources of baseline competencies may include:</b></div><div><ul><li>role and associated tasks (security administrator, network administrator, CIO, etc.)</li><li>position (CIO, senior security analyst, network engineer, etc.)</li><li>organizational processes such as vulnerability management, incident management, service continuity management, etc.</li><li>skills (Java programming, Oracle DBA, etc.)</li><li>certifications (CISSP, MCSE, etc.)</li><li>aptitudes and job requirements (able to work long hours, travel, or be on call)</li></ul></div><div><b>&#8220;Knowledge&#8221; </b>is a body of information applied directly to the performance of a function, such as incident handling and response.</div><div><br></div><div><b>&#8220;Skill&#8221;</b> is an observable competence to perform a function using various tools, frameworks, and processes. For each role, identify the technologies or systems that the organization uses to perform the tasks assigned to that role.</div><div><br></div><div><b>&#8220;Ability&#8221;</b> is the proficiency to perform an observable behavior or a behavior that results in an observable product. For example, some roles may require abilities to effectively communicate or analyze a problem; other roles, to develop technical documentation; and managers, to organize work or tasks and lead others effectively.</div><div><br></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization <b>documents Knowledge, Skill, and Ability requirements</b> for <b>all</b> of the Incident Management Function roles that personnel and appropriate external dependencies will be assigned.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization <b>documents Knowledge, Skill, and Ability requirements</b> for <b>some</b> roles,</li><li>Or, the Knowledge, Skill, and Ability requirements are in development and partially documented.</li></ul></div>' WHERE [Mat_Question_Id] = 1376
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PR:G5.Q2', [Question_Text]=N'Have training needs for incident handling and response personnel been established?' WHERE [Mat_Question_Id] = 1377
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'PR:G5.Q3', [Question_Text]=N'Are training activities for the Incident Management Function conducted to meet the identified KSA requirements?', [Supplemental_Info]=N'<div><b>Question Intent:</b> To determine if <b>cybersecurity training activities</b> for the Incident Management Function <b>are conducted</b> to address the training needs of the incident handling and response personnel and thereby meet the identified Knowledge, Skill, and Ability requirements.</div><div><br></div><div><ul><li>The organization must perform training to <b>ensure that staff is appropriately skilled</b> in their roles.</li><li>Training should be <b>planned and scheduled.</b></li><li>Training should be conducted by experienced instructors and in settings that closely resemble the actual performance conditions.</li><li>Training provided should address identified KSA gaps and associated training needs of the incident handling and response personnel (established in Prepare Response, Goal 5 Question 2) including:</li><ul><li>training in the use of <b>specialized tools</b></li><li>training in <b>procedures</b> that are new to the individuals who will perform them</li></ul></ul></div><div><b>Typical work products include:</b></div><div><ul><li>delivered training courses</li><li>training schedule</li></ul></div><div><b><i>Criteria for &#8220;Yes&#8221; Response:</i></b></div><div><ul><li>The organization has <b>conducted training activities</b> for <b>all incident handling and response personnel </b>to meet the identified KSA requirements.</li></ul></div><div><b><i>Criteria for &#8220;Incomplete&#8221; Response:</i></b></div><div><ul><li>The organization has conducted training activities for <b>some of the incident handling and response personnel</b> to meet the identified KSA requirements.</li></ul></div>' WHERE [Mat_Question_Id] = 1378
PRINT(N'Operation applied to 88 rows out of 88')

PRINT(N'Update rows in [dbo].[MATURITY_GROUPINGS]')
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Title]=N'1 Event Detection and Handling (EH)' WHERE [Grouping_Id] = 206
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Title]=N'2 Incident Declaration, Handling, and Response (IR)' WHERE [Grouping_Id] = 210
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Title]=N'3 Post-Incident Analysis and Testing (PI)' WHERE [Grouping_Id] = 215
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Title]=N'4 Integrate Organizational Capabilities (OC)' WHERE [Grouping_Id] = 218
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Title]=N'5 Protect and Sustain the Incident Management Function (PS)' WHERE [Grouping_Id] = 223
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Title]=N'6 Prepare for Incident Response (PR)' WHERE [Grouping_Id] = 226
PRINT(N'Operation applied to 6 rows out of 6')

PRINT(N'Update rows in [dbo].[DIAGRAM_TEMPLATES]')
UPDATE [dbo].[DIAGRAM_TEMPLATES] SET [Diagram_Markup]=N'<mxGraphModel dx="1799" dy="1066" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" value="Main Layer" parent="0"/>
    <UserObject SAL="Low" label="Corporate-Low" internalLabel="Corporate" ZoneType="Corporate" zone="1" Criticality="Low" id="2">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#fdf9d9;swimlaneFillColor=#fffef4;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="41" y="72" width="315" height="522" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="External Firewall" ComponentGuid="b94b6a0b-ebe5-4bf0-a2ff-7db569e2df13" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="5">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="119" y="31.1" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Public Historian" ComponentGuid="16b71bf0-01aa-4c69-9d30-4a719bf562a1" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="6">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/historian.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="207" y="408" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp IDS" ComponentGuid="1af3ffe6-b3b7-46a9-92dc-06ca8f6253ef" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="7">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="207" y="149.5" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-1" ComponentGuid="9d5fdc14-e6e9-487c-b74a-e46b8e4f3925" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" internalLabel="CON-1" id="8">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="137.5" y="148" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp Router" ComponentGuid="a9073944-6f56-4ac1-85d0-56c846f6d9ec" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="9">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="119" y="215.5" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp Switch" ComponentGuid="4a45079c-c584-481d-99e9-49ac131e1e46" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="10">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="119" y="313" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Remote Access Server" ComponentGuid="6dfaa6bf-0f0d-4f90-ac5e-0f1afcff0b0c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="11">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/remote_access_server.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="40" y="408" width="34" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="27" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="8" target="5" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="28" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="8" target="7" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="39" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="8" target="9" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="40" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="9" target="10" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="41" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="10" target="6" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="42" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="10" target="11" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="High" label="Distributed Control System (DCS)-High" internalLabel="Distributed Control System (DCS)" ZoneType="Control System" zone="1" Criticality="Low" id="3">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#d3eef2;swimlaneFillColor=#f2f8f9;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="384" y="73" width="715" height="518" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="DCS Firewall" ComponentGuid="a5f33082-fad1-4860-8bd3-95ec9002173f" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="12">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="39" y="203.5" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Operator Workstation" ComponentGuid="ae6ccc4e-0b5d-47f3-b972-119e1e45d592" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="13">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="289" y="123" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Server A" ComponentGuid="06cc100e-04b0-4831-aa04-118d5426a681" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="14">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="289" y="312" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Server B" ComponentGuid="cf9f4b51-7010-4919-88ed-4b8ce8e0eea3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="15">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="441" y="312" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Internal Historian" ComponentGuid="9b177786-353f-4bba-a22f-e60c09d61020" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="16">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/historian.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="153" y="312" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="DCS 1" ComponentGuid="fe23455c-dcf0-4f37-90f1-8dea37956702" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="17">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/dcs.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="601" y="123" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="DCS 2" ComponentGuid="171ed4e7-d296-4c1b-9d50-8e82d4f09656" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="18">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/dcs.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="601" y="216.5" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="DCS 3" ComponentGuid="0b7ce43a-45bd-4e30-bf89-052ec4c76787" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="19">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/dcs.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="601" y="312" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="DCS IDS" ComponentGuid="46f17cc1-d63c-4865-a675-22d32229c6cd" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="20">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="156" y="123" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-2" ComponentGuid="477d3077-6648-4bf8-a647-c35e7550ab03" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" internalLabel="CON-2" id="21">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="177" y="219" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Op Switch" ComponentGuid="55547555-3658-4f9d-b53b-e88170f8a14d" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="22">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="289" y="216.5" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="DCS Router" ComponentGuid="fdbec6d5-9c9c-4eb9-9730-8340b8f528c7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="23">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="441" y="216.5" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="24" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" target="20" edge="1" source="21">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="183" y="216" as="sourcePoint"/>
      </mxGeometry>
    </mxCell>
    <mxCell id="25" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="21" target="22" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="31" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="22" target="16" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="32" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="22" target="15" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="33" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="22" target="14" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="34" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="22" target="13" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="35" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="22" target="23" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="36" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="23" target="17" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="37" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="23" target="18" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="38" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="23" target="19" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="30" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="12" edge="1" target="21">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="177" y="227" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <UserObject label="Web" ComponentGuid="a1e43fc3-8cd8-4fc7-9ef1-7e5f4301124a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Web" id="4">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/web.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="-39.879999999999995" y="98.60000000000002" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="26" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="4" target="5" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="29" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="9" target="12" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
  </root>
</mxGraphModel>' WHERE [Id] = 1
UPDATE [dbo].[DIAGRAM_TEMPLATES] SET [Diagram_Markup]=N'<mxGraphModel dx="1154" dy="562" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" value="Main Layer" parent="0"/>
    <UserObject SAL="Moderate" label="Process Control System (PCS)-Moderate" internalLabel="Process Control System (PCS)" ZoneType="Control System" zone="1" Criticality="Low" id="2">
      <mxCell style="swimlane;zone=1;fillColor=#d3eef2;swimlaneFillColor=#f2f8f9;labelBackgroundColor=none;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="400" y="60" width="380" height="505" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PCS Firewall" ComponentGuid="13e8e978-742c-4a50-b85c-9e5ffd0e0e75" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="5">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="28" y="205.5" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Operator Workstation" ComponentGuid="484d793b-24f9-4a9e-80cc-68a03f2e6951" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="6">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="192" y="123.5" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Server A" ComponentGuid="e94d57f4-511a-40fa-8904-3ef54e956473" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="7">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="295" y="107.5" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Server B" ComponentGuid="2e553950-2235-4b74-b532-5acd1ab9752a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="8">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="295" y="201.5" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Historian" ComponentGuid="602fd3e9-14e3-4383-8079-2a15f0e36807" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="9">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/historian.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="295" y="312" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Gateway PLC" ComponentGuid="a361a557-4abe-4fbc-9dcf-3b806754dfc4" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="10">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="192" y="312" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC 1" ComponentGuid="b996e486-b60e-436e-92bd-95fe1b296e49" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="11">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="105" y="407" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC 2" ComponentGuid="fc264b3b-dc31-4405-8d42-0b69fe4d89d0" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="12">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="192" y="407" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC 3" ComponentGuid="1a7b998a-9c79-4904-b227-ff8a0bfe8b95" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="13">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="295" y="407" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PCS IDS" ComponentGuid="65197a08-7158-4363-b5d7-6f98785d3dcc" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="14">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="108" y="123.5" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-1" ComponentGuid="fdaf738e-a7c0-407f-b65b-6a2804fed772" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" internalLabel="CON-1" id="15">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="129" y="221.5" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PCS Switch" ComponentGuid="702476c4-5fa3-4bed-b958-70e5b7388760" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="16">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="192" y="219.5" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="24" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="10" target="11" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="25" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="10" target="12" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="26" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="10" target="13" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="30" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="15" target="16" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="31" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="15" target="14" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="32" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="10" target="16" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="33" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="16" target="6" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="35" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="16" target="7" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="36" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="16" target="8" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="37" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="16" target="9" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="39" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="15" target="5" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="Low" label="Corporate-Low" internalLabel="Corporate" ZoneType="Corporate" zone="1" Criticality="Low" id="3">
      <mxCell style="swimlane;zone=1;fillColor=#fdf9d9;swimlaneFillColor=#fffef4;labelBackgroundColor=none;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="70" y="60" width="310" height="505" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="External Firewall" ComponentGuid="17b2b636-b223-4899-9c41-161d136cfd7d" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="17">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="110.5" y="31" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Public Historian" ComponentGuid="b1aab421-6d53-49c5-99ec-4046e2187e96" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="18">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/historian.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="201" y="407" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-2" ComponentGuid="fd8f3128-9a9f-4810-9cbf-99d612ffea07" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" internalLabel="CON-2" id="19">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;rotation=4;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="131.5" y="135.5" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corporate IDS" ComponentGuid="d3fd41f5-90dc-4360-a86f-4a47fb58e800" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="20">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="202" y="136.5" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp Router" ComponentGuid="8051bdc8-a3c6-40ba-a4c0-00badb0882f3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="21">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="112.5" y="216.5" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp Switch" ComponentGuid="1700506f-e830-4cff-91c9-ab79fb565189" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="22">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="112.5" y="312" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Remote Access Server" ComponentGuid="84c931ee-e894-4cde-9ae5-bd910fc94eab" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="23">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/remote_access_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="41" y="391" width="34" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="27" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="20" target="19" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="28" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="21" target="19" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="34" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="17" target="19" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="40" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="21" target="22" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="41" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="22" target="18" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="42" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="22" target="23" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject label="Web" ComponentGuid="671b6f00-741c-43b7-8eb5-b4d9e1bbe62a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Web" id="4">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/web.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="-18" y="86" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="29" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="4" target="17" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="38" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="21" target="5" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
  </root>
</mxGraphModel>' WHERE [Id] = 2
UPDATE [dbo].[DIAGRAM_TEMPLATES] SET [Diagram_Markup]=N'<mxGraphModel dx="1508" dy="1124" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" value="Main Layer" parent="0"/>
    <UserObject SAL="Moderate" label="Dispatcher Training Simulator-Moderate" internalLabel="Dispatcher Training Simulator" ZoneType="Other" zone="1" Criticality="Low" id="2">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#ece4d7;swimlaneFillColor=#f6f3ed;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="1438" y="887" width="395" height="240" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Switch" ComponentGuid="f948f3ca-843e-48c7-8fd9-5e61965b404e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="7">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="204.2878" y="53.16669" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Firewall" ComponentGuid="5e359c31-ec1c-4118-bec4-f0c9362da3aa" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="8">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="111.9545" y="40.16669" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Workstation 1" ComponentGuid="72b07b47-a5fd-4da5-b221-a6b8a413b669" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="9">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="111.9545" y="130.4166" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Workstation 2" ComponentGuid="616918fb-e27f-40a3-99a3-efffa3b694af" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="10">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="293.5973" y="130.4166" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Printer" ComponentGuid="f50a6813-0a57-4525-a43d-da50113ca69f" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="11">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/network_printer.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="293.5973" y="38.16669" width="60" height="54" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="DTS Server" ComponentGuid="1083056b-07bd-462c-a5cf-0357ea639d97" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="12">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="204.2878" y="130.4166" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IDS" ComponentGuid="9a8dd141-9de9-41f5-a1e3-a01e5e301459" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="13">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="31.9425" y="130.4166" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_373" ComponentGuid="4da8505f-9c87-44ca-88e9-1bf3e7e519ca" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="14">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="51.9425" y="55.16670000000004" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="114" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="7" target="12" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="115" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="7" target="11" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="116" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="7" target="10" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="117" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="7" target="9" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="137" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="8" target="14" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="160" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="14" target="13" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="161" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="8" target="7" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="Low" label="Corporate-Low" internalLabel="Corporate" ZoneType="Corporate" zone="1" Criticality="Low" id="3">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#fdf9d9;swimlaneFillColor=#fffef4;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="1440" y="353" width="395" height="385" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corporate Firewall" ComponentGuid="38cbf20a-5611-45e5-b545-615d51e79d14" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="15">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="293.5973" y="63.950010000000006" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_37a" ComponentGuid="688ca0c1-87ae-4547-aa96-5a654642bcc3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="16">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="228.2878" y="77.95001" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp. IDS" ComponentGuid="ba878977-53fe-4648-8cb3-3e0b5cad9bcf" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="17">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="209.2878" y="172" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp. Router" ComponentGuid="ee52e20c-3e6e-41c0-b55d-997d8e53779c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="18">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="27.942500000000088" y="74.95001" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp. Switch" ComponentGuid="cd711264-f789-4f9c-8b8c-ac07392a7098" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="19">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="27.942500000000088" y="172" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Remote Access &#xa;Server" ComponentGuid="11bd3c79-1aa5-41de-a97f-1c7ef7812427" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="20">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/remote_access_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="40.942500000000386" y="269.7338" width="34" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Public Historian" ComponentGuid="9146e235-f4f1-4441-bfbf-69b3c1b076b5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="21">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/historian.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="111.9545" y="155" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="139" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="18" target="16" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="140" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="17" target="16" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="141" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="16" target="15" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="143" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="18" target="19" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="144" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="19" target="21" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="145" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="19" target="20" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="High" label="SCADA-High" internalLabel="SCADA" ZoneType="Control System" zone="1" Criticality="Low" id="4">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#d3eef2;swimlaneFillColor=#f2f8f9;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="493" y="349.5" width="922" height="781" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Firewall" ComponentGuid="6dcc8254-962a-4ad8-8671-d7808d98b730" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="34">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="656.6077" y="63.950010000000006" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="SCADA Firewall" ComponentGuid="ea35fba6-e474-4441-8ec1-49eaa3cde66d" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="35">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="35.59106" y="161" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Scada Server A" ComponentGuid="64db3209-02d3-4e0e-b8e1-aa9c54ae325f" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="36">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="47.59106" y="665.4166" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Scada Server B" ComponentGuid="88e4b3eb-925e-4ded-8147-93ac6f5c6d90" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="37">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="133.8911" y="665.4166" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Data Server A" ComponentGuid="cb3ea495-87c0-469c-a984-7149f2b80ac7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="38">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/database_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="223.0911" y="665.4166" width="43" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Operator &#xa;Workstation" ComponentGuid="1f691340-7173-460d-9b50-08a423528103" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="39">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="660.6077" y="665.4166" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Front-end Switch(s)" ComponentGuid="5b478038-5832-4347-84e4-0e4eb4867a99" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="40">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="210.0911" y="175" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="SCADA IDS" ComponentGuid="02f1a20a-67a9-489c-a5eb-3d3f71848cf3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="41">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="125.8911" y="74.95001" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Router" ComponentGuid="63bff69c-4610-4dcf-a8ff-9cfc951664a4" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="42">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="656.6077" y="269.7338" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_126" ComponentGuid="acb01643-8635-43fd-baa9-056383a7c1bf" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="43">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="145.8911" y="176" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_177" ComponentGuid="368674cb-9f74-4160-bd8f-3615917f5d51" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="44">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="676.6077" y="196" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IDS" ComponentGuid="29426331-e5a4-4e45-ba74-27206a6fcb5e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="45">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="743.7577" y="196" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Data Server B" ComponentGuid="bb2cf32b-667f-41ea-8276-c36a1f324914" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="46">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/database_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="309.2578" y="665.4166" width="43" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Power Analysis &#xa;Software Server A" ComponentGuid="a58b366a-4b46-4597-9c87-32d0d550d989" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="47">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="396.0911" y="665.4166" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Power Analysis  &#xa;Software Server B" ComponentGuid="fcdeb63e-91d4-4af0-a03c-c2286d2f1efe" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="48">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="493.0911" y="665.4166" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Front-End &#xa;Server A" ComponentGuid="9e0956b2-9ddf-4624-a167-66201e94a907" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="49">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="134.8911" y="269.7338" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Switch 2" ComponentGuid="36fb8b7e-0a0e-416e-b4ac-e1e48957106a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="50">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="573.3911" y="395" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="RTU 1" ComponentGuid="49e094da-6a77-4770-b35b-72249a707500" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="51">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="485.0911" y="74.95001" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="RTU 2" ComponentGuid="fabc1648-ac95-4a95-8787-310165ba0d74" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="52">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="387.0911" y="74.95001" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="RTU 3" ComponentGuid="3f6b6dc6-ffa1-46aa-810d-0815128968ac" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="53">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="300.2578" y="74.95001" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Maintenance &#xa;Workstation" ComponentGuid="060ec4a5-cf54-4c6b-a3aa-fae80d1ca910" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="54">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="573.3911" y="665.4166" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Controller" ComponentGuid="d5da299f-7cc5-4cfb-a912-caa9abab118d" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="55">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="748.7577" y="665.4166" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Front-End &#xa;Server B" ComponentGuid="4bb396a2-ee8c-4734-ba53-ba5e928bad4e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="56">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="308.2578" y="269.7338" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_287" ComponentGuid="2c1d1947-c57d-465d-ad86-c746e9f355e4" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="57">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="505.0911" y="176" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_288" ComponentGuid="834b7a7a-dff2-4294-aa23-d610828336b7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="58">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="145.8911" y="398" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_289" ComponentGuid="c4c975e5-1d2e-4979-9867-1de1c79a6802" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="59">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="320.2578" y="398" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_295" ComponentGuid="ef1a6e1b-6b6d-4bbd-a136-dfaffb1064e1" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="60">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="408.0911" y="176" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_296" ComponentGuid="41d590f2-787b-44b3-9be1-d5fabc25c541" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="61">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="320.2578" y="176" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="GPS Clock" ComponentGuid="a71c8f68-9da2-4034-9fe3-2ab700023031" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="62">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/clock.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="125.8911" y="472" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_2a4" ComponentGuid="83e579b6-f535-42f5-9cda-ea87c5329d57" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="63">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="408.0911" y="398" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Workstation 1" ComponentGuid="4e5e5f34-a417-4636-b95a-2330330fc3ab" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="64">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="301.2578" y="472" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Workstation 2" ComponentGuid="2d7a7c46-0c4a-46b0-8cb2-f3a3f8a60d73" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="65">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="389.0911" y="472" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Workstation 3" ComponentGuid="e6b30949-21fc-475b-a32e-9aca6d260779" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="66">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="486.0911" y="472" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_2b3" ComponentGuid="1c912b7e-b887-4b0e-a7ad-9907737c4f70" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="67">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="505.0911" y="398" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Network Printer" ComponentGuid="c42b23c6-f75a-4830-82f1-53537a67ed87" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="68">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/network_printer.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="388.0911" y="269.7338" width="60" height="54" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Switch 1" ComponentGuid="f446fa9d-d4d1-4676-bcbe-a04a1652eb5a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="69">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="743.7577" y="269.7338" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_309" ComponentGuid="09b27c03-58b7-4b8b-9737-87aed576d22b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="70">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="763.7577" y="398" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_30a" ComponentGuid="09a74c26-84ca-4826-9b3f-f08457c07e4a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="71">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="764.7577" y="496" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Web Server A" ComponentGuid="96605710-6112-4473-8c4d-d60ab34d3b49" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="72">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/web_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="846.0911" y="377" width="45" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Web Server B" ComponentGuid="fa71c805-4927-41c9-9598-7bd787eb7f01" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="73">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/web_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="831.7577" y="475" width="45" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Network Isolator" ComponentGuid="ffc69faa-0c03-4ddb-8fa1-47dbe72cd429" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="74">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="656.6077" y="383" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_329" ComponentGuid="79401379-96ff-49ee-9597-2bd0ad0fc7e1" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="75">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="767.7577" y="593.1667" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_330" ComponentGuid="49a58f24-3229-4faa-84d8-43939ff92a94" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="76">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="680.6077" y="593.1667" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_353" ComponentGuid="0a418a54-abce-4338-884d-be00d192068b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="77">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="593.3911" y="593.1667" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_354" ComponentGuid="60e9b947-e800-411f-b01f-2b0534cbd5d7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="78">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="505.0911" y="593.1667" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_355" ComponentGuid="d306e4b9-9203-4c31-8ff3-b6fe0a686237" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="79">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="408.0911" y="593.1667" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_356" ComponentGuid="f8750752-bb46-4d58-b505-8a4e1163dcc4" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="80">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="320.2578" y="593.1667" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_357" ComponentGuid="498973f1-2160-46a6-b6d8-7d1443193e4f" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="81">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="234.0911" y="593.1667" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_358" ComponentGuid="966dd742-9b59-4f02-84ea-f927b65251ad" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="82">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="145.8911" y="593.1667" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_359" ComponentGuid="3cfc33b0-75a6-4350-aaf6-b1aaf7d07f8b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="83">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="59.59106" y="593.1667" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="84" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="35" target="43" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="85" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="41" target="43" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="86" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="44" target="34" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="87" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="44" target="45" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="88" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="42" target="44" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="89" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="43" target="40" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="90" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="43" target="49" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="91" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="61" target="56" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="92" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="56" target="59" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="93" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="49" target="58" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="94" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="51" target="57" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="95" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="57" target="60" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="96" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="60" target="52" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="97" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="60" target="61" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="98" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="61" target="53" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="99" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="58" target="59" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="100" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="58" target="62" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="101" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="59" target="63" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="102" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="59" target="64" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="103" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="63" target="65" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="104" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="63" target="67" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="105" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="67" target="66" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="106" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="63" target="68" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="107" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="67" target="50" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="108" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="69" target="70" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="109" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="70" target="71" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="110" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="72" target="70" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="111" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="73" target="71" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="112" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="70" target="74" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="113" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="74" target="50" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="118" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="77" target="50" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="119" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="75" target="55" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="120" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="75" target="76" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="121" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="76" target="39" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="122" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="42" target="69" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="123" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="76" target="77" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="124" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="77" target="54" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="125" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="77" target="78" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="126" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="78" target="48" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="127" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="78" target="79" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="128" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="79" target="47" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="129" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="79" target="80" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="130" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="80" target="46" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="131" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="80" target="81" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="132" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="81" target="38" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="133" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="82" target="81" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="134" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="82" target="37" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="135" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="82" target="83" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="136" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="83" target="36" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="146" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="61" target="40" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="Moderate" label="Substation-Moderate" internalLabel="Substation" ZoneType="Plant System" zone="1" Criticality="Low" id="5">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#e6dbee;swimlaneFillColor=#f2edf6;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="48" y="386" width="412" height="563" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Substation Router" ComponentGuid="48d81e77-3b61-47d5-baa7-2af181c9daa2" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="22">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="310.0911" y="137" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch(s)" ComponentGuid="8d6962bd-9b98-4181-b4eb-8513b3e60994" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="23">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="130.5911" y="137" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Local HMI" ComponentGuid="ed16722a-4345-4c1d-b314-994478d82309" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="24">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="130.5911" y="39.95001" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Network Ring" ComponentGuid="a3c3ec98-bfed-4465-a25e-bc01763b1d19" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="25">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/optical_ring.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="130.5911" y="215.7338" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch 1" ComponentGuid="a6f6d36f-a252-4297-a2c5-4a5c5a6cccbc" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="26">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="310.0911" y="234.7338" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch 2" ComponentGuid="12fde920-e0ed-453a-ada0-d30b776e8366" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="27">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="230.0911" y="339" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch 3" ComponentGuid="1e94bc81-adab-4140-b829-7b12e6ce7f1f" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="28">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="130.5911" y="339" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch 4" ComponentGuid="2056be74-c216-44c1-9245-01cac4a71fc3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="29">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="36.09106" y="234.7338" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IED 1" ComponentGuid="51bf30b2-7c49-4d57-9411-9850c02f66eb" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="30">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ied.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="310.0911" y="437" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IED 2" ComponentGuid="0ecb7468-c0d9-4815-a6a5-781d7a66ee43" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="31">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ied.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="230.0911" y="437" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IED 3" ComponentGuid="e7701df9-9a80-4d41-859b-ccb3a0b596fd" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="32">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ied.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="130.5911" y="437" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IED 4" ComponentGuid="f407094a-2f3e-4784-98c0-8a527f156005" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="33">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ied.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="36.09106" y="437" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="148" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="22" target="23" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="149" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="23" target="24" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="150" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="23" target="25" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="151" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="25" target="26" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="152" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="25" target="27" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="153" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="25" target="28" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="154" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="25" target="29" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="155" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="26" target="30" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="156" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="27" target="31" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="157" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="28" target="32" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="158" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="29" target="33" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject label="Web" ComponentGuid="4bd7ec73-cb26-4f8c-bf82-b5d1d4138d6c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Web" id="6">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/web.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="1718.5973275221952" y="256.70628571428574" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="138" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="34" target="18" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="142" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;entryX=0.5;entryY=1;entryDx=0;entryDy=0;" parent="1" source="15" target="6" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="1850" y="310" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <mxCell id="147" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="35" target="22" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="159" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="75" target="14" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
  </root>
</mxGraphModel>' WHERE [Id] = 3
UPDATE [dbo].[DIAGRAM_TEMPLATES] SET [Diagram_Markup]=N'<mxGraphModel dx="1285" dy="682" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" value="Main Layer" parent="0"/>
    <UserObject SAL="Moderate" label="Dispatcher Training Simulator" internalLabel="Dispatcher Training Simulator" ZoneType="Other" zone="1" Criticality="Low" id="2">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#ece4d7;swimlaneFillColor=#f6f3ed;" parent="1" vertex="1">
        <mxGeometry x="1004" y="876.5" width="389" height="287" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Switch 2" ComponentGuid="1a76e6fc-b958-423b-bae0-a51260b1dc70" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="7">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="204.3334" y="68.16669" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Firewall" ComponentGuid="b5f05706-9ee1-4d94-8e0d-f3030b7ba8d3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="8">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="107" y="54.16669" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Workstation 4" ComponentGuid="4512f506-448d-4d3e-9535-a7560c00ea49" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="9">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="107" y="174.5" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Workstation 5" ComponentGuid="e1f1e922-b19b-4f57-a905-7908b1acd037" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="10">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="293.1428" y="174.5" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Printer" ComponentGuid="ab4d8299-176a-448e-8a8c-74dbd3fc3300" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="11">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/network_printer.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="293.1428" y="54.16669" width="60" height="54" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="DTS Server" ComponentGuid="0993abb5-542d-4486-83ab-d3264a8987df" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="12">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="204.3334" y="174.5" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IDS3" ComponentGuid="e6a72eb1-888b-45b8-a587-45d71a1f8754" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="13">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="25.988039999999998" y="174.5" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_373" ComponentGuid="e5573b0f-e7f0-4763-88f0-e49ad338243b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="14">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="46.98804" y="69.16669999999998" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="114" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="7" target="12" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="115" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="7" target="11" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="116" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="7" target="10" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="117" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="7" target="9" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="137" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="8" target="14" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="160" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="14" target="13" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="161" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="8" target="7" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="Low" label="Corporate" internalLabel="Corporate" ZoneType="Corporate" zone="1" Criticality="Low" id="3">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#fdf9d9;swimlaneFillColor=#fffef4;" parent="1" vertex="1">
        <mxGeometry x="1002" y="343.5" width="394" height="383" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corporate Firewall" ComponentGuid="f26a14a1-2085-4437-afa3-3d1f85f13f6d" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="15">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="295.1428" y="68.20001" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_37a" ComponentGuid="5c5ca21d-a5a5-4024-a835-95e52fb13923" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="16">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="230.3334" y="83.20001" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp. IDS" ComponentGuid="9e1c7894-dfa1-4fcf-94ac-fa42d90c7f70" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="17">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="211.3334" y="171" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp. Router" ComponentGuid="06523bdd-26b4-4815-a8f7-a9eb68358d78" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="18">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="24.98804" y="78.20001" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp. Switch" ComponentGuid="2b5f43b4-44f2-4638-9236-131c088627ff" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="19">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="24.98804" y="171" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Remote Access Server" ComponentGuid="25382d9c-965a-4e0c-904a-7490b1043f40" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="20">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/remote_access_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="37.98804" y="270.2338" width="34" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Public Historian" ComponentGuid="a8c731d4-0d6b-4529-8f9b-05fa7df72910" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="21">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/historian.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="109" y="171" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="139" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="18" target="16" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="140" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="17" target="16" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="141" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="16" target="15" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="143" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="18" target="19" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="144" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="19" target="21" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="145" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="19" target="20" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="High" label="SCADA" internalLabel="SCADA" ZoneType="Control System" zone="1" Criticality="Low" id="4">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#d3eef2;swimlaneFillColor=#f2f8f9;" parent="1" vertex="1">
        <mxGeometry x="99" y="359" width="872" height="819" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Firewall2" ComponentGuid="06e6c024-f1c6-4187-9968-f2c29a4aa785" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="34">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="641.017" y="50.20001000000002" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="SCADA Firewall" ComponentGuid="21ec56a5-3a82-4e36-81d0-b604676e4824" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="35">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="20" y="147" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Scada Server A" ComponentGuid="2ce2118a-651c-44a1-849e-6f1b55b9df91" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="36">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="33" y="665.3334" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Scada Server B" ComponentGuid="bcfa3b53-c80b-45e7-9a1a-29683ecec25f" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="37">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="119.29999999999995" y="665.3334" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Data Server A" ComponentGuid="b14b1e53-f979-4e33-805f-00b367dc1e00" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="38">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/database_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="207.5" y="665.3334" width="43" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Operator &#xa;Workstation" ComponentGuid="13ee607c-00b7-43b4-986c-698f382eb3b5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="39">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="646.017" y="676.3334" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Front-end Switch(s)" ComponentGuid="abea54b8-c381-49f3-9570-a8c6f1907182" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="40">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="194.5" y="160" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="SCADA IDS" ComponentGuid="2d94e0ef-9ecd-47c1-8a70-2f693ad7a111" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="41">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="110.29999999999995" y="50.20001000000002" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Router2" ComponentGuid="c289a29d-baf1-45d5-82fc-9ce0787328cd" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="42">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="644.017" y="255.23379999999997" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_126" ComponentGuid="10bc37d9-1884-4d3c-9a4d-8f6d6d760558" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="43">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="130.29999999999995" y="161" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_177" ComponentGuid="c927f452-1c35-48f5-a5cf-a0fa2d8ae939" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="44">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="663.017" y="171" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IDS2" ComponentGuid="4fb1ba56-3547-4617-ab96-14393fdf22d6" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="45">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="728.1669999999999" y="173" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Data Server B" ComponentGuid="e34873db-3993-4b93-9e7f-540ff2632cf3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="46">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/database_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="293.6667" y="665.3334" width="43" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Power Analysis &#xa;Software Server A" ComponentGuid="8ff46729-dafd-4ba6-9e6f-06d4d8711ffa" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="47">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="381.5" y="665.3334" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Power Analysis  &#xa;Software Server B" ComponentGuid="a4fdc284-a9c3-47e0-8288-999bf8e20f64" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="48">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="478.5" y="665.3334" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Front-End &#xa;Server A" ComponentGuid="547bce9b-0ac7-464a-9f66-c87fe30f2f09" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="49">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="118.29999999999995" y="255.23379999999997" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Switch2" ComponentGuid="df34d740-d626-4393-aefa-4150286017d8" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="50">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="555.8" y="380" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="RTU 1" ComponentGuid="95eb6f62-1e26-4207-854d-1f9a13379c6e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="51">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="469.5" y="50.20001000000002" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="RTU 2" ComponentGuid="ebc01422-8047-4097-bab4-3325cdda4bf5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="52">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="372.5" y="50.20001000000002" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="RTU 3" ComponentGuid="e7de89ce-f8d9-4201-9364-a42353714bd5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="53">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="284.6667" y="50.20001000000002" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Maintenance &#xa;Workstation" ComponentGuid="5a38c8ca-ad34-4563-acb9-1e75306661c8" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="54">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="558.8" y="676.3334" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Controller" ComponentGuid="356f4368-4f8f-4aab-a821-d2f697240845" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="55">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="733.1669999999999" y="676.3334" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Front-End &#xa;Server B" ComponentGuid="24551d86-9030-4011-a264-6d82478b0c69" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="56">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="292.6667" y="255.23379999999997" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_287" ComponentGuid="11ddc4f6-51bc-4d6d-9c41-a5787e421940" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="57">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="489.5" y="161" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_288" ComponentGuid="471582a7-5a18-4e0d-b579-df0d9526321e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="58">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="130.29999999999995" y="383" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_289" ComponentGuid="c7a2cd43-09ab-49cb-8429-164bd87ad16c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="59">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="304.6667" y="383" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_295" ComponentGuid="3d61a4dc-f21c-4049-88f2-b3befd37d3f3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="60">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="392.5" y="161" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_296" ComponentGuid="67288dff-d641-4f9f-8899-507f7a928ed3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="61">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="304.6667" y="161" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="GPS Clock" ComponentGuid="0d979924-7f58-45ed-a5ca-5c92d65b4e5c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="62">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/clock.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="110.29999999999995" y="467" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_2a4" ComponentGuid="4d617312-c739-465a-aebd-1a2d37e5cfb9" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="63">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="392.5" y="383" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Workstation" ComponentGuid="8c17c6a7-7ee6-4500-9591-db54508dd31e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="64">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="286.6667" y="483" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Workstation2" ComponentGuid="e4aef5d5-6825-445e-baf4-3ea05a34658a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="65">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="374.5" y="483" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Workstation 3" ComponentGuid="e692c607-173b-43b7-ab5f-75c840120805" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="66">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="471.5" y="484" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_2b3" ComponentGuid="97470a71-710f-44b0-8ede-3934a8872e84" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="67">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="489.5" y="383" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Network Printer" ComponentGuid="1c527624-b0f8-4467-88ef-a7abfa1db835" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="68">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/network_printer.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="373.5" y="255.23379999999997" width="60" height="54" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Switch" ComponentGuid="507ba476-aa23-463c-98e0-d5f0a87338e5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="69">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="730.1669999999999" y="255.23379999999997" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_309" ComponentGuid="0d04e75f-34c4-4912-9951-e458df76bb9d" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="70">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="752.1669999999999" y="383" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_30a" ComponentGuid="6f22c09e-a4ae-46c6-a9e0-0685f8235bb2" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="71">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="752.1669999999999" y="508" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Web Server A" ComponentGuid="cee3f1c4-c552-4f89-b01b-5c6655b180c5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="72">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/web_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="809.5" y="364" width="45" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Web Server B" ComponentGuid="fb0955de-d9d8-4de1-b75e-e9afd06fd12b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="73">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/web_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="816.1669999999999" y="488" width="45" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Network Isolator" ComponentGuid="51d8db8e-e9f4-4b78-859c-4ec19a2c6326" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="74">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="641.017" y="368" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_329" ComponentGuid="6acc9a2d-ba75-4b3f-9fe6-420368e8cace" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="75">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="752.1669999999999" y="587.1667" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_330" ComponentGuid="19c14d93-fc94-49c4-ae49-28063ab962e6" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="76">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="665.017" y="587.1667" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_353" ComponentGuid="265224ab-4080-4582-836b-4535d766db5b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="77">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="577.8" y="587.1667" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_354" ComponentGuid="6115ae8d-1891-4fca-aa3c-1ea70a71cc7b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="78">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="489.5" y="587.1667" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_355" ComponentGuid="6f7542dc-5201-4414-b8d0-ee7aaec50a27" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="79">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="392.5" y="587.1667" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_356" ComponentGuid="2018162d-54a3-4170-b35c-2a8f5e729259" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="80">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="304.6667" y="587.1667" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_357" ComponentGuid="a241a151-8548-4a7a-b7e2-8144f38b3e34" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="81">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="218.5" y="587.1667" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_358" ComponentGuid="131cfcfc-90b7-4d45-bd66-0c232fe03026" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="82">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="130.29999999999995" y="587.1667" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_359" ComponentGuid="3df6cc61-0c3f-4e54-9584-5a0a75686cdd" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="83">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="44" y="587.1667" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="84" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="35" target="43" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="89" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="43" target="40" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="85" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="41" target="43" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="86" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="44" target="34" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="88" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="42" target="44" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="87" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="44" target="45" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="90" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="43" target="49" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="94" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="51" target="57" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="93" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="49" target="58" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="92" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="56" target="59" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="99" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="58" target="59" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="96" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="60" target="52" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="95" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="57" target="60" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="146" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="61" target="40" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="98" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="61" target="53" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="91" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="61" target="56" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="97" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="60" target="61" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="100" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="58" target="62" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="101" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="59" target="63" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="102" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="59" target="64" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="103" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="63" target="65" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="107" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="67" target="50" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="104" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="63" target="67" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="105" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="67" target="66" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="106" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="63" target="68" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="122" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="42" target="69" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="108" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="69" target="70" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="109" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="70" target="71" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="110" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="72" target="70" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="111" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="73" target="71" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="113" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="74" target="50" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="112" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="70" target="74" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="119" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="75" target="55" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="121" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="76" target="39" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="120" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="75" target="76" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="118" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="77" target="50" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="124" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="77" target="54" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="123" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="76" target="77" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="126" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="78" target="48" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="125" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="77" target="78" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="128" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="79" target="47" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="127" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="78" target="79" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="130" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="80" target="46" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="129" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="79" target="80" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="132" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="81" target="38" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="131" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="80" target="81" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="134" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="82" target="37" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="133" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="82" target="81" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="136" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="83" target="36" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="135" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="82" target="83" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject label="Web" ComponentGuid="629b530b-759f-4622-9906-60fd1601c79a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" id="6">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/web.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="1297.1428571428569" y="240.20628571428574" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="142" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;entryX=0.5;entryY=1;entryDx=0;entryDy=0;" parent="1" source="15" target="6" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="1460" y="298" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <UserObject SAL="Moderate" label="Substation" internalLabel="Substation" ZoneType="Plant System" zone="1" parent="4" Criticality="Low" id="5">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#e6dbee;swimlaneFillColor=#f2edf6;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="-342" y="370" width="412" height="563" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Substation Router" ComponentGuid="8b82818b-c823-4e2a-82a6-0a66b137a35c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="22">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="310" y="149" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch(s)" ComponentGuid="b0c63764-345e-4ed4-9e60-ed4925f6703b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="23">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="130.5" y="150" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Local HMI" ComponentGuid="22b47b36-c074-4884-8e64-d958976169c8" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="24">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="130.5" y="52.19999999999999" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Network Ring" ComponentGuid="44655839-dac2-4d34-8643-2360d1da7c8b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="25">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/optical_ring.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="130.5" y="240.23379999999997" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch 1" ComponentGuid="8bb38e56-859f-4e60-8457-fea6a45afe6a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="26">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="310" y="257.2338" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch 2" ComponentGuid="7fd02b2b-4c2b-4230-8fc3-8875f7dfe285" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="27">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="230" y="361" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch 3" ComponentGuid="956ddfaf-e456-4a42-bb2f-4184865ff482" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="28">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="130.5" y="361" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch 4" ComponentGuid="56276fee-f58d-4e9a-953f-c1c748a118be" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="29">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="36" y="257.2338" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IED 1" ComponentGuid="b2235c17-de5d-4849-9ad0-30d22c549c8a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="30">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ied.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="310" y="469" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IED 2" ComponentGuid="b29a3a79-c084-4088-a216-ff52f5e8fa7c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="31">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ied.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="230" y="469" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IED 3" ComponentGuid="661b3fdd-4d45-418b-be09-342de3f8fbd6" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="32">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ied.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="130.5" y="469" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IED 4" ComponentGuid="c3a9449d-0060-4bcc-bec1-16b7261a7612" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="33">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ied.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="36" y="469" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="148" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="22" target="23" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="149" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="23" target="24" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="150" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="23" target="25" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="151" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="25" target="26" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="152" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="25" target="27" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="153" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="25" target="28" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="154" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="25" target="29" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="155" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="26" target="30" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="156" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="27" target="31" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="157" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="28" target="32" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="158" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="29" target="33" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="138" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="34" target="18" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="147" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="35" target="22" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="159" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="75" target="14" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
  </root>
</mxGraphModel>' WHERE [Id] = 4
UPDATE [dbo].[DIAGRAM_TEMPLATES] SET [Diagram_Markup]=N'<mxGraphModel dx="1154" dy="562" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" value="Main Layer" parent="0"/>
    <UserObject SAL="Low" label="Corporate-Low" internalLabel="Corporate" ZoneType="Corporate" zone="1" Criticality="Low" id="2">
      <mxCell style="swimlane;zone=1;fillColor=#fdf9d9;swimlaneFillColor=#fffef4;labelBackgroundColor=none;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="87" y="37" width="274" height="516" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="External Firewall" ComponentGuid="f8f6b0d0-070c-4dc0-b6b7-0a36ffdaf41c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="5">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="100.5" y="31" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Public Historian" ComponentGuid="eb58c8f2-2faf-4093-acea-47b719d0b033" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="6">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/historian.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="177" y="417" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp IDS" ComponentGuid="1e66b4da-8a35-46a2-a81c-87f130bdf907" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="7">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="192" y="153" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_4a" ComponentGuid="6c8b63b3-e304-421e-8f1f-5d6990f96add" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="8">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="122.5" y="153" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp Router" ComponentGuid="64e34c8d-8e47-405e-babe-45543505b546" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="9">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="103.5" y="223.5" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp Switch" ComponentGuid="c8b8053d-1f99-49b7-a849-83b485c2f024" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="10">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="103.5" y="318" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Remote Access Server" ComponentGuid="6c0d2b27-9f9a-499a-9484-d353ab1726a6" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="11">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/remote_access_server.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="33" y="405" width="34" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="42" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="5" target="8" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="43" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="8" target="7" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="45" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="8" target="9" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="46" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="9" target="10" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="47" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="10" target="6" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="48" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="10" target="11" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="High" label="Hydroelectric Control System-High" internalLabel="Hydroelectric Control System" ZoneType="Control System" zone="1" Criticality="Low" id="3">
      <mxCell style="swimlane;zone=1;fillColor=#d3eef2;swimlaneFillColor=#f2f8f9;labelBackgroundColor=none;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="376" y="36" width="997" height="711" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Firewall" ComponentGuid="f775f55a-6de1-4c5b-9eee-bb018c509c81" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="12">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="17" y="213.5" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Web Server" ComponentGuid="6c6930af-1318-445b-a438-37d4108c8de4" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="13">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/web_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="168" y="210.5" width="45" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Communication Server" ComponentGuid="74b0949f-76ef-4abe-8c45-806e9999031a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="14">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/database_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="363" y="130" width="43" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Voice Alarm History &#xa;DB Server" ComponentGuid="9780a8a1-1fc2-48d1-84fa-eb6f7a5ea481" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="15">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/database_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="365" y="319" width="43" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Engineer Console" ComponentGuid="2c8510c3-0e28-4037-ac92-63a1c75e8f1f" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="16">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ews.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="477.4" y="319" width="60" height="52" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Operator Console 1" ComponentGuid="0ddf2ed1-0853-4515-9f5f-bc58263f654b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="17">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="581" y="319" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Switch(s)" ComponentGuid="fa06c399-c83e-42d5-9871-109366d3aa90" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="18">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="256.5" y="228.5" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch 1" ComponentGuid="0d21d004-f25c-425b-8449-fa7b9ed6cc1a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="19">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="683.8" y="418" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch 2" ComponentGuid="0835c705-0f3f-42fd-99ed-af6f9a8f6ea3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="20">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="683.8" y="516" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch 3" ComponentGuid="130d8cdc-511e-4ec2-bed5-160238fc5b0e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="21">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="801" y="516" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch 4" ComponentGuid="59ab4d22-02de-412e-a3a2-56997f6bbafb" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="22">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="892" y="418" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="DCS 1" ComponentGuid="dbca8e4d-72c6-4d39-92f8-4b868a1c15b6" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="23">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/dcs.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="534" y="400" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="DCS 2" ComponentGuid="3173b5f0-6886-41b2-a02f-0476322a2114" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="24">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/dcs.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="691.8" y="611" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="DCS 3" ComponentGuid="3a267e63-bd6b-485d-88f8-f34b3a33c008" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="25">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/dcs.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="808" y="611" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="DCS 4" ComponentGuid="2fdb58ac-de7d-4b36-bbff-4388f4a8e955" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="26">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/dcs.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="898" y="497.5" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Network Ring" ComponentGuid="9b3deeb0-74cb-4004-835a-dff244f6ac8f" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="27">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/optical_ring.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="801" y="399" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Simulate Screen" ComponentGuid="4c265d9a-75ce-47d7-8c51-81657c319d9b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="28">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/pc.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="256.5" y="134" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial TV" ComponentGuid="dfb0fcce-dc1b-4a2b-9de2-1f6a84250101" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="29">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="256.5" y="32" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Fire Alarm System" ComponentGuid="bc11c1a4-4360-45ce-ae39-4e64d5e6e087" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="30">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/sis.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="355" y="32" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Billing System" ComponentGuid="fe6ce97d-eb23-4415-800e-0504e9b663b2" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="31">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="473.4" y="32" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Regimen Forecast" ComponentGuid="356042aa-ebc3-4251-b576-072f249ad6e2" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="32">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/pc.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="473.4" y="133" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Operator Console 2" ComponentGuid="ba5379b8-2347-4ad9-8e76-9233541db1fe" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="33">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="686.8" y="319" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch 5" ComponentGuid="d821a4bc-3a3d-400a-9465-ef49391ee7c9" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="34">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="801" y="231.5" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IDS" ComponentGuid="d7ccb962-2535-4b65-81cd-38b392639013" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="35">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="100" y="130" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_177" ComponentGuid="dcbaa75e-19fc-4364-bca1-d98e80da0a98" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="36">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="122" y="230.5" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_187" ComponentGuid="1c076151-0344-47f4-8a0e-852ebc8e7e72" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="37">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="497.4" y="230.5" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_188" ComponentGuid="802abe1b-2e84-44f4-89e8-3eda75565b22" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="38">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="601" y="231.5" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_189" ComponentGuid="8fb98ed1-12a4-4c26-a026-b53a89151661" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="39">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="707.8" y="232.5" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_194" ComponentGuid="3087a1d5-0ca3-46f4-9864-e35ff0aebb70" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="40">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="376" y="230.5" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="49" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="19" target="23" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="50" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="20" target="24" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="51" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="21" target="25" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="52" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="22" target="26" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="53" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="27" target="34" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="54" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="19" target="27" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="55" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="27" target="20" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="56" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="27" target="21" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="57" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="27" target="22" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="58" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="36" target="35" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="59" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="36" target="12" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="60" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="36" target="13" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="61" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="13" target="18" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="62" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="40" target="14" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="63" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="37" target="38" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="64" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="38" target="39" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="65" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="38" target="17" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="66" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="39" target="33" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="67" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="18" target="40" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="68" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="40" target="37" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="69" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="40" target="15" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="70" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="37" target="16" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="71" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="39" target="34" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="72" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="14" target="28" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="73" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="14" target="29" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="74" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="14" target="30" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="75" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="14" target="31" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="76" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="14" target="32" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject label="Web" ComponentGuid="2f27641c-fa55-4f2c-a451-9eef226c0b49" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Web" id="4">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/web.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="-0.7280000000000086" y="65" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="41" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="4" target="5" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="44" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="9" target="12" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
  </root>
</mxGraphModel>' WHERE [Id] = 5
UPDATE [dbo].[DIAGRAM_TEMPLATES] SET [Diagram_Markup]=N'<mxGraphModel dx="1154" dy="562" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" value="Main Layer" parent="0"/>
    <UserObject SAL="Low" label="Corporate-Low" internalLabel="Corporate" ZoneType="Corporate" zone="1" Criticality="Low" id="2">
      <mxCell style="swimlane;zone=1;fillColor=#fdf9d9;swimlaneFillColor=#fffef4;labelBackgroundColor=none;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="65" y="100" width="315" height="520" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="External Firewall" ComponentGuid="f325df2f-5009-4cdf-a483-87bd933dde8e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="5">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="117.1701" y="30.70621" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Public Historian" ComponentGuid="300811c8-1d91-4d95-abc4-2aab2b677919" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="6">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/historian.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="206.9701" y="414.4826" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp IDS" ComponentGuid="028f4b2d-be7b-4c9f-b226-7d86355a3e0f" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="7">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="206.9701" y="148.3062" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_4a" ComponentGuid="eb368476-bd88-470c-b6a2-d00cfa78ca39" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="8">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="139.1701" y="148.3062" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp Router" ComponentGuid="c000b048-28f3-4a83-afc6-efba158a0ef4" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="9">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="120.1701" y="225.5062" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp Switch" ComponentGuid="7811e6a1-c0d9-4ad6-bbd7-dbf27a819571" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="10">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="121.1701" y="320.8812" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Remote Access Server" ComponentGuid="a37950ea-73b7-4e36-bcf4-b15419a65d2c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="11">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/remote_access_server.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="35.47005" y="406.4826" width="34" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="53" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="5" target="8" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="54" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="8" target="7" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="56" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="8" target="9" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="57" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="9" target="10" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="58" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="10" target="6" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="59" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="10" target="11" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="High" label="Nuclear Plant Control System-High" internalLabel="Nuclear Plant Control System" ZoneType="Control System" zone="1" Criticality="Low" id="3">
      <mxCell style="swimlane;zone=1;fillColor=#d3eef2;swimlaneFillColor=#f2f8f9;labelBackgroundColor=none;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="402" y="100" width="885" height="710" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_39" ComponentGuid="4cdb0742-4a5c-4941-b22c-3a431f6c6a86" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="12">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="122.9935" y="228.5062" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Operator Station(s)" ComponentGuid="edc712d7-186a-45c2-9484-f7f838f9acdb" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="13">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="258.7042" y="123.3062" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Engineering &#xa;Workstation(s)" ComponentGuid="aa11a01d-c180-4b20-b512-3a41b431bfb5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="14">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="357.2115" y="123.3062" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Switch(s)" ComponentGuid="39df6af7-b99c-42bc-bcaf-3aa9d7aca88c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="15">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="180.0172" y="226.5062" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="RTU1" ComponentGuid="a2eceddb-fa68-47ab-a33e-c2014e79ddbf" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="16">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="15.1767" y="508.828" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="RTU 2" ComponentGuid="b612d2ae-d9bc-421c-8b7b-7cb7065989e9" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="17">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="351.2115" y="606" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC 1" ComponentGuid="f605423d-a241-4823-9661-68df051bd3b9" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="18">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="15.1767" y="414.4826" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC 2" ComponentGuid="794c5fcd-41d2-4675-bcb4-8aee468e1ddc" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="19">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="261.7042" y="606" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="SPDS" ComponentGuid="becd9c99-14d9-4b83-a71b-41944ba03914" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="20">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="455.2115" y="123.3062" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="LAN Access &#xa;Policy Manager" ComponentGuid="fa655379-74f4-4e11-9f19-498afa6ba069" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="21">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="710.9951" y="107.3062" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Real-Time &#xa;Server(s)" ComponentGuid="a08d1284-9570-4143-8bec-53e3a29b80d3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="22">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/database_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="806.3868" y="320.8812" width="43" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IPS" ComponentGuid="03bbfe6a-3287-4231-9127-730fef59591f" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="23">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ips.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="616.6403" y="123.3062" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_132" ComponentGuid="15ea57fb-8e38-42f9-863d-0e4ebbfa3acb" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="24">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="379.2115" y="231.5062" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_135" ComponentGuid="624616fd-8e1b-43a2-9baa-7eca52067958" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="25">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="469.2115" y="231.5062" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_136" ComponentGuid="edc26723-5faa-42d8-8f5e-85e4b44f3299" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="26">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="639.6404" y="232.5062" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Secure VPN" ComponentGuid="bca8c551-ac1a-414f-a282-c56cd47d5512" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="27">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/vpn.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="98.99344" y="123.3062" width="60" height="56" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Plant Process &#xa;Computer System" ComponentGuid="f2ef1778-f929-4a9d-84b8-47fe0b8faee7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="28">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="801.3868" y="108.3062" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_143" ComponentGuid="206d54ff-e8a3-4200-b4ef-1ba7a7ec54be" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="29">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="725.9951" y="233.5062" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_144" ComponentGuid="d1813c36-03d0-4aa6-ad76-f7c85c9e0eed" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="30">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="816.3868" y="233.5062" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Network Printer(s)" ComponentGuid="8da84ce4-0607-42d8-8808-d2ae096ba4cf" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="31">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/network_printer.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="536.469" y="123.3062" width="60" height="54" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch 1" ComponentGuid="151cfdb5-4d31-41b6-8fa1-90a9cfcf3d45" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="32">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="260.7042" y="320.8812" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Network Ring" ComponentGuid="19f725ba-e5cc-4129-b597-1c2d232646f3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="33">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/optical_ring.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="260.7042" y="400.4826" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch 2" ComponentGuid="8e79e65f-6c79-4e2b-8d94-b098b260e111" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="34">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="98.99344" y="417.4826" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch3" ComponentGuid="195c4298-8adb-4a6c-b4ac-0a0aa76a711c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="35">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="260.7042" y="508.828" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch 4" ComponentGuid="f15b43e0-1678-4418-b146-e3a7f37f780f" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="36">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="449.2115" y="508.828" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch 5" ComponentGuid="183b888b-d824-4ca3-908b-416361ca8e08" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="37">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="448.2115" y="341.8812" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="MTU 1" ComponentGuid="0465f083-226e-4798-b978-f1402bec90c5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="38">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/mtu.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="106.99344" y="497.828" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="MTU 2" ComponentGuid="d5cfe277-64ae-4a25-acbe-e33b51c236a4" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="39">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/mtu.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="355.2115" y="493.828" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC 3" ComponentGuid="950bf06a-af23-4983-bb4c-e28e7dc9722a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="40">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="533.469" y="508.828" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="MTU 3" ComponentGuid="ffd33d52-7160-4b40-b3b1-b6acf22acf7a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="41">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/mtu.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="457.2115" y="596" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="RTU 3" ComponentGuid="dfe9b872-9734-4931-a4ec-d16f01533c9c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="42">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="533.469" y="610" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC 4" ComponentGuid="815acca7-cd03-47ff-a6d8-07f026488d63" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="43">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="616.6403" y="340.8812" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="MTU 4" ComponentGuid="162beaf9-b2e6-46fb-af8e-754842be328a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="44">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/mtu.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="544.469" y="414.4826" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="RTU 4" ComponentGuid="ba03e269-27ca-4c85-b38c-1955601856e3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="45">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="616.6403" y="427.4826" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IDS" ComponentGuid="30c841c9-58e4-44a2-a5b4-2bf953bc5ffa" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="46">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="103.99344" y="320.8812" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Data Diode" ComponentGuid="64eaf308-e7fd-4162-95b5-693869861728" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="47">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unidirectional_device.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="15.1767" y="216.5062" width="60" height="40" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-38" ComponentGuid="c927eda4-e3e1-4ca6-a0cd-3e0d8afbd9bf" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="48">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="280.7042" y="229.5062" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-38" ComponentGuid="dca349c3-66a8-4a99-a9c2-32bafa29f793" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="49">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="557.469" y="232.5062" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-38" ComponentGuid="26304c74-e6fd-4737-9b36-7485fac1d6af" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="50">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="469.2115" y="422.4826" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-38" ComponentGuid="a16562b9-f526-4d0a-bbd3-f49c1ad48771" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="51">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="557.469" y="344.8812" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="60" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="12" target="15" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="61" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="15" target="48" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="62" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="24" target="14" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="63" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="24" target="25" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="64" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="25" target="20" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="65" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="26" target="23" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="66" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="13" target="48" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="67" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="12" target="27" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="68" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="26" target="29" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="69" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="29" target="30" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="70" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="30" target="22" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="71" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="30" target="28" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="72" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="29" target="21" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="73" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="49" target="31" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="74" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="48" target="32" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="75" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="32" target="33" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="76" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="34" target="33" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="77" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="33" target="35" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="78" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="50" target="36" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="79" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="33" target="50" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="80" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="34" target="38" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="81" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="38" target="16" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="82" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="18" target="34" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="83" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="35" target="19" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="84" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="35" target="39" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="85" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="39" target="17" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="86" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="36" target="40" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="87" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="36" target="41" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="88" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="41" target="42" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="89" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="51" target="43" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="90" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="51" target="44" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="91" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="44" target="45" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="92" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="12" target="46" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="93" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="12" target="47" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="94" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="24" target="48" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="95" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="25" target="49" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="96" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="49" target="26" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="97" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="37" target="50" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="98" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="37" target="51" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject label="Web" ComponentGuid="b4b542f8-b25d-436e-97e8-52ff0bb03ac5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Web" id="4">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/web.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="-30.46553672316385" y="126.70621468926555" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="52" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="4" target="5" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="55" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="9" target="47" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
  </root>
</mxGraphModel>' WHERE [Id] = 6
UPDATE [dbo].[DIAGRAM_TEMPLATES] SET [Diagram_Markup]=N'<mxGraphModel dx="1154" dy="562" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" value="Main Layer" parent="0"/>
    <UserObject SAL="Low" label="Corporate-Low" internalLabel="Corporate" ZoneType="Corporate" zone="1" Criticality="Low" id="2">
      <mxCell style="swimlane;zone=1;fillColor=#fdf9d9;swimlaneFillColor=#fffef4;labelBackgroundColor=#ffffff;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="52" y="82" width="291" height="520" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="External Firewall" ComponentGuid="3efda319-1850-465d-b8fe-c7ea5dc871e7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="7">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=#ffffff;" parent="2" vertex="1">
        <mxGeometry x="108" y="40.49492" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Public Historian" ComponentGuid="dcba85b0-9ab4-4ce9-8611-0b6e8c066631" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="8">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/historian.svg;labelBackgroundColor=#ffffff;" parent="2" vertex="1">
        <mxGeometry x="21" y="416" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp Router" ComponentGuid="e50e8efe-6f95-4033-8877-8ef2bf8af878" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="9">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=#ffffff;" parent="2" vertex="1">
        <mxGeometry x="110" y="239.9508" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_177" ComponentGuid="5b3924da-bc1c-4a3a-9f88-7ea2384c852b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="10">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="2" vertex="1">
        <mxGeometry x="129" y="132" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp IDS" ComponentGuid="52ac8ce2-7605-420f-97b4-fc77d3c92257" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="11">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=#ffffff;" parent="2" vertex="1">
        <mxGeometry x="194" y="133" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp Switch" ComponentGuid="e5fc2360-b314-4348-b571-aee72e417170" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="12">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=#ffffff;" parent="2" vertex="1">
        <mxGeometry x="110" y="322" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Remote Access Server" ComponentGuid="e7fdf040-49a3-402a-ac95-257ade9f041c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="13">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/remote_access_server.svg;labelBackgroundColor=#ffffff;" parent="2" vertex="1">
        <mxGeometry x="194" y="409" width="34" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="76" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="2" source="10" target="7" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="77" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="2" source="10" target="11" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="78" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="2" source="9" target="10" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="79" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="2" source="9" target="12" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="80" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="2" source="12" target="8" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="81" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="2" source="12" target="13" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="High" label="Plant Control Center-High" internalLabel="Plant Control Center" ZoneType="Control System" zone="1" Criticality="Low" id="3">
      <mxCell style="swimlane;zone=1;fillColor=#d3eef2;swimlaneFillColor=#f2f8f9;labelBackgroundColor=#ffffff;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="361" y="82" width="874" height="609" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="SCADA Firewall" ComponentGuid="d2016409-df25-4c4f-87a0-e6b99e256d60" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="14">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="17.2034" y="227.9508" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Control Server" ComponentGuid="8459eb53-e0ab-4fa0-865c-e022d28c3b94" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="15">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="608.2034" y="416" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Data Historian" ComponentGuid="22a74939-d65d-4ab3-9fd9-94bbd4693ec3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="16">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/historian.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="512.0237" y="416" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="SCADA IDS" ComponentGuid="181c94d2-9767-433e-9617-e3ef8256c998" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="17">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="106.9424" y="133" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_126" ComponentGuid="37b736a8-a5b0-4adf-b7b1-b3fbefe6aa7a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="18">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="128.9424" y="243.9508" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_245" ComponentGuid="471bbd96-650e-43b2-bcf9-5db008b5e8ff" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="19">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="214.1932" y="243.9508" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_247" ComponentGuid="ddd869f7-1c0b-4f3d-a354-c11c09c6cffc" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="20">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="305.4745" y="243.9508" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_248" ComponentGuid="672a85a2-e7cd-4fbe-aab6-a166acf9e94e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="21">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="389.9525" y="243.9508" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_249" ComponentGuid="432fba15-cb22-4d9b-ba89-afc1ac7ce94e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="22">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="488.1559" y="243.9508" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_24a" ComponentGuid="0bbd2138-cba2-424b-ae9a-d85524b51c3c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="23">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="576.0237" y="243.9508" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_24b" ComponentGuid="358c3573-fe08-418a-afef-39f6827a440d" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="24">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="649.2034" y="243.9508" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_250" ComponentGuid="c52e7721-8305-472b-a739-43959946ebb8" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="25">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="730.4119" y="243.9508" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="OPC Server" ComponentGuid="a3d1a838-ffec-4fbf-968c-080faeb3dfb0" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="26">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="291.4745" y="133" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Main Layer &#xa;Domain Controller" ComponentGuid="eb86e9ad-c1df-4246-9013-51d9578c05d8" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="27">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/active_directory.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="374.9525" y="133" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Application Server" ComponentGuid="668c544c-7219-4160-82ba-f325ce5f4ec0" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="28">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="474.1559" y="133" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Data Server" ComponentGuid="122f5300-d81f-45bf-ba82-8f30e4362eb6" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="29">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/database_server.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="562.0237" y="133" width="43" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Printer" ComponentGuid="97f595fe-f989-4600-8909-c0b38bdcb404" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="30">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/network_printer.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="628.2034" y="133" width="60" height="54" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Workstations" ComponentGuid="1ae67d2b-d0fd-497e-8bce-ea921be3d9ed" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="31">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="709.4119" y="133" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="HMI" ComponentGuid="03d0017a-6b9a-4ef6-879d-2578663e94bb" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="32">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="791.7526" y="416" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="EWS" ComponentGuid="7ec6eafe-4a16-4a62-a9b6-c74a8d607657" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="33">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ews.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="699.4119" y="416" width="60" height="52" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Hub/Switch" ComponentGuid="0b473bfc-2509-4868-882d-f0563b751b3a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="34">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hub.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="789.7526" y="240.9508" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Router" ComponentGuid="1bf065a7-cfb5-45cd-8458-500f8e01b9a3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="35">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="425.1559" y="513.2136" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_278" ComponentGuid="945b8da8-49de-4747-8af6-bed2b8518152" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="36">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="526.0237" y="517.2136" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_279" ComponentGuid="aaf8df1c-2b08-40d5-bccd-81981243801b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="37">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="620.2034" y="518.2136" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_27a" ComponentGuid="a8c40975-33c3-4796-8570-77ae60c62739" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="38">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="721.4119" y="518.2136" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_27b" ComponentGuid="006ab116-fcd9-42ac-98a4-95e2d403cde2" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="39">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="814.7526" y="517.2136" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Link Encryption" ComponentGuid="6e55c37a-6cda-4434-bc87-cc9d369e489e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="40">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/link_encryption.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="347.9525" y="496.2136" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Wireless Device(s)" ComponentGuid="62011910-7846-4400-928a-6b38bdb4aa9c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="41">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/wireless_network.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="193.1932" y="133" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Master Radio" ComponentGuid="354ca5e3-d127-4f4c-8fcd-8ac215d1fc42" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="42">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/serial_radio.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="250.47449999999998" y="509.2136" width="60" height="31" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-47" ComponentGuid="7f29e0cf-1b63-4271-bff2-75e9b16660b6" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="67">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="528.0237" y="346" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-47" ComponentGuid="5062980b-cfdc-4ff7-8e22-1b7646bd0361" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="68">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="623.2034" y="346" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-47" ComponentGuid="2b0cd19c-3c33-41ea-9ebb-128f133ed465" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="69">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="718.4119" y="346" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-47" ComponentGuid="0150b608-2fc5-45e4-9d09-2674adf998e5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="70">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="809.7526" y="346" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-47" ComponentGuid="573d81dd-a046-4380-af8d-575697a6d1bc" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="71">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="3" vertex="1">
        <mxGeometry x="82.94239999999999" y="516.2136" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="73" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="14" target="18" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="74" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="17" target="18" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="82" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="19" target="20" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="83" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="20" target="21" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="84" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="21" target="22" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="85" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="22" target="23" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="86" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="23" target="24" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="87" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="24" target="25" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="88" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="26" target="20" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="89" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="27" target="21" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="90" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="28" target="22" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="91" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="29" target="23" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="92" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="24" target="30" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="93" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="31" target="25" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="94" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="25" target="34" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="95" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="67" target="16" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="96" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="69" target="33" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="97" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="70" target="32" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="98" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="68" target="15" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="99" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="32" target="39" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="100" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="38" target="39" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="101" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="33" target="38" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="102" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="15" target="37" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="103" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="16" target="36" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="104" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="37" target="36" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="105" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="38" target="37" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="106" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="36" target="35" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="107" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="18" target="19" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="108" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="19" target="41" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="109" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="35" target="40" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="110" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="40" target="42" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="111" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="42" target="71" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="135" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="67" target="68" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="136" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="69" target="68" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="137" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="70" target="69" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="138" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="3" source="70" target="34" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="Moderate" label="Remote Station 1-Moderate" internalLabel="Remote Station 1" ZoneType="Control System" zone="1" Criticality="Low" id="4">
      <mxCell style="swimlane;zone=1;fillColor=#d3eef2;swimlaneFillColor=#f2f8f9;labelBackgroundColor=#ffffff;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="142" y="703" width="418" height="421" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Remote Radio" ComponentGuid="a08bca24-5ba8-4cb7-9952-2f8839b8341d" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="43">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/serial_radio.svg;labelBackgroundColor=#ffffff;" parent="4" vertex="1">
        <mxGeometry x="318.9424" y="30.38983" width="60" height="31" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Link Encryption" ComponentGuid="1802cfc3-01e8-4488-b61c-17c7d003432c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="44">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/link_encryption.svg;labelBackgroundColor=#ffffff;" parent="4" vertex="1">
        <mxGeometry x="323.9424" y="127.5526" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC1" ComponentGuid="d36e38a0-79ce-413b-a943-bd042308f589" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="45">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=#ffffff;" parent="4" vertex="1">
        <mxGeometry x="104" y="220.2203" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Wireless &#xa;Device(s)" ComponentGuid="3fe32d0c-900c-4455-9e9e-b92bfdd0e4b2" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="46">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/wireless_network.svg;labelBackgroundColor=#ffffff;" parent="4" vertex="1">
        <mxGeometry x="236.2034" y="220.2203" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Device 1" ComponentGuid="1ea92370-cd7e-427c-b1f2-61b2f1a45bab" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="47">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=#ffffff;" parent="4" vertex="1">
        <mxGeometry x="18" y="127.5526" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Device 2" ComponentGuid="2a553b64-a211-414f-9df9-70853337d851" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="48">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=#ffffff;" parent="4" vertex="1">
        <mxGeometry x="18" y="220.2203" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Device 3" ComponentGuid="92b26e0c-17b7-4248-999e-3cb0ba9721bc" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="49">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=#ffffff;" parent="4" vertex="1">
        <mxGeometry x="18" y="322.8644" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Device 4" ComponentGuid="404119c3-ada2-48c4-8bf1-9337db9bcd14" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="50">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=#ffffff;" parent="4" vertex="1">
        <mxGeometry x="107" y="322.8644" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Device 5" ComponentGuid="f573a9a8-565e-4157-a8fb-f534dec383f6" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="51">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=#ffffff;" parent="4" vertex="1">
        <mxGeometry x="236.2034" y="322.8644" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Firewall" ComponentGuid="84951c3f-afa7-486a-844d-a51517a6c0ff" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="52">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=#ffffff;" parent="4" vertex="1">
        <mxGeometry x="104" y="130.55259999999998" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_315" ComponentGuid="675b4d79-b925-45bf-a6f1-e765d8a01b23" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="53">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="4" vertex="1">
        <mxGeometry x="260.2034" y="147.5526" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IPS" ComponentGuid="763a1197-f774-4a1e-8f53-78cfc6b47418" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="54">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ips.svg;labelBackgroundColor=#ffffff;" parent="4" vertex="1">
        <mxGeometry x="239.2034" y="43.38983" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="113" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="4" source="43" target="44" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="115" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="4" source="45" target="46" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="116" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="4" source="45" target="47" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="117" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="4" source="45" target="48" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="118" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="4" source="45" target="49" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="119" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="4" source="45" target="50" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="120" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="4" source="45" target="51" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="127" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="4" source="52" target="45" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="128" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="4" source="44" target="53" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="129" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="4" source="53" target="52" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="130" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="4" source="53" target="54" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="Moderate" label="Remote Station 2-Moderate" internalLabel="Remote Station 2" ZoneType="Control System" zone="1" Criticality="Low" id="5">
      <mxCell style="swimlane;zone=1;fillColor=#d3eef2;swimlaneFillColor=#f2f8f9;labelBackgroundColor=#ffffff;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="623" y="703" width="397" height="420" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Remote Radio" ComponentGuid="d126039d-721b-42aa-baef-5dcef6556055" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="55">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/serial_radio.svg;labelBackgroundColor=#ffffff;" parent="5" vertex="1">
        <mxGeometry x="19.47455" y="30.38983" width="60" height="31" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Link Encryption" ComponentGuid="b007f300-6653-4ab7-afe2-5f0346fb5632" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="56">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/link_encryption.svg;labelBackgroundColor=#ffffff;" parent="5" vertex="1">
        <mxGeometry x="25.47455" y="127.5526" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC 2" ComponentGuid="9296b4d0-cb01-4671-be39-e54722c43fc8" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="57">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=#ffffff;" parent="5" vertex="1">
        <mxGeometry x="202.1559" y="220.2203" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Device 1" ComponentGuid="69c4a7e9-ce97-4651-bc17-c7cad96208c4" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="58">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=#ffffff;" parent="5" vertex="1">
        <mxGeometry x="103.9525" y="220.2203" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Device 2" ComponentGuid="e16af926-59c6-435c-8572-b9110ac2bb58" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="59">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=#ffffff;" parent="5" vertex="1">
        <mxGeometry x="103.9525" y="312.8644" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Device 3" ComponentGuid="0de9dd81-0bd2-4b83-b49e-10ca3b1a531e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="60">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=#ffffff;" parent="5" vertex="1">
        <mxGeometry x="209.1559" y="312.8644" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Device 4" ComponentGuid="6e647d11-e86e-4bc1-b4f2-7527b41071f4" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="61">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=#ffffff;" parent="5" vertex="1">
        <mxGeometry x="290.0237" y="315.8644" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Device 5" ComponentGuid="ecdf9c0e-d220-47a1-8302-f018c7869dc2" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="62">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=#ffffff;" parent="5" vertex="1">
        <mxGeometry x="290.0237" y="127.5526" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Wireless &#xa;Device(s)" ComponentGuid="fedfcac4-b67d-4cd3-a161-8ba818802535" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="63">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/wireless_network.svg;labelBackgroundColor=#ffffff;" parent="5" vertex="1">
        <mxGeometry x="290.0237" y="220.2203" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_31a" ComponentGuid="502d4dca-e9da-41b6-adf4-173142fc9cb8" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="64">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=#ffffff;" parent="5" vertex="1">
        <mxGeometry x="125.9525" y="148.5526" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IPS" ComponentGuid="08a6b05a-71f3-40da-8f00-30bdab0d20d6" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="65">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ips.svg;labelBackgroundColor=#ffffff;" parent="5" vertex="1">
        <mxGeometry x="103.9525" y="44.38983" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Firewall" ComponentGuid="3d54195b-1a10-4a0b-9b69-c981a335f726" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="66">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=#ffffff;" parent="5" vertex="1">
        <mxGeometry x="202.1559" y="132.55259999999998" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="114" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="5" source="55" target="56" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="121" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="5" source="57" target="58" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="122" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="5" source="57" target="59" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="123" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="5" source="57" target="60" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="124" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="5" source="57" target="61" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="125" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="5" source="57" target="62" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="126" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="5" source="57" target="63" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="131" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="5" source="57" target="66" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="132" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="5" source="56" target="64" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="133" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="5" source="64" target="66" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="134" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="5" source="64" target="65" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject label="Web" ComponentGuid="660aa164-2e18-4d09-809f-a8ef0c079e3e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Web" id="6">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/web.svg;labelBackgroundColor=#ffffff;" parent="1" vertex="1">
        <mxGeometry x="-48.83322033898304" y="117.4949152542373" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="72" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="1" source="14" target="9" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="75" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=#ffffff;" parent="1" source="6" target="7" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="112" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;entryX=0;entryY=0.25;entryDx=0;entryDy=0;labelBackgroundColor=#ffffff;" parent="1" source="42" target="55" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="139" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;exitX=0;exitY=0.25;exitDx=0;exitDy=0;entryX=0.75;entryY=1;entryDx=0;entryDy=0;labelBackgroundColor=#ffffff;" parent="1" source="43" target="71" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="487.07766585123863" y="733.3898300000001" as="sourcePoint"/>
        <mxPoint x="480" y="618" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
  </root>
</mxGraphModel>' WHERE [Id] = 7
UPDATE [dbo].[DIAGRAM_TEMPLATES] SET [Diagram_Markup]=N'<mxGraphModel dx="1154" dy="562" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" value="Main Layer" parent="0"/>
    <UserObject SAL="Low" label="Corporate-Low" internalLabel="Corporate" ZoneType="Corporate" zone="1" Criticality="Low" id="2">
      <mxCell style="swimlane;zone=1;fillColor=#fdf9d9;swimlaneFillColor=#fffef4;labelBackgroundColor=none;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="86" y="72" width="265" height="520" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp. Firewall" ComponentGuid="7f06f9fc-8567-4ab5-8e6e-bbf7579debd8" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="9">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="97.43904" y="30.75646" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_399" ComponentGuid="75375e69-17d8-405b-b1f1-b87712f7aeef" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="10">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="119.439" y="149.2" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp. IDS" ComponentGuid="a95c1665-c61a-47a8-a5d8-baeefc58404b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="11">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="179.0398" y="150.2" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp. Router" ComponentGuid="f5ea33c8-7be4-473e-a17f-344154ad69aa" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="12">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="100.43904" y="209.925" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp. Switch" ComponentGuid="7662db49-ee87-43b5-9c9f-85c27683953b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="13">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="99.43904" y="322.925" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Public Historian" ComponentGuid="6949c4ed-5d92-4455-8f21-1d71fb46b73c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="14">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/historian.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="9.539841" y="418.425" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp. Remote &#xa;Access Server" ComponentGuid="75664d85-1755-4bcb-bb85-2810cb78cec4" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="15">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/remote_access_server.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="179.0398" y="391.425" width="34" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="90" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="9" target="10" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="91" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="10" target="11" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="92" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="10" target="12" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="93" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="12" target="13" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="94" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="13" target="14" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="95" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="13" target="15" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="High" label="Plant Control Center-High" internalLabel="Plant Control Center" ZoneType="Control System" zone="1" Criticality="Low" id="3">
      <mxCell style="swimlane;zone=1;fillColor=#d3eef2;swimlaneFillColor=#f2f8f9;labelBackgroundColor=none;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="360" y="218" width="450" height="770" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Core Ethernet &#xa;Switch" ComponentGuid="16ad8817-967d-460a-8bde-615058194bb2" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="16">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="159.5806" y="328.4991" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Historian" ComponentGuid="8f68097d-a1ad-434e-af2b-537c265311be" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="17">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/database_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="29.96375" y="462.8271" width="43" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Remote Access &#xa;Server" ComponentGuid="634dfc9a-7873-4516-a154-2cac90582348" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="18">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/remote_access_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="29.96375" y="310.4991" width="34" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IDS 1" ComponentGuid="c0c25228-f10d-4a09-b62a-1183e745c7e4" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="19">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="248.4243" y="158.925" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_286" ComponentGuid="f87afb7c-2795-4593-a10d-305d9e1e8a34" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="20">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="178.5806" y="158.925" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="HMI(s)" ComponentGuid="e41ef933-5ff1-4052-8d32-7ce1222a6a11" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="21">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="29.96375" y="668.1771" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="VPN" ComponentGuid="93df5558-7382-4d3c-8a39-9ab487ea93e7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="22">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/vpn.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="29.96375" y="139.925" width="60" height="56" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="SCADA Server" ComponentGuid="04bb5baf-9ba4-4ea8-a9b5-18a69c979ca7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="23">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="29.96375" y="565.8571" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_330" ComponentGuid="560b7629-ac32-4f9a-ba6a-f8e71be9e6d7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="24">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="180.5806" y="483.8271" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_333" ComponentGuid="c0aa3a20-1eb0-443b-94c7-55a809932330" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="25">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="180.5806" y="587.8571" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_334" ComponentGuid="f9d9700c-86c4-4c2f-836f-69c63c12ff9f" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="26">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="180.5806" y="685.1771" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Network Management &amp;amp; &#xa;VideoSurveillance Server" ComponentGuid="bedba6a3-e540-4a45-9771-c13c66368bb5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="27">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="333.0806" y="567.8571" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Router" ComponentGuid="f7f546a0-7e47-4d56-9959-6a61ba1b47d7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="28">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="158.5806" y="230.425" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Control System &#xa;Firewall" ComponentGuid="5a483f52-c4e1-4b52-b76c-a14e5c072938" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="29">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="156.5806" y="49.92499" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Firewall" ComponentGuid="c12069cb-190f-4969-925b-9a5205734140" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="30">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="333.0806" y="314.4991" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IDS 2" ComponentGuid="03bf9662-01f2-4da2-857a-7e47ce1c3c2b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="31">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="251.4243" y="230.425" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-1" ComponentGuid="6bdb27f1-b2c6-45cb-9da3-a751ed49214f" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" internalLabel="CON-1" id="32">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="272.4243" y="330.4991" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Engineer &#xa;Workstation(s)" ComponentGuid="f9f9fb3b-f85c-4497-83ff-ff884384984b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="33">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ews.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="333.0806" y="466.8271" width="60" height="52" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="60" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="20" target="19" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="61" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="22" target="20" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="62" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="16" target="18" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="63" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="16" target="24" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="64" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="24" target="17" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="65" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="24" target="25" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="66" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="25" target="26" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="67" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="25" target="23" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="68" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="26" target="21" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="69" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="27" target="25" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="70" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="33" target="24" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="75" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="20" target="28" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="76" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="28" target="16" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="88" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="20" target="29" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="109" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="32" target="31" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="110" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="16" target="32" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="111" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="32" target="30" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="Moderate" label="Wellhead Monitoring/Control 1-Moderate" internalLabel="Wellhead Monitoring/Control 1" ZoneType="Control System" zone="1" Criticality="Low" id="4">
      <mxCell style="swimlane;zone=1;fillColor=#d3eef2;swimlaneFillColor=#f2f8f9;labelBackgroundColor=none;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="825" y="695" width="320" height="435" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch" ComponentGuid="671a68d2-f935-458c-8336-8d5cd96f56f7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="34">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="125.162" y="223" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Multi-Service &#xa;Gateway" ComponentGuid="3037c46c-84b5-41fe-a77e-014b7afe91e8" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="35">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/vlan_router.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="124.162" y="328.673" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Firewall" ComponentGuid="8986774d-efe3-41c4-945c-a5ae2f1769d7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="36">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="125.162" y="117.68" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_363" ComponentGuid="bd7ec0d6-c28b-4684-9d12-553cd4b3a61c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="37">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="146.162" y="40.65002" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IDS" ComponentGuid="68b30ce6-2d3a-45cc-8aec-523bb8f75110" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="38">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="230.1385" y="40.65002" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Camera" ComponentGuid="3305833a-0dad-48b9-8aa9-c4e156b2551e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="39">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ip_camera.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="230.1385" y="236" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="RTU" ComponentGuid="c79dd8a2-acbd-4a09-974b-7a95e005a30d" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="40">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="230.1385" y="133.68" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IP Phone(s)" ComponentGuid="a3cacb56-2b9e-4661-a410-036c45057931" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="41">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ip_phone.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="230.1385" y="335.673" width="60" height="57" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="78" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="37" target="38" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="79" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="35" target="39" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="80" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="35" target="40" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="81" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="35" target="41" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="102" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="37" target="36" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="103" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="36" target="34" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="104" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="34" target="35" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="Moderate" label="Gas/Oil Separation Plant (GOSP)-Moderate" internalLabel="Gas/Oil Separation Plant (GOSP)" ZoneType="Plant System" zone="1" Criticality="Low" id="5">
      <mxCell style="swimlane;zone=1;fillColor=#e6dbee;swimlaneFillColor=#f2edf6;labelBackgroundColor=none;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="831" y="107.5" width="320" height="515" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Network Ring" ComponentGuid="8ec57ec9-50c6-4304-9122-f7938e7a3eac" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="8">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/optical_ring.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="121.162" y="421.4991" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Camera(s)" ComponentGuid="ce5645b3-8f4f-4454-ad74-c39824988e8e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="42">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ip_camera.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="12.92572" y="30.2" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch" ComponentGuid="5294491d-ebee-4fe8-bf1d-c5115d797ac7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="43">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="12.92572" y="237.925" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Embedded  &#xa;Computer" ComponentGuid="ddefbc00-592e-46c6-92da-e86652323ffb" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="44">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/front_end_processor.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="117.162" y="123.925" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Video &#xa;Encoder(s)" ComponentGuid="cb362261-ffad-408a-9894-73d3029ffcdd" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="45">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/front_end_processor.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="18.92572" y="123.925" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="GOSP Controllers" ComponentGuid="eac2a30e-bc11-4b18-b907-27a42c5bed1c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="46">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/dcs.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="117.162" y="227.925" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Firewall" ComponentGuid="af267a3f-7746-4961-90bb-3a3a12674600" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="47">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="12.92572" y="330.425" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IPS" ComponentGuid="5fd49f9c-169c-438a-92de-252bcf67195d" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="48">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ips.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="210.1385" y="347.425" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_3b5" ComponentGuid="a6bcbd6d-ba34-4996-8fb1-f5d77a93e326" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="49">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="141.162" y="347.425" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="72" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="43" target="44" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="73" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="43" target="45" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="74" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="43" target="46" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="77" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="45" target="42" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="97" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="49" target="48" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="98" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="8" target="49" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="99" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="49" target="47" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="100" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="47" target="43" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="Moderate" label="Wellhead Monitoring/Control 2-Moderate" internalLabel="Wellhead Monitoring/Control 2" ZoneType="Control System" zone="1" Criticality="Low" id="6">
      <mxCell style="swimlane;zone=1;fillColor=#d3eef2;swimlaneFillColor=#f2f8f9;labelBackgroundColor=none;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="1160" y="377" width="444" height="380" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Wireless" ComponentGuid="8fd0ab1a-7f99-4919-8fc3-09b037a7528f" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="50">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/wireless_network.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="183.6774" y="45.42499" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Switch" ComponentGuid="e1f5ea59-1312-4ec7-94e7-425b62ff9ac9" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="51">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="185.6774" y="168.4991" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IP Phone(s)" ComponentGuid="922a7e41-4c7c-4730-a8b2-6e368530d39e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="52">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ip_phone.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="92.67737" y="277.8271" width="60" height="57" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IP Camera(s)" ComponentGuid="e352235b-6bd8-4ef4-a1a7-dfb695f5b6d8" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="53">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ip_camera.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="185.6774" y="277.8271" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial Serial &#xa;Device Server" ComponentGuid="1f32fd1c-c792-4fa5-bf25-ede1722da709" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="54">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/terminal_server.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="279.6774" y="149.4991" width="39" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="RTU(s)" ComponentGuid="673bbe35-9a5f-4035-923c-520b28bd0be3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="55">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="279.6774" y="277.8271" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC(s)" ComponentGuid="22119d84-21ec-415a-9208-fa7ed28a5ce2" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="56">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="361.6774" y="163.4991" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Firewall 2" ComponentGuid="ffc02b03-47e2-4f76-b0d0-c694d13c1345" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="57">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="92.67737" y="156.4991" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_409" ComponentGuid="c214998c-0c3c-46a1-a6d3-3fe56ca55fa5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="58">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="34.24597" y="172.4991" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IDS" ComponentGuid="8a46fcb0-4cb9-41df-a35c-436049d67c09" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="59">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="13.24597" y="45.42499" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="82" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="51" target="52" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="83" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="51" target="53" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="84" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="50" target="51" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="85" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="51" target="54" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="86" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="54" target="55" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="87" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="54" target="56" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="106" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="58" target="59" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="107" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="58" target="57" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="108" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="57" target="51" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject label="Web" ComponentGuid="e2468ef7-4d7b-40fe-b52b-82b76504acf5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Web" id="7">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/web.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="-1.5687615844038874" y="97.75646052639352" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="71" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="30" target="8" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="89" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="7" target="9" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="96" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="29" target="12" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="101" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="8" target="37" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="105" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="8" target="58" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
  </root>
</mxGraphModel>' WHERE [Id] = 8
UPDATE [dbo].[DIAGRAM_TEMPLATES] SET [Diagram_Markup]=N'<mxGraphModel dx="754" dy="562" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" value="Main Layer" parent="0"/>
    <UserObject SAL="Low" label="Corporate-Low" internalLabel="Corporate" ZoneType="Corporate" zone="1" Criticality="Low" id="2">
      <mxCell style="swimlane;zone=1;fillColor=#fdf9d9;swimlaneFillColor=#fffef4;labelBackgroundColor=none;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="150" y="120" width="270" height="520" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="External Firewall" ComponentGuid="ff102b8a-578d-49dd-95ec-032a4d09928c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="6">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="96.39999" y="32.63" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_185" ComponentGuid="6368349e-ea60-4e10-bd64-d0289aca6e04" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="7">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="116.4" y="152.23" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp. IDS" ComponentGuid="bb570a5d-d236-4b16-b76e-77108aefaf52" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="8">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="179.6" y="153.23" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp. Router" ComponentGuid="e134b35e-ae97-44f3-b307-b487543c70db" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="9">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="96.39999" y="222.3794" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp. Switch" ComponentGuid="8c818d6f-ff67-427b-a027-ae3f2cf56119" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="10">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="96.39999" y="318.43" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Public Historian" ComponentGuid="aef6ba88-451f-48d6-a028-bc47c991e6c0" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="11">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/historian.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="13" y="419.43" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Remote Access &#xa;Server" ComponentGuid="cbba877c-f603-4886-ab41-086982df254b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="12">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/remote_access_server.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="179.6" y="406.43" width="34" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="45" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="6" target="7" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="46" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="7" target="8" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="47" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="7" target="9" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="48" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="9" target="10" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="49" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="10" target="11" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="50" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="10" target="12" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="High" label="Traffic Dispatch/Control Center-High" internalLabel="Traffic Dispatch/Control Center" ZoneType="Control System" zone="1" Criticality="Low" id="3">
      <mxCell style="swimlane;zone=1;fillColor=#d3eef2;swimlaneFillColor=#f2f8f9;labelBackgroundColor=none;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="440" y="120" width="550" height="425" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Firewall 1" ComponentGuid="b9cb6c17-cf00-4909-a42e-467c6aab2df6" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="13">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="15" y="211.3794" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Switch(s)" ComponentGuid="9153daf1-41ec-42eb-adce-d977d6575915" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="14">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="99" y="128.23" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Database &#xa;Server" ComponentGuid="47c2d81d-5ba9-4c0a-874d-b9d4db73a0b1" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="15">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/database_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="109" y="34" width="43" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Video Server" ComponentGuid="48c46d79-f3da-4257-b4ec-00aba4e17328" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="16">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/database_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="218.8" y="34" width="43" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_17a" ComponentGuid="55326790-cf91-4284-8346-50e7e9b19aa7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="17">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="120" y="227.3794" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IDS 1" ComponentGuid="fd1f3d21-78a7-47a7-938e-76364192b6e7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="18">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="100" y="318.43" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Operator &#xa;Workstation(s)" ComponentGuid="81e3cd06-b4a2-44bc-a4a6-f4bb4867b277" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="19">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="15" y="34" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CCTV &#xa;Camera(s)" ComponentGuid="6bed05cc-87a4-4214-a584-0d2764603e32" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="20">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ip_camera.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="467" y="34" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Communications &#xa;Server" ComponentGuid="daf77c3f-7736-49bb-b18c-78a30067a30e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="21">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="314" y="34" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Master &#xa;Coordinator" ComponentGuid="4f93f153-63cf-4ea8-9aa5-5299068e33c7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="22">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="400.445" y="34" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Firewall 2" ComponentGuid="801a6554-7168-4d92-98fb-ac61903a921b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="23">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="209.8" y="318.43" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_1b9" ComponentGuid="11089647-2ce3-4b82-9529-df1386e31f28" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="24">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="229.8" y="227.3794" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IDS 2" ComponentGuid="b2bc3948-41b1-4ebc-b3d4-456f68523dc0" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="25">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="301" y="230.3794" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-26" ComponentGuid="f98e65b8-778a-4a7e-84fd-fd66c8ed5ffc" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="33">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="35" y="131.23" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-26" ComponentGuid="7efbc7bb-d120-408a-b7d5-8ac323036068" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="34">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="229.8" y="132.23" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-26" ComponentGuid="9a2c276a-42b8-4a22-ada8-927f2abf2b46" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="35">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="325" y="132.23" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-26" ComponentGuid="5e549199-39e7-4b23-98a9-8c1c0515edf8" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="36">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="488" y="132.23" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-26" ComponentGuid="0a6a78a6-4837-4498-995f-f313c1e7a0cb" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="37">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="412.445" y="132.23" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="38" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="34" target="16" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="39" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="14" target="15" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="43" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="17" target="18" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="52" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="13" target="17" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="53" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="17" target="14" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="54" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="33" target="19" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="55" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="36" target="20" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="59" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="24" target="25" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="60" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="34" target="24" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="61" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="24" target="23" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="63" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="33" target="14" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="64" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="14" target="34" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="65" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="34" target="35" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="66" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="21" target="35" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="67" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="37" target="22" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="68" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="37" target="35" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="69" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="36" target="37" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="Moderate" label="Field-Moderate" internalLabel="Field" ZoneType="Control System" zone="1" Criticality="Low" id="4">
      <mxCell style="swimlane;zone=1;fillColor=#d3eef2;swimlaneFillColor=#f2f8f9;labelBackgroundColor=none;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="440" y="560" width="550" height="315" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Network Ring" ComponentGuid="4a845109-02d7-477c-b4be-71c0f326a22e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="26">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/optical_ring.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="209.8" y="30.65002" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial &#xa;Switch 1" ComponentGuid="398c9510-6d74-416b-a7f7-a26e85b74827" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="27">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="210.8" y="124.65" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial &#xa;Switch 3" ComponentGuid="6aba186f-cbf9-40cf-8c15-138fffe6ebc4" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="28">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="388.445" y="30.65002" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC 3" ComponentGuid="f426cdaa-c43d-4c3d-935b-a7a53b2acc1e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="29">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="388.445" y="124.65" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC 1" ComponentGuid="d1b6f058-416a-46de-a098-c5b0a3191b2c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="30">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="210.8" y="217.65" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industiral &#xa;Switch 2" ComponentGuid="4eb280cb-66b7-461f-a930-a9a3dfa71346" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="31">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="301" y="124.65" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC 2" ComponentGuid="0e424cf6-9978-4c8f-92cc-c44fbecf252f" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="32">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="301" y="217.65" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="40" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="26" target="27" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="41" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="26" target="28" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="42" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="28" target="29" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="56" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="27" target="30" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="57" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="26" target="31" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="58" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="31" target="32" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject label="Web" ComponentGuid="ec659a4f-c682-4157-877b-ad55d09408ae" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Web" id="5">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/web.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="69.79999999999995" y="147.63" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="44" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="5" target="6" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="51" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="9" target="13" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="62" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="23" target="26" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
  </root>
</mxGraphModel>' WHERE [Id] = 9
UPDATE [dbo].[DIAGRAM_TEMPLATES] SET [Diagram_Markup]=N'<mxGraphModel dx="1947" dy="1034" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" value="Main Layer" parent="0"/>
    <UserObject SAL="Low" label="Corporate-Low" internalLabel="Corporate" ZoneType="Corporate" zone="1" Criticality="Low" id="2">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#fdf9d9;swimlaneFillColor=#fffef4;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="40" y="100" width="260" height="520" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="External Firewall" ComponentGuid="f1fac8bc-739a-4912-b458-046fd14f9f1e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="8">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="85.5" y="32.14987" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Public Historian" ComponentGuid="9fb0d7bb-3aed-426d-99f2-f3cc02d63292" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="9">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/historian.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="14" y="422.1548" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp Router" ComponentGuid="a1daf7de-0bb2-4826-8f9a-9ecccb3b0fbf" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="10">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="87.5" y="223.49" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_177" ComponentGuid="8f961afc-caeb-486a-89a2-31dd77d5b592" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="11">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="106.5" y="151.98" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp IDS" ComponentGuid="f627088a-7f73-4cc3-b1db-00f4b22e7245" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="12">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="171" y="153.98000000000002" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp Switch" ComponentGuid="a266ede2-a0c9-4306-88d9-bfb2f4713f67" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="13">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="87.5" y="321.98" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Remote Access &#xa;Server" ComponentGuid="0c785c82-d2ea-404e-83a3-a26f0cfa4807" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="14">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/remote_access_server.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="171" y="410.1548" width="34" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="92" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="11" target="8" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="93" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="11" target="12" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="95" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="10" target="11" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="96" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="10" target="13" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="97" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="13" target="9" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="98" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="13" target="14" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="High" label="Water Treatment Plant-High" internalLabel="Water Treatment Plant" ZoneType="Control System" zone="1" Criticality="Low" id="3">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#d3eef2;swimlaneFillColor=#f2f8f9;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="320" y="100" width="800" height="820" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Firewall" ComponentGuid="b726a04c-d4b4-4ac4-8e90-a5ed4ed187da" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="15">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="18.272" y="209.49" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="SCADA &#xa;Server(s)" ComponentGuid="4a3a4dc8-871c-4ab7-8653-a48589590fb3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="16">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="458" y="127.98" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Internal &#xa;Historian" ComponentGuid="4d03a32c-52fd-4238-9cab-ae9a059c55a2" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="17">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/historian.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="382.5" y="127.98" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Operator &#xa;Workstation(s)" ComponentGuid="080b4be4-f08d-400e-994b-c14af9e2fcb7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="18">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="532" y="127.98" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Master Radio &lt;br&gt;Ethernet&lt;br&gt;" ComponentGuid="6a1d369c-0767-435f-8dc7-fce0c8de5c72" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="20">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/serial_radio.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="705.8022" y="321.98" width="60" height="31" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Switch(s)" ComponentGuid="fff370fe-7b02-4b1d-9061-851667b75c78" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="21">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="209" y="223.49" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Network Ring" ComponentGuid="ecc05ddc-a32b-484d-9164-67154482d13e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="25">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/optical_ring.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="211" y="302.98" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial &#xa;Switch 1" ComponentGuid="f0384245-c908-482b-b206-c5aa49d029d5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="27">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="18.272" y="321.98" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial &#xa;Switch 2" ComponentGuid="cf36ff88-626f-4b34-bf83-372f5c3a3ee6" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="28">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="212" y="422.1548" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial &#xa;Switch 3" ComponentGuid="0da2aee3-661c-4316-b56c-1cfc34ff7dc1" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="29">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="375.5" y="422.1548" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial &#xa;Switch 4" ComponentGuid="ef0ece89-a66a-402f-8fe0-a9c80fb01302" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="30">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="532" y="321.98" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC" ComponentGuid="e1dceaa0-b503-490e-8002-4a8accfd2ebd" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="31">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="107" y="544.0960000000002" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="I/O" ComponentGuid="9258ed00-c7a7-4c63-a4ab-d2a0b6316195" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="32">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="107" y="638.4120000000001" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="I/O 1" ComponentGuid="aea5f99d-b52d-4b3a-a619-fb5e7f0637a3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="35">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;direction=east;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="291" y="638.4120000000001" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC 2" ComponentGuid="c41a1119-32eb-40f0-aadd-cb9337f5c927" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="36">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="291" y="544.0960000000001" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC 3" ComponentGuid="731fa609-9ac8-44f8-800f-071fd5ae0287" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="37">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="448" y="544.0960000000001" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="I/O 3" ComponentGuid="d056355c-0221-4131-9f14-a40568584310" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="38">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="448" y="638.412" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC 4" ComponentGuid="84236fb1-9fc9-4cd4-b939-c13d2bb62a77" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="40">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="618" y="544.0960000000001" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="I/O 4" ComponentGuid="1de9fba5-2c92-43db-81fc-d8cbab485aa0" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="41">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="618" y="638.412" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_29b" ComponentGuid="62642d2e-bb09-49d8-9b98-2de0c9eff6e0" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="43">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="650" y="224.99" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_2a0" ComponentGuid="70233ebd-6b10-4193-bd75-df817bfb4d03" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="44">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="396.5" y="224.49" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_2a1" ComponentGuid="c0afd8bd-dcf5-4a95-a47d-ab967c57607c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="45">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="472" y="224.49" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_2a2" ComponentGuid="fd9aea8d-69cb-4d6c-a42c-0d8c550d76f7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="46">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="553" y="224.49" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_2ab" ComponentGuid="28aa34d5-9925-4b38-939a-f7008f35fe82" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="47">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="42.272" y="548.096" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_2b0" ComponentGuid="c85f469e-ca94-4e36-9aa3-a9dd17b9892d" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="48">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="42.272" y="644.412" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_2b8" ComponentGuid="bf747f2b-b52f-4e18-93d5-88cd140dc7c8" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="50">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="233" y="548.096" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_2b9" ComponentGuid="86055b45-c2ef-41c3-9b58-bdac37e063b2" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="51">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="233" y="644.412" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_305" ComponentGuid="92c4c9cb-b62d-4503-a3f3-953ceabd5b7a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="53">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="396.5" y="548.096" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_306" ComponentGuid="2586016d-e6ae-493a-b44e-b61c1de355ee" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="54">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="396.5" y="644.412" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_312" ComponentGuid="47a23686-1e9a-42b9-af10-375c948d88e0" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="56">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="553" y="548.096" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_313" ComponentGuid="10f257a3-6205-403d-9592-3596a0437f5a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="57">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="553" y="644.412" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-53" ComponentGuid="c39d26c4-1376-430f-ae3b-dab5ae1fc82e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="80">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="723.8022" y="145.2998" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="116" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="45" target="16" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="114" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="44" target="17" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="115" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="18" target="46" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="87" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="20" target="80" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="104" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="21" target="25" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="105" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="25" target="27" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="106" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="28" target="25" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="107" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="25" target="29" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="108" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="25" target="30" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="117" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="27" target="47" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="123" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="28" target="50" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="129" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="29" target="53" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="135" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="30" target="56" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="120" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="47" target="31" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="121" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="48" target="32" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="127" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="51" target="35" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="126" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="50" target="36" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="134" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="53" target="37" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="133" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="54" target="38" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="138" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="56" target="40" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="139" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="57" target="41" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="111" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="44" target="45" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="112" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="45" target="46" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="118" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="47" target="48" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="124" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="50" target="51" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="130" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="53" target="54" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="136" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="56" target="57" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="86" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="30" target="20" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="662" y="337.8573033735438" as="sourcePoint"/>
      </mxGeometry>
    </mxCell>
    <UserObject ComponentGuid="c941fff3-7f15-45fb-9942-9af5d680725c" Criticality="Low" label="Engineering&lt;br&gt;Workstation(s)&lt;br&gt;" internalLabel="EW-2" id="plqYrKeGjVpLpWE4VVd8-156">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/ews.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="630" y="126" width="60" height="52" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="141" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" parent="3" source="46" target="43" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="618" y="233.01348993288593" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <mxCell id="plqYrKeGjVpLpWE4VVd8-160" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" parent="3" source="44" target="21" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="316.5" y="234.49" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <mxCell id="plqYrKeGjVpLpWE4VVd8-161" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="3" source="43" target="plqYrKeGjVpLpWE4VVd8-156" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="83" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="15" target="21" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="131" y="233.6517634371496" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <UserObject SAL="High" label="Other Treatment Plants-High" internalLabel="Other Treatment Plants" ZoneType="Plant System" zone="1" Criticality="Low" id="4">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#e6dbee;swimlaneFillColor=#f2edf6;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="1140" y="100" width="400" height="240" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Remote &#xa;Radio" ComponentGuid="e93b1d8b-780e-42a3-9fe5-39a8dec7d926" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="59">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/serial_radio.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="21" y="140.2998" width="60" height="31" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject ComponentGuid="559fd8a1-93b8-4ea2-b426-7d926641dc4a" Criticality="Low" label="PLC-1" internalLabel="PLC-1" id="plqYrKeGjVpLpWE4VVd8-155">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="271" y="140" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject ComponentGuid="d5e33582-5777-4cff-a2d3-7e0cfab7a0f4" Criticality="Low" label="SW-3" internalLabel="SW-3" id="plqYrKeGjVpLpWE4VVd8-157">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="158" y="141" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="89" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;entryX=0;entryY=0.75;entryDx=0;entryDy=0;" parent="4" source="59" target="plqYrKeGjVpLpWE4VVd8-157" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="118" y="155.43166813186804" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <mxCell id="145" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" target="plqYrKeGjVpLpWE4VVd8-155" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="214" y="153" as="sourcePoint"/>
        <mxPoint x="266.2664999999997" y="153.42958317557463" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <UserObject SAL="High" label="Remote Sites-High" internalLabel="Remote Sites-High" ZoneType="Control System" zone="1" Criticality="Low" id="5">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#d3eef2;swimlaneFillColor=#f2f8f9;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="1140" y="375" width="400" height="240" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Remote &#xa;Radio" ComponentGuid="af95dc47-e138-4c04-adbe-d674d19a8c5c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="65">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/serial_radio.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="18.8501" y="46.01807" width="60" height="31" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="RTU(s)" ComponentGuid="62d92c78-5e3f-4b5c-9662-0cd084871d45" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="67">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="266.2665" y="43.01807" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject ComponentGuid="1543ebb4-a75e-42ee-a017-86916ca7bf54" Criticality="Low" label="SW-4" internalLabel="SW-4" id="plqYrKeGjVpLpWE4VVd8-158">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="154" y="47" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="143" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="plqYrKeGjVpLpWE4VVd8-158" target="67" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="240.64120000000003" y="54.16770626404832" as="sourcePoint"/>
      </mxGeometry>
    </mxCell>
    <mxCell id="90" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;entryX=0;entryY=0.75;entryDx=0;entryDy=0;" parent="5" source="65" target="plqYrKeGjVpLpWE4VVd8-158" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="115.85010000000011" y="61.14993813186811" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <UserObject label="Web" ComponentGuid="609aca56-6f87-4cfa-8634-c06169d6b7cc" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Web" id="7">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/web.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="-42.523028248587565" y="127.97999999999999" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="91" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="7" target="8" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="82" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="15" target="10" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="88" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="20" target="65" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="154" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="59" target="80" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
  </root>
</mxGraphModel>' WHERE [Id] = 10
UPDATE [dbo].[DIAGRAM_TEMPLATES] SET [Diagram_Markup]=N'<mxGraphModel dx="1947" dy="1034" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" value="Main Layer" parent="0"/>
    <UserObject SAL="Low" label="Corporate-Low" internalLabel="Corporate" ZoneType="Corporate" zone="1" Criticality="Low" id="2">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#fdf9d9;swimlaneFillColor=#fffef4;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="40" y="100" width="260" height="520" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="External Firewall" ComponentGuid="f1fac8bc-739a-4912-b458-046fd14f9f1e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="8">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="85.5" y="32.14987" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Public Historian" ComponentGuid="9fb0d7bb-3aed-426d-99f2-f3cc02d63292" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="9">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/historian.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="14" y="422.1548" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp Router" ComponentGuid="a1daf7de-0bb2-4826-8f9a-9ecccb3b0fbf" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="10">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="87.5" y="223.49" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_177" ComponentGuid="8f961afc-caeb-486a-89a2-31dd77d5b592" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="11">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="106.5" y="151.98" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp IDS" ComponentGuid="f627088a-7f73-4cc3-b1db-00f4b22e7245" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="12">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="171" y="153.98000000000002" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp Switch" ComponentGuid="a266ede2-a0c9-4306-88d9-bfb2f4713f67" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="13">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="87.5" y="321.98" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Remote Access &#xa;Server" ComponentGuid="0c785c82-d2ea-404e-83a3-a26f0cfa4807" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="14">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/remote_access_server.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="171" y="410.1548" width="34" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="92" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="11" target="8" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="93" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="11" target="12" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="95" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="10" target="11" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="96" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="10" target="13" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="97" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="13" target="9" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="98" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="13" target="14" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="High" label="Water Treatment Plant-High" internalLabel="Water Treatment Plant" ZoneType="Control System" zone="1" Criticality="Low" id="3">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#d3eef2;swimlaneFillColor=#f2f8f9;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="320" y="100" width="800" height="820" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Firewall" ComponentGuid="b726a04c-d4b4-4ac4-8e90-a5ed4ed187da" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="15">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="18.272" y="209.49" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="SCADA &#xa;Server(s)" ComponentGuid="4a3a4dc8-871c-4ab7-8653-a48589590fb3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="16">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="458" y="127.98" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Internal &#xa;Historian" ComponentGuid="4d03a32c-52fd-4238-9cab-ae9a059c55a2" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="17">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/historian.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="382.5" y="127.98" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Operator &#xa;Workstation(s)" ComponentGuid="080b4be4-f08d-400e-994b-c14af9e2fcb7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="18">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/hmi.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="532" y="127.98" width="60" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Master Radio &lt;br&gt;Ethernet&lt;br&gt;" ComponentGuid="6a1d369c-0767-435f-8dc7-fce0c8de5c72" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="20">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/serial_radio.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="705.8022" y="321.98" width="60" height="31" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Switch(s)" ComponentGuid="fff370fe-7b02-4b1d-9061-851667b75c78" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="21">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="209" y="223.49" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Network Ring" ComponentGuid="ecc05ddc-a32b-484d-9164-67154482d13e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="25">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/optical_ring.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="211" y="302.98" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial &#xa;Switch 1" ComponentGuid="f0384245-c908-482b-b206-c5aa49d029d5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="27">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="18.272" y="321.98" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial &#xa;Switch 2" ComponentGuid="cf36ff88-626f-4b34-bf83-372f5c3a3ee6" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="28">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="212" y="422.1548" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial &#xa;Switch 3" ComponentGuid="0da2aee3-661c-4316-b56c-1cfc34ff7dc1" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="29">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="375.5" y="422.1548" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Industrial &#xa;Switch 4" ComponentGuid="ef0ece89-a66a-402f-8fe0-a9c80fb01302" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="30">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="532" y="321.98" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC" ComponentGuid="e1dceaa0-b503-490e-8002-4a8accfd2ebd" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="31">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="107" y="544.0960000000002" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="I/O" ComponentGuid="9258ed00-c7a7-4c63-a4ab-d2a0b6316195" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="32">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="107" y="638.4120000000001" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="I/O 1" ComponentGuid="aea5f99d-b52d-4b3a-a619-fb5e7f0637a3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="35">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;direction=east;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="291" y="638.4120000000001" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC 2" ComponentGuid="c41a1119-32eb-40f0-aadd-cb9337f5c927" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="36">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="291" y="544.0960000000001" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC 3" ComponentGuid="731fa609-9ac8-44f8-800f-071fd5ae0287" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="37">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="448" y="544.0960000000001" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="I/O 3" ComponentGuid="d056355c-0221-4131-9f14-a40568584310" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="38">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="448" y="638.412" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC 4" ComponentGuid="84236fb1-9fc9-4cd4-b939-c13d2bb62a77" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="40">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="618" y="544.0960000000001" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="I/O 4" ComponentGuid="1de9fba5-2c92-43db-81fc-d8cbab485aa0" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="41">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="618" y="638.412" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_29b" ComponentGuid="62642d2e-bb09-49d8-9b98-2de0c9eff6e0" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="43">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="650" y="224.99" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_2a0" ComponentGuid="70233ebd-6b10-4193-bd75-df817bfb4d03" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="44">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="396.5" y="224.49" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_2a1" ComponentGuid="c0afd8bd-dcf5-4a95-a47d-ab967c57607c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="45">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="472" y="224.49" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_2a2" ComponentGuid="fd9aea8d-69cb-4d6c-a42c-0d8c550d76f7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="46">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="553" y="224.49" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_2ab" ComponentGuid="28aa34d5-9925-4b38-939a-f7008f35fe82" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="47">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="42.272" y="548.096" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_2b0" ComponentGuid="c85f469e-ca94-4e36-9aa3-a9dd17b9892d" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="48">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="42.272" y="644.412" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_2b8" ComponentGuid="bf747f2b-b52f-4e18-93d5-88cd140dc7c8" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="50">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="233" y="548.096" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_2b9" ComponentGuid="86055b45-c2ef-41c3-9b58-bdac37e063b2" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="51">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="233" y="644.412" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_305" ComponentGuid="92c4c9cb-b62d-4503-a3f3-953ceabd5b7a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="53">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="396.5" y="548.096" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_306" ComponentGuid="2586016d-e6ae-493a-b44e-b61c1de355ee" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="54">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="396.5" y="644.412" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_312" ComponentGuid="47a23686-1e9a-42b9-af10-375c948d88e0" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="56">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="553" y="548.096" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Connector_313" ComponentGuid="10f257a3-6205-403d-9592-3596a0437f5a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="57">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="553" y="644.412" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-53" ComponentGuid="c39d26c4-1376-430f-ae3b-dab5ae1fc82e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="80">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="723.8022" y="145.2998" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="116" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="45" target="16" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="114" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="44" target="17" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="115" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="18" target="46" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="87" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="20" target="80" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="104" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="21" target="25" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="105" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="25" target="27" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="106" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="28" target="25" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="107" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="25" target="29" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="108" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="25" target="30" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="117" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="27" target="47" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="123" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="28" target="50" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="129" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="29" target="53" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="135" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="30" target="56" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="120" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="47" target="31" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="121" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="48" target="32" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="127" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="51" target="35" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="126" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="50" target="36" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="134" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="53" target="37" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="133" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="54" target="38" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="138" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="56" target="40" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="139" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="57" target="41" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="111" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="44" target="45" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="112" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="45" target="46" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="118" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="47" target="48" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="124" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="50" target="51" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="130" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="53" target="54" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="136" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="56" target="57" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="86" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="30" target="20" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="662" y="337.8573033735438" as="sourcePoint"/>
      </mxGeometry>
    </mxCell>
    <UserObject ComponentGuid="c941fff3-7f15-45fb-9942-9af5d680725c" Criticality="Low" label="Engineering&lt;br&gt;Workstation(s)&lt;br&gt;" internalLabel="EW-2" id="plqYrKeGjVpLpWE4VVd8-156">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/ews.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="630" y="126" width="60" height="52" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="141" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" parent="3" source="46" target="43" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="618" y="233.01348993288593" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <mxCell id="plqYrKeGjVpLpWE4VVd8-160" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" parent="3" source="44" target="21" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="316.5" y="234.49" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <mxCell id="plqYrKeGjVpLpWE4VVd8-161" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="3" source="43" target="plqYrKeGjVpLpWE4VVd8-156" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="83" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="15" target="21" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="131" y="233.6517634371496" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <UserObject SAL="High" label="Other Treatment Plants-High" internalLabel="Other Treatment Plants" ZoneType="Plant System" zone="1" Criticality="Low" id="4">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#e6dbee;swimlaneFillColor=#f2edf6;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="1140" y="100" width="400" height="240" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Remote &#xa;Radio" ComponentGuid="e93b1d8b-780e-42a3-9fe5-39a8dec7d926" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="59">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/serial_radio.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="21" y="140.2998" width="60" height="31" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject ComponentGuid="559fd8a1-93b8-4ea2-b426-7d926641dc4a" Criticality="Low" label="PLC-1" internalLabel="PLC-1" id="plqYrKeGjVpLpWE4VVd8-155">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="271" y="140" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject ComponentGuid="d5e33582-5777-4cff-a2d3-7e0cfab7a0f4" Criticality="Low" label="SW-3" internalLabel="SW-3" id="plqYrKeGjVpLpWE4VVd8-157">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="158" y="141" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="89" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;entryX=0;entryY=0.75;entryDx=0;entryDy=0;" parent="4" source="59" target="plqYrKeGjVpLpWE4VVd8-157" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="118" y="155.43166813186804" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <mxCell id="145" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" target="plqYrKeGjVpLpWE4VVd8-155" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="214" y="153" as="sourcePoint"/>
        <mxPoint x="266.2664999999997" y="153.42958317557463" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <UserObject SAL="High" label="Remote Sites-High" internalLabel="Remote Sites-High" ZoneType="Control System" zone="1" Criticality="Low" id="5">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#d3eef2;swimlaneFillColor=#f2f8f9;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="1140" y="375" width="400" height="240" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Remote &#xa;Radio" ComponentGuid="af95dc47-e138-4c04-adbe-d674d19a8c5c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="65">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/serial_radio.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="18.8501" y="46.01807" width="60" height="31" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="RTU(s)" ComponentGuid="62d92c78-5e3f-4b5c-9662-0cd084871d45" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="67">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="266.2665" y="43.01807" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject ComponentGuid="1543ebb4-a75e-42ee-a017-86916ca7bf54" Criticality="Low" label="SW-4" internalLabel="SW-4" id="plqYrKeGjVpLpWE4VVd8-158">
      <mxCell style="aspect=fixed;html=1;align=center;shadow=0;dashed=0;spacingTop=3;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="154" y="47" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="143" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="plqYrKeGjVpLpWE4VVd8-158" target="67" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="240.64120000000003" y="54.16770626404832" as="sourcePoint"/>
      </mxGeometry>
    </mxCell>
    <mxCell id="90" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;entryX=0;entryY=0.75;entryDx=0;entryDy=0;" parent="5" source="65" target="plqYrKeGjVpLpWE4VVd8-158" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="115.85010000000011" y="61.14993813186811" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <UserObject label="Web" ComponentGuid="609aca56-6f87-4cfa-8634-c06169d6b7cc" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Web" id="7">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/web.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="-42.523028248587565" y="127.97999999999999" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="91" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="7" target="8" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="82" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="15" target="10" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="88" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="20" target="65" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="154" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="59" target="80" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
  </root>
</mxGraphModel>' WHERE [Id] = 11
UPDATE [dbo].[DIAGRAM_TEMPLATES] SET [Diagram_Markup]=N'<mxGraphModel dx="754" dy="562" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" value="Main Layer" parent="0"/>
    <UserObject SAL="Moderate" label="Heating, Ventilation, and Air-Conditioning System-Moderate" internalLabel="Heating, Ventilation, and Air-Conditioning System" ZoneType="Other" zone="1" Criticality="Low" id="2">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#ece4d7;swimlaneFillColor=#f6f3ed;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="539" y="315" width="340" height="340" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Switch" ComponentGuid="9ba5d895-2750-4a87-8bee-f0ac53ef13a5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="4">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="21" y="38" width="60" height="22" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Control &#xa;Device 1" ComponentGuid="beb3b9c5-ad65-4be1-b669-f45583217f60" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="5">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="98.79999" y="34.870509999999996" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Control &#xa;Device 2" ComponentGuid="a0e9eb1b-baa0-4cd9-9851-59e61fe83352" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="6">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="98.79999" y="249.718" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Building Automation  &#xa;System" ComponentGuid="8827e48f-9cf5-4af5-955c-c394b21ec778" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="7">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/building_automation_management_systems.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="98.79999" y="132.218" width="40" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Chiller Unit" ComponentGuid="73a810f4-d52a-4be9-885f-0343a7d858f4" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="8">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="195.8" y="23.87051" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Boiler Unit" ComponentGuid="2ad03cf3-e03d-4392-89af-0d552af22755" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="9">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="195.8" y="238.718" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-14" ComponentGuid="83eed835-0246-4357-9daf-7f24fba9acb9" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="10">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="41.79999" y="152.218" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-14" ComponentGuid="0d75ae0e-e5de-4ce2-8674-b7e1f37a2040" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="11">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="41.79999" y="254.718" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="21" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="5" target="8" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="22" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="4" target="5" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="23" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="11" target="6" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="24" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="10" target="7" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="25" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="4" target="10" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="26" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="10" target="11" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="27" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="6" target="9" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="Low" label="Corporate-Low" internalLabel="Corporate" ZoneType="Corporate" zone="1" Criticality="Low" id="3">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#fdf9d9;swimlaneFillColor=#fffef4;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="170" y="120" width="200" height="410" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="External &#xa;Firewall" ComponentGuid="36d35dc4-4be6-40fb-a426-8f5f46bdf1db" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="12">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="16" y="30.2955" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp IDS" ComponentGuid="9cc3c77e-e964-4357-95fa-489bc9a937a1" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="13">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="100" y="157.2955" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-1" ComponentGuid="aa420d8c-fca2-4ab0-9f52-cb0a1515a5d4" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" internalLabel="CON-1" id="14">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="36" y="156.2955" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp Router" ComponentGuid="90c96c94-035d-4b9e-bc51-567bfb2aa04f" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="15">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="16" y="229.8705" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp Switch" ComponentGuid="b7809191-9875-4e84-b1eb-a822e1786e5b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="16">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="16" y="316.359" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="29" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="14" target="12" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="30" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="14" target="13" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="32" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="14" target="15" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="33" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="15" target="16" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject label="Web" ComponentGuid="ef3156ac-94f3-4e9f-af15-6ab5f9f03406" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Web" id="17">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/web.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="89.46399999999994" y="145.79549999999995" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Firewall" ComponentGuid="5adc173b-4676-460d-ba64-fb03bc0f3bb6" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Firewall" id="18">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="456.42527009130026" y="336.8705" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="IDS" ComponentGuid="ab86c7e3-1fbf-483f-ad99-c49b7f4c0e90" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="IDS" id="19">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="382.4000000000001" y="276.29549999999995" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-28" ComponentGuid="8d800b88-d07c-40ee-ad19-deccedcab2c8" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="CON-28" id="20">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="403.4000000000001" y="352.3705" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="28" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="17" target="12" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="31" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="15" target="20" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="34" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="18" target="4" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="35" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="20" target="18" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="36" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="20" target="19" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
  </root>
</mxGraphModel>' WHERE [Id] = 12
UPDATE [dbo].[DIAGRAM_TEMPLATES] SET [Diagram_Markup]=N'<mxGraphModel dx="754" dy="562" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" value="Main Layer" parent="0"/>
    <UserObject SAL="Low" label="Corporate-Low" internalLabel="Corporate" ZoneType="Corporate" zone="1" Criticality="Low" id="2">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#fdf9d9;swimlaneFillColor=#fffef4;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="104" y="322.5" width="196" height="531" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="External Firewall" ComponentGuid="3ccacdde-2e6b-49b5-88ed-a6081a34df5c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="10">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="18.39874" y="30.35886" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Public&#xa;Historian" ComponentGuid="9d8c998d-fd85-438c-8ad0-c714c508cf4c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="11">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/historian.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="106.7392" y="426.3599" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp IDS" ComponentGuid="b0cfc701-5dc0-4cac-8825-5756f0cb5f26" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="12">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="106.7392" y="163.17950000000002" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-2" ComponentGuid="e8d3e41a-f80c-4b8b-8011-e685ebbc1dae" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" internalLabel="CON-2" id="13">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="15.39873" y="161.6795" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp Router" ComponentGuid="42b0a79c-0459-4fc5-ba22-b639d05a2a6e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="14">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="52.398740000000004" y="231.3824" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp Switch" ComponentGuid="77304754-68ff-4d5a-b9bb-29499ae00389" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="15">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="22.39874" y="329.3599" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Remote Access&#xa;Server" ComponentGuid="6aa95ac1-5e60-4fbf-a306-586c96f25014" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="16">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/remote_access_server.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="18.39874" y="414.3599" width="34" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="63" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;entryX=0.016;entryY=1.002;entryDx=0;entryDy=0;entryPerimeter=0;exitX=0.18;exitY=0.291;exitDx=0;exitDy=0;exitPerimeter=0;" parent="2" source="13" target="10" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="36" y="151.5" as="sourcePoint"/>
      </mxGeometry>
    </mxCell>
    <mxCell id="64" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="13" target="12" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="66" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="13" target="14" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="67" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;exitX=0;exitY=0.75;exitDx=0;exitDy=0;" parent="2" source="14" target="15" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="68" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="15" target="11" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="69" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;exitX=0;exitY=0.75;exitDx=0;exitDy=0;" parent="2" source="15" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="22" y="414.5" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <UserObject SAL="High" label="Closed Circuit Camera System-High" internalLabel="Closed Circuit Camera System" ZoneType="Control System" zone="1" Criticality="Low" id="3">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#d3eef2;swimlaneFillColor=#f2f8f9;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="660" y="82" width="241" height="341" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Video Server" ComponentGuid="94cc2c8f-ccb9-46f9-be8a-b9c0093231d8" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="22">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="107.0641" y="237.3795" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Camera 2" ComponentGuid="b776331b-e288-4ef4-9726-3dd69d40bd9f" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="23">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ip_camera.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="107.0641" y="131.4095" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Camera 1" ComponentGuid="017fcb73-37c4-4ba1-b6b3-8edff4522472" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="24">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ip_camera.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="107.0641" y="35.18567" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Camera&#xa;Switch" ComponentGuid="98cb9686-6860-465d-bbac-7600b0e85c17" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="25">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="12.828" y="237.3795" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Camera PC" ComponentGuid="1aefe1d6-42df-4273-aa62-dbe9c2cf803b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="57">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/pc.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="10.828" y="102.90950000000001" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="71" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="24" target="25" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="72" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="23" target="25" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="73" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="22" target="25" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="109" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;entryX=0;entryY=0.25;entryDx=0;entryDy=0;" parent="3" target="25" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="13" y="155" as="sourcePoint"/>
        <Array as="points"/>
      </mxGeometry>
    </mxCell>
    <UserObject SAL="Moderate" label="Access Control Systems (Badges and Door Locks)-Moderate" internalLabel="Access Control Systems (Badges and Door Locks)" ZoneType="Plant System" zone="1" Criticality="Low" id="4">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#e6dbee;swimlaneFillColor=#f2edf6;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="943" y="82" width="378" height="360" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Door&#xa;Lock 2" ComponentGuid="ad0b9d0e-f8fc-4d0e-8b8d-47b92a13e596" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="19">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/door_access_door_control_unit.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="254.8986" y="132.4095" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Door&#xa;Lock 1" ComponentGuid="0fffd8fa-13c7-46ef-8c81-4337f773d836" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="20">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/door_access_door_control_unit.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="254.8986" y="36.18567" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Badge Reader" ComponentGuid="0b06914b-a872-4fd0-9a8c-9f3683b69a7a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="21">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="254.8986" y="229.8795" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Access Control&#xa;Switch" ComponentGuid="a3850587-684f-4b7c-a34a-ceb380df5919" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="28">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="63.46625" y="243.3795" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="RTU" ComponentGuid="2c4c1e99-74f2-47cf-b84b-9b156ed598e0" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="48">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="157.43720000000002" y="238.3795" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Central Badge&#xa;Database" ComponentGuid="bbf90bb2-6176-4e80-bc6d-6cedecc6f252" HasUniqueQuestions="" IPAddress="" Description="this is description&#xa;" Criticality="Moderate" HostName="" parent="4" id="53">
      <mxCell style="whiteSpace=wrap;html=1;labelBackgroundColor=none;image;image=img/cset/emg.svg;" parent="4" vertex="1">
        <mxGeometry x="63.46625" y="36.18567" width="43" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Badge Enrollment&#xa;Station" ComponentGuid="30dd4721-6c31-489a-a60e-31488c8c7502" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="54">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/pc.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="157.43720000000002" y="36.18567" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="74" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="48" target="20" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="75" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="48" target="19" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="76" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="21" target="48" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="104" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="28" target="48" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="105" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="28" target="54" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="106" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="53" target="28" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="dsjeRrVDX3vuCqAbKDFM-113" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.25;exitY=1;exitDx=0;exitDy=0;endArrow=none;strokeColor=#808080;" parent="4" source="28" target="28" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="High" label="Fire Supression-High" internalLabel="Fire Supression" ZoneType="Other" zone="1" Criticality="Low" id="5">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#ece4d7;swimlaneFillColor=#f6f3ed;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="388" y="178" width="182" height="252" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Fire &#xa;Supression SIS" ComponentGuid="bb2652d9-7943-4a08-b84c-470fb0fcdc87" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="18">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/sis.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="11.75751" y="138.3795" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Smoke Alarm" ComponentGuid="54384500-f475-49e3-b26e-a433261c4ec5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="55">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="11.75751" y="32.40953" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Pull Switch" ComponentGuid="5b0052e7-a7fa-45cb-813d-ab0fd133b51f" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="56">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="95.00323" y="32.40953" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="107" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;entryX=0.75;entryY=1;entryDx=0;entryDy=0;exitX=0.75;exitY=0;exitDx=0;exitDy=0;" parent="5" target="55" edge="1" source="18">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="63" y="102" as="sourcePoint"/>
        <mxPoint x="53.296296296296305" y="87.07407407407413" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <mxCell id="108" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;exitX=0.25;exitY=1;exitDx=0;exitDy=0;entryX=0.75;entryY=0;entryDx=0;entryDy=0;" parent="5" source="56" target="18" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="82" y="82" as="sourcePoint"/>
        <mxPoint x="82" y="138" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <UserObject SAL="Moderate" label="Power/Lighting Control Systems-Moderate" internalLabel="Power/Lighting Control Systems" ZoneType="Control System" zone="1" Criticality="Low" id="6">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#d3eef2;swimlaneFillColor=#f2f8f9;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="330" y="783" width="275" height="232" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC-22" ComponentGuid="db43b919-68d1-4d76-b461-e55c338780db" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="32">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="134.7575" y="136.1732" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Power/Lighting&#xa;PC" ComponentGuid="5945ec2d-9147-491f-9d8c-0263fff408b5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="58">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/pc.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="37.89478" y="31.77319" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Power/Lighting&#xa;Switch" ComponentGuid="94e50a7a-82b2-45e1-90ed-a7c86f046e43" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="59">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="134.7575" y="43.27319" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="110" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="32" target="59" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="111" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="58" target="59" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="Moderate" label="Elevator Control System-Moderate" internalLabel="Elevator Control System" ZoneType="Control System" zone="1" Criticality="Low" id="7">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#d3eef2;swimlaneFillColor=#f2f8f9;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="622" y="783" width="238" height="137" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PLC" ComponentGuid="4a87ee24-c0e1-4c6c-acb7-f732958db4fb" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="7" id="31">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="7" vertex="1">
        <mxGeometry x="68.92542" y="31.77319" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject SAL="Moderate" label="Heating, Ventilation, and Air-Conditioning System-Moderate" internalLabel="Heating, Ventilation, and Air-Conditioning System" ZoneType="Other" zone="1" Criticality="Low" id="8">
      <mxCell style="swimlane;zone=1;labelBackgroundColor=none;fillColor=#ece4d7;swimlaneFillColor=#f6f3ed;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="883" y="782" width="387" height="344" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Control Device 1" ComponentGuid="26218cfb-36b7-4ecb-bc22-8b34a0f1ba93" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="8" id="34">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="8" vertex="1">
        <mxGeometry x="104.4372" y="32.77319" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Control Device 2" ComponentGuid="368490d4-026b-4637-b5f1-788be758dbf6" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="8" id="35">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="8" vertex="1">
        <mxGeometry x="104.4372" y="265.67269999999996" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Building Automation System" ComponentGuid="8bb0e08c-b197-469f-a060-6d8bcd1d02a5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="8" id="36">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/building_automation_management_systems.svg;labelBackgroundColor=none;" parent="8" vertex="1">
        <mxGeometry x="104.4372" y="133.6732" width="40" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Chiller Unit" ComponentGuid="e60e9f18-0428-4c8f-b5e8-a4af3ab056dd" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="8" id="41">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=none;" parent="8" vertex="1">
        <mxGeometry x="201.8986" y="22.27319" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Boiler Unit" ComponentGuid="2196eb3e-f7f7-4d15-a76d-dc5820760423" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="8" id="42">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=none;" parent="8" vertex="1">
        <mxGeometry x="201.8986" y="256.67269999999996" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="HVAC Switch" ComponentGuid="b067cdaa-8c79-445f-a8ad-8dc550cfa3cc" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="8" id="43">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="8" vertex="1">
        <mxGeometry x="10.46625" y="32.77319" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-14" ComponentGuid="42c236ff-53e8-47cd-ba1e-ee9659d2009e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="8" id="49">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="8" vertex="1">
        <mxGeometry x="24.466250000000002" y="153.6732" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-14" ComponentGuid="b0907815-f45e-489c-b07c-d41c96d57dc2" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="8" id="50">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="8" vertex="1">
        <mxGeometry x="24.466250000000002" y="271.6727" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="83" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="8" source="34" target="41" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="84" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="8" source="43" target="34" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="85" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="8" source="50" target="35" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="86" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="8" source="49" target="36" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="87" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="8" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="37" y="56" as="sourcePoint"/>
        <mxPoint x="37" y="158" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <mxCell id="88" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="8" source="49" target="50" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="89" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="8" source="35" target="42" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="osXfNHMXeTdumSsDzwq7-118" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.5;exitY=0;exitDx=0;exitDy=0;entryX=0;entryY=0.25;entryDx=0;entryDy=0;endArrow=none;strokeColor=#808080;" parent="8" source="49" target="49" edge="1">
      <mxGeometry relative="1" as="geometry">
        <Array as="points">
          <mxPoint x="35" y="166"/>
        </Array>
      </mxGeometry>
    </mxCell>
    <mxCell id="osXfNHMXeTdumSsDzwq7-119" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.75;exitY=1;exitDx=0;exitDy=0;entryX=0;entryY=0.75;entryDx=0;entryDy=0;endArrow=none;strokeColor=#808080;" parent="8" source="49" target="49" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject label="Web" ComponentGuid="811401bd-9d42-4dbb-aacc-08353035b696" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Web" id="9">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/web.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="16.449338950446275" y="347.35886681579626" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Main &#xa;Firewall" ComponentGuid="4758b26f-f0db-400a-8479-8479bfa75b7b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Main 
&#xa;Firewall" id="17">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="398.3947633483376" y="540.8824186152941" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Main&#xa;IDS" ComponentGuid="473f29cd-21da-4d67-8b6e-b8db9d2ebcc9" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Main
&#xa;IDS" id="26">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="318.6341826579005" y="458.6794723681767" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="ldtP0OuuEyKqfiShxJDW-113" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.5;exitY=0;exitDx=0;exitDy=0;endArrow=none;strokeColor=#808080;" parent="1" source="27" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="353" y="570" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <UserObject label="CON-28" ComponentGuid="a3ea4bda-b761-4f66-af40-d2ce3bf8deee" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="CON-28" id="27">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="340.1341826579005" y="556.3824186152941" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="HVAC&#xa;IDS" ComponentGuid="0eab95f8-17f2-4b88-bcb8-7030ee9758fa" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="HVAC
&#xa;IDS" id="29">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="787.0641099036629" y="666.6959329079011" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="HVAC&#xa;FIrewall" ComponentGuid="fada0d57-855e-4f79-bc8a-812f1e5b0a46" HasUniqueQuestions="true" IPAddress="" Description="" Criticality="" HostName="" internalLabel="HVAC
&#xa;FIrewall" id="30">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="893.4662244115325" y="649.6959329079011" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Switch(s)" ComponentGuid="aa8c7fc2-6b04-4fcb-8a18-108c3a98b4e4" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Switch(s)" id="33">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="496.75750679113435" y="556.3824186152941" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Elevator&#xa;IDS" ComponentGuid="be93484a-f623-4e97-8ddb-0baf3fb1b9b8" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Elevator
&#xa;IDS" id="37">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="599.1645394208691" y="666.6959329079011" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Camera&#xa;IDS" ComponentGuid="48eae710-bdf4-4282-a027-818072e2ad54" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Camera
&#xa;IDS" id="38">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="590.0109469608" y="458.6794723681767" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Access Control&#xa;Firewall" ComponentGuid="ecdcbe1c-d8eb-40db-9f39-e377e52caae8" HasUniqueQuestions="true" IPAddress="" Description="" Criticality="Joe" HostName="" internalLabel="Access Control
&#xa;Firewall" id="39">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="885.4662244115325" y="443.1794723681767" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Access Control&#xa;IDS" ComponentGuid="ced9250c-fc18-4806-9b26-2a603cecfe05" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Access Control
&#xa;IDS" id="40">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="787.0641099036629" y="458.6794723681767" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Camera&#xa;Firewall" ComponentGuid="f30b2701-1048-43c7-98ac-68df8eeac27c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Camera
&#xa;Firewall" id="44">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="688.4254355171845" y="443.1794723681767" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Elevator&#xa;Firewall" ComponentGuid="56f645e3-cf46-4e7b-af59-683a0c7c57a1" HasUniqueQuestions="true" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Elevator
&#xa;Firewall" id="45">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="688.4254355171845" y="649.1959329079011" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="osXfNHMXeTdumSsDzwq7-117" value="" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=none;strokeColor=#808080;" parent="1" source="46" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="527" y="568" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <UserObject label="Fire Supression&#xa;Firewall" ComponentGuid="bcecb056-6796-4f92-be85-16e09d0c1095" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Fire Supression
&#xa;Firewall" id="46">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;align=center;" parent="1" vertex="1">
        <mxGeometry x="494.75750679113435" y="443.1794723681767" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Fire Supression&#xa;IDS" ComponentGuid="2f0ac238-8d63-41be-bf1e-c72247c8e1d6" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Fire Supression
&#xa;IDS" id="47">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="399.8947633483376" y="458.6794723681767" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Power/Lighting&#xa;Firewall" ComponentGuid="053b8015-839f-4310-b20b-f085a94cfd6f" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Power/Lighting
&#xa;Firewall" id="51">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="494.75750679113435" y="649.1959329079011" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Power/Lighting&#xa;IDS" ComponentGuid="df3359d8-888f-4dc1-9bb2-c0bf035cbf22" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="Power/Lighting
&#xa;IDS" id="52">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="399.8947633483376" y="666.6959329079011" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-48" ComponentGuid="25657338-3f2a-4596-b1cb-a48aba84ef31" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="CON-48" id="60">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="712.9254355171845" y="557.8824186152941" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-48" ComponentGuid="9eb1e251-d314-451a-9f73-f7d5d3424b6e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="CON-48" id="61">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="915.4662244115325" y="559.3824186152941" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="62" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="9" target="10" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="65" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="14" target="27" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="70" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;entryX=0.5;entryY=1;entryDx=0;entryDy=0;" parent="1" target="44" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="719" y="558" as="sourcePoint"/>
      </mxGeometry>
    </mxCell>
    <mxCell id="77" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="920" y="494" as="sourcePoint"/>
        <mxPoint x="920" y="559" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <mxCell id="78" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" parent="1" source="46" target="33" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="550" y="493" as="sourcePoint"/>
        <mxPoint x="548" y="557" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <mxCell id="79" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="30" target="61" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="80" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;entryX=0.5;entryY=1;entryDx=0;entryDy=0;" parent="1" target="33" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="527" y="649" as="sourcePoint"/>
        <mxPoint x="521" y="579" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <mxCell id="81" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="17" target="33" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="82" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" target="60" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="723" y="649" as="sourcePoint"/>
      </mxGeometry>
    </mxCell>
    <mxCell id="90" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="30" target="43" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="91" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="30" target="29" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="92" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="27" target="17" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="93" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;entryX=0.5;entryY=1;entryDx=0;entryDy=0;" parent="1" target="26" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="348" y="560" as="sourcePoint"/>
        <Array as="points"/>
      </mxGeometry>
    </mxCell>
    <mxCell id="94" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="47" target="46" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="95" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="46" target="18" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="96" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="38" target="44" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="97" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;exitX=0.75;exitY=0;exitDx=0;exitDy=0;" parent="1" source="44" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="730" y="343" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <mxCell id="98" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="40" target="39" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="99" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="39" target="28" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="100" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="37" target="45" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="101" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="45" target="31" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="102" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="52" target="51" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="103" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="51" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="523" y="780" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <mxCell id="112" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="33" target="60" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="113" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="60" target="61" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="osXfNHMXeTdumSsDzwq7-113" style="edgeStyle=none;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.75;exitY=1;exitDx=0;exitDy=0;endArrow=none;strokeColor=#808080;" parent="1" source="33" target="33" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
  </root>
</mxGraphModel>' WHERE [Id] = 13
UPDATE [dbo].[DIAGRAM_TEMPLATES] SET [Diagram_Markup]=N'<mxGraphModel dx="3554" dy="162" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" value="Main Layer" parent="0"/>
    <UserObject SAL="Low" label="Corporate-Low" internalLabel="Corporate" ZoneType="Corporate" zone="1" Criticality="Low" id="2">
      <mxCell style="swimlane;zone=1;fillColor=#fdf9d9;swimlaneFillColor=#fffef4;labelBackgroundColor=none;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="-2129" y="1534" width="307" height="592" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corporate Firewall" ComponentGuid="28fb94ac-ed32-4d4d-ab2e-269164844032" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="75">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="113.7208" y="33.87488" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corporate IDS" ComponentGuid="4c02b40c-6fa4-47d0-aa6a-0e10d2068170" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="76">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="216.2635" y="162.5922" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="RTR-77" ComponentGuid="83616a59-eacf-4887-b752-e6215dfc2ff1" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="78">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="115.7208" y="265.0913" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corporate Switch" ComponentGuid="f98af6ae-d4d7-4018-9fcb-4dddab8964b5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="79">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="115.7208" y="374.1013" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corporate &#xa;Database Server" ComponentGuid="5624b5aa-e61b-43fd-a0ec-5e361eabfdbb" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="80">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/database_server.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="216.2635" y="480.847" width="43" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corporate  &#xa;RAS" ComponentGuid="d3688806-a75f-496d-a0c3-5e8c8ddcaaff" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="81">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/remote_access_server.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="15.14087" y="480.847" width="34" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-94" ComponentGuid="39b42eed-4234-4204-bc0f-31065927addb" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="110">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="134.7208" y="161.5922" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="188" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="76" target="110" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="189" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="110" target="78" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="190" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="78" target="79" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="191" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="79" target="81" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="192" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="79" target="80" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="217" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="75" target="110" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="Low" label="Guest Network-Low" internalLabel="Guest Network" ZoneType="External DMZ" zone="1" Criticality="Low" id="3">
      <mxCell style="swimlane;zone=1;fillColor=#d3f1df;swimlaneFillColor=#ebf4ef;labelBackgroundColor=none;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="-2478" y="1533" width="319" height="385" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Guest &#xa;View Stations" ComponentGuid="c5b1b9e1-9559-4f21-961b-1e47a45a6591" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="77">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/pc.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="19.233890000000002" y="138.5922" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Guest Kiosks" ComponentGuid="071f526a-723c-4e90-b1b6-b1ef0f3467cb" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="89">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/public_kiosk.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="111.06396" y="138.5922" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Guest Wireless &#xa;Router" ComponentGuid="dfc355d8-5eab-42c6-9931-9880c6435f7a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="90">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/wireless_router.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="202.0449" y="138.5922" width="60" height="38" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Guest Switch" ComponentGuid="db9f9b34-d745-4bb7-828f-de5adf7258ab" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="106">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="201.0449" y="55.87488" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-96" ComponentGuid="11a92101-0f33-41df-9f39-5b69870b3acc" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="107">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="39.23389" y="58.87488" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-96" ComponentGuid="01d58f9d-ce10-421c-86fa-946c07857966" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="108">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="121.064" y="58.87488" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Wireless  &#xa;Devices" ComponentGuid="98868480-a44c-4773-8bea-3d517d270cb2" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="109">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/handheld_wireless_device.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="215.0449" y="266.0913" width="34" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="165" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="77" target="107" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="209" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="89" target="108" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="211" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="107" target="108" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="212" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="90" target="106" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="213" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="108" target="106" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="214" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="90" target="109" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="Moderate" label="Main Hospital Network-Moderate" internalLabel="Main Hospital Network" ZoneType="Other" zone="1" Criticality="Low" id="4">
      <mxCell style="swimlane;zone=1;fillColor=#ece4d7;swimlaneFillColor=#f6f3ed;labelBackgroundColor=none;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="-1810.5" y="766" width="1954" height="1381" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="WMTS Wireless" ComponentGuid="c9f2d081-53c1-4d1a-80e7-92b9263acf5f" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="5">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/wireless_network.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1144.815" y="150.0251" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="802.11" ComponentGuid="7caa567e-a99a-4e0b-a5e2-3612dd80a953" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="6">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/wireless_network.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1242.87" y="150.0251" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Building Automation  &#xa;Systems" ComponentGuid="20f29a87-49a3-4060-b2b3-b86c12ac557d" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="7">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/building_automation_management_systems.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1452.647" y="822.8749" width="40" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Radiology &#xa;Ultrasound" ComponentGuid="f979571d-0c06-4308-974b-dbd9678f701c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="8">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/imaging_modalities_and_equipment.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="680.095" y="472.8937" width="45" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Real Time  &#xa;Location System" ComponentGuid="4980eb30-2570-417f-8842-9d6376e0eb5c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="9">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/real_time_location_system.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="82.1379" y="926.5922" width="60" height="52" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Web Server" ComponentGuid="a999e48c-67b3-4293-a9e1-93d4b3b712ff" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="10">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/web_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="956.0027" y="536.2374" width="45" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="ECG Data  &#xa;Management" ComponentGuid="3bd969ed-d517-4ee3-b0a8-b999d1f4f291" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="11">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/database_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1152.815" y="530.2374" width="43" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Admission/Discharge/ &#xa;Transfer Server" ComponentGuid="e2ca77f5-b767-4b86-8088-35dcbc4a7a4d" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="12">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="866.4598" y="537.2374" width="23" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-92" ComponentGuid="84851aa6-e142-4556-ba5e-9f3c7cb1de53" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="13">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="970.0027" y="650.1525" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Imaging VLAN &#xa;Switch" ComponentGuid="df25d308-1e5a-4de3-b9d4-f3a0f0c66839" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="14">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/vlan_switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="602.4597" y="581.2374" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Two Way Cameras" ComponentGuid="311266b7-5ca5-484b-8fa6-7746df92d368" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="15">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ip_camera.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="263.3282" y="365.0938" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Anethesia &#xa;VLAN Switch" ComponentGuid="3135a6f6-7d3d-41da-bde5-f8b7484c7941" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="16">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/vlan_switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="423.0372" y="822.8749" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="A Series  &#xa;Anethesia" ComponentGuid="a2604a0e-b023-4400-b7f2-6553a3f05734" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="17">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="440.0372" y="1054.091" width="23" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Central Station" ComponentGuid="e0ea656b-4f30-4703-a13e-67204d0b6617" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="20">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/pc.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1034.709" y="365.0938" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="View Station" ComponentGuid="0c0cf4af-e554-4432-9652-7c5eba92d344" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="21">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/pc.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1034.709" y="260.7068" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Work Station" ComponentGuid="2c67a790-6a71-4603-938d-7ddf680ed2d5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="22">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/pc.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1034.709" y="150.0251" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Triage  &#xa;Monitors" ComponentGuid="cd942077-668f-415a-9617-2f5b1777cbe2" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="24">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/physiological_monitoring_system.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="845.4598" y="1093.101" width="60" height="47" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Emergency &#xa;Department Monitors" ComponentGuid="e80ead49-1fbb-414c-bdae-3049ce4170f8" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="25">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/physiological_monitoring_system.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1352.927" y="472.8937" width="60" height="47" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Vital Signs &#xa;CS Server" ComponentGuid="56dd30cc-6c2d-4c38-aad5-54700c24b269" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="26">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="865.4598" y="822.8749" width="23" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="AIMS Server" ComponentGuid="c0b31a31-f8c6-47c6-b334-4c1d897a6458" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="27">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="441.0372" y="926.5922" width="23" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PACS" ComponentGuid="a27cc9b6-1131-40d7-a5e8-447a14f30512" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="28">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/imaging_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="428.0372" y="567.2374" width="47" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Alarm Paging &#xa;System" ComponentGuid="11dddc9b-961f-477a-a759-a10b46c9966e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="31">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1042.709" y="472.8937" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="OR &#xa;Ultrasound" ComponentGuid="da3a24f0-5356-431f-8b42-a82a70d2f3b4" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="32">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/imaging_modalities_and_equipment.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="509.9202" y="472.8937" width="45" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="ER Ultrasound" ComponentGuid="d4b56e4f-a227-4bfe-9f1b-68abc3788eea" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="33">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/imaging_modalities_and_equipment.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="608.552" y="472.8937" width="45" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Redundant &#xa;Hospital Switch" ComponentGuid="46c03838-61b4-4313-9b43-1178110432eb" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="34">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1352.927" y="647.1525" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Recovery  &#xa;Monitors" ComponentGuid="75c0a311-e9d1-4438-849c-ce7f47025693" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="35">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/physiological_monitoring_system.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="760.8279" y="1092.101" width="60" height="47" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Stepdown  &#xa;Monitors" ComponentGuid="394cfa25-7f1b-42b2-827a-7a817d8acb5f" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="36">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/physiological_monitoring_system.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="946.0027" y="1092.101" width="60" height="47" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="PACS Consoles" ComponentGuid="609ed9e4-237e-41f9-bc99-b37b677fe274" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="37">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/pc.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="420.1295" y="461.8937" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Operating Room  &#xa;Anethesia Machines" ComponentGuid="3b06131b-d92a-44bd-9e38-e19e2d4d029f" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="38">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="425.0372" y="1163.101" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Local eICU" ComponentGuid="3419b079-a677-4cd7-bcfe-45f2378f76d3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="39">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="110.2302" y="477.8937" width="23" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Stepdown &#xa;Monitors" ComponentGuid="b66a99a4-1eff-4006-89ed-13ffe86aee45" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="40">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/physiological_monitoring_system.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="680.095" y="926.5922" width="60" height="47" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="e-Gateway" ComponentGuid="c9a707bf-4d0c-474a-a299-562166ec90a0" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="41">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="599.3066" y="822.8749" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Recovery  &#xa;Monitors" ComponentGuid="fb2c80ef-59bf-42b8-b019-8b2f6516aebe" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="42">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/physiological_monitoring_system.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1034.709" y="44.42462" width="60" height="47" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Stepdown &#xa;Monitors" ComponentGuid="86f737af-f609-4799-92f3-f7652159f583" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="43">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/physiological_monitoring_system.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1144.815" y="44.42462" width="60" height="47" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Emergency &#xa;Department Monitors" ComponentGuid="9659ad36-6a88-4087-a280-116f015096fe" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="44">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/physiological_monitoring_system.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1242.87" y="44.42462" width="60" height="47" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Intensive Care &#xa;Unit Monitors" ComponentGuid="f805d012-56d2-4d2e-bccc-4d0b2797e5c6" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="45">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/physiological_monitoring_system.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1352.927" y="44.42462" width="60" height="47" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Intensive Care  &#xa;Unit Monitors" ComponentGuid="3fcef8e2-af63-455c-a6f7-4ae7bc6998c9" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="46">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/physiological_monitoring_system.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1352.927" y="365.0938" width="60" height="47" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Operating &#xa;Room Monitors" ComponentGuid="e7f70c98-8fdb-4d53-a96d-83a76a27ed0c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="47">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/physiological_monitoring_system.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1352.927" y="260.7068" width="60" height="47" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Recovery Monitors" ComponentGuid="92af7833-a5d8-4763-a993-96a9c6a2e16c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="48">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/physiological_monitoring_system.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1352.927" y="150.0251" width="60" height="47" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Main Server" ComponentGuid="842a96e0-17aa-46a2-8b62-1d82956520cb" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="49">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1144.815" y="260.7068" width="23" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Electronic  &#xa;Security System" ComponentGuid="30d155bb-4fda-433c-bc3b-aa600e289004" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="50">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/electronic_security_system.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1572.22" y="1163.101" width="45" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Video Monitors" ComponentGuid="aa4ba959-a42f-472e-b955-40a2d73e476e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="51">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/interactive_television_system.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="263.3282" y="564.2374" width="60" height="46" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Microphones" ComponentGuid="72812858-7339-4d57-8b6d-4e0cf46405e5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="52">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="263.3282" y="478.8937" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Smart Alarms" ComponentGuid="0002f19a-a25b-4141-a980-f5747c97b9e4" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="53">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="263.3282" y="260.7068" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="eICU VLAN &#xa;Switch" ComponentGuid="0b147d85-5cf9-4a75-afe3-7b620d5b1253" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="55">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/vlan_switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="93.1379" y="575.2374" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Direct Line  &#xa;Telephones" ComponentGuid="0d35269f-4769-4ba0-84c1-2c7ba302987c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="56">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ip_phone.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="94.2302" y="260.7068" width="60" height="57" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Wireless Router" ComponentGuid="19aaa9bf-53cf-4f28-ba9d-c92aaa1c6958" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="57">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/wireless_router.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="845.4598" y="970.0909999999999" width="60" height="38" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Main Hospital  &#xa;Switch" ComponentGuid="ffe32b40-99ee-4f6b-a203-5fdcf2ccdab1" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="58">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1144.815" y="647.1525" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Fire Suppression" ComponentGuid="76dda83e-ad75-4ba4-bfee-a943eda4ec3c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="59">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/sis.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1774.22" y="1163.101" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="e-Gateway" ComponentGuid="9c05c600-4e63-42b7-ad8c-4d49882586a7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="60">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1242.87" y="472.8937" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Recovery &#xa;Monitors" ComponentGuid="ba43cd3b-7778-4d33-85ef-cc34cd19f9fa" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="61">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/physiological_monitoring_system.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="595.3066" y="926.5922" width="60" height="47" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="HVAC VLAN" ComponentGuid="80850797-991b-454a-bcf0-f90fef9ec546" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="62">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/vlan_switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1442.647" y="1054.091" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Physical Badging / &#xa;Access Control RTU" ComponentGuid="7d1e054f-3e69-4b64-be3c-6a7df407f0b3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="63">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rtu.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1563.22" y="1269.847" width="60" height="33" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Power/Lighting &#xa;VLAN" ComponentGuid="168d7862-3ae5-4722-a864-461197b0f337" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="64">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/vlan_switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1774.22" y="636.1525" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Security VLAN" ComponentGuid="02da6491-dd47-46a4-b373-858e6f03756b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="65">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/vlan_switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1564.22" y="1054.091" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Elevator Control  &#xa;System PLC" ComponentGuid="f808ea1b-ad27-4140-8fef-f4d2962685c1" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="66">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1564.22" y="644.1525" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Control Device" ComponentGuid="d9b07aea-a1dc-4a75-914e-5cb82a7f13ae" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="67">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1442.647" y="1163.101" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Door Locks" ComponentGuid="bfef182d-f35f-4e82-978e-125d2f546f36" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="68">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/door_access_door_control_unit.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1438.647" y="1258.847" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Smoke Alarms" ComponentGuid="0c3ba86d-108d-43ee-9f74-7a93d278a3ec" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="69">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1871.62" y="1168.101" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Pull Switch" ComponentGuid="0d80df53-1f19-4082-8255-a053aae89ec0" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="70">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1780.22" y="1269.847" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Lighting PLC" ComponentGuid="fdee63c5-7912-45d4-9f26-7d4f2d868a53" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="71">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/plc.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1774.22" y="822.8749" width="60" height="29" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Security Cameras" ComponentGuid="05a4563c-fd20-46b1-aad6-aea26401160a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="72">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ip_camera.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1672.02" y="1168.101" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Transmitter Tags" ComponentGuid="5166ade8-91b3-492b-8eb2-487568afc085" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="73">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/rfid_transmitter.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="83.1379" y="1054.091" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="EMS Hardware" ComponentGuid="2cf50e1d-4de3-40ba-ad04-4a31413d739e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="74">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/emergency_medical_service_communications_hardware.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1144.815" y="822.8749" width="60" height="59" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Link Encryption" ComponentGuid="fb0e8ceb-00d0-475f-9e83-ad3d5a6b1e4e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="82">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/link_encryption.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="17.49854" y="478.8937" width="48" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="RTLS VLAN Switch" ComponentGuid="f990f87a-a456-44f2-962e-ad61b91afee2" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="83">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/vlan_switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="97.1379" y="822.8749" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="EMS Monitors" ComponentGuid="c4efc166-7604-4c63-a73b-d5d137170837" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="84">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/unknown.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1242.87" y="926.5922" width="50" height="50" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="EMR/EHR  &#xa;System" ComponentGuid="065da23c-f535-4e20-a8bf-4650a119532b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="85">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="287.3282" y="926.5922" width="23" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="EMS Tablets" ComponentGuid="b3b60f2d-8c7c-420f-a09a-b2dac0e1da0c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="86">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/handheld_wireless_device.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1154.815" y="926.5922" width="34" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="EMR Database  &#xa;Servers" ComponentGuid="f8eb3ece-71aa-4d5f-a497-47fbc06c93b0" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="87">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/database_server.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="279.3282" y="1054.091" width="43" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="EMS Cameras" ComponentGuid="1bec3b03-ca09-40d5-a8a0-bd7f632fef94" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="88">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ip_camera.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1034.709" y="926.5922" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-90" ComponentGuid="a774ce5f-8362-4c46-aa01-008f027bbe1b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="91">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="115" y="651" width="20" height="21" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-90" ComponentGuid="7d763b30-0bfe-4acf-8fe7-7b669e9c4460" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="92">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="287.3282" y="651.1525" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-90" ComponentGuid="c518998a-f23b-4bc8-affb-67fc2aa603be" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="93">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="442.0372" y="651.1525" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-90" ComponentGuid="1f42e8c7-11fd-445f-8051-20031f8ae702" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="94">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="621.3066" y="651.1525" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-90" ComponentGuid="b981b92a-0116-4dc0-b0c5-6261f7b48f6a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="95">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="869.4598" y="651.1525" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="BAS Main Switch" ComponentGuid="b7a8b5fa-a126-4fec-b8dc-880a52da87e8" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="96">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1442.647" y="926.5922" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-92" ComponentGuid="6905ccad-74d4-4ae7-97d6-eeacd69c54cd" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="97">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1462.647" y="649.1525" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="EMR/EHR &#xa;VLAN Switch" ComponentGuid="2dbd40d3-4c7d-49c4-894c-a48039646ea5" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="100">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/vlan_switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="268.3282" y="822.8749" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Fire Supression &#xa;VLAN" ComponentGuid="40265932-32df-4fa1-bb0a-6fc8c23e6b6c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="101">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/vlan_switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1774.22" y="1054.091" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-94" ComponentGuid="75ad6c36-8e53-422d-9c96-65d69f53fc4a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="102">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1585.22" y="929.5922" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Elevator VLAN" ComponentGuid="52edea2a-8761-4626-ac0b-08da2d80d50a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="103">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/vlan_switch.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1564.22" y="822.8749" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-95" ComponentGuid="d3569da5-1d1d-4cc0-a06c-877f7cc29362" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="105">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="1266.87" y="649.1525" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="113" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="105" target="60" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="114" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="11" target="58" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="115" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="12" target="95" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="117" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="57" target="24" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="118" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="27" target="16" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="119" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="49" target="5" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="120" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="49" target="6" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="121" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="22" target="49" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="122" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="21" target="49" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="123" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="20" target="49" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="126" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="35" target="57" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="127" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="36" target="57" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="128" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="14" target="8" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="129" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="14" target="32" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="130" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="14" target="33" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="131" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="74" target="58" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="132" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="57" target="26" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="133" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="26" target="95" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="134" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="5" target="42" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="135" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="5" target="43" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="136" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="6" target="44" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="137" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="6" target="45" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="138" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="25" target="49" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="139" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="46" target="49" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="140" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="47" target="49" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="141" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="48" target="49" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="142" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="39" target="15" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="143" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="39" target="51" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="144" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="52" target="39" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="145" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="53" target="39" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="147" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="56" target="39" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="148" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="27" target="17" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="149" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="60" target="49" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="150" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="65" target="50" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="151" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="62" target="67" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="152" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="62" target="96" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="153" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="63" target="68" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="154" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="59" target="69" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="155" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="59" target="70" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="156" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="71" target="64" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="157" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="50" target="72" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="158" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="63" target="50" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="159" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="39" target="55" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="160" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="73" target="9" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="161" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="105" target="58" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="162" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="11" target="49" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="163" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="41" target="94" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="164" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="82" target="39" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="166" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="9" edge="1">
      <mxGeometry relative="1" as="geometry">
        <mxPoint x="109" y="834.5" as="targetPoint"/>
      </mxGeometry>
    </mxCell>
    <mxCell id="167" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="84" target="74" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="168" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="86" target="74" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="169" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="87" target="85" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="170" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="88" target="74" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="171" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="14" target="94" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="172" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="41" target="40" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="173" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="41" target="61" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="174" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="20" target="31" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="176" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="91" target="55" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="179" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="91" target="92" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="180" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="83" target="91" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="181" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="85" target="100" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="182" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="92" target="93" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="183" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="93" target="16" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="184" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="92" target="100" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="185" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="93" target="94" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="186" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="94" target="95" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="187" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="95" target="13" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="195" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="13" target="58" edge="1">
      <mxGeometry relative="1" as="geometry"/>' WHERE [Id] = 15
UPDATE [dbo].[DIAGRAM_TEMPLATES] SET [Diagram_Markup]=N'<mxGraphModel dx="1954" dy="962" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="0" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
  <root>
    <mxCell id="0"/>
    <mxCell id="1" value="Main Layer" parent="0"/>
    <UserObject SAL="Low" label="Corporate-Low" internalLabel="Corporate" ZoneType="Corporate" zone="1" Criticality="Low" id="2">
      <mxCell style="swimlane;zone=1;fillColor=#fdf9d9;swimlaneFillColor=#fffef4;labelBackgroundColor=none;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="-776" y="-96" width="295" height="547" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp. IDS" ComponentGuid="ef3e4b89-35b9-42a5-a427-c02670092b69" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="29">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="198.0337" y="158.5333" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="External Firewall" ComponentGuid="6124f548-057d-47e4-ac64-f7947e1cb375" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="33">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="97.62115" y="34.44792" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp. Router" ComponentGuid="4696030a-23f5-47cd-9805-9fbf9ec18bd7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="37">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="97.62115" y="244.6882" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp. Switch" ComponentGuid="4c1bc39d-5ae3-4a4c-9b94-a6597d479006" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="38">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="97.62115" y="347.0931" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp. Server" ComponentGuid="7bc87baf-5405-4979-9e1a-c3b654b7638a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="39">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/application_server.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="21.16364" y="442.5701" width="44" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-34" ComponentGuid="4658b897-b5ed-40fe-b8ec-ae408a267684" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="40">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="118.6212" y="157.5333" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Corp. Database &#xa;Server" ComponentGuid="b3651e44-d5f3-4be7-9b51-5cc2aafb8b47" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="2" id="41">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/database_server.svg;labelBackgroundColor=none;" parent="2" vertex="1">
        <mxGeometry x="198.0337" y="432.5" width="43" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="80" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="38" target="37" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="81" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="40" target="29" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="82" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="40" target="33" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="83" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="40" target="37" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="84" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="39" target="38" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="85" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="2" source="41" target="38" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="Moderate" label="Main Radio Network-Moderate" internalLabel="Main Radio Network" ZoneType="Other" zone="1" Criticality="Low" id="3">
      <mxCell style="swimlane;zone=1;fillColor=#ece4d7;swimlaneFillColor=#f6f3ed;labelBackgroundColor=none;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="-467" y="-300" width="979" height="564" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Core LAN Switch" ComponentGuid="89f8d360-c82a-480b-a722-158ac7d7b1ae" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="7">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="369.1011" y="255.4479" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Main Firewall" ComponentGuid="ef25e68a-f70f-4232-8066-97b1d21eb933" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="8">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="902.2955" y="241.4479" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Microwave  &#xa;Backhaul" ComponentGuid="747e68a7-ba15-4f6b-9c4c-19e4afe7b1c9" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="9">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/microwave_backhaul.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="638.7455" y="38.66666" width="53" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Gateway &#xa;Router/Relay  &#xa;Panel" ComponentGuid="e8846037-f0b1-4754-ad9d-936635be8729" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="10">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/relay_panel.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="369.1011" y="335.5333000000002" width="60" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Exit &#xa;Router/Relay  &#xa;Panel" ComponentGuid="2eba4bf0-9331-4e0e-850a-4234e9db3e10" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="11">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/relay_panel.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="252.0622" y="335.5333000000002" width="60" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Core &#xa;Router/Relay  &#xa;Panel" ComponentGuid="0f9e2362-1538-4434-9fc8-df1832ef7f6d" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="12">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/relay_panel.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="133.6706" y="335.5333000000002" width="60" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Redundant Switch" ComponentGuid="fa3dc760-6a5d-4326-88fc-d10403a47275" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="15">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="476.4817" y="255.4479000000001" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Main IDS" ComponentGuid="63094d4e-1b49-48eb-9e13-08820f87982e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="16">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="900.2955" y="378.53329999999994" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Gateway" ComponentGuid="e64a9f4b-99e0-4c75-9da0-76fd8b278eae" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="18">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/router.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="135.6706" y="448.6882" width="60" height="25" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Audio Switch" ComponentGuid="fb823b6a-3c33-42df-9e20-2a989631b7c6" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="24">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/audio_switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="369.1011" y="180.1833" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Backhaul  &#xa;Switch" ComponentGuid="d8071858-4825-45c9-9004-38d8a7420388" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="25">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/switch.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="369.1011" y="448.6882" width="60" height="23" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Microwave Backhaul &#xa;LAN (T1)" ComponentGuid="d676a4f2-082c-4b0f-ba0d-6a61ab1785f3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="26">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/microwave_backhaul.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="29.74554" y="38.66666" width="53" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Main Dispatch &#xa;Console Site" ComponentGuid="accba69b-2c8e-424b-8515-607969cb58bf" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="28">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/dispatch_console.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="376.1011" y="38.66666" width="46" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="System Printer" ComponentGuid="03cef26c-35b2-4461-af15-b05ac697963e" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="32">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/network_printer.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="776.7678" y="341.53329999999994" width="60" height="54" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Virtual Management  &#xa;Server" ComponentGuid="37d67481-0bc3-4e05-b0ad-5c4c0dcd7554" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="35">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/virtual_machine_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="589.5289" y="349.5332999999999" width="60" height="46" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="VMS Storage  &#xa;Service" ComponentGuid="673b24b8-71fb-4409-b764-29b9a548b398" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="36">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/database_server.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="697.5233" y="342.53329999999994" width="43" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-38" ComponentGuid="e678d11b-cb44-46d8-837a-d4afe8ad78db" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="46">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="152.6706" y="255.4479000000001" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-38" ComponentGuid="be29d5ba-0c11-4db1-858c-0ba0aad43786" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="47">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="45.42889" y="451.6882000000001" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-38" ComponentGuid="79372909-60f1-4920-a706-9447f511b629" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="48">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="797.7678" y="255.44790000000012" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-38" ComponentGuid="0171e7e9-4ed5-4949-b611-2799d9ca99d2" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="49">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="708.5233" y="255.44789999999995" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-38" ComponentGuid="ecf9481a-8e6b-4e50-ae0d-b98003108bbf" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="50">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="608.5289" y="255.44790000000003" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-38" ComponentGuid="aa9d446c-1de1-467e-8edb-b8cf0fddd83a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="51">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="273.0622" y="448.6882000000001" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-38" ComponentGuid="ed3899d2-e00d-4cd6-9fd2-3707b3d139cb" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="52">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="273.0622" y="255.44790000000017" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="CON-38" ComponentGuid="288c758b-58de-4451-bcc8-96c6bfb6fabf" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="3" id="53">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/connector.svg;labelBackgroundColor=none;" parent="3" vertex="1">
        <mxGeometry x="920.2955" y="57.66667" width="20" height="20" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="56" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="16" target="8" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="63" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="10" target="7" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="64" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="12" target="18" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="67" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="51" target="25" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="68" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="46" target="12" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="69" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="26" target="28" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="70" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="28" target="9" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="71" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="28" target="24" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="72" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="24" target="7" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="73" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="9" target="53" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="74" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="15" target="50" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="77" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="32" target="48" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="78" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="36" target="35" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="79" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="36" target="49" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="94" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="46" target="52" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="95" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="26" target="47" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="96" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="15" target="7" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="97" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="48" target="8" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="98" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="49" target="48" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="99" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="49" target="50" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="100" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="35" target="50" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="101" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="51" target="11" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="102" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="52" target="7" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="103" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="11" target="52" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="104" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="10" target="25" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="105" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="53" target="8" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="111" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="47" target="18" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="112" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="3" source="51" target="18" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="Moderate" label="Moose County-Moderate" internalLabel="Moose County" ZoneType="Other" zone="1" Criticality="Low" id="4">
      <mxCell style="swimlane;zone=1;fillColor=#ece4d7;swimlaneFillColor=#f6f3ed;labelBackgroundColor=none;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="527" y="-298" width="195" height="252" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Moose  &#xa;Master Site" ComponentGuid="2fb67be1-0b3b-4742-906c-8eb09300fae3" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="27">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/master_site.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="103.2016" y="137.1833" width="52" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Moose  &#xa;Firewall" ComponentGuid="0c8fec68-1812-4f87-b826-2b4bb104ad74" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="30">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="9.92334" y="140.1833" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Moose  &#xa;IDS" ComponentGuid="e0758619-ff61-46c3-a4ee-fd16c6e8b3f0" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="4" id="43">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="4" vertex="1">
        <mxGeometry x="9.92334" y="33.53333" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="88" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="30" target="43" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="89" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="4" source="27" target="30" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="Moderate" label="Squirrel County-Moderate" internalLabel="Squirrel County" ZoneType="Other" zone="1" Criticality="Low" id="5">
      <mxCell style="swimlane;zone=1;fillColor=#ece4d7;swimlaneFillColor=#f6f3ed;labelBackgroundColor=none;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="525" y="2" width="198" height="252" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Squirrel  &#xa;Firewall" ComponentGuid="83bbd3a1-46d0-46c6-8f99-c68946155d13" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="17">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="11.92334" y="146.6882" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Squirrel  &#xa;IDS" ComponentGuid="4da00b4e-9ba6-4993-b4ac-6e1972f42356" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="31">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="11.92334" y="33.53333" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Squirrel &#xa;Master Site" ComponentGuid="3301819b-04ef-4dd5-a367-c26406230f0c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="5" id="44">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/master_site.svg;labelBackgroundColor=none;" parent="5" vertex="1">
        <mxGeometry x="105.2016" y="142.6882" width="52" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="75" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="31" target="17" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="91" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="5" source="44" target="17" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject SAL="Moderate" label="External Radio-Moderate" internalLabel="External Radio" ZoneType="Other" zone="1" Criticality="Low" id="6">
      <mxCell style="swimlane;zone=1;fillColor=#ece4d7;swimlaneFillColor=#f6f3ed;labelBackgroundColor=none;" parent="1" vertex="1" connectable="0">
        <mxGeometry x="-377" y="281" width="486" height="455" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Microwave Backhaul &#xa;TDM T1 " ComponentGuid="301edd77-8bdd-4200-a596-5af400fcfc51" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="13">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/microwave_backhaul.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="385.4817" y="342.6278" width="53" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Microwave Backhaul &#xa;TDM T1 " ComponentGuid="acd694df-5de5-4165-b271-31bf64da301b" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="14">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/microwave_backhaul.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="37.67056" y="139.0167" width="53" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Legacy  &#xa;Radio Site" ComponentGuid="895d99f1-5eb6-4016-847f-e8c8a44c84e4" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="19">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/radio_site.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="45.67056" y="342.6278" width="40" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Fire Subscriber  &#xa;Radio" ComponentGuid="1827a620-3686-48b9-96ec-18d64f0c8cbf" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="20">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/subscriber_radio.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="158.0622" y="361.6278" width="60" height="28" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="P25  &#xa;Radio Site" ComponentGuid="fb7b4f0e-5e16-40ce-8028-6b48462d87bf" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="21">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/radio_site.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="292.1011" y="343.6278" width="40" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Remote Dispatch &#xa;Console Site" ComponentGuid="6df72e81-2f73-4049-9b0d-03a04dd8bef4" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="22">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/dispatch_console.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="385.4817" y="139.0167" width="46" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Ethernet  &#xa;Backhaul" ComponentGuid="15098f59-818f-4bbb-aace-51214db3ab6c" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="23">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ethernet_backhaul.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="279.1011" y="139.0167" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="External Radio &#xa;Firewall" ComponentGuid="59fb1c95-8c6d-4900-aea9-dbf9c60004b2" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="42">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="44.67056" y="36.44791" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="Police Subscriber &#xa;Radio" ComponentGuid="0855646d-d41e-4dec-877a-2362c2e941e6" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="45">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/subscriber_radio.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="158.0622" y="243.0278" width="60" height="28" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="External Radio &#xa;IDS" ComponentGuid="540d886e-9f68-47d2-a610-6f43cd7def3a" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="54">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/ids.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="158.0622" y="52.53333" width="60" height="17" as="geometry"/>
      </mxCell>
    </UserObject>
    <UserObject label="External Radio &#xa;Firewall" ComponentGuid="3cbd13a4-d289-4f4d-91d0-13d182bf0013" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" parent="6" id="55">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/firewall.svg;labelBackgroundColor=none;" parent="6" vertex="1">
        <mxGeometry x="278.1011" y="34.44791" width="60" height="51" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="57" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="42" target="14" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="58" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="14" target="19" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="59" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="20" target="19" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="60" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="21" target="20" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="61" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="22" target="13" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="62" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="21" target="13" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="65" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="23" target="22" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="66" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="23" target="21" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="92" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="19" target="45" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="93" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="45" target="21" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="107" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="54" target="42" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="109" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="54" target="55" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="110" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="6" source="23" target="55" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <UserObject label="WEB" ComponentGuid="38f5bcfa-cf2d-4b7e-9195-1a13311537b7" HasUniqueQuestions="" IPAddress="" Description="" Criticality="" HostName="" internalLabel="WEB" id="34">
      <mxCell style="whiteSpace=wrap;html=1;image;image=img/cset/web.svg;labelBackgroundColor=none;" parent="1" vertex="1">
        <mxGeometry x="-861.90209039548" y="-64.55208333333326" width="60" height="60" as="geometry"/>
      </mxCell>
    </UserObject>
    <mxCell id="76" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="17" target="8" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="86" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="46" target="33" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="87" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="34" target="33" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="90" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="8" target="30" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="106" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="42" target="18" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
    <mxCell id="108" style="rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#808080;strokeWidth=1;endArrow=none;labelBackgroundColor=none;" parent="1" source="55" target="25" edge="1">
      <mxGeometry relative="1" as="geometry"/>
    </mxCell>
  </root>
</mxGraphModel>' WHERE [Id] = 16
PRINT(N'Operation applied to 15 rows out of 15')

PRINT(N'Add rows to [dbo].[MATURITY_REFERENCE_TEXT]')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1308, 1, N'<p class="p1"><font size="3">Establish a process to declare incidents. Events that exit the triage process warranting more attention&#160;<span>may be referred to additional analysis processes for resolution, or declared as an incident and&#160;</span><span>subsequently referred to incident response processes for resolution. These events may be declared as&#160;</span><span>incidents during triage, through further event analysis, through the application of incident declaration&#160;</span><span>criteria, or during the development of response strategies.</span></font></p><p class="p2"><font size="3">Follow an established process to declare incidents. Incident declaration defines the point at which the&#160;<span>organization has established that an incident has occurred, is occurring, or is imminent, and will need&#160;</span><span>to be handled and responded to. The time from event detection to incident declaration may be&#160;</span><span>immediate, requiring little additional review and analysis. In other cases, incident declaration requires&#160;</span><span>more thoughtful analysis.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1309, 1, N'<p class="p1"><font size="3">Establish incident declaration criteria for use in guiding when to declare an incident. To guide the&#160;<span>organization in determining when to declare an incident (particularly if incident declaration is not&#160;</span><span>immediately apparent), the organization must define incident declaration criteria.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1310, 1, N'<p class="p1"><font size="3">Develop an incident escalation process. The incident escalation process should consider the type and&#160;<span>extent of incident and the appropriate stakeholders. Incidents that the organization has declared and&#160;</span><span>that require an organizational response must be escalated to those stakeholders who can implement,&#160;</span><span>manage, and bring to closure an appropriate and timely solution. The organization must establish&#160;</span><span>processes to ensure that incidents are referred to the appropriate stakeholders, because failure to do&#160;</span><span>so will impede the organization''s response and may increase the impact on the organization. Incidents&#160;</span><span>should not be handled on a first-in, first-out basis. Instead, organizations should establish written&#160;</span><span>guidelines that outline how quickly the team must respond to the incident and what actions should be&#160;</span><span>performed, based on relevant factors such as the impact of the incident, and the likely recoverability&#160;</span><span>from the incident.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1311, 1, N'<p class="p1"><font size="3">Incident analysis is primarily focused on helping the organization determine an appropriate response to&#160;<span>a declared incident by examining its underlying causes and actions as well as the effects of the&#160;</span><span>underlying event(s). Incident analysis should be focused on properly defining the underlying problem,&#160;</span><span>condition, or issue and in helping the organization prepare the most appropriate and timely response to&#160;</span><span>the incident.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1312, 1, N'<p class="p1"><font size="3">Correlating activity across incidents can determine any interrelations, patterns, common intruder&#160;<span>signatures, common targets, or exploitation of common vulnerabilities.</span></font></p><p class="p2"><font size="3">Incident correlation:</font></p><p class="p3"></p><ul><li><font size="3">broadens the view of the nature, scope, and impact of malicious activity.</font></li><li><font size="3">identifies relationships and interdependencies that can help develop and implement&#160;<span>comprehensive solutions.</span></font></li></ul><p></p><p class="p2"><font size="3">Types of information that can be correlated include:</font></p><p class="p2"></p><ul><li><span><font size="3">IP addresses, hostnames, ports, protocols, and services</font></span></li><li><font size="3">targeted applications, OSs, organizational sectors, site names, and business functions</font></li><li><font size="3">common attacks and exploits</font></li></ul><p></p><p class="p3"><font size="3">Incident correlation can identify where activity is more widespread than originally thought and identify&#160;<span>any relationships among malicious attacks, compromises, and exploited vulnerabilities. Open event&#160;</span><span>reports may correlate to the incident under analysis and provide additional information that is useful in&#160;</span><span>developing an appropriate response. Reviewing documentation on previously declared incidents may&#160;</span><span>inform the development of a response action plan, particularly if significant organizational (and&#160;</span><span>external) coordination is required.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1313, 1, N'<p class="p1"><font size="3">Identify relevant analysis tools, techniques, and activities that the organization uses to analyze&#160;<span>incidents and develop appropriate responses. Provide appropriate levels of training for incident&#160;</span><span>management staff on analysis tools and techniques.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1314, 1, N'<p class="p1"><font size="3">Impact analysis can help determine the breadth and severity of an incident. Incident management&#160;<span>personnel may use the results of impact analysis to further prioritize cases during and after the triage&#160;</span><span>process. Without information about how an incident affects an organization, incident responders&#160;</span><span>cannot adequately plan containment, remediation, or eradication efforts.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1315, 1, N'<p class="p1"><font size="3">Identify root-cause analysis tools and techniques and ensure that all staff who participate in analysis&#160;<span>are trained in their use. These tools and techniques may include cause-and-effect diagrams,&#160;</span><span>interrelationship diagrams, causal factor tree analysis, and others.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1317, 1, N'<p class="p1"><font size="3">Organizations should have clear guidance on how to report incidents so the correct information gets to&#160;<span>the right people at the right time. Incident information reported should include the timeframes, details,&#160;</span><span>and any other relevant information. Relevant stakeholder can include asset owners, information&#160;</span><span>technology staff, physical security staff, auditors, and legal staff, as well as external stakeholders such&#160;</span><span>as vendors and suppliers, law enforcement staff, and others.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1318, 1, N'<p class="p1"><font size="3">The incident reporting guidance should address the stakeholders with whom communications about&#160;<span>incidents are required, and include specific details such as the methods, and under what operational&#160;</span><span>circumstances the stakeholders must be notified.</span></font></p><p class="p2"><font size="3">Document the information security requirements, because not all stakeholders may have access to the&#160;<span>same communication methods, and not all may be authorized to receive the full details of the incident.&#160;</span><span>Document the process, procedures and any other guidance to identify what information is provided to&#160;</span><span>individual or organizational stakeholders.</span></font></p><p class="p2"><font size="3">Ensure that the organizational incident reporting guidance addresses the various message types and&#160;<span>level of communications appropriate to various stakeholders. For example, incident communications&#160;</span><span>may be vastly different for incident response leadership than for those who may simply need to have&#160;</span><span>situational awareness. The plan should detail any special controls over communication (e.g.,&#160;</span><span>encryption or secured communications) that are appropriate for some stakeholders, possibly&#160;</span><span>depending on the type of incident.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1319, 1, N'<p class="p1"><font size="3">Develop predefined procedures to provide a consistent response and to limit the effect of the incident&#160;<span>on the organization. The response to an incident describes the actions the organization takes to&#160;</span><span>prevent or contain the impact of an incident on the organization while it is occurring or shortly after it&#160;</span><span>has occurred. The range, scope, and breadth of the organizational response may vary widely&#160;</span><span>depending on the nature of the incident. The incident response procedures should address at a&#160;</span><span>minimum:</span></font></p><p class="p2"></p><ul><li><font size="3">the essential activities (administrative, technical, and physical) that are required to contain or&#160;<span>limit damage and provide service continuity</span></font></li><li><font size="3">existing continuity of operations and restoration plans</font></li><li><font size="3">coordination activities with other internal staff and external agencies that must be performed&#160;<span>to implement the procedures</span></font></li><li><font size="3">the levels of authority and access needed by responders to carry out the procedures</font></li><li><font size="3"><span>the essential activities necessary to restore services to normal operation (recovery), and the&#160;</span><span>resources involved in these activities</span></font></li><li><font size="3">legal and regulatory obligations that must be met by the procedure</font></li><li><font size="3">standardized responses for certain types of incidents</font></li></ul><p></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1320, 1, N'<p class="p1"><font size="3">Develop and implement an organizational incident management communications plan. The&#160;<span>organization must proactively manage communications when incidents are detected and throughout&#160;</span><span>their life cycle. This requires the organization to develop and implement a communications plan that&#160;</span><span>can be readily implemented to manage communications to internal and external stakeholders on a&#160;</span><span>regular basis and as needed. Additionally, ensure that steps within the incident management process&#160;</span><span>and workflow are documented to prompt updates to status and response activities to appropriate&#160;</span><span>stakeholders.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1321, 1, N'<p class="p1"><font size="3">Part of an effective incident management process is the ability to quickly disseminate the correct&#160;<span>information to the right people at the right time. The internal and external stakeholders need to&#160;</span><span>understand what threats or vulnerabilities might impact them, the associated level of risk, and how to&#160;</span><span>protect against or mitigate them. Incident management personnel provide such notifications and&#160;</span><span>warnings to promote awareness of threats and malicious activity and to help support organizational&#160;</span><span>response actions. Depending on the mission of the incident management function, alerts and warnings&#160;</span><span>may be shared with other external parties. Notifications, reports, and warnings should be distributed in&#160;</span><span>a manner commensurate with the classification of the information related to the activity. Sensitive and&#160;</span><span>classified activity should be handled only through appropriate, secure mechanisms and within the&#160;</span><span>appropriate facilities.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1322, 1, N'<p class="p1"><font size="3">Incidents may be open for an extended period of time, may not have followed the organization''s&#160;<span>incident management process or may not have been formally closed. The organization must have a&#160;</span><span>process for tracking and managing incidents to closure which results in formally logging a status of&#160;</span><span>&#8220;closed&#8221; in the incident knowledge base. A &#8220;closed&#8221; status indicates to all relevant stakeholders that no&#160;</span><span>further actions are required or outstanding for the incident. It also provides notification to those affected&#160;</span><span>by the incident that it has been addressed and that they should not be subject to continuing effects.&#160;</span><span>The status of incidents in the incident database should be reviewed regularly to determine if open&#160;</span><span>incidents should be closed or need additional action.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1323, 1, N'<p class="p1"><font size="3">Identify relevant rules, laws, regulations, and policies for which event and incident evidence may be&#160;<span>required. This practice must be considered in the context of the organization''s compliance program&#160;</span><span>because there may be compliance issues related to the collection and preservation of event and&#160;</span><span>incident data.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1325, 1, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1326, 1, N'<p class="p1"><font size="3">Forensic analysis results can be used to determine the extent to which a system or network has been&#160;<span>compromised or otherwise affected and to provide a better understanding of what malicious activity&#160;</span><span>occurred and what other systems or services may have been affected. Such analysis can also facilitate&#160;</span><span>the development and implementation of comprehensive solutions, ensuring the use of more effective&#160;</span><span>protective strategies. The results of forensics analysis can also be used to prosecute malicious&#160;</span><span>intruders.</span></font></p><p class="p2"><font size="3">Policies, procedures, and training are needed to ensure personnel performing this analysis do not&#160;<span>damage or invalidate forensic evidence. These efforts include outlining how and when law enforcement&#160;</span><span>is involved in the analysis. In addition, personnel performing this function for forensic purposes may&#160;</span><span>need to be prepared to act as expert witnesses in court proceedings if the evidence analyzed is used&#160;</span><span>in a court of law to prosecute the intruder.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1328, 1, N'<p class="p1"><font size="3">Ensure that the processes or mechanisms used to track the resolution of incidents also indicate which&#160;<span>incidents require review in accordance with established guidance. This allows the organization''s&#160;</span><span>auditing function or incident management leadership to easily identify incidents that require post-incident&#160;</span><span>reviews, and ensure that they are performed. The post-incident review should determine if the&#160;</span><span>incident response plan or process was followed. The review should also identify any needed&#160;</span><span>improvements to the incident response plan or process. Ensure that the organization''s auditing&#160;</span><span>function checks for completion of these reviews as part of regular Incident Management reviews.</span></font></p><p class="p2"><font size="3">Multiple incidents may be covered in a single meeting to optimize the resources necessary to perform&#160;<span>this function. Some organizations may find it useful to have a pre-scheduled periodic review on the&#160;</span><span>stakeholders'' calendars to ensure availability, which they can simply cancel if no incidents have&#160;</span><span>occurred that meet the review criteria.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1329, 1, N'<p class="p1"><font size="3">Review the incident knowledge-base information and update the following areas accordingly:</font></p><p class="p2"></p><ul><li><font size="3">protection strategies and controls for assets involved in the incident</font></li><li><font size="3">continuity plans and strategies for sustaining assets involved in the incident</font></li><li><font size="3"><span>information security and other organizational policies that need to reflect new standards,&#160;</span><span>procedures, and guidelines based on what is learned in the incident handling</span></font></li><li><font size="3">training for staff on incident response, information security, business continuity, and IT&#160;<span>operations</span></font></li></ul><p></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1330, 1, N'<p class="p1"><font size="3">Updating event and incident response policies and procedures is an important part of the lessons&#160;<span class="s1">learned&#160;</span><span>process. Any issues encountered or lessons learned should be reviewed to identify or propose&#160;</span><span>areas for improvement and to act on these findings or recommendations. Post-mortem analysis of the&#160;</span><span>handling of an incident often reveals a missing step or an inaccuracy in a procedure, providing impetus&#160;</span><span>for change.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1332, 1, N'<p class="p1"><font size="3">Develop a testing program and test standards to apply universally in testing all aspects of incident&#160;<span>handling and response plans. These exercises:</span></font></p><p class="p3"></p><ul><li><font size="3">should look at the adequacy of processes and procedures through incident scenario&#160;<span>exercises (for example, perform triage, respond to events and incidents in a timely manner,&#160;</span><span>notify correct people, protect data during response activities, or meet SLAs)</span></font></li><li><font size="3">may involve simulated incidents</font></li><li><font size="3">can be performed throughout the whole organization or for specific organizational business&#160;<span>units</span></font></li><li><font size="3">may be internal to the organization or part of a broader, multi-organization exercise</font></li></ul><p></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1334, 1, N'<p class="p1"><font size="3">Establish a schedule for ongoing testing and review of plans and processes. The proposed schedule&#160;<span>for testing should be coordinated among stakeholders for situational awareness and for gathering their&#160;</span><span>input on objectives and secure participation. Ensure that the testing schedule does not conflict with&#160;</span><span>major system or organizational changes that a simultaneous test or exercise could impact negatively,&#160;</span><span>or vice versa. Similarly, ensure that testing aligns with major system or organizational changes as&#160;</span><span>appropriate, to confirm that incident detection, handling, and response activities are not impacted&#160;</span><span>negatively by the change(s). Because testing can require significant planning to be conducted&#160;</span><span>effectively, periodically review the schedule to ensure that resources are not expended on planning&#160;</span><span>activities that risk being canceled due to external activities or dependencies.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1335, 1, N'<p class="p1"><font size="3">Conduct tests of the incident detection, handling, and response processes on a regular basis. The test&#160;<span>should establish the viability, accuracy, and completeness of the incident detection, incident handling,&#160;</span><span>and incident response processes and activities. Test results should be recorded and documented for&#160;</span><span>resolution of gaps and overall improvement.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1336, 1, N'<p class="p1"><font size="3">The incident response test plan should identify all internal and external stakeholders involved in the&#160;<span>testing exercise, and their roles and expected participation. The organization should ensure that all&#160;</span><span>relevant stakeholders are involved in the planned testing.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1337, 1, N'<p class="p1"><font size="3">Compare actual test results with expected test results and test objectives. Areas where objectives&#160;<span>could not be met should be recorded, and strategies developed to review and revise incident detection,&#160;</span><span>handling, and response processes. Improvements to the testing process and test plans should be&#160;</span><span>identified, documented, and incorporated into future tests.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1339, 1, N'<p class="p1"><font size="3">The intent of this capability is to ensure that incident management personnel are updated on all&#160;<span>constituents'' infrastructure changes, such as configuration changes, scheduled power outages, and&#160;</span><span>maintenance on critical network assets. An agreement should stipulate exactly the changes that&#160;</span><span>require notification. Without this information, incident management personnel may not be able to&#160;</span><span>adequately assess the validity of a given event or incident report. Such notifications help incident&#160;</span><span>management personnel determine when reported behavior may have been caused by normal&#160;</span><span>maintenance or configuration updates, rather than by malicious intruder activity that disables part of&#160;</span><span>the constituent network. These notifications also facilitate an accurate inventory of system and network&#160;</span><span>components.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1340, 1, N'<p class="p1"><font size="3">A vulnerability repository is the central source of vulnerability information. As vulnerabilities are&#160;<span>discovered, they are submitted to the organization''s vulnerability repository. Basic information that&#160;</span><span>should be collected about vulnerabilities includes, but is not limited to:</span></font></p><p class="p2"></p><ul><li><font size="3">a unique organizational identifier for internal reference</font></li><li><font size="3">a description of the vulnerability</font></li><li><font size="3">the date entered to the repository</font></li><li><font size="3">references to the source of the vulnerability</font></li><li><font size="3">the importance of the vulnerability to the organization (critical, moderate, etc.)</font></li><li><font size="3">individuals or teams assigned to analyze and remediate the vulnerability</font></li><li><font size="3">a log of remediation actions taken to reduce or eliminate the vulnerability</font></li></ul><p></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1341, 1, N'<p class="p1"><font size="3">The vulnerability management repository or information should be available to the Incident&#160;<span>Management Function, as needed, to assist incident management personnel in responding to an&#160;</span><span>incident.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1342, 1, N'<p class="p1"><font size="3">Provide notification of unmitigated vulnerabilities to the event and incident handling personnel.&#160;<span>Accurate, complete, and timely information about vulnerabilities can assist in the examination of&#160;</span><span>incidents and events, and form the basis of root-cause analysis and trending for overall improvement&#160;</span><span>to the incident handling and responses process.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1343, 1, N'<p class="p1"><font size="3">The incident management function should be appropriately integrated with other related organizational&#160;<span>plans, services, and functions, including the organization''s service continuity plans. Computer security&#160;</span><span>incidents undermine the business resilience of an organization. Business continuity planning&#160;</span><span>professionals should be made aware of incidents and their impacts so they can fine-tune business&#160;</span><span>impact assessments, risk assessments, and continuity of operations plans. Further, because business&#160;</span><span>continuity planners have extensive expertise in minimizing operational disruption during severe&#160;</span><span>circumstances, they may be valuable in planning responses to certain situations, such as denial of&#160;</span><span>service (DoS) conditions.</span></font></p><p class="p2"><font size="3">Service continuity plans must be consistent with the standards and guidelines established by the&#160;<span>organization to ensure plan consistency, accuracy, and ability to implement. The incident management&#160;</span><span>function should be appropriately integrated with the organization''s service continuity plans.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1344, 1, N'<p class="p1"><font size="3">To ensure plan consistency, accuracy, completeness, and effectiveness, service continuity plans are&#160;<span>examined against the organization''s standards and guidelines for plan development. This ensures&#160;</span><span>consistent levels of documentation, the inclusion of required elements (such as the integration of the&#160;</span><span>Incident Management Function), and the ability of the plans to meet stated objectives.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1345, 1, N'<p class="p1"><font size="3">Monitoring is an activity that the organization uses to `take the pulse'' of its day-to-day operations. The&#160;<span>proactive discovery and analysis of data related to operational activities ensure that stakeholders have&#160;</span><span>the information needed to make decisions before, during, or after a disruption occurs. Monitoring&#160;</span><span>provides information that the organization needs to determine whether it is being subjected to threats&#160;</span><span>that require action to prevent organizational impact. The organization should implement standards that&#160;</span><span>ensure enterprise-wide quality assurance for the threat-monitoring process.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1346, 1, N'<p class="p1"><font size="3">Communicate threat information to stakeholders, including the Incident Management Function.</font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1347, 1, N'<p class="p1"><font size="3">Identify and inventory the assets that support the incident management function. An organization must&#160;<span>be able to identify the people, information, technology, and facility assets that support the incident&#160;</span><span>management function; document them; and establish their value in order to develop strategies for&#160;</span><span>protecting and sustaining assets commensurate with their value to the function.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1348, 1, N'<p class="p1"><font size="3">All information relevant to the asset should be contained with the asset entry in the asset database.&#160;<span>Strategies to protect and sustain an asset may be documented as part of the asset description.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1349, 1, N'<p class="p1"><font size="3">Control objectives are guided by strategies for protecting and sustaining service-related assets to&#160;<span>ensure that their exposure to vulnerabilities and threats is managed. Assuring mission success is the&#160;</span><span>focus for defining service level controls that meet their corresponding control objectives. Based on the&#160;</span><span>control objectives and the larger protection and sustainment strategies, specific controls are selected,&#160;</span><span>analyzed, and managed to ensure that control objectives are satisfied.</span></font></p><p class="p2"><font size="3">The incident management function supports all organizational services and collects information that is&#160;<span>sensitive to the organization while performing its duties. The incident response team should safeguard&#160;</span><span>incident data and restrict access to it. At a minimum, the controls that protect and sustain the Incident&#160;</span><span>Management Function should be commensurate with those that protect the organization''s most critical&#160;</span><span>services.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1350, 1, N'<p class="p1"><font size="3">Change management is a continuous process and, therefore, requires the organization to assign&#160;<span>responsibility and accountability. The organization must independently monitor the change&#160;</span><span>management process to ensure that it is operational, and that asset-level resilience requirements have&#160;</span><span>been updated on a regular basis so that they remain in direct alignment with organizational drivers.</span></font></p><p class="p2"><font size="3">Create baseline configuration items. Establish a technology asset baseline (often called a configuration&#160;<span>item) to provide a foundation for managing the integrity of the asset as it changes during its life.</span></font></p><p class="p2"><font size="3">Develop a strategy to meet the demand for capacity based on the resilience requirements for the&#160;<span>technology asset and the services it supports. In this instance, the strategy may need to consider the&#160;</span><span>organization''s strategic objectives and how their accomplishment affects the capacity of current&#160;</span><span>technology assets and future capacity needs.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1351, 1, N'<p class="p1"><font size="3">To ensure that the organization has the appropriate tools for incident management, a process for&#160;<span>identifying needed tools and determining their requirements for implementation should be in place.&#160;</span><span>This process could follow the normal system/software acquisition life cycle or another organization specific&#160;</span><span>process. The life cycle for acquiring and developing tools to support an incident management&#160;</span><span>function comprises the following core actions:</span></font></p><p class="p2"></p><ul><li><font size="3">Establish requirements for tools.</font></li><li><font size="3">Acquire or develop tools that meet these requirements.</font></li><li><font size="3">Test tools within the incident management environment.</font></li><li><font size="3">Deploy tools for operational use.</font></li><li><span><font size="3">Operate and sustain tools over time</font></span></li></ul><p></p><p class="p2"><font size="3">Developing or acquiring resilient technical solutions, such as software and systems, requires a&#160;<span>dedicated process that encompasses the asset''s life cycle.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1352, 1, N'<p class="p1"><font size="3">Document the service continuity plans using available templates, as appropriate. The continuity of the&#160;<span>incident management function must be specifically addressed. A service continuity plan typically&#160;</span><span>includes the following information:</span></font></p><p class="p2"></p><ul><li><font size="3">Identification of authority for initiating and executing the plan (plan ownership)</font></li><li><font size="3">Identification of the communication mechanism to initiate execution of the plan</font></li></ul><p></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1353, 1, N'<p class="p1"><font size="3">Implement physical access control for the Incident Management Function. Similar to other components&#160;<span>of the organization, the Incident Management Function''s assets (including infrastructure, data, and&#160;</span><span>personnel) should be subject to physical access control, including the following provisions:</span></font></p><p class="p2"></p><ul><li><font size="3">Enforcement of physical access authorizations at entry and exit points, including the following:</font></li><ul><li><font size="3">Verification of appropriate authorizations as a requirement to grant access to the&#160;<span>facility.</span></font></li><li><font size="3"><font face="Times">&#160;</font><span>Control of all ingress to and egress from the facility.</span></font></li></ul><li><font size="3">Maintenance of audit logs of all physical access through all entry and exit points.</font></li><li><font size="3">Escort of visitors and monitoring of their activity throughout their visit.</font></li><li><font size="3">Securing of keys, key combinations, and other physical access devices, and changing them&#160;<span>when lost, stolen, or after personnel changes.</span></font></li><li><font size="3">Regular review of all logs and procedures to ensure access control is effective.</font></li></ul><p></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1354, 1, N'<p class="p1"><font size="3">The monitoring, identification, and reporting of events are the foundation of incident identification, and&#160;<span>commence the incident life cycle. Events can affect the productivity of organizational assets and, in&#160;</span><span>turn, of associated services. At a minimum, the organization should identify the most effective methods&#160;</span><span>for event detection, and provide a process for reporting events so that they can be triaged, analyzed,&#160;</span><span>and addressed.</span></font></p><p class="p2"><font size="3">Implement network monitoring related to the Incident Management Function, similar to the control of&#160;<span>other organizational components. Continuous monitoring programs provide ongoing awareness of&#160;</span><span>threats, vulnerabilities, and information security.</span></font></p><p class="p2"><font size="3">Use continuous monitoring to support appropriate responses to risks. Providing organizational officials&#160;<span>with continuous access to security-related information (in the form of reports and/or dashboards)&#160;</span><span>enables them to make more effective and timely risk management decisions. Use automation to&#160;</span><span>provide more frequent updates to security authorization packages, hardware/software/firmware&#160;</span><span>inventories, and other system information.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1355, 1, N'<p class="p1"><font size="3">The intent of this capability is to ensure that incident management personnel are watching their own&#160;<span>networks. Information collected by incident management personnel and stored on incident&#160;</span><span>management systems and applications can contain sensitive information. It is critical that such&#160;</span><span>information be protected with the same rigor applied to other key organizational assets.</span></font></p><p class="p2"><font size="3">A documented and implemented plan to protect information assets should exist for monitoring Incident&#160;<span>Management Function systems. This monitoring plan should include methods for detecting events,&#160;</span><span>incidents, anomalous activity, intrusion attempts, and other potential threats. The plan also requires&#160;</span><span>identification of critical Incident Management Function assets so that appropriate monitoring activities&#160;</span><span>can be implemented.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1356, 1, N'<p class="p1"><font size="3">The organization may have a vulnerability management practice or capability in place. Vulnerabilities in&#160;<span>the systems that support the Incident Management Function must be remediated. If these systems are&#160;</span><span>not included in the scope of the organization''s larger vulnerability management processes, there must&#160;</span><span>be a similar process established specifically for the Incident Management Function. The process&#160;</span><span>should consider the following:</span></font></p><p class="p2"></p><ul><li><font size="3">Scan for vulnerabilities in information systems and hosted applications. Conduct scanning&#160;<span>according to an organization-defined schedule, and when new relevant vulnerabilities are&#160;</span><span>identified and reported.</span></font></li><li><font size="3">Use vulnerability scanning tools and techniques that facilitate their interoperability.</font></li><li><font size="3">Automate parts of the vulnerability management process by using standards for the following:</font></li><ul><li><font size="3">enumerating platforms, software flaws, and improper configurations</font></li><li><font size="3">formatting checklists and test procedures</font></li><li><font size="3">measuring vulnerability impact</font></li></ul><li><font size="3">Analyze vulnerability scan reports and results from security control assessments.</font></li><li><font size="3">Remediate legitimate vulnerabilities according to an assessment of the risk to the&#160;<span>organization.</span></font></li><li><font size="3">Share information from vulnerability scanning and security control assessments with entities&#160;<span>identified by organizational leadership to help eliminate similar vulnerabilities in other&#160;</span><span>information systems.</span></font></li></ul><p></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1357, 1, N'<p class="p1"><font size="3">Develop and implement guidelines for the secure collection, handling, transmission, storage, and the&#160;<span>appropriate disposition of event and incident information assets. Communicate these guidelines to all&#160;</span><span>staff responsible for the resilience of information assets.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1358, 1, N'<p class="p1"><font size="3">Develop information asset backup and retention procedures. Information asset backup and retention&#160;<span>procedures should include:</span></font></p><p class="p3"></p><ul><li><font size="3">standards for the frequency of backup and storage (which may be established and connected&#160;<span>to the organization''s configuration management of information assets) and the retention&#160;</span><span>period for each information asset</span></font></li><li><font size="3">the types and forms of information asset retention (paper, CDs, tapes, etc.)</font></li><li><font size="3">the identification of organization-authorized storage locations and methods, and of guidelines&#160;<span>for appropriate proximity of these storage locations</span></font></li><li><font size="3">procedures for accessing stored copies of information assets</font></li><li><font size="3">standards for the protection and environmental control of information assets in storage&#160;<span>(particularly if the assets are stored in locations not owned by the organization)</span></font></li><li><font size="3">standards for the testing of the validity of the information assets to be used in restorative&#160;<span>activities</span></font></li><li><font size="3">periodic revision of the guidelines as operational conditions change</font></li></ul><p></p><p class="p3"><font size="3">The application of these guidelines should be based on the value of the asset and its availability&#160;<span>requirements during an emergency, which may be indicated by a service continuity plan.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1360, 1, N'<p class="p1"><font size="3">Identify and document staff who are authorized to modify information assets, relative to the asset''s&#160;<span>integrity requirements. This information may be specifically included as part of the information asset''s&#160;</span><span>resilience requirements.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1361, 1, N'<p class="p1"><font size="3">Establish the incident management plan. At a minimum, the incident management plan should&#160;<span>address:</span></font></p><p class="p3"></p><ul><li><font size="3">the organization''s philosophy for incident management</font></li><li><font size="3">the structure of the incident management process</font></li><li><font size="3">the requirements and objectives of the incident management process</font></li><li><font size="3">a description of how the organization will identify incidents, analyze them, and respond to&#160;<span>them</span></font></li><li><font size="3">the roles and responsibilities necessary to carry out the plan</font></li><li><font size="3">internal and external stakeholders to the plan and capability</font></li><li><font size="3">applicable training needs and requirements</font></li><li><font size="3">resources, both internal and external, required to meet the objectives of the plan</font></li><li><font size="3">relevant costs and budgets associated with the incident management activities</font></li></ul><p></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1362, 1, N'<p class="p1"><font size="3">The incident management plan should be reviewed and updated periodically, as defined by the&#160;<span>organization. Review the plan to ensure that the organization is following the roadmap for maturing the&#160;</span><span>capability and for fulfilling its incident response goals. Ensure that lessons learned from responding to&#160;</span><span>incidents are also incorporated in the plan to improve the incident management process and life cycle.&#160;</span><span>Organizational changes should be assessed, and the plan updated as necessary. Revise and update&#160;</span><span>documented commitments from those responsible for implementing and supporting the plan,&#160;</span><span>particularly the commitment of higher-level managers.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1363, 1, N'<p class="p1"><font size="3">Assign staff to incident management roles and responsibilities. The organization must identify the staff&#160;<span>necessary to achieve the plan''s objectives. Ensure that staff are assigned and aware of their roles and&#160;</span><span>responsibilities with respect to satisfying these objectives.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1364, 1, N'<p class="p1"><font size="3">Develop detailed job descriptions for each role and responsibility detailed in the incident management&#160;<span>plan. The job description should clearly state the duties, expectations, and requirements of each role&#160;</span><span>defined in the plan.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1365, 1, N'<p class="p1"><font size="3">The incident management plan provides the organization with a standard operating procedure for&#160;<span>handling incidents that may impact critical business operations and information. The plan should&#160;</span><span>identify the roles and responsibilities of everyone involved in the process, including senior leadership.&#160;</span><span>Senior leadership needs to be made aware of their roles to support incident response.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1366, 1, N'<p class="p1"><font size="3">All relevant groups and individuals that have a significant role in the incident management plan should&#160;<span>be involved in the creation of the plan. Obtaining the perspectives of all plan stakeholders, and getting&#160;</span><span>their support and buy-in, will increase their awareness, engagement, and responsibility to abide by the&#160;</span><span>guidance provided in that plan.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1367, 1, N'<p class="p1"><font size="3">Establish a foundational structure for event detection, reporting, logging, and tracking, and for&#160;<span>collecting and storing event evidence. This structure enables incident management processes to&#160;</span><span>function properly.</span></font></p><p class="p2"><font size="3">Foundational processes related to event detection and reporting also support incident reporting,&#160;<span>logging, and tracking. One approach to establishing this foundational structure is to implement an&#160;</span><span>event and incident knowledge base.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1368, 1, N'<p class="p1"><font size="3">The organization should have a documented communication plan for its incident management&#160;<span>activities. During an incident, it is critical that the designated people receive the appropriate information&#160;</span><span>in a timely manner. The plan should include management notification, and incident response and&#160;</span><span>coordination. The communication plan should also include guidance on internal and external&#160;</span><span>communication requirements. This communication plan may be part of a larger organizational plan or&#160;</span><span>crisis management plan.</span></font></p><p class="p2"><font size="3">Plan and prepare several communication channels, including out-of-band methods (e.g., in person,&#160;<span>paper), and select the appropriate methods for each incident. Regularly review and update the&#160;</span><span>communication plan for incident management, and include at a minimum the following information:</span></font></p><p class="p2"></p><ul><li><font size="3">the roles with authority to initiate incident-related communications or data</font></li><li><font size="3">the internal and external resources that support the communications process</font></li><li><font size="3">the individuals, groups, and designated POCs to be contacted</font></li><li><font size="3">thresholds for when to contact someone</font></li><li><font size="3">the contact processes and mechanisms, including security requirements</font></li><li><font size="3">the respective timeframes for contacting the appropriate individuals, groups, and designated&#160;<span>POCs</span></font></li><li><font size="3">the frequency and timing of communications</font></li><li><font size="3">a description of the action an individual should take after receiving the communicated&#160;<span>information</span></font></li><li><font size="3">special communications requirements (e.g., brevity codes, encryption, or secured&#160;<span>communications)</span></font></li></ul><p></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1369, 1, N'<p class="p1"><font size="3">Disseminate the communication plan to both internal and external stakeholders. It is expected that the&#160;<span>stakeholders are committed to supporting the communications plan. The communications plan should&#160;</span><span>be disseminated each time it is modified. Organizational changes that have occurred since the last&#160;</span><span>revision could necessitate a redistribution of the plan.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1370, 1, N'<p class="p1"><font size="3">Ensure that information exchange interfaces among the groups involved in incident management&#160;<span>functions are described and understood by all participants. Identify the appropriate communications&#160;</span><span>protocols and channels (media and message) for each type of stakeholder. Various message types&#160;</span><span>and levels of communications may be appropriate for various stakeholders.</span></font></p><p class="p2"><font size="3">Establish an incident management function that ensures an interface is available that identifies and&#160;<span>facilitates the flow of incident management data among all groups that have a stake in the incident&#160;</span><span>management process.</span></font></p><p class="p2"><font size="3">The interface should identify member groups and define the incident management information that is&#160;<span>exchanged (e.g., process, authority, mechanism).</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1371, 1, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1372, 1, N'<p class="p1"><font size="3">Identify external dependencies. It is important for the Incident Management Function to identify and&#160;<span>characterize all external dependencies so that they can be understood, formalized, monitored, and&#160;</span><span>managed.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1373, 1, N'<p class="p1"><font size="3">Formal agreements should be established with external entities that support the Incident Management&#160;<span>Function. Types of agreements may include contracts, memorandum of agreement, purchase orders,&#160;</span><span>and licensing agreements. The agreements should be enforceable, include detailed and complete&#160;</span><span>specifications, specify required performance standards, and be periodically updated to reflect&#160;</span><span>necessary changes. All agreements should establish procedures for monitoring the performance of&#160;</span><span>external entities and inspecting the services or products they deliver to the organization.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1374, 1, N'<p class="p1"><font size="3">Properly document the agreement terms, conditions, specifications, and other provisions. All&#160;<span>agreement provisions should be documented clearly in the agreement in easy-to-understand language.&#160;</span><span>The agreement should not contain any general exceptions for achieving the resilience specifications&#160;</span><span>unless they are considered and negotiated carefully. It may, however, contain scenarios of types of&#160;</span><span>unforeseen events for which the external entity is not expected to prepare. Exceptions granted to&#160;</span><span>resilience specifications, or scenarios for which the external entity is not required to prepare, should be&#160;</span><span>treated as risks. All agreements should establish procedures for monitoring the performance of&#160;</span><span>external entities and for inspecting the services or products they deliver to the organization.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1375, 1, N'<p class="p1"><font size="3">Establish procedures and responsibility for monitoring external entity performance and for inspecting&#160;<span>external entity deliverables. Periodically meet with representatives of the external dependencies to&#160;</span><span>review the result of monitoring activities, the specifications of each agreement, and any changes that&#160;</span><span>might impact performance.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1376, 1, N'<p class="p1"><font size="3">To ensure that members of the incident response team respond effectively to incidents, it is important&#160;<span>that the organization develops KSA requirements for candidates.</span></font></p><p class="p3"><font size="3">Establish and document baseline competencies necessary to meet the needs of the Incident&#160;<span>Management Function. Baseline competencies may be as detailed as the organization needs to&#160;</span><span>describe its required skill sets. This may involve many layers of information, including</span></font></p><p class="p1"></p><ul><li><font size="3">role (security administrator, network administrator, CIO, etc.)</font></li><li><font size="3">position (CIO, senior security analyst, network engineer, etc.)</font></li><li><font size="3">skills (Java programming, Oracle DBA, etc.)</font></li><li><font size="3">certifications (CISSP, MSCE, etc.)</font></li><li><font size="3">aptitudes and job requirements (able to work long hours, travel, or be on call)</font></li></ul><p></p><p class="p3"><font size="3">For each incident handling and response position, develop a list of attributes required to perform the&#160;<span>role in the form of KSAs.</span></font></p><p class="p1"><font size="3">&#8221;Knowledge&#8221; is a body of information applied directly to the performance of a function, such as incident&#160;<span>handling and response.</span></font></p><p class="p1"><font size="3">&#8221;Skill&#8221; is an observable competence to perform a function using various tools, frameworks and&#160;<span>processes. For each role, identify the technologies or systems that the organization uses to perform&#160;</span><span>the tasks assigned to that role.</span></font></p><p class="p1"><font size="3">&#8221;Ability&#8221; is the proficiency to perform an observable behavior or a behavior that results in an observable&#160;<span>product. For example, some roles may require abilities to effectively communicate or analyze a&#160;</span><span>problem; others, to develop technical documentation; and managers may have to organize work or&#160;</span><span>tasks and lead others effectively.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1377, 1, N'<p class="p1"><font size="3">Document the training needs of the incident handling and response personnel. The training needs&#160;<span>should focus on the skills and knowledge needed to perform particular roles and address the&#160;</span><span>associated KSAs. The training needs should also adequately cover the capabilities represented by the&#160;</span><span>Incident Management Function. Training needs are established by first, identifying people in the&#160;</span><span>organization with incident handling and response roles and responsibilities, then analyzing gaps in&#160;</span><span>their knowledge and skills that have to be addressed to enable them to succeed in their roles.</span></font></p>')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1378, 1, N'<p class="p1"><font size="3">Conduct training for the personnel assigned to the Incident Management Function. Experienced&#160;<span>instructors should conduct the training. When possible, the training is conducted in settings that closely&#160;</span><span>resemble actual performance conditions, and includes activities that simulate actual work situations.&#160;</span><span>This approach includes integration of tools, methods, and procedures for competency development.&#160;</span><span>Training is tied to work responsibilities so that on-the-job activities or other outside experiences&#160;</span><span>reinforce the training within a reasonable time after its conclusion.</span></font></p>')
PRINT(N'Operation applied to 64 rows out of 64')

PRINT(N'Add rows to [dbo].[MATURITY_REFERENCES]')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1291, 2208, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1291, 3866, N'ID.BE', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1291, 5031, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1292, 2208, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1292, 3866, N'ID.AM-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1292, 3866, N'ID.BE', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1292, 5031, N'3.2.6', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1293, 3866, N'ID.AM', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1293, 3866, N'ID.AM-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1293, 3866, N'ID.AM-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1293, 3866, N'ID.AM-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1293, 3866, N'ID.AM-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1293, 3866, N'ID.BE-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1293, 3866, N'ID.BE-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1293, 5014, N'CA-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1293, 5014, N'CM-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1293, 5014, N'CM-8', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1293, 5014, N'CP-2(8)', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1293, 5014, N'PM-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1293, 5017, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1293, 5031, N'3.1.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1294, 3866, N'ID.AM', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1294, 3866, N'ID.AM-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1294, 3866, N'ID.AM-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1294, 3866, N'ID.AM-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1294, 3866, N'ID.BE-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1294, 3866, N'ID.BE-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1294, 5014, N'CM-8', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1294, 5031, N'3.1.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1295, 3866, N'DE.CM-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1295, 3866, N'DE.CM-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1295, 3866, N'DE.CM-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1295, 5014, N'CA-7', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1295, 5014, N'IR-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1295, 5014, N'SI-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1295, 5031, N'3.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1296, 3866, N'DE.CM-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1296, 3866, N'DE.CM-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1296, 3866, N'DE.CM-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1296, 5014, N'CA-7', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1296, 5014, N'SI-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1296, 5031, N'3.2.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1296, 5031, N'3.2.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1297, 2602, N'IR-6', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1297, 3866, N'DE.DP-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1297, 3866, N'RS.CO-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1297, 5031, N'3.1.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1297, 5031, N'3.2.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1299, 3866, N'DE.AE-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1299, 5031, N'2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1299, 6078, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1300, 3866, N'RS.CO-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1300, 5014, N'IR-6', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1300, 5031, N'2.3.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1300, 5031, N'2.6', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1300, 5031, N'3.5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1300, 5031, N'3.6', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1301, 3866, N'RS.AN-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1301, 5031, N'3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1301, 6078, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1302, 3866, N'DE.AE-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1302, 3866, N'DE.AE-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1302, 5031, N'3.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1302, 6078, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1303, 670, N'3.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1303, 3866, N'DE.AE-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1303, 3866, N'DE.AE-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1303, 5031, N'3.2.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1303, 5031, N'3.2.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1304, 3866, N'DE.EA-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1304, 5031, N'3.2.6', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1305, 3866, N'DE.AE.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1305, 5031, N'3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1306, 3866, N'DE.AE-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1306, 3866, N'RS.AN-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1306, 5031, N'3.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1307, 3866, N'DE.DP-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1307, 3866, N'DE.DP-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1307, 3866, N'PR.IP-11', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1307, 3866, N'RS.CO-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1307, 4988, N'4.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1307, 5031, N'2.4.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1308, 3866, N'RS.CO-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1308, 5031, N'3.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1308, 6078, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1309, 3866, N'DE.AE-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1309, 5031, N'3.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1310, 3866, N'RS.CO-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1310, 5031, N'3.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1310, 5031, N'3.6', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1311, 3866, N'RS.AN-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1311, 3866, N'RS.AN-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1311, 5031, N'3.2.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1311, 6078, N'3.4.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1312, 3866, N'RS.AN-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1312, 3866, N'RS.AN-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1312, 5031, N'3.2.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1312, 6078, N'3.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1312, 6078, N'3.4.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1313, 3866, N'RS.AN-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1313, 3866, N'RS.AN-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1313, 5031, N'3.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1313, 6078, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1314, 2533, N'2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1314, 2533, N'3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1314, 2533, N'H', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1314, 3866, N'RS.AN-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1315, 3866, N'DE.DP-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1315, 3866, N'PR.IP-7', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1315, 5014, N'IR-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1315, 5014, N'IR-8', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1315, 6078, N'3.4.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1316, 3866, N'RS.CO-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1316, 5031, N'3.2.7', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1316, 6078, N'3.8.7', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1317, 3866, N'RS.CO-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1317, 3866, N'RS.CO-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1317, 5014, N'IR-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1317, 5014, N'IR-6', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1317, 5031, N'2.3.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1317, 5031, N'2.3.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1317, 5031, N'3.1.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1317, 5031, N'3.2.7', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1317, 6078, N'3.3.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1318, 3866, N'RS.CO-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1318, 3866, N'RS.CO-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1318, 5031, N'3.2.7', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1319, 3866, N'RS.MI-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1319, 3866, N'RS.RP-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1319, 5031, N'3.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1319, 5031, N'3.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1320, 3866, N'RC.CO-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1320, 3866, N'RS.CO-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1320, 3866, N'RS.CO-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1320, 5031, N'2.3.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1320, 5031, N'3.2.7', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1320, 5031, N'4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1320, 6078, N'3.8.8', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1321, 3866, N'RC.CO.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1321, 3866, N'RC.CO-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1321, 3866, N'RS.CO-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1321, 5014, N'SI-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1321, 5031, N'2.5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1321, 5031, N'3.2.7', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1321, 6078, N'3.5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1321, 6078, N'3.8.8', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1322, 3866, N'RS.MI-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1322, 3866, N'RS.MI-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1322, 5031, N'3.2.5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1322, 6078, N'3.3.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1322, 6078, N'3.4.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1322, 6078, N'3.4.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1323, 3866, N'DE.DP-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1323, 3866, N'ID.GV-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1323, 5031, N'2.4.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1323, 6078, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1324, 3866, N'DE.DP-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1324, 3866, N'ID.GV-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1324, 3894, N'2.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1324, 3894, N'2.5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1324, 3894, N'2.6', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1324, 5031, N'2.4.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1324, 5031, N'3.3.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1325, 3866, N'ID-GV.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1325, 3866, N'RS.AN-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1325, 3894, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1325, 5031, N'3.3.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1325, 6078, N'2.3.2.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1326, 3866, N'RS.CO-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1326, 3894, N'3.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1327, 3866, N'DE.DP-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1327, 3866, N'PR.IP-7', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1327, 3866, N'RC.IM-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1327, 3866, N'RC.IM-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1327, 3866, N'RS.IM-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1327, 3866, N'RS.IM-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1327, 3866, N'RS.RP-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1327, 5031, N'3.4.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1327, 5031, N'3.4.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1328, 3866, N'DE.DP-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1328, 3866, N'PR.IP-7', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1328, 3866, N'RC.IM-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1328, 3866, N'RC.IM-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1328, 3866, N'RS.IM-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1328, 3866, N'RS.IM-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1328, 3866, N'RS.RP-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1328, 5014, N'IR-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1328, 5014, N'IR-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1328, 5031, N'3.4.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1329, 3866, N'DE.DP-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1329, 3866, N'PR.IP-7', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1329, 3866, N'RC.IM-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1329, 3866, N'RC.IM-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1329, 3866, N'RS.IM-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1329, 3866, N'RS.RP-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1330, 3866, N'DE.DP-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1330, 3866, N'PR.IP-7', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1330, 3866, N'RC.IM-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1330, 3866, N'RC.IM-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1330, 3866, N'RS.RP-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1330, 5031, N'3.4.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1330, 5031, N'3.4.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1331, 3866, N'DE.DP-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1331, 3866, N'PR.IP-7', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1331, 3866, N'RC.IM-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1331, 3866, N'RC.IM-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1331, 3866, N'RS.IM-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1331, 3866, N'RS.IM-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1331, 3866, N'RS.RP-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1331, 5031, N'3.4.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1331, 5031, N'3.4.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1331, 6078, N'3.4.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1332, 673, N'6', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1332, 3866, N'ID.SC-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1332, 3866, N'PR.IP-10', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1332, 5014, N'IR-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1333, 673, N'6', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1333, 3866, N'ID.SC-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1333, 3866, N'PR.IP-10', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1333, 5014, N'IR-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1334, 673, N'6', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1334, 3866, N'ID.SC-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1334, 3866, N'PR.IP-10', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1334, 5014, N'IR-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1335, 673, N'6', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1335, 3866, N'ID.SC-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1335, 3866, N'PR.IP-10', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1335, 5014, N'IR-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1337, 673, N'6', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1337, 3866, N'ID.SC-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1337, 3866, N'PR.IP-10', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1337, 5014, N'IR-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1338, 3866, N'PR.IP-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1338, 5014, N'CM-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1339, 3866, N'PR.IP-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1339, 5014, N'CM-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1340, 3866, N'ID.RA-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1340, 3866, N'RS.AN-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1341, 3866, N'ID.RA-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1341, 3866, N'RS.AN-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1343, 2208, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1343, 3866, N'PR.IP-9', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1343, 5014, N'IR-4 (3)', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1345, 3866, N'ID.RA-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1345, 3866, N'ID.RA-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1345, 5015, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1345, 5031, N'2.5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1346, 2533, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1346, 3866, N'PR.IP-8', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1346, 5031, N'2.5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1347, 3866, N'ID.AM', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1347, 3866, N'ID.AM-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1347, 3866, N'ID.AM-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1347, 3866, N'ID.AM-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1347, 5017, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1348, 3866, N'ID.BE-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1349, 3866, N'ID.GV-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1349, 3866, N'ID.GV-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1349, 3866, N'PR.AC', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1349, 3866, N'PR.DS', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1349, 3866, N'PR.IP', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1349, 3866, N'PR.MA', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1349, 3866, N'PR.PT', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1349, 5031, N'3.2.5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1349, 5031, N'3.6', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1349, 5031, N'4.2.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1350, 3866, N'PR.IP-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1350, 5014, N'CM-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1350, 5018, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1352, 3866, N'PR.AC-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1352, 5014, N'PE', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1353, 3866, N'PR.AC-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1353, 5014, N'PE', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1354, 3866, N'DE.CM-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1354, 5014, N'CA-7', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1354, 5014, N'SI-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1354, 5031, N'2.1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1354, 5031, N'3.2.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1355, 3866, N'DE.DP-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1355, 3866, N'PR.IP-9', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1355, 5014, N'IR-8', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1355, 5031, N'2.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1356, 3866, N'DE.CM-8', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1356, 3866, N'ID.RA-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1356, 3866, N'RS.AN-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1356, 3896, N'4.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1356, 5014, N'RA-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1356, 5031, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1357, 3866, N'PR.DS-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1357, 3866, N'PR.IP-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1357, 3866, N'PR.IP-6', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1357, 5014, N'CP-9', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1357, 5014, N'MP-6', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1357, 5031, N'2.3.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1357, 5031, N'3.2.5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1357, 5031, N'3.3.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1357, 5031, N'3.4.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1357, 5031, N'3.4.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1359, 3866, N'ID.SC-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1359, 3866, N'PR.IP-11', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1359, 3866, N'PR.IP-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1359, 5014, N'AC-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1360, 3866, N'PR.AC-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1360, 3866, N'PR.IP-11', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1360, 3866, N'PR.IP-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1360, 5014, N'AC-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1361, 3866, N'DE.DP-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1361, 3866, N'ID.SC-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1361, 3866, N'PR.IP-9', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1361, 3866, N'RS.CO-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1361, 3866, N'RS.CO-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1361, 5014, N'IR-8', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1361, 5031, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1361, 6078, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1362, 3866, N'DE.DP-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1362, 3866, N'ID.SC-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1362, 3866, N'PR.IP-10', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1362, 5014, N'IR-8', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1363, 3866, N'DE.DP-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1363, 3866, N'RS.CO-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1363, 5031, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1363, 6078, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1364, 3866, N'DE.DP-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1364, 3866, N'PR.IP-11', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1365, 3866, N'ID.AM-6', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1365, 3866, N'ID.GV-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1365, 3866, N'PR.AT-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1365, 5014, N'IR-8', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1365, 5031, N'2.3.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1366, 3866, N'DE.DP-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1366, 3866, N'ID.SC-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1366, 3866, N'PR.IP-9', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1366, 3866, N'RS.CO-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1366, 3866, N'RS.CO-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1366, 5014, N'IR-8', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1366, 5031, N'2.3.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1366, 5031, N'2.4.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1367, 3866, N'ID.SC-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1367, 3866, N'PR.IP-9', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1367, 6078, N'', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1368, 3866, N'DE.DP-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1368, 3866, N'ID.SC-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1368, 3866, N'PR.IP-9', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1368, 3866, N'RS.CO-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1368, 3866, N'RS.CO-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1368, 5014, N'IR-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1368, 5014, N'IR-8', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1368, 5031, N'2.3.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1368, 5031, N'2.3.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1368, 6078, N'3.7', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1368, 6078, N'3.8.8', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1368, 6078, N'4.2.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1368, 6078, N'4.2.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1369, 3866, N'ID.SC-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1369, 3866, N'PR.IP-9', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1369, 5014, N'IR-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1369, 5014, N'IR-8', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1369, 5031, N'2.3.2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1369, 5031, N'2.3.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1369, 5031, N'3.2.7', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1370, 3866, N'RC.CO-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1370, 3866, N'RC.CO-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1370, 3866, N'RS.CO-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1370, 5014, N'IR-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1370, 5031, N'2.4.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1371, 3866, N'RC.CO-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1371, 3866, N'RC.CO-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1371, 3866, N'RS.CO-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1371, 5014, N'2.4.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1371, 5014, N'IR-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1371, 5031, N'2.4.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1372, 3866, N'ID.BE-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1372, 3866, N'ID.SC-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1372, 5015, N'E-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1373, 3866, N'ID.BE-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1373, 3866, N'ID.SC-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1373, 3866, N'PR.AT-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1373, 5014, N'SA-12', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1374, 3866, N'ID.BE-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1374, 3866, N'ID.SC-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1374, 3866, N'PR.AT-3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1374, 5014, N'SA-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1375, 3866, N'ID.SC-4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1375, 5014, N'SA-12 9', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1376, 3866, N'PR.AT-1', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1376, 3866, N'PR.IP-7', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1376, 5010, N'2.1.4', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1376, 5014, N'IR-2', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1376, 5031, N'2.4.3', NULL, N'')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1377, 3866, N'PR.AT-1', NULL, N'')
PRINT(N'Operation applied to 390 rows out of 390')

PRINT(N'Add rows to [dbo].[MATURITY_SOURCE_FILES]')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1336, 673, N'2', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1336, 3866, N'ID.SC-5', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1336, 3866, N'PR.IP-10', NULL, N'')
INSERT INTO [dbo].[MATURITY_SOURCE_FILES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (1336, 5031, N'2.3.3', NULL, N'')
PRINT(N'Operation applied to 4 rows out of 4')

PRINT(N'Add constraints to [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[MATURITY_REFERENCE_TEXT]')
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_LEVELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_OPTIONS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTION_TYPES]
ALTER TABLE [dbo].[HYDRO_DATA] WITH CHECK CHECK CONSTRAINT [FK__HYDRO_DAT__Mat_Q__38652BE2]
ALTER TABLE [dbo].[ISE_ACTIONS] WITH CHECK CHECK CONSTRAINT [FK__ISE_ACTIO__Mat_Q__7F2CAE86]
ALTER TABLE [dbo].[ISE_ACTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MAT_QUESTION_ID]
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1]
ALTER TABLE [dbo].[MATURITY_QUESTION_PROPS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTION_PROPS_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[TTP_MAT_QUESTION] WITH CHECK CHECK CONSTRAINT [FK_TTP_MAT_QUESTION_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_GROUPING_TYPES]
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS]

PRINT(N'Add DML triggers to [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] ENABLE TRIGGER [trg_update_maturity_groupings]
COMMIT TRANSACTION
GO
