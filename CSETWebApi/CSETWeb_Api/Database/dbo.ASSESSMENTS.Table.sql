USE [CSETWeb]
GO
/****** Object:  Table [dbo].[ASSESSMENTS]    Script Date: 6/28/2018 8:21:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ASSESSMENTS](
	[Assessment_Id] [int] IDENTITY(1,1) NOT NULL,
	[AssessmentCreatedDate] [datetime] NOT NULL,
	[AssessmentCreatorId] [int] NULL,
	[LastAccessedDate] [datetime] NULL,
 CONSTRAINT [PK_Aggregation_1] PRIMARY KEY CLUSTERED 
(
	[Assessment_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[ASSESSMENTS] ON 

INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (1, CAST(N'2018-04-18T01:30:50.520' AS DateTime), 8, NULL)
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (2, CAST(N'2018-04-18T01:34:01.980' AS DateTime), 8, NULL)
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (15, CAST(N'2018-05-03T22:31:01.043' AS DateTime), NULL, CAST(N'2018-05-04T04:31:01.293' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (16, CAST(N'2018-05-03T22:34:41.950' AS DateTime), NULL, CAST(N'2018-05-04T04:34:41.980' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (17, CAST(N'2018-05-03T23:27:45.620' AS DateTime), NULL, CAST(N'2018-05-04T05:27:56.807' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (18, CAST(N'2018-05-03T23:29:45.870' AS DateTime), NULL, CAST(N'2018-05-04T05:29:45.903' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (19, CAST(N'2018-05-04T03:41:52.230' AS DateTime), NULL, CAST(N'2018-05-04T15:44:09.480' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (20, CAST(N'2018-05-04T09:46:39.760' AS DateTime), NULL, CAST(N'2018-05-04T15:46:39.793' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (21, CAST(N'2018-05-04T09:54:18.557' AS DateTime), NULL, CAST(N'2018-05-04T15:55:36.247' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (22, CAST(N'2018-05-04T04:12:40.700' AS DateTime), 15, CAST(N'2018-05-04T16:31:52.590' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (23, CAST(N'2018-05-04T10:38:17.183' AS DateTime), 15, CAST(N'2018-05-04T16:39:06.103' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (24, CAST(N'2018-05-07T10:16:00.053' AS DateTime), 8, CAST(N'2018-05-07T16:16:00.320' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (25, CAST(N'2018-05-07T05:07:06.613' AS DateTime), 8, CAST(N'2018-06-18T16:41:55.010' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (26, CAST(N'2018-05-16T07:07:26.500' AS DateTime), 15, CAST(N'2018-06-15T19:33:02.027' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (27, CAST(N'2018-05-17T18:24:29.470' AS DateTime), 2, CAST(N'2018-06-13T22:48:38.703' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (28, CAST(N'2018-05-18T00:25:30.437' AS DateTime), 17, CAST(N'2018-06-15T19:31:02.253' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (29, CAST(N'2018-05-21T10:15:59.803' AS DateTime), 19, CAST(N'2018-05-22T19:42:58.210' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (30, CAST(N'2018-05-22T12:24:46.010' AS DateTime), 19, CAST(N'2018-05-22T12:24:46.010' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (32, CAST(N'2018-06-06T10:16:23.937' AS DateTime), 24, CAST(N'2018-06-07T21:06:27.453' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (33, CAST(N'2018-06-10T19:05:42.047' AS DateTime), 24, CAST(N'2018-06-15T14:21:40.963' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (34, CAST(N'2018-06-11T13:11:12.020' AS DateTime), 8, CAST(N'2018-06-11T20:03:34.050' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (35, CAST(N'2018-06-11T07:23:40.973' AS DateTime), 8, CAST(N'2018-06-11T19:30:51.433' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (36, CAST(N'2018-06-11T07:30:51.403' AS DateTime), 8, CAST(N'2018-06-11T19:31:21.670' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (37, CAST(N'2018-06-11T13:31:21.637' AS DateTime), 8, CAST(N'2018-06-11T19:33:10.907' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (38, CAST(N'2018-06-11T07:33:10.860' AS DateTime), 8, CAST(N'2018-06-11T19:33:13.763' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (39, CAST(N'2018-06-11T07:38:42.113' AS DateTime), 8, CAST(N'2018-06-11T19:39:18.240' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (40, CAST(N'2018-06-11T07:50:10.580' AS DateTime), 8, CAST(N'2018-06-11T19:50:18.473' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (41, CAST(N'2018-06-11T13:54:50.180' AS DateTime), 8, CAST(N'2018-06-11T13:54:50.180' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (42, CAST(N'2018-06-11T13:59:11.577' AS DateTime), 8, CAST(N'2018-06-11T13:59:11.577' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (43, CAST(N'2018-06-11T08:01:00.373' AS DateTime), 8, CAST(N'2018-06-11T20:03:18.410' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (44, CAST(N'2018-06-11T14:03:34.020' AS DateTime), 8, CAST(N'2018-06-11T14:03:34.020' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (45, CAST(N'2018-06-11T14:08:38.447' AS DateTime), 8, CAST(N'2018-06-11T14:08:38.447' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (46, CAST(N'2018-06-11T09:09:02.687' AS DateTime), 8, CAST(N'2018-06-11T21:09:27.080' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (47, CAST(N'2018-06-11T09:15:49.993' AS DateTime), 8, CAST(N'2018-06-11T21:16:38.883' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (48, CAST(N'2018-06-11T15:21:07.640' AS DateTime), 8, CAST(N'2018-06-11T15:21:07.640' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (49, CAST(N'2018-06-11T15:23:30.237' AS DateTime), 8, CAST(N'2018-06-11T15:23:30.237' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (50, CAST(N'2018-06-11T15:27:43.320' AS DateTime), 8, CAST(N'2018-06-11T21:27:51.413' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (51, CAST(N'2018-06-11T15:31:41.743' AS DateTime), 8, CAST(N'2018-06-11T21:31:49.103' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (52, CAST(N'2018-06-11T15:41:27.663' AS DateTime), 8, CAST(N'2018-06-11T21:41:35.477' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (53, CAST(N'2018-06-11T09:43:15.103' AS DateTime), 8, CAST(N'2018-06-11T21:44:19.180' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (54, CAST(N'2018-06-11T09:46:10.387' AS DateTime), 8, CAST(N'2018-06-11T21:49:22.907' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (55, CAST(N'2018-06-12T08:39:56.470' AS DateTime), 8, CAST(N'2018-06-12T08:39:56.470' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (56, CAST(N'2018-06-12T08:52:00.500' AS DateTime), 8, CAST(N'2018-06-12T08:52:00.500' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (57, CAST(N'2018-06-12T13:39:07.440' AS DateTime), 2, CAST(N'2018-06-12T13:39:07.440' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (58, CAST(N'2018-06-12T13:39:19.363' AS DateTime), 2, CAST(N'2018-06-12T13:39:19.363' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (59, CAST(N'2018-06-12T13:49:12.967' AS DateTime), 2, CAST(N'2018-06-12T13:49:12.967' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (60, CAST(N'2018-06-12T13:52:11.300' AS DateTime), 2, CAST(N'2018-06-12T13:52:11.300' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (61, CAST(N'2018-06-12T13:57:32.867' AS DateTime), 2, CAST(N'2018-06-12T13:57:32.867' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (62, CAST(N'2018-06-12T14:02:29.873' AS DateTime), 2, CAST(N'2018-06-12T14:02:29.873' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (63, CAST(N'2018-06-12T14:06:12.627' AS DateTime), 2, CAST(N'2018-06-12T14:06:12.627' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (64, CAST(N'2018-06-12T14:08:47.020' AS DateTime), 2, CAST(N'2018-06-12T14:08:47.020' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (65, CAST(N'2018-06-12T14:13:55.870' AS DateTime), 2, CAST(N'2018-06-12T14:13:55.870' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (66, CAST(N'2018-06-12T14:15:31.810' AS DateTime), 24, CAST(N'2018-06-12T14:15:31.810' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (67, CAST(N'2018-06-12T14:15:38.030' AS DateTime), 24, CAST(N'2018-06-12T14:15:38.030' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (68, CAST(N'2018-06-12T14:15:42.560' AS DateTime), 24, CAST(N'2018-06-12T14:15:42.560' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (69, CAST(N'2018-06-12T14:15:43.387' AS DateTime), 24, CAST(N'2018-06-12T14:15:43.387' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (70, CAST(N'2018-06-12T14:15:44.903' AS DateTime), 24, CAST(N'2018-06-12T14:15:44.903' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (71, CAST(N'2018-06-12T14:16:07.607' AS DateTime), 24, CAST(N'2018-06-12T14:16:07.607' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (72, CAST(N'2018-06-12T14:16:09.733' AS DateTime), 24, CAST(N'2018-06-12T14:16:09.733' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (73, CAST(N'2018-06-12T14:16:55.733' AS DateTime), 24, CAST(N'2018-06-12T14:16:55.733' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (74, CAST(N'2018-06-12T14:16:57.547' AS DateTime), 24, CAST(N'2018-06-12T14:16:57.547' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (75, CAST(N'2018-06-12T14:22:35.303' AS DateTime), 2, CAST(N'2018-06-12T14:22:35.303' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (76, CAST(N'2018-06-12T14:25:34.320' AS DateTime), 2, CAST(N'2018-06-12T14:25:34.320' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (77, CAST(N'2018-06-12T14:41:55.927' AS DateTime), 2, CAST(N'2018-06-12T14:41:55.927' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (78, CAST(N'2018-06-12T14:41:56.553' AS DateTime), 2, CAST(N'2018-06-12T14:41:56.553' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (79, CAST(N'2018-06-12T14:41:57.053' AS DateTime), 2, CAST(N'2018-06-12T14:41:57.053' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (80, CAST(N'2018-06-12T14:41:57.553' AS DateTime), 2, CAST(N'2018-06-12T14:41:57.553' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (81, CAST(N'2018-06-12T14:41:58.007' AS DateTime), 2, CAST(N'2018-06-12T14:41:58.007' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (82, CAST(N'2018-06-12T14:41:58.383' AS DateTime), 2, CAST(N'2018-06-12T14:41:58.383' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (83, CAST(N'2018-06-12T14:41:58.930' AS DateTime), 2, CAST(N'2018-06-12T14:41:58.930' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (84, CAST(N'2018-06-12T14:41:59.320' AS DateTime), 2, CAST(N'2018-06-12T14:41:59.320' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (85, CAST(N'2018-06-13T08:29:52.037' AS DateTime), 24, CAST(N'2018-06-13T08:29:52.037' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (86, CAST(N'2018-06-13T13:16:30.473' AS DateTime), 17, CAST(N'2018-06-13T13:16:30.473' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (87, CAST(N'2018-06-13T13:16:33.380' AS DateTime), 17, CAST(N'2018-06-13T13:16:33.380' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (88, CAST(N'2018-06-13T13:16:33.927' AS DateTime), 17, CAST(N'2018-06-13T13:16:33.927' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (89, CAST(N'2018-06-13T13:16:34.147' AS DateTime), 17, CAST(N'2018-06-13T13:16:34.147' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (90, CAST(N'2018-06-13T13:16:34.333' AS DateTime), 17, CAST(N'2018-06-13T13:16:34.333' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (91, CAST(N'2018-06-13T13:16:34.490' AS DateTime), 17, CAST(N'2018-06-13T13:16:34.490' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (92, CAST(N'2018-06-13T13:16:42.990' AS DateTime), 17, CAST(N'2018-06-13T13:16:42.990' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (93, CAST(N'2018-06-13T14:52:29.163' AS DateTime), 15, CAST(N'2018-06-13T14:52:29.163' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (94, CAST(N'2018-06-13T14:52:54.773' AS DateTime), 8, CAST(N'2018-06-13T14:52:54.773' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (95, CAST(N'2018-06-13T16:36:48.907' AS DateTime), 15, CAST(N'2018-06-13T16:36:48.907' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (96, CAST(N'2018-06-13T10:37:33.457' AS DateTime), 2, CAST(N'2018-06-15T18:08:58.830' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (97, CAST(N'2018-06-13T16:46:54.920' AS DateTime), 2, CAST(N'2018-06-13T16:46:54.920' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (98, CAST(N'2018-06-13T10:48:38.657' AS DateTime), 2, CAST(N'2018-06-19T18:19:53.207' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (99, CAST(N'2018-06-15T13:31:02.223' AS DateTime), 17, CAST(N'2018-06-15T13:31:02.223' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (100, CAST(N'2018-06-15T13:33:01.993' AS DateTime), 17, CAST(N'2018-06-15T19:33:14.853' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (101, CAST(N'2018-06-15T07:33:14.823' AS DateTime), 17, CAST(N'2018-06-15T19:33:19.900' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (102, CAST(N'2018-06-15T13:37:51.180' AS DateTime), 15, CAST(N'2018-06-15T13:37:51.180' AS DateTime))
INSERT [dbo].[ASSESSMENTS] ([Assessment_Id], [AssessmentCreatedDate], [AssessmentCreatorId], [LastAccessedDate]) VALUES (103, CAST(N'2018-06-18T10:41:54.727' AS DateTime), 15, CAST(N'2018-06-18T10:41:54.727' AS DateTime))
SET IDENTITY_INSERT [dbo].[ASSESSMENTS] OFF
ALTER TABLE [dbo].[ASSESSMENTS] ADD  CONSTRAINT [DF_ASSESSMENTS_AssessmentCreatedDate]  DEFAULT (getdate()) FOR [AssessmentCreatedDate]
GO
ALTER TABLE [dbo].[ASSESSMENTS]  WITH CHECK ADD  CONSTRAINT [FK_ASSESSMENTS_USERS] FOREIGN KEY([AssessmentCreatorId])
REFERENCES [dbo].[USERS] ([UserId])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[ASSESSMENTS] CHECK CONSTRAINT [FK_ASSESSMENTS_USERS]
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSESSMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSESSMENTS'
GO
