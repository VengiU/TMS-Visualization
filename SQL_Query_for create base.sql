USE [test_tr]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--#region drop tables
------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS [dbo].[Logs]
DROP TABLE IF EXISTS [dbo].[Trackers]
DROP TABLE IF EXISTS [dbo].[UserTasks]
DROP TABLE IF EXISTS [dbo].[__EFMigrationsHistory]
DROP TABLE IF EXISTS [dbo].[Tasks]
DROP TABLE IF EXISTS [dbo].[Projects]
DROP TABLE IF EXISTS [dbo].[Users]
DROP TABLE IF EXISTS [dbo].[Roles]
DROP TABLE IF EXISTS [dbo].[Teams]
DROP TABLE IF EXISTS [dbo].[States]
GO
------------------------------------------------------------------------------------------------------------------------
--#endregion

--#region drop triggers
------------------------------------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS dbo.Tasks_delete
DROP TRIGGER IF EXISTS dbo.Project_delete
GO
------------------------------------------------------------------------------------------------------------------------
--#endregion

--#region Delete procedures
------------------------------------------------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS dbo.Get_Users
DROP PROCEDURE IF EXISTS dbo.Get_Status
DROP PROCEDURE IF EXISTS dbo.Get_data_by_Projects
DROP PROCEDURE IF EXISTS dbo.Team_stuff
DROP PROCEDURE IF EXISTS dbo.Get_Projects
DROP PROCEDURE IF EXISTS dbo.Get_Tasks_by_Project
DROP PROCEDURE IF EXISTS dbo.Get_Data_By_Users
DROP PROCEDURE IF EXISTS dbo.Get_Data_tasks
DROP PROCEDURE IF EXISTS dbo.Get_All_Info
GO
------------------------------------------------------------------------------------------------------------------------
--#endregion

