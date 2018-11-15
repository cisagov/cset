USE [CSETWeb]
GO
/****** Object:  Table [dbo].[GLOBAL_PROPERTIES]    Script Date: 11/14/2018 3:57:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GLOBAL_PROPERTIES](
	[Property] [varchar](50) NOT NULL,
	[Property_Value] [varchar](7500) NULL,
 CONSTRAINT [PK_GlobalProperties] PRIMARY KEY CLUSTERED 
(
	[Property] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[GLOBAL_PROPERTIES] ([Property], [Property_Value]) VALUES (N'CompareExecutiveSummary', N'Cyber terrorism is a real and growing threat. Standards and guides have been developed, vetted, and widely accepted to assist with protection from cyber-attacks. The Cyber Security Evaluation Tool (CSET) includes a selectable array of these standards for a tailored assessment of cyber vulnerabilities. The aggregation of multiple assessments produced the analyses presented herein. The variance statistics provide a comparison of the subject assessments while the summary compliance data presents an overall picture treating each assessment as part of a greater whole.')
INSERT [dbo].[GLOBAL_PROPERTIES] ([Property], [Property_Value]) VALUES (N'DiagramAutoSaveTimeInterval', N'300')
INSERT [dbo].[GLOBAL_PROPERTIES] ([Property], [Property_Value]) VALUES (N'EE_ExecutiveSummary', N'Enterprise Evaluation Executive Summary 

This analysis identifies the cybersecurity posture of [FACILITY NAME]. The review evaluated the business systems to identify what is performed well, what can be improved, and suggests options for consideration. 

The approach used in reviewing [FACILITY NAME]''s cyber systems was the Enterprise Evaluation (EE), which includes a series of questions organized in ten categories derived from international, audit community, and federal government standards, and guidelines. The findings are presented based on the responses provided during the review. Notable Good Practices represent those practices of the organization that are areas of excellence. Most Critical Aspects for Improvement represent those issues that the organization should consider remedying immediately to mitigate vulnerabilities and minimize consequences of an egregious security breach. Moderately Critical Aspects for Improvement represent those issues that the organization should consider remedying in the near future in order to mitigate vulnerabilities and minimize consequences of a security breach. Finally, Least Critical Aspects for Improvement represent those issues that the organization should consider to improve security policies or incorporate generally accepted good practices.

This report does not make recommendations as to what should be changed. Instead, the report attempts to identify both notable good practices in place at [FACILITY NAME] as well as gaps between current practices and what is possible with appropriate resources. [FACILITY NAME] should conduct (or reevaluate) a risk assessment to determine if any gaps should be mitigated and to what extent. This assessment should be used to support risk-based decisions on policies, plans, procedures, and business systems operations.

EE is a vulnerability assessment rather than a risk assessment. Cyber vulnerabilities can often be mitigated through physical and human security measures. Given this reality, [FACILITY NAME] should employ a robust risk management program that not only addresses threats, vulnerabilities, and consequences via cyber means, but also physical and human aspects. For example, while issues such as the lockout of accounts are (and remain) vulnerabilities, their effects are reduced by the defense-in-depth approach of the physical and human security measures in place.

Cyber Threat: Malicious actors are increasingly acquiring information technology skills to potentially launch a cyber attack on the U.S. infrastructure. Cyber intruder groups already possess the necessary skills to launch a successful cyber attack and may be “talent-for-hire” available to terrorists, criminal organizations, and nation states. Attackers do not need to be technically savvy because free and commercial automated tools are simplifying attack methods. 

Consequence of Attack On or Exploitation of Systems and Networks: If the business systems at this organization were compromised, the result could include the loss of sensitive data (e.g., intellectual capital, personal and health information) and the disruption of business operations. In addition, a compromise could provide a platform from which the process control network is attacked. Or, these networks could be exploited by malicious actors to attack other computers, facilities, and critical infrastructure through botnets.

Cybersecurity Posture (Vulnerability): A successful attack on the business systems is feasible through the Internet or other external connections (e.g., modems, wireless, portable devices, and media).

Company- or facility-specific information is often available on the Internet, and tools are readily available that automate search techniques for connections (e.g., Internet, wireless, and modems). Moreover, mature cyber attack tools (also available on the Internet) make common vulnerabilities easy to exploit by moderately skilled malicious actors unless perimeter security devices are properly configured and kept up to date (e.g., unless the option is turned off, firewalls will respond to reconnaissance attempts with information that enables cyber attack). An estimated ten new cyber vulnerabilities are discovered every day.

A common approach to cybersecurity is to secure the perimeter, leaving the internal network as a trusted environment. The actions of insiders (intentional or unintentional) then become an issue of concern. Unfortunately, unintentional consequences, introduced to systems through good intentions of trusted insiders, are known to have caused disruptions of operational business systems. In addition, system and network vulnerabilities are becoming more widely known and trends show that untargeted attacks, such as viruses, worms, and Trojans, are more prevalent. By opening e-mail attachments or visiting compromised web-sites, unsuspecting users can introduce malicious code to otherwise well-managed systems and networks. 

Resources are available to assist in understanding and resolving consequential cyber attacks and incidents. Among them is the United States Computer Emergency Readiness Team (US-CERT), which, in partnership with the Multi-State Information Sharing and Analysis Center (MS-ISAC), published an information paper titled “Current Malware Threats and Mitigation Strategies,” May 16, 2005. The following is an excerpt that summarizes the concern: “The nature of malicious code, or malware, (e.g., viruses, worms, bots) shifted recently… to actively seeking financial gain… [and] unfortunately, attackers have become very adept at circumventing traditional defenses such as anti-virus software and firewalls… Botnets are often the focal point for collecting the confidential information, launching Denial of Service attacks, and distributing SPAM. A bot, short for robot, is an automated software program that can execute certain commands. A botnet, short for robot network, is an aggregation of computers compromised by bots that are connected to a central ‘controller.’ … Botnets controlling tens of thousands of compromised hosts are common…” (Source: http://www.us-cert.gov/reading_room/malware-threats-mitigation.pdf; additional information can be found at the US-CERT home: http://www.uscert.gov/).

Cybersecurity practices that are performed well by [FACILITY NAME] include: [Please insert the 3 or 4 sections that are of least concern here based on results from the Detailed Findings section of the report].
 
Several areas of concern make possible a successful cyber attack by malicious actors or a serious cyber incident. These include: [Please insert the 3 or 4 sections that are of greatest concern here based on results from the Detailed Findings section of the report].

[FACILITY NAME]''s most critical gaps are: [Please insert the Most Critical Aspects for Improvement here based on results from the Summary of Gaps and Options for Consideration section at the end of the report].

Company Comments
[Insert the most relevant high-level comments provided throughout the assessment here.]')
INSERT [dbo].[GLOBAL_PROPERTIES] ([Property], [Property_Value]) VALUES (N'InternalPDF', N'False')
INSERT [dbo].[GLOBAL_PROPERTIES] ([Property], [Property_Value]) VALUES (N'MainExecutiveSummary', N'Cyber terrorism is a real and growing threat. Standards and guides have been developed, vetted, and widely accepted to assist with protection from cyber attacks. The Cyber Security Evaluation Tool (CSET) includes a selectable array of these standards for a tailored assessment of cyber vulnerabilities. Once the standards were selected and the resulting question sets answered, the CSET created a compliance summary, compiled variance statistics, ranked top areas of concern, and generated security recommendations. ')
INSERT [dbo].[GLOBAL_PROPERTIES] ([Property], [Property_Value]) VALUES (N'TrendExecutiveSummary', N'Cyber terrorism is a real and growing threat. Standards and guides have been developed, vetted, and widely accepted to assist with protection from cyber-attacks. The Cyber Security Evaluation Tool (CSET) includes a selectable array of these standards for a tailored assessment of cyber vulnerabilities. The analysis performed and shows the change in cyber security overall and for specific areas. Cyber security posture changes over time. The trend report shows these changes overtime starting with an established baseline and comparing following assessments.  CSET presents a summary of these changes with emphasis on the most improved and least improved areas. ')
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Property is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GLOBAL_PROPERTIES', @level2type=N'COLUMN',@level2name=N'Property'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Property Value is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GLOBAL_PROPERTIES', @level2type=N'COLUMN',@level2name=N'Property_Value'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GLOBAL_PROPERTIES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Global Properties' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GLOBAL_PROPERTIES'
GO
