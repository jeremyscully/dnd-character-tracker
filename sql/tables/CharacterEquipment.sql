-- =============================================
-- CharacterEquipment.sql
-- Creates the CharacterEquipment table
-- =============================================

USE DnDCharacterTracker;
GO

-- Drop table if it exists
IF OBJECT_ID('dbo.CharacterEquipment', 'U') IS NOT NULL
    DROP TABLE dbo.CharacterEquipment;
GO

-- Create CharacterEquipment table
CREATE TABLE dbo.CharacterEquipment
(
    CharacterEquipmentID INT IDENTITY(1,1) PRIMARY KEY,
    CharacterLevelID INT NOT NULL,
    EquipmentID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    IsEquipped BIT NOT NULL DEFAULT 0,
    IsAttuned BIT NOT NULL DEFAULT 0,
    Location NVARCHAR(50) NOT NULL DEFAULT 'Carried', -- Carried, Backpack, Bank, etc.
    Notes NVARCHAR(MAX) NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_CharacterEquipment_CharacterLevels FOREIGN KEY (CharacterLevelID) REFERENCES dbo.CharacterLevels(CharacterLevelID),
    CONSTRAINT FK_CharacterEquipment_Equipment FOREIGN KEY (EquipmentID) REFERENCES dbo.Equipment(EquipmentID)
);
GO

-- Add table description
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Contains the equipment and inventory for each character at each level.',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'CharacterEquipment';
GO

-- Add indexes
CREATE INDEX IX_CharacterEquipment_CharacterLevelID ON dbo.CharacterEquipment(CharacterLevelID);
CREATE INDEX IX_CharacterEquipment_EquipmentID ON dbo.CharacterEquipment(EquipmentID);
GO

PRINT 'CharacterEquipment table created successfully.';
GO