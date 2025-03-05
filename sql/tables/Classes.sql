-- =============================================
-- Classes.sql
-- Creates the Classes table
-- =============================================

USE DnDCharacterTracker;
GO

-- Drop table if it exists
IF OBJECT_ID('dbo.Classes', 'U') IS NOT NULL
    DROP TABLE dbo.Classes;
GO

-- Create Classes table
CREATE TABLE dbo.Classes
(
    ClassID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    HitDie INT NOT NULL, -- e.g., 8 for d8, 10 for d10, etc.
    PrimaryAbility NVARCHAR(50) NOT NULL,
    SavingThrowProficiency1 NVARCHAR(20) NOT NULL,
    SavingThrowProficiency2 NVARCHAR(20) NOT NULL,
    SpellcastingAbility NVARCHAR(20) NULL, -- NULL if not a spellcaster
    SubclassLevelAvailability INT NOT NULL, -- Level at which subclass is chosen
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Add table description
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Contains all playable classes in D&D 5e with their core attributes.',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Classes';
GO

-- Add indexes
CREATE UNIQUE INDEX IX_Classes_Name ON dbo.Classes(Name);
GO

PRINT 'Classes table created successfully.';
GO