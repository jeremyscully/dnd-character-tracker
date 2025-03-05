-- =============================================
-- CharacterClasses.sql
-- Creates the CharacterClasses table
-- =============================================

USE DnDCharacterTracker;
GO

-- Drop table if it exists
IF OBJECT_ID('dbo.CharacterClasses', 'U') IS NOT NULL
    DROP TABLE dbo.CharacterClasses;
GO

-- Create CharacterClasses table
CREATE TABLE dbo.CharacterClasses
(
    CharacterClassID INT IDENTITY(1,1) PRIMARY KEY,
    CharacterLevelID INT NOT NULL,
    ClassID INT NOT NULL,
    SubclassID INT NULL,
    ClassLevel INT NOT NULL, -- Level in this specific class
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_CharacterClasses_CharacterLevels FOREIGN KEY (CharacterLevelID) REFERENCES dbo.CharacterLevels(CharacterLevelID),
    CONSTRAINT FK_CharacterClasses_Classes FOREIGN KEY (ClassID) REFERENCES dbo.Classes(ClassID),
    CONSTRAINT FK_CharacterClasses_Subclasses FOREIGN KEY (SubclassID) REFERENCES dbo.Subclasses(SubclassID)
);
GO

-- Add table description
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Contains the classes and subclasses for each character at each level, supporting multiclassing.',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'CharacterClasses';
GO

-- Add indexes
CREATE INDEX IX_CharacterClasses_CharacterLevelID ON dbo.CharacterClasses(CharacterLevelID);
CREATE INDEX IX_CharacterClasses_ClassID ON dbo.CharacterClasses(ClassID);
CREATE INDEX IX_CharacterClasses_SubclassID ON dbo.CharacterClasses(SubclassID) WHERE SubclassID IS NOT NULL;
CREATE UNIQUE INDEX IX_CharacterClasses_CharacterLevelID_ClassID ON dbo.CharacterClasses(CharacterLevelID, ClassID);
GO

PRINT 'CharacterClasses table created successfully.';
GO