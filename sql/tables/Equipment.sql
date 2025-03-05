-- =============================================
-- Equipment.sql
-- Creates the Equipment table
-- =============================================

USE DnDCharacterTracker;
GO

-- Drop table if it exists
IF OBJECT_ID('dbo.Equipment', 'U') IS NOT NULL
    DROP TABLE dbo.Equipment;
GO

-- Create Equipment table
CREATE TABLE dbo.Equipment
(
    EquipmentID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Type NVARCHAR(50) NOT NULL, -- Weapon, Armor, Adventuring Gear, Tool, etc.
    Subtype NVARCHAR(50) NULL, -- Simple Weapon, Martial Weapon, Light Armor, etc.
    Cost DECIMAL(10, 2) NOT NULL,
    CostUnit NVARCHAR(2) NOT NULL DEFAULT 'gp', -- cp, sp, gp, pp
    Weight DECIMAL(10, 2) NULL,
    Description NVARCHAR(MAX) NULL,
    Properties NVARCHAR(255) NULL, -- For weapons: Finesse, Heavy, Light, etc.
    Damage NVARCHAR(50) NULL, -- For weapons: 1d6, 2d6, etc.
    DamageType NVARCHAR(50) NULL, -- For weapons: Slashing, Piercing, etc.
    ArmorClass NVARCHAR(50) NULL, -- For armor: 11 + Dex modifier, etc.
    StrengthRequirement INT NULL, -- For armor
    StealthDisadvantage BIT NULL, -- For armor
    Source NVARCHAR(100) NOT NULL DEFAULT 'Player''s Handbook',
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Add table description
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = N'Contains all equipment items in D&D 5e including weapons, armor, and adventuring gear.',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'Equipment';
GO

-- Add indexes
CREATE UNIQUE INDEX IX_Equipment_Name ON dbo.Equipment(Name);
CREATE INDEX IX_Equipment_Type ON dbo.Equipment(Type);
CREATE INDEX IX_Equipment_Subtype ON dbo.Equipment(Subtype) WHERE Subtype IS NOT NULL;
GO

PRINT 'Equipment table created successfully.';
GO