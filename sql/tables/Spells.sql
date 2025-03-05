-- =============================================
-- Spells.sql
-- Creates the Spells table
-- =============================================

USE DnDCharacterTracker;
GO

-- Drop table if it exists
IF OBJECT_ID('dbo.Spells', 'U') IS NOT NULL
    DROP TABLE dbo.Spells;
GO

-- Create Spells table
CREATE TABLE dbo.Spells
(
    SpellID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Level INT NOT NULL, -- 0 for cantrips, 1-9 for other spells
    School NVARCHAR(50) NOT NULL, -- Abjuration, Conjuration, etc.
    CastingTime NVARCHAR(50) NOT NULL,
    Range NVARCHAR(50) NOT NULL,
    Components NVARCHAR(100) NOT NULL, -- V, S, M (material components)
    Duration NVARCHAR(50) NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    HigherLevelDescription NVARCHAR(MAX) NULL,
    Ritual BIT NOT NULL DEFAULT 0,
    Concentration BIT NOT NULL DEFAULT 0,
    Source NVARCHAR(100) NOT NULL DEFAULT 'Player''s Handbook',
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Add table description
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Contains all spells in D&D 5e with their descriptions and properties.',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Spells';
GO

-- Add indexes
CREATE UNIQUE INDEX IX_Spells_Name ON dbo.Spells(Name);
CREATE INDEX IX_Spells_Level ON dbo.Spells(Level);
CREATE INDEX IX_Spells_School ON dbo.Spells(School);
GO

PRINT 'Spells table created successfully.';
GO