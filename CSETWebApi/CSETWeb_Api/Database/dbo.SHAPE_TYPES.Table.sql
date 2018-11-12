USE [CSETWeb]
GO
/****** Object:  Table [dbo].[SHAPE_TYPES]    Script Date: 6/28/2018 8:21:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SHAPE_TYPES](
	[Diagram_Type_XML] [varchar](50) NOT NULL,
	[Telerik_Shape_Type] [varchar](50) NOT NULL,
	[Visio_Shape_Type] [varchar](50) NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[DisplayName] [varchar](50) NULL,
 CONSTRAINT [PK_Shape_Types] PRIMARY KEY CLUSTERED 
(
	[Diagram_Type_XML] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[SHAPE_TYPES] ([Diagram_Type_XML], [Telerik_Shape_Type], [Visio_Shape_Type], [IsDefault], [DisplayName]) VALUES (N'Ellipse', N'EllipseShape', N'Ellipse', 0, N'Ellipse')
INSERT [dbo].[SHAPE_TYPES] ([Diagram_Type_XML], [Telerik_Shape_Type], [Visio_Shape_Type], [IsDefault], [DisplayName]) VALUES (N'Hexagon', N'HexagonShape', N'Hexagon', 0, N'Hexagon')
INSERT [dbo].[SHAPE_TYPES] ([Diagram_Type_XML], [Telerik_Shape_Type], [Visio_Shape_Type], [IsDefault], [DisplayName]) VALUES (N'Octagon', N'OctagonShape', N'Octagon', 0, N'Octagon')
INSERT [dbo].[SHAPE_TYPES] ([Diagram_Type_XML], [Telerik_Shape_Type], [Visio_Shape_Type], [IsDefault], [DisplayName]) VALUES (N'Pentagon', N'PentagonShape', N'Pentagon', 0, N'Pentagon')
INSERT [dbo].[SHAPE_TYPES] ([Diagram_Type_XML], [Telerik_Shape_Type], [Visio_Shape_Type], [IsDefault], [DisplayName]) VALUES (N'Plus', N'Cross2Shape', N'Cross', 0, N'Cross')
INSERT [dbo].[SHAPE_TYPES] ([Diagram_Type_XML], [Telerik_Shape_Type], [Visio_Shape_Type], [IsDefault], [DisplayName]) VALUES (N'Rectangle', N'RectangleShape', N'Rectangle', 1, N'Rectangle')
INSERT [dbo].[SHAPE_TYPES] ([Diagram_Type_XML], [Telerik_Shape_Type], [Visio_Shape_Type], [IsDefault], [DisplayName]) VALUES (N'RightTriangle', N'RightTriangleShape', N'Right Triangle', 0, N'Right Triangle')
INSERT [dbo].[SHAPE_TYPES] ([Diagram_Type_XML], [Telerik_Shape_Type], [Visio_Shape_Type], [IsDefault], [DisplayName]) VALUES (N'RoundedRectangle', N'RoundedRectangleShape', N'Rounded Rectangle', 0, N'Rounded Rectangle')
INSERT [dbo].[SHAPE_TYPES] ([Diagram_Type_XML], [Telerik_Shape_Type], [Visio_Shape_Type], [IsDefault], [DisplayName]) VALUES (N'Star', N'Star5Shape', N'5-Point Star', 0, N'Star')
INSERT [dbo].[SHAPE_TYPES] ([Diagram_Type_XML], [Telerik_Shape_Type], [Visio_Shape_Type], [IsDefault], [DisplayName]) VALUES (N'Triangle', N'TriangleShape', N'Triangle', 0, N'Triangle')
ALTER TABLE [dbo].[SHAPE_TYPES]  WITH NOCHECK ADD  CONSTRAINT [FK_Shape_Types_CSET_DIAGRAM_TYPES] FOREIGN KEY([Diagram_Type_XML])
REFERENCES [dbo].[DIAGRAM_TYPES_XML] ([Diagram_Type_XML])
GO
ALTER TABLE [dbo].[SHAPE_TYPES] CHECK CONSTRAINT [FK_Shape_Types_CSET_DIAGRAM_TYPES]
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SHAPE_TYPES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SHAPE_TYPES'
GO
