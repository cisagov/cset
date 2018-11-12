USE [CSETWeb]
GO
/****** Object:  Table [dbo].[RECENT_FILES]    Script Date: 6/28/2018 8:21:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RECENT_FILES](
	[AssessmentName] [varchar](512) NULL,
	[Filename] [varchar](900) NOT NULL,
	[FilePath] [varchar](1024) NOT NULL,
	[LastOpenedTime] [datetime] NOT NULL,
	[RecentFileId] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_RECENT_FILES_1] PRIMARY KEY CLUSTERED 
(
	[RecentFileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RECENT_FILES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RECENT_FILES'
GO
