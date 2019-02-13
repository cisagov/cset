USE [CSETWeb]
GO
/****** Object:  Table [dbo].[NIST_SAL_INFO_TYPES]    Script Date: 11/14/2018 3:57:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NIST_SAL_INFO_TYPES](
	[Assessment_Id] [int] NOT NULL,
	[Type_Value] [varchar](50) NOT NULL,
	[Selected] [bit] NOT NULL,
	[Confidentiality_Value] [varchar](50) NULL,
	[Confidentiality_Special_Factor] [varchar](1500) NULL,
	[Integrity_Value] [varchar](50) NULL,
	[Integrity_Special_Factor] [varchar](1500) NULL,
	[Availability_Value] [varchar](50) NULL,
	[Availability_Special_Factor] [varchar](1500) NULL,
	[Area] [varchar](50) NULL,
	[NIST_Number] [varchar](50) NULL,
 CONSTRAINT [PK_NIST_SAL] PRIMARY KEY CLUSTERED 
(
	[Assessment_Id] ASC,
	[Type_Value] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NIST_SAL_INFO_TYPES] ADD  CONSTRAINT [DF_NIST_SAL_INFO_TYPES_Selected]  DEFAULT ((0)) FOR [Selected]
GO
ALTER TABLE [dbo].[NIST_SAL_INFO_TYPES]  WITH NOCHECK ADD  CONSTRAINT [FK_NIST_SAL_STANDARD_SELECTION] FOREIGN KEY([Assessment_Id])
REFERENCES [dbo].[STANDARD_SELECTION] ([Assessment_Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NIST_SAL_INFO_TYPES] CHECK CONSTRAINT [FK_NIST_SAL_STANDARD_SELECTION]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NIST_SAL_INFO_TYPES', @level2type=N'COLUMN',@level2name=N'Assessment_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Type Value is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NIST_SAL_INFO_TYPES', @level2type=N'COLUMN',@level2name=N'Type_Value'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Selected is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NIST_SAL_INFO_TYPES', @level2type=N'COLUMN',@level2name=N'Selected'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Confidentiality Value is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NIST_SAL_INFO_TYPES', @level2type=N'COLUMN',@level2name=N'Confidentiality_Value'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Integrity Value is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NIST_SAL_INFO_TYPES', @level2type=N'COLUMN',@level2name=N'Integrity_Value'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Availability Value is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NIST_SAL_INFO_TYPES', @level2type=N'COLUMN',@level2name=N'Availability_Value'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Area is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NIST_SAL_INFO_TYPES', @level2type=N'COLUMN',@level2name=N'Area'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NIST_SAL_INFO_TYPES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NIST_SAL_INFO_TYPES'
GO
