-- =============================================
-- Subclasses.sql
-- Creates the Subclasses table
-- =============================================

USE DnDCharacterTracker;
GO

-- Drop table if it exists
IF OBJECT_ID('dbo.Subclasses', 'U') IS NOT NULL
    DROP TABLE dbo.Subclasses;
GO

-- Create Subclasses table
CREATE TABLE dbo.Subclasses
(
    SubclassID INT IDENTITY(1,1) PRIMARY KEY,
    ClassID INT NOT NULL,
    Name NVARCHAR(50) NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    Source NVARCHAR(100) NOT NULL DEFAULT 'Player''s Handbook',
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Subclasses_Classes FOREIGN KEY (ClassID) REFERENCES dbo.Classes(ClassID)
);
GO

-- Add table description
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Contains all subclasses for the main classes in D&D 5e.',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Subclasses';
GO

-- Add indexes
CREATE UNIQUE INDEX IX_Subclasses_ClassID_Name ON dbo.Subclasses(ClassID, Name);
GO

PRINT 'Subclasses table created successfully.';
GO