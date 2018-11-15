USE [CSETWeb]
GO
/****** Object:  Table [dbo].[FILE_TYPE]    Script Date: 11/14/2018 3:57:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FILE_TYPE](
	[File_Type_Id] [numeric](38, 0) NOT NULL,
	[File_Type] [varchar](60) NOT NULL,
	[Mime_Type] [varchar](60) NULL,
	[Description] [varchar](250) NULL,
 CONSTRAINT [SYS_C0014416] PRIMARY KEY CLUSTERED 
(
	[File_Type_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[FILE_TYPE] ([File_Type_Id], [File_Type], [Mime_Type], [Description]) VALUES (CAST(15 AS Numeric(38, 0)), N'zip', N'application/x-zip-compressed', N'LZW Zip Compressed file.')
INSERT [dbo].[FILE_TYPE] ([File_Type_Id], [File_Type], [Mime_Type], [Description]) VALUES (CAST(18 AS Numeric(38, 0)), N'ppt', N'application/vnd.ms-powerpoint', N'Microsoft Powerpoint file')
INSERT [dbo].[FILE_TYPE] ([File_Type_Id], [File_Type], [Mime_Type], [Description]) VALUES (CAST(19 AS Numeric(38, 0)), N'txt', N'text/plain', N'General ASCII text file.')
INSERT [dbo].[FILE_TYPE] ([File_Type_Id], [File_Type], [Mime_Type], [Description]) VALUES (CAST(20 AS Numeric(38, 0)), N'bmp', N'image/bmp', N'BitMap image file')
INSERT [dbo].[FILE_TYPE] ([File_Type_Id], [File_Type], [Mime_Type], [Description]) VALUES (CAST(27 AS Numeric(38, 0)), N'xls', N'application/vnd.ms-excel', N'Microsoft Excel Spreadsheet file')
INSERT [dbo].[FILE_TYPE] ([File_Type_Id], [File_Type], [Mime_Type], [Description]) VALUES (CAST(28 AS Numeric(38, 0)), N'exe', N'application/octet-stream', N'binary executable file')
INSERT [dbo].[FILE_TYPE] ([File_Type_Id], [File_Type], [Mime_Type], [Description]) VALUES (CAST(29 AS Numeric(38, 0)), N'html', N'text/html', N'HTML file .html')
INSERT [dbo].[FILE_TYPE] ([File_Type_Id], [File_Type], [Mime_Type], [Description]) VALUES (CAST(30 AS Numeric(38, 0)), N'doc', N'application/msword', N'Microsoft Word Document')
INSERT [dbo].[FILE_TYPE] ([File_Type_Id], [File_Type], [Mime_Type], [Description]) VALUES (CAST(31 AS Numeric(38, 0)), N'pdf', N'application/pdf', N'Acrobat PDF file')
INSERT [dbo].[FILE_TYPE] ([File_Type_Id], [File_Type], [Mime_Type], [Description]) VALUES (CAST(32 AS Numeric(38, 0)), N'xml', N'text/xml', N'XML text file')
INSERT [dbo].[FILE_TYPE] ([File_Type_Id], [File_Type], [Mime_Type], [Description]) VALUES (CAST(33 AS Numeric(38, 0)), N'gif', N'image/gif', N'Graphics Interchange Format image file')
INSERT [dbo].[FILE_TYPE] ([File_Type_Id], [File_Type], [Mime_Type], [Description]) VALUES (CAST(34 AS Numeric(38, 0)), N'jpg', N'image/pjpeg', N'Joint Photographics Expert Group image file')
INSERT [dbo].[FILE_TYPE] ([File_Type_Id], [File_Type], [Mime_Type], [Description]) VALUES (CAST(35 AS Numeric(38, 0)), N'avi', N'video/avi', N'Microsoft Audio Video Interleave video format')
INSERT [dbo].[FILE_TYPE] ([File_Type_Id], [File_Type], [Mime_Type], [Description]) VALUES (CAST(37 AS Numeric(38, 0)), N'mpeg', N'video/mpeg', N'Moving Pictures Experts Group video format .mpeg')
INSERT [dbo].[FILE_TYPE] ([File_Type_Id], [File_Type], [Mime_Type], [Description]) VALUES (CAST(39 AS Numeric(38, 0)), N'class', N'application/java', N'Java Class file')
INSERT [dbo].[FILE_TYPE] ([File_Type_Id], [File_Type], [Mime_Type], [Description]) VALUES (CAST(40 AS Numeric(38, 0)), N'xlsx', N'application/vnd.ms-excel', N'Microsoft Office Excel 2007')
INSERT [dbo].[FILE_TYPE] ([File_Type_Id], [File_Type], [Mime_Type], [Description]) VALUES (CAST(41 AS Numeric(38, 0)), N'docx', N'application/msword', N'Microsoft Office Word 2007')
INSERT [dbo].[FILE_TYPE] ([File_Type_Id], [File_Type], [Mime_Type], [Description]) VALUES (CAST(42 AS Numeric(38, 0)), N'pptx', N'application/vnd.ms-powerpoint', N'Microsoft Office PowerPoint 2007')
INSERT [dbo].[FILE_TYPE] ([File_Type_Id], [File_Type], [Mime_Type], [Description]) VALUES (CAST(43 AS Numeric(38, 0)), N'vsd', N'application/x-visio', N'Microsoft Office Visio 2007')
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The File Type Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILE_TYPE', @level2type=N'COLUMN',@level2name=N'File_Type_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The File Type is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILE_TYPE', @level2type=N'COLUMN',@level2name=N'File_Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Mime Type is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILE_TYPE', @level2type=N'COLUMN',@level2name=N'Mime_Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Description is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILE_TYPE', @level2type=N'COLUMN',@level2name=N'Description'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'File Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILE_TYPE'
GO
