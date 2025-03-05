-- =============================================
-- CharacterFeats.sql
-- Creates the CharacterFeats table
-- =============================================

USE DnDCharacterTracker;
GO

-- Drop table if it exists
IF OBJECT_ID('dbo.CharacterFeats', 'U') IS NOT NULL
    DROP TABLE dbo.CharacterFeats;
GO

-- Create CharacterFeats table
CREATE TABLE dbo.CharacterFeats
(
    CharacterFeatID INT IDENTITY(1,1) PRIMARY KEY,
    CharacterLevelID INT NOT NULL,
    FeatID INT NOT NULL,
    Notes NVARCHAR(MAX) NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_CharacterFeats_CharacterLevels FOREIGN KEY (CharacterLevelID) REFERENCES dbo.CharacterLevels(CharacterLevelID),
    CONSTRAINT FK_CharacterFeats_Feats FOREIGN KEY (FeatID) REFERENCES dbo.Feats(FeatID)
);
GO

-- Add table description
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Contains the feats for each character at each level.',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'CharacterFeats';
GO

-- Add indexes
CREATE INDEX IX_CharacterFeats_CharacterLevelID ON dbo.CharacterFeats(CharacterLevelID);
CREATE INDEX IX_CharacterFeats_FeatID ON dbo.CharacterFeats(FeatID);
CREATE UNIQUE INDEX IX_CharacterFeats_CharacterLevelID_FeatID ON dbo.CharacterFeats(CharacterLevelID, FeatID);
GO

PRINT 'CharacterFeats table created successfully.';
GO