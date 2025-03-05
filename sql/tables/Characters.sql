-- =============================================
-- Characters.sql
-- Creates the Characters table
-- =============================================

USE DnDCharacterTracker;
GO

-- Drop table if it exists
IF OBJECT_ID('dbo.Characters', 'U') IS NOT NULL
    DROP TABLE dbo.Characters;
GO

-- Create Characters table
CREATE TABLE dbo.Characters
(
    CharacterID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    PlayerName NVARCHAR(100) NOT NULL,
    RaceID INT NOT NULL,
    SubraceID INT NULL,
    BackgroundID INT NOT NULL,
    Alignment NVARCHAR(20) NOT NULL,
    Gender NVARCHAR(20) NULL,
    Age INT NULL,
    Height NVARCHAR(20) NULL,
    Weight NVARCHAR(20) NULL,
    EyeColor NVARCHAR(20) NULL,
    HairColor NVARCHAR(20) NULL,
    SkinColor NVARCHAR(20) NULL,
    Appearance NVARCHAR(MAX) NULL,
    Personality NVARCHAR(MAX) NULL,
    Ideals NVARCHAR(MAX) NULL,
    Bonds NVARCHAR(MAX) NULL,
    Flaws NVARCHAR(MAX) NULL,
    Backstory NVARCHAR(MAX) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Characters_Races FOREIGN KEY (RaceID) REFERENCES dbo.Races(RaceID),
    CONSTRAINT FK_Characters_Subraces FOREIGN KEY (SubraceID) REFERENCES dbo.Subraces(SubraceID),
    CONSTRAINT FK_Characters_Backgrounds FOREIGN KEY (BackgroundID) REFERENCES dbo.Backgrounds(BackgroundID)
);
GO

-- Add table description
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Contains the base information for all characters.',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Characters';
GO

-- Add indexes
CREATE INDEX IX_Characters_RaceID ON dbo.Characters(RaceID);
CREATE INDEX IX_Characters_SubraceID ON dbo.Characters(SubraceID) WHERE SubraceID IS NOT NULL;
CREATE INDEX IX_Characters_BackgroundID ON dbo.Characters(BackgroundID);
CREATE INDEX IX_Characters_PlayerName ON dbo.Characters(PlayerName);
GO

PRINT 'Characters table created successfully.';
GO