-- =============================================
-- Subraces.sql
-- Creates the Subraces table
-- =============================================

USE DnDCharacterTracker;
GO

-- Drop table if it exists
IF OBJECT_ID('dbo.Subraces', 'U') IS NOT NULL
    DROP TABLE dbo.Subraces;
GO

-- Create Subraces table
CREATE TABLE dbo.Subraces
(
    SubraceID INT IDENTITY(1,1) PRIMARY KEY,
    RaceID INT NOT NULL,
    Name NVARCHAR(50) NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    StrengthBonus INT NOT NULL DEFAULT 0,
    DexterityBonus INT NOT NULL DEFAULT 0,
    ConstitutionBonus INT NOT NULL DEFAULT 0,
    IntelligenceBonus INT NOT NULL DEFAULT 0,
    WisdomBonus INT NOT NULL DEFAULT 0,
    CharismaBonus INT NOT NULL DEFAULT 0,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Subraces_Races FOREIGN KEY (RaceID) REFERENCES dbo.Races(RaceID)
);
GO

-- Add table description
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Contains all subraces for the main races in D&D 5e with their additional bonuses.',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Subraces';
GO

-- Add indexes
CREATE UNIQUE INDEX IX_Subraces_RaceID_Name ON dbo.Subraces(RaceID, Name);
GO

PRINT 'Subraces table created successfully.';
GO