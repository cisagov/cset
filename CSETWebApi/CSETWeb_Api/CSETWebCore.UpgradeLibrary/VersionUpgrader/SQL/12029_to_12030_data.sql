/*
Run this script on:

(localdb)\INLLocalDb2022.CSETWeb12029    -  This database will be modified

to synchronize it with:

(localdb)\INLLocalDb2022.CSETWeb12030

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.10.9.22680 from Red Gate Software Ltd at 9/5/2023 2:34:22 PM

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

PRINT(N'Drop constraints from [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Drop constraints from [dbo].[MATURITY_REFERENCE_TEXT]')
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]

PRINT(N'Drop constraints from [dbo].[SECTOR_INDUSTRY]')
ALTER TABLE [dbo].[SECTOR_INDUSTRY] NOCHECK CONSTRAINT [FK_SECTOR_INDUSTRY_SECTOR]

PRINT(N'Drop constraint FK_DEMOGRAPHICS_SECTOR_INDUSTRY from [dbo].[DEMOGRAPHICS]')
ALTER TABLE [dbo].[DEMOGRAPHICS] NOCHECK CONSTRAINT [FK_DEMOGRAPHICS_SECTOR_INDUSTRY]

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

PRINT(N'Drop constraint FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS from [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_TTP_MAT_QUESTION_MATURITY_QUESTIONS from [dbo].[TTP_MAT_QUESTION]')
ALTER TABLE [dbo].[TTP_MAT_QUESTION] NOCHECK CONSTRAINT [FK_TTP_MAT_QUESTION_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_DEMOGRAPHICS_SECTOR from [dbo].[DEMOGRAPHICS]')
ALTER TABLE [dbo].[DEMOGRAPHICS] NOCHECK CONSTRAINT [FK_DEMOGRAPHICS_SECTOR]

PRINT(N'Drop constraint FK_SECTOR_STANDARD_RECOMMENDATIONS_SECTOR from [dbo].[SECTOR_STANDARD_RECOMMENDATIONS]')
ALTER TABLE [dbo].[SECTOR_STANDARD_RECOMMENDATIONS] NOCHECK CONSTRAINT [FK_SECTOR_STANDARD_RECOMMENDATIONS_SECTOR]

PRINT(N'Drop constraints from [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_GROUPING_TYPES]
ALTER TABLE [dbo].[MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_MODELS]

PRINT(N'Drop constraint FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS from [dbo].[MATURITY_DOMAIN_REMARKS]')
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] NOCHECK CONSTRAINT [FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS]

PRINT(N'Drop constraints from [dbo].[GEN_FILE]')
ALTER TABLE [dbo].[GEN_FILE] NOCHECK CONSTRAINT [FK_GEN_FILE_FILE_REF_KEYS]
ALTER TABLE [dbo].[GEN_FILE] NOCHECK CONSTRAINT [FK_GEN_FILE_FILE_TYPE]

PRINT(N'Drop constraint FILE_KEYWORDS_GEN_FILE_FK from [dbo].[FILE_KEYWORDS]')
ALTER TABLE [dbo].[FILE_KEYWORDS] NOCHECK CONSTRAINT [FILE_KEYWORDS_GEN_FILE_FK]

PRINT(N'Drop constraint FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE from [dbo].[GEN_FILE_LIB_PATH_CORL]')
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] NOCHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE]

PRINT(N'Drop constraint FK_MATURITY_SOURCE_FILES_GEN_FILE from [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE]

PRINT(N'Drop constraint FK_REQUIREMENT_REFERENCES_GEN_FILE from [dbo].[REQUIREMENT_REFERENCES]')
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] NOCHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_GEN_FILE]

PRINT(N'Drop constraint FK_REQUIREMENT_SOURCE_FILES_GEN_FILE from [dbo].[REQUIREMENT_SOURCE_FILES]')
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] NOCHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_GEN_FILE]

PRINT(N'Drop constraint FK_SET_FILES_GEN_FILE from [dbo].[SET_FILES]')
ALTER TABLE [dbo].[SET_FILES] NOCHECK CONSTRAINT [FK_SET_FILES_GEN_FILE]

PRINT(N'Drop constraints from [dbo].[ANALYTICS_MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[ANALYTICS_MATURITY_GROUPINGS] NOCHECK CONSTRAINT [FK_ANALYTICS_MATURITY_GROUPINGS_MATURITY_MODELS]

PRINT(N'Update rows in [dbo].[MATURITY_REFERENCE_TEXT]')
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2</b></span></p><p class="p1"><span><b>[SC:SG2.SP1]&#160;</b></span><span>Identify the Organization&#8217;s High-Value Services</span></p><p class="p1"><span>Identify the organization''s high-value services, associated assets, and activities. A fundamental risk management principle is to focus on those activities that protect and sustain services and assets that most directly affect the organization''s ability to achieve its mission. This information should be made available to the Incident Management Function to support the prioritization of its detection and&#160;</span><span>response efforts.</span></p>' WHERE [Mat_Question_Id] = 1291 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2</b></span></p><p class="p1"><b>[SC:SG2.SP1]</b>&#160;Identify the Organization&#8217;s High-Value Services</p><p class="p1">Prioritize and document the list of high-value services that must be provided if a disruption occurs.&#160;Consideration of the consequences of the loss of high-value organizational services is typically part of&#160;<span>a business impact analysis. In addition, the consequences of risks to high-value services are identified&#160;</span><span>and analyzed in risk assessment activities. The organization must consider this information when&#160;</span><span>prioritizing high-value services. This information should be made available to the Incident Management&#160;</span><span>Function to support the prioritization of its detection and response efforts.</span></p>' WHERE [Mat_Question_Id] = 1292 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2</b></span></p><p class="p1"><b>[ADM:SG1.SP1]</b>&#160;Inventory Assets</p><p class="p1">Identify and inventory high-value assets (technology, information, people, and facilities). An organization must be able to identify its high-value assets, document them, and establish their value in order to develop strategies for protecting and sustaining assets commensurate with their value to services./p&gt;</p><p class="p3">Consider the following attributes for each asset:</p><p class="p2"></p><ul><li>protection and sustainment requirements</li><li>owners and custodians</li><li>physical Locations</li><li>organizational communications and data flows</li><li>critical service(s) supported</li><li>configuration standards</li><li>baseline of network operations associated</li><li>baseline of expected data flows</li></ul><p></p>' WHERE [Mat_Question_Id] = 1293 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2</b></span></p><p class="p1"><span><b>[ADM:SG1.SP1]</b></span>&#160;Inventory Assets</p><p class="p1">Organizational mission-critical systems and data should be identified, and an up-to-date inventory&#160;<span>should be provided to event detection, and incident handling and response personnel to support their&#160;</span><span>detection and response efforts.</span></p>' WHERE [Mat_Question_Id] = 1294 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><b><span>CERT-RMM Reference V1.2</span><br></b></p><p class="p1"><b>[MON:SG2.SP2]</b>&#160;Establish Collection Standards and Guidelines</p><p class="p1">Security monitoring is an important function that enables an organization to detect suspicious activity&#160;across its enterprise. Suspicious activity includes unauthorized, security-relevant changes to&#160;organizational systems and networks.&#160;</p>&#10;<p class="p1">This capability ensures that the organization can:</p><p class="p2"></p><ul><li>monitor networks and systems</li><li>analyze or monitor the output of the security monitoring activities to detect possible intrusions</li><li>notify stakeholders of suspicious behavior</li><li>provide guidance and recommendations on tool selection, installation, and configuration;&#160;analysis and monitoring techniques and methodologies; and network monitoring strategies</li></ul><p></p><p class="p2">Technologies involved in security monitoring and analysis can include IDSs, IPSs, ADSs, AVSs,&#160;<span>netflow analysis tools, NFAT, host-based monitoring, and other similar tools.</span></p><p class="p2">Personnel monitor a variety of data (e.g., host logs, firewall logs, netflows) and use intrusion detection&#160;and prevention software to monitor network behavior, looking for indications of suspicious activity.&#160;Personnel performing proactive detect capabilities may be located in various areas of an organization&#160;such as an IT group, telecommunications group, security group, or CSIRT. In some organizations, the&#160;IT or network operations staff perform this capability and communicate any suspicious activity, or&#160;relevant incident or vulnerability information to an established incident handling and response team.</p>' WHERE [Mat_Question_Id] = 1295 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><b><span>CERT-RMM Reference V1.2</span><br></b></p><p class="p1"><b>[IMC:SG2.SP1]</b>&#160;Detect and Report Events</p><p class="p1">Assets (people, information, technology, and facility) that support the organization''s critical services&#160;<span>should be monitored to include the observation of events occurring within the systems, or their&#160;</span><span>boundaries, to meet the monitoring objectives established. A comprehensive information system&#160;</span><span>monitoring capability can be achieved through a variety of tools and techniques (e.g., intrusion&#160;</span><span>detection systems, intrusion prevention systems, malicious code protection software, scanning tools,&#160;</span><span>audit record monitoring software, network monitoring software, log correlation and alerts). The&#160;</span><span>granularity of monitoring information collected should be based on organizational monitoring objectives&#160;</span><span>and the capability of information systems to support such objectives. Information system monitoring is&#160;</span><span>a foundational part of incident response.</span></p><p class="p2">The organization may need to assign priority to monitoring requirements due to resource constraints;&#160;<span>as such, the organization''s critical services may be higher priority.</span></p>' WHERE [Mat_Question_Id] = 1296 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><b><span>CERT-RMM Reference V1.2</span><br></b></p><p class="p1"><b>[COMM:SG2.SP3]</b>&#160;Provide Resilience Communications</p><p class="p1">Proactive detection requires actions by the designated staff to identify suspicious activity. The data are&#160;<span>analyzed, and any unusual or suspicious event information is communicated to the appropriate&#160;</span><span>individuals for handling.</span></p><p class="p2">Personnel performing proactive detect capabilities communicate any suspicious activity or relevant&#160;<span>incident or vulnerability information to an established incident handling and response team. In such&#160;</span><span>cases, it is important to have established procedures for communicating this information. Personnel&#160;</span><span>performing the monitoring must have criteria to help them determine what type of alerts or suspicious&#160;</span><span>activity should be escalated.</span></p>' WHERE [Mat_Question_Id] = 1297 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><b><span>CERT-RMM Reference V1.2</span><br></b></p><p class="p1"><b>[IMC:SG2.SP1]</b>&#160;Detect and Report Events</p><p class="p1">Define the methods of event detection and reporting. Define the criteria and responsibilities for&#160;<span>reporting events, and distribute throughout the organization as appropriate.</span></p><p class="p2">Examples of methods of detection:</p><p class="p3"></p><ul><li>monitoring of technical infrastructure, including network architecture and network traffic</li><li>reporting of problems or issues to the organization''s helpdesk</li><li>observation of organizational managers and users of IT services</li><li>reporting of environmental and geographical events through media such as television, radio,&#160;<span>and the Internet</span></li><li>reporting from legal or law enforcement staff</li><li>observation of a breakdown in processes or productivity of assets</li><li>external notification from other entities such as CERT</li><li>notification of results of audits or assessments</li></ul><p></p>' WHERE [Mat_Question_Id] = 1298 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><b><span>CERT-RMM Reference V1.2</span><br></b></p><p class="p1"><b>[IMC:SG2.SP2]</b>&#160;Log and Track Events</p><p class="p1">Develop and implement an incident management knowledge base that allows for the entry of event&#160;<span>reports (and the tracking of declared incidents) through all phases of their life cycle. Guidelines and&#160;</span><span>standards for the consistent documentation of events should be developed and communicated to all&#160;</span><span>those involved in the reporting and logging processes.</span></p>' WHERE [Mat_Question_Id] = 1299 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><span><b>[IMC:SG2.SP1]</b></span>&#160;Detect and Report Events</p><p class="p1">The organization should identify the most effective methods for event detection and provide a process&#160;<span>for reporting events and incidents so that they can be triaged, analyzed, and addressed. This should&#160;</span><span>include the types of events and incidents (potential and declared) to report, and the methods.</span></p><p class="p2"></p><ul><li>Require personnel to report suspected security incidents to the organization''s incident&#160;<span>response capability within a time period specified by the organization.</span></li><li>Require partners, suppliers, and others to report suspected or verified security incidents&#160;<span>within a time period specified in applicable contracts, SLAs, and other relevant documents.</span></li><li>Report security incident information to the appropriate authorities.</li></ul><p></p><p class="p2">These activities address incident reporting requirements in an organization. Ensure that the types of&#160;<span>security incidents reported, the content and timeliness of the reports, and the reporting authorities&#160;</span><span>designated, all reflect applicable laws, directives, regulations, policies, standards, and guidance.</span></p>' WHERE [Mat_Question_Id] = 1300 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><b><span>CERT-RMM Reference V1.2</span><br></b></p><p class="p1"><b>[IMC:SG2.SP4]</b>&#160;Analyze and Triage Events</p><p class="p1">Assign a category to events from the organization''s standard category definitions during the triage&#160;process to assist with prioritization and correlation, and to develop proper responses.</p>' WHERE [Mat_Question_Id] = 1301 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><span><b>[IMC:SG2.SP4]</b></span>&#160;Analyze and Triage Events</p><p class="p1">Perform correlation analysis on event reports to determine if there is affinity between two or more&#160;<span>events.</span></p>' WHERE [Mat_Question_Id] = 1302 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><span><b>[IMC:SG2.SP4]</b></span>&#160;Analyze and Triage Events</p><p class="p1">Identify the tools, techniques, and methods that the organization will use to perform event correlation.&#160;<span>Pre-approving tools, techniques, and methods ensures consistency and cost-effectiveness, as well as&#160;</span><span>validity of results. This list should include both procedural and automated methods.</span></p><p class="p2">Perform correlation analysis on detected or reported events to determine if there is affinity between two&#160;<span>or more events. Ensure that the Incident Management Function has access to the schedule of&#160;</span><span>activities that may trigger false positive alerts, to deconflict detected events as known (benign) activity.&#160;</span><span>Evidence of a single incident may be captured in several logs. Correlating events among multiple&#160;</span><span>indication sources can be invaluable in validating whether a particular incident occurred, as well as&#160;</span><span>rapidly consolidating the pieces of data. Develop specific correlative metadata and ensure that the&#160;</span><span>event logs capture (and parse or align) this data, to be correlated by either technology or by manual&#160;</span><span>process(es) such as IP addresses, ports, protocols, services, timestamps, or other indicators of&#160;</span><span>compromise that could be common between multiple log sources.</span></p>' WHERE [Mat_Question_Id] = 1303 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><b><span>[IMC:SG2.SP4]</span>&#160;</b>Analyze and Triage Events</p><p class="p1">Prioritize events. Events may be prioritized based on event knowledge, system affected, potential&#160;<span>impact, the results of categorization and correlation analysis, incident declaration criteria and&#160;</span><span>experience with past-declared incidents. Events and incidents can be categorized in a variety of ways,&#160;</span><span>such as by the attack vector or method used (e.g., probe, scan, unpatched vulnerability, password&#160;</span><span>cracking, social engineering, or phishing attack); by the impact (e.g., denial of service, compromised&#160;</span><span>account, data leakage); by the scope (e.g., number of systems affected); by the success or failure of&#160;</span><span>the attack; or other factors.</span></p>' WHERE [Mat_Question_Id] = 1304 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><b>[IMC:SG2.SP2]</b> Log and Track Events</p><p class="p1"><span><b>[IMC:SG2.SP4]</b></span>&#160;Analyze and Triage Events</p><p class="p1">The organization should have a documented process for logging events as they are identified and for&#160;<span>tracking them through the incident life cycle. Logging and tracking ensure that the event is properly&#160;</span><span>progressing through the incident life cycle and that, most importantly, is closed when an appropriate&#160;</span><span>response and post-incident review have been completed. Logging and tracking facilitate event triage&#160;</span><span>and analysis activities; provide the ability to quickly obtain a status of the event and the organization''s&#160;</span><span>disposition; provide the basis for conversion from event to incident declaration; and may be useful in&#160;</span><span>post-incident review processes when trending and root-cause analysis are performed.</span></p>' WHERE [Mat_Question_Id] = 1305 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><b><span>[IMC:SG2.SP4]</span>&#160;</b>Analyze and Triage Events</p><p class="p1">Periodically review the event and incident management tracking system for events that have not been&#160;<span>closed or that do not have a disposition. Events that have not been closed or that do not have a&#160;</span><span>disposition should be reprioritized and analyzed for resolution.</span></p><p class="p3">Possible dispositions for events include:</p><p class="p2"></p><ul><li>closed</li><li>referred for further analysis</li><li>referred to organizational unit or line of business for disposition</li><li>declared an incident and referred to incident handling and response process</li></ul><p></p>' WHERE [Mat_Question_Id] = 1306 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><span><b>[IMC:SG3.SP1]</b></span>&#160;Declare Incidents</p><p class="p1">Establish a process to declare incidents. Events that exit the triage process warranting more attention&#160;<span>may be referred to additional analysis processes for resolution, or declared as an incident and&#160;</span><span>subsequently referred to incident response processes for resolution. These events may be declared as&#160;</span><span>incidents during triage, through further event analysis, through the application of incident declaration&#160;</span><span>criteria, or during the development of response strategies.</span></p><p class="p2">Follow an established process to declare incidents. Incident declaration defines the point at which the&#160;<span>organization has established that an incident has occurred, is occurring, or is imminent, and will need&#160;</span><span>to be handled and responded to. The time from event detection to incident declaration may be&#160;</span><span>immediate, requiring little additional review and analysis. In other cases, incident declaration requires&#160;</span><span>more thoughtful analysis.</span></p>' WHERE [Mat_Question_Id] = 1308 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><span><b>[IMC:SG3.SP1]</b></span>&#160;Declare Incidents</p><p class="p1">Establish incident declaration criteria for use in guiding when to declare an incident. To guide the&#160;<span>organization in determining when to declare an incident (particularly if incident declaration is not&#160;</span><span>immediately apparent), the organization must define incident declaration criteria.</span></p>' WHERE [Mat_Question_Id] = 1309 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><span><b>[IMC:SG4.SP1]</b></span>&#160;Escalate Incidents</p><p class="p1">Develop an incident escalation process. The incident escalation process should consider the type and&#160;<span>extent of incident and the appropriate stakeholders. Incidents that the organization has declared and&#160;</span><span>that require an organizational response must be escalated to those stakeholders who can implement,&#160;</span><span>manage, and bring to closure an appropriate and timely solution. The organization must establish&#160;</span><span>processes to ensure that incidents are referred to the appropriate stakeholders, because failure to do&#160;</span><span>so will impede the organization''s response and may increase the impact on the organization. Incidents&#160;</span><span>should not be handled on a first-in, first-out basis. Instead, organizations should establish written&#160;</span><span>guidelines that outline how quickly the team must respond to the incident and what actions should be&#160;</span><span>performed, based on relevant factors such as the impact of the incident, and the likely recoverability&#160;</span><span>from the incident.</span></p>' WHERE [Mat_Question_Id] = 1310 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><span><b>[IMC:SG3.SP2]</b></span>&#160;Analyze Incidents</p><p class="p1">Incident analysis is primarily focused on helping the organization determine an appropriate response to&#160;<span>a declared incident by examining its underlying causes and actions as well as the effects of the&#160;</span><span>underlying event(s). Incident analysis should be focused on properly defining the underlying problem,&#160;</span><span>condition, or issue and in helping the organization prepare the most appropriate and timely response to&#160;</span><span>the incident.</span></p>' WHERE [Mat_Question_Id] = 1311 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><span><b>[IMC:SG3.SP2]</b></span>&#160;Analyze Incidents</p><p class="p1">Correlating activity across incidents can determine any interrelations, patterns, common intruder&#160;<span>signatures, common targets, or exploitation of common vulnerabilities.</span></p><p class="p2">Incident correlation:</p><p class="p3"></p><ul><li>broadens the view of the nature, scope, and impact of malicious activity.</li><li>identifies relationships and interdependencies that can help develop and implement&#160;<span>comprehensive solutions.</span></li></ul><p></p><p class="p2">Types of information that can be correlated include:</p><p class="p2"></p><ul><li><span>IP addresses, hostnames, ports, protocols, and services</span></li><li>targeted applications, OSs, organizational sectors, site names, and business functions</li><li>common attacks and exploits</li></ul><p></p><p class="p3">Incident correlation can identify where activity is more widespread than originally thought and identify&#160;<span>any relationships among malicious attacks, compromises, and exploited vulnerabilities. Open event&#160;</span><span>reports may correlate to the incident under analysis and provide additional information that is useful in&#160;</span><span>developing an appropriate response. Reviewing documentation on previously declared incidents may&#160;</span><span>inform the development of a response action plan, particularly if significant organizational (and&#160;</span><span>external) coordination is required.</span></p>' WHERE [Mat_Question_Id] = 1312 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><span><b>[IMC:SG3.SP2]</b></span>&#160;Analyze Incidents</p><p class="p1">Identify relevant analysis tools, techniques, and activities that the organization uses to analyze&#160;<span>incidents and develop appropriate responses. Provide appropriate levels of training for incident&#160;</span><span>management staff on analysis tools and techniques.</span></p>' WHERE [Mat_Question_Id] = 1313 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><b>[IMC:SG3.SP1]</b> Declare Incidents</p><p class="p1"><span><b>[IMC:SG3.SP2]</b></span>&#160;Analyze Incidents</p><p class="p1">Impact analysis can help determine the breadth and severity of an incident. Incident management&#160;<span>personnel may use the results of impact analysis to further prioritize cases during and after the triage&#160;</span><span>process. Without information about how an incident affects an organization, incident responders&#160;</span><span>cannot adequately plan containment, remediation, or eradication efforts.</span></p>' WHERE [Mat_Question_Id] = 1314 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><span><b>[IMC:SG5.SP1]</b></span>&#160;Perform Post-Incident Review</p><p class="p1">Identify root-cause analysis tools and techniques and ensure that all staff who participate in analysis&#160;<span>are trained in their use. These tools and techniques may include cause-and-effect diagrams,&#160;</span><span>interrelationship diagrams, causal factor tree analysis, and others.</span></p>' WHERE [Mat_Question_Id] = 1315 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><span><b>[IMC:SG4.SP1]</b></span>&#160;Escalate Incidents</p><p class="p1">Incident escalation procedures should consider the extent of the incident and the appropriate&#160;<span>stakeholders. Incidents that the organization has declared and that require an organizational response&#160;</span><span>must be escalated to those stakeholders who can implement, manage, and bring to closure an&#160;</span><span>appropriate and timely solution. Typically, these stakeholders are internal to the organization but could&#160;</span><span>be external, such as contractors or other suppliers. The organization must establish processes to&#160;</span><span>ensure that incidents are referred to the appropriate stakeholders because failure to do so will impede&#160;</span><span>the organization''s response and may increase the level to which the organization is impacted.</span></p>' WHERE [Mat_Question_Id] = 1316 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><b>[IMC:SG2.SP1]</b>&#160;Detect and Report Events</p><p class="p1"><b>[IMC:SG2.SP4]</b>&#160;Analyze and Triage Events</p><p class="p1"><span><b>[IMC:SG4.SP1]</b></span>&#160;Escalate Incidents</p><p class="p1">Organizations should have clear guidance on how to report incidents so the correct information gets to&#160;<span>the right people at the right time. Incident information reported should include the timeframes, details,&#160;</span><span>and any other relevant information. Relevant stakeholder can include asset owners, information&#160;</span><span>technology staff, physical security staff, auditors, and legal staff, as well as external stakeholders such&#160;</span><span>as vendors and suppliers, law enforcement staff, and others.</span></p>' WHERE [Mat_Question_Id] = 1317 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><b><span>[IMC:SG4.SP3]</span>&#160;</b>Communicate Incidents</p><p class="p1">The incident reporting guidance should address the stakeholders with whom communications about&#160;<span>incidents are required, and include specific details such as the methods, and under what operational&#160;</span><span>circumstances the stakeholders must be notified.</span></p><p class="p2">Document the information security requirements, because not all stakeholders may have access to the&#160;<span>same communication methods, and not all may be authorized to receive the full details of the incident.&#160;</span><span>Document the process, procedures and any other guidance to identify what information is provided to&#160;</span><span>individual or organizational stakeholders.</span></p><p class="p2">Ensure that the organizational incident reporting guidance addresses the various message types and&#160;<span>level of communications appropriate to various stakeholders. For example, incident communications&#160;</span><span>may be vastly different for incident response leadership than for those who may simply need to have&#160;</span><span>situational awareness. The plan should detail any special controls over communication (e.g.,&#160;</span><span>encryption or secured communications) that are appropriate for some stakeholders, possibly&#160;</span><span>depending on the type of incident.</span></p>' WHERE [Mat_Question_Id] = 1318 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><b>[IMC:SG4.SP2]</b>&#160;Develop Incident Response</p><p class="p1">Develop predefined procedures to provide a consistent response and to limit the effect of the incident&#160;<span>on the organization. The response to an incident describes the actions the organization takes to&#160;</span><span>prevent or contain the impact of an incident on the organization while it is occurring or shortly after it&#160;</span><span>has occurred. The range, scope, and breadth of the organizational response may vary widely&#160;</span><span>depending on the nature of the incident. The incident response procedures should address at a&#160;</span><span>minimum:</span></p><p class="p2"></p><ul><li>the essential activities (administrative, technical, and physical) that are required to contain or&#160;<span>limit damage and provide service continuity</span></li><li>existing continuity of operations and restoration plans</li><li>coordination activities with other internal staff and external agencies that must be performed&#160;<span>to implement the procedures</span></li><li>the levels of authority and access needed by responders to carry out the procedures</li><li><span>the essential activities necessary to restore services to normal operation (recovery), and the&#160;</span><span>resources involved in these activities</span></li><li>legal and regulatory obligations that must be met by the procedure</li><li>standardized responses for certain types of incidents</li></ul><p></p>' WHERE [Mat_Question_Id] = 1319 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><span><b>[IMC:SG4.SP3]</b></span>&#160;Communicate Incidents</p><p class="p1">Develop and implement an organizational incident management communications plan. The&#160;<span>organization must proactively manage communications when incidents are detected and throughout&#160;</span><span>their life cycle. This requires the organization to develop and implement a communications plan that&#160;</span><span>can be readily implemented to manage communications to internal and external stakeholders on a&#160;</span><span>regular basis and as needed. Additionally, ensure that steps within the incident management process&#160;</span><span>and workflow are documented to prompt updates to status and response activities to appropriate&#160;</span><span>stakeholders.</span></p>' WHERE [Mat_Question_Id] = 1320 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><span><b>[IMC:SG4.SP3]</b></span>&#160;Communicate Incidents</p><p class="p1">Part of an effective incident management process is the ability to quickly disseminate the correct&#160;<span>information to the right people at the right time. The internal and external stakeholders need to&#160;</span><span>understand what threats or vulnerabilities might impact them, the associated level of risk, and how to&#160;</span><span>protect against or mitigate them. Incident management personnel provide such notifications and&#160;</span><span>warnings to promote awareness of threats and malicious activity and to help support organizational&#160;</span><span>response actions. Depending on the mission of the incident management function, alerts and warnings&#160;</span><span>may be shared with other external parties. Notifications, reports, and warnings should be distributed in&#160;</span><span>a manner commensurate with the classification of the information related to the activity. Sensitive and&#160;</span><span>classified activity should be handled only through appropriate, secure mechanisms and within the&#160;</span><span>appropriate facilities.</span></p>' WHERE [Mat_Question_Id] = 1321 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><b><span>[IMC:SG4.SP4]</span>&#160;</b>Close Incidents</p><p class="p1">Incidents may be open for an extended period of time, may not have followed the organization''s&#160;<span>incident management process or may not have been formally closed. The organization must have a&#160;</span><span>process for tracking and managing incidents to closure which results in formally logging a status of&#160;</span><span>&#8220;closed&#8221; in the incident knowledge base. A &#8220;closed&#8221; status indicates to all relevant stakeholders that no&#160;</span><span>further actions are required or outstanding for the incident. It also provides notification to those affected&#160;</span><span>by the incident that it has been addressed and that they should not be subject to continuing effects.&#160;</span><span>The status of incidents in the incident database should be reviewed regularly to determine if open&#160;</span><span>incidents should be closed or need additional action.</span></p>' WHERE [Mat_Question_Id] = 1322 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'Develop and communicate consistent guidelines and standards for the collection, documentation, and
preservation of evidence for events/incidents. Document evidence information in the incident
management knowledge base where practical. Rules, laws, regulations, and policies may require
specific documentation for forensic purposes. These specific requirements must be included in the
organization''s logging and tracking process. Some information about events and/or incidents may be
confidential or sensitive, therefore the organization must be careful to limit access to event information
to only those who need to know about it.' WHERE [Mat_Question_Id] = 1325 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><b>[IMC:SG5.SP1]</b>&#160;Perform Post-Incident Review</p><p class="p1">Post-incident reviews are a part of the incident closure process. Establish criteria to determine the&#160;<span>extent of the review required for incident closure. Some examples of criteria could include:</span></p><p class="p3"></p><ul><li>severity of damage</li><li>assets involved</li><li>duration of incident</li><li>processes not followed</li><li>visibility to public or stakeholders</li><li>legal or regulatory requirements</li></ul><p></p><p class="p3">It is important to develop these criteria with the stakeholders to ensure that post-incident reviews occur&#160;<span>on all appropriate incidents, and do not consume unnecessary resources on those that do not meet the&#160;</span><span>established thresholds</span></p>' WHERE [Mat_Question_Id] = 1327 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><span><b>[IMC:SG5.SP1]</b></span>&#160;Perform Post-Incident Review</p><p class="p1">Ensure that the processes or mechanisms used to track the resolution of incidents also indicate which&#160;<span>incidents require review in accordance with established guidance. This allows the organization''s&#160;</span><span>auditing function or incident management leadership to easily identify incidents that require post-incident&#160;</span><span>reviews, and ensure that they are performed. The post-incident review should determine if the&#160;</span><span>incident response plan or process was followed. The review should also identify any needed&#160;</span><span>improvements to the incident response plan or process. Ensure that the organization''s auditing&#160;</span><span>function checks for completion of these reviews as part of regular Incident Management reviews.</span></p><p class="p2">Multiple incidents may be covered in a single meeting to optimize the resources necessary to perform&#160;<span>this function. Some organizations may find it useful to have a pre-scheduled periodic review on the&#160;</span><span>stakeholders'' calendars to ensure availability, which they can simply cancel if no incidents have&#160;</span><span>occurred that meet the review criteria.</span></p>' WHERE [Mat_Question_Id] = 1328 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><span><b>[IMC:SG5.SP2]</b></span>&#160;Translate Experience to Strategy</p><p class="p1">Review the incident knowledge-base information and update the following areas accordingly:</p><p class="p2"></p><ul><li>protection strategies and controls for assets involved in the incident</li><li>continuity plans and strategies for sustaining assets involved in the incident</li><li><span>information security and other organizational policies that need to reflect new standards,&#160;</span><span>procedures, and guidelines based on what is learned in the incident handling</span></li><li>training for staff on incident response, information security, business continuity, and IT&#160;<span>operations</span></li></ul><p></p>' WHERE [Mat_Question_Id] = 1329 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span>CERT-RMM Reference V1.2<br></span></p><p class="p1"><span>[IMC:SG5.SP2]</span>&#160;Translate Experience to Strategy</p>' WHERE [Mat_Question_Id] = 1330 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><span><b>[IMC:SG5.SP1]</b></span>&#160;Perform Post-Incident Review</p><p class="p1">This practice ensures that the results and findings of the post-incident analysis meetings or reviews of&#160;<span>&#8220;significant&#8221; incidents are generated, documented, and reported. The organization defines the meaning&#160;</span><span>of &#8220;significant.&#8221; The purpose of the reviews is to identify issues encountered and lessons learned, to&#160;</span><span>propose areas for improvement, and to act on the findings and recommendations. Post-incident&#160;</span><span>analysis of the handling of an incident may often reveal a missing step or procedural inaccuracy,&#160;</span><span>providing impetus for change. This report should detail the organization''s recommendations for&#160;</span><span>improvement in administrative, technical, and physical controls, as well as in event and incident&#160;</span><span>management processes.</span></p>' WHERE [Mat_Question_Id] = 1331 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><span><b>[SC:SG5.SP1]</b></span>&#160;Develop Testing Program and Standards</p><p class="p1"><b>[IMC:SG1.SP2]&#160;</b><span>Assign Staff to the Incident Management Plan</span></p><p class="p1">Develop a testing program and test standards to apply universally in testing all aspects of incident&#160;<span>handling and response plans. These exercises:</span></p><p class="p3"></p><ul><li>should look at the adequacy of processes and procedures through incident scenario&#160;<span>exercises (for example, perform triage, respond to events and incidents in a timely manner,&#160;</span><span>notify correct people, protect data during response activities, or meet SLAs)</span></li><li>may involve simulated incidents</li><li>can be performed throughout the whole organization or for specific organizational business&#160;<span>units</span></li><li>may be internal to the organization or part of a broader, multi-organization exercise</li></ul><p></p>' WHERE [Mat_Question_Id] = 1332 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><span><b>[SC:SG5.SP1]</b></span>&#160;Develop Testing Program and Standards</p><p class="p1">Guidance helps ensure regular and consistent testing of the incident detection, handling, and response&#160;<span>processes. Periodic testing should be conducted to ensure that these activities are effective and&#160;</span><span>complete, and that personnel understand their roles and responsibilities. A comprehensive,&#160;</span><span>organization-wide schedule for testing should be established based on factors such as risk, potential&#160;</span><span>consequences to the organization, and other organizationally-derived factors.</span></p>' WHERE [Mat_Question_Id] = 1333 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><span><b>[SC:SG5.SP1]</b></span>&#160;Develop Testing Program and Standards</p><p class="p1">Establish a schedule for ongoing testing and review of plans and processes. The proposed schedule&#160;<span>for testing should be coordinated among stakeholders for situational awareness and for gathering their&#160;</span><span>input on objectives and secure participation. Ensure that the testing schedule does not conflict with&#160;</span><span>major system or organizational changes that a simultaneous test or exercise could impact negatively,&#160;</span><span>or vice versa. Similarly, ensure that testing aligns with major system or organizational changes as&#160;</span><span>appropriate, to confirm that incident detection, handling, and response activities are not impacted&#160;</span><span>negatively by the change(s). Because testing can require significant planning to be conducted&#160;</span><span>effectively, periodically review the schedule to ensure that resources are not expended on planning&#160;</span><span>activities that risk being canceled due to external activities or dependencies.</span></p>' WHERE [Mat_Question_Id] = 1334 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><span><b>[SC:SG5.SP3]</b></span>&#160;Exercise Plans</p><p class="p1">Conduct tests of the incident detection, handling, and response processes on a regular basis. The test&#160;<span>should establish the viability, accuracy, and completeness of the incident detection, incident handling,&#160;</span><span>and incident response processes and activities. Test results should be recorded and documented for&#160;</span><span>resolution of gaps and overall improvement.</span></p>' WHERE [Mat_Question_Id] = 1335 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><b><span>[SC:SG5.SP2]</span>&#160;</b>Develop and Document Test Plans</p><p class="p1">The incident response test plan should identify all internal and external stakeholders involved in the&#160;<span>testing exercise, and their roles and expected participation. The organization should ensure that all&#160;</span><span>relevant stakeholders are involved in the planned testing.</span></p>' WHERE [Mat_Question_Id] = 1336 AND [Sequence] = 1
UPDATE [dbo].[MATURITY_REFERENCE_TEXT] SET [Reference_Text]=N'<p class="p1"><span><b>CERT-RMM Reference V1.2<br></b></span></p><p class="p1"><b>[SC:SG5.SP4]</b>&#160;Evaluate Plan Test Results</p><p class="p1">Compare actual test results with expected test results and test objectives. Areas where objectives&#160;<span>could not be met should be recorded, and strategies developed to review and revise incident detection,&#160;</span><span>handling, and response processes. Improvements to the testing process and test plans should be&#160;</span><span>identified, documented, and incorporated into future tests.</span></p>' WHERE [Mat_Question_Id] = 1337 AND [Sequence] = 1
PRINT(N'Operation applied to 43 rows out of 43')

PRINT(N'Update rows in [dbo].[SECTOR_INDUSTRY]')
UPDATE [dbo].[SECTOR_INDUSTRY] SET [Is_Other]=1 WHERE [SectorId] = 1 AND [IndustryId] = 1
UPDATE [dbo].[SECTOR_INDUSTRY] SET [Is_Other]=1 WHERE [SectorId] = 2 AND [IndustryId] = 5
UPDATE [dbo].[SECTOR_INDUSTRY] SET [Is_Other]=1 WHERE [SectorId] = 3 AND [IndustryId] = 11
UPDATE [dbo].[SECTOR_INDUSTRY] SET [Is_Other]=1 WHERE [SectorId] = 4 AND [IndustryId] = 16
UPDATE [dbo].[SECTOR_INDUSTRY] SET [Is_Other]=1 WHERE [SectorId] = 5 AND [IndustryId] = 20
UPDATE [dbo].[SECTOR_INDUSTRY] SET [Is_Other]=1 WHERE [SectorId] = 6 AND [IndustryId] = 31
UPDATE [dbo].[SECTOR_INDUSTRY] SET [Is_Other]=1 WHERE [SectorId] = 7 AND [IndustryId] = 42
UPDATE [dbo].[SECTOR_INDUSTRY] SET [Is_Other]=1 WHERE [SectorId] = 8 AND [IndustryId] = 46
UPDATE [dbo].[SECTOR_INDUSTRY] SET [Is_Other]=1 WHERE [SectorId] = 9 AND [IndustryId] = 48
UPDATE [dbo].[SECTOR_INDUSTRY] SET [Is_Other]=1 WHERE [SectorId] = 10 AND [IndustryId] = 54
UPDATE [dbo].[SECTOR_INDUSTRY] SET [Is_Other]=1 WHERE [SectorId] = 11 AND [IndustryId] = 56
UPDATE [dbo].[SECTOR_INDUSTRY] SET [Is_Other]=1 WHERE [SectorId] = 12 AND [IndustryId] = 61
UPDATE [dbo].[SECTOR_INDUSTRY] SET [Is_Other]=1 WHERE [SectorId] = 13 AND [IndustryId] = 64
UPDATE [dbo].[SECTOR_INDUSTRY] SET [Is_Other]=1 WHERE [SectorId] = 14 AND [IndustryId] = 66
UPDATE [dbo].[SECTOR_INDUSTRY] SET [Is_Other]=1 WHERE [SectorId] = 15 AND [IndustryId] = 73
UPDATE [dbo].[SECTOR_INDUSTRY] SET [Is_Other]=1 WHERE [SectorId] = 16 AND [IndustryId] = 75
PRINT(N'Operation applied to 16 rows out of 16')

PRINT(N'Update rows in [dbo].[MATURITY_QUESTIONS]')
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'2. Do event and incident handling personnel have access to an up-to-date vulnerability management repository?' WHERE [Mat_Question_Id] = 1341
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'5. Do documented procedures exist for defining tool requirements, and for acquiring, developing, deploying, and maintaining tools (e.g., a System Development Life Cycle)?' WHERE [Mat_Question_Id] = 1351
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'1. Are dependencies on external relationships that are critical to the Incident Management Function identified?' WHERE [Mat_Question_Id] = 1372
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Measures to formally document the containment and control of all incidents.' WHERE [Mat_Question_Id] = 7596
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Measures to formally document the containment and control of all incidents.' WHERE [Mat_Question_Id] = 7663
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'A process that identifies all business functions and prioritizes them in order of criticality (business impact analysis)' WHERE [Mat_Question_Id] = 7676
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 7.7', [Sequence]=8 WHERE [Mat_Question_Id] = 7740
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 7.8', [Sequence]=9 WHERE [Mat_Question_Id] = 7741
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 7.9', [Sequence]=10 WHERE [Mat_Question_Id] = 7742
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 7.10', [Sequence]=11 WHERE [Mat_Question_Id] = 7743
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 7.11', [Sequence]=12 WHERE [Mat_Question_Id] = 7744
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 7.12', [Sequence]=13 WHERE [Mat_Question_Id] = 7745
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 7.13', [Sequence]=14 WHERE [Mat_Question_Id] = 7746
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 8.10', [Sequence]=11 WHERE [Mat_Question_Id] = 7747
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 8.11', [Sequence]=12 WHERE [Mat_Question_Id] = 7748
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 8.12', [Sequence]=13 WHERE [Mat_Question_Id] = 7749
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 8.13', [Sequence]=14 WHERE [Mat_Question_Id] = 7750
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 8.14', [Sequence]=15 WHERE [Mat_Question_Id] = 7751
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 8.15', [Sequence]=16 WHERE [Mat_Question_Id] = 7752
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 8.16', [Sequence]=17 WHERE [Mat_Question_Id] = 7753
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 8.17', [Sequence]=18 WHERE [Mat_Question_Id] = 7754
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 8.18', [Sequence]=19 WHERE [Mat_Question_Id] = 7755
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 9.6', [Sequence]=7 WHERE [Mat_Question_Id] = 7756
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 9.7', [Sequence]=8 WHERE [Mat_Question_Id] = 7757
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 9.8', [Sequence]=9 WHERE [Mat_Question_Id] = 7758
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 9.9', [Sequence]=10 WHERE [Mat_Question_Id] = 7759
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 9.10', [Sequence]=11 WHERE [Mat_Question_Id] = 7760
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 9.11', [Sequence]=12 WHERE [Mat_Question_Id] = 7761
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 9.12', [Sequence]=13 WHERE [Mat_Question_Id] = 7762
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 9.13', [Sequence]=14 WHERE [Mat_Question_Id] = 7763
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 9.14', [Sequence]=15 WHERE [Mat_Question_Id] = 7764
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 9.15', [Sequence]=16 WHERE [Mat_Question_Id] = 7765
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 9.16', [Sequence]=17 WHERE [Mat_Question_Id] = 7766
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 9.17', [Sequence]=18 WHERE [Mat_Question_Id] = 7767
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 9.18', [Sequence]=19 WHERE [Mat_Question_Id] = 7768
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 9.19', [Sequence]=20 WHERE [Mat_Question_Id] = 7769
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 9.20', [Sequence]=21 WHERE [Mat_Question_Id] = 7770
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Stmt 9.21', [Sequence]=22 WHERE [Mat_Question_Id] = 7771
PRINT(N'Operation applied to 38 rows out of 38')

PRINT(N'Update rows in [dbo].[MATURITY_GROUPINGS]')
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Abbreviation]=N'G1' WHERE [Grouping_Id] = 207
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Abbreviation]=N'G2' WHERE [Grouping_Id] = 208
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Abbreviation]=N'G3' WHERE [Grouping_Id] = 209
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Abbreviation]=N'G1' WHERE [Grouping_Id] = 211
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Abbreviation]=N'G2' WHERE [Grouping_Id] = 212
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Abbreviation]=N'G3' WHERE [Grouping_Id] = 213
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Abbreviation]=N'G4' WHERE [Grouping_Id] = 214
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Abbreviation]=N'G1' WHERE [Grouping_Id] = 216
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Abbreviation]=N'G2' WHERE [Grouping_Id] = 217
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Abbreviation]=N'G1' WHERE [Grouping_Id] = 219
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Abbreviation]=N'G2' WHERE [Grouping_Id] = 220
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Abbreviation]=N'G3' WHERE [Grouping_Id] = 221
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Abbreviation]=N'G4' WHERE [Grouping_Id] = 222
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Abbreviation]=N'G1' WHERE [Grouping_Id] = 224
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Abbreviation]=N'G2' WHERE [Grouping_Id] = 225
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Abbreviation]=N'G1' WHERE [Grouping_Id] = 227
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Abbreviation]=N'G2' WHERE [Grouping_Id] = 228
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Abbreviation]=N'G3' WHERE [Grouping_Id] = 229
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Abbreviation]=N'G4' WHERE [Grouping_Id] = 230
UPDATE [dbo].[MATURITY_GROUPINGS] SET [Abbreviation]=N'G5' WHERE [Grouping_Id] = 231
PRINT(N'Operation applied to 20 rows out of 20')

PRINT(N'Update rows in [dbo].[GEN_FILE]')
UPDATE [dbo].[GEN_FILE] SET [Title]=N'Security Directive Pipeline-2021-02C', [Short_Name]=N'TSA SD Pipeline-2021-02C' WHERE [Gen_File_Id] = 5070
UPDATE [dbo].[GEN_FILE] SET [Title]=N'Security Directive Pipeline-2021-02D', [Short_Name]=N'TSA SD Pipeline-2021-02D' WHERE [Gen_File_Id] = 5071
PRINT(N'Operation applied to 2 rows out of 2')

PRINT(N'Add rows to [dbo].[ANALYTICS_MATURITY_GROUPINGS]')
INSERT INTO [dbo].[ANALYTICS_MATURITY_GROUPINGS] ([Maturity_Model_Id], [Maturity_Question_Id], [Question_Group]) VALUES (10, 9918, N'Training')
INSERT INTO [dbo].[ANALYTICS_MATURITY_GROUPINGS] ([Maturity_Model_Id], [Maturity_Question_Id], [Question_Group]) VALUES (10, 9919, N'Incident Response')
INSERT INTO [dbo].[ANALYTICS_MATURITY_GROUPINGS] ([Maturity_Model_Id], [Maturity_Question_Id], [Question_Group]) VALUES (10, 9920, N'Incident Response')
INSERT INTO [dbo].[ANALYTICS_MATURITY_GROUPINGS] ([Maturity_Model_Id], [Maturity_Question_Id], [Question_Group]) VALUES (10, 9921, N'Third-Party Risk Management')
INSERT INTO [dbo].[ANALYTICS_MATURITY_GROUPINGS] ([Maturity_Model_Id], [Maturity_Question_Id], [Question_Group]) VALUES (10, 9922, N'Training')
INSERT INTO [dbo].[ANALYTICS_MATURITY_GROUPINGS] ([Maturity_Model_Id], [Maturity_Question_Id], [Question_Group]) VALUES (10, 9923, N'Incident Response')
INSERT INTO [dbo].[ANALYTICS_MATURITY_GROUPINGS] ([Maturity_Model_Id], [Maturity_Question_Id], [Question_Group]) VALUES (10, 9924, N'Incident Response')
INSERT INTO [dbo].[ANALYTICS_MATURITY_GROUPINGS] ([Maturity_Model_Id], [Maturity_Question_Id], [Question_Group]) VALUES (10, 9925, N'Third-Party Risk Management')
PRINT(N'Operation applied to 8 rows out of 8')

PRINT(N'Add row to [dbo].[CSF_MAPPING]')
INSERT INTO [dbo].[CSF_MAPPING] ([CSF_Code], [Question_Type], [Question_Id]) VALUES (N'PR.PT', N'Maturity', 1349)

PRINT(N'Add rows to [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS]')
SET IDENTITY_INSERT [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ON
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (1, N'ORG-TYPE', 1, 1, N'Industry')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (2, N'ORG-TYPE', 2, 2, N'Federal Entity')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (3, N'ORG-TYPE', 3, 3, N'SLTT')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (4, N'NUM-EMP-TOTAL', 1, 1, N'< 100')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (5, N'NUM-EMP-TOTAL', 2, 2, N'100-500')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (6, N'NUM-EMP-TOTAL', 3, 3, N'501-1,000')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (7, N'NUM-EMP-TOTAL', 4, 4, N'1,001-5,000')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (8, N'NUM-EMP-TOTAL', 5, 5, N'5,001-10,000')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (9, N'NUM-EMP-TOTAL', 6, 6, N'10,001-50,000')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (10, N'NUM-EMP-TOTAL', 7, 7, N'50,001-100,000')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (11, N'NUM-EMP-TOTAL', 8, 8, N'> 100,000')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (12, N'NUM-EMP-UNIT', 1, 1, N'N/A')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (13, N'NUM-EMP-UNIT', 2, 2, N'< 50')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (14, N'NUM-EMP-UNIT', 3, 3, N'50-100')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (15, N'NUM-EMP-UNIT', 4, 4, N'101-250')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (16, N'NUM-EMP-UNIT', 5, 5, N'251-500')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (17, N'NUM-EMP-UNIT', 6, 6, N'501-1,000')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (18, N'NUM-EMP-UNIT', 7, 7, N'1,001-2,500')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (19, N'NUM-EMP-UNIT', 8, 8, N'2,501-5,000')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (20, N'NUM-EMP-UNIT', 9, 9, N'5,001-10,000')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (21, N'NUM-EMP-UNIT', 10, 10, N'> 10,000')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (22, N'ANN-REVENUE', 1, 1, N'< $100,000')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (23, N'ANN-REVENUE', 2, 2, N'$100,000 - $500,000')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (24, N'ANN-REVENUE', 3, 3, N'$500,000 - $1 million')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (25, N'ANN-REVENUE', 4, 4, N'$1M - $10M')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (26, N'ANN-REVENUE', 5, 5, N'$10M - $100M')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (27, N'ANN-REVENUE', 6, 6, N'$100M - $500M')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (28, N'ANN-REVENUE', 7, 7, N'$500M - $1B')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (29, N'ANN-REVENUE', 8, 8, N'> $1B')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (30, N'ANN-REVENUE-PERCENT', 1, 1, N'1-10%')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (31, N'ANN-REVENUE-PERCENT', 2, 2, N'11-20%')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (32, N'ANN-REVENUE-PERCENT', 3, 3, N'21-30%')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (33, N'ANN-REVENUE-PERCENT', 4, 4, N'31-40%')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (34, N'ANN-REVENUE-PERCENT', 5, 5, N'41-50%')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (35, N'ANN-REVENUE-PERCENT', 6, 6, N'51-60%')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (36, N'ANN-REVENUE-PERCENT', 7, 7, N'61-70%')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (37, N'ANN-REVENUE-PERCENT', 8, 8, N'71-80%')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (38, N'ANN-REVENUE-PERCENT', 9, 9, N'81-90%')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (39, N'ANN-REVENUE-PERCENT', 10, 10, N'91-100%')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (40, N'SHARE-ORG-1', 1, 1, N'ISAC and/ or Coordinating Council')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (41, N'SHARE-ORG-2', 2, 2, N'FBI - InfraGard')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (42, N'SHARE-ORG-3', 3, 3, N'Cybersecurity suppliers/ consultants')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (43, N'SHARE-ORG-4', 4, 4, N'Department of Homeland Security')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (44, N'SHARE-ORG-5', 5, 5, N'State or local government group')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (45, N'SHARE-ORG-6', 6, 6, N'Industry peers(informal exchanges)')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (46, N'SHARE-ORG-7', 7, 7, N'NCFTA')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (47, N'REG-TYPE', 1, 1, N'Federal regulation, not industry specific (HIPAA, FTC, DFARS)')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (48, N'REG-TYPE', 2, 2, N'Federal regulation, industry specific (NERC-CIP)')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (49, N'REG-TYPE', 3, 3, N'Federal civilian agency oversight (FISMA)')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (50, N'REG-TYPE', 4, 4, N'State regulation, not industry specific (breach notification)')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (51, N'REG-TYPE', 5, 5, N'State regulation, industry specific')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (52, N'REG-TYPE', 6, 6, N'State civilian agency oversight')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (53, N'BARRIER', 1, 1, N'Potential for increased regulatory scrutiny')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (54, N'BARRIER', 2, 2, N'Potential for legal action')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (55, N'BARRIER', 3, 3, N'Anti - trust regulation')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (56, N'BARRIER', 4, 4, N'Privacy regulation')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (57, N'BARRIER', 5, 5, N'Confidentiality of company information')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (58, N'BARRIER', 6, 6, N'Impact on reputation')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (59, N'BARRIER', 7, 7, N'Relevancy of the information available')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (60, N'NUM-PEOPLE-SERVED', 1, 1, N'N/A')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (61, N'NUM-PEOPLE-SERVED', 2, 2, N'Less than 1,000')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (62, N'NUM-PEOPLE-SERVED', 3, 3, N'1,001 to 10,000')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (63, N'NUM-PEOPLE-SERVED', 4, 4, N'10,001 to 50,000')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (64, N'NUM-PEOPLE-SERVED', 5, 5, N'50,001 to 100,000')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (65, N'NUM-PEOPLE-SERVED', 6, 6, N'100,001 to 500,000')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (66, N'NUM-PEOPLE-SERVED', 7, 7, N'500,001 to 1 Million')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (67, N'NUM-PEOPLE-SERVED', 8, 8, N'1 Million to 10 Million')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (68, N'NUM-PEOPLE-SERVED', 9, 9, N'10 Million to 50 Million')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (69, N'STANDARD', 1, 1, N'NIST SP 800 series')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (70, N'STANDARD', 2, 2, N'ISO/IEC 27000 series')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (71, N'STANDARD', 3, 3, N'COBIT')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (72, N'STANDARD', 4, 4, N'ITIL')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (73, N'STANDARD', 5, 5, N'HITRUST')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (74, N'STANDARD', 6, 6, N'ISF Standard of Good Practice (SOGP)')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (75, N'STANDARD', 7, 7, N'NERC CIP')
INSERT INTO [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] ([Option_Id], [DataItemName], [Sequence], [OptionValue], [OptionText]) VALUES (76, N'STANDARD', 8, 8, N'FIPS 199')
SET IDENTITY_INSERT [dbo].[DETAILS_DEMOGRAPHICS_OPTIONS] OFF
PRINT(N'Operation applied to 76 rows out of 76')

PRINT(N'Add row to [dbo].[GEN_FILE]')
SET IDENTITY_INSERT [dbo].[GEN_FILE] ON
INSERT INTO [dbo].[GEN_FILE] ([Gen_File_Id], [File_Type_Id], [File_Name], [Title], [Name], [File_Size], [Doc_Num], [Comments], [Description], [Short_Name], [Publish_Date], [Doc_Version], [Summary], [Source_Type], [Data], [Is_Uploaded]) VALUES (5072, 31, N'sd-pipeline-2021-01c.pdf', N'Security Directive Pipeline-2021-01C', NULL, NULL, N'NONE', NULL, NULL, N'TSA SD Pipeline-2021-01C', NULL, NULL, NULL, NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[GEN_FILE] OFF

PRINT(N'Add rows to [dbo].[SECTOR]')
SET IDENTITY_INSERT [dbo].[SECTOR] ON
INSERT INTO [dbo].[SECTOR] ([SectorId], [SectorName], [Is_NIPP], [NIPP_sector]) VALUES (17, N'Agriculture and Food', 1, NULL)
INSERT INTO [dbo].[SECTOR] ([SectorId], [SectorName], [Is_NIPP], [NIPP_sector]) VALUES (18, N'Banking and Finance', 1, NULL)
INSERT INTO [dbo].[SECTOR] ([SectorId], [SectorName], [Is_NIPP], [NIPP_sector]) VALUES (19, N'Chemical and Hazardous Materials Industry', 1, NULL)
INSERT INTO [dbo].[SECTOR] ([SectorId], [SectorName], [Is_NIPP], [NIPP_sector]) VALUES (20, N'Commercial Facilities', 1, NULL)
INSERT INTO [dbo].[SECTOR] ([SectorId], [SectorName], [Is_NIPP], [NIPP_sector]) VALUES (21, N'Communications', 1, NULL)
INSERT INTO [dbo].[SECTOR] ([SectorId], [SectorName], [Is_NIPP], [NIPP_sector]) VALUES (22, N'Dams', 1, NULL)
INSERT INTO [dbo].[SECTOR] ([SectorId], [SectorName], [Is_NIPP], [NIPP_sector]) VALUES (23, N'Defense Industrial Base', 1, NULL)
INSERT INTO [dbo].[SECTOR] ([SectorId], [SectorName], [Is_NIPP], [NIPP_sector]) VALUES (24, N'Emergency Services', 1, NULL)
INSERT INTO [dbo].[SECTOR] ([SectorId], [SectorName], [Is_NIPP], [NIPP_sector]) VALUES (25, N'Energy', 1, NULL)
INSERT INTO [dbo].[SECTOR] ([SectorId], [SectorName], [Is_NIPP], [NIPP_sector]) VALUES (26, N'Government Facilities', 1, NULL)
INSERT INTO [dbo].[SECTOR] ([SectorId], [SectorName], [Is_NIPP], [NIPP_sector]) VALUES (27, N'Healthcare and Public Health', 1, NULL)
INSERT INTO [dbo].[SECTOR] ([SectorId], [SectorName], [Is_NIPP], [NIPP_sector]) VALUES (28, N'Information Technology', 1, NULL)
INSERT INTO [dbo].[SECTOR] ([SectorId], [SectorName], [Is_NIPP], [NIPP_sector]) VALUES (29, N'Manufacturing', 1, NULL)
INSERT INTO [dbo].[SECTOR] ([SectorId], [SectorName], [Is_NIPP], [NIPP_sector]) VALUES (30, N'National Monuments and Icons', 1, NULL)
INSERT INTO [dbo].[SECTOR] ([SectorId], [SectorName], [Is_NIPP], [NIPP_sector]) VALUES (31, N'Nuclear Reactors, Materials, and Waste', 1, NULL)
INSERT INTO [dbo].[SECTOR] ([SectorId], [SectorName], [Is_NIPP], [NIPP_sector]) VALUES (32, N'Postal and Shipping', 1, NULL)
INSERT INTO [dbo].[SECTOR] ([SectorId], [SectorName], [Is_NIPP], [NIPP_sector]) VALUES (33, N'Transportation', 1, NULL)
INSERT INTO [dbo].[SECTOR] ([SectorId], [SectorName], [Is_NIPP], [NIPP_sector]) VALUES (34, N'Water', 1, NULL)
SET IDENTITY_INSERT [dbo].[SECTOR] OFF
PRINT(N'Operation applied to 18 rows out of 18')

PRINT(N'Add rows to [dbo].[MATURITY_QUESTIONS]')
SET IDENTITY_INSERT [dbo].[MATURITY_QUESTIONS] ON
INSERT INTO [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id], [Question_Title], [Question_Text], [Supplemental_Info], [Category], [Sub_Category], [Maturity_Level_Id], [Sequence], [Maturity_Model_Id], [Parent_Question_Id], [Ranking], [Grouping_Id], [Examination_Approach], [Short_Name], [Mat_Question_Type], [Parent_Option_Id], [Supplemental_Fact], [Scope], [Recommend_Action], [Risk_Addressed], [Services]) VALUES (9918, N'Stmt 4.6', N'Training to all employees, emphasizing the importance of reporting cyber incidents and the potential consequences of noncompliance to ensure employees understand their role in identifying and reporting incidents.', N'', N'Examination Statements', N'', 17, 7, 10, 7588, NULL, 2544, N'', NULL, NULL, NULL, N'', NULL, NULL, NULL, NULL)
INSERT INTO [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id], [Question_Title], [Question_Text], [Supplemental_Info], [Category], [Sub_Category], [Maturity_Level_Id], [Sequence], [Maturity_Model_Id], [Parent_Question_Id], [Ranking], [Grouping_Id], [Examination_Approach], [Short_Name], [Mat_Question_Type], [Parent_Option_Id], [Supplemental_Fact], [Scope], [Recommend_Action], [Risk_Addressed], [Services]) VALUES (9919, N'Stmt 5.8', N'Incident Response Plans have been updated to incorporate 12 CFR 748.1, reporting requirement timeframes and procedures for notifying the NCUA. Ensuring the plan includes clear guidelines for identifying reportable incidents and escalation procedures for notifying management and the NCUA', N'', N'Examination Statements', N'', 17, 9, 10, 7594, NULL, 2545, N'', NULL, NULL, NULL, N'', NULL, NULL, NULL, NULL)
INSERT INTO [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id], [Question_Title], [Question_Text], [Supplemental_Info], [Category], [Sub_Category], [Maturity_Level_Id], [Sequence], [Maturity_Model_Id], [Parent_Question_Id], [Ranking], [Grouping_Id], [Examination_Approach], [Short_Name], [Mat_Question_Type], [Parent_Option_Id], [Supplemental_Fact], [Scope], [Recommend_Action], [Risk_Addressed], [Services]) VALUES (9920, N'Stmt 5.9', N'Periodic testing of the incident response plan is conducted to ensure roles, responsibilities, procedures, countermeasures, and reporting are working as intended.', N'', N'Examination Statements', N'', 17, 10, 10, 7594, NULL, 2545, N'', NULL, NULL, NULL, N'', NULL, NULL, NULL, NULL)
INSERT INTO [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id], [Question_Title], [Question_Text], [Supplemental_Info], [Category], [Sub_Category], [Maturity_Level_Id], [Sequence], [Maturity_Model_Id], [Parent_Question_Id], [Ranking], [Grouping_Id], [Examination_Approach], [Short_Name], [Mat_Question_Type], [Parent_Option_Id], [Supplemental_Fact], [Scope], [Recommend_Action], [Risk_Addressed], [Services]) VALUES (9921, N'Stmt 6.5', N'Contracts with critical service providers are appropriately identified and reviewed to ensure provisions requiring timely notification of cyber incidents are aligned with credit union policy and expectations', N'', N'Examination Statements', N'', 17, 6, 10, 7602, NULL, 2546, N'', NULL, NULL, NULL, N'', NULL, NULL, NULL, NULL)
INSERT INTO [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id], [Question_Title], [Question_Text], [Supplemental_Info], [Category], [Sub_Category], [Maturity_Level_Id], [Sequence], [Maturity_Model_Id], [Parent_Question_Id], [Ranking], [Grouping_Id], [Examination_Approach], [Short_Name], [Mat_Question_Type], [Parent_Option_Id], [Supplemental_Fact], [Scope], [Recommend_Action], [Risk_Addressed], [Services]) VALUES (9922, N'Stmt 7.6', N'Training to all employees, emphasizing the importance of reporting cyber incidents and the potential consequences of noncompliance to ensure employees understand their role in identifying and reporting incidents.', N'', N'Examination Statements', N'', 18, 7, 10, 7655, NULL, 2556, N'', NULL, NULL, NULL, N'', NULL, NULL, NULL, NULL)
INSERT INTO [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id], [Question_Title], [Question_Text], [Supplemental_Info], [Category], [Sub_Category], [Maturity_Level_Id], [Sequence], [Maturity_Model_Id], [Parent_Question_Id], [Ranking], [Grouping_Id], [Examination_Approach], [Short_Name], [Mat_Question_Type], [Parent_Option_Id], [Supplemental_Fact], [Scope], [Recommend_Action], [Risk_Addressed], [Services]) VALUES (9923, N'Stmt 8.8', N'Incident Response Plans have been updated to incorporate 12 CFR 748.1, reporting requirement timeframes and procedures for notifying the NCUA. Ensuring the plan includes clear guidelines for identifying reportable incidents and escalation procedures for notifying management and the NCUA', N'', N'Examination Statements', N'', 18, 9, 10, 7661, NULL, 2557, N'', NULL, NULL, NULL, N'', NULL, NULL, NULL, NULL)
INSERT INTO [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id], [Question_Title], [Question_Text], [Supplemental_Info], [Category], [Sub_Category], [Maturity_Level_Id], [Sequence], [Maturity_Model_Id], [Parent_Question_Id], [Ranking], [Grouping_Id], [Examination_Approach], [Short_Name], [Mat_Question_Type], [Parent_Option_Id], [Supplemental_Fact], [Scope], [Recommend_Action], [Risk_Addressed], [Services]) VALUES (9924, N'Stmt 8.9', N'Periodic testing of the incident response plan is conducted to ensure roles, responsibilities, procedures, countermeasures, and reporting are working as intended.', N'', N'Examination Statements', N'', 18, 10, 10, 7661, NULL, 2557, N'', NULL, NULL, NULL, N'', NULL, NULL, NULL, NULL)
INSERT INTO [dbo].[MATURITY_QUESTIONS] ([Mat_Question_Id], [Question_Title], [Question_Text], [Supplemental_Info], [Category], [Sub_Category], [Maturity_Level_Id], [Sequence], [Maturity_Model_Id], [Parent_Question_Id], [Ranking], [Grouping_Id], [Examination_Approach], [Short_Name], [Mat_Question_Type], [Parent_Option_Id], [Supplemental_Fact], [Scope], [Recommend_Action], [Risk_Addressed], [Services]) VALUES (9925, N'Stmt 9.5', N'Contracts with critical service providers are appropriately identified and reviewed to ensure provisions requiring timely notification of cyber incidents are aligned with credit union policy and expectations', N'', N'Examination Statements', N'', 18, 6, 10, 7669, NULL, 2558, N'', NULL, NULL, NULL, N'', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[MATURITY_QUESTIONS] OFF
PRINT(N'Operation applied to 8 rows out of 8')

PRINT(N'Add rows to [dbo].[SECTOR_INDUSTRY]')
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (17, 121, N'Agricultural and Food Product Distribution', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (17, 122, N'Agricultural and Food Product Transportation', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (17, 123, N'Agriculture and Food Product Storage and Distribution Warehouse', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (17, 124, N'Agriculture and Food Supporting Facility', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (17, 125, N'Other Agriculture and Food', 1, 1, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (17, 126, N'Processing, Packaging, and Production', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (17, 127, N'Regulatory, Oversight, or Industry Organization', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (17, 128, N'Supply', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (18, 129, N'Banking and Credit', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (18, 130, N'Insurance Company', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (18, 131, N'Securities, Commodities, or Financial Investment', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (19, 132, N'Chemical Manufacturing or Processing Plant', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (19, 133, N'Hazardous Chemical Storage/Stockpile/Utilization/Distribution', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (19, 134, N'Hazardous Chemical Transport', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (19, 135, N'Other Chemical and Hazardous Material', 1, 1, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (19, 136, N'Regulatory, Oversight, or Industry Organization', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (20, 137, N'Entertainment or Media Facility', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (20, 138, N'Gaming Facility/Casino', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (20, 139, N'Lodging Facility', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (20, 140, N'Other Commercial Facility', 1, 1, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (20, 141, N'Public Assembly', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (20, 142, N'Real Estate Facility', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (20, 143, N'Retail Facility', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (21, 144, N'Information Services', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (21, 145, N'Internet', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (21, 146, N'Next Generation Network', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (21, 147, N'Other Communication Facility', 1, 1, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (21, 148, N'Regulatory, Oversight, or Industry Organization', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (21, 149, N'Satellite Communication', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (21, 150, N'Telecomm Hotel', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (21, 151, N'Wired Communication', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (21, 152, N'Wireless Communication', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (22, 153, N'Dam Project', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (22, 154, N'Flood Damage Reduction System', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (22, 155, N'Hurricane or Storm Surge Protection System', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (22, 156, N'Mine Tailings and Industrial Waste Impoundment', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (22, 157, N'Regulatory, Oversight, or Industry Organization', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (23, 158, N'Aircraft Industry', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (23, 159, N'Ammunition Industry', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (23, 160, N'Combat Vehicle Industry', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (23, 161, N'Electrical Industry Commodity Manufacturing', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (23, 162, N'Electronic Industry Commodity Manufacturing', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (23, 163, N'Electronics Industry', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (23, 164, N'Information Technology Industry', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (23, 165, N'Mechanical Industry Commodity Manufacturing', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (23, 166, N'Missile Industry', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (23, 167, N'Research & Development Facility', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (23, 168, N'Shipbuilding Industry', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (23, 169, N'Space Industry', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (23, 170, N'Structural Industry Commodity Manufacturing', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (23, 171, N'Troop Support Industry', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (23, 172, N'Weapons Industry', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (24, 173, N'Emergency Management', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (24, 174, N'Emergency Medical Services (EMS)', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (24, 175, N'Fire and Emergency Services', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (24, 176, N'Law Enforcement', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (24, 177, N'Other Emergency Services Facility', 1, 1, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (24, 178, N'Public Works', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (25, 179, N'Biodiesel', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (25, 180, N'Coal', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (25, 181, N'Electricity', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (25, 182, N'Ethanol', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (25, 183, N'Hydrogen', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (25, 184, N'Natural Gas', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (25, 185, N'Other Energy Conversion System', 1, 1, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (25, 186, N'Petroleum', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (25, 187, N'Regulatory, Oversight, or Industry Organization', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (26, 188, N'Education Facility', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (26, 189, N'Election Infrastructure', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (26, 190, N'Government Research Facility', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (26, 191, N'Government Sensor or Monitoring System', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (26, 192, N'Government Space System', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (26, 193, N'Government Storage or Preservation Facility', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (26, 194, N'Military Facility', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (26, 195, N'Other Government Facility', 1, 1, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (26, 196, N'Personnel-Oriented Government Facility', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (26, 197, N'Service-Oriented Government Facility', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (27, 198, N'Direct Patient Healthcare', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (27, 199, N'Fatality/Mortuary Facility', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (27, 200, N'Health Supporting Facility', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (27, 201, N'Healthcare Educational Facility', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (27, 202, N'Other Healthcare and Public Health Entity', 1, 1, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (27, 203, N'Public Health Agency', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (27, 204, N'Regulatory, Oversight, or Industry Organization', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (28, 205, N'Hardware Production', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (28, 206, N'Internet-Based Content, Information, and Communications Services', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (28, 207, N'Other Hardware Production Facility', 1, 1, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (28, 208, N'Other Information Technology Facility', 1, 1, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (28, 209, N'Regulatory, Oversight, or Industry Organization', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (28, 210, N'Software Production', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (29, 211, N'Beverage Manufacturing', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (29, 212, N'Chemical Manufacturing', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (29, 213, N'Computer and Electronic Product Manufacturing', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (29, 214, N'Critical Manufacturing', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (29, 215, N'Fabricated Metal Product Manufacturing', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (29, 216, N'Food Manufacturing', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (29, 217, N'Furniture And Related Product Manufacturing', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (29, 218, N'Mining, Quarrying, or Oil and Gas Extraction', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (29, 219, N'Non-Metallic Mineral Products Manufacturing', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (29, 220, N'Other Manufacturing', 1, 1, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (29, 221, N'Paper Manufacturing', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (29, 222, N'Petroleum and Coal Products Manufacturing', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (29, 223, N'Plastics And Rubber Products Manufacturing', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (29, 224, N'Printing and Related Support', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (29, 225, N'Textile, Textile Product, Apparel, Leather Manufacturing', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (29, 226, N'Tobacco Product Manufacturing', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (29, 227, N'Wood Product Manufacturing', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (30, 228, N'National Monument/Icon Document or Object', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (30, 229, N'National Monument/Icon Geographic Area', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (30, 230, N'National Monument/Icon Structure', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (30, 231, N'Other National Monuments and Icons', 1, 1, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (31, 232, N'Nuclear Facility', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (31, 233, N'Nuclear Material', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (31, 234, N'Nuclear Waste', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (31, 235, N'Other Nuclear Facility', 1, 1, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (31, 236, N'Regulatory, Oversight, or Industry Organization', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (32, 237, N'Courier', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (32, 238, N'Other Postal and Shipping Facility', 1, 1, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (32, 239, N'United States Postal Service', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (33, 240, N'Aviation', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (33, 241, N'Maritime', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (33, 242, N'Mass Transit', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (33, 243, N'Pipeline', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (33, 244, N'Railroad', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (33, 245, N'Regulatory, Oversight, or Industry Organization', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (33, 246, N'Road', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (34, 247, N'Raw Water Storage', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (34, 248, N'Raw Water Supply', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (34, 249, N'Raw Water Transmission', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (34, 250, N'Regulatory, Oversight, or Industry Organization', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (34, 251, N'Treated (Finished) Water Storage', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (34, 252, N'Treated Water Distribution Control Center', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (34, 253, N'Treated Water Distribution System', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (34, 254, N'Treated Water Monitoring System', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (34, 255, N'Wastewater Facility', 1, 0, NULL)
INSERT INTO [dbo].[SECTOR_INDUSTRY] ([SectorId], [IndustryId], [IndustryName], [Is_NIPP], [Is_Other], [NIPP_subsector]) VALUES (34, 256, N'Water Treatment Facility', 1, 0, NULL)
PRINT(N'Operation applied to 136 rows out of 136')

PRINT(N'Add row to [dbo].[MATURITY_REFERENCE_TEXT]')
INSERT INTO [dbo].[MATURITY_REFERENCE_TEXT] ([Mat_Question_Id], [Sequence], [Reference_Text]) VALUES (1371, 1, N'The roles and responsibilities for each interface or type of interface should be documented for all
parties. Understanding the roles and responsibilities for incident management tasks facilitates timely
coordination, communication, decision-making, and problem resolution.')

PRINT(N'Add rows to [dbo].[MATURITY_REFERENCES]')
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6801, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6802, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6803, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6804, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6805, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6806, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6807, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6808, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6809, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6810, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6811, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6812, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6813, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6814, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6815, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6816, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6817, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6818, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6819, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6820, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6821, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6822, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6823, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6824, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6825, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6826, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6827, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6828, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6829, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6830, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6831, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6832, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6833, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6834, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6835, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6836, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6837, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6838, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6839, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6840, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6841, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6842, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6843, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6844, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6845, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6846, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6847, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6848, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6849, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6850, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6851, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6852, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6853, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6854, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6855, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6856, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6857, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6858, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6859, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6860, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6861, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6862, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6863, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6864, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6865, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6866, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6867, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6868, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6869, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6870, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6871, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6872, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6873, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6874, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6875, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6876, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6877, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6878, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6879, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6880, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6881, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6882, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6883, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6884, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6885, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6886, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6887, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6888, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6889, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6890, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6891, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6892, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6893, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6894, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6895, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6896, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6897, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6898, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6899, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6900, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6901, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6902, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6903, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6904, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6905, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6906, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6907, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6908, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6909, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6910, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6911, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6912, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6913, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6914, 5072, N'', NULL, NULL)
INSERT INTO [dbo].[MATURITY_REFERENCES] ([Mat_Question_Id], [Gen_File_Id], [Section_Ref], [Page_Number], [Destination_String]) VALUES (6915, 5072, N'', NULL, NULL)
PRINT(N'Operation applied to 115 rows out of 115')

PRINT(N'Add constraints to [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_REFERENCES] CHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[MATURITY_REFERENCE_TEXT]')
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]

PRINT(N'Add constraints to [dbo].[SECTOR_INDUSTRY]')
ALTER TABLE [dbo].[SECTOR_INDUSTRY] WITH CHECK CHECK CONSTRAINT [FK_SECTOR_INDUSTRY_SECTOR]
ALTER TABLE [dbo].[DEMOGRAPHICS] WITH CHECK CHECK CONSTRAINT [FK_DEMOGRAPHICS_SECTOR_INDUSTRY]

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
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[TTP_MAT_QUESTION] WITH CHECK CHECK CONSTRAINT [FK_TTP_MAT_QUESTION_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[DEMOGRAPHICS] WITH CHECK CHECK CONSTRAINT [FK_DEMOGRAPHICS_SECTOR]
ALTER TABLE [dbo].[SECTOR_STANDARD_RECOMMENDATIONS] WITH CHECK CHECK CONSTRAINT [FK_SECTOR_STANDARD_RECOMMENDATIONS_SECTOR]

PRINT(N'Add constraints to [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_GROUPINGS_MATURITY_GROUPING_TYPES]
ALTER TABLE [dbo].[MATURITY_DOMAIN_REMARKS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_DOMAIN_REMARKS_MATURITY_GROUPINGS]

PRINT(N'Add constraints to [dbo].[GEN_FILE]')
ALTER TABLE [dbo].[GEN_FILE] WITH CHECK CHECK CONSTRAINT [FK_GEN_FILE_FILE_REF_KEYS]
ALTER TABLE [dbo].[GEN_FILE] WITH CHECK CHECK CONSTRAINT [FK_GEN_FILE_FILE_TYPE]
ALTER TABLE [dbo].[FILE_KEYWORDS] CHECK CONSTRAINT [FILE_KEYWORDS_GEN_FILE_FK]
ALTER TABLE [dbo].[GEN_FILE_LIB_PATH_CORL] CHECK CONSTRAINT [FK_GEN_FILE_LIB_PATH_CORL_GEN_FILE]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_REFERENCES] CHECK CONSTRAINT [FK_REQUIREMENT_REFERENCES_GEN_FILE]
ALTER TABLE [dbo].[REQUIREMENT_SOURCE_FILES] CHECK CONSTRAINT [FK_REQUIREMENT_SOURCE_FILES_GEN_FILE]
ALTER TABLE [dbo].[SET_FILES] WITH CHECK CHECK CONSTRAINT [FK_SET_FILES_GEN_FILE]

PRINT(N'Add constraints to [dbo].[ANALYTICS_MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[ANALYTICS_MATURITY_GROUPINGS] WITH CHECK CHECK CONSTRAINT [FK_ANALYTICS_MATURITY_GROUPINGS_MATURITY_MODELS]

PRINT(N'Add DML triggers to [dbo].[MATURITY_GROUPINGS]')
ALTER TABLE [dbo].[MATURITY_GROUPINGS] ENABLE TRIGGER [trg_update_maturity_groupings]
COMMIT TRANSACTION
GO
