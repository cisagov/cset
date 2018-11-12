USE [CSETWeb]
GO
/****** Object:  Table [dbo].[CNSS_CIA_JUSTIFICATIONS]    Script Date: 6/28/2018 8:21:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CNSS_CIA_JUSTIFICATIONS](
	[Assessment_Id] [int] NOT NULL,
	[CIA_Type] [varchar](50) NOT NULL,
	[DropDownValueLevel] [varchar](50) NOT NULL,
	[Justification] [varchar](1500) NOT NULL,
 CONSTRAINT [PK_CNSS_CIA_JUSTIFICATIONS] PRIMARY KEY CLUSTERED 
(
	[Assessment_Id] ASC,
	[CIA_Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[CNSS_CIA_JUSTIFICATIONS] ([Assessment_Id], [CIA_Type], [DropDownValueLevel], [Justification]) VALUES (26, N'Availability', N'Low', N'asdfasdfas   Special Factors Affecting Availability Impact Determination: Some water and sea transportation functions are time-critical (e.g., distress signals, docking operations, collision avoidance, warnings of hazardous weather or sea conditions). Loss of availability of time-critical information necessary to these functions can result in large-scale property loss and in loss of human lives. Such information would have a high integrity impact level.')
INSERT [dbo].[CNSS_CIA_JUSTIFICATIONS] ([Assessment_Id], [CIA_Type], [DropDownValueLevel], [Justification]) VALUES (26, N'Confidentiality', N'Moderate', N'THis is edited Special Factors Affecting Confidentiality Impact Determination: Unauthorized disclosure of information (e.g., investigations, maintenance) that has not been adequately researched, coordinated, or edited can result in serious economic harm to individuals and to corporations. Loss in public confidence is a further potential consequence. Additionally, some information associated with air transportation functions is proprietary to corporations or subject to privacy laws. In such cases, the confidentiality impact resulting from unauthorized disclosure can be moderate. The sensitivity of air transportation information (e.g., aircraft positioning data)can be time or event-driven. For example, passenger lists are not releasable to the general public before a flight takes off, but are placed in the public domain in the event of a crash. In such cases, the confidentiality impact resulting from unauthorized disclosure can be moderate.')
INSERT [dbo].[CNSS_CIA_JUSTIFICATIONS] ([Assessment_Id], [CIA_Type], [DropDownValueLevel], [Justification]) VALUES (26, N'Integrity', N'Low', N'Special Factors Affecting Integrity Impact Determination: The loss of integrity for some system and network monitoring information can be very serious for agency network and security operations, as well as, the functionality of the information system. Additionally, a loss of integrity can have severe consequences for the agency’s mission and critical business functions. The integrity impact level recommended for system and network monitoring information associated with highly critical information is high.')
INSERT [dbo].[CNSS_CIA_JUSTIFICATIONS] ([Assessment_Id], [CIA_Type], [DropDownValueLevel], [Justification]) VALUES (33, N'Availability', N'Moderate', N'Yes,')
INSERT [dbo].[CNSS_CIA_JUSTIFICATIONS] ([Assessment_Id], [CIA_Type], [DropDownValueLevel], [Justification]) VALUES (33, N'Confidentiality', N'Moderate', N'Yes,')
INSERT [dbo].[CNSS_CIA_JUSTIFICATIONS] ([Assessment_Id], [CIA_Type], [DropDownValueLevel], [Justification]) VALUES (33, N'Integrity', N'Low', N'Yes,')
ALTER TABLE [dbo].[CNSS_CIA_JUSTIFICATIONS]  WITH CHECK ADD  CONSTRAINT [FK_CNSS_CIA_JUSTIFICATIONS_ASSESSMENTS] FOREIGN KEY([Assessment_Id])
REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CNSS_CIA_JUSTIFICATIONS] CHECK CONSTRAINT [FK_CNSS_CIA_JUSTIFICATIONS_ASSESSMENTS]
GO
ALTER TABLE [dbo].[CNSS_CIA_JUSTIFICATIONS]  WITH CHECK ADD  CONSTRAINT [FK_CNSS_CIA_JUSTIFICATIONS_CNSS_CIA_TYPES] FOREIGN KEY([CIA_Type])
REFERENCES [dbo].[CNSS_CIA_TYPES] ([CIA_Type])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CNSS_CIA_JUSTIFICATIONS] CHECK CONSTRAINT [FK_CNSS_CIA_JUSTIFICATIONS_CNSS_CIA_TYPES]
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CNSS_CIA_JUSTIFICATIONS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CNSS_CIA_JUSTIFICATIONS'
GO
