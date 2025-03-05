-- =============================================
-- CharacterLevels.sql
-- Creates the CharacterLevels table
-- =============================================

USE DnDCharacterTracker;
GO

-- Drop table if it exists
IF OBJECT_ID('dbo.CharacterLevels', 'U') IS NOT NULL
    DROP TABLE dbo.CharacterLevels;
GO

-- Create CharacterLevels table
CREATE TABLE dbo.CharacterLevels
(
    CharacterLevelID INT IDENTITY(1,1) PRIMARY KEY,
    CharacterID INT NOT NULL,
    Level INT NOT NULL, -- Total character level
    ExperiencePoints INT NOT NULL,
    HitPoints INT NOT NULL,
    MaxHitPoints INT NOT NULL,
    TemporaryHitPoints INT NOT NULL DEFAULT 0,
    Strength INT NOT NULL,
    Dexterity INT NOT NULL,
    Constitution INT NOT NULL,
    Intelligence INT NOT NULL,
    Wisdom INT NOT NULL,
    Charisma INT NOT NULL,
    Inspiration BIT NOT NULL DEFAULT 0,
    ProficiencyBonus INT NOT NULL,
    ArmorClass INT NOT NULL,
    Initiative INT NOT NULL,
    Speed INT NOT NULL,
    CurrentHitDice INT NOT NULL,
    MaxHitDice INT NOT NULL,
    DeathSaveSuccesses INT NOT NULL DEFAULT 0,
    DeathSaveFailures INT NOT NULL DEFAULT 0,
    Copper INT NOT NULL DEFAULT 0,
    Silver INT NOT NULL DEFAULT 0,
    Electrum INT NOT NULL DEFAULT 0,
    Gold INT NOT NULL DEFAULT 0,
    Platinum INT NOT NULL DEFAULT 0,
    Notes NVARCHAR(MAX) NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_CharacterLevels_Characters FOREIGN KEY (CharacterID) REFERENCES dbo.Characters(CharacterID),
    CONSTRAINT UQ_CharacterLevels_CharacterID_Level UNIQUE (CharacterID, Level)
);
GO

-- Add table description
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Contains character information at each level, allowing for tracking progression over time.',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'CharacterLevels';
GO

-- Add indexes
CREATE INDEX IX_CharacterLevels_CharacterID ON dbo.CharacterLevels(CharacterID);
GO

PRINT 'CharacterLevels table created successfully.';
GO