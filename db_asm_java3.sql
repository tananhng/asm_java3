/* =========================
   TẠO DATABASE & DÙNG DB
   ========================= */
IF DB_ID(N'ABCNewsDB') IS NULL
    CREATE DATABASE ABCNewsDB;
GO
USE ABCNewsDB;
GO

/* =========================
   BẢNG USERS
   ========================= */
CREATE TABLE dbo.USERS (
    Id_Author  NVARCHAR(50)  NOT NULL PRIMARY KEY,
    [Password] NVARCHAR(100) NOT NULL,
    Fullname   NVARCHAR(100) NOT NULL,
    Birthday   DATE          NULL,
    Gender     BIT           NULL,   -- có thể NULL
    Mobile     NVARCHAR(20)  NULL,
    Email      NVARCHAR(100) NULL,
    [Role]     BIT           NOT NULL  -- 1=Admin, 0=Phóng viên
);
GO

/* =========================
   BẢNG CATEGORIES
   ========================= */
CREATE TABLE dbo.CATEGORIES (
    Id     NVARCHAR(50)   NOT NULL PRIMARY KEY,
    [Name] NVARCHAR(100)  NOT NULL
);
GO

/* =========================
   BẢNG NEWS
   ========================= */
CREATE TABLE dbo.NEWS (
    Id          INT            IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Title       NVARCHAR(200)  NOT NULL,
    [Content]   NVARCHAR(MAX)  NOT NULL,
    [Image]     NVARCHAR(255)  NULL,
    PostedDate  DATETIME       NOT NULL CONSTRAINT DF_NEWS_PostedDate DEFAULT (GETDATE()),
    ViewCount   INT            NOT NULL CONSTRAINT DF_NEWS_ViewCount DEFAULT (0),
    Home        BIT            NOT NULL CONSTRAINT DF_NEWS_Home DEFAULT (0),
    Id_Author   NVARCHAR(50)   NOT NULL,
    CategoryId  NVARCHAR(50)   NOT NULL,
    CONSTRAINT FK_NEWS_USERS       FOREIGN KEY (Id_Author)  REFERENCES dbo.USERS(Id_Author),
    CONSTRAINT FK_NEWS_CATEGORIES  FOREIGN KEY (CategoryId) REFERENCES dbo.CATEGORIES(Id)
);
GO

/* =========================
   BẢNG NEWSLETTERS
   ========================= */
CREATE TABLE dbo.NEWSLETTERS (
    Email     NVARCHAR(256) NOT NULL PRIMARY KEY,
    Enabled   BIT           NOT NULL CONSTRAINT DF_NEWSLETTERS_Enabled   DEFAULT (1),
    CreatedAt DATETIME      NOT NULL CONSTRAINT DF_NEWSLETTERS_CreatedAt DEFAULT (GETDATE())
);
GO

/* =========================
   DỮ LIỆU MẪU
   ========================= */

/* Users mẫu */
INSERT INTO dbo.USERS (Id_Author, [Password], Fullname, Birthday, Gender, Mobile, Email, [Role]) VALUES
(N'admin', N'123', N'Quản trị viên', '1995-01-01', 1, N'0900000000', N'admin@abcnews.vn', 1),
(N'user1', N'123', N'Phóng viên 1',  '2000-05-10', 0, N'0911111111', N'user1@abcnews.vn', 0);
GO

/* Categories mẫu */
INSERT INTO dbo.CATEGORIES (Id, [Name]) VALUES
(N'thoi-su',   N'Thời sự'),
(N'the-thao',  N'Thể thao'),
(N'cong-nghe', N'Công nghệ');
GO

/* News mẫu (Id tự tăng) */
INSERT INTO dbo.NEWS (Title, [Content], [Image], PostedDate, ViewCount, Home, Id_Author, CategoryId) VALUES
(N'Thời sự buổi sáng', N'Nội dung bài viết thời sự...',  N'assets/img/hero1.jpg', GETDATE(),  50, 1, N'admin', N'thoi-su'),
(N'Bóng đá cuối tuần', N'Nội dung bài viết thể thao...', N'assets/img/hero2.jpg', GETDATE(), 120, 1, N'user1', N'the-thao'),
(N'AI lên ngôi',       N'Nội dung bài viết công nghệ...',N'assets/img/hero3.jpg', GETDATE(),  75, 0, N'admin', N'cong-nghe');
GO

/* Newsletters mẫu */
INSERT INTO dbo.NEWSLETTERS (Email, Enabled) VALUES
(N'docgia1@example.com', 1),
(N'docgia2@example.com', 1);
GO
