-- =============================================
-- Feats.sql
-- Creates the Feats table
-- =============================================

USE DnDCharacterTracker;
GO

-- Drop table if it exists
IF OBJECT_ID('dbo.Feats', 'U') IS NOT NULL
    DROP TABLE dbo.Feats;
GO

-- Create Feats table
CREATE TABLE dbo.Feats
(
    FeatID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    Prerequisites NVARCHAR(255) NULL,
    AbilityScoreIncrease NVARCHAR(100) NULL, -- e.g., "STR +1" or "Choose one: DEX +1, WIS +1"
    Source NVARCHAR(100) NOT NULL DEFAULT 'Player''s Handbook',
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Add table description
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Contains all feats in D&D 5e with their descriptions and prerequisites.',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Feats';
GO

-- Add indexes
CREATE UNIQUE INDEX IX_Feats_Name ON dbo.Feats(Name);
GO

PRINT 'Feats table created successfully.';
GO