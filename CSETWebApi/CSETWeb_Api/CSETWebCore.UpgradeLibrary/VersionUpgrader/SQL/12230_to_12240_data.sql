/*
Run this script on:

(localdb)\INLLocalDB2022.CSETWeb12230    -  This database will be modified

to synchronize it with:

(localdb)\INLLocalDB2022.CSETWeb12240

You are recommended to back up your database before running this script

Script created by SQL Data Compare version 14.10.9.22680 from Red Gate Software Ltd at 6/26/2024 2:07:42 PM

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

PRINT(N'Drop constraint FK__HYDRO_DAT__Mat_Q__38652BE2 from [dbo].[HYDRO_DATA]')
ALTER TABLE [dbo].[HYDRO_DATA] NOCHECK CONSTRAINT [FK__HYDRO_DAT__Mat_Q__38652BE2]

PRINT(N'Drop constraint FK_MATURITY_QUESTIONS_MAT_QUESTION_ID from [dbo].[ISE_ACTIONS]')
ALTER TABLE [dbo].[ISE_ACTIONS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MAT_QUESTION_ID]

PRINT(N'Drop constraint FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1 from [dbo].[MATURITY_ANSWER_OPTIONS]')
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] NOCHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1]

PRINT(N'Drop constraint FK_MATURITY_QUESTION_PROPS_MATURITY_QUESTIONS from [dbo].[MATURITY_QUESTION_PROPS]')
ALTER TABLE [dbo].[MATURITY_QUESTION_PROPS] NOCHECK CONSTRAINT [FK_MATURITY_QUESTION_PROPS_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS from [dbo].[MATURITY_REFERENCE_TEXT]')
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_REFERENCES_MATURITY_QUESTIONS from [dbo].[MATURITY_REFERENCES]')
ALTER TABLE [dbo].[MATURITY_REFERENCES] NOCHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS from [dbo].[MATURITY_SOURCE_FILES]')
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] NOCHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_MATURITY_SUB_MODEL_QUESTIONS_MATURITY_QUESTIONS from [dbo].[MATURITY_SUB_MODEL_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_SUB_MODEL_QUESTIONS] NOCHECK CONSTRAINT [FK_MATURITY_SUB_MODEL_QUESTIONS_MATURITY_QUESTIONS]

PRINT(N'Drop constraint FK_mq_bonus_mat_q from [dbo].[MQ_BONUS]')
ALTER TABLE [dbo].[MQ_BONUS] NOCHECK CONSTRAINT [FK_mq_bonus_mat_q]

PRINT(N'Drop constraint FK_mq_bonus_mat_q1 from [dbo].[MQ_BONUS]')
ALTER TABLE [dbo].[MQ_BONUS] NOCHECK CONSTRAINT [FK_mq_bonus_mat_q1]

PRINT(N'Drop constraint FK_TTP_MAT_QUESTION_MATURITY_QUESTIONS from [dbo].[TTP_MAT_QUESTION]')
ALTER TABLE [dbo].[TTP_MAT_QUESTION] NOCHECK CONSTRAINT [FK_TTP_MAT_QUESTION_MATURITY_QUESTIONS]

PRINT(N'Delete rows from [dbo].[MATURITY_QUESTIONS]')
DELETE FROM [dbo].[MATURITY_QUESTIONS] WHERE [Mat_Question_Id] = 12154
DELETE FROM [dbo].[MATURITY_QUESTIONS] WHERE [Mat_Question_Id] = 12155
DELETE FROM [dbo].[MATURITY_QUESTIONS] WHERE [Mat_Question_Id] = 12156
DELETE FROM [dbo].[MATURITY_QUESTIONS] WHERE [Mat_Question_Id] = 12157
DELETE FROM [dbo].[MATURITY_QUESTIONS] WHERE [Mat_Question_Id] = 12158
DELETE FROM [dbo].[MATURITY_QUESTIONS] WHERE [Mat_Question_Id] = 12159
DELETE FROM [dbo].[MATURITY_QUESTIONS] WHERE [Mat_Question_Id] = 12160
DELETE FROM [dbo].[MATURITY_QUESTIONS] WHERE [Mat_Question_Id] = 12161
DELETE FROM [dbo].[MATURITY_QUESTIONS] WHERE [Mat_Question_Id] = 12162
DELETE FROM [dbo].[MATURITY_QUESTIONS] WHERE [Mat_Question_Id] = 12163
DELETE FROM [dbo].[MATURITY_QUESTIONS] WHERE [Mat_Question_Id] = 12164
PRINT(N'Operation applied to 11 rows out of 11')

PRINT(N'Update rows in [dbo].[MATURITY_QUESTIONS]')
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 1' WHERE [Mat_Question_Id] = 10990
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 1a' WHERE [Mat_Question_Id] = 10991
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 1b' WHERE [Mat_Question_Id] = 10992
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 1c' WHERE [Mat_Question_Id] = 10993
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 1d' WHERE [Mat_Question_Id] = 10994
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 1e' WHERE [Mat_Question_Id] = 10995
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 2' WHERE [Mat_Question_Id] = 10996
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'What are the unacceptable high consequence events that impact mission delivery, safety, security, the environment, equipment and property, financials, or corporate reputation?' WHERE [Mat_Question_Id] = 12085
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'What are the critical processes, operations, and/or administrative actions required to protect against unacceptable high consequence events?' WHERE [Mat_Question_Id] = 12086
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'How are identified high consequence events documented, monitored for change, and reassessed?' WHERE [Mat_Question_Id] = 12087
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Which stakeholders (e.g. operations staff, engineering staff, executive leadership, external parties) would be impacted during or by damage from high consequence events and how are they included in mitigation decisions?' WHERE [Mat_Question_Id] = 12088
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 1', [Question_Text]=N'How are the storage, movement, and use of hazardous quantities of mass or energy (potential and kinetic) controlled by digital technologies? ', [Sequence]=1, [Grouping_Id]=2622 WHERE [Mat_Question_Id] = 12089
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 2', [Question_Text]=N'How are engineered systems (e.g., IT, operational technology [OT], electrical, mechanical pneumatic, mechanical hydraulic, thermal, chemical) that store, move and use hazardous quantities of product or energy dependent on digital technologies to support critical functions?   ', [Sequence]=2, [Grouping_Id]=2622 WHERE [Mat_Question_Id] = 12090
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 3', [Question_Text]=N'What consequences of failure or maloperation are the engineered controls designed to prevent?', [Sequence]=3 WHERE [Mat_Question_Id] = 12091
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 4', [Question_Text]=N'Where engineered controls depend on digital technologies, where might an analog engineered control add to the protection (or lower the impact) of a high consequence event?  ', [Sequence]=4 WHERE [Mat_Question_Id] = 12092
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 5', [Question_Text]=N'How do we monitor and ensure the effectiveness of engineering controls through system changes (e.g. expansion) and operational conditions, including those that may weaken their effectiveness (e.g. through undue stress)? ', [Sequence]=5 WHERE [Mat_Question_Id] = 12093
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 6', [Question_Text]=N'How do we validate the efficacy of engineered controls, especially those that may be affected or circumvented by administrative workarounds?    ', [Sequence]=6 WHERE [Mat_Question_Id] = 12094
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 1', [Question_Text]=N'What are the key data elements, the critical inputs  and outputs, and the mechanisms (people, tools, systems) each process step that the system executes?', [Sequence]=1, [Grouping_Id]=2623 WHERE [Mat_Question_Id] = 12095
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 2', [Question_Text]=N'How independent are the key data elements, physically or digitally, to allow diagnosis of the extent or cause of an anomaly?', [Sequence]=2, [Grouping_Id]=2623 WHERE [Mat_Question_Id] = 12096
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 3', [Question_Text]=N'Which information exchanges with the system would would result in a high consequence event if the data was disrupted or manipulated? ', [Sequence]=3 WHERE [Mat_Question_Id] = 12097
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 4', [Question_Text]=N'What engineering and operations-based protection and verification could ensure that key data elements have not been manipulated?', [Sequence]=4 WHERE [Mat_Question_Id] = 12098
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 5', [Question_Text]=N'How could unanticipated adverse or extraordinary operating modes potentially violate security controls or validation mechanisms placed on the data?', [Sequence]=5 WHERE [Mat_Question_Id] = 12099
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 1', [Question_Text]=N'Where are opportunities to simplify or eliminate device/system elements or features that are not necessary to meet the minimum functional capabilities and defined system requirements?', [Sequence]=1, [Grouping_Id]=2624 WHERE [Mat_Question_Id] = 12100
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 2', [Question_Text]=N'How would a given design simplification introduce tradeoffs (e.g., loss of redundant control, reduced reliability, reduced operator visibility) that conflict with other stakeholder requirements or downstream dependencies?', [Sequence]=2, [Grouping_Id]=2624 WHERE [Mat_Question_Id] = 12101
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 3', [Question_Text]=N'How do each of the design elements traceable to a specific project requirement or critical operation/process?', [Sequence]=3, [Grouping_Id]=2624 WHERE [Mat_Question_Id] = 12102
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 4', [Question_Text]=N'What non-digital alternative to a digital feature could be applied to satisfy a requirement?', [Sequence]=4, [Grouping_Id]=2624 WHERE [Mat_Question_Id] = 12103
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 5', [Question_Text]=N'Which system features used for supporting the operation and maintenance of the system by personnel not necessary (e.g., engineering workstations, remote access for third-party entities, human-machine interfaces [HMIs], operator laptop connections)?  ', [Sequence]=5 WHERE [Mat_Question_Id] = 12104
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 1', [Question_Text]=N'What layers of digital control defenses (e.g., network segmentation, access control, encryption, etc.) are present in the system?', [Sequence]=1, [Grouping_Id]=2625 WHERE [Mat_Question_Id] = 12105
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 2', [Question_Text]=N'What layers of engineered control defenses are present in the system?', [Sequence]=2, [Grouping_Id]=2625 WHERE [Mat_Question_Id] = 12106
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 3', [Question_Text]=N'How are multiple defenses independent of each other such that the failure or compromise of one has no effect on others?', [Sequence]=3, [Grouping_Id]=2625 WHERE [Mat_Question_Id] = 12107
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 4', [Question_Text]=N'How are critical functions sufficiently protected by layered defenses?', [Sequence]=4, [Grouping_Id]=2625 WHERE [Mat_Question_Id] = 12108
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 5', [Question_Text]=N'Where are there single points of failure that could result in undesired exposure of the critical function.', [Sequence]=5 WHERE [Mat_Question_Id] = 12109
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 6', [Question_Text]=N'How can the team assess and adjust layered defenses to maintain the desired level of protection after system upgrades, configuration changes, requirements changes, or changes in critical consequences?', [Sequence]=6 WHERE [Mat_Question_Id] = 12110
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 1', [Question_Text]=N'What are the indicators, including the earliest precursors, that a high consequence event could be caused, intentionally or unintentionally?', [Sequence]=1, [Grouping_Id]=2626 WHERE [Mat_Question_Id] = 12111
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 2', [Question_Text]=N'What temporary operational changes can be made in response to a perceived threat?', [Sequence]=2, [Grouping_Id]=2626 WHERE [Mat_Question_Id] = 12112
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 3', [Question_Text]=N'What countermeasures, compensating controls, or alternative operations strategies support active defense while maintaining critical functions?', [Sequence]=3, [Grouping_Id]=2626 WHERE [Mat_Question_Id] = 12113
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 4', [Question_Text]=N'How are active defense features/tools/procedures tested, validated, and regularly exercised during systems operations and are those results representative of how they would be expected to perform?', [Sequence]=4, [Grouping_Id]=2626 WHERE [Mat_Question_Id] = 12114
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 5', [Question_Text]=N'How are current or new features tested following maintenance, changes, and upgrades?', [Sequence]=5, [Grouping_Id]=2626 WHERE [Mat_Question_Id] = 12115
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 6', [Question_Text]=N'Who has the documented responsibility and accountability to initiate and terminate active defense measures, and how are they and others notified of an active threat or aware of triggers to temporarily change operations?', [Sequence]=6 WHERE [Mat_Question_Id] = 12116
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 1', [Question_Text]=N'What supporting utilities  (e.g., telecommunications, water, power) provide inputs to the system that are essential for system-level critical function delivery?', [Sequence]=1, [Grouping_Id]=2627 WHERE [Mat_Question_Id] = 12117
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 2', [Question_Text]=N'What inputs do the system’s critical functions require that are not directly and completely controlled by the system', [Sequence]=2, [Grouping_Id]=2627 WHERE [Mat_Question_Id] = 12118
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 3', [Question_Text]=N'If access to a critical input is lost, can the input be obtained from alternative sources, and/or how will the system continue to execute its critical functions without it?', [Sequence]=3, [Grouping_Id]=2627 WHERE [Mat_Question_Id] = 12119
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 4', [Question_Text]=N'What outputs does the system provide that are critical inputs to other business systems or infrastructures?', [Sequence]=4, [Grouping_Id]=2627 WHERE [Mat_Question_Id] = 12120
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 5', [Question_Text]=N'If system outputs to dependent system’s critical inputs are lost, can the output be produced from alternate sources?', [Sequence]=5, [Grouping_Id]=2627 WHERE [Mat_Question_Id] = 12121
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 6', [Question_Text]=N'How are changes in interdependent systems communicated and used to inform the need for additional controls, capabilities, or investments?', [Sequence]=6, [Grouping_Id]=2627 WHERE [Mat_Question_Id] = 12122
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'Which digital features in a system have the potential to cause high consequences events from adversarial manipulation or control?', [Grouping_Id]=2628 WHERE [Mat_Question_Id] = 12123
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'How are digital feature abuse/misuse scenarios used to identify high consequences events, inform requirements for what the system must be designed to not do, and drive digital and non-digital (i.e., engineered controls) mechanisms to prevent abuse/misuse?', [Grouping_Id]=2628 WHERE [Mat_Question_Id] = 12124
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'How do abuse/misuse scenarios inform operators’ thinking about systems and affect system requirements?', [Grouping_Id]=2628 WHERE [Mat_Question_Id] = 12125
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'What processes ensure that digital assets are tracked and that third-party vendors provide the specifications needed to enable asset tracking?', [Grouping_Id]=2628 WHERE [Mat_Question_Id] = 12126
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'What processes ensure that operations and maintenance activities (e.g., changes to software, logic, or configurations) appropriately trigger updates to asset tracking records?', [Grouping_Id]=2628 WHERE [Mat_Question_Id] = 12127
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Text]=N'What is the process to ensure that applied packages from updates/patches are necessary, desired, and make all the changes promised (and only the changes promised; no new unexpected features introduced)?', [Grouping_Id]=2628 WHERE [Mat_Question_Id] = 12128
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 7', [Question_Text]=N'Where updates or patching are delayed or not performed, are there alternate defenses that could be implemented to limit impacts of the resulting vulnerability or related exploitations? ', [Sequence]=7 WHERE [Mat_Question_Id] = 12129
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 1', [Question_Text]=N'What assumptions have been made about the availability, quality, and security of the products or services that are critical to system functions or to the mitigation of high consequence events?', [Sequence]=1, [Grouping_Id]=2629 WHERE [Mat_Question_Id] = 12130
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 2', [Question_Text]=N'How can the organization reduce supply chain risk by prioritizing familiar technologies, technologies that are expected to be continuously available, and suppliers with a strong history of meeting supply chain constraints?', [Sequence]=2, [Grouping_Id]=2629 WHERE [Mat_Question_Id] = 12131
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 3', [Question_Text]=N'How are delivery interruptions of critical components avoided by using alternate methods of delivery or by arranging for multiple alternate sources?', [Sequence]=3, [Grouping_Id]=2629 WHERE [Mat_Question_Id] = 12132
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 4', [Question_Text]=N'How does the organization ensure the services and components that are critical to system function are being used in alignment with the vendor''s intended purpose to minimize consequences of disruption, the expected security functions and requirements, and the vendor’s responsibility and accountability in mitigating and preventing disruptions?', [Sequence]=4, [Grouping_Id]=2629 WHERE [Mat_Question_Id] = 12133
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 5', [Question_Text]=N'How will the organization identify and manage the risks of continued use of a component or subcomponent if a vendor support contract expires?', [Sequence]=5, [Grouping_Id]=2629 WHERE [Mat_Question_Id] = 12134
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 1', [Question_Text]=N'What are the limits of acceptable degradation for critical system functions and what alternate operating modes would protect and maintain those critical system functions within acceptable limits?', [Sequence]=1, [Grouping_Id]=2630 WHERE [Mat_Question_Id] = 12135
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 2', [Question_Text]=N'How reliable are the supporting utilities  (e.g., power, communication) and what plans are in place for continued operation if one or more is lost?', [Sequence]=2, [Grouping_Id]=2630 WHERE [Mat_Question_Id] = 12136
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 3', [Question_Text]=N'How does the system maintain safety, security, and/or stable operation in the case of partial or complete functional failures (i.e., fail-secure, similar to fail-safe)?', [Sequence]=3, [Grouping_Id]=2630 WHERE [Mat_Question_Id] = 12137
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 4', [Question_Text]=N'Do processes controlled by an automated system have a manual operation mode that is practiced and has been verified to have no dependencies on automation?', [Sequence]=4, [Grouping_Id]=2630 WHERE [Mat_Question_Id] = 12138
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 5', [Question_Text]=N'How does the organization maintain business continuity and critical function delivery through incident response and recovery?', [Sequence]=5, [Grouping_Id]=2630 WHERE [Mat_Question_Id] = 12139
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 6', [Question_Text]=N'How will resilience measures be validated?', [Sequence]=6, [Grouping_Id]=2630 WHERE [Mat_Question_Id] = 12140
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 7', [Question_Text]=N'How do you practice and continually improve response and recovery processes?', [Sequence]=7, [Grouping_Id]=2630 WHERE [Mat_Question_Id] = 12141
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 1', [Question_Text]=N'What information about the system (e.g., requirements, procurement, engineering diagrams, processes and procedures) is sensitive and how is that information protected?', [Sequence]=1, [Grouping_Id]=2631 WHERE [Mat_Question_Id] = 12142
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 2', [Question_Text]=N'How are internal stakeholders trained and held accountable to ensure potentially sensitive information is correctly identified and protected?', [Sequence]=2, [Grouping_Id]=2631 WHERE [Mat_Question_Id] = 12143
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 3', [Question_Text]=N'How are data sensitivity controls and requirements passed to external stakeholders (e.g., subcontractors, service providers, distributors) and enforced through contracts, procurement, and reporting documents?', [Sequence]=3, [Grouping_Id]=2631 WHERE [Mat_Question_Id] = 12144
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 4', [Question_Text]=N'How are internal stakeholder roles and associated access privileges defined and adjudicated to enable necessary access to sensitive system data? Do information security policies that overly constrain workflows “encourage” workarounds and bypasses? ', [Sequence]=4, [Grouping_Id]=2631 WHERE [Mat_Question_Id] = 12145
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 5', [Question_Text]=N'Could an adversary reasonably derive sensitive system information from hiring, recruitment, marketing or other externally facing information sources?', [Sequence]=5, [Grouping_Id]=2631 WHERE [Mat_Question_Id] = 12146
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 1', [Question_Text]=N'How do expectations around creating, operating, and maintaining the system transfer from the organization to supporting organizations (e.g., hardware vendors, consulting engineers)?', [Sequence]=1, [Grouping_Id]=2632 WHERE [Mat_Question_Id] = 12147
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 2', [Question_Text]=N'How can choices that make the organization less resilient or bring on undue complexity/cost (e.g. delaying hardware and software life-cycle updates) be recognized and documented? ', [Sequence]=2, [Grouping_Id]=2632 WHERE [Mat_Question_Id] = 12148
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 3', [Question_Text]=N'What assumptions are made about existing skill and experience and what training, education, and practice will be needed for those who will operate, maintain, secure, and defend the system?', [Sequence]=3, [Grouping_Id]=2632 WHERE [Mat_Question_Id] = 12149
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 4', [Question_Text]=N'How is interpersonal trust maintained across the entire organization? ', [Sequence]=4, [Grouping_Id]=2632 WHERE [Mat_Question_Id] = 12150
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 5', [Question_Text]=N'What processes ensure that operators consider the possibility of digital sabotage when responding to and diagnosing process anomalies?', [Sequence]=5, [Grouping_Id]=2632 WHERE [Mat_Question_Id] = 12151
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 6', [Question_Text]=N'How can the organization foster a culture of  timely reporting of issues in people, process, and technology without fear of reprisal, and with confidence that the issues will be addressed?', [Sequence]=6, [Grouping_Id]=2632 WHERE [Mat_Question_Id] = 12152
UPDATE [dbo].[MATURITY_QUESTIONS] SET [Question_Title]=N'Question 7', [Question_Text]=N'How can the organization positively reinforce behaviors and choices that support security outcomes, while reducing those that harm security outcomes?', [Sequence]=7, [Grouping_Id]=2632 WHERE [Mat_Question_Id] = 12153
PRINT(N'Operation applied to 76 rows out of 76')

PRINT(N'Add constraints to [dbo].[MATURITY_QUESTIONS]')
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK__MATURITY___Matur__5B638405]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_GROUPINGS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_LEVELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_MODELS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_OPTIONS]
ALTER TABLE [dbo].[MATURITY_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MATURITY_QUESTION_TYPES]
ALTER TABLE [dbo].[HYDRO_DATA] WITH CHECK CHECK CONSTRAINT [FK__HYDRO_DAT__Mat_Q__38652BE2]
ALTER TABLE [dbo].[ISE_ACTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTIONS_MAT_QUESTION_ID]
ALTER TABLE [dbo].[MATURITY_ANSWER_OPTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_ANSWER_OPTIONS_MATURITY_QUESTIONS1]
ALTER TABLE [dbo].[MATURITY_QUESTION_PROPS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_QUESTION_PROPS_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_REFERENCE_TEXT] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_REFERENCE_TEXT_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_REFERENCES] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_REFERENCES_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_SOURCE_FILES] CHECK CONSTRAINT [FK_MATURITY_SOURCE_FILES_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MATURITY_SUB_MODEL_QUESTIONS] WITH CHECK CHECK CONSTRAINT [FK_MATURITY_SUB_MODEL_QUESTIONS_MATURITY_QUESTIONS]
ALTER TABLE [dbo].[MQ_BONUS] WITH CHECK CHECK CONSTRAINT [FK_mq_bonus_mat_q]
ALTER TABLE [dbo].[MQ_BONUS] WITH CHECK CHECK CONSTRAINT [FK_mq_bonus_mat_q1]
ALTER TABLE [dbo].[TTP_MAT_QUESTION] WITH CHECK CHECK CONSTRAINT [FK_TTP_MAT_QUESTION_MATURITY_QUESTIONS]
COMMIT TRANSACTION
GO
