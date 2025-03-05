-- =============================================
-- Races.sql
-- Creates the Races table
-- =============================================

USE DnDCharacterTracker;
GO

-- Drop table if it exists
IF OBJECT_ID('dbo.Races', 'U') IS NOT NULL
    DROP TABLE dbo.Races;
GO

-- Create Races table
CREATE TABLE dbo.Races
(
    RaceID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    Speed INT NOT NULL,
    Size NVARCHAR(20) NOT NULL,
    StrengthBonus INT NOT NULL DEFAULT 0,
    DexterityBonus INT NOT NULL DEFAULT 0,
    ConstitutionBonus INT NOT NULL DEFAULT 0,
    IntelligenceBonus INT NOT NULL DEFAULT 0,
    WisdomBonus INT NOT NULL DEFAULT 0,
    CharismaBonus INT NOT NULL DEFAULT 0,
    HasSubraces BIT NOT NULL DEFAULT 0,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Add table description
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Contains all playable races in D&D 5e with their base attributes and bonuses.',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Races';
GO

-- Add indexes
CREATE UNIQUE INDEX IX_Races_Name ON dbo.Races(Name);
GO

PRINT 'Races table created successfully.';
GO