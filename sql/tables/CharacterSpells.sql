-- =============================================
-- CharacterSpells.sql
-- Creates the CharacterSpells table
-- =============================================

USE DnDCharacterTracker;
GO

-- Drop table if it exists
IF OBJECT_ID('dbo.CharacterSpells', 'U') IS NOT NULL
    DROP TABLE dbo.CharacterSpells;
GO

-- Create CharacterSpells table
CREATE TABLE dbo.CharacterSpells
(
    CharacterSpellID INT IDENTITY(1,1) PRIMARY KEY,
    CharacterLevelID INT NOT NULL,
    SpellID INT NOT NULL,
    IsKnown BIT NOT NULL DEFAULT 1, -- For classes that know spells (Bard, Sorcerer, etc.)
    IsPrepared BIT NOT NULL DEFAULT 0, -- For classes that prepare spells (Cleric, Wizard, etc.)
    InSpellbook BIT NOT NULL DEFAULT 0, -- For Wizards
    Notes NVARCHAR(MAX) NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_CharacterSpells_CharacterLevels FOREIGN KEY (CharacterLevelID) REFERENCES dbo.CharacterLevels(CharacterLevelID),
    CONSTRAINT FK_CharacterSpells_Spells FOREIGN KEY (SpellID) REFERENCES dbo.Spells(SpellID)
);
GO

-- Add table description
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Contains the spells known, prepared, and in spellbooks for each character at each level.',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'CharacterSpells';
GO

-- Add indexes
CREATE INDEX IX_CharacterSpells_CharacterLevelID ON dbo.CharacterSpells(CharacterLevelID);
CREATE INDEX IX_CharacterSpells_SpellID ON dbo.CharacterSpells(SpellID);
CREATE UNIQUE INDEX IX_CharacterSpells_CharacterLevelID_SpellID ON dbo.CharacterSpells(CharacterLevelID, SpellID);
GO

PRINT 'CharacterSpells table created successfully.';
GO