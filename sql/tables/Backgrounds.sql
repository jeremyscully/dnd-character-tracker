-- =============================================
-- Backgrounds.sql
-- Creates the Backgrounds table
-- =============================================

USE DnDCharacterTracker;
GO

-- Drop table if it exists
IF OBJECT_ID('dbo.Backgrounds', 'U') IS NOT NULL
    DROP TABLE dbo.Backgrounds;
GO

-- Create Backgrounds table
CREATE TABLE dbo.Backgrounds
(
    BackgroundID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    SkillProficiency1 NVARCHAR(50) NOT NULL,
    SkillProficiency2 NVARCHAR(50) NOT NULL,
    ToolProficiencies NVARCHAR(255) NULL,
    Languages NVARCHAR(255) NULL,
    Equipment NVARCHAR(MAX) NOT NULL,
    Feature NVARCHAR(100) NOT NULL,
    FeatureDescription NVARCHAR(MAX) NOT NULL,
    SuggestedCharacteristics NVARCHAR(MAX) NULL,
    Source NVARCHAR(100) NOT NULL DEFAULT 'Player''s Handbook',
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Add table description
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Contains all character backgrounds in D&D 5e with their features and proficiencies.',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Backgrounds';
GO

-- Add indexes
CREATE UNIQUE INDEX IX_Backgrounds_Name ON dbo.Backgrounds(Name);
GO

PRINT 'Backgrounds table created successfully.';
GO