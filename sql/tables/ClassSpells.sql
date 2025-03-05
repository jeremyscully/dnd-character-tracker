-- =============================================
-- ClassSpells.sql
-- Creates the ClassSpells table (junction table)
-- =============================================

USE DnDCharacterTracker;
GO

-- Drop table if it exists
IF OBJECT_ID('dbo.ClassSpells', 'U') IS NOT NULL
    DROP TABLE dbo.ClassSpells;
GO

-- Create ClassSpells table
CREATE TABLE dbo.ClassSpells
(
    ClassID INT NOT NULL,
    SpellID INT NOT NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_ClassSpells PRIMARY KEY (ClassID, SpellID),
    CONSTRAINT FK_ClassSpells_Classes FOREIGN KEY (ClassID) REFERENCES dbo.Classes(ClassID),
    CONSTRAINT FK_ClassSpells_Spells FOREIGN KEY (SpellID) REFERENCES dbo.Spells(SpellID)
);
GO

-- Add table description
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Junction table linking spells to the classes that can cast them.',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'ClassSpells';
GO

-- Add indexes
CREATE INDEX IX_ClassSpells_SpellID ON dbo.ClassSpells(SpellID);
GO

PRINT 'ClassSpells table created successfully.';
GO