--#region Create tables
------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
CREATE TABLE [dbo].[Logs](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Date] [datetime2](2) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ProjectId] [int] NOT NULL,
	[UserId] SMALLINT NOT NULL,	--SMALLINT
 CONSTRAINT [PK_Logs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------

CREATE TABLE [dbo].[States](
	[Id] TINYINT IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NULL,
 CONSTRAINT [PK_States] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 

GO
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
CREATE TABLE [dbo].[Roles](
	[Id] TINYINT IDENTITY(1,1) NOT NULL,	--TINY
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
CREATE TABLE [dbo].[Projects](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Title] [nvarchar](50) NOT NULL,
	[Actual] [bit] NOT NULL,
 CONSTRAINT [PK_Projects] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[Projects] ADD  DEFAULT ((1)) FOR [Actual]
GO
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
CREATE TABLE [dbo].[Tasks](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[CreatedDate] [datetime2](2) NOT NULL,
	[DeadDate] [datetime2](2) NOT NULL,
 CONSTRAINT [PK_Tasks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[Tasks]  WITH CHECK ADD  CONSTRAINT [FK_Tasks_Projects_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Tasks] CHECK CONSTRAINT [FK_Tasks_Projects_ProjectId]
GO
--------------------------------------------------------------------------------

--SELECT * FROM  [dbo].[Teams]
--------------------------------------------------------------------------------
CREATE TABLE [dbo].[Teams](
	[Id] SMALLINT IDENTITY(1,1) NOT NULL,	--SMALL
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Teams] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
CREATE TABLE [dbo].[Users](
	[Id] SMALLINT IDENTITY(1,1) NOT NULL, --SMALLINT
	[Username] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](150) NULL,
	[RoleId] TINYINT NOT NULL,			--TINY
	[TeamId] SMALLINT NOT NULL,			--SMALL
	[Token] [nvarchar](500) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_Roles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Roles] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_Roles_RoleId]
GO

ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_Teams_TeamId] FOREIGN KEY([TeamId])
REFERENCES [dbo].[Teams] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_Teams_TeamId]
GO
--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
CREATE TABLE [dbo].[UserTasks](
	[TaskId] [int] NOT NULL,
	[UserId] SMALLINT NOT NULL,				--SMALLINT
	[EstimateHours] FLOAT/*(23)*/ NOT NULL,
	[UsedHours] FLOAT/*(23)*/ NOT NULL,
	[StateId] TINYINT NOT NULL,
 CONSTRAINT [PK_UserTasks] PRIMARY KEY CLUSTERED 
(
	[TaskId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[UserTasks] ADD  DEFAULT ((1)) FOR [StateId]
GO

ALTER TABLE [dbo].[UserTasks]  WITH CHECK ADD  CONSTRAINT [FK_UserTasks_States_StateId] FOREIGN KEY([StateId])
REFERENCES [dbo].[States] ([Id])
ON DELETE SET DEFAULT
GO


ALTER TABLE [dbo].[UserTasks]  WITH CHECK ADD  CONSTRAINT [FK_UserTasks_Tasks_TaskId] FOREIGN KEY([TaskId])
REFERENCES [dbo].[Tasks] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[UserTasks] CHECK CONSTRAINT [FK_UserTasks_Tasks_TaskId]
GO

ALTER TABLE [dbo].[UserTasks]  WITH CHECK ADD  CONSTRAINT [FK_UserTasks_Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[UserTasks] CHECK CONSTRAINT [FK_UserTasks_Users_UserId]
GO
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
ALTER TABLE [dbo].[Logs]  WITH CHECK ADD  CONSTRAINT [FK_Logs_Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])

ALTER TABLE [dbo].[Logs]  WITH CHECK ADD  CONSTRAINT [FK_Logs_Projects_ProjectsId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([Id])
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------

CREATE TABLE [dbo].[Trackers](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[TaskId] [int] NOT NULL,
	[UserId] SMALLINT NOT NULL,	--SMALLINT
	[TrackStart] [datetime2](2) NOT NULL,
	[TrackEnd] [datetime2](2) NULL,
 CONSTRAINT [PK_Trackers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Trackers]  WITH CHECK ADD  CONSTRAINT [FK_Trackers_Tasks_TaskId] FOREIGN KEY([TaskId])
REFERENCES [dbo].[Tasks] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Trackers] CHECK CONSTRAINT [FK_Trackers_Tasks_TaskId]
GO

ALTER TABLE [dbo].[Trackers]  WITH CHECK ADD  CONSTRAINT [FK_Trackers_Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Trackers] CHECK CONSTRAINT [FK_Trackers_Users_UserId]
GO
--------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
--#endregion

--#region triggers only for situation without Foreign Keys
------------------------------------------------------------------------------------------------------------------------
--Триггеры на удаление в случае отключения/не_создания ключей
GO

CREATE TRIGGER dbo.Project_delete
ON dbo.Projects
FOR DELETE
AS Begin
	DELETE FROM dbo.Tasks
	WHERE ProjectId IN (SELECT  deleted.id FROM deleted)
	End

	GO
	

CREATE TRIGGER dbo.Tasks_delete
ON dbo.Tasks
FOR DELETE
AS begin
	DELETE FROM dbo.UserTasks
	WHERE TaskId IN (SELECT  deleted.id FROM deleted)
	end
	GO
	
------------------------------------------------------------------------------------------------------------------------
--#endregion


--#region Insert test data into tables
------------------------------------------------------------------------------------------------------------------------
--Тестовые данные:
INSERT INTO dbo.Projects ([DESCRIPTION], Title)
	VALUES('Description of Test project 1', 'Title of Test project 1')	,
	('Description of Test project 2', 'Title 1 of Test project 2'),
	('Description of Test project 3', 'Title 2 of Test project 3'),
	('Description of Test project 4', 'Title 3 of Test project 4'),
	('Description of Test project 5', 'Title 4 of Test project 5')
	
	INSERT INTO dbo.Tasks (Title, ProjectId, Description, CreatedDate, DeadDate)
	VALUES('Title 1',1,'Description 1','20170110','20170112'),
	('Title 2',1,'Description 2','20170111','20170115'),
	('Title 3',1,'Description 3','20170112','20170116'),
	('Title 4',2,'Description 4','20170113','20170117'),
	('Title 5',2,'Description 5','20170114','20170118'),
	('Title 6',3,'Description 6','20170117','20170119'),
	('Title 7',4,'Description 7','20170119','20170121'),
	('Title 8',5,'Description 8','20170120','20170122'),
	('Title 9',3,'Description 9','20170125','20170124'),
	('Title 10',5,'Description 10','20170127','20170129')
	


INSERT INTO [dbo].[States] (NAME)
VALUES('In work'), ('Finished'), ('Deleted')

	
INSERT INTO [dbo].[Roles](Name)
VALUES('Admin'),('User')

		
	
INSERT INTO dbo.[Teams] (Name)
VALUES('Test Team'),('Dream Team'),('777777')


INSERT INTO 	[dbo].[Users] (Username, [Password], Email, RoleId, TeamId)
VALUES
				('TestAdmin','pmWkWSBCL51Bfkhn79xPuKBKHz//H6B+mY6G9/eieuM=',NULL,	1,	1),
				('New one','pmWkWSBCL51Bfkhn79xPuKBKHz//H6B+mY6G9/eieuM=',	'776777@mail.mm',	2,	1),
				('NotAdmin','pmWkWSBCL51Bfkhn79xPuKBKHz//H6B+mY6G9/eieuM=',	'none@mail.ru',	2,	2),
				('My','pmWkWSBCL51Bfkhn79xPuKBKHz//H6B+mY6G9/eieuM=',	'my.ua@gmal.com',	1,	1),
				('User','pmWkWSBCL51Bfkhn79xPuKBKHz//H6B+mY6G9/eieuM=',	'u@mail.ru',	2,	1)


INSERT INTO dbo.UserTasks(TaskId, UserId, EstimateHours, UsedHours)
VALUES(1,3,8,8),
(2,3,8,8),
(3,2,16.00,12.00),
(4,3,24.00,32.00),
(5,2,12.00,10.00),
(6,1,12.00,10.00),
(7,3,12.00,10.00),
(8,2,12.00,10.00),
(9,1,12.00,10.00),
(10,1,12.00,10.00)
------------------------------------------------------------------------------------------------------------------------
--#endregion


--#region Stored procedures for SSRS Dashbord
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

GO
--#region Get all users
------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE dbo.Get_Users
AS 
BEGIN

SET NOCOUNT ON
SET XACT_ABORT ON
SET ANSI_NULLS ON

SELECT DISTINCT u.Username, u.Id
FROM dbo.Users AS u

END
Go
------------------------------------------------------------------------------------------------------------------------
--#endregion

--#region Get status of Tasks
------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE dbo.Get_Status
AS 
BEGIN

SET NOCOUNT ON
SET XACT_ABORT ON
SET ANSI_NULLS ON

SELECT DISTINCT u.Id, u.Name
FROM [dbo].[States] AS u

END
Go
------------------------------------------------------------------------------------------------------------------------
--#endregion

--#region Get all Projects
------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE dbo.Get_Projects
AS 
BEGIN

SET NOCOUNT ON
SET XACT_ABORT ON
SET ANSI_NULLS ON

SELECT DISTINCT p.Id, p.Title
FROM [dbo].Projects AS p

END
GO
------------------------------------------------------------------------------------------------------------------------
--#endregion

--#region Get base information about projects
------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE dbo.Get_data_by_Projects
@status VARCHAR(MAX) = '1,2,3', 
@users VARCHAR(MAX) = '',
@projects VARCHAR(MAX) = ''
AS 
BEGIN

SET NOCOUNT ON
SET XACT_ABORT ON
SET ANSI_NULLS ON


SELECT 
			p.Id, 
			p.Title,
			isnull(count(distinct t.Id),0)		AS Count_Tasks,
			isnull(sum(ut.EstimateHours),0)		AS Estimate_Hours,
			isnull(SUM(ut.UsedHours),0)				AS Used_Hours
FROM dbo.Projects AS p
LEFT JOIN dbo.Tasks AS t ON p.Id = t.ProjectId
LEFT JOIN dbo.UserTasks AS ut ON ut.TaskId = t.Id
AND ut.StateId IN (SELECT * from string_split(@status,','))
AND ut.UserId IN (SELECT * from string_split(@users,','))
WHERE p.Id IN (SELECT * from string_split(@projects,','))
GROUP BY p.Id, 
			p.Title
ORDER BY isnull(sum(ut.EstimateHours),0) desc, isnull(SUM(ut.UsedHours),0) desc
			
END	
GO
------------------------------------------------------------------------------------------------------------------------
--#endregion

			
--#region Get team stuff
------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE dbo.Team_stuff
@users VARCHAR(MAX) = ''
AS 
BEGIN

SET NOCOUNT ON
SET XACT_ABORT ON
SET ANSI_NULLS ON

SELECT t.* , isnull(COUNT(DISTINCT u.Id),0) AS Count_Employees
FROM dbo.Teams AS t
left JOIN dbo.Users AS u ON u.TeamId = t.Id
WHERE u.Id IN (SELECT * from string_split(@users,','))
GROUP BY t.Id,t.Name
ORDER BY COUNT(DISTINCT u.Id) DESC

END
GO
------------------------------------------------------------------------------------------------------------------------
--#endregion


--#region Get tasks by Projects
------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE dbo.Get_Tasks_by_Project
@status VARCHAR(MAX) = '1,2,3', 
@users VARCHAR(MAX) = '',
@projects VARCHAR(MAX) = ''
AS 
BEGIN

SET NOCOUNT ON
SET XACT_ABORT ON
SET ANSI_NULLS ON

SELECT		p.Id,
					p.Title, 
					isnull(COUNT(DISTINCT t.Id),0)	AS Count_tasks,
					SUM(ut.EstimateHours)						AS EstimateHours,
					SUM(ut.UsedHours)								AS UsedHours,
					COUNT(distinct ut.UserId)				AS Count_users
FROM dbo.Projects AS p
Left JOIN dbo.Tasks AS t ON t.ProjectId = p.Id
LEFT JOIN dbo.UserTasks AS ut ON ut.TaskId = t.Id
WHERE p.Id IN (SELECT * from string_split(@projects,','))
AND ut.StateId IN (SELECT * from string_split(@status,','))
AND ut.UserId IN (SELECT * from string_split(@users,','))
GROUP BY p.Id,p.Title
END
GO
------------------------------------------------------------------------------------------------------------------------
--#endregion


--#region Get information by Users
------------------------------------------------------------------------------------------------------------------------
--EXEC dbo.Get_Data_By_Users '1,2,3','1,2,3,4,5,6,7', '1,2,3,4,5,6,7'
CREATE PROCEDURE dbo.Get_Data_By_Users
@status VARCHAR(MAX) = '1,2,3', 
@users VARCHAR(MAX) = '',
@projects VARCHAR(MAX) = ''
AS 
BEGIN

SET NOCOUNT ON
SET XACT_ABORT ON
SET ANSI_NULLS ON

SELECT		u.Id, 
					u.Username, 
					u.Email, 
					r.Name AS RoleName, 
					t.Name AS TeamName,
					COUNT(ut.TaskId)			AS Count_tasks,
					SUM(ut.EstimateHours) AS EstimateHours,
					SUM(ut.UsedHours)			AS UsedHours,
					Cast(SUM(ut.UsedHours)*1.00/SUM(ut.EstimateHours)*1.00 as Numeric(10,2))AS Perc_Used,
					SUM(ut.EstimateHours)-SUM(ut.UsedHours) AS Left_Time
FROM dbo.Users AS u
JOIN dbo.Roles AS r ON u.RoleId = r.Id
JOIN dbo.Teams AS t ON t.Id = u.TeamId
LEFT JOIN dbo.UserTasks AS ut ON ut.UserId = u.Id
LEFT JOIN dbo.Tasks AS t2 ON t2.Id = ut.TaskId
LEFT JOIN dbo.Projects AS p ON p.Id = t2.ProjectId
WHERE p.Id IN (SELECT * from string_split(@projects,','))
AND ut.StateId IN (SELECT * from string_split(@status,','))
AND u.Id IN (SELECT * from string_split(@users,','))
GROUP BY u.Id, 
					u.Username, 
					u.Email, 
					r.Name , 
					t.Name 
					
					
END
GO
------------------------------------------------------------------------------------------------------------------------
--#endregion



--#region Get information by Users
------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE dbo.Get_Data_tasks
@status VARCHAR(MAX) = '1,2,3', 
@users VARCHAR(MAX) = '',
@projects VARCHAR(MAX) = ''
AS 
BEGIN

SET NOCOUNT ON
SET XACT_ABORT ON
SET ANSI_NULLS ON

	
SELECT		ut.TaskId, 
					t.Title,
					SUM(ut.EstimateHours) AS EstimateHours, 
					SUM(ut.UsedHours) AS UsedHours
FROM dbo.UserTasks AS ut
JOIN dbo.Tasks AS t ON t.Id = ut.TaskId		
JOIN dbo.Projects AS p ON p.Id = t.ProjectId		
WHERE ut.StateId IN (SELECT * from string_split(@status,','))
AND p.Id IN (SELECT * from string_split(@projects,','))
AND  ut.UserId IN (SELECT * from string_split(@users,','))
GROUP BY ut.TaskId, 
					t.Title		
ORDER BY 		SUM(ut.EstimateHours) DESC
END
GO
------------------------------------------------------------------------------------------------------------------------
--#endregion


--#region Get all information for pivot table
--EXEC dbo.Get_All_Info '1,2,3','1,2,3,4,5,6,7', '1,2,3,4,5,6,7'
CREATE PROCEDURE dbo.Get_All_Info
@status VARCHAR(MAX) = '1,2,3', 
@users VARCHAR(MAX) = '',
@projects VARCHAR(MAX) = ''
AS 
BEGIN

SET NOCOUNT ON
SET XACT_ABORT ON
SET ANSI_NULLS ON

SELECT		u.Id, 
					u.Username, 
					u.Email, 
					r.Name						AS RoleName, 
					t.Name						AS TeamName,
					p.Title						AS Project_Title,
					t2.Title					AS Task_Title,
					ut.EstimateHours,
					ut.UsedHours,
					COUNT(ut.TaskId)	AS Count_task,
					MAX(tr.TrackStart) AS TrackStart,
					MAX(tr.TrackEnd)	AS TrackEnd
FROM dbo.Users AS u
JOIN dbo.Roles AS r ON u.RoleId = r.Id
JOIN dbo.Teams AS t ON t.Id = u.TeamId
LEFT JOIN dbo.UserTasks AS ut ON ut.UserId = u.Id
LEFT JOIN dbo.Tasks AS t2 ON t2.Id = ut.TaskId
LEFT JOIN dbo.Projects AS p ON p.Id = t2.ProjectId
LEFT JOIN dbo.Trackers AS tr ON tr.TaskId = t.Id
														AND tr.UserId = u.Id
WHERE p.Id IN (SELECT * from string_split(@projects,','))
AND ut.StateId IN (SELECT * from string_split(@status,','))
AND u.Id IN (SELECT * from string_split(@users,','))
GROUP BY u.Id, 
					u.Username, 
					u.Email, 
					r.Name				, 
					t.Name				,
					p.Title				,
					t2.Title			,
					ut.EstimateHours,
					ut.UsedHours
					
					
END
GO
------------------------------------------------------------------------------------------------------------------------
--#endregion
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--#endregion



