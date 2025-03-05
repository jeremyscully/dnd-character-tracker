-- =============================================
-- CharacterSkills.sql
-- Creates the CharacterSkills table
-- =============================================

USE DnDCharacterTracker;
GO

-- Drop table if it exists
IF OBJECT_ID('dbo.CharacterSkills', 'U') IS NOT NULL
    DROP TABLE dbo.CharacterSkills;
GO

-- First create Skills table if it doesn't exist
IF OBJECT_ID('dbo.Skills', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Skills
    (
        SkillID INT IDENTITY(1,1) PRIMARY KEY,
        Name NVARCHAR(50) NOT NULL,
        AbilityScore NVARCHAR(3) NOT NULL, -- STR, DEX, CON, INT, WIS, CHA
        Description NVARCHAR(MAX) NOT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        ModifiedDate DATETIME NOT NULL DEFAULT GETDATE()
    );
    
    -- Add table description
    EXEC sp_addextendedproperty 
        @name = N'MS_Description', 
        @value = N'Contains all skills in D&D 5e with their associated ability scores.',
        @level0type = N'SCHEMA', @level0name = N'dbo',
        @level1type = N'TABLE', @level1name = N'Skills';
    
    -- Add unique index
    CREATE UNIQUE INDEX IX_Skills_Name ON dbo.Skills(Name);
    
    PRINT 'Skills table created successfully.';
END
GO

-- Create CharacterSkills table
CREATE TABLE dbo.CharacterSkills
(
    CharacterSkillID INT IDENTITY(1,1) PRIMARY KEY,
    CharacterLevelID INT NOT NULL,
    SkillID INT NOT NULL,
    IsProficient BIT NOT NULL DEFAULT 0,
    HasExpertise BIT NOT NULL DEFAULT 0, -- Double proficiency bonus (Bards, Rogues)
    HasJackOfAllTrades BIT NOT NULL DEFAULT 0, -- Half proficiency bonus (Bards)
    Bonus INT NOT NULL DEFAULT 0, -- Additional bonus from feats, items, etc.
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_CharacterSkills_CharacterLevels FOREIGN KEY (CharacterLevelID) REFERENCES dbo.CharacterLevels(CharacterLevelID),
    CONSTRAINT FK_CharacterSkills_Skills FOREIGN KEY (SkillID) REFERENCES dbo.Skills(SkillID)
);
GO

-- Add table description
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Contains the skill proficiencies and bonuses for each character at each level.',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'CharacterSkills';
GO

-- Add indexes
CREATE INDEX IX_CharacterSkills_CharacterLevelID ON dbo.CharacterSkills(CharacterLevelID);
CREATE INDEX IX_CharacterSkills_SkillID ON dbo.CharacterSkills(SkillID);
CREATE UNIQUE INDEX IX_CharacterSkills_CharacterLevelID_SkillID ON dbo.CharacterSkills(CharacterLevelID, SkillID);
GO

PRINT 'CharacterSkills table created successfully.';
GO