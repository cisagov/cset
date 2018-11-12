USE [CSETWeb]
GO
/****** Object:  Table [dbo].[DIAGRAM_TEMPLATES]    Script Date: 6/28/2018 8:21:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIAGRAM_TEMPLATES](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Template_Name] [nvarchar](150) NULL,
	[File_Name] [nvarchar](max) NULL,
	[Is_Read_Only] [bit] NOT NULL,
	[Is_Visible] [bit] NOT NULL,
 CONSTRAINT [PK_DIAGRAM_TEMPATES] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[DIAGRAM_TEMPLATES] ON 

INSERT [dbo].[DIAGRAM_TEMPLATES] ([Id], [Template_Name], [File_Name], [Is_Read_Only], [Is_Visible]) VALUES (1, N'DCS', N'DiagramTemplates\DCSTemplate.csetd', 1, 1)
INSERT [dbo].[DIAGRAM_TEMPLATES] ([Id], [Template_Name], [File_Name], [Is_Read_Only], [Is_Visible]) VALUES (2, N'PCS', N'DiagramTemplates\PCSTemplate.csetd', 1, 1)
INSERT [dbo].[DIAGRAM_TEMPLATES] ([Id], [Template_Name], [File_Name], [Is_Read_Only], [Is_Visible]) VALUES (3, N'SCADA', N'DiagramTemplates\SCADATemplate.csetd', 1, 1)
INSERT [dbo].[DIAGRAM_TEMPLATES] ([Id], [Template_Name], [File_Name], [Is_Read_Only], [Is_Visible]) VALUES (4, N'Electric ', N'DiagramTemplates\ElectricUtilityTemplate.csetd', 1, 1)
INSERT [dbo].[DIAGRAM_TEMPLATES] ([Id], [Template_Name], [File_Name], [Is_Read_Only], [Is_Visible]) VALUES (5, N'Hydro', N'DiagramTemplates\HydroelectricSystemTemplate.csetd', 1, 1)
INSERT [dbo].[DIAGRAM_TEMPLATES] ([Id], [Template_Name], [File_Name], [Is_Read_Only], [Is_Visible]) VALUES (6, N'Nuclear', N'DiagramTemplates\NuclearPlantTemplate.csetd', 1, 1)
INSERT [dbo].[DIAGRAM_TEMPLATES] ([Id], [Template_Name], [File_Name], [Is_Read_Only], [Is_Visible]) VALUES (7, N'Oil & Gas 1', N'DiagramTemplates\Oil&GasSystem1Template.csetd', 1, 1)
INSERT [dbo].[DIAGRAM_TEMPLATES] ([Id], [Template_Name], [File_Name], [Is_Read_Only], [Is_Visible]) VALUES (8, N'Oil & Gas 2', N'DiagramTemplates\Oil&GasSystem2Template.csetd', 1, 1)
INSERT [dbo].[DIAGRAM_TEMPLATES] ([Id], [Template_Name], [File_Name], [Is_Read_Only], [Is_Visible]) VALUES (9, N'Traffic Control', N'DiagramTemplates\TrafficControlSystemTemplate.csetd', 1, 1)
INSERT [dbo].[DIAGRAM_TEMPLATES] ([Id], [Template_Name], [File_Name], [Is_Read_Only], [Is_Visible]) VALUES (10, N'Waste Water Treatment Plant', N'DiagramTemplates\WastewaterTreatmentPlantSystemTemplate.csetd', 1, 1)
INSERT [dbo].[DIAGRAM_TEMPLATES] ([Id], [Template_Name], [File_Name], [Is_Read_Only], [Is_Visible]) VALUES (11, N'Water Plant System', N'DiagramTemplates\WaterPlantSystemTemplate.csetd', 1, 1)
INSERT [dbo].[DIAGRAM_TEMPLATES] ([Id], [Template_Name], [File_Name], [Is_Read_Only], [Is_Visible]) VALUES (12, N'HVAC', N'DiagramTemplates\HeatingVentilationACSystemTemplate.csetd', 1, 1)
INSERT [dbo].[DIAGRAM_TEMPLATES] ([Id], [Template_Name], [File_Name], [Is_Read_Only], [Is_Visible]) VALUES (13, N'Building Access Control', N'DiagramTemplates\BuildingAndAccessControlSystemsTemplate.csetd', 1, 1)
INSERT [dbo].[DIAGRAM_TEMPLATES] ([Id], [Template_Name], [File_Name], [Is_Read_Only], [Is_Visible]) VALUES (15, N'Medical', N'DiagramTemplates\MedicalTemplate.csetd', 1, 1)
INSERT [dbo].[DIAGRAM_TEMPLATES] ([Id], [Template_Name], [File_Name], [Is_Read_Only], [Is_Visible]) VALUES (16, N'Radio', N'DiagramTemplates\RadioTemplate.csetd', 1, 1)
SET IDENTITY_INSERT [dbo].[DIAGRAM_TEMPLATES] OFF
ALTER TABLE [dbo].[DIAGRAM_TEMPLATES] ADD  CONSTRAINT [DF_DIAGRAM_TEMPLATES_Is_Read_Only]  DEFAULT ((1)) FOR [Is_Read_Only]
GO
ALTER TABLE [dbo].[DIAGRAM_TEMPLATES] ADD  CONSTRAINT [DF_DIAGRAM_TEMPLATES_Is_Visible]  DEFAULT ((1)) FOR [Is_Visible]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DIAGRAM_TEMPLATES', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Template Name is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DIAGRAM_TEMPLATES', @level2type=N'COLUMN',@level2name=N'Template_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The File Name is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DIAGRAM_TEMPLATES', @level2type=N'COLUMN',@level2name=N'File_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Is Read Only is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DIAGRAM_TEMPLATES', @level2type=N'COLUMN',@level2name=N'Is_Read_Only'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Is Visible is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DIAGRAM_TEMPLATES', @level2type=N'COLUMN',@level2name=N'Is_Visible'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DIAGRAM_TEMPLATES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DIAGRAM_TEMPLATES'
GO
