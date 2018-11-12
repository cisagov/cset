USE [CSETWeb]
GO
/****** Object:  Table [dbo].[DIAGRAM_TYPES]    Script Date: 6/28/2018 8:21:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIAGRAM_TYPES](
	[Specific_Type] [varchar](100) NOT NULL,
	[Diagram_Type_XML] [varchar](50) NULL,
	[Object_Type] [varchar](100) NULL,
 CONSTRAINT [PK_DIAGRAM_TYPES] PRIMARY KEY CLUSTERED 
(
	[Specific_Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Active Directory', N'Active Directory', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Application Server', N'Application Server', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Audio Switch', N'Audio Switch', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Building Automation Management Systems', N'Building Automation Management Systems', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Clock', N'Clock', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Configuration Server', N'Configuration Server', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Connector', N'Connector', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Cross', N'Plus', N'Shape')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'CT Scanner', N'CT Scanner', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Database Server', N'Database Server', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'DCS', N'DCS', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Dispatch Console', N'Dispatch Console', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'DNS Server', N'DNS Server', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Door Access Door Control Unit', N'Door Access Door Control Unit', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'ECG', N'ECG', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'EEG', N'EEG', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Electronic Security System', N'Electronic Security System', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Ellipse', N'Ellipse', N'Shape')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Emergency Medical Service Communications Hardware', N'Emergency Medical Service Communications Hardware', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'EMG', N'EMG', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Endoscopy System', N'Endoscopy System', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Engineering Workstation', N'Engineering Workstation', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Ethernet Backhaul', N'Ethernet Backhaul', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Firewall', N'Firewall', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Front End Processor', N'Front End Processor', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Handheld Wireless Device', N'Handheld Wireless Device', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Hexagon', N'Hexagon', N'Shape')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Historian', N'Historian', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'HMI', N'HMI', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Hub', N'Hub', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'IDS', N'IDS', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'IED', N'IED', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Imaging Modalities and Equipment', N'Imaging Modalities and Equipment', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Imaging Server', N'Imaging Server', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Infant Protection Remote Display Unit', N'Infant Protection Remote Display Unit', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Infusion Pump', N'Infusion Pump', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Interactive Television System', N'Interactive Television System', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'IP Camera', N'IP Camera', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'IP Phone', N'IP Phone', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'IPS', N'IPS', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Linear Partical Accelerator', N'Linear Partical Accelerator', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Link Encryption', N'Link Encryption', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Magnetic Resonance Imaging', N'Magnetic Resonance Imaging', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Mail Server', N'Mail Server', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Master Site', N'Master Site', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Medical Gas System', N'Medical Gas System', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Microwave Backhaul', N'Microwave Backhaul', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Modem', N'Modem', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'MTU', N'MTU', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Multi Protocol Label Switching', N'Multi Protocol Label Switching', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Multiple Services Component', N'Multiple Services Component', N'MultiServicesComponent')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Network Printer', N'Network Printer', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Network Scanner And Copier', N'Network Scanner And Copier', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Octagon', N'Octagon', N'Shape')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Optical Ring System', N'Optical Ring System', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Partner', N'Partner', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'PC', N'PC', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Pentagon', N'Pentagon', N'Shape')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Physiological Monitoring System', N'Physiological Monitoring System', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'PLC', N'PLC', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Power Over Ethernet', N'Power Over Ethernet', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Public Kiosk', N'Public Kiosk', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Radio Site', N'Radio Site', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Real Time Location System', N'Real Time Location System', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Rectangle', N'Rectangle', N'Shape')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Relay Panel', N'Relay Panel', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Remote Access Server', N'Remote Access Server', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'RFID Transmitter', N'RFID Transmitter', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Right Triangle', N'RightTriangle', N'Shape')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Rounded Rectangle', N'RoundedRectangle', N'Shape')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Router', N'Router', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'RTU', N'RTU', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Safety Instrumented System', N'Safety Instrumented System', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Security Information And Event Management System', N'Security Information And Event Management System', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Serial Radio', N'Serial Radio', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Serial Switch', N'Serial Switch', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Server', N'SERVER', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Star', N'Star', N'Shape')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Subscriber Radio', N'Subscriber Radio', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Switch', N'Switch', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'T1 Backhaul', N'T1 Backhaul', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'TDM Backhaul', N'TDM Backhaul', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Terminal Server', N'Terminal Server', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Text', NULL, N'Text')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Triangle', N'Triangle', N'Shape')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Ultrasound', N'Ultrasound', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Unidirectional Device', N'Unidirectional Device', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Uninterruptible Power Supply', N'Uninterruptible Power Supply', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Unknown', N'Unknown', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Urodynamic Diagnostic Equipment', N'Urodynamic Diagnostic Equipment', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Vendor', N'Vendor', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Video Teleconferencing Equipment', N'Video Teleconferencing Equipment', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Virtual Machine Server', N'Virtual Machine Server', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'VLAN Router', N'VLAN Router', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'VLAN Switch', N'VLAN Switch', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'VPN', N'VPN', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Web', N'Web', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Web Server', N'Web Server', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Windows Update Server', N'Windows Update Server', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Wireless Modem', N'Wireless Modem', N'Component')
GO
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Wireless Network', N'Wireless Network', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Wireless Router', N'Wireless Router', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'XRay Generator', N'XRay Generator', N'Component')
INSERT [dbo].[DIAGRAM_TYPES] ([Specific_Type], [Diagram_Type_XML], [Object_Type]) VALUES (N'Zone', NULL, N'Zone')
ALTER TABLE [dbo].[DIAGRAM_TYPES]  WITH CHECK ADD  CONSTRAINT [FK_DIAGRAM_TYPES_CSET_DIAGRAM_TYPES] FOREIGN KEY([Diagram_Type_XML])
REFERENCES [dbo].[DIAGRAM_TYPES_XML] ([Diagram_Type_XML])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[DIAGRAM_TYPES] CHECK CONSTRAINT [FK_DIAGRAM_TYPES_CSET_DIAGRAM_TYPES]
GO
ALTER TABLE [dbo].[DIAGRAM_TYPES]  WITH CHECK ADD  CONSTRAINT [FK_DIAGRAM_TYPES_DIAGRAM_OBJECT_TYPES] FOREIGN KEY([Object_Type])
REFERENCES [dbo].[DIAGRAM_OBJECT_TYPES] ([Object_Type])
GO
ALTER TABLE [dbo].[DIAGRAM_TYPES] CHECK CONSTRAINT [FK_DIAGRAM_TYPES_DIAGRAM_OBJECT_TYPES]
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DIAGRAM_TYPES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DIAGRAM_TYPES'
GO